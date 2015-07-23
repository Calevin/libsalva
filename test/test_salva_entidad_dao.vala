using Salva;

/*
* Clase para tests sobre Salva.EntidadDAO (salva_entidad_dao.vala)
*/
class Testing.TestEntidadDAO {
  string base_datos_test = "./testsalva.db";
  BaseDeDatos base_test;
  UnaEntidadDao una_entidad_dao;

  public TestEntidadDAO () {
    this.base_test = new BaseDeDatos ( base_datos_test );
    this.una_entidad_dao = new UnaEntidadDao ();
    this.una_entidad_dao.set_db( base_test );
  }

  public void test_insertar () {
    stdout.printf ( "\nTest sobre el metodo insertar:\n" );
    UnaEntidad ent_para_insert = new UnaEntidad ( 2, 4, "c" );
    this.una_entidad_dao.insertar ( ent_para_insert );
  }

  public void test_actualizar () {
    stdout.printf ( "\nTest sobre el metodo actualizar:\n" );
    UnaEntidad ent_para_actualizar = new UnaEntidad ( 2, 4, "actualizar" );
    this.una_entidad_dao.actualizar ( ent_para_actualizar );
  }

  public void test_borrar () {
    stdout.printf ( "\nTest sobre el metodo borrar:\n" );
    UnaEntidad ent_para_borrar = new UnaEntidad.UnaEntidad_id ( 2 );
    this.una_entidad_dao.borrar ( ent_para_borrar );
  }

  public void test_get_todos () {
    stdout.printf ( "\nTest sobre el metodo get_todos:\n" );
    this.insertar_entidades_para_test ();

    Array<Salva.Entidad> entidades = this.una_entidad_dao.get_todos ();
    UnaEntidad row_entidad;
    stdout.printf ( "\n\n Entidades: \n" );
    for (int i = 0; i < entidades.length; i++) {
      row_entidad = entidades.index (i) as UnaEntidad;
      stdout.printf ( "ID: %u\n", row_entidad.id );
      stdout.printf ( "Propiedad Unit: %u\n", row_entidad.propiedad_unit );
      stdout.printf ( "Propiedad String: %s\n", row_entidad.propiedad_string );
    }
    borrar_entidades_usadas_para_test ();
  }

  public void test_get_todos_segun_condicion () {
    stdout.printf ( "\nTest sobre el metodo get_todos_segun_condicion:\n" );
    this.insertar_entidades_para_test ();

    stdout.printf ( " Se ejecuta el select con condicion: \n" );
    Array<Salva.Entidad> entidades = this.una_entidad_dao.get_todos_segun_condicion ( "propiedad_string='conjunto' " );
    UnaEntidad row_entidad;
    stdout.printf ( " Entidades con propiedad_string='conjunto': \n" );
    for (int i = 0; i < entidades.length; i++) {
      row_entidad = entidades.index (i) as UnaEntidad;
      stdout.printf ( "ID: %u\n", row_entidad.id );
      stdout.printf ( "Propiedad Unit: %u\n", row_entidad.propiedad_unit );
      stdout.printf ( "Propiedad String: %s\n", row_entidad.propiedad_string );
    }
    borrar_entidades_usadas_para_test ();
  }

  private void insertar_entidades_para_test () {
    stdout.printf ( "\nSe insertan entidades para el test:\n" );
    this.una_entidad_dao.insertar ( new UnaEntidad ( 3, 4, "conjunto" ) );
    this.una_entidad_dao.insertar ( new UnaEntidad ( 4, 4, "conjunto" ) );
    this.una_entidad_dao.insertar ( new UnaEntidad ( 5, 4, "conjunto" ) );
    this.una_entidad_dao.insertar ( new UnaEntidad ( 6, 4, "no-conjunto" ) );
  }

  private void borrar_entidades_usadas_para_test () {
    stdout.printf ( "\nSe borran las entidades usadas durante el test:\n" );
    this.una_entidad_dao.borrar ( new UnaEntidad.UnaEntidad_id ( 3 ) );
    this.una_entidad_dao.borrar ( new UnaEntidad.UnaEntidad_id ( 4 ) );
    this.una_entidad_dao.borrar ( new UnaEntidad.UnaEntidad_id ( 5 ) );
    this.una_entidad_dao.borrar ( new UnaEntidad.UnaEntidad_id ( 6 ) );
  }
}
