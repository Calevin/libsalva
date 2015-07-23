/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * salva-entidad.vala
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

public class Salva.Entidad : GLib.Object {
  public uint id { public get; protected set; }

  public Entidad ( uint id ) {
    this._id = id;
  }

  public Array<string> valores_para_query () {
    //Se obtienene los atributos de la clase
    ObjectClass clase_entidad = ( ObjectClass ) ( this.get_type () ).class_ref ();
    ParamSpec[] propiedades_entidad = clase_entidad.list_properties ();

    Array<string> valores = new Array<string> ();
    string valor = "";

    //Se recorren los atributos de la clase 
    //Se obtienen los valores de la instancia
    foreach ( ParamSpec propiedad in propiedades_entidad ) {
        GLib.Value valor_propiedad = GLib.Value ( propiedad.value_type );
        //Se obtiene el valor de la propiedad (Value)
        this.get_property ( propiedad.get_name (), ref valor_propiedad );
        //En caso de no ser un array se tomara el valor
        if ( !valor_propiedad.holds ( typeof ( Array ) ) ) {
          //Se comprueba si el valor de la propiedad es string
          if ( valor_propiedad.holds ( typeof ( string ) ) ) {
            //En caso de ser String el valor va entre comillas en la query
            valor = " \"" + valor_propiedad.get_string () + "\"";

          } else {
            //En caso de no ser string, se castea a string para agregarlo a la query
            GLib.Value valor_propiedad_como_string = GLib.Value ( typeof ( string ) );
            valor_propiedad.transform ( ref valor_propiedad_como_string );

            valor = valor_propiedad_como_string.get_string ();
          }
          valores.append_val ( valor );
        }//Fin si no es array
    } //Fin foreach
    return valores;
  }
}
