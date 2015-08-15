# Introduction #
This bat (Windows XP cmd.exe compatible) can create register setup commands to prevent the automatic execution procedures on removable media, as a means to avoid software virus and malware. The output can be redirected to a file that can be executed on multiple computers.
See the [Autorun](http://en.wikipedia.org/wiki/Autorun) article at [Wikipedia.org](http://wikipedia.org).
## Usage ##
```
autorun_disable.bat [ [ /DISABLE ][ >SCRIPT_FILE.BAT ]
```
### Parameters ###
  * **`/DISABLE`**: optional, default parameter, requesting to generate commands that will disable autorun procedures. /ENABLE flag not permited since this script is yet capable of generating (re)enabling commands.
## Example ##
To create a script with commands to disable autorun procedures:
```
C:\> autorun_disable.bat >disable_script.bat
Copyright 2009, Joner Cyrre Worm. Some rights reserved.
This program is licensed with the GNU GPL version 2 or newer,
the General Public License as published by the Free Software Foundation.
C:\> type disable_script.bat
reg.exe ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HonorAutoRunSetting  /T REG_DWORD  /D 0x00000001  /F
reg.exe ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoDriveTypeAutoRun  /T REG_DWORD  /D 0x000000ff  /F
reg.exe ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoDriveAutoRun  /T REG_DWORD  /D 0x0003ffff  /F
reg.exe ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoAutoRun  /T REG_DWORD  /D 0x00000001  /F
reg.exe ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HonorAutoRunSetting  /T REG_DWORD  /D 0x00000001  /F
reg.exe ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoDriveTypeAutoRun  /T REG_DWORD  /D 0x000000ff  /F
reg.exe ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoDriveAutoRun  /T REG_DWORD  /D 0x0003ffff  /F
reg.exe ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V NoAutoRun  /T REG_DWORD  /D 0x00000001  /F
reg.exe ADD "HKLM\SYSTEM\CurrentControlSet\Services\Cdrom" /V AutoRun  /T REG_DWORD  /D 0x00000000  /F
reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf" /VE      /T REG_SZ    /D "@SYS:DoesNotExist" /F

```