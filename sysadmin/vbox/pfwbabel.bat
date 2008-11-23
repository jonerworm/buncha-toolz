@echo off
rem ====================================================================
rem pfwbabel - multi-firewall port forwarding configurator
echo pfwbabel - multi-firewall port forwarding configurator >&2
rem Another product from Buncha-toolz!
rem Copyright 2008, Joner Cyrre Worm.
echo Copyright 2008, Joner Cyrre Worm. >&2
rem http://www.worm.sh
rem
rem $Id$
rem
rem This program is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with this program.  If not, see http://www.gnu.org/licenses/.
rem ====================================================================
rem
rem Write to STDOUT commands to configure Windows and Virtualbox firewall
rem
rem Read from STDIN port forwarding parameters in this format:
rem
rem PROTOCOL PORT DESCRIPTION
rem
rem PROTOCOL = TCP or UDP
rem
rem PORT = port number
rem
rem DESCRIPTION = text with up to 6 words
rem
rem To generate deletion rules, use the /DELETE parameter/DELETE
rem
rem To inform an extra info (such as virtual machine name),
rem pass it as a paramter (after /DELETE if this is the case).
rem
rem Lines beginning with "#" or ";" are comments
rem
set TMPFIL=%TEMP%\pfb_%RANDOM%.TMP
sort >"%TMPFIL%"

for /F "usebackq tokens=1,2*" %%X in (`reg query "hklm\software\innotek\virtualbox"  /v InstallDir`) do if "%%X"=="InstallDir" SET VBXPATH=%%Z

set VBXBIN=%VBXPATH%\vboxmanage.exe

if "%1"=="/DELETE" goto DEL
if "%1"=="/DEL" goto DEL
if "%1"=="/D" goto DEL

set TARGET=%1
set MODE=ADD

goto PROCESS


:DEL
set MODE=DEL
set TARGET=%2

goto PROCESS

:PROCESS

set NOTARGET=_#_NO_TARGET_#_

if "%TARGET%"=="" set TARGET=%NOTARGET%


echo @echo off
echo rem ===================================================================================
echo rem Automatically created by %0 - pfwbabel: multi-firewall port forwarding configurator
echo rem Another product from Buncha-toolz!
echo rem Copyright 2008, Joner Cyrre Worm.
echo rem http://www.worm.sh
echo.
echo rem ============ WINDOWS FIREWALL THROUGH NETSH
echo Generating Windows firewall configuration... >&2
echo echo Configuring Windows firewall through NETSH...
echo.
for /F "usebackq tokens=1,2*" %%X in (`type "%TMPFIL%"`) do call :WINXP %MODE% %%X %%Y %%Z

echo echo.
echo Done. >&2
echo echo Done.

if not exist "%VBXBIN%" goto NOVBX

echo rem ============ VIRTUALBOX FIREWALL THROUGH VBOXMANAGE.EXE
echo Generating VirtualBox firewall configuration... >&2
echo echo Configuring VirtualBox firewall through VBOXMANAGE...
echo.

if not "%TARGET%"=="%NOTARGET%" echo rem DEFAULT VIRTUAL MACHINE NAME: %TARGET%
echo rem %%1 = VIRTUAL MACHINE NAME
echo.
echo set VBXPATH=%VBXPATH%
echo set VBXBIN=%%VBXPATH%%vboxmanage.exe
echo if not exist "%%VBXBIN%%" goto NOVBX
echo.

if "%TARGET%"=="%NOTARGET%" echo set TARGET=%%1
if not "%TARGET%"=="%NOTARGET%" echo set TARGET=%TARGET%

echo if not "%%1"=="" set TARGET=%%1

echo if "%%TARGET%%"=="" goto NOTARGET
echo.

for /F "usebackq tokens=1,2*" %%X in (`type "%TMPFIL%"`) do call :VBX %MODE% %%%%TARGET%%%% %%X %%Y %%Z

echo.
echo echo.
echo echo Done.
echo.
echo goto END
echo.
echo :NOTARGET
echo echo Virtual Machine name missing, pass it as a command line parameter. ^>^&2
echo goto END
echo.
echo :NOVBX
echo echo VIRTUAL BOX NOT FOUND (%%VBXBIN%%) ^>^&2
echo goto END
echo.
echo :END
echo.

echo Done. >&2


goto END


rem ======== VIRTUAL BOX =========

:VBX

set OPR=%1
set GUEST=%2
set PROTO=%3

if "%PROTO%"=="#" goto VBXEND
if "%PROTO%"==";" goto VBXEND

set PORT=%4
set SERVICE=%PROTO%_%PORT%

if not "%OPR%"=="DEL" goto VBXPROCESS

set PROTO=
set PORT=

goto VBXPROCESS

:VBXPROCESS

echo "%%VBXBIN%%" -nologo setextradata "%GUEST%" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/%SERVICE%/Protocol" %PROTO%
echo "%%VBXBIN%%" -nologo setextradata "%GUEST%" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/%SERVICE%/GuestPort" %PORT%
echo "%%VBXBIN%%" -nologo setextradata "%GUEST%" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/%SERVICE%/HostPort" %PORT%

goto VBXEND


:VBXEND

goto END



rem ======== WINDOWS =========

:WINXP

set OPR=%1
set PROTO=%2


if "%PROTO%"=="#" goto WINXPEND
if "%PROTO%"==";" goto WINXPEND

set PORT=%3

if "%OPR%"=="DEL" goto WINXPDEL

set REST=%4

if not "%5"=="" set REST=%REST% %5
if not "%6"=="" set REST=%REST% %6
if not "%7"=="" set REST=%REST% %7
if not "%8"=="" set REST=%REST% %8
if not "%9"=="" set REST=%REST% %9

echo netsh.exe FIREWALL ADD PORTOPENING %PROTO% %PORT% "%REST% (%PORT%/%PROTO%)" ENABLE

goto WINXPEND


:WINXPDEL

echo FIREWALL DELETE PORTOPENING %2 %3

goto WINXPEND


:WINXPEND

goto END


:NOVBX
echo No VirtualBox installation found. >&2
echo echo No VirtualBox installation found.

goto END



:END
