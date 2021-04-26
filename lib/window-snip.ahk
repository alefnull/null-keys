
;; 100% ripped from Joe Glines' "WindowSnipping" script
;; which was updated from Learning one's "Screen clipping" script
;; https://www.autohotkey.com/boards/viewtopic.php?t=12088
;; ---------------------------------------------------------
;; cut out basically everything except for snip/clip/save
;; also removed built-in Gdip functions
;; in favor of #including my own in null-keys.ahk

SCW_SetUp(Options="") {
	if !(Options = "") {
		Loop, Parse, Options, %A_Space%
		{
			Field := A_LoopField
			DotPos := InStr(Field, ".")
			if (DotPos = 0)
		Continue
			var := SubStr(Field, 1, DotPos-1)
			val := SubStr(Field, DotPos+1)
			if var in StartAfter,MaxGuis,AutoMonitorWM_LBUTTONDOWN,DrawCloseButton,BorderAColor,BorderBColor,SelColor,SelTrans
		%var% := val
		}
	}

	SCW_Default(StartAfter,80), SCW_Default(MaxGuis,6)
	SCW_Default(AutoMonitorWM_LBUTTONDOWN,1), SCW_Default(DrawCloseButton,0)
	SCW_Default(BorderAColor,"ffdddddd"), SCW_Default(BorderBColor,"ffffffff")
	SCW_Default(SelColor,"19B3EE"), SCW_Default(SelTrans,30)

	SCW_GetSet("MaxGuis", MaxGuis), SCW_GetSet("StartAfter", StartAfter), SCW_GetSet("DrawCloseButton", DrawCloseButton)
	SCW_GetSet("BorderAColor", BorderAColor), SCW_GetSet("BorderBColor", BorderBColor)
	SCW_GetSet("SelColor", SelColor), SCW_GetSet("SelTrans",SelTrans)
	SCW_GetSet("WasSetUp", 1)
	if AutoMonitorWM_LBUTTONDOWN
	OnMessage(0x201, "SCW_LBUTTONDOWN")
}

SCW_ScreenClip2Win(clip=0) {
	static c
	global defaultSignature, origText

	if !(SCW_GetSet("WasSetUp"))
		SCW_SetUp()

	StartAfter := SCW_GetSet("StartAfter"), MaxGuis := SCW_GetSet("MaxGuis"), SelColor := SCW_GetSet("SelColor"), SelTrans := SCW_GetSet("SelTrans")
	c++
	if (c > MaxGuis)
		c := 1

	GuiNum := StartAfter + c
	Area := SCW_SelectAreaMod("g" GuiNum " c" SelColor " t" SelTrans)
	StringSplit, v, Area, |
	if (v3 < 10 and v4 < 10)   ; too small area
		return

	pToken := Gdip_Startup()
	if (! pToken )	{
		MsgBox, 64, GDI+ error, GDI+ failed to start. Please ensure you have GDI+ on your system.
		return
	}
	Sleep, 100

	pBitmap := Gdip_BitmapFromScreen(Area)

	;*******************************************************
	SCW_CreateLayeredWinMod(GuiNum,pBitmap,v1,v2, SCW_GetSet("DrawCloseButton"))
	Gdip_Shutdown("pToken")
	if (clip=1){
		;********************** added to copy to clipboard by default*********************************
		WinActivate, ScreenClippingWindow ahk_class AutoHotkeyGUI ;activates last clipped window
		SCW_Win2Clipboard(0)  ;copies to clipboard by default w/o border
		;*******************************************************
	}
}

SCW_SelectAreaMod(Options="") {
	CoordMode, Mouse, Screen
	MouseGetPos, MX, MY
	loop, parse, Options, %A_Space%
	{
		Field := A_LoopField
		FirstChar := SubStr(Field,1,1)
		if FirstChar contains c,t,g,m
		{
			StringTrimLeft, Field, Field, 1
			%FirstChar% := Field
		}
	}
	c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g
	Gui %g%: Destroy
	Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound -DPIScale ;provided from rommmcek 10/23/16


	WinSet, Transparent, %t%
	Gui %g%: Color, %c%
	Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
	While, (GetKeyState(Hotkey, "p"))   {
		Sleep, 10
		MouseGetPos, MXend, MYend
		w := abs(MX - MXend), h := abs(MY - MYend)
		X := (MX < MXend) ? MX : MXend
		Y := (MY < MYend) ? MY : MYend
		Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
	}
	Gui %g%: Destroy
	MouseGetPos, MXend, MYend
	If ( MX > MXend )
		temp := MX, MX := MXend, MXend := temp
	If ( MY > MYend )
		temp := MY, MY := MYend, MYend := temp
	Return MX "|" MY "|" w "|" h
}

