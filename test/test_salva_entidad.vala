using Salva;

/*
* Clase para tests sobre Salva.Entidad (salva_entidad.vala)
*/
class Testing.TestEntidad {
  UnaEntidad ent_test;

  public TestEntidad () {
    this.ent_test = new UnaEntidad (1, 2, "a");
  }

  //TODO comprobar valores en vez de mostrarlos por pantalla
  public void test_valores_para_query () {
    stdout.printf ( "\nTest sobre el metodo valores_para_query():\n" );

    Array<string> props = this.ent_test.valores_para_query ();
    stdout.printf ( "Propiedades:\n" );
    for (int i = 0; i < props.length; i++) {
      stdout.printf ( "Propiedad: %s\n", props.index ( i) );
    }
  }
}
