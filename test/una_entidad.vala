
public class Testing.UnaEntidad : Salva.Entidad {
  public uint propiedad_unit { public get; public set; }
  public string propiedad_string { public get; public set; }
  public Array<Testing.EntidadRelacionada> entidades_relacionadas { public get; public set; }

  public UnaEntidad ( uint id, uint un_uint, string un_string ) {
    base ( id );
    this._propiedad_unit = un_uint;
    this._propiedad_string = un_string;
  }

  public UnaEntidad.UnaEntidad_sin_id ( uint un_uint, string un_string ) {
    base.Entidad_sin_id ( );
    this._propiedad_unit = un_uint;
    this._propiedad_string = un_string;
  }

  public UnaEntidad.UnaEntidad_id ( uint id ) {
    base ( id );
  }

}
