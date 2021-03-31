;; use capslock as meta key
;; if tapped instead of used as modifier, send Esc
CapsLock::Esc

;; alt + capslock
;; if you *really* need it
!CapsLock::CapsLock

;; vim navigation
CapsLock & h:: Send {Left}
CapsLock & j:: Send {Down}
CapsLock & k:: Send {Up}
CapsLock & l:: Send {Right}
CapsLock & 4:: Send {End}
CapsLock & 0:: Send {Home}

CapsLock & x:: Send ^{x} ; cut
CapsLock & c:: Send ^{c} ; copy
CapsLock & v:: Send ^{v} ; paste
CapsLock & u:: Send ^{z} ; undo
CapsLock & y:: Send ^{y} ; redo
CapsLock & s:: Send ^{s} ; save
CapsLock & q:: Send !{F4} ; quit

CapsLock & Backspace:: Send +^{Esc}

CapsLock & e::
Edit ; edit this script in default editor
return

CapsLock & r::
ReloadScript()
return

CapsLock & t::
Run wt.exe
return

CapsLock & Del::
FileRecycleEmpty
CornerNotify("recycle bin emptied", "hotkeys.ahk", "b r", 3)
return
