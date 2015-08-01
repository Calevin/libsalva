using Salva;

/*
* Clase para tests sobre Salva.BaseDeDatos (salva_base_de_datos.vala)
*/
class Testing.TestBaseDeDatos {

  public static void test_conectar () {
    GLib.Test.message ( "Test sobre el metodo conectar" );

    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    try {
        bool conexion_satisfactoria = false;
        conexion_satisfactoria = base_test.conectar ();
        assert ( conexion_satisfactoria );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
  }

  public static void test_insert () {
    GLib.Test.message ( "Test sobre el metodo insert" );
    string nombre_tabla = "entidades";
    string columnas_tabla = "rowid, propiedad_unit, propiedad_string";
    UnaEntidad ent_para_insert = new UnaEntidad ( 1, 2, "b" );
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );

    try {
        base_test.insert ( nombre_tabla, columnas_tabla , ent_para_insert );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
        base_test = null;
    }
  }

  public static void test_delete () {
    GLib.Test.message ( "Test sobre el metodo delete" );
    string nombre_tabla = "entidades";
    UnaEntidad ent_para_borrar = new UnaEntidad.UnaEntidad_id ( 1 );
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );

    try {
        base_test.delet ( nombre_tabla, ent_para_borrar );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
        base_test = null;
    }
  }

  public static void test_update () {
    GLib.Test.message ( "Test sobre el metodo update" );
    string nombre_tabla = "entidades";
    string columnas_tabla = "rowid, propiedad_unit, propiedad_string";
    UnaEntidad ent_para_update = new UnaEntidad ( 1, 2, "update" );
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );

    try {
        base_test.update ( nombre_tabla, columnas_tabla , ent_para_update );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
        base_test = null;
    }
  }

  public static void test_select () {
    GLib.Test.message ( "Test sobre el metodo select" );
    string nombre_tabla = "entidades";
    string columnas_tabla = "rowid, propiedad_unit, propiedad_string";
    string[] propiedades_entidad = {"id", "propiedad_unit", "propiedad_string"};
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    Array<Salva.Entidad> entidades;

    try {
      entidades = base_test.select ( nombre_tabla, columnas_tabla , propiedades_entidad,
                                          typeof ( UnaEntidad ) );
      UnaEntidad row_entidad;
      for (int i = 0; i < entidades.length; i++) {
        row_entidad = entidades.index (i) as UnaEntidad;
        assert ( 1 == row_entidad.id );
        assert ( 2 == row_entidad.propiedad_unit );
        assert ( "update" == row_entidad.propiedad_string );
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
        base_test = null;
    }
  }

  public static void test_ejecutar_query () {
    GLib.Test.message ( "Test sobre el metodo ejecutar query" );
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    try {
      assert ( base_test.ejecutar_query ( "SELECT 1" ) );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
        base_test = null;
    }
  }
}
