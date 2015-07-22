using Salva;

class Testing.TestMain {

  public static int main ( string[] args ) {
    stdout.printf ("Iniciando test\n");
    UnaEntidad ent = new UnaEntidad (1, 2, "a");
    Array<string> props = ent.valores_para_query ();
    stdout.printf ("Propiedades:\n");
    for (int i = 0; i < props.length; i++) {
      stdout.printf ("Propiedad: %s\n", props.index ( i) );
    }
    return 0;
  }
}
