; This line will unroll any rolled up windows if the script exits
; for any reason:
OnExit, ExitSub

#SingleInstance, force 
#Persistent 
ws_MinHeight = 25
ws_IDList = ''
return  ; End of auto-execute section
#MaxHotkeysPerInterval 300

#z::
Loop
{

	WheelUp::
		MouseGetPos, , ypos 
		WinGet, ws_ID, ID, A
		if (ypos >= 0 and ypos <=25) {
			if (ws_Window%ws_ID% > 0)
			{
				Send {WheelUp}
				return
			} else {
				WinGetPos,,,, ws_Height, A
				ws_Window%ws_ID% = %ws_Height%
				WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
				ws_IDList = %ws_IDList%|%ws_ID%
				return
			}
		} else {
			Send {WheelUp}
			return
		}
		
	WheelDown::
		MouseGetPos, , ypos 
		WinGet, ws_ID, ID, A
		if (ypos >= 0 and ypos <=25) {
			Loop, Parse, ws_IDList, |
			{
				IfEqual, A_LoopField, %ws_ID%
				{
					; Match found, so this window should be restored (unrolled):
					StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
					WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
					StringReplace, ws_IDList, ws_IDList, |%ws_ID%
					ws_Window%ws_ID% =
					return
				}
			}
		} else {
			Send {WheelDown}
			return
		}


	return
}
	
ExitSub:
	Loop, Parse, ws_IDList, |
	{
		if A_LoopField =  ; First field in list is normally blank.
			continue      ; So skip it.
		;StringTrimRight, ws_Height, ws_Window%A_LoopField%, 0
		WinMove, ahk_id %A_LoopField%,,,,, %ws_Height%
	}

	
ExitApp  ; Must do this for the OnExit subroutine to actually Exit the script.
