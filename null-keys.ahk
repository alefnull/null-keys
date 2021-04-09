#SingleInstance Force
;#Warn
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

GroupAdd ScriptEdit, %A_ScriptName%

SetNumLockState AlwaysOn
SetCapsLockState AlwaysOff
SetScrollLockState AlwaysOff

#Include <Notify>
#Include funcs.ahk

isReloading := ReadConfig("reloading")
If (isReloading) {
    WriteConfig("reloading", false)
    sleep 750
    Notify().Toast(" null-keys reloaded ")
} else {
    Notify().Toast(" null-keys loaded ")
}

InitConfig()
ResetConfig()

#Include hotkeys.ahk
#Include hotstrings.ahk
#Include misc.ahk

/* --- BEGIN CONFIG ---
[config]
reloading=0
brewing=0
canceled=0
--- END CONFIG --- */
