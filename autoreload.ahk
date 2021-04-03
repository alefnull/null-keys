ReloadScript() {
    CornerNotify("reloading updated script", "autoexec.ahk", "b r", 3)
	Sleep 2000
	Reload
}

#IfWinActive ahk_group ScriptEdit
~Capslock & s::
~^s::
    ReloadScript()
return
#IfWinActive
