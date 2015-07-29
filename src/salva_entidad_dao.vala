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

public abstract class Salva.EntidadDAO : GLib.Object {

  protected abstract string[] get_propiedades ();

  protected abstract string get_nombre_tabla ();

  protected abstract string get_columnas_tabla ();

  protected abstract Type get_tipo_entidad ();

  public abstract void set_db ( Salva.BaseDeDatos db );

  protected abstract Salva.BaseDeDatos get_db ();

  public void insertar ( Salva.Entidad entidad ) {
    Salva.BaseDeDatos db = get_db ();
    db.insert ( get_nombre_tabla (), get_columnas_tabla (), entidad, get_tipo_entidad () );
  }

  public void borrar ( Salva.Entidad entidad ) {
    Salva.BaseDeDatos db = get_db ();
    db.delet ( get_nombre_tabla (), entidad );
  }

  public void actualizar ( Salva.Entidad entidad ) {
    Salva.BaseDeDatos db = get_db ();
    db.update ( get_nombre_tabla (), get_columnas_tabla (), entidad, get_tipo_entidad () );
  }

  public Array<Salva.Entidad> get_todos () {
    Salva.BaseDeDatos db = get_db ();
    return db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad () );
  }

  public Array<Salva.Entidad> get_todos_segun_condicion ( string condicion ) {
    Salva.BaseDeDatos db = get_db ();
    return db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad (), condicion );
  }

  public Array<Salva.Entidad> get_entidades_relacionadas ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada ) {
    string nombre_tabla = get_nombre_tabla ();
    string nombre_tabla_sin_s = nombre_tabla.substring ( 0, ( nombre_tabla.length - 1 ) );
    string condicion_join = nombre_tabla_sin_s + "_rowid=" + entidad.id.to_string();

    return dao_entidad_relacionada.get_todos_segun_condicion ( condicion_join );
  }

  public void borrar_entidades_relacionadas ( Salva.Entidad entidad, Salva.EntidadDAO dao_entidad_relacionada ) {
    Array<Salva.Entidad> entidades_relacionadas = get_entidades_relacionadas ( entidad, dao_entidad_relacionada );

    stdout.printf ( "Se borraran %u entidades relacionadas\n", entidades_relacionadas.length );
    for ( int i = 0; i < entidades_relacionadas.length; i++ ) {
      Salva.Entidad entidad_a_borrar = entidades_relacionadas.index (i);
      dao_entidad_relacionada.borrar ( entidad_a_borrar );
    }
  }
}
