include ../Makefile

all:
	make sources

SOURCE_FILES=salva_entidad.vala salva_ibase_de_datos.vala salva_entidad_dao.vala salva_sqlite_base_de_datos.vala
PACKAGES=--pkg sqlite3

sources:
	$(VALAC) --library=$(LIBNAME) -o $(FULL_LIBNAME) -X -fPIC -X --shared $(SOURCE_FILES) --vapi $(NAME).vapi -H $(NAME).h $(PACKAGES)
