﻿CoordMode, Mouse, Screen


; Set Variables up! 
StrikeTime := 0 ; !!!!!!!!!!!!!!!!!!!!!!
LoopRunning := 0
Event := 0
Special := 0
AngelHell := 0

RaidMenu := [{x: 2250, y: -280}, {x: 1820, y: 300}, {x: 1570, y: 560}, {x: 1760, y: 560}]
	  ; [{1st Raid}, {ID BUTTON}, {SEARCH BAR}, {JOIN RAID}, {OK BUTTON}]

Summons := [{x: 1650, y: 510}, {x: 1650, y: 640}, {x: 1650, y: 760}]

Skill := [{x: 1760, y: 730}, {x: 1470, y: 600}, {x: 1570, y: 645}, {x: 1660, y: 645}] ; Skill positions
	; [{MC}, {MCHSK1}, {MCHSK2}, {MCHSK3}] ; To do: Add Coords for all other Team Characters!

Attack := [{x: 1790, y: 480}, {x: 1470, y: 505}] ; Used for Attack and for when a battle finishes.. 
	; [{ATTACK}, {AUTO_ATTACK}] ; same coords as [{BACK}, {NEXT}] 

OkContinue := [{x: 1650, y: 600}] ; *OK* After battle ends. 

BrowserSearch := [{x: 1700, y: 60}] ; Raid ID Search Bar

\::
	Loop % RaidMenu.Length(){		       ; Cycle through all coordinates
			x := RaidMenu[A_Index].x ; Pull the coordinates out of the array
			y := RaidMenu[A_Index].y
			MouseClick, , x, y     ; *CLICK*
			if (A_Index = 1){      ; first click in the sequence
				Sleep 500
			}
			if(A_Index = 3){
				MouseClick, , x, y
				Send ^a
				Send ^v{Enter}
			}
	}
	Gosub autoSummon  ; SUMMON Selection Page
	Gosub mchAutoOugi ; Specifically for Mechanic class, can add more detailed turns later. 
	Gosub autoAttack  ; After OUGI -> AUTOATTACK
	return


]:: ; If it fails to join, hit key to stop script. Return to Raid screen! 
	Sleep 50
	temp := clipboardall ; Store clipboard
   	clipboard := "http://game.granbluefantasy.jp/#quest/assist"
	MouseClick, , BrowserSearch[1].x , BrowserSearch[1].y
	Sleep 50
	Send ^a
	Sleep 50
	Send ^v{Enter}
	Sleep 50
	Send {Enter}
   	clipboard := temp ; Clipboard to previous text
	Return


;:: ; Return to Treasure Quest Page
	Sleep 50
	temp := clipboardall ; Store clipboard
   	clipboard := "http://game.granbluefantasy.jp/#quest/extra"
	MouseClick, , BrowserSearch[1].x , BrowserSearch[1].y
	Sleep 50
	Send ^a
	Sleep 50
	Send ^v{Enter}
	Sleep 50
	Send {Enter}
   	clipboard := temp ; Clipboard to previous text
	Return

':: 
	Gosub autoAttack
	Return
	
autoAttack:
	Sleep 100
	MouseClick, , Attack[1].x, Attack[1].y
	Sleep 1200
	MouseClick, , Attack[2].x, Attack[2].y
	Sleep 100
	Return

autoSummon: ; subroutine for Support Summon selection ; Support Summon Selection Page
	Random, n, 1, 3 ; random # between 1-3, grab SUMMON coordinates
	a := Summons[n].x	; Grab coords for Support Summon list positions!
	b := Summons[n].y	
	Sleep 800
	MouseClick, , a, b
	Return
	
; !! Class Specific !!
mchAutoOugi: ; Uses MECHANIC skills = Activate -> Cusomized Action -> AutoAttack auto leech.
	Loop % Skill.Length(){
		c := Skill[A_Index].x
		d := Skill[A_Index].y
		if(A_Index = 1){	; Party select *OK BUTTON*
			Sleep 1400
			MouseClick, , c, d
		}
		if(StrikeTime = 1 and A_Index = 1){ ; If Strike time. Attack immediately, refresh.
			Sleep 5400	; wait for raid to load, then *CLICK* "ATTACK" Button
			MouseClick, , Attack[1].x, Attack[1].y
			Sleep 100
			send ^{f5}
			Sleep 50
		}
		if(A_Index = 2){ 	; MC Portrait, for MCH Skills, Check if StrikeTime! Change delay.
			if(StrikeTime = 1){
				Sleep 5450 ; Wait for page to refresh, then proceed. 
			}
			else{
				Sleep 5450
			}
			MouseClick, , c, d
		}
		if(A_Index > 2){	; MC Portrait skills.
			Sleep 100
			MouseClick, , c, d
		}
	}
	Return


[:: ; reload script.
	Reload
	Return

; TODO:
; Change timings of *Sleep* to avoid cheat detection... 