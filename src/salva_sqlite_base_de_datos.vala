/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * salva_base_de_datos.vala
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

private const string log_domain_base_de_datos = "Salva.SQLiteBaseDeDatos";

public class Salva.SQLiteBaseDeDatos : Salva.IBaseDeDatos, GLib.Object {
  public string base_datos { public get; public set; }
  private Sqlite.Database db;
  public bool pragma_foreign_key { public get; public set; default = false; }

  public SQLiteBaseDeDatos ( string base_datos )
  requires ( base_datos != "" )
  {
    this._base_datos = base_datos;
  }

  public SQLiteBaseDeDatos.SQLiteBaseDeDatos_foreign_keys_activas ( string base_datos )
  requires ( base_datos != "" )
  {
    this._base_datos = base_datos;
    this._pragma_foreign_key = true;
  }

  protected bool conectar () throws BaseDeDatosError {
    bool conexion_satisfactoria = false;

    GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_MESSAGE, "Base de datos a conectarse URI: %s.", this.base_datos);

    int rc = Sqlite.Database.open ( this.base_datos, out this.db );

    conexion_satisfactoria = (rc == Sqlite.OK);
    if ( !conexion_satisfactoria ) {
      string error_mensaje = "No se pudo abrir la base de datos. Result Code: %d. Mesaje de Error: %s.".printf ( rc, this.db.errmsg () );

      GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
      throw new BaseDeDatosError.OPEN_FAIL ( error_mensaje );
    }

