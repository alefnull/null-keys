;;                       /##
;;                      | ##
;;  /######  /##   /## /######    /######   /######  /##   /##  /######   /#######
;; |____  ##| ##  | ##|_  ##_/   /##__  ## /##__  ##|  ## /##/ /##__  ## /##_____/
;;  /#######| ##  | ##  | ##    | ##  \ ##| ######## \  ####/ | ########| ##
;; /##__  ##| ##  | ##  | ## /##| ##  | ##| ##_____/  >##  ## | ##_____/| ##
;;|  #######|  ######/  |  ####/|  ######/|  ####### /##/\  ##|  #######|  #######
;; \_______/ \______/    \___/   \______/  \_______/|__/  \__/ \_______/ \_______/
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
Menu, tray, Tip, null-keys is running

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

#Include funcs.ahk
Gui hwndNotes:-Caption +Resize +LastFound +ToolWindow +HwndhwndNotes
Gui hwndNotes:Font, s14 w1, CaskaydiaCove NF
Gui hwndNotes:Add, Edit, vNotesEdit x0 y0 w640 h480
if (FileExist(A_ScriptDir "\notes.txt"))
{
    LoadNotes()
}
OnMessage(0x201, "ClickDrag")

;#Include lib/Neutron.ahk
#Include lib/Gdip_All.ahk
#Include lib/Notify.ahk
#Include lib/Clip.ahk
#Include lib/WindowSnip.ahk

ResetConfig()
Notify().Toast(" null-keys loaded ", {Time:3000})
;; end auto-exec
return

;; /##                   /##     /##
;;| ##                  | ##    | ##
;;| #######   /######  /######  | ##   /##  /######  /##   /##  /#######
;;| ##__  ## /##__  ##|_  ##_/  | ##  /##/ /##__  ##| ##  | ## /##_____/
;;| ##  \ ##| ##  \ ##  | ##    | ######/ | ########| ##  | ##|  ######
;;| ##  | ##| ##  | ##  | ## /##| ##_  ## | ##_____/| ##  | ## \____  ##
;;| ##  | ##|  ######/  |  ####/| ## \  ##|  #######|  ####### /#######/
;;|__/  |__/ \______/    \___/  |__/  \__/ \_______/ \____  ##|_______/
;;                                                   /##  | ##
;; use capslock as meta key / escape                |  ######/
;; RAlt + capslock if you *really* need it           \______/
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
CapsLock & p::Processing()
CapsLock & t::Terminal()

;; emoji/emotes
CapsLock & /::Clip("¯\_(●_●)_/¯") ;; shrug ¯\_(●_●)_/¯
CapsLock & [::Clip("(●_●)") ;; face neutral (●_●)
CapsLock & ]::Clip("(●_◉)") ;; face raised eyebrow (●_◉)
CapsLock & \::Clip("(ノ●_●)ノ︵┻━┻") ;; table flip (ノ●_●)ノ︵┻━┻

;; snap active window to FancyZones zone
CapsLock & w::Send #{Up}

;; toggle desktop icons
CapsLock & i::
    dhw := A_DetectHiddenWindows
    DetectHiddenWindows Off
    DesktopIcons()
    DetectHiddenWindows % dhw
Return

;; window spy
CapsLock & s::
    Run "C:\Program Files\AutoHotkey\WindowSpy.ahk"
    WinActivate Window Spy
Return

;; tea timer
CapsLock & '::TeaTimer(3)

;; ueli
CapsLock & Space::Send !{Space}

;; task manager
CapsLock & Enter::Send +^{Esc}

;; virtual desktop left & right
CapsLock & Left::Send ^#{Left}
CapsLock & Right::Send ^#{Right}

;; empty recycle bin
CapsLock & Del::
    DriveGet drives, List, Fixed
    Loop, Parse, drives
    {
        SHQueryRecycleBin(A_LoopField ":\", bin_size, bin_items)
        total_size += bin_size
        total_items += bin_items
    }
    FileRecycleEmpty
    Notify().Toast(" recycle bin emptied: " . total_items . " items, " . FormatByteSize(total_size), {Time:3000})
return

;; edit this script in default editor
CapsLock & e::
    Edit
return

;; reload script
CapsLock & r::
    SaveNotes()
    sleep 100
    ReloadScript()
return

;; sticky notes show/hide
CapsLock & n::
    if !(WinActive("hwndNotes"))
    {
        Gui hwndNotes:Show, w640 h480, hwndNotes
        GuiControl Focus, NotesEdit
        Send ^{End}
        return
    }
    Gui hwndNotes:Hide
return

;; always-on-top window snips
CapsLock & LButton::SCW_ScreenClip2Win(1)

#IfWinActive ScreenClippingWindow ahk_class AutoHotkeyGUI
CapsLock::
    Esc::WinClose, ScreenClippingWindow ahk_class AutoHotkeyGUI ;; close active snip
    ^s::SCW_Win2File(0) ;; save active snip to 'snips' folder in A_ScriptDir
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

;; warframe - zenurik energizing dash (z : crouch)
#IfWinActive Warframe
CapsLock & MButton::
    Send {Numpad5}
    Sleep 275
    Send {z down}
    Sleep 275
    Send {Space}
    Sleep 275
    Send {z up}
    Sleep 275
    Send {Numpad5}
    Sleep 750
    Send {WheelDown}
return
#If

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

;; sticky note hotkeys
#If WinActive("hwndNotes")
^s::
    SaveNotes()
    Notify().Toast(" notes file loaded ", {Time:3000})
return
^l::
    LoadNotes()
    Send #{Right}
    Notify().Toast(" notes file loaded ", {Time:3000})
return
#If

#If MouseIsOver("hwndNotes")
MButton::Gui Hide
#If

;; adjust volume via mousewheel over tray/taskbar
#If MouseIsOver("ahk_class Shell_TrayWnd")
    MButton::Send {Volume_Mute}
WheelUp::Send {Volume_Up 5}
WheelDown::Send {Volume_Down 5}
#If

GuiSize:
    AutoXYWH("wh", "NotesEdit")
return

;;                                /######  /##
;;                               /##__  ##|__/
;;  /#######  /######  /####### | ##  \__/ /##  /######
;; /##_____/ /##__  ##| ##__  ##| ####    | ## /##__  ##
;;| ##      | ##  \ ##| ##  \ ##| ##_/    | ##| ##  \ ##
;;| ##      | ##  | ##| ##  | ##| ##      | ##| ##  | ##
;;|  #######|  ######/| ##  | ##| ##      | ##|  #######
;; \_______/ \______/ |__/  |__/|__/      |__/ \____  ##
;;                                             /##  \ ##
;;                                            |  ######/
;;                                             \______/
/*
[config]
reloading=0
brewing=0
*/
