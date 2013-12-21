;-------------------------  Midi input library  ----------------------
#include midi_in_lib_test.ahk

DetectHiddenWindows, on

; Functions {{{
saveActiveWindow( saveNum )
{
	; {{{
	global
	WinGet windowID%saveNum%, ID, A
	; }}}
}

retrieveSavedWindow( saveNum )
{
	; {{{
	global
	id := windowID%saveNum%
	WinActivate, ahk_id %id%
	; }}}
}

GetMonitorIndexFromWindow(windowHandle)
{
; {{{
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
; }}}
}

numpadTileWindow( numpadNum )
{
	; {{{
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
		WinRestore ahk_id %activeWindow%
		SysGet, count, MonitorCount
		nextMonitorNum := Mod( monitorNumber, count )
		nextMonitorNum := nextMonitorNum + 1
		; MsgBox %monitorNumber% %nextMonitorNum%
		SysGet, NextMon, MonitorWorkArea, %nextMonitorNum%
		WinMove, ahk_id %activeWindow%, , %NextMonLeft%, %NextMonTop%
	}
	; MsgBox, Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom% HalfWidth %MonHalfWidth% HalfHeight %MonHalfHeight%
	return
	; }}}
}

pedalToggleKey( pressedKey )
{
	; {{{
	state := GetKeyState( "Control" )
	if( state == 1 ){
		if( pressedKey == "j" ){
			Send {Ctrl Up}{Down}{Ctrl Down}
		}else if( pressedKey == "k" ){
			Send {Ctrl Up}{Up}{Ctrl Down}
		}else if( pressedKey == "h" ){
			Send {Ctrl Up}{Left}{Ctrl Down}
		}else if( pressedKey == "l" ){
			Send {Ctrl Up}{Right}{Ctrl Down}
		}else if( pressedKey == "i" ){
			Send k
		}else if( pressedKey == "o" ){
			Send l
		}
	}else{
		if( pressedKey == "j" ){
			Send j
		}else if( pressedKey == "k" ){
			Send k
		}else if( pressedKey == "h" ){
			Send h
		}else if( pressedKey == "l" ){
			Send l
		}else if( pressedKey == "i" ){
			Send i
		}else if( pressedKey == "o" ){
			Send o
		}
	}

	return
	; }}}
}

firefoxLeaderCommand()
{
	; {{{
	Suspend On
	Input, inputLetter, L1 T1
	if( inputLetter = "c" ){
		Input, inputLetter2, L1 T1
		if( inputLetter2 = "l" ){
			; "cl" Close tab
			Send ^w
		}else if( inputLetter2 = "u" ){
			; "cu" Close undo
			Send +^t
		}
	}else if( inputLetter = "t" ){
		Input, inputLetter2, L1 T1
		if( inputLetter2 = "n" ){
			; tn Tab new
			Send ^t
		}else if( inputLetter2 = "h" ){
			; th Tab left
			Send ^+{Tab}
		}else if( inputLetter2 = "l" ){
			; th Tab right
			Send ^{Tab}
		}else if( inputLetter2 = "1" ){
			Send ^1
		}else if( inputLetter2 = "2" ){
			Send ^2
		}else if( inputLetter2 = "3" ){
			Send ^3
		}else if( inputLetter2 = "4" ){
			Send ^4
		}else if( inputLetter2 = "5" ){
			Send ^5
		}else if( inputLetter2 = "6" ){
			Send ^6
		}else if( inputLetter2 = "7" ){
			Send ^7
		}else if( inputLetter2 = "8" ){
			Send ^8
		}else if( inputLetter2 = "9" ){
			Send ^9
		}else if( inputLetter2 = "0" ){
			; go to last tab
			Send ^9
		}
	}else if( inputLetter = "g" ){
		Input, inputLetter2, L1 T1
		if( inputLetter2 = "o" ){
			; go tab group open
			Send ^+e
		}else if( inputLetter2 = "h" ){
			; gh tab group left
			Send ^~
		}else if( inputLetter2 = "l" ){
			; gl tab^ group right
			Send ^`
		}
	}else if( inputLetter = "h" ){
		Input, inputLetter2, L2 T1
		if( inputLetter2 = "is" ){
			; his history
			Send ^h
		}
	}else if( inputLetter = "s" ){
		; s Tab left
		Send ^+{Tab}
	}else if( inputLetter = "e" ){
		; e Tab right
		Send ^{Tab}
	}
	Suspend Off
	; }}}
}
; }}}

; Shift +
; Alt !
; Ctrl ^
; Win #

^+F12::Suspend, Toggle

#IfWinActive ahk_class MozillaWindowClass
; {{{
	j::pedalToggleKey( A_ThisHotkey )
	k::pedalToggleKey( A_ThisHotkey )
	h::pedalToggleKey( A_ThisHotkey )
	l::pedalToggleKey( A_ThisHotkey )
	i::pedalToggleKey( A_ThisHotkey )
	o::pedalToggleKey( A_ThisHotkey )
	\::firefoxLeaderCommand()

	^i::k
	^o::l
	^h::Send {Left}
	^j::Send {Down}
	^k::Send {Up}
	^l::Send {Right}

	!0::
		Suspend On
		Send ^9
		Suspend Off
		return
	!1::
	!2::
	!3::
	!4::
	!5::
	!6::
	!7::
	!8::
	!9::
		Suspend On
		trimHotkey := Trim( A_ThisHotkey, "!" )
		Send ^{ %trimHotkey% }
		Suspend Off
		return
; }}}
#IfWinActive ; End Firefox block

; Quake console
; {{{
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
; }}}

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
