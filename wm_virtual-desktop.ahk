; 依赖于 https://github.com/MScholtes/VirtualDesktop
; 依赖于 https://github.com/FuPeiJiang/VD.ahk/tree/v2_port
#Include %A_ScriptDir%\resources\lib\VD.ah2
DeskMove(targetDesktop) {

  ; RunWait A_ScriptDir "\resources\bin\VirtualDesktop11-24H2.exe anim:0 s:" targetDesktop ,,"Hide"
  Run VD.goToDesktopNum(targetDesktop + 1)
}
; 目前共有8个窗口, 标号[0-7]
; Win + 数字/字母 跳转到对应的虚拟桌面
#1:: DeskMove(0)
#2:: DeskMove(1)
#3:: DeskMove(2)
#4:: DeskMove(3)

#0:: DeskMove(7)
#9:: DeskMove(6)

#m:: DeskMove(5)
#w:: DeskMove(4)


WinMoveToDesk(targetDesktop) {
  ; RunWait A_ScriptDir "\resources\bin\VirtualDesktop11-24H2.exe gd:" targetDesktop " maw" ,,"Hide"
  Run VD.MoveWindowToDesktopNum("A", targetDesktop + 1).follow()
}
; Shift Win + 数字/字母 移动窗口到对应虚拟桌面
#+1:: WinMoveToDesk(0)
#+2:: WinMoveToDesk(1)
#+3:: WinMoveToDesk(2)
#+4:: WinMoveToDesk(3)

#+0:: WinMoveToDesk(7)
#+9:: WinMoveToDesk(6)

#+m:: WinMoveToDesk(5)
#+w:: WinMoveToDesk(4)