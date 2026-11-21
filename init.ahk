#Requires AutoHotkey v2.0

#Include %A_ScriptDir%\fullscreen.ahk
#Include %A_ScriptDir%\keybind.ahk
; #Include %A_ScriptDir%\wm_init.ahk
Run Format('*UIAccess "{1}\wm_init.ahk"', A_ScriptDir)
