public class Testing.CategoriaDao : Salva.EntidadDAO {
  private string[] _propiedades = {"id", "nombre", "descripcion"};
  private string _nombre_tabla = "categorias";
  private string _columnas_tabla = "rowid, nombre, descripcion";
  private Type _tipo_entidad = typeof ( Categoria );

  public CategoriaDao ( Salva.IBaseDeDatos db ) {
    base ( db );
  }

  protected override string[] get_propiedades () {
    return this._propiedades;
  }

  protected override string get_nombre_tabla () {
    return this._nombre_tabla;
  }

  protected override string get_columnas_tabla () {
    return this._columnas_tabla;
  }

  protected override Type get_tipo_entidad () {
    return this._tipo_entidad;
  }

}
