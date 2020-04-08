CoordMode, Mouse, Screen


; Set Variables up! 
StrikeTime := 0 ; ~*!!!!!!!!!!!! StrikeTime !!!!!!!!!!!!!*~
LoopRunning := 0
Event := 0
Special := 0
; AngelHell := 0


MemberFour := 1	; fourth party member

RaidFinder := [{x: 2250, y: -280}] ; Coords for tab with raidfinder activated. 

RaidMenu := [{x: 1820, y: 300}, {x: 1570, y: 560}, {x: 1760, y: 560}]
	  ; [{Enter ID TAB}, {SEARCH BAR}, {JOIN RAID}, {OK BUTTON}]

Summons := [{x: 1650, y: 510}, {x: 1650, y: 640}, {x: 1650, y: 760}]

PartyOK := [{x: 1760, y: 730}]

Character := [{x: 1455, y: 620}, {x: 1540, y: 620}, {x: 1620, y: 620}, {x: 1700, y: 620}]

mechanicRotation := [{x: 1470, y: 600}, {x: 1570, y: 645}, {x: 1660, y: 645}] ; MC & Skill positions
	; [{MC}, {MCHSK1}, {MCHSK2}] ; To do: Add Coords for all other Team Characters!

SkillCoords := [{x: 1560, y: 640}, {x: 1665, y: 645}, {x: 1746, y: 645}, {x: 1830, y: 645}]

Attack := [{x: 1790, y: 480}, {x: 1470, y: 505}] ; Used for Attack and for when a battle finishes.. 
	; [{ATTACK}, {AUTO_ATTACK}] ; same coords as [{BACK}, {NEXT}]

OkContinue := [{x: 1650, y: 600}] 		; *OK Button* After battle ends. 
playAgain := [{x: 1540, y: 530}]
BrowserSearch := [{x: 1700, y: 60}] 		; Raid ID /Search Bar/

TreasureQuestList := [{x: 1800, y: 470}, {x: 1800, y: 590}, {x: 1800, y: 710}, {x: 1800, y: 830}]
SubQuestLengthOne := [{x: 1810, y: 580}]
SubQuestLengthThree := [{x: 0, y: 0}, {x: 0, y: 0}, {x: 1810, y: 650}]
AngelHellList := [{x: 1800, y: 565}] 		; Must hit End to scroll to end of web page.

; __________________________________________________________________________________________
; Simplified with subroutines for quick setup
; __________________________________________________________________________________________

\:: 	; "BASIC RAID MENU LOOP"
	Sleep 50 ; Used so inputs don't overlap "50ms"
	Gosub GetRaidID	 		; Go to tab and copy RAID ID
	Gosub NavigateRaidMenu		; Must be at raid listing page! "gbf.jp/#quest/assist" auto clicks RAID ID tab
	Gosub autoSummon  		; SUMMON Selection Page
	Gosub PartyReady		; Ready Party, wait and select OK to ready party
;Gosub mchAutoOugi 		; Specifically for Mechanic class, can add more detailed turns later. ; contains party OK, !@CHANGE@!
	TeamRotation(1, 1, 1, 0, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing)
	TeamRotation(4, 0, 1, 0, 0)
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
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
   	clipboard := temp 		 ; Clipboard to previous text
	Return


NavigateRaidMenu: 
	Loop % RaidMenu.Length(){		        ; Cycle through all coordinates
			x := RaidMenu[A_Index].x 	; Pull the coordinates out of the array
			y := RaidMenu[A_Index].y
			MouseClick, , x, y		; *CLICK* {Enter ID TAB} -> {SEARCH BAR} -> {JOIN RAID} -> {OK BUTTON}
			if (A_Index = 1){      		; first click in the sequence
				Sleep 50
			}
			if(A_Index = 2){		; *Clicks* Search Bar -> Select all -> Paste *NEW* RAID ID
				MouseClick, , x, y
				Send ^a
				Send ^v{Enter}
			}
	}
	Return 

,:: ; Return to Treasure Quest Page
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
	Sleep randomDelay(1100)
	MouseClick, , Attack[2].x, Attack[2].y
	Sleep 100
	Return

autoSummon: 			; subroutine for Support Summon selection ; Support Summon Selection Page
	Random, n, 1, 3 	; random # between 1-3, grab SUMMON coordinates
	a := Summons[n].x	; Grab coords for Support Summon list positions!
	b := Summons[n].y	
	Sleep randomDelay(800)
	MouseClick, , a, b
	Return

GetRaidID:	
	MouseClick, , RaidFinder[1].x, RaidFinder[1].y ; Grab raid ID
	Sleep 500
	return

