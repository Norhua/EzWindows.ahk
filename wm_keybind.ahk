; WM 窗口与虚拟桌面管理按键绑定
; Win -> '#', Alt -> '!', Shift -> '+', Control -> '^'
; LXX -> '<XX', RXX -> '>XX'

; 窗口基础操作
#q:: PostMessage 0x0112, 0xF060, , , "A"
#+q:: WinKill("A")
#t:: MaximizeOrRestoreWindow()

; 鼠标拖拽移动窗口与调整窗口大小
LWin & LButton:: EWD_MoveWindow()  ; 左Win键 + 左鼠标按钮移动窗口
LWin & RButton:: EWD_ReSizeWindow()  ; 左Win键 + 右鼠标按钮调整窗口大小

; 目前共有8个窗口, 标号[0-7]
; Win + 数字/字母 跳转到对应的虚拟桌面
#`:: DeskMove(0)
#1:: DeskMove(1)
#2:: DeskMove(2)
#3:: DeskMove(3)

#0:: DeskMove(7)
#9:: DeskMove(6)

#m:: DeskMove(5)
#w:: DeskMove(4)

; Shift Win + 数字/字母 移动窗口到对应虚拟桌面
#+`:: WinMoveToDesk(0)
#+1:: WinMoveToDesk(1)
#+2:: WinMoveToDesk(2)
#+3:: WinMoveToDesk(3)

#+0:: WinMoveToDesk(7)
#+9:: WinMoveToDesk(6)

#+m:: WinMoveToDesk(5)
#+w:: WinMoveToDesk(4)
