;; emoji/emotes
!/::Send {U+00AF}\_({U+25CF}{U+005F}{U+25CF})_/{U+00AF} ;; shrug
![::Send ({U+25CF}{U+005F}{U+25CF}) ;; face neutral
!]::Send ({U+25CF}{U+005F}{U+25C9}) ;; face raised eyebrow
!\::Send (ノ{U+25CF}{U+005F}{U+25CF})ノ︵┻━┻

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
