; Win -> '#', Alt -> '!', Shift -> '+', Control -> '^'
; LXX -> '<XX', RXX -> '>XX'

#c:: Run "Chrome"
#Enter:: Run "wt"

; 依赖于 https://github.com/daipeihust/im-select
~Shift:: {
  if (WinActive("Minecraft")) {
    ; MsgBox("hh")
    return
  }
  SetTimer SwitchIm, 10
  SwitchIm() {
    ; 如果任意键被按下，则不执行
    if (!GetKeyState("Shift", "P")) {
      SetTimer , 0
      if (A_Priorkey = "LShift" or A_Priorkey = "RShift") {
        RunWait A_ScriptDir "\resources\bin\im-select.exe local", , "Hide"
      }
      return
    }
  }
}

#+Up::Volume_Up
#+Down::Volume_Down