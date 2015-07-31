#!/bin/bash
# Script para correr los test
clear
echo $'\n------ Compilando el proyecto ------\n'
make all

sleep 1

echo $'\n------ Corriendo los test ------\n'
cd test && make
./test --verbose
