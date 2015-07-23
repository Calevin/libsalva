all:
	make sources

NAME=salva
LIBNAME=lib$(NAME)
SOURCE_FILES=salva-entidad.vala salva-base-de-datos.vala
PACKAGES=--pkg sqlite3
VALAC=valac

sources:
	$(VALAC) --library $(LIBNAME).so -o $(LIBNAME).so -X -fPIC -X --shared $(SOURCE_FILES) --vapi $(NAME).vapi -H $(NAME).h $(PACKAGES)
