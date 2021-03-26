; =========================
; basic remappings
; =========================
CapsLock::Esc
Esc::CapsLock

; =========================
; shortcuts
; =========================
RAlt & e::
CapsLock & e::
Edit ; RIGHT-ALT + E == edit this script in default editor
return

; vim-like HJKL navigation + 4/0 for home/end
CapsLock & h::Send {Blind}{Left down}
CapsLock & h up::Send {Blind}{Left up}
CapsLock & j::Send {Blind}{Down down}
CapsLock & j up::Send {Blind}{Down up}
CapsLock & k::Send {Blind}{Up down}
CapsLock & k up::Send {Blind}{Up up}
CapsLock & l::Send {Blind}{Right down}
CapsLock & l up::Send {Blind}{Right up}
CapsLock & 0::Send {Blind}{Home down}
CapsLock & 0 up::Send {Blind}{Home up}
CapsLock & 4::Send {Blind}{End down}
CapsLock & 4 up::Send {Blind}{End up}
