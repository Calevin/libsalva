CREATE TABLE entidades (
	propiedad_unit INTEGER,
	propiedad_string VARCHAR(60)
);

CREATE TABLE entidades_relacionadas (
	entidade_rowid INTEGER,
	otra_propiedad_unit INTEGER,
	otra_propiedad_string VARCHAR(60),
	FOREIGN KEY (entidade_rowid) REFERENCES entidad (rowid)
);
