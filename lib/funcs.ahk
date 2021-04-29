CheckConfig()
{
    FileRead, this_script, %A_ScriptFullPath%
    found := InStr(this_script, "[config]")
    return found = 0 ? false : true
}

ReadConfig(key)
{
    IniRead value, %A_ScriptFullPath%, config, %key%
    return %value%
}

WriteConfig(key, value)
{
    IniWrite %value%, %A_ScriptFullPath%, config, %key%
}

ResetConfig()
{
    IniWrite 0, %A_ScriptFullPath%, config, reloading
    IniWrite 0, %A_ScriptFullPath%, config, brewing
    IniWrite 0, %A_ScriptFullPath%, config, canceled
}

ReloadScript()
{
    WriteConfig("reloading", true)
    Sleep 750
    Reload
}

ClickDrag()
{
    if (GetKeyState("RButton", "P"))
    {
        MouseGetPos,,, win_id
        WinGetTitle, win_title, ahk_id %win_id%
        if (win_title = "hwndNotes") {
            PostMessage, 0x0A1, 2,,, ahk_id %win_id%
            return 1
        }
    }
}

;WinMove()
;{
    ;GuiGetPos(gui_x, gui_y, gui_w, gui_h)
;}

;GuiGetPos( ByRef gui_x, ByRef gui_y, ByRef gui_w, ByRef gui_h ) {
	;Gui hwndNotes:+LastFoundExist
	;IfWinExist
	;{
		;WinGetPos gui_x, gui_y
		;VarSetCapacity( rect, 16, 0 )
		;DllCall("GetClientRect", uint, gui_hwnd := WinExist(), uint, &rect )
		;gui_w := NumGet( rect, 8, "int" )
		;gui_h := NumGet( rect, 12, "int" )
	;}
;}

GuiDestroyAll()
{
    dhw_setting := A_DetectHiddenWindows
    DetectHiddenWindows On
    PID := DllCall("GetCurrentProcessId", "UInt")
    WinGet, gui_list, List, ahk_class AutoHotkeyGUI ahk_pid %PID%
    Loop, %gui_list%
    {
        Gui % gui_list%A_Index% . ":Destroy"
    }
    DetectHiddenWindows, %dhw_setting%
    return gui_list
}

SHQueryRecycleBin(RootPath, ByRef Size, ByRef NumItems) {
    VarSetCapacity(SHQueryRBInfo, 20, 0)
    NumPut(20, SHQueryRBInfo, 0, "UInt")
    HR := DllCall("Shell32.dll\SHQueryRecycleBin", "Str", RootPath, (A_PtrSize = 8 ? "Ptr" : "UInt"), &SHQueryRBInfo, "UInt")
    Size := NumGet(SHQueryRBInfo, (A_PtrSize = 8 ? 8 : 4), "Int64")
    NumItems := NumGet(SHQueryRBInfo, (A_PtrSize = 8 ? 16 : 12), "Int64")
    return HR
}

StrFormatByteSize(ByteSize) {
    VarSetCapacity(SizeFormat, 32)
    DllCall("Shlwapi.dll\StrFormatByteSize64A", "Int64", ByteSize, "UInt", &ByteSize, "UInt", 32, "Str")
    return StrGet(&ByteSize, "CP0")
}

TeaTimer(mins)
{
    total_seconds := mins * 60
    millis := total_seconds * 1000
    end_tick := A_TickCount + millis
    is_brewing := ReadConfig("brewing")
    if (is_brewing = 0)
    {
        WriteConfig("brewing", 1)
        Notify().Toast(" starting tea timer: " . mins . " min ",{Color:"0xFF44FF", Time:3000})
        Gui New,hwndTeaTimer
        Gui +E0x20 -Caption +AlwaysOnTop +Owner +LastFound
        WinSet Transparent, 150
        Gui Color, FFFFFF
        While (A_TickCount <= end_tick)
        {
            is_canceled := ReadConfig("canceled")
            if (is_canceled = 1)
            {
                WriteConfig("brewing", 0)
                WriteConfig("canceled", 0)
                GuiDestroyAll()
                Notify().Toast(" why would you cancel a tea timer? ",{Color:"0xFF44FF", Time:3000})
                Goto break_outer
            }
            width := A_ScreenWidth * (1 - (end_tick - A_TickCount)/millis)
            Gui, Show, x0 y0 w%width% h15 NA
            Sleep 20
        }
        Gui Destroy
        WriteConfig("brewing", 0)
        Notify().Toast(" your tea is (probably) ready ",{Color:"0xFF44FF", Time:3000})
    }
    else
    {
        WriteConfig("canceled", 1)
    }
    break_outer:
}

MouseIsOver(win_title)
{
    MouseGetPos ,,,win
    return WinExist(win_title . " ahk_id " . win)
}

Swapp(win_title, target_exe)
{
    if WinExist(win_title)
    {
        if WinActive(win_title)
        {
            WinMinimize
        }
        else
        {
            WinGet win_id, ID, %win_title%
            Sleep 100
            DllCall("SetForegroundWindow", UInt, win_id)
            DllCall("SwitchToThisWindow", "UInt", win_id, "UInt", 1)
        }
    }
    else
    {
        if (target_exe = wt.exe)
        {
            Run *RunAs wt.exe
        }
        else
        {
            Run %target_exe%
            WinWait %win_title%
            WinActivate
        }
    }
}

Discord()
{
    win_title = Discord ahk_class Chrome_WidgetWin_1
    target_exe = "C:\Users\alefnull\AppData\Local\Discord\app-0.0.309\Discord.exe"
    Swapp(win_title, target_exe)
}

Guilded()
{
    win_title = Guilded ahk_class Chrome_WidgetWin_1
    target_exe = "C:\Users\alefnull\AppData\Local\Programs\Guilded\Guilded.exe"
    Swapp(win_title, target_exe)
}

Firefox()
{
    win_title = Mozilla Firefox ahk_class MozillaWindowClass
    target_exe = "C:\Program Files\Mozilla Firefox\firefox.exe"
    Swapp(win_title, target_exe)
}

Terminal()
{
    win_title = ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    target_exe = wt.exe
    Swapp(win_title, target_exe)
}