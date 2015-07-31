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

    Test.run ();
    return 0;
  }
}
