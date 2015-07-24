using Salva;

/*
* Clase para tests sobre Salva.EntidadDAO (salva_entidad_dao.vala)
*/
class Testing.TestEntidadDAO {
  string base_datos_test = "./testsalva.db";
  BaseDeDatos base_test;
  UnaEntidadDao una_entidad_dao;
  EntidadRelacionadaDao entidad_relacionada_dao;

  public TestEntidadDAO () {
    this.base_test = new BaseDeDatos ( base_datos_test );
    this.una_entidad_dao = new UnaEntidadDao ();
    this.entidad_relacionada_dao = new EntidadRelacionadaDao ();
    this.una_entidad_dao.set_db ( base_test );
    this.entidad_relacionada_dao.set_db  ( base_test );
  }

  public void test_insertar () {
    stdout.printf ( "\nTest sobre el metodo insertar:\n" );
    UnaEntidad ent_para_insert = new UnaEntidad ( 1, 1, "a" );
    this.una_entidad_dao.insertar ( ent_para_insert );
  }

  public void test_actualizar () {
    stdout.printf ( "\nTest sobre el metodo actualizar:\n" );
    UnaEntidad ent_para_actualizar = new UnaEntidad ( 1, 1, "actualizar" );
    this.una_entidad_dao.actualizar ( ent_para_actualizar );
  }

  public void test_borrar () {
    stdout.printf ( "\nTest sobre el metodo borrar:\n" );
    UnaEntidad ent_para_borrar = new UnaEntidad.UnaEntidad_id ( 1 );
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
    Array<Salva.Entidad> entidades = this.una_entidad_dao.get_todos_segun_condicion ( "propiedad_string='conjunto'" );
    UnaEntidad row_entidad;
    stdout.printf ( " Entidades con propiedad_string='conjunto': \n" );
    for (int i = 0; i < entidades.length; i++) {
      row_entidad = entidades.index (i) as UnaEntidad;
      stdout.printf ( "ID: %u\n", row_entidad.id );
      stdout.printf ( "Propiedad Unit: %u\n", row_entidad.propiedad_unit );
      stdout.printf ( "Propiedad String: %s\n", row_entidad.propiedad_string );
    }

    this.borrar_entidades_usadas_para_test ();
  }

  public void test_get_entidades_relacionadas () {
    stdout.printf ( "\nTest sobre el metodo get_entidades_relacionadas:\n" );
    this.insertar_entidades_relacionadas_para_test ();

    Array<Salva.Entidad> entidades = this.una_entidad_dao.get_entidades_relacionadas ( new UnaEntidad.UnaEntidad_id ( 1 ), this.entidad_relacionada_dao );

    EntidadRelacionada row_entidad;
    stdout.printf ( " Entidades relacionadas: \n" );
    for (int i = 0; i < entidades.length; i++) {
      row_entidad = entidades.index (i) as EntidadRelacionada;
      stdout.printf ( "ID: %u\n", row_entidad.id );
      stdout.printf ( "Otra Propiedad Unit: %u\n", row_entidad.otra_propiedad_unit );
      stdout.printf ( "Otra Propiedad String: %s\n", row_entidad.otra_propiedad_string );
    }

    this.borrar_entidades_relacionadas_usadas_para_test ();
  }

  public void test_borrar_entidades_relacionadas () {
    stdout.printf ( "\nTest sobre el metodo borrar_entidades_relacionadas:\n" );
    this.insertar_entidades_relacionadas_para_test ();
    this.una_entidad_dao.borrar_entidades_relacionadas ( new UnaEntidad.UnaEntidad_id ( 1 ), this.entidad_relacionada_dao );
  }

  private void insertar_entidades_para_test () {
    stdout.printf ( "\nSe insertan entidades para el test:\n" );
    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      for ( int i = 2; i < 5 ; i++){
      this.base_test.ejecutar_query ( "INSERT INTO entidades (rowid, propiedad_unit, propiedad_string)" +
                                      "VALUES (" + i.to_string () + ", " + ( i + 1 ).to_string () + ", \"conjunto\")");
      }
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante 'insertar_entidades_para_test'\n" );
    }
      this.base_test.ejecutar_query ( "INSERT INTO entidades (rowid, propiedad_unit, propiedad_string)" +
                                      "VALUES ( 5, 6, \"no-conjunto\")");
  }

  private void borrar_entidades_usadas_para_test () {
    stdout.printf ( "\nSe borran las entidades usadas durante el test:\n" );
    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      for ( int i = 2; i <= 5 ; i++){
      this.base_test.ejecutar_query ( "DELETE FROM entidades WHERE rowid=" + i.to_string () );
      }
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante 'borrar_entidades_usadas_para_test'\n" );
    }
  }

  private void insertar_entidades_relacionadas_para_test () {
    stdout.printf ( "\nSe insertan entidades relacionadas para el test:\n" );
    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      for ( int i = 1; i < 4 ; i++){
      this.base_test.ejecutar_query ( "INSERT INTO entidades_relacionadas (rowid, entidade_rowid, otra_propiedad_unit, otra_propiedad_string) " +
                                      "VALUES (" + i.to_string () + ", 1, " + ( i + 1 ).to_string () + ", \"relacionada\")");
      }
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante 'insertar_entidades_relacionadas_para_test'\n" );
    }
    stdout.printf ( "\nSaliendo de insertar_entidades_relacionadas_para_test\n" );
  }

  private void borrar_entidades_relacionadas_usadas_para_test () {
    stdout.printf ( "\nSe borran las entidades relacionadas usadas durante el test:\n" );
    bool conexion_satisfactoria = false;
    conexion_satisfactoria = this.base_test.conectar ();
    if ( conexion_satisfactoria ) {
      for ( int i = 1; i < 4 ; i++){
      this.base_test.ejecutar_query ( "DELETE FROM entidades_relacionadas WHERE rowid=" + i.to_string () );
      }
    } else {
      stdout.printf ( "Conexion NO satisfactoria durante 'borrar_entidades_usadas_para_test'\n" );
    }
  }

}
