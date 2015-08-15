
public class Testing.UnaEntidadDao : Salva.EntidadDAO {
  private string[] _propiedades = {"id", "propiedad_unit", "propiedad_string"};
  private string _nombre_tabla = "entidades";
  private string _columnas_tabla = "rowid, propiedad_unit, propiedad_string";
  private Type _tipo_entidad = typeof ( UnaEntidad );

  public UnaEntidadDao ( Salva.BaseDeDatos db ) {
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
