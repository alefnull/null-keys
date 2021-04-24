
;; 100% ripped from Joe Glines' "WindowSnipping" script
;; which was updated from Learning one's "Screen clipping" script
;; https://www.autohotkey.com/boards/viewtopic.php?t=12088
;; ---------------------------------------------------------
;; cut out basically everything except for snip/clip/save

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
	SCW_Default(BorderAColor,"ffdddddd"), SCW_Default(BorderBColor,"ffdddddd")
	SCW_Default(SelColor,"19B3EE"), SCW_Default(SelTrans,100)

	SCW_Reg("MaxGuis", MaxGuis), SCW_Reg("StartAfter", StartAfter), SCW_Reg("DrawCloseButton", DrawCloseButton)
	SCW_Reg("BorderAColor", BorderAColor), SCW_Reg("BorderBColor", BorderBColor)
	SCW_Reg("SelColor", SelColor), SCW_Reg("SelTrans",SelTrans)
	SCW_Reg("WasSetUp", 1)
	if AutoMonitorWM_LBUTTONDOWN
	OnMessage(0x201, "SCW_LBUTTONDOWN")
}

SCW_ScreenClip2Win(clip=0) {
	static c
	global defaultSignature, origText

	if !(SCW_Reg("WasSetUp"))
		SCW_SetUp()

	StartAfter := SCW_Reg("StartAfter"), MaxGuis := SCW_Reg("MaxGuis"), SelColor := SCW_Reg("SelColor"), SelTrans := SCW_Reg("SelTrans")
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
	SCW_CreateLayeredWinMod(GuiNum,pBitmap,v1,v2, SCW_Reg("DrawCloseButton"))
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
	BorderAColor := SCW_Reg("BorderAColor"), BorderBColor := SCW_Reg("BorderBColor")

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
	SCW_Reg("G" GuiNum "#HWND", hwnd)
	SCW_Reg("G" GuiNum "#XClose", Width+6-CloseButton)
	SCW_Reg("G" GuiNum "#YClose", CloseButton)
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
	  XClose := SCW_Reg("G" A_Gui "#XClose"), YClose := SCW_Reg("G" A_Gui "#YClose")
		if (x > XClose and y < YClose)
		Gui %A_Gui%: Destroy
		return 1   ; confirm that click was on module's screen clipping windows
	}
}

SCW_Reg(variable, value="") {
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

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255){
 if ((x != "") && (y != ""))
  VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)

 if (w = "") ||(h = "")
  WinGetPos,,, w, h, ahk_id %hwnd%
 return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster=""){
 return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh, "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}

Gdip_BitmapFromScreen(Screen=0, Raster=""){
 if (Screen = 0) {
  Sysget, x, 76
  Sysget, y, 77
  Sysget, w, 78
  Sysget, h, 79
 } else if (Screen&1 != "") {
  Sysget, M, Monitor, %Screen%
  x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
 } else {
  StringSplit, S, Screen, |
  x := S1, y := S2, w := S3, h := S4
 }

 if (x = "") || (y = "") || (w = "") || (h = "")
  return -1

 chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := GetDC()
 BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
 ReleaseDC(hhdc)

 pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
 SelectObject(hhdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
 return pBitmap
}

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0){
 hdc2 := hdc ? hdc : GetDC()
 VarSetCapacity(bi, 40, 0)
 NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
 hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)

 If !hdc
  ReleaseDC(hdc2)
 return hbm
}

CreateCompatibleDC(hdc=0){
	return DllCall("CreateCompatibleDC", "uint", hdc)
}

SelectObject(hdc, hgdiobj){
	return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}

DeleteObject(hObject){
	return DllCall("DeleteObject", "uint", hObject)
}

GetDC(hwnd=0){
 return DllCall("GetDC", "uint", hwnd)
}

ReleaseDC(hdc, hwnd=0){
	return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}

