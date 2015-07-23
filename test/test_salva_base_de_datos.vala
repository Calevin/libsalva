using Salva;

/*
* Clase para tests sobre Salva.BaseDeDatos (salva_base_de_datos.vala)
*/
class Testing.TestBaseDeDatos {
  string base_datos_test = "./testsalva.db";

  public TestBaseDeDatos () {
  }

  public void test_conectar () {
    stdout.printf ( "\nTest sobre el metodo conectar :\n" );

    Sqlite.Database db;
    bool conexion_satisfactoria = false;
    conexion_satisfactoria = BaseDeDatos.conectar ( base_datos_test, out db );
    if ( conexion_satisfactoria ) {
      stdout.printf ( "Conexion satisfactoria\n" );
    } else {
      stdout.printf ( "Conexion NO satisfactoria\n" );
    }
  }

}
