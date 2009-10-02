@echo off

call :COPYLEFT >&2

rem Copyright 2009, Joner Cyrre Worm. Some rights reserved.
rem This program is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See therem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with this program.  If not, see http://www.gnu.org/licenses/.

if "%1" == "/?" then goto USAGE
if "%1" == "/e" then goto ENABLE
if "%1" == "/E" then goto ENABLE
if "%1" == "/enable" then goto ENABLE
if "%1" == "/ENABLE" then goto ENABLE
if "%1" == "/d" then goto DISABLE
if "%1" == "/D" then goto DISABLE
if "%1" == "/disable" then goto DISABLE
if "%1" == "/DISABLE" then goto DISABLE

set MODE=DISABLE
goto PARAM

rem ---------------------------
:ENABLE

echo Enable action not implemented. Sorry. >&2

goto END

rem ---------------------------
:DISABLE

shift
set MODE=DISABLE
goto PARAM

rem ---------------------------
:PARAM

if not "%1" == "" goto USAGE

goto EXEC

rem ---------------------------
:EXEC

set KEY=Software\Microsoft\Windows\CurrentVersion\Policies\Explorer

set HIV=HKCU
call :REG_ADD_NOAR

set HIV=HKLM
call :REG_ADD_NOAR

set KEY=SYSTEM\CurrentControlSet\Services\Cdrom
set HIV=HKLM
call :REG_ADD_NOCDAR

set KEY=SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf
set HIV=HKLM
call :REG_ADD_NOARINF

goto END

rem ---------------------------
:REG_ADD_NOAR

call :REG_EXE_ADD "%HIV%\%KEY%" HonorAutoRunSetting REG_DWORD 0x00000001
call :REG_EXE_ADD "%HIV%\%KEY%" NoDriveTypeAutoRun  REG_DWORD 0x000000ff
call :REG_EXE_ADD "%HIV%\%KEY%" NoDriveAutoRun      REG_DWORD 0x0003ffff
call :REG_EXE_ADD "%HIV%\%KEY%" NoAutoRun           REG_DWORD 0x00000001


goto END


rem ---------------------------
:REG_ADD_NOCDAR

call :REG_EXE_ADD "%HIV%\%KEY%" AutoRun REG_DWORD 0x00000000

goto END


rem ---------------------------
:REG_ADD_NOARINF

call :REG_EXE_ADD "%HIV%\%KEY%" /VE REG_SZ "@SYS:DoesNotExist"

goto END

rem ---------------------------
:REG_EXE_ADD

set HIVKEY=%1
set V=%2
set T=%3
set D=%4
if "%V%"=="/VE" echo reg.exe ADD "%HIV%\%KEY%" /VE      /T %T%    /D %D% /F
if not "%V%"=="/VE" echo reg.exe ADD "%HIV%\%KEY%" /V %V%  /T %T%  /D %D%  /F

goto END

rem ---------------------------
:USAGE

echo.
echo Usage:
echo.
echo %0 [ /D[ISABLE] ]
echo.
echo Default is /DISABLE. /ENABLE is not implemented.
echo.
echo Disables some possible AutoRun capabilities as described by
echo http://en.wikipedia.org/wiki/Autorun

goto END

:COPYLEFT
echo Copyright 2009, Joner Cyrre Worm. Some rights reserved.
echo This program is licensed with the GNU GPL version 2 or newer,
echo the General Public License as published by the Free Software Foundation.

rem ---------------------------
:END

