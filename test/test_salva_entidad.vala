using Salva;

/*
* Clase para tests sobre Salva.Entidad (salva_entidad.vala)
*/
class Testing.TestEntidad {

  public static void test_valores_para_query () {
    GLib.Test.message ( "Test sobre el metodo valores_para_query()" );

    UnaEntidad entidad_test = new UnaEntidad ( 1, 2, "a" );
    Array<string> valores_propiedades = entidad_test.valores_para_query ();

    assert ( valores_propiedades.index (0) == "1" );
    assert ( valores_propiedades.index (1) == "2" );
    assert ( valores_propiedades.index (2) == "\"a\"" );
  }
}
