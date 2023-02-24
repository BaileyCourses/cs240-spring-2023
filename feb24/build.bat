@echo off

SET INCLUDE=E:\Masm611\INCLUDE;E:\CLASS\INCLUDE;NOTES
SET LIB=E:\Masm611\LIB;E:\CLASS\LIB

ML -c -nologo demo.asm

if errorlevel 1 goto terminate

cd notes
ML -c -nologo lib.asm
cd ..

if errorlevel 1 goto terminate

LINK demo notes\lib,,NUL,CS240;

:terminate
