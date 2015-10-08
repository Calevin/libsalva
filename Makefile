all:
	make library
	make copy_library

NAME=salva
LIBNAME=lib$(NAME)
VALAC=valac
MAYOR_VERSION=1
MINOR_VERSION=0
PATCH_VERSION=0
SONAME=lib$(NAME).so
FULL_LIBNAME=$(SONAME).$(MAYOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION)

library:
#Se compila los source como una libreria
	cd src && make

copy_library:
#Se borra la carpeta lib si existe
	rm -rf lib/
#Se crea la carpeta lib
	mkdir lib
#Se copia el .deps, el .pc a la carpeta lib
	cp $(NAME).deps lib/
	cp $(NAME).pc lib/
#Se mueve el .h, el .so. y el vapi de la carpeta src a la carpeta lib
	mv src/$(NAME).h src/$(FULL_LIBNAME) src/$(NAME).vapi lib/

clean:
#borra la lib
	rm -rf lib/

install:
	cp lib/$(FULL_LIBNAME) /usr/lib/
	cp lib/$(NAME).vapi /usr/share/vala/vapi
	cp lib/$(NAME).deps /usr/share/vala/vapi
	cp lib/$(NAME).h /usr/include
	cp lib/$(NAME).pc /usr/lib/pkgconfig/
	ln -sf /usr/lib/$(FULL_LIBNAME) /usr/lib/$(SONAME).$(MAYOR_VERSION).$(MINOR_VERSION)
	ln -sf /usr/lib/$(SONAME).$(MAYOR_VERSION).$(MINOR_VERSION) /usr/lib/$(SONAME).$(MAYOR_VERSION)
	ln -sf /usr/lib/$(SONAME).$(MAYOR_VERSION) /usr/lib/$(SONAME)

uninstall:
	rm -f /usr/lib/$(FULL_LIBNAME)
	rm -f /usr/share/vala/vapi/$(NAME).vapi
	rm -f /usr/share/vala/vapi/$(NAME).deps
	rm -f /usr/include/$(NAME).h
	rm -f /usr/lib/pkgconfig/$(NAME).pc
	rm -f /usr/lib/$(SONAME).$(MAYOR_VERSION).$(MINOR_VERSION)
	rm -f /usr/lib/$(SONAME).$(MAYOR_VERSION)
	rm -f /usr/lib/$(SONAME)
