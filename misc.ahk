;; emoji/emotes
!/::Send ¯\_(•_•)_/¯

;; warframe - zenurik energizing dash
#IfWinActive Warframe
Alt & MButton::
    ; operator form
    Send {Numpad5}
    Sleep 275
    ; void dash
    ; crouch key
    Send {z down}
    Sleep 275
    ; jump key
    Send {Space}
    Sleep 275
    ; release crouch key
    Send {z up}
    Sleep 275
    ; back to warframe
    Send {Numpad5}
    ; wait a moment then scroll to first ability
    ; this is a personal preference thing
    ; feel free to comment out or delete
    Sleep 750
    Send {WheelDown}
    return
#If
