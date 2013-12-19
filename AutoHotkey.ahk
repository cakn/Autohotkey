;-------------------------  Midi input library  ----------------------
#include midi_in_lib_test.ahk

DetectHiddenWindows, on

saveActiveWindow( saveNum )
{
	global
	WinGet windowID%saveNum%, ID, A
}

retrieveSavedWindow( saveNum )
{
	global
	id := windowID%saveNum%
	WinActivate, ahk_id %id%
}

GetMonitorIndexFromWindow(windowHandle)
{
;{{{
	; Starts with 1.
	monitorIndex := 1

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)

	if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
		&& DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo)
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}

	return monitorIndex
;}}}
}

numpadTileWindow( numpadNum )
{
	WinGet, activeWindow, ID, A
	monitorNumber := GetMonitorIndexFromWindow( activeWindow )
	SysGet, Mon, MonitorWorkArea, %monitorNumber%
	MonWidth := MonRight - MonLeft
	MonHalfWidth := MonWidth/2
	MonHeight := MonBottom - MonTop
	MonHalfHeight := MonHeight/2
	MonHalfLeft := MonLeft + MonHalfWidth
	MonHalfTop := MonTop + MonHalfHeight
	WinGet, IsMaximized, MinMax, ahk_id %activeWindow%


	if( numpadNum = 1 ){
		WinMove, ahk_id %activeWindow%, , %MonLeft%, %MonHalfTop%, %MonHalfWidth%, %MonHalfHeight%
	}else if( numpadNum = 2 ){
		WinMove, ahk_id %activeWindow%, , %MonLeft%, %MonHalfTop%, %MonWidth%, %MonHalfHeight%
	}else if( numpadNum = 3 ){
		WinMove, ahk_id %activeWindow%, , %MonHalfLeft%, %MonHalfTop%, %MonHalfWidth%, %MonHalfHeight%
	}else if( numpadNum = 4 ){
		WinMove, ahk_id %activeWindow%, , %MonLeft%, %MonTop%, %MonHalfWidth%, %MonHeight%
	}else if( numpadNum = 5 ){
		if( IsMaximized = 1 ){
			WinRestore ahk_id %activeWindow%
		}else{
			WinMaximize ahk_id %activeWindow%
		}
	}else if( numpadNum = 6 ){
		WinMove, ahk_id %activeWindow%, , %MonHalfLeft%, %MonTop%, %MonHalfWidth%, %MonHeight%
	}else if( numpadNum = 7 ){
		WinMove, ahk_id %activeWindow%, , %MonLeft%, %MonTop%, %MonHalfWidth%, %MonHalfHeight%
	}else if( numpadNum = 8 ){
		WinMove, ahk_id %activeWindow%, , %MonLeft%, %MonTop%, %MonWidth%, %MonHalfHeight%
	}else if( numpadNum = 9 ){
		WinMove, ahk_id %activeWindow%, , %MonHalfLeft%, %MonTop%, %MonHalfWidth%, %MonHalfHeight%
	}else if( numpadNum = 0 ){
		SysGet, count, MonitorCount
		nextMonitorNum := Mod( monitorNumber, count )
		nextMonitorNum := nextMonitorNum + 1
		; MsgBox %monitorNumber% %nextMonitorNum%
		SysGet, NextMon, MonitorWorkArea, %nextMonitorNum%
		WinMove, ahk_id %activeWindow%, , %NextMonLeft%, %NextMonTop%
	}
	; MsgBox, Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom% HalfWidth %MonHalfWidth% HalfHeight %MonHalfHeight%
	return
}


Capslock::Ctrl

#IfWinActive ahk_class MozillaWindowClass
; *^o::^l
; *^i::^k
; o & CapsLock::MsgBox HI
; ; $^i::^k
; ; $^o::^l
#IfWinActive ; End Firefox block
$^h::Send {Ctrl Up}{Left}{Ctrl Down}
$^j::Send {Ctrl Up}{Down}{Ctrl Down}
$^k::Send {Ctrl Up}{Up}{Ctrl Down}
$^l::Send {Ctrl Up}{Right}{Ctrl Down}

; Quake console
`::
DetectHiddenWindows, On
IfWinExist ahk_class Console_2_Main
{
	IfWinNotActive
	{
		consoleActive = false
	}
	if( consoleActive = "true" ){
		WinHide
		consoleActive = false
	}else{
		WinShow
		WinActivate
		consoleActive = true
	}
}
else
{
	SysGet, width, 16, 17
	Run, C:\Users\Kenneth\Documents\Autohotkey\Console2\Console.exe, C:\Users\Kenneth, Hide
	WinWait, ahk_class Console_2_Main
	WinMove, , , 0, 0, width, 300
	consoleActive = true
	WinShow
}
return

#1::saveActiveWindow( 1 )
#2::saveActiveWindow( 2 )
#3::saveActiveWindow( 3 )
#4::saveActiveWindow( 4 )
#5::saveActiveWindow( 5 )
#6::saveActiveWindow( 6 )
#7::saveActiveWindow( 7 )
#8::saveActiveWindow( 8 )
#9::saveActiveWindow( 9 )
#0::saveActiveWindow( 0 )

^1::retrieveSavedWindow( 1 )
^2::retrieveSavedWindow( 2 )
^3::retrieveSavedWindow( 3 )
^4::retrieveSavedWindow( 4 )
^5::retrieveSavedWindow( 5 )
^6::retrieveSavedWindow( 6 )
^7::retrieveSavedWindow( 7 )
^8::retrieveSavedWindow( 8 )
^9::retrieveSavedWindow( 9 )
^0::retrieveSavedWindow( 0 )

!^Numpad1::numpadTileWindow( 1 )
!^Numpad2::numpadTileWindow( 2 )
!^Numpad3::numpadTileWindow( 3 )
!^Numpad4::numpadTileWindow( 4 )
!^Numpad5::numpadTileWindow( 5 )
!^Numpad6::numpadTileWindow( 6 )
!^Numpad7::numpadTileWindow( 7 )
!^Numpad8::numpadTileWindow( 8 )
!^Numpad9::numpadTileWindow( 9 )
!^Numpad0::numpadTileWindow( 0 )