DeleteDC(hdc){
	return DllCall("DeleteDC", "uint", hdc)
}

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h){
	return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1){
 if (Matrix&1 = "")
  ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
 else if (Matrix != 1)
  ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

 if (sx = "" && sy = "" && sw = "" && sh = "") {
  if (dx = "" && dy = "" && dw = "" && dh = "") {
	sx := dx := 0, sy := dy := 0,sw :=dw:=Gdip_GetImageWidth(pBitmap),sh := dh := Gdip_GetImageHeight(pBitmap)
  } else {
	sx := sy := 0, sw := Gdip_GetImageWidth(pBitmap),sh := Gdip_GetImageHeight(pBitmap)
  }
 }

 E := DllCall("gdiplus\GdipDrawImageRectRect","uint", pGraphics,"uint",pBitmap,"float",dx,"float",dy,"float",dw,"float", dh,"float",sx,"float",sy,"float", sw, "float",sh,"int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
 if ImageAttr
  Gdip_DisposeImageAttributes(ImageAttr)
 return E
}

Gdip_SetImageAttributesColorMatrix(Matrix){
 VarSetCapacity(ColourMatrix, 100, 0)
 Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
 StringSplit, Matrix, Matrix, |
 Loop, 25  {
  Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
  NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
 }
 DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
 DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
 return ImageAttr
}

Gdip_GraphicsFromImage(pBitmap){
	 DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
	 return pGraphics
}

Gdip_GraphicsFromHDC(hdc){
	 DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
	 return pGraphics
}

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=100){
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
	if !(nCount && nSize)
		return -2

	Loop, %nCount%	{
		Location := NumGet(ci, 76*(A_Index-1)+44)
		if !A_IsUnicode {
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
		}else{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			sString := ""
			Loop, %nSize%
				sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
			if !InStr(sString, "*" Extension)
				continue
		}
		pCodec := &ci+76*(A_Index-1)
		break
	}
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
			Loop, % NumGet(EncoderParameters) {     ;%
					if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6){
					p := (28*(A_Index-1))+&EncoderParameters
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
					break
				}
			}
		}
	}

	if !A_IsUnicode {
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
	} else
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

Gdip_GetImageWidth(pBitmap){
	DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
	return Width
}

Gdip_GetImageHeight(pBitmap){
	DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
	return Height
}

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height){
 Width := Gdip_GetImageWidth(pBitmap)
 Height := Gdip_GetImageHeight(pBitmap)
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0){
 DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
 return pBitmap
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff){
 DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
 return hbm
}

Gdip_CreateBitmap(Width, Height, Format=0x26200A){
	 DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
	 Return pBitmap
}

Gdip_CreateBitmapFromClipboard(){
 if !DllCall("OpenClipboard", "uint", 0)
  return -1
 if !DllCall("IsClipboardFormatAvailable", "uint", 8)
  return -2
 if !hBitmap := DllCall("GetClipboardData", "uint", 2)
  return -3
 if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
  return -4
 if !DllCall("CloseClipboard")
  return -5
 DeleteObject(hBitmap)
 return pBitmap
}

Gdip_SetBitmapToClipboard(pBitmap){
 hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
 DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
 hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
 pdib := DllCall("GlobalLock", "uint", hdib)
 DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
 DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
 DllCall("GlobalUnlock", "uint", hdib)
 DllCall("DeleteObject", "uint", hBitmap)
 DllCall("OpenClipboard", "uint", 0)
 DllCall("EmptyClipboard")
 DllCall("SetClipboardData", "uint", 8, "uint", hdib)
 DllCall("CloseClipboard")
}

Gdip_CreatePen(ARGB, w){
	DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
	return pPen
}

Gdip_DeletePen(pPen){
	return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}

Gdip_DisposeImage(pBitmap){
	return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}

Gdip_DeleteGraphics(pGraphics){
	return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}

Gdip_DisposeImageAttributes(ImageAttr){
 return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}

Gdip_SetInterpolationMode(pGraphics, InterpolationMode){
	return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}

Gdip_SetSmoothingMode(pGraphics, SmoothingMode){
	return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}

Gdip_Startup(){
 if !DllCall("GetModuleHandle", "str", "gdiplus")
  DllCall("LoadLibrary", "str", "gdiplus")
 VarSetCapacity(si, 16, 0), si := Chr(1)
 DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
 return pToken
}

Gdip_Shutdown(pToken){
 DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
 if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
  DllCall("FreeLibrary", "uint", hModule)
 return 0
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
		File2:=A_ScriptDir . "\shots\" . TodayDate . ".PNG" ;path to file to save
		Gdip_SaveBitmapToFile(pBitmap2, File2) ;Exports automatcially to file
		Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
		Gdip_Shutdown("pToken")
	}
}
