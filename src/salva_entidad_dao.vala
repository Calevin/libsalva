/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * salva_entidad_dao.vala
 * Copyright (C) 2015 Sebastian Barreto <sebastian.e.barreto@gmail.com>
 *
 * libsalva is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * libsalva is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Salva;

private const string log_domain_entidad_dao = "Salva.EntidadDAO";

public abstract class Salva.EntidadDAO : GLib.Object {

  protected Salva.IBaseDeDatos _db;

  protected abstract string[] get_propiedades ();

  protected abstract string get_nombre_tabla ();

  protected abstract string get_columnas_tabla ();

  protected abstract Type get_tipo_entidad ();

  protected virtual HashTable<string, string>? get_relaciones_m2m () {
    return null;
  }

  protected EntidadDAO ( Salva.IBaseDeDatos db ) {
    this._db = db;
  }

  public void insertar ( Salva.Entidad entidad ) throws BaseDeDatosError {
    this._db.insert ( get_nombre_tabla (), get_columnas_tabla (), entidad );
  }

  public void borrar ( Salva.Entidad entidad ) throws BaseDeDatosError {
    this._db.delet ( get_nombre_tabla (), entidad );
  }

  public void actualizar ( Salva.Entidad entidad ) throws BaseDeDatosError {
    this._db.update ( get_nombre_tabla (), get_columnas_tabla (), entidad );
  }

