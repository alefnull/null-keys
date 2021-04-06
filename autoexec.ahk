#SingleInstance Force
#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
FileEncoding UTF-8
SetTitleMatchMode 2
SetWinDelay 0
SetControlDelay 0
SetKeyDelay 0
SetMouseDelay 0
#Hotstring EndChars \
#KeyHistory 20

GroupAdd ScriptEdit, %A_ScriptName%

SetNumLockState AlwaysOn
SetCapsLockState AlwaysOff
SetScrollLockState AlwaysOff

#Include <Notify>
Notify().AddWindow(" ahk-scripts loaded ")
#Include funcs.ahk
#Include hotkeys.ahk
#Include hotstrings.ahk
#Include misc.ahk