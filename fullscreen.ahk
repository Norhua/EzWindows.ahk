#Requires AutoHotkey v2.0

; 全屏检测排除列表
; 列表中的应用即使处于全屏状态（如火狐、Edge 等浏览器 F11 全屏或全屏播放视频），也不会使快捷键失效
; 支持填写进程名称（如 "firefox.exe"、"msedge.exe"）或窗口匹配规则（如 "ahk_class MozillaWindowClass"）
global FullScreenExcludeList := [
  "firefox.exe",
  "msedge.exe",
  "chrome.exe"
]

; 定时检测当前活动窗口是否为全屏应用，若是则暂停（Suspend）当前 AHK 脚本的所有按键绑定
SetTimer(CheckFullScreen, 250)

CheckFullScreen() {
  shouldSuspend := IsFullScreenAppActive()
  if (A_IsSuspended != shouldSuspend) {
    Suspend(shouldSuspend)
  }
}

IsFullScreenAppActive() {
  hwnd := WinExist("A")
  if !hwnd {
    return false
  }

  try {
    winClass := WinGetClass(hwnd)
    ; 排除 Windows 桌面与任务栏
    if (winClass = "Progman" || winClass = "WorkerW" || winClass = "Shell_TrayWnd" || winClass = "Shell_SecondaryTrayWnd") {
      return false
    }

    ; 检查是否在排除列表中
    procName := ""
    try {
      procName := WinGetProcessName(hwnd)
    }
    for item in FullScreenExcludeList {
      if ((procName != "" && (StrLower(procName) = StrLower(item) || StrLower(procName) = StrLower(item . ".exe")))
        || WinActive(item)) {
        return false
      }
    }

    ; 获取窗口样式与尺寸
    style := WinGetStyle(hwnd)
    ; WS_MINIMIZE (0x20000000) | WS_BORDER (0x00800000)
    ; 普通窗口和普通最大化窗口均带有 WS_BORDER 样式，而全屏应用无边框
    if (style & 0x20800000) {
      return false
    }

    WinGetPos(&winX, &winY, &winW, &winH, hwnd)

    ; 获取当前窗口所在显示器的屏幕区域（支持多显示器）
    hMon := DllCall("User32\MonitorFromWindow", "Ptr", hwnd, "UInt", 2, "Ptr") ; MONITOR_DEFAULTTONEAREST = 2
    monInfo := Buffer(40, 0)
    NumPut("UInt", 40, monInfo, 0)
    if (hMon && DllCall("User32\GetMonitorInfo", "Ptr", hMon, "Ptr", monInfo)) {
      monLeft   := NumGet(monInfo, 4, "Int")
      monTop    := NumGet(monInfo, 8, "Int")
      monRight  := NumGet(monInfo, 12, "Int")
      monBottom := NumGet(monInfo, 16, "Int")
      monW := monRight - monLeft
      monH := monBottom - monTop
    } else {
      monLeft := 0
      monTop  := 0
      monW := A_ScreenWidth
      monH := A_ScreenHeight
    }

    return (winX <= monLeft && winY <= monTop && winW >= monW && winH >= monH)
  } catch {
    return false
  }
}

#HotIf !IsFullScreenAppActive()