SCW_CreateLayeredWinMod(GuiNum,pBitmap,x,y,DrawCloseButton=0) {
	static CloseButton := 16
	BorderAColor := SCW_GetSet("BorderAColor"), BorderBColor := SCW_GetSet("BorderBColor")

	; IniRead, ClipBorder, % script.configfile, Settings, ClipBorder, % false

	Gui %GuiNum%: -Caption +E0x80000 +LastFound +ToolWindow +AlwaysOnTop +OwnDialogs
	Gui %GuiNum%: Show, Na, ScreenClippingWindow
	hwnd := WinExist()

	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	hbm := CreateDIBSection(Width+6, Height+6), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)

	Gdip_DrawImage(G, pBitmap, 3, 3, Width, Height)
	Gdip_DisposeImage(pBitmap)

	pPen1 := Gdip_CreatePen("0x" BorderAColor, 3), pPen2 := Gdip_CreatePen("0x" BorderBColor, 1)
	if DrawCloseButton {
		Gdip_DrawRectangle(G, pPen1, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
		Gdip_DrawRectangle(G, pPen2, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
	}
	Gdip_DrawRectangle(G, pPen1, 1, 1, Width+3, Height+3)
	Gdip_DrawRectangle(G, pPen2, 1, 1, Width+3, Height+3)
	Gdip_DeletePen(pPen1), Gdip_DeletePen(pPen2)

	UpdateLayeredWindow(hwnd, hdc, x-3, y-3, Width+6, Height+6)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
	SCW_GetSet("G" GuiNum "#HWND", hwnd)
	SCW_GetSet("G" GuiNum "#XClose", Width+6-CloseButton)
	SCW_GetSet("G" GuiNum "#YClose", CloseButton)
	Return hwnd
}

SCW_LBUTTONDOWN() {
	MouseGetPos,,, WinUMID
	WinGetTitle, Title, ahk_id %WinUMID%
	if (Title = "ScreenClippingWindow") {
		PostMessage, 0xA1, 2,,, ahk_id %WinUMID%
		KeyWait, Lbutton
		CoordMode, mouse, Relative
		MouseGetPos, x,y
	  XClose := SCW_GetSet("G" A_Gui "#XClose"), YClose := SCW_GetSet("G" A_Gui "#YClose")
		if (x > XClose and y < YClose)
		Gui %A_Gui%: Destroy
		return 1   ; confirm that click was on module's screen clipping windows
	}
}

SCW_GetSet(variable, value="") {
	static
	if (value = "") {
		yaqxswcdevfr := kxucfp%variable%pqzmdk
		Return yaqxswcdevfr
	} Else
	kxucfp%variable%pqzmdk = %value%
}

SCW_Default(ByRef Variable,DefaultValue) {
	if (Variable="")
	Variable := DefaultValue
}

SCW_Win2Clipboard(KeepBorders=0) {
	Send, !{PrintScreen} ; Active Win's client area to Clipboard
    Sleep 50
	if !KeepBorders {
		pToken := Gdip_Startup()
		pBitmap := Gdip_CreateBitmapFromClipboard()
		Gdip_GetDimensions(pBitmap, w, h)
		pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
		Gdip_SetBitmapToClipboard(pBitmap2)
		Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
		Gdip_Shutdown("pToken")
	}
}

SCW_CropImage(pBitmap, x, y, w, h) {
	pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
	Gdip_DeleteGraphics(G2)
	return pBitmap2
}

SCW_Win2File(KeepBorders=0) {
	Send, !{PrintScreen} ; Active Win's client area to Clipboard
	sleep 50
	if !KeepBorders
	{
		pToken := Gdip_Startup()
		pBitmap := Gdip_CreateBitmapFromClipboard()
		Gdip_GetDimensions(pBitmap, w, h)
		pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
		;~ File2:=A_Desktop . "\" . A_Now . ".PNG" ; tervon  time /path to file to save
		FormatTime, TodayDate , YYYYMMDDHH24MISS, yyyy_MMM_dd@hh_mmtt
		File2:=A_ScriptDir . "\snips\" . TodayDate . ".PNG" ;path to file to save
		Gdip_SaveBitmapToFile(pBitmap2, File2) ;Exports automatcially to file
		Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
		Gdip_Shutdown("pToken")
	}
}
