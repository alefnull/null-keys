ReadConfig(key) {
    IniRead value, %A_ScriptFullPath%, config, %key%
    return %value%
}

WriteConfig(key, value) {
    IniWrite %value%, %A_ScriptFullPath%, config, %key%
}

DefaultConfig() {
    IniWrite 0, %A_ScriptFullPath%, config, brewing
    IniWrite 0, %A_ScriptFullPath%, config, canceled
}

ReloadScript() {
    WriteConfig("reloading", 1)
    Notify().Toast(" reloading script ",{Color:"0xFF4444"})
    Sleep 2000
    Reload
}

GuiDestroyAll(){
   dhwSetting := A_DetectHiddenWindows
   DetectHiddenWindows On
   PID := DllCall("GetCurrentProcessId", "UInt")
   WinGet, guiList, List, ahk_class AutoHotkeyGUI ahk_pid %PID%
   Loop, %guiList%
      Gui % guiList%A_Index% . ":Destroy"
   DetectHiddenWindows, %dhwSetting%
   return guiList
}

TeaTimer(mins) {
    totalSeconds := mins * 60
    milli := totalSeconds * 1000
    endTime := A_TickCount + (totalSeconds*1000)
    isBrewing := ReadConfig("brewing")
    if (isBrewing = 0) {
        WriteConfig("brewing", 1)
        Notify().Toast(" starting tea timer: " . mins . " min ",{Color:"0xFF44FF"})
        Gui New,hwndTeaTimer
        Gui +E0x20 -Caption +AlwaysOnTop +Owner +LastFound
        WinSet Transparent, 150
        Gui Color, FF00FF
        While (A_TickCount <= endTime) {
            isCanceled := ReadConfig("canceled")
            if (isCanceled = 1) {
                WriteConfig("brewing", 0)
                WriteConfig("canceled", 0)
                GuiDestroyAll()
                Notify().Toast(" why would you cancel a tea timer? ",{Color:"0xFF44FF"})
                Goto break_outer
            }
            width := A_ScreenWidth * (1 - (endTime - A_TickCount)/milli)
            Gui, Show, x0 y0 w%width% h25 NA
            Sleep 20
        }
        Gui Destroy
        WriteConfig("brewing", 0)
        Notify().Toast(" your tea is (probably) ready ",{Color:"0xFF44FF"})
    } else {
        WriteConfig("canceled", 1)
    }
    break_outer:
}

MouseIsOver(WinTitle) {
    MouseGetPos ,,,Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

Swapp(WinTitle, Target) {
    if WinExist(WinTitle) {
        if WinActive(WinTitle) {
            WinMinimize
        } else {
            WinGet hWnd, ID, %WinTitle%
            DllCall("SetForegroundWindow", UInt, hWnd)
            Sleep 150
            WinGet WinId, ID, %WinTitle%
            DllCall("SwitchToThisWindow", "UInt", WinId, "UInt", 1)
        }
    } else {
        if (Target = wt.exe) {
            Run *RunAs wt.exe
        } else {
            Run %Target%
            WinWait %WinTitle%
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