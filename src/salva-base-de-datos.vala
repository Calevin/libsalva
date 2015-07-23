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

  public static bool conectar ( string archivo_db, out Sqlite.Database db ) {
    bool retorno = false;

    int rc = Sqlite.Database.open ( archivo_db, out db );

    if ( rc != Sqlite.OK ) {
      stderr.printf ( "No se pudo abrir la base de datos" + ": %d, %s\n",
                      rc, db.errmsg () );
    } else {
      retorno = true;
    }

    return retorno;
  }

}
