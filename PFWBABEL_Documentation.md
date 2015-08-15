# Introduction #
This bat (Windows XP cmd.exe compatible) can create firewall rules for Windows XP firewall and VirtualBox guest VMs.
## Usage ##
```
pfwbabel.bat [ [ /SCRIPT ] /DELETE ] [ VM_NAME ] <PORTS_FORWARD_FILE [ >SCRIPT_FILE.BAT ]
```
### Parameters ###
  * **`/SCRIPT`:** script commands generation only, no execution; must be first param.
  * **`/DELETE`**: rules deletion mode; must be 1st param (2nd if /SCRIPT was given).
  * **`<PORTS_FORWARD_FILE`**: standard input redirection, where ports info are given.
  * **`>SCRIPT_FILE.BAT`**: standard output redirection, usefull to record script for later use.
Obs: if `/SCRIPT` is given, rules are not executed, and a script containing the necessary comands are written to STDOUT. A script created with `/SCRIPT` and `/DELETE` can only perform rules reletion.
### Ports Forward File ###
The standard input is read to obtain all ports to be forwarded between LAN/Internet and guest VM, using the following format:
```
<PROTOCOL> <PORT> <DESCRIPTION>
{ ; | # } <ONE_LINE_COMMENT>
```
  * **`PROTOCOL`**: either `UDP` or `TCP`
  * **`PORT`**: port number
  * **`DESCRIPTION`**: free description for Windows Firewall rule
Obs: lines beginning by ";" or "#" followed by a blank space are not considered. Rules in VirtualBox have scandard names like: `<PROTOCOL>_<PORT>`. Ex: `TCP_80`.
## Example ##
To create rules to a web server hosted by WINXPVM virtual machine at port #80, TCP protocol:
```
pfwbabel WINXPVM
TCP 80 Web Server
^Z
```
Create a script file "pf\_del\_www.bat" to delete rules from web server hosted by VM called WINXPVM:
```
pfwbabel /SCRIPT /DELETE WINXPVM >pf_del_www.bat
WINXPVM:
TCP 80 Web Server
^Z
```