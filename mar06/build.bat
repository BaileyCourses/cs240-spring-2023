@echo off

SET INCLUDE=E:\Masm611\INCLUDE;E:\CLASS\INCLUDE;NOTES
SET LIB=E:\Masm611\LIB;E:\CLASS\LIB

ML -c -nologo game.asm
ML -c -nologo alarms.asm

if errorlevel 1 goto terminate

cd notes
ML -c -nologo lib.asm
ML -c -nologo gamelib.asm
cd ..

if errorlevel 1 goto terminate

LINK game alarms notes\lib notes\gamelib,,NUL,CS240;

:terminate