    return conexion_satisfactoria;
  }

  public void insert ( string tabla, owned string columnas, Salva.Entidad entidad)
  throws BaseDeDatosError
  requires ( tabla != "" && columnas != "")
  {
    string valores = "";
    Array<string> valores_array = entidad.valores_para_query ();

    //Si el ID no fue asignado se suprime del insert
    if ( entidad.id == 0 ) {
        columnas = columnas.replace ("rowid, ", "" );
        valores_array.remove_index (0);
    }

    for (int i = 0; i < valores_array.length; i++) {
      valores = valores + valores_array.index (i);
      if ((i + 1) < valores_array.length) {
        valores = valores + ",";
      }
    }
    string sql_query = "INSERT INTO " + tabla + " (" + columnas + ") VALUES (" + valores + ")";
    this.ejecutar_query ( sql_query );
  }

  public void delet ( string tabla, Salva.Entidad entidad)
  throws BaseDeDatosError
  requires ( tabla != "" )
  {
    string where = "";

    //Obtengo el valor del atributo ID
    GLib.Value propiedad_id_value = GLib.Value ( typeof ( uint ) );
    entidad.get_property ( "id", ref propiedad_id_value );
    //Casteo el id a string para agregarlo a la query
    GLib.Value id_value_string = GLib.Value ( typeof( string ) );
    propiedad_id_value.transform ( ref id_value_string );

    //Agrego el valor del id a la sentencia WHERE
    where = "rowid=" + id_value_string.get_string ();

    string sql_query = "DELETE FROM " + tabla + " WHERE " + where;
    this.ejecutar_query ( sql_query );
  }

  public void update ( string tabla, string columnas, Salva.Entidad entidad )
  throws BaseDeDatosError
  requires ( tabla != "" && columnas != "")
  {
    string valores = "";
    string[] columnas_array = columnas.split_set ( "," );
    string where = "";

    Array<string> valores_array = entidad.valores_para_query ();
    //Se considera el primer atributo como el ID
    where = "rowid = " + valores_array.index ( 0 );

    //Se recorren los atributos de la clase
    //Se obtienen los valores de la instancia
    for (int i = 1; i < valores_array.length; i++) {
      //Se agregan los valores al SET
      //Nombre de la columna seguido de "=" seguido del valor
      valores = valores + columnas_array[i] + "=" + valores_array.index (i);

      //Agrego una coma despues del valor, a menos que sea el ultimo valor
      if ( ( i + 1 ) < valores_array.length ) {
        valores = valores + ",";
      }
    }

    string sql_query = "UPDATE " + tabla + " SET" + valores + " WHERE " + where;
    this.ejecutar_query ( sql_query );
  }

  public Array<Salva.Entidad> select ( string tabla, string campos, string[] propiedades, Type tipo_entidad,
                                       string condicion = "")
  throws BaseDeDatosError
  requires ( tabla != "" && campos != "")
  requires ( propiedades.length > 0 )
  requires ( tipo_entidad.is_a ( typeof ( Salva.Entidad ) ) )
  {
    int rc;
    Array<Salva.Entidad> entidades = new Array<Salva.Entidad> ();

    if ( this.conectar () ) {
      string sql_query = "SELECT " + campos + " FROM " + tabla + this.armar_condicion ( condicion );
      GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_MESSAGE, "Query a ejecutar: %s.", sql_query);

      Sqlite.Statement stmt;
      rc = this.db.prepare_v2 ( sql_query, -1, out stmt, null );

      if ( rc == Sqlite.ERROR ) {
        string error_mensaje = "Error al ejecutar la query: %s. Result Code: %d. Mesaje de Error: %s.".printf ( sql_query, rc, this.db.errmsg () );

        GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
        throw new BaseDeDatosError.EXEC_QUERY ( error_mensaje );
      }

      int cantidad_columnas = stmt.column_count ();

      do {
        // Se instancia un objeto del tipo a retornar
        var entidad = Object.new ( tipo_entidad );
        rc = stmt.step ();
        switch ( rc  ) {
          case Sqlite.DONE:
            break;
          case Sqlite.ROW:
            for ( int j = 0; j < cantidad_columnas; j++ ) {

              int columna_tipo = stmt.column_type ( j );
              //Se seteo el valor de la columna a su correspondiente propiedad en la instancia
              //TODO completar el switch
              switch (columna_tipo) {
                case Sqlite.INTEGER:
                  entidad.set_property (propiedades[j], stmt.column_int ( j ));
                break;
                case Sqlite.TEXT:
                  entidad.set_property (propiedades[j], stmt.column_text ( j ));
                break;
                case Sqlite.FLOAT:
                  entidad.set_property (propiedades[j], stmt.column_double ( j ));
                break;
                default :
                  //TODO revisar el comportamiento del dato no soportado
                  string error_mensaje = "Tipo de dato no soportado. Codigo Tipo: %u.".printf ( columna_tipo );

                  GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
                  throw new BaseDeDatosError.PARSER_RESULT ( error_mensaje );
                break;
              }
            }

            entidades.append_val ( entidad as Salva.Entidad );
            break;
          default:
            string error_mensaje = "Error parseando respuesta de la base de datos. Codigo Respuesta: %u.".printf ( rc );

            GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
            throw new BaseDeDatosError.PARSER_RESULT ( error_mensaje );
            break;
        }
      } while ( rc == Sqlite.ROW );
    }
    return entidades;
  }

  public bool ejecutar_query ( string sql_query )
  throws BaseDeDatosError
  requires ( sql_query != "" )
  {
    bool retorno = true;
    int rc;

    if ( this.conectar () ) {

      this.foreign_keys_definir_comportamiento ();

      GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_MESSAGE, "Query a ejecutar: %s.", sql_query);

      rc = this.db.exec ( sql_query, null, null );
      if ( rc != Sqlite.OK ) {
        string error_mensaje = "SQL error: %d, %s.".printf ( rc, this.db.errmsg () );

        GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
        throw new BaseDeDatosError.EXEC_QUERY ( error_mensaje );
      }
    }
    return retorno;
  }

  private void foreign_keys_definir_comportamiento () throws BaseDeDatosError {
    string pragma_foreign_key = "PRAGMA foreign_keys=";

    if ( this._pragma_foreign_key ) {
      pragma_foreign_key += "ON;";
    } else {
      pragma_foreign_key += "OFF;";
    }

      GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_MESSAGE, "Base de datos definida con: %s.", pragma_foreign_key );
    var rc = this.db.exec ( pragma_foreign_key, null, null );

    if ( rc != Sqlite.OK ) {
      string error_mensaje = "SQL error: %d, %s.".printf ( rc, this.db.errmsg () );

      GLib.log ( log_domain_base_de_datos, GLib.LogLevelFlags.LEVEL_WARNING, error_mensaje );
      throw new BaseDeDatosError.EXEC_QUERY ( error_mensaje );
    }

  }

  private string armar_condicion ( string condicion ) {
    string retorno = "";
    if ( condicion != "" ) {
      retorno = " WHERE " + condicion;
    }
    return retorno;
  }

}
