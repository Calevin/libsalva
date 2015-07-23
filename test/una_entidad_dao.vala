
public class Testing.UnaEntidadDao : Salva.EntidadDAO {
  private string[] _propiedades = {"id", "propiedad_unit", "propiedad_string"};
  private string _nombre_tabla = "entidades";
  private string _columnas_tabla = "rowid, propiedad_unit, propiedad_string";
  private Type _tipo_entidad = typeof ( UnaEntidad );
  private Salva.BaseDeDatos _db;

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

  public override void set_db ( Salva.BaseDeDatos db ) {
    this._db = db;
  }

  protected override Salva.BaseDeDatos get_db () {
    return this._db;
  }
}
