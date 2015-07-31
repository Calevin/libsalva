using Salva;
using Sqlite;

/*
* Clase para todos los tests
*/
class Testing.TestMain {

  public static int main ( string[] args ) {
    GLib.Test.init (ref args);
    stdout.printf ( "Iniciando tests\n" );

    stdout.printf ( "Tests sobre Salva.Entidad\n" );
    Test.add_func ( "/test_entidad/valores_para_query", TestEntidad.test_valores_para_query );

    stdout.printf ( "\nTests sobre Salva.BaseDeDatos\n" );
    Test.add_func ( "/TestBaseDeDatos/test_conectar", TestBaseDeDatos.test_conectar );
    Test.add_func ( "/TestBaseDeDatos/test_insert", TestBaseDeDatos.test_insert );
    Test.add_func ( "/TestBaseDeDatos/test_update", TestBaseDeDatos.test_update );
    Test.add_func ( "/TestBaseDeDatos/test_select", TestBaseDeDatos.test_select );
    Test.add_func ( "/TestBaseDeDatos/test_delete", TestBaseDeDatos.test_delete );
    Test.add_func ( "/TestBaseDeDatos/test_ejecutar_query", TestBaseDeDatos.test_ejecutar_query );

    Test.run ();
    return 0;
  }
}
