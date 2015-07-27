all:
	make library
	make copy_library

NAME=salva
LIBNAME=lib$(NAME)
VALAC=valac

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
	mv src/$(NAME).h src/$(LIBNAME).so src/$(NAME).vapi lib/

clean:
#borra la lib
	rm -rf lib/

install:
	cp lib/$(LIBNAME).so /usr/lib/
	cp lib/$(NAME).vapi /usr/share/vala/vapi
	cp lib/$(NAME).deps /usr/share/vala/vapi
	cp lib/$(NAME).h /usr/include
	cp lib/$(NAME).pc /usr/lib/pkgconfig/

uninstall:
	rm -f /usr/lib/$(LIBNAME).so
	rm -f /usr/share/vala/vapi/$(NAME).vapi
	rm -f /usr/share/vala/vapi/$(NAME).deps
	rm -f /usr/include/$(NAME).h
	rm -f /usr/lib/pkgconfig/$(NAME).pc
