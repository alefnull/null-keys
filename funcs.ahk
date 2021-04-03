MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

ReloadScript() {
    CornerNotify("reloading updated script", "autoexec.ahk", "b r", 3)
	Sleep 2000
	Reload
}

TeaTimer(Mins) {
    totalSeconds := Mins * 60
    endTime := A_TickCount + (totalSeconds*1000)
    CornerNotify("tea timer", "starting tea timer: " . Mins . " min", "b r", 3)
    Loop
    {
        Sleep 1000
        If (A_TickCount >= endTime)
        {
            Break
        }
    }
    CornerNotify("tea timer", "your tea is (probably) ready", "b r", 3)
}

Swapp(WinTitle, Target) {
    if WinExist(WinTitle) {
        if WinActive(WinTitle) {
            WinMinimize
        } else {
            ; WinActivate, %WinTitle%
            ; WinGet, hWnd, ID, %WinTitle%
            ; DllCall("SetForegroundWindow", UInt, hWnd)
            ; Sleep, 150
            WinGet, WinId, ID, %WinTitle%
            DllCall("SwitchToThisWindow", "UInt", WinId, "UInt", 1)
        }
    } else {
        if (Target = wt.exe) {
            Run, ^RunAs wt.exe
        } else {
            Run, %Target%
            WinWait, %WinTitle%
            WinActivate
        }
    }
}

discord() {
    WinTitle = Discord ahk_class Chrome_WidgetWin_1
    Target = "C:\Users\alefnull\AppData\Local\Discord\app-0.0.309\Discord.exe"
    Swapp(WinTitle, Target)
}

guilded() {
    WinTitle = Guilded ahk_class Chrome_WidgetWin_1
    Target = "C:\Users\alefnull\AppData\Local\Programs\Guilded\Guilded.exe"
    Swapp(WinTitle, Target)
}

firefox() {
    WinTitle = Firefox ahk_class MozillaWindowClass
    Target = "C:\Program Files\Mozilla Firefox\firefox.exe"
    Swapp(WinTitle, Target)
}

notepad() {
    WinTitle = Notepad ahk_class Notepad
    Target = "C:\Windows\notepad.exe"
    Swapp(WinTitle, Target)
}

terminal() {
    WinTitle = ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    Target = wt.exe
    Swapp(WinTitle, Target)
}