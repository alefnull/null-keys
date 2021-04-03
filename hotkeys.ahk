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
CapsLock & q::
If WinActive("ahk_exe WindowsTerminal.exe")
{
    Send exit
    Sleep 100
    Send {Enter}
}
Else
{
    Send !{F4} ; quit
}
Return

;; launch or switch to apps (funcs.ahk)
CapsLock & d:: openDiscord()
CapsLock & f:: openFirefox()
CapsLock & g:: openGuilded()
CapsLock & n:: openNotepad()
CapsLock & t:: openTerminal()

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
