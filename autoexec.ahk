#SingleInstance Force
#Persistent
#NoEnv
; #Warn
#MaxThreadsPerHotkey 1
SendMode Input
SetWorkingDir %A_ScriptDir%
#KeyHistory 0
ListLines Off
SetTitleMatchMode 2
DetectHiddenWindows On
SetBatchLines -1

; =====================================
; script reload on editor save & hotkey
; =====================================
GroupAdd ThisScript, %A_ScriptName%

ReloadScript() {
	TrayTip, reloading updated script, %A_ScriptName%
	Sleep, 3000
	Reload
}

RAlt & r::ReloadScript()

#IfWinActive ahk_group ThisScript
~^s::
    ReloadScript()
return
#IfWinActive
; ====================================

#Include hotkeys.ahk
#Include teatimer.ahk
#Include volumouse.ahk