#SingleInstance Force
#NoEnv
#Persistent
#MaxThreadsPerHotkey 20
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
FileEncoding UTF-8
SetTitleMatchMode 2
ListLines Off
#KeyHistory 20

if not A_IsAdmin
{
    Run *RunAs %A_ScriptFullPath%
    ExitApp
}

GroupAdd SCRIPT_EDIT, %A_ScriptName%

SetNumLockState AlwaysOn
SetCapsLockState AlwaysOff
SetScrollLockState AlwaysOff

;#Include lib/Nuetron.ahk
#Include lib/Notify.ahk
#Include funcs.ahk

is_reloading := ReadConfig("reloading")
If (is_reloading)
{
    sleep 750
    Notify().Toast(" null-keys reloaded ")
}
else
{
    Notify().Toast(" null-keys loaded ")
}

ResetConfig()

#Include hotkeys.ahk
#Include hotstrings.ahk

/*
[config]
reloading=0
brewing=0
canceled=0
*/
