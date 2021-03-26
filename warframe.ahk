; ==========================
; experimental macro:
; zenurik energizing dash
; (working, but needs more testing)
; ==========================
#IfWinActive Warframe
CapsLock & XButton1::
Send 5
Sleep 250
Send {z down}
Send {Space}
Sleep 250 
Send {z up}
Send 5
#If
