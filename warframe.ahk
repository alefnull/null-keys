; ==========================
; experimental macro:
; zenurik energizing dash
; (working, but needs more testing)
; ==========================
#IfWinActive Warframe
Alt & MButton::
    Send 5
    Sleep 250
    Send {z down}
    Sleep 250
    Send {Space}
    Sleep 250 
    Send {z up}
    Sleep 250
    Send 5
    Sleep 1000
    Send {WheelDown}
    return
#If
