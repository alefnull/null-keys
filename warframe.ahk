; ==========================
; experimental macro:
; zenurik energizing dash
; (working, but needs more testing)
; ==========================
#IfWinActive Warframe
CapsLock & XButton1::
    Send 5
    Sleep 100
    Send {z down}
    Sleep 100
    Send {Space}
    Sleep 100 
    Send {z up}
    Sleep 100
    Send 5
    return
#If
