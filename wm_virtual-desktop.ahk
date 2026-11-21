; 依赖于 https://github.com/MScholtes/VirtualDesktop
; 依赖于 https://github.com/FuPeiJiang/VD.ahk/tree/v2_port
#Include %A_ScriptDir%\resources\lib\VD.ah2

DeskMove(targetDesktop) {
  ; RunWait A_ScriptDir "\resources\bin\VirtualDesktop11-24H2.exe anim:0 s:" targetDesktop ,,"Hide"
  Run VD.goToDesktopNum(targetDesktop + 1)
}

WinMoveToDesk(targetDesktop) {
  ; RunWait A_ScriptDir "\resources\bin\VirtualDesktop11-24H2.exe gd:" targetDesktop " maw" ,,"Hide"
  Run VD.MoveWindowToDesktopNum("A", targetDesktop + 1).follow()
}
