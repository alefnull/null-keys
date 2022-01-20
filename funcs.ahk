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
}

ReloadScript()
{
    WriteConfig("reloading", true)
    Sleep 750
    Reload
}

SaveNotes()
{
    ControlGetText NotesEdit
    FileDelete %A_ScriptDir%\notes.txt
    FileAppend %NotesEdit%, %A_ScriptDir%\notes.txt
}

LoadNotes()
{
    FileRead notes_content, %A_ScriptDir%\notes.txt
    GuiControl hwndNotes:, NotesEdit, %notes_content%
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

MouseIsOver(win_title)
{
    MouseGetPos ,,,win
    return WinExist(win_title . " ahk_id " . win)
}

Swapp(win_title, target_exe, args:="")
{
    if WinExist(win_title)
    {
        if WinActive(win_title)
        {
            if InStr(args, "Ubuntu")
            {
                Send ^+1
            }
            else if InStr(args, "Arch")
            {
                Send ^+4
            }
            else if InStr(args, "Command")
            {
                Send ^+2
            }
            else
            {
                WinMinimize
            }
        }
        else
        {
            WinGet win_id, ID, %win_title%
            Sleep 100
            DllCall("SetForegroundWindow", UInt, win_id)
            DllCall("SwitchToThisWindow", "UInt", win_id, "UInt", 1)
            if InStr(args, "Ubuntu")
            {
                Send ^+1
            }
            else if InStr(args, "Command")
            {
                Send ^+2
            }
            else if InStr(args, "Arch")
            {
                Send ^+4
            }
            Sleep 100
            DllCall("SetForegroundWindow", UInt, win_id)
            DllCall("SwitchToThisWindow", "UInt", win_id, "UInt", 1)
        }
    }
    else
    {
        if InStr(target_exe, "wt.exe")
        {
            Run *RunAs %target_exe% %args%
            WinWait %win_title%
            WinActivate
        }
        else
        {
            Run %target_exe%
            WinWait %win_title%
            WinActivate
        }
        Sleep 100
        DllCall("SetForegroundWindow", UInt, win_id)
        DllCall("SwitchToThisWindow", "UInt", win_id, "UInt", 1)
    }
}

VSCode()
{
    win_title = Visual Studio Code ahk_class Chrome_WidgetWin_1
    target_exe = "C:\Program Files\Microsoft VS Code\Code.exe"
    Swapp(win_title, target_exe)
}

Discord()
{
    win_title = Discord ahk_class Chrome_WidgetWin_1
    target_exe = "C:\Users\alefnull\AppData\Local\Discord\app-1.0.9003\Discord.exe"
    Swapp(win_title, target_exe)
}

Firefox()
{
    win_title = Mozilla Firefox ahk_class MozillaWindowClass
    target_exe = "C:\Program Files\Mozilla Firefox\firefox.exe"
    Swapp(win_title, target_exe)
}

Terminal(args:="")
{
    win_title = ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    target_exe = "wt.exe"
    if InStr(args, "Ubuntu")
    {
        Swapp(win_title, target_exe, args)
    }
    else if InStr(args, "Arch")
    {
        Swapp(win_title, target_exe, args)
    }
    else if InStr(args, "Command")
    {
        Swapp(win_title, target_exe, args)
    }
    else
    {
        Swapp(win_title, target_exe)
    }
}
