; 依赖于 https://github.com/FuPeiJiang/VD.ahk/tree/v2_port
#Include %A_ScriptDir%\resources\lib\VD.ah2

DeskMove(targetDesktop) {
  Run VD.goToDesktopNum(targetDesktop + 1)
}

WinMoveToDesk(targetDesktop) {
  Run VD.MoveWindowToDesktopNum("A", targetDesktop + 1).follow()
}
