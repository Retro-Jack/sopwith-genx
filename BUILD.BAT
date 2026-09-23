@echo off
set PATH=C:\PROG
echo --- assembling ---
A86 +o +c SOPASM.ASM
echo --- compiling ---
TCC -v -y -IC:\PROG\INCLUDE -LC:\PROG\LIB -c -w SOPWITH2.C
echo --- linking ---
TLINK /m /v /c C:\PROG\LIB\C0S.OBJ+SOPWITH2.OBJ+SOPASM.OBJ,SOPWITH2.EXE,SOPWITH2.MAP,C:\PROG\LIB\CS.LIB
echo --- done ---
dir SOPWITH2.EXE
