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

; ===================================
; auto-reload script on editor save
; ===================================
GroupAdd ThisScript, %A_ScriptName%

#IfWinActive ahk_group ThisScript
~^s::
	TrayTip, reloading updated script, %A_ScriptName%
	Sleep, 3000
	Reload
return
#IfWinActive
; ===================================

#Include hotkeys.ahk
#Include teatimer.ahk