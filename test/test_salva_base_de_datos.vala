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

}
