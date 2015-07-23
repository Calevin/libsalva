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
  private Sqlite.Database db;

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

}
