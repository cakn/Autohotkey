#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%

OnExit, sub_exit
if (midi_in_Open(0))
	ExitApp
Menu TRAY, Icon, icon4.ico

;--------------------  Midi "hotkey" mappings  -----------------------
;listenNoteRange(48, 52, "playSomeSounds", 0x02)
listenCC( 64, "pedal")

return
;----------------------End of auto execute section--------------------

sub_exit:
	midi_in_Close()
ExitApp

;-------------------------Miscellaneous hotkeys-----------------------

;-------------------------Midi "hotkey" functions---------------------
playSomeSounds(note, vel)
{
	SoundPlay drum48.wav
}

pedal(note, vel)
{
	if( vel >= 30 ){
		Send {Ctrl Down}
	}else{
		Send {Ctrl Up}
	}
}

;-------------------------  Midi input library  ----------------------
#include midi_in_lib.ahk
