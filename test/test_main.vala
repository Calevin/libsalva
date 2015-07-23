using Salva;
using Sqlite;

class Testing.TestMain {

  public static int main ( string[] args ) {

    stdout.printf ( "Iniciando tests\n" );

    stdout.printf ( "Tests sobre Salva.Entidad\n" );
    TestEntidad test_entidad = new TestEntidad ();
    test_entidad.test_valores_para_query ();

    stdout.printf ( "\nTests sobre Salva.BaseDeDatos\n" );
    TestBaseDeDatos test_base_de_datos = new TestBaseDeDatos ();
    test_base_de_datos.test_conectar ();
    test_base_de_datos.test_insert ();
    test_base_de_datos.test_update ();
    test_base_de_datos.test_select ();
    test_base_de_datos.test_delete ();

    stdout.printf ( "\nTests sobre Salva.EntidadDAO\n" );
    TestEntidadDAO test_entidad_dao = new TestEntidadDAO ();
    test_entidad_dao.test_insertar ();
    test_entidad_dao.test_actualizar();
    test_entidad_dao.test_borrar ();
    test_entidad_dao.test_get_todos ();
    test_entidad_dao.test_get_todos_segun_condicion ();

    return 0;
  }
}
