GroupAdd ThisScript, %A_ScriptName%

ReloadScript() {
	TrayTip, reloading updated script, %A_ScriptName%
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