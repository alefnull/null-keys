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

GroupAdd ScriptEdit, %A_ScriptName%

SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

#Include <CornerNotify>
#Include funcs.ahk
#Include hotkeys.ahk
#Include hotstrings.ahk
#Include misc.ahk
