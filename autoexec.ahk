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

TrayTip, script loaded, autoexec.ahk,, 33
Sleep 3000
TrayTip ; clear

GroupAdd ThisScript, %A_ScriptName%

SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

#Include lib\CornerNotify.ahk
#Include autoreload.ahk
#Include hotkeys.ahk
#Include teatimer.ahk
#Include volumouse.ahk
#Include warframe.ahk
