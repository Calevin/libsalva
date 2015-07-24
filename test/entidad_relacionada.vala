
public class Testing.EntidadRelacionada : Salva.Entidad {
  public uint otra_propiedad_unit { public get; public set; }
  public string otra_propiedad_string { public get; public set; }

  public EntidadRelacionada ( uint id, uint un_uint, string un_string ) {
    base ( id );
    this._otra_propiedad_unit = un_uint;
    this._otra_propiedad_string = un_string;
  }

  public EntidadRelacionada.EntidadRelacionada_id ( uint id ) {
    base ( id );
  }

}
