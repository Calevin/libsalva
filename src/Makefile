all:
	make sources

NAME=salva
LIBNAME=lib$(NAME)
SOURCE_FILES=salva-entidad.vala
#PACKAGES=--pkg gee-1.0 --pkg libxml-2.0 --pkg libsoup-2.4  $(PACKAGES)
VALAC=valac

sources:
	$(VALAC) --library $(LIBNAME).so -o $(LIBNAME).so -X -fPIC -X --shared $(SOURCE_FILES) --vapi $(NAME).vapi -H $(NAME).h
