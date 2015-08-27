using Salva;
using Sqlite;

/*
* Clase para todos los tests
*/
class Testing.TestMain {

  public static int main ( string[] args ) {
    GLib.Test.init (ref args);
    GLib.Test.message ( "Iniciando tests." );
    GLib.Test.message ( "-------------------------------------------------------------------" );

    GLib.Test.message ( "Tests sobre Salva.Entidad." );
    Test.add_func ( "/test_entidad/valores_para_query", TestEntidad.test_valores_para_query );

    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Tests sobre Salva.BaseDeDatos." );
    Test.add_func ( "/TestSQLiteBaseDeDatos/test_insert", TestSQLiteBaseDeDatos.test_insert );
    Test.add_func ( "/TestSQLiteBaseDeDatos/test_update", TestSQLiteBaseDeDatos.test_update );
    Test.add_func ( "/TestSQLiteBaseDeDatos/test_select", TestSQLiteBaseDeDatos.test_select );
    Test.add_func ( "/TestSQLiteBaseDeDatos/test_delete", TestSQLiteBaseDeDatos.test_delete );
    Test.add_func ( "/TestSQLiteBaseDeDatos/test_ejecutar_query", TestSQLiteBaseDeDatos.test_ejecutar_query );

    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Tests sobre Salva.UnaEntidadDao." );
    Test.add_func ( "/TestEntidadDAO/test_insertar", TestEntidadDAO.test_insertar );
    Test.add_func ( "/TestEntidadDAO/test_insertar_sin_id", TestEntidadDAO.test_insertar_sin_id );
    Test.add_func ( "/TestEntidadDAO/test_actualizar", TestEntidadDAO.test_actualizar );
    Test.add_func ( "/TestEntidadDAO/test_borrar", TestEntidadDAO.test_borrar );
    Test.add_func ( "/TestEntidadDAO/test_get_todos", TestEntidadDAO.test_get_todos );
    Test.add_func ( "/TestEntidadDAO/test_get_todos_segun_condicion", TestEntidadDAO.test_get_todos_segun_condicion );
    Test.add_func ( "/TestEntidadDAO/test_get_entidades_relacionadas", TestEntidadDAO.test_get_entidades_relacionadas );
    Test.add_func ( "/TestEntidadDAO/test_borrar_entidades_relacionadas", TestEntidadDAO.test_borrar_entidades_relacionadas );

    GLib.Test.message ( "Tests finalizados." );
    Test.run ();
    return 0;
  }
}
