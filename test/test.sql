CREATE TABLE entidades (
	rowid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	propiedad_unit INTEGER,
	propiedad_string TEXT
);

CREATE TABLE entidades_relacionadas (
	rowid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	entidade_rowid INTEGER,
	otra_propiedad_unit INTEGER,
	otra_propiedad_string TEXT,
	FOREIGN KEY (entidade_rowid) REFERENCES entidades (rowid)
);

CREATE TABLE categorias (
	rowid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	nombre TEXT,
	descripcion TEXT
);

CREATE TABLE entidades_categorias (
	rowid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	entidade_rowid INTEGER NOT NULL,
	categoria_rowid INTEGER NOT NULL,
	FOREIGN KEY (entidade_rowid) REFERENCES entidades (rowid),
	FOREIGN KEY (categoria_rowid) REFERENCES categorias (rowid)
);
