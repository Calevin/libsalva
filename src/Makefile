all:
	make sources

NAME=salva
LIBNAME=lib$(NAME)
SOURCE_FILES=salva_entidad.vala salva_base_de_datos.vala
PACKAGES=--pkg sqlite3
VALAC=valac

sources:
	$(VALAC) --library $(LIBNAME).so -o $(LIBNAME).so -X -fPIC -X --shared $(SOURCE_FILES) --vapi $(NAME).vapi -H $(NAME).h $(PACKAGES)
