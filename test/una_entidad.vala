
public class Testing.UnaEntidad : Salva.Entidad {
  public uint propiedad_unit { public get; public set; }
  public string propiedad_string { public get; public set; }

  public UnaEntidad (uint id, uint un_uint, string un_string) {
    base (id);
    this._propiedad_unit = un_uint;
    this._propiedad_string = un_string;
  }
}
