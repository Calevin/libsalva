using Salva;

/*
* Clase para tests sobre Salva.BaseDeDatos (salva_base_de_datos.vala)
*/
class Testing.TestBaseDeDatos {
  string base_datos_test = "./testsalva.db";
  BaseDeDatos base_test;

  public TestBaseDeDatos () {
    this.base_test = new BaseDeDatos ( base_datos_test );
  }

  public void test_conectar () {
    stdout.printf ( "\nTest sobre el metodo conectar :\n" );

    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      stdout.printf ( "Conexion satisfactoria\n" );
    } else {
      stdout.printf ( "Conexion NO satisfactoria\n" );
    }
  }

  public void test_insert () {
    stdout.printf ( "\nTest sobre el metodo insert :\n" );
    UnaEntidad ent_para_insert = new UnaEntidad ( 1, 2, "b" );

    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      this.base_test.insert ( "entidades", "rowid, propiedad_unit, propiedad_string" , ent_para_insert, typeof ( UnaEntidad ) );
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante el test al metodo insert\n" );
    }
  }

  public void test_delete () {
    stdout.printf ( "\nTest sobre el metodo delete :\n" );
    UnaEntidad ent_para_borrar = new UnaEntidad.UnaEntidad_id ( 1 );

    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      this.base_test.delet ( "entidades", ent_para_borrar );
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante el test al metodo delete\n" );
    }
  }

  public void test_update () {
    stdout.printf ( "\nTest sobre el metodo update :\n" );
    UnaEntidad ent_para_insert = new UnaEntidad ( 1, 2, "modificado" );

    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      this.base_test.update ( "entidades", "rowid, propiedad_unit, propiedad_string" , ent_para_insert, typeof ( UnaEntidad ) );
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante el test al metodo update\n" );
    }
  }

  public void test_select () {
    stdout.printf ( "\nTest sobre el metodo select :\n" );
    Array<Salva.Entidad> entidades;

    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      entidades = this.base_test.select ( "entidades", "rowid, propiedad_unit, propiedad_string" , {"id", "propiedad_unit", "propiedad_string"},
                                          typeof ( UnaEntidad ) );
      UnaEntidad row_entidad;
      stdout.printf ( "\n\n Entidades: \n" );
      for (int i = 0; i < entidades.length; i++) {
        row_entidad = entidades.index (i) as UnaEntidad;
        stdout.printf ( "ID: %u\n", row_entidad.id );
        stdout.printf ( "Propiedad Unit: %u\n", row_entidad.propiedad_unit );
        stdout.printf ( "Propiedad String: %s\n", row_entidad.propiedad_string );
      }
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante el test al metodo select\n" );
    }
  }
}
