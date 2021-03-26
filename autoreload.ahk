ReloadScript() {
    CornerNotify("reloading updated script", "autoexec.ahk", "b r", 3)
	Sleep, 3000
	Reload
}

RAlt & r::
CapsLock & r::
    ReloadScript()
return

#IfWinActive ahk_group ThisScript
~^s::
    ReloadScript()
return
#IfWinActive
