; ==========================
; experimental macro:
; zenurik energizing dash
; 250 ms Sleep seems to work inconsistently
; still testing
; ==========================
#IfWinActive Warframe
Alt & MButton::
    ; operator form
    Send 5
    Sleep 250
    ; void dash
    ; crouch key
    Send {z down}
    Sleep 250
    ; jump key
    Send {Space}
    Sleep 250
    ; release crouch key
    Send {z up}
    Sleep 250
    ; back to warframe
    Send 5
    ; wait a moment then scroll to first ability
    ; this is a personal preference thing
    ; feel free to comment out or delete
    Sleep 750
    Send {WheelDown}
    return
#If
