/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * salva-base-de-datos.vala
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

public class Salva.BaseDeDatos {
  public string base_datos { public get; public set; }
  public Sqlite.Database db;

  public BaseDeDatos ( string base_datos ) {
    this._base_datos = base_datos;
  }

  public bool conectar () {
    bool retorno = false;

    int rc = Sqlite.Database.open ( this.base_datos, out this.db );

    if ( rc != Sqlite.OK ) {
      stderr.printf ( "No se pudo abrir la base de datos" + ": %d, %s\n",
                      rc, this.db.errmsg () );
    } else {
      retorno = true;
    }

    return retorno;
  }

  public void insert ( string tabla, string columnas, Salva.Entidad entidad, Type tipo_entidad) {
    int rc;
    string valores = "";
    Array<string> valores_array = entidad.valores_para_query ();

    for (int i = 0; i < valores_array.length; i++) {
      valores = valores + valores_array.index (i);
      if ((i + 1) < valores_array.length) {
        valores = valores + ",";
      }
    }

    if ( this.conectar () ) {
      string sql_query = "INSERT INTO " + tabla + "(" + columnas + ") VALUES (" + valores + ")";
      stdout.printf( "QUERY:  %s\n", sql_query );

      rc = this.db.exec ( sql_query, null, null );
      if ( rc != Sqlite.OK ) {
            stderr.printf ( "SQL error: %d, %s\n", rc, db.errmsg () );
      }
    } else {
      stdout.printf( "No hubo conexion con la base\n" );
    }
  }

  public void delet ( string tabla, Salva.Entidad entidad) {
    int rc;
    string where = "";

    //Obtengo el valor del atributo ID
    GLib.Value propiedad_id_value = GLib.Value ( typeof ( uint ) );
    entidad.get_property ( "id", ref propiedad_id_value );
    //Casteo el id a string para agregarlo a la query
    GLib.Value id_value_string = GLib.Value ( typeof( string ) );
    propiedad_id_value.transform ( ref id_value_string );

    //Agrego el valor del id a la sentencia WHERE
    where = " rowid = " + id_value_string.get_string ();

    if ( this.conectar () ) {
      string sql_query = "DELETE FROM " + tabla + " WHERE " + where;
      stdout.printf("QUERY:  %s\n", sql_query);

      rc = this.db.exec ( sql_query, null, null);
      if (rc != Sqlite.OK) {
            stderr.printf ( "SQL error: %d, %s\n", rc, db.errmsg () );
      }
    } else {
      stdout.printf( "No hubo conexion con la base\n" );
    }
  }

}
