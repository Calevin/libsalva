using Salva;
using Sqlite;

class Testing.TestMain {

  public static int main ( string[] args ) {

    stdout.printf ( "Iniciando tests\n" );

    stdout.printf ( "Tests sobre Salva.Entidad\n" );
    TestEntidad test_entidad = new TestEntidad ();
    test_entidad.test_valores_para_query ();

    stdout.printf ( "Tests sobre Salva.BaseDeDatos\n" );
    TestBaseDeDatos test_base_de_datos = new TestBaseDeDatos ();
    test_base_de_datos.test_conectar ();
    test_base_de_datos.test_insert ();
    test_base_de_datos.test_delete ();

    return 0;
  }
}
