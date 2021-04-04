#SingleInstance Force
#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
FileEncoding UTF-8
SetTitleMatchMode 2
#WinActivateForce
SetWinDelay 0
SetControlDelay 0
SetKeyDelay 0
SetMouseDelay 0
#Hotstring EndChars \
#KeyHistory 20

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
