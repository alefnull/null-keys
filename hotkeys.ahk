;; use capslock as meta key
;; if tapped instead of used as modifier, send Esc
CapsLock::
    key=
    Input, key, B C L1 T1, {Esc}
    if (ErrorLevel = "Max")
        Send {Ctrl DownTemp}{Shift DownTemp}{LWin DownTemp}%key%
    KeyWait, CapsLock
Return

CapsLock up::
    If key
    Send {Ctrl Up}{Shift Up}{LWin Up}
    else
        if (A_TimeSincePriorHotkey < 1000)
        Send, {Esc 2}
Return

;; shift + esc to access capslock
;; if you *really* need it
+Esc::CapsLock

;; vim navigation with hyper
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
