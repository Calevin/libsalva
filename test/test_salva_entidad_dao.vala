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
}