; *!AngelCampaign!* 
.:: 		; TreasureQuestList [{x: 1800, y: 470}], Grab first listed Special Quest
	Send {,}
	Sleep randomDelay(2000)
	MouseClick, , TreasureQuestList[1].x, TreasureQuestList[1].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthOne[1].x, SubQuestLengthOne[1].y 	; SubQuestLengthOne := {x: 1810, y: 580}
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 5450
	Gosub autoAttack
	send ^{f5}
	Sleep 5450
	Gosub autoAttack
	send ^{f5}
	Sleep 5450
	return

; *!Angel Halo!*
/:: 	
	Send {,}
	Sleep randomDelay(2000)
	Send {End}
	Sleep 1000
	MouseClick, , AngelHellList [1].x, AngelHellList [1].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x, SubQuestLengthThree[3].y 	; SubQuestLengthThree := {x: 1810, y: 580}
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 5450
	Gosub autoAttack
	Return
	

; *!Violet Trial Very HARD!*
k::
	Send {,}
	Sleep randomDelay(1800)
	MouseClick, , TreasureQuestList[3].x, TreasureQuestList[3].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x, SubQuestLengthThree[3].y 		; SubQuestLengthThree := [{x: 0, y: 0}, {x: 0, y: 0}, {x: 1810, y: 650}]
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x +1, SubQuestLengthThree[3].y +1 
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 5450
	Gosub autoAttack
	return

; *Pay again
j:: 
	MouseClick, , OkContinue[1].x, OkContinue[1].y 		; Battle ended, OK
	Sleep randomDelay(1300)
	MouseClick, , playAgain[1].x, playAgain[1].y		; Play Again, Loop
	Sleep randomDelay(1000)
	Gosub autoSummon					; grab support summon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    		; OK
	Sleep 5450
	Gosub autoAttack
	Return

randomDelay(x){
	Random,  n, x, x+500
	return n
}

PartyReady: 	; PartyOK := [{x: 1760, y: 730}]
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y
	Sleep 5700
	Return

; !! Class Specific !! Mechanic Rotation
mchAutoOugi: 						; Uses MECHANIC skills = Activate -> Cusomized Action -> AutoAttack auto leech.
	Loop % mechanicRotation.Length(){
		c := mechanicRotation[A_Index].x
		d := mechanicRotation[A_Index].y
		if(A_Index = 1){			; Party select *OK BUTTON*
			Sleep randomDelay(1600)
			MouseClick, , c, d
		}
		if(StrikeTime = 1 && A_Index = 1){ 	; If Strike time. Attack immediately, refresh.
			MouseClick, , Attack[1].x, Attack[1].y	; *Click* {ATTACK} 
			Sleep 200
			send ^{f5}
			Sleep 50
		}
		if(A_Index = 2){ 			; MC Portrait, for MCH Skills, Check if StrikeTime! Change delay.
			if(StrikeTime = 1){
				Sleep randomDelay(5800) 		; Wait for page to refresh, then proceed. 
			}
			else{
				Sleep randomDelay(5800)
			}
			MouseClick, , c, d
		}
		if(A_Index > 2){			; MC Portrait skills.
			Sleep 100
			MouseClick, , c, d
		}
	}
	if(MemberFour = 1){
		a := Character[4].x		; Member4 {x: 1700, y: 620}
		b := Character[4].y
		Sleep randomDelay(200)
		MouseClick, , Attack[2].x, Attack[2].y
		Sleep 200
		MouseClick, , a, b 			; click portrait
		Sleep 100
		MouseClick, , skillCoords[2].x, SkillCoords[2].y
		Sleep 100
		
	}
	
	Return

; (Member, skill1, skill2, skill3, skill4)
TeamRotation(Member, skill1, skill2, skill3, skill4){
	global Character
	global Attack
	global StrikeTime

	if(Member < 1 or Member > 4){ 			; Base case, Must be a valid member, ignore otherwise
		Return
	}		
	if(StrikeTime = 1 && Member = 1){ 		; If Strike time. Attack immediately, refresh.
		MouseClick, , Attack[1].x, Attack[1].y	; *Click* {ATTACK} 
		Sleep 200
		send ^{f5}
		Sleep randomDelay(6000)	
	}
	if(Member != 1){ 				; Hit back only after MC has been finished
		sleep 200
		MouseClick, , Attack[2].x, Attack[2].y	; Click Back
	}
	Sleep 100
	MouseClick, , Character[Member].x, Character[Member].y			; click portrait
	Sleep 100
	QueueSkill(skill1, 1)				; Sleep -> click skill
	QueueSkill(skill2, 2)
	QueueSkill(skill3, 3)
	QueueSkill(skill4, 4) 
}	

QueueSkill(skill, n){
	global SkillCoords
	if(skill = 1){
		Sleep randomDelay(100)
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
	}
}

l:: ; reload script.
	Reload
	Return

; TODO:
; Change timings of *Sleep* to avoid cheat detection...?