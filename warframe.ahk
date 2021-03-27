; ==========================
; experimental macro:
; zenurik energizing dash
; (working, but needs more testing)
; ==========================
#IfWinActive Warframe
Alt & MButton::
    ; operator form
    Send 5
    Sleep 250
    ; void dash
    Send {z down}
    Sleep 250
    Send {Space}
    Sleep 250 
    Send {z up}
    Sleep 250
    ; back to warframe
    Send 5
    Sleep 750
    ; select first ability
    Send {WheelDown}
    return
#If
