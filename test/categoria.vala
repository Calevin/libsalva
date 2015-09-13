public class Testing.Categoria : Salva.Entidad {
  public string nombre { public get; public set; }
  public string descripcion { public get; public set; }

  public Categoria ( uint id, string nombre, string descripcion ) {
    base ( id );
    this._nombre = nombre;
    this._descripcion = descripcion;
  }

  public Categoria.Categoria_id ( uint id ) {
    base ( id );
  }

}
