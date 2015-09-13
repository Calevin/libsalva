all:
	make sources

NAME=salva
LIBNAME=lib$(NAME)
SOURCE_FILES_TESTS=test_main.vala test_salva_entidad.vala test_salva_sqlite_base_de_datos.vala test_salva_entidad_dao.vala
SOURCE_FILES_ENTITIES=una_entidad.vala entidad_relacionada.vala categoria.vala
SOURCE_FILES_DAOS=una_entidad_dao.vala entidad_relacionada_dao.vala categoria_dao.vala
SOURCE_FILES=$(SOURCE_FILES_TESTS) $(SOURCE_FILES_ENTITIES) $(SOURCE_FILES_DAOS)
PACKAGES=--pkg sqlite3

sources:
	rm -f ./test
	valac ../lib/$(NAME).vapi $(SOURCE_FILES) -X ../lib/$(LIBNAME).so -X -I../lib $(PACKAGES) -o test
