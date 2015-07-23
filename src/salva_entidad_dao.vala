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

  public Array<Entidad> get_todos () {
    Salva.BaseDeDatos db = get_db ();
    return db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad () );
  }

  public Array<Entidad> get_todos_segun_condicion ( string condicion ) {
    Salva.BaseDeDatos db = get_db ();
    return db.select( get_nombre_tabla (), get_columnas_tabla (),
      get_propiedades (), get_tipo_entidad (), condicion );
  }

}
