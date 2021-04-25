#SingleInstance Force
#NoEnv
#Persistent
#MaxThreadsPerHotkey 20
Process Priority, , A
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
FileEncoding UTF-8
SetTitleMatchMode 2
ListLines Off
#KeyHistory 20

if not A_IsAdmin
{
    Run *RunAs %A_ScriptFullPath%
    ExitApp
}

if ((A_PtrSize = 8 && A_IsCompiled = "") || !A_IsUnicode)
{ ;32 bit=4  ;64 bit=8
    SplitPath,A_AhkPath,,dir
    if (!FileExist(correct := dir "\AutoHotkeyU32.exe"))
    {
        MsgBox requires AHK 32-bit
        ExitApp
    }
    Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
    ExitApp
}

icon = null-keys.ico
IfExist, %icon%
Menu, Tray, Icon, %icon%

GroupAdd SCRIPT_EDIT, %A_ScriptName%

SetNumLockState AlwaysOn
SetCapsLockState AlwaysOff
SetScrollLockState AlwaysOff

;#Include lib/Neutron.ahk
#Include lib/Gdip_All.ahk
#Include lib/Notify.ahk
#Include lib/Clip.ahk
#Include lib/window-snip.ahk
#Include lib/funcs.ahk

is_reloading := ReadConfig("reloading")
If (is_reloading)
{
    sleep 750
    Notify().Toast(" null-keys reloaded ", {Time:3000})
}
else
{
    Notify().Toast(" null-keys loaded ", {Time:3000})
}
ResetConfig()
;; end auto-exec
return

;; ####################################
;; ##            hotkeys             ##
;; ####################################
;; use capslock as meta key / escape
;; RAlt + capslock if you *really* need it
CapsLock::Esc
RAlt & CapsLock::CapsLock

;; vim-like navigation
CapsLock & h::Send {Left}
CapsLock & j::Send {Down}
CapsLock & k::Send {Up}
CapsLock & l::Send {Right}
CapsLock & 0::Send {End}
CapsLock & 9::Send {Home}

;; normal useful commands
CapsLock & Backspace::Send {Del} ;; delete
CapsLock & u::Send ^{z} ;; undo
CapsLock & y::Send ^{y} ;; redo
CapsLock & q::
    if !(WinActive("ahk_class Progman") || WinActive("ahk_class Shell_TrayWnd"))
    {
        Send !{F4} ;; quit program if not explorer
    }
Return

;; launch or switch to apps (funcs.ahk)
CapsLock & d::Discord()
CapsLock & f::Firefox()
CapsLock & g::Guilded()
CapsLock & p::Notepad()
CapsLock & t::Terminal()

;; emoji/emotes
CapsLock & /::Clip("¯\_(●_●)_/¯") ;; shrug ¯\_(●_●)_/¯
CapsLock & [::Clip("(●_●)") ;; face neutral (●_●)
CapsLock & ]::Clip("(●_◉)") ;; face raised eyebrow (●_◉)
CapsLock & \::Clip("(ノ●_●)ノ︵┻━┻") ;; table flip (ノ●_●)ノ︵┻━┻

;; snap active window to FancyZones zone
CapsLock & w::Send #{Right}

;; window spy
CapsLock & i::
    Run "C:\Program Files\AutoHotkey\WindowSpy.ahk"
    WinActivate Window Spy
Return

;; tea timer
CapsLock & '::TeaTimer(3)
;; general timer
CapsLock & =::
InputBox inpt,timer,"how many minutes?"
TeaTimer(inpt)
return

;; adjust volume via mousewheel over tray/taskbar
#If MouseIsOver("ahk_class Shell_TrayWnd")
    MButton::Send {Volume_Mute}
    WheelUp::Send {Volume_Up 5}
    WheelDown::Send {Volume_Down 5}
#If

;; ueli
CapsLock & Space::Send !{Space}

;; task manager
CapsLock & Enter::Send +^{Esc}

;; virtual desktop left & right
CapsLock & Left::Send ^#{Left}
CapsLock & Right::Send ^#{Right}

;; empty recycle bin
CapsLock & Del::
    FileRecycleEmpty
    Notify().Toast(" recycle bin emptied ", {Time:3000})
return

;; edit this script in default editor
CapsLock & e::
    Edit
return

;; reload script
CapsLock & r::
    ReloadScript()
return

;; auto-reload script on save
#IfWinActive ahk_group SCRIPT_EDIT
~^s::
    sleep 1000
    ReloadScript()
return
#IfWinActive

;; use Space as Enter in ueli
#IfWinActive ueli
Space::Enter
#IfWinActive

;; always-on-top window snips
CapsLock & LButton::SCW_ScreenClip2Win(0)

#IfWinActive ScreenClippingWindow ahk_class AutoHotkeyGUI
CapsLock::
Esc::WinClose, ScreenClippingWindow ahk_class AutoHotkeyGUI ;; close active snip
^s::SCW_Win2File(0) ;; save active snip to 'shots' folder in A_ScriptDir
^c::SCW_Win2Clipboard(0) ;; copy to clipboard w/o border
#IfWinActive

~LButton:: ;; double click any snip to close
	MouseGetPos,,, win_id
	WinGetTitle, win_title, ahk_id %win_id%
    if (win_title = "ScreenClippingWindow")
    {
        If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 200)
            WinClose ScreenClippingWindow ahk_class AutoHotkeyGUI
    }
Return

;; warframe - zenurik energizing dash
#IfWinActive Warframe
    CapsLock & MButton::
        ;; operator form
        Send {Numpad5}
        Sleep 275
        ;; void dash
        ;; crouch key
        Send {z down}
        Sleep 275
        ;; jump key
        Send {Space}
        Sleep 275
        ;; release crouch key
        Send {z up}
        Sleep 275
        ;; back to warframe
        Send {Numpad5}
        ;; wait a moment then scroll to first ability
        ;; this is a personal preference thing
        ;; feel free to comment out or delete
        Sleep 750
        Send {WheelDown}
    return
#If

/*
[config]
reloading=0
brewing=0
canceled=0
*/
