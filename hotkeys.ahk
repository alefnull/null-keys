#Include funcs.ahk

;; use capslock as meta key
;; if tapped instead of used as modifier, send Esc
CapsLock::Esc

;; alt + capslock
;; if you *really* need caps
!CapsLock::CapsLock

;; vim navigation
CapsLock & h:: Send {Left}
CapsLock & j:: Send {Down}
CapsLock & k:: Send {Up}
CapsLock & l:: Send {Right}
CapsLock & 4:: Send {End}
CapsLock & 0:: Send {Home}

;; normal useful commands
CapsLock & x:: Send ^{x} ; cut
CapsLock & c:: Send ^{c} ; copy
CapsLock & v:: Send ^{v} ; paste
CapsLock & u:: Send ^{z} ; undo
CapsLock & y:: Send ^{y} ; redo
CapsLock & s:: Send ^{s} ; save
CapsLock & q:: Send !{F4} ; quit

;; launch or switch to apps (funcs.ahk)
CapsLock & d:: discord()
CapsLock & f:: firefox()
CapsLock & g:: guilded()
CapsLock & n:: notepad()
CapsLock & t:: terminal()

CapsLock & i::
Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
WinActivate Window Spy
Return

;; tea timer
^#t:: TeaTimer(4)

;; adjust volume via mousewheel over tray/taskbar
#If MouseIsOver("ahk_class Shell_TrayWnd")
MButton::Send {Volume_Mute}
WheelUp::Send {Volume_Up 5}
WheelDown::Send {Volume_Down 5}
#If

;; auto-reload script on save
#IfWinActive ahk_group ScriptEdit
~Capslock & s::
~^s::
    ReloadScript()
return
#IfWinActive

;; ueli
CapsLock & Space:: Send !{Space}

;; task manager
CapsLock & Backspace:: Send +^{Esc}

;; virtual desktop left & right
CapsLock & Left:: Send ^#{Left}
CapsLock & Right:: Send ^#{Right}

;; edit this script in default editor
CapsLock & e::
Edit
return

;; reload script
CapsLock & r::
ReloadScript()
return

;; suspend script on/off
CapsLock & NumpadDot:: Suspend Toggle

;; empty recycle bin
CapsLock & Del::
FileRecycleEmpty
CornerNotify("recycle bin emptied", "hotkeys.ahk", "b r", 3)
return
