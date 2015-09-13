
public class Testing.UnaEntidadDao : Salva.EntidadDAO {
  private string[] _propiedades = {"id", "propiedad_unit", "propiedad_string"};
  private string _nombre_tabla = "entidades";
  private string _columnas_tabla = "rowid, propiedad_unit, propiedad_string";
  private Type _tipo_entidad = typeof ( UnaEntidad );
  private HashTable<string, string> _relaciones_m2m = new HashTable<string, string> (str_hash, str_equal);

  public UnaEntidadDao ( Salva.IBaseDeDatos db ) {
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

  protected override HashTable<string, string>? get_relaciones_m2m () {
    this._relaciones_m2m.insert ( "categorias", "entidades_categorias" );
    return this._relaciones_m2m;
  }

}
