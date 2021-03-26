ReloadScript() {
    CornerNotify(3, "reloading updated script", "autoexec.ahk", vc hc)
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
