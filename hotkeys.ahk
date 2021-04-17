;; use capslock as meta key / escape
;; RAlt + capslock if you *really* need it
CapsLock::Esc
RAlt & CapsLock::CapsLock

;; vim-like navigation
CapsLock & h::Send {Left}
CapsLock & j::Send {Down}
CapsLock & k::Send {Up}
CapsLock & l::Send {Right}
CapsLock & 0::Send {End}
CapsLock & 9::Send {Home}

;; normal useful commands
CapsLock & Backspace::Send {Del} ;; delete
CapsLock & u::Send ^{z} ;; undo
CapsLock & y::Send ^{y} ;; redo
CapsLock & q::
    if !(WinActive("ahk_class Progman") || WinActive("ahk_class Shell_TrayWnd"))
    {
        Send !{F4} ;; quit program if not explorer
    }
Return

;; launch or switch to apps (funcs.ahk)
CapsLock & d::Discord()
CapsLock & f::Firefox()
CapsLock & g::Guilded()
CapsLock & p::Notepad()
CapsLock & t::Terminal()

;; emoji/emotes
CapsLock & /::Send ¯\_(●_●)_/¯ ;; shrug ¯\_(●_●)_/¯
CapsLock & [::Send (●_●) ;; face neutral (●_●)
CapsLock & ]::Send (●_◉) ;; face raised eyebrow (●_◉)
CapsLock & \::Send (ノ●_●)ノ︵┻━┻ ;; table flip (ノ●_●)ノ︵┻━┻

;; snap active window to FancyZones zone
CapsLock & w::Send #{Right}

;; window spy
CapsLock & i::
    Run "C:\Program Files\AutoHotkey\WindowSpy.ahk"
    WinActivate Window Spy
Return

;; tea timer
CapsLock & '::TeaTimer(3)

;; adjust volume via mousewheel over tray/taskbar
#If MouseIsOver("ahk_class Shell_TrayWnd")
    MButton::Send {Volume_Mute}
    WheelUp::Send {Volume_Up 5}
    WheelDown::Send {Volume_Down 5}
#If

;; ueli
CapsLock & Space::Send !{Space}

;; task manager
CapsLock & Enter::Send +^{Esc}

;; virtual desktop left & right
CapsLock & Left::Send ^#{Left}
CapsLock & Right::Send ^#{Right}

;; empty recycle bin
CapsLock & Del::
    FileRecycleEmpty
    Notify().Toast(" recycle bin emptied ")
return

;; edit this script in default editor
CapsLock & e::
    Edit
return

;; reload script
CapsLock & r::
    ReloadScript()
return

;; auto-reload script on save
#IfWinActive ahk_group SCRIPT_EDIT
~^s::
    sleep 1000
    ReloadScript()
return
#IfWinActive

;; use Space as Enter in ueli
#IfWinActive ueli
Space::Enter
#IfWinActive

;; warframe - zenurik energizing dash
#IfWinActive Warframe
    CapsLock & MButton::
        ;; operator form
        Send {Numpad5}
        Sleep 275
        ;; void dash
        ;; crouch key
        Send {z down}
        Sleep 275
        ;; jump key
        Send {Space}
        Sleep 275
        ;; release crouch key
        Send {z up}
        Sleep 275
        ;; back to warframe
        Send {Numpad5}
        ;; wait a moment then scroll to first ability
        ;; this is a personal preference thing
        ;; feel free to comment out or delete
        Sleep 750
        Send {WheelDown}
    return
#If
