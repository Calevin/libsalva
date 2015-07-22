all:
	make sources

sources:
	rm -f ./test
	valac ../lib/salva.vapi test_main.vala una_entidad.vala -X ../lib/libsalva.so -X -I../lib -o test
