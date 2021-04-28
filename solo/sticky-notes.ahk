#SingleInstance Force
#NoEnv
#Persistent
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

if ((A_PtrSize = 8 && A_IsCompiled = "") || !A_IsUnicode)
{ ;32 bit=4  ;64 bit=8
    SplitPath,A_AhkPath,,dir
    if (!FileExist(correct := dir "\AutoHotkeyU32.exe"))
    {
        MsgBox requires AHK 32-bit
        ExitApp
    }
    Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
    ExitApp
}

Gui +AlwaysOnTop -Caption +LastFound +OwnDialogs +Resize +ToolWindow +MinSize320x240 +MaxSize640x480 +HwndhwndNotes
Gui Font, s14 w1, CaskaydiaCove NF
Gui Add, Edit, vNotesEdit x0 y0 w320 h240
if (FileExist(A_ScriptDir "\notes.txt"))
{
    FileRead notes_content, %A_ScriptDir%\notes.txt
    GuiControl,, NotesEdit, %notes_content%
}
OnMessage(0x201, "ClickDrag")

#n::
    if !(WinActive("hwndNotes"))
    {
        Gui Show, w320 h240, hwndNotes
        GuiControl Focus, NotesEdit
        Send ^{End}
        return
    }
    Gui Hide
return

#If WinActive("hwndNotes")
Esc::
CapsLock::Gui Hide
^s::
    ControlGetText NotesEdit
    FileDelete %A_ScriptDir%\notes.txt
    FileAppend %NotesEdit%, %A_ScriptDir%\notes.txt
    WinClose hwndNotes
    Notify().Toast(" notes file saved ", {Time:3000})
return
#If

#If MouseIsOver("hwndNotes")
    MButton::Gui Hide
#If

GuiSize:
	AutoXYWH("wh", "NotesEdit")
return

MouseIsOver(win_title)
{
    MouseGetPos ,,,win
    return WinExist(win_title . " ahk_id " . win)
}

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }
