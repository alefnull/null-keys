#SingleInstance Force
#Persistent
#Warn

#Include lib/funcs.ahk
#Include lib/AutoXYWH.ahk

Gui New, +AlwaysOnTop -Caption +LastFound +Owner +OwnDialogs +Resize +ToolWindow +MinSize320x240 +MaxSize640x480 +Hwndnull_notes
Gui Font, s14 w1, CaskaydiaCove NF
Gui Add, Edit, vNotesEdit x0 y0 w320 h240 +WantTab
Gui Show, w320 h240, null_notes
OnMessage(0x201, "ClickDrag")
return

#If MouseIsOver("null_notes")
;CapsLock & MButton::WinClose null_notes
CapsLock & MButton::ExitApp
#If

ClickDrag() {
    if (GetKeyState("RButton", "P"))
    {
        MouseGetPos,,, win_id
        WinGetTitle, win_title, ahk_id %win_id%
        if (win_title = "null_notes") {
            PostMessage, 0x0A1, 2,,, ahk_id %win_id%
            return 1
        }
    }
}

GuiSize:
	AutoXYWH("wh", "NotesEdit")
return
