all:
	make sources

NAME=salva
LIBNAME=lib$(NAME)
SOURCE_FILES=test_main.vala una_entidad.vala
PACKAGES=--pkg sqlite3

sources:
	rm -f ./test
	valac ../lib/$(NAME).vapi $(SOURCE_FILES) -X ../lib/$(LIBNAME).so -X -I../lib $(PACKAGES) -o test
