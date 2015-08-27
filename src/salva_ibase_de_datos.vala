/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * salva_ibase_de_datos.vala
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

public errordomain BaseDeDatosError {
  OPEN_FAIL,
  EXEC_QUERY,
  PARSER_RESULT
}

public interface Salva.IBaseDeDatos : GLib.Object {

  protected abstract bool conectar () throws BaseDeDatosError;

  public abstract void insert ( string tabla, owned string columnas, Salva.Entidad entidad) throws BaseDeDatosError;

  public abstract void delet ( string tabla, Salva.Entidad entidad) throws BaseDeDatosError;

  public abstract void update ( string tabla, string columnas, Salva.Entidad entidad ) throws BaseDeDatosError;

  public abstract Array<Salva.Entidad> select ( string tabla, string campos, string[] propiedades, Type tipo_entidad,
                                       string condicion = "") throws BaseDeDatosError;

  public abstract bool ejecutar_query ( string sql_query ) throws BaseDeDatosError;

}
