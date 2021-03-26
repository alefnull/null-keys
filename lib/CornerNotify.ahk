;---------------------------------------------------------------
; CornerNotify.ahk
; http://www.autohotkey.com/board/topic/94458-msgbox-replacement-monolog-non-modal-transparent-message-box-cornernotify/

;---------------------------------------------------------------
; CHANGELOG

; v1.1 2013-06-19
; added optional position argument that calls WinMove function from user "Learning One"
; position argument syntax is to create a string with the following:
; t=top, vc= vertical center, b=bottom
; l=left, hc=horizontal center, r=right

;---------------------------------------------------------------

CornerNotify(title, message, position="b r", secs=3) {
    CornerNotify_Create(title, message, position)
    millisec := secs*1000*-1
    SetTimer, CornerNotifyBeginFadeOut, %millisec%
}

CornerNotify_Create(title, message, position="b r") {
    global cornernotify_title, cornernotify_msg, w, curtransp, cornernotify_hwnd
    CornerNotify_Destroy() ; make sure an old instance isn't still running or fading out
    Gui,+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
    cornernotify_hwnd := WinExist()
    WinSet, ExStyle, +0x20 ; WS_EX_TRANSPARENT make the window transparent-to-mouse
    WinSet, Transparent, 0
    curtransp := 200
    Gui,Color, 151515 ;background color
    Gui,Font, cFF5050 s18 wbold, CaskaydiaCove NF
    Gui,Add, Text, w450 Center vcornernotify_title, %title%
    Gui,Font, cF0F0F0 s15 wnorm
    Gui,Add, Text, w450 Center vcornernotify_msg, %message%
    Gui,Show, NoActivate w500
    WinMove(cornernotify_hwnd, position)
    winfade("ahk_id " cornernotify_hwnd,210,5)
    Return
}

CornerNotify_ModifyTitle(title) {
    global cornernotify_title
    GuiControl,Text,cornernotify_title, %title%
}

CornerNotify_ModifyMessage(message) {
    global cornernotify_msg
    GuiControl,Text,cornernotify_msg, %message%
}

CornerNotify_Destroy() {
    global cornernotify_hwnd
    ;global curtransp
    ;curtransp := 0
    winfade("ahk_id " cornernotify_hwnd,0,5)
    Gui, Destroy
    SetTimer, CornerNotify_FadeOut_Destroy, Off
}

CornerNotifyBeginFadeOut:
    SetTimer, CornerNotifyBeginFadeOut, Off
    SetTimer, CornerNotify_FadeOut_Destroy, 10
Return

CornerNotify_FadeOut_Destroy:
    If(curtransp > 0) {
        curtransp := curtransp - 4
        WinSet, Transparent, %curtransp%, ahk_id %cornernotify_hwnd%
    }else  {
        Gui, Destroy
        SetTimer, CornerNotify_FadeOut_Destroy, Off
    }
Return

;---------------------------------------------------------------
; Modification of WinMove function by Learning One (http://www.autohotkey.com/board/topic/72630-gui-bottom-right/#entry461385)

; position argument syntax is to create a string with the following:
; t=top, vc= vertical center, b=bottom
; l=left, hc=horizontal center, r=right

WinMove(hwnd,position) {
    ; by Learning one
    SysGet, Mon, MonitorWorkArea
    WinGetPos,ix,iy,w,h, ahk_id %hwnd%
    x := InStr(position,"l") ? MonLeft : InStr(position,"hc") ?  (MonRight-w)/2 : InStr(position,"r") ? MonRight - w : ix
    y := InStr(position,"t") ? MonTop : InStr(position,"vc") ?  (MonBottom-h)/2 : InStr(position,"b") ? MonBottom - h : iy
    WinMove, ahk_id %hwnd%,,x,y
}

winfade(w:="",t:=128,i:=1,d:=10) {
    w:=(w="")?("ahk_id " WinActive("A")):w
    t:=(t>255)?255:(t<0)?0:t
    WinGet,s,Transparent,%w%
    s:=(s="")?255:s ;prevent trans unset bug
    WinSet,Transparent,%s%,%w%
    i:=(s<t)?abs(i):-1*abs(i)
    while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
        WinGet,s,Transparent,%w%
        s+=i
        WinSet,Transparent,%s%,%w%
        sleep %d%
    }
}
;---------------------------------------------------------------
