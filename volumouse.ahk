#If MouseIsOver("ahk_class Shell_TrayWnd")
MButton::Send {Volume_Mute}
WheelUp::Send {Volume_Up 5}
WheelDown::Send {Volume_Down 5}
#If

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}