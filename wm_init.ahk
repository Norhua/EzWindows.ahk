#Requires AutoHotkey v2.0

; WM -- Window Manager
; 桌面和窗口管理
; 提供虚拟桌面切换, 鼠标移动窗口位置调整窗口大小功能

#Include %A_ScriptDir%\fullscreen.ahk

#q:: PostMessage 0x0112, 0xF060, , , "A"
#+q:: WinKill("A")

#t::
MaximizeOrRestoreWindow(*) {
  winMinMax := WinGetMinMax("A")
  if (winMinMax = 1) {
    WinRestore "A"
  } else if (winMinMax = 0) {
    WinMaximize "A"
  }
}

#Include %A_ScriptDir%\wm_virtual-desktop.ahk
#Include %A_ScriptDir%\wm_mouse-easy-window.ahk
