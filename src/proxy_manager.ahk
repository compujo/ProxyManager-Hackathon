#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#persistent

;---- Settings ------

proxytxtURL := "http://proxy-ip-list.com/download/free-usa-proxy-ip.txt" ;Doesn't work yet
backendURL := "http://test.ineedabetterdomainna.me/hackathon/proxy/"
tempfile := "data\temp"

;----End Settings----


Menu, Tray, NoStandard

menu, tray, add, Open GUI, opengui

menu, tray, add, Autoselect Proxy, ButtonAutoselectProxy
menu, tray, add, Enable Proxy, enablep
menu, tray, add, Disable Proxy, ButtonDisableProxies
menu, tray, add, Edit Proxy List, ButtonEditProxyList
menu, tray, add, Fastest Proxies, ButtonPingRankings
menu, tray, add, Reload Script, reload2

menu,tray, default, Open GUI

menu, tray, add,

Menu, tray, Standard

urldownloadtofile, %backendURL%outfile.txt, data\outfile.txt


Run, lib\ProxyPinger.exe "%proxytxtURL%",,Hide

FileRead, iplist, lib\iplist.txt
StringReplace, iplist2, iplist, `n, @, All
urldownloadtofile, %backendURL%?puthosts=true&hosts=%iplist2%, %tempfile%
urldownloadtofile, %backendURL%?exec=true, %tempfile%

urldownloadtofile, %backendURL%outfile.txt, data\outfile.txt

Run ruby lib\ping_rank.rb,,hide

goto opengui ;EXITS PROGRAM

return

ButtonAutoselectProxy:
Run, ruby lib\enable_proxy.rb, ,Hide

FileRead, selected_proxy, data\selectedproxy.txt

RunWait, ruby lib\proxy_set.rb %selected_proxy%, ,Hide
;TrayTip, , Please restart your programs using the proxy

Gui, Add, Text, x46 y73 w350 h40 , Now using: %selected_proxy%`r`nPlease restart your proxy-enabled programs

Run, lib\ProxyPinger.exe "%proxytxtURL%",,Hide

FileRead, iplist, lib\iplist.txt
StringReplace, iplist2, iplist, `n, @, All
urldownloadtofile, %backendURL%?puthosts=true&hosts=%iplist2%, %tempfile%
urldownloadtofile, %backendURL%?exec=true, %tempfile%

urldownloadtofile, %backendURL%outfile.txt, data\outfile.txt

Run ruby lib\ping_rank.rb,,hide
return

enablep:
Run, ruby lib\enable_proxy.rb,, hide
return

ButtonDisableProxies:
RunWait, ruby lib\disable_proxy.rb,,hide
;TrayTip, , Please restart your programs using the proxy
return

ButtonEditProxyList:
Run,open data\proxylist.txt
return

ButtonPingRankings:
FileRead, ranksout, data\proxylist.txt
Gui, Add, Text, x46 y167 w430 h180 , %ranksout%

Run, lib\ProxyPinger.exe "%proxytxtURL%",,Hide

FileRead, iplist, lib\iplist.txt
StringReplace, iplist2, iplist, `n, @, All
urldownloadtofile, %backendURL%?puthosts=true&hosts=%iplist2%, %tempfile%
urldownloadtofile, %backendURL%?exec=true, %tempfile%

urldownloadtofile, %backendURL%outfile.txt, data\outfile.txt

Run ruby lib\ping_rank.rb,,hide
return

opengui:
Gui, Add, Button, x36 y13 w100 h40 , Autoselect Proxy
Gui, Add, Button, x286 y13 w110 h40 , Edit Proxy List
Gui, Add, Button, x156 y13 w120 h40 , Disable Proxies

Gui, Add, Button, x166 y117 w100 h30 , Ping Rankings

; Generated using SmartGUI Creator 4.0
Gui, Show, h353 w438, Proxy Manager
Return

GuiClose:
Gui, Hide
return

reload2:
reload
return