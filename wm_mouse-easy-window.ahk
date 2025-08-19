; 灵感来自于 https://wyagd001.github.io/v2/docs/scripts/index.htm#EasyWindowDrag
; 增加了右键调整窗口大小的功能

LWin & LButton::  ; 左Win键 + 左鼠标按钮热键
; 窗口移动函数
EWD_MoveWindow(*) {
  CoordMode "Mouse"  ; 切换到屏幕绝对坐标系
  MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin  ; 获取初始鼠标位置和窗口句柄
  WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY, , , EWD_MouseWin  ; 获取窗口原始位置

  ; 对于最大化窗口先还原状态
  winMinMax := WinGetMinMax(EWD_MouseWin)
  if (winMinMax = 1) {
    SetWinDelay 0  ; 设置窗口激活延迟为0
    WinActivate(EWD_MouseWin)  ; 激活窗口
    WinRestore(EWD_MouseWin)
    SetTimer EWD_WatchMouse, 10 ;  启动定时器追踪鼠标拖拽
  } else if (winMinMax = 0) {
    SetWinDelay 0
    WinActivate(EWD_MouseWin)
    SetTimer EWD_WatchMouse, 10
  }

  ; 鼠标追踪函数
  EWD_WatchMouse() {
    ; 检测鼠标左键释放 (拖拽结束)
    if !GetKeyState("LButton", "P") {
      SetTimer , 0  ; 关闭定时器
      return
    }
    ; 检测ESC键按下 (取消拖拽)
    if GetKeyState("Escape", "P") {
      SetTimer , 0  ; 关闭定时器
      WinMove EWD_OriginalPosX, EWD_OriginalPosY, , , EWD_MouseWin  ; 恢复窗口原始位置
      return
    }

    ; 根据鼠标位移实时更新窗口位置
    CoordMode "Mouse"
    MouseGetPos &EWD_MouseX, &EWD_MouseY  ; 获取当前鼠标位置
    WinGetPos &EWD_WinX, &EWD_WinY, , , EWD_MouseWin  ; 获取当前窗口位置

    SetWinDelay -1  ; 禁用窗口移动延迟
    ; 计算新窗口位置并移动
    WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX,
      EWD_WinY + EWD_MouseY - EWD_MouseStartY,
      , ,
      EWD_MouseWin

    ; 更新鼠标起始坐标
    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
  }
}


LWin & RButton::  ; 左Win键 + 左鼠标按钮热键
; 设置窗口大小函数
EWD_ReSizeWindow(*) {
  CoordMode "Mouse"
  MouseGetPos , , &EWD_MouseWin  ; 获取初始鼠标位置的窗口的句柄
  WinGetPos &EWD_WinX, &EWD_WinY, &EWD_OriginalWinWidth, &EWD_OriginalWinHeight, EWD_MouseWin  ; 获取窗口原始位置

  ; 计算窗口右下角坐标
  EWD_MouseStartX := EWD_WinX + EWD_OriginalWinWidth
  EWD_MouseStartY := EWD_WinY + EWD_OriginalWinHeight

  ; 仅在窗口非最大化状态下操作
  if !WinGetMinMax(EWD_MouseWin) {
    SetWinDelay 0
    WinActivate(EWD_MouseWin)

    MouseMove EWD_MouseStartX, EWD_MouseStartY, 0  ; 移动光标到右下角
    SetTimer EWD_WatchMouse, 10
  }

  EWD_WatchMouse() {
    if !GetKeyState("RButton", "P") {
      SetTimer , 0
      return
    }

    ; 根据鼠标位移实时调整窗口大小
    CoordMode "Mouse"
    MouseGetPos &EWD_MouseX, &EWD_MouseY  ; 获取当前鼠标位置

    SetWinDelay -1
    ; 计算新窗口位置并移动
    WinMove , ,
      EWD_OriginalWinWidth - (EWD_MouseStartX - EWD_MouseX),
      EWD_OriginalWinHeight - (EWD_MouseStartY - EWD_MouseY),
      EWD_MouseWin
  }
}