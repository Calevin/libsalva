using Salva;

/*
* Clase para tests sobre Salva.EntidadDAO (salva_entidad_dao.vala)
*/
class Testing.TestEntidadDAO {

  public static void test_insertar () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo insertar" );
    UnaEntidad ent_para_insert = new UnaEntidad ( 1, 1, "a" );

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );

    try {
      una_entidad_dao.insertar ( ent_para_insert );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
  }

  public static void test_insertar_sin_id () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo insertar (Entidad sin ID)" );
    UnaEntidad ent_para_insert = new UnaEntidad.UnaEntidad_sin_id ( 10, "z" );

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );

    try {
      una_entidad_dao.insertar ( ent_para_insert );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
  }

  public static void test_actualizar () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo actualizar" );
    UnaEntidad ent_para_actualizar = new UnaEntidad ( 1, 1, "actualizar" );

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );

    try {
      una_entidad_dao.actualizar ( ent_para_actualizar );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
  }

  public static void test_borrar () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo borrar" );
    UnaEntidad ent_para_borrar = new UnaEntidad.UnaEntidad_id ( 1 );

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );

    try {
      una_entidad_dao.borrar ( ent_para_borrar );
      una_entidad_dao.borrar ( new UnaEntidad.UnaEntidad_id ( 2 ) );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
  }

  public static void test_get_todos () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo get_todos" );
    insertar_entidades_para_test ();

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );
    try {
      Array<Salva.Entidad> entidades = una_entidad_dao.get_todos ();
      UnaEntidad row_entidad;
      int valor_propiedad = 2;
      for (int i = 0; i < entidades.length; i++) {
        row_entidad = entidades.index (i) as UnaEntidad;
        assert ( row_entidad.id == valor_propiedad );
        assert ( row_entidad.propiedad_unit == (valor_propiedad + 1) );

        if ( row_entidad.id != 5 ) {
          assert ( row_entidad.propiedad_string == "conjunto" );
        } else {
          assert ( row_entidad.propiedad_string == "no-conjunto" );
        }
        valor_propiedad++;
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
      borrar_entidades_usadas_para_test ();
    }
  }

  public static void test_get_todos_segun_condicion () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo get_todos_segun_condicion" );
    insertar_entidades_para_test ();

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );

    GLib.Test.message ( "Se ejecuta el select con condicion. Entidades con propiedad_string='conjunto'" );
    try {
      Array<Salva.Entidad> entidades = una_entidad_dao.get_todos_segun_condicion ( "propiedad_string='conjunto'" );
      UnaEntidad row_entidad;
      int valor_propiedad = 2;
      for (int i = 0; i < entidades.length; i++) {
        row_entidad = entidades.index (i) as UnaEntidad;
        assert ( row_entidad.id == valor_propiedad );
        assert ( row_entidad.propiedad_unit == (valor_propiedad + 1) );
        assert ( row_entidad.propiedad_string == "conjunto" );

        valor_propiedad++;
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
      borrar_entidades_usadas_para_test ();
    }
  }

  public static void test_get_entidades_relacionadas () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo get_entidades_relacionadas" );
    insertar_entidades_relacionadas_para_test ();

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );
    EntidadRelacionadaDao entidad_relacionada_dao = new EntidadRelacionadaDao ();
    entidad_relacionada_dao.set_db  ( base_test );

    try {
      Array<Salva.Entidad> entidades = una_entidad_dao.get_entidades_relacionadas (
                                        new UnaEntidad.UnaEntidad_id ( 1 ),
                                        entidad_relacionada_dao );

      EntidadRelacionada row_entidad;
      int valor_propiedad = 1;
      for (int i = 0; i < entidades.length; i++) {
        row_entidad = entidades.index (i) as EntidadRelacionada;
        assert ( row_entidad.id == valor_propiedad );
        assert ( row_entidad.otra_propiedad_unit == (valor_propiedad + 1 ) );
        assert ( row_entidad.otra_propiedad_string == "relacionada" );
        valor_propiedad++;
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
      borrar_entidades_relacionadas_usadas_para_test ();
    }
  }

  public static void test_borrar_entidades_relacionadas () {
    GLib.Test.message ( "-------------------------------------------------------------------" );
    GLib.Test.message ( "Test sobre el metodo borrar_entidades_relacionadas" );
    insertar_entidades_relacionadas_para_test ();

    UnaEntidadDao una_entidad_dao = new UnaEntidadDao ();
    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    una_entidad_dao.set_db ( base_test );
    EntidadRelacionadaDao entidad_relacionada_dao = new EntidadRelacionadaDao ();
    entidad_relacionada_dao.set_db  ( base_test );

    try {
      una_entidad_dao.borrar_entidades_relacionadas ( new UnaEntidad.UnaEntidad_id ( 1 ),
                                                        entidad_relacionada_dao );
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
      borrar_entidades_relacionadas_usadas_para_test ();
    }
  }

  private static void insertar_entidades_para_test () {
    GLib.Test.message ( "****************************************" );
    GLib.Test.message ( "Se insertan entidades para el test" );

    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    try {
      for ( int i = 2; i < 5 ; i++){
        base_test.ejecutar_query ( "INSERT INTO entidades (rowid, propiedad_unit, propiedad_string)" +
                                      "VALUES (" + i.to_string () + ", " + ( i + 1 ).to_string () + ", \"conjunto\")");
      }

      base_test.ejecutar_query ( "INSERT INTO entidades (rowid, propiedad_unit, propiedad_string)" +
                                      "VALUES ( 5, 6, \"no-conjunto\")");
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
    GLib.Test.message ( "Se insertaron las entidades para el test" );
    GLib.Test.message ( "****************************************" );
  }

  private static void borrar_entidades_usadas_para_test () {
    GLib.Test.message ( "****************************************" );
    GLib.Test.message ( "Se borran las entidades usadas durante el test" );

    BaseDeDatos base_test = new BaseDeDatos.BaseDeDatos_foreign_keys_activas ( "./testsalva.db" );
    try {
      for ( int i = 2; i <= 5 ; i++){
        base_test.ejecutar_query ( "DELETE FROM entidades WHERE rowid=" + i.to_string () );
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
    GLib.Test.message ( "Se borraron las entidades usadas durante el test" );
    GLib.Test.message ( "****************************************" );
  }

  private static void insertar_entidades_relacionadas_para_test () {
    GLib.Test.message ( "****************************************" );
    GLib.Test.message ( "Se insertan entidades relacionadas para el test" );

    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    try {
      for ( int i = 1; i < 4 ; i++){
        base_test.ejecutar_query ( "INSERT INTO entidades_relacionadas (rowid, entidade_rowid, otra_propiedad_unit, otra_propiedad_string) " +
                                      "VALUES (" + i.to_string () + ", 1, " + ( i + 1 ).to_string () + ", \"relacionada\")");
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
    GLib.Test.message ( "Se insertaron las entidades relacionadas para el test" );
    GLib.Test.message ( "****************************************" );
  }

  private static void borrar_entidades_relacionadas_usadas_para_test () {
    GLib.Test.message ( "****************************************" );
    GLib.Test.message ( "Se borran las entidades relacionadas usadas durante el test" );

    BaseDeDatos base_test = new BaseDeDatos ( "./testsalva.db" );
    try {
      for ( int i = 1; i < 4 ; i++){
        base_test.ejecutar_query ( "DELETE FROM entidades_relacionadas WHERE rowid=" + i.to_string () );
      }
    } catch ( BaseDeDatosError e ) {
        assert_not_reached();
    } finally {
      base_test = null;
    }
    GLib.Test.message ( "Se borraron las entidades relacionadas usadas durante el test" );
    GLib.Test.message ( "****************************************" );
  }
}
