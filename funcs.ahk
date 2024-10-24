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
}

ReloadScript()
{
    WriteConfig("reloading", true)
    Sleep 750
    Reload
}

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

DesktopIcons(Show:=-1, hWnd:=0)
{ ; By SKAN on D35D @ tiny.cc/desktopicons
    If ! hWnd := DllCall("GetWindow", "Ptr",WinExist("ahk_class Progman"), "UInt",5, "Ptr")
        hWnd := DllCall("GetWindow", "Ptr",WinExist("ahk_class WorkerW"), "UInt",5, "Ptr")
    If DllCall("IsWindowVisible", "Ptr",DllCall("GetWindow","Ptr",hWnd, "UInt",5, "Ptr")) != Show
        DllCall("SendMessage","Ptr",hWnd, "Ptr",0x111, "Ptr",0x7402, "Ptr",0)
}

SHQueryRecycleBin(RootPath, ByRef Size, ByRef NumItems)
{
    VarSetCapacity(SHQueryRBInfo, 20, 0)
    NumPut(20, SHQueryRBInfo, 0, "UInt")
    HR := DllCall("Shell32.dll\SHQueryRecycleBin", "Str", RootPath, (A_PtrSize = 8 ? "Ptr" : "UInt"), &SHQueryRBInfo, "UInt")
    Size := NumGet(SHQueryRBInfo, (A_PtrSize = 8 ? 8 : 4), "Int64")
    NumItems := NumGet(SHQueryRBInfo, (A_PtrSize = 8 ? 16 : 12), "Int64")
    return HR
}

FormatByteSize(Bytes)
{
    static size:="bytes,KB,MB,GB,TB,PB,EB,ZB,YB"
    Loop,Parse,size,`,
        If (bytes>999)
            bytes:=bytes/1024
        else {
            bytes:=Trim(SubStr(bytes,1,4),".") " " A_LoopField
            break
        }
    return bytes
}
