#SingleInstance Force
#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
FileEncoding UTF-8
SetTitleMatchMode 2
#KeyHistory 20

GroupAdd ScriptEdit, %A_ScriptName%

SetNumLockState AlwaysOn
SetCapsLockState AlwaysOff
SetScrollLockState AlwaysOff

#Include <Notify>
IniRead isReloading, %A_ScriptFullPath%, config, reloading
If (isReloading) {
    IniWrite 0, %A_ScriptFullPath%, config, reloading
    Notify().AddWindow(" ahk-scripts reloaded ")
} else {
    Notify().AddWindow(" ahk-scripts loaded ")
}
#Include funcs.ahk
#Include hotkeys.ahk
#Include hotstrings.ahk
#Include misc.ahk


/*  -- config section

[config]
reloading=0

;; IniRead value, %A_ScriptFullPath%, section, key
;; IniWrite value, %A_ScriptFullPath%, section, key

*/  ;-- end config section