  public Array<Salva.Entidad> get_todos () throws BaseDeDatosError {
    return this._db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad () );
  }

  public Array<Salva.Entidad> get_todos_segun_condicion ( string condicion )
  throws BaseDeDatosError
  requires ( condicion != "")
  {
    return this._db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad (), condicion );
  }

  public Array<Salva.Entidad> get_entidades_relacionadas ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada ) throws BaseDeDatosError {
    string tabla_join_correspondiente = get_tabla_join_correspondiente ( dao_entidad_relacionada.get_nombre_tabla () );

    if ( tabla_join_correspondiente != null ) {
      //SI ES UNA RELACION m2m se usa la tabla join correspondiente
      return get_entidades_relacionadas_muchos_a_muchos ( entidad, dao_entidad_relacionada, tabla_join_correspondiente);
    } else {
      return get_entidades_relacionadas_uno_a_muchos (entidad, dao_entidad_relacionada);
    }
  }

  public void borrar_entidades_relacionadas ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada ) throws BaseDeDatosError {
    Array<Salva.Entidad> entidades_relacionadas = get_entidades_relacionadas ( entidad, dao_entidad_relacionada );

    GLib.log ( log_domain_entidad_dao, GLib.LogLevelFlags.LEVEL_MESSAGE, "Se borraran %u entidades relacionadas\n", entidades_relacionadas.length );
    for ( int i = 0; i < entidades_relacionadas.length; i++ ) {
      Salva.Entidad entidad_a_borrar = entidades_relacionadas.index (i);
      dao_entidad_relacionada.borrar ( entidad_a_borrar );
    }
  }

  private Array<Salva.Entidad> get_entidades_relacionadas_uno_a_muchos ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada ) throws BaseDeDatosError {
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string condicion_join = nombre_tabla_sin_s + "_rowid=" + entidad.id.to_string();

    return dao_entidad_relacionada.get_todos_segun_condicion ( condicion_join );
  }

  private Array<Salva.Entidad> get_entidades_relacionadas_muchos_a_muchos ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada, string nombre_tabla_join) throws BaseDeDatosError {
    string nombre_tabla_relacionada_sin_s = this.quitar_letra_final ( dao_entidad_relacionada.get_nombre_tabla () );
    string columna_id = nombre_tabla_relacionada_sin_s + "_rowid";
    string[] propiedad_id = {"id"};
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string condicion_join = nombre_tabla_sin_s + "_rowid=" + entidad.id.to_string();

    Array<Salva.Entidad> entidades_relacionadas = this._db.select( nombre_tabla_join, columna_id,
      propiedad_id, dao_entidad_relacionada.get_tipo_entidad (), condicion_join );

    string condicion_in_ids = "rowid IN (" + this.listar_ids ( entidades_relacionadas ) + ")";

    return dao_entidad_relacionada.get_todos_segun_condicion ( condicion_in_ids );
  }

  public void guardar_relacion ( Salva.Entidad entidad, Salva.Entidad entidad_relacionada, Salva.EntidadDAO dao_entidad_relacionada ) throws BaseDeDatosError {
    string tabla_join_correspondiente = get_tabla_join_correspondiente ( dao_entidad_relacionada.get_nombre_tabla () );

    if ( tabla_join_correspondiente != null ) {
      //SI ES UNA RELACION m2m el insert se relizara en la tabla join
      this.guardar_relacion_muchos_a_muchos ( entidad, entidad_relacionada, dao_entidad_relacionada.get_nombre_tabla (), tabla_join_correspondiente);
    } else {
      this.guardar_relacion_uno_a_muchos ( entidad, entidad_relacionada, dao_entidad_relacionada.get_nombre_tabla () );
    }
  }

  private void guardar_relacion_uno_a_muchos ( Salva.Entidad entidad, Salva.Entidad entidad_relacionada,  string tabla_entidad_relacionada ) throws BaseDeDatosError {
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string set_valor = nombre_tabla_sin_s + "_rowid=" + entidad.id.to_string();
    string condicion = "rowid="+ entidad_relacionada.id.to_string();

    entidad_relacionada.set_property ( nombre_tabla_sin_s + "_rowid", entidad.id );

    this._db.ejecutar_query ("UPDATE " + tabla_entidad_relacionada + " SET " + set_valor + " WHERE " + condicion);
  }

  private void guardar_relacion_muchos_a_muchos ( Salva.Entidad entidad, Salva.Entidad entidad_relacionada, string nombre_tabla_entidad_relacionada, string tabla_join_correspondiente ) throws BaseDeDatosError {
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string nombre_tabla_relacionada_sin_s = this.quitar_letra_final ( nombre_tabla_entidad_relacionada );

    string nombre_columnas = "(" + nombre_tabla_sin_s + "_rowid," + nombre_tabla_relacionada_sin_s + "_rowid)";
    string valores = "(" + entidad.id.to_string() + ", " + entidad_relacionada.id.to_string() + ")";

    this._db.ejecutar_query ("INSERT INTO " + tabla_join_correspondiente + " " + nombre_columnas + " VALUES " + valores);
  }

  public void borrar_relacion ( Salva.Entidad entidad, Salva.Entidad entidad_relacionada, Salva.EntidadDAO dao_entidad_relacionada ) throws BaseDeDatosError {
    string tabla_join_correspondiente = get_tabla_join_correspondiente ( dao_entidad_relacionada.get_nombre_tabla () );

    if ( tabla_join_correspondiente != null ) {
      //SI ES UNA RELACION m2m el insert se relizara en la tabla join
      this.borrar_relacion_muchos_a_muchos ( entidad, entidad_relacionada, dao_entidad_relacionada.get_nombre_tabla (), tabla_join_correspondiente);
    } else {
      this.borrar_relacion_uno_a_muchos ( entidad_relacionada, dao_entidad_relacionada.get_nombre_tabla () );
    }
  }

  private void borrar_relacion_uno_a_muchos ( Salva.Entidad entidad_relacionada,  string tabla_entidad_relacionada ) throws BaseDeDatosError {
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string set_valor = nombre_tabla_sin_s + "_rowid=0";
    string condicion = "rowid="+ entidad_relacionada.id.to_string();

    entidad_relacionada.set_property ( nombre_tabla_sin_s + "_rowid", 0 );

    this._db.ejecutar_query ("UPDATE " + tabla_entidad_relacionada + " SET " + set_valor + " WHERE " + condicion);
  }

  private void borrar_relacion_muchos_a_muchos ( Salva.Entidad entidad, Salva.Entidad entidad_relacionada, string nombre_tabla_entidad_relacionada, string tabla_join_correspondiente ) throws BaseDeDatosError {
    string nombre_tabla_sin_s = this.quitar_letra_final ( this.get_nombre_tabla () );
    string nombre_tabla_relacionada_sin_s = this.quitar_letra_final ( nombre_tabla_entidad_relacionada );

    string columna_y_valor_id_entidad = nombre_tabla_sin_s + "_rowid=" + entidad.id.to_string();
    string columna_y_valor_id_entidad_relacionada = nombre_tabla_relacionada_sin_s + "_rowid=" + entidad_relacionada.id.to_string();

    this._db.ejecutar_query ("DELETE FROM " + tabla_join_correspondiente + " WHERE " + columna_y_valor_id_entidad + " AND " + columna_y_valor_id_entidad_relacionada );
  }

  private string quitar_letra_final ( string palabra ) {
    string palabra_sin_letra_final = palabra.substring ( 0, ( palabra.length - 1 ) );
    return palabra_sin_letra_final;
  }

  private string listar_ids ( Array<Salva.Entidad> entidades ) {
    string lista_ids = "";
    Salva.Entidad row_entidad;
    for (int i = 0; i < entidades.length; i++) {
      row_entidad = entidades.index (i);

      lista_ids = lista_ids + row_entidad.id.to_string ();

      if ( ( i + 1 ) < entidades.length ) {
        lista_ids = lista_ids + ",";
      }
    }

    return lista_ids;
  }

  private string? get_tabla_join_correspondiente ( string nombre_tabla ) {
    string tabla_m2m_correspondiente = null;

    if ( get_relaciones_m2m () != null ) {
      tabla_m2m_correspondiente = get_relaciones_m2m ().get ( nombre_tabla );
    }

    return tabla_m2m_correspondiente;
  }
}
