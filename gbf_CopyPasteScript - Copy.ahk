CoordMode, Mouse, Screen

; Bindings: For most, MUST BE AT RESPECTIVE RAID/QUEST PAGE!	I MAY HAVE CHANGED A FEW, UPDATE LATER 
;	***ALL BINDINGS CAN BE CHANGED!! IT DOESN'T MATTER! BESIDES "," WHICH IS TREASURE PAGE***
;	L = MOST IMPORTANT BINDING, REFRESHED SCRIPT ESSENTIALLY STOPPING IT! May have to use often if timing is wrong. 
;		You'll understand what I am saying the more you use it. 
; 	\ = Basic Raid Finder Loop, MUST BE AT RAID PAGE, will fill everything out for you.
; 	] = Jumps to RAID MENU - If it fails to join, hit key to stop script. Return to Raid screen! 
;	' = Clicks ATTACK -> AutoPlay
;	J = for play again, then auto attack loop.
; 	k = VioletTrial grind..
;	/ = Angel Hell
; 	. = Treasure Quest: Campaign-Exclusive Quest
;	, = Jump to Treasure Quest Page
;	
; Set Variables up! Set 1 for ON

; ~*!!!!!!!! StrikeTime !!!!!!!!!*~ "Currently have it immediately ATTACK and refresh, then continue normal rotation (MCHT1)"
StrikeTime := 0 

LoopRunning := 0 ; Work in progress

Event := 0
Special := 0
; AngelHell := 0

; __________________________________________________________________________________________
; Coordinate Setup
; If resolution is 1920x1080, Only must set new COORDS for RaidFinder := [{x:_, y:_}] !!
; Position GBF on right side of screen, SEE GITHUB PICTURE FOR REFERENCE!!
; __________________________________________________________________________________________

; https://www.gbfraiders.com/
RaidFinder := [{x: 2069, y: -470}] ; Coords for tab with raidfinder activated. I have it on a different monitor. Yours coords will vary. 

RaidMenu := [{x: 1820, y: 300}, {x: 1570, y: 560}, {x: 1760, y: 560}]
	  ; [{Enter ID TAB}, {SEARCH BAR}, {JOIN RAID}, {OK BUTTON}]

Summons := [{x: 1650, y: 510}, {x: 1650, y: 640}, {x: 1650, y: 760}]

; During raids, 7 slot is the first summon menu button.
AttackSummon := [{x: 1455, y: 620}, {x: 1540, y: 620}, {x: 1620, y: 620}, {x: 1700, y: 620}, {x: 1780, y: 620}, {x: 1845, y: 620}, {x: 1800, y: 620}, {x: 1765, y: 595}] 	; TODO: Summon Coords in battle... 

PartyOK := [{x: 1760, y: 730}]

Character := [{x: 1455, y: 620}, {x: 1540, y: 620}, {x: 1620, y: 620}, {x: 1700, y: 620}] ; Char portraits during raid

SkillCoords := [{x: 1560, y: 640}, {x: 1665, y: 645}, {x: 1746, y: 645}, {x: 1830, y: 645}]

Attack := [{x: 1790, y: 480}, {x: 1470, y: 505}] ; Used for Attack and for when a battle finishes.. 
	; [{ATTACK}, {AUTO_ATTACK}] ; same coords as [{BACK}, {NEXT}]

OkContinue := [{x: 1650, y: 600}] 		; *OK Button* After battle ends
playAgain := [{x: 1650, y: 560}]
EventItem := [{x: 1540, y: 530}]		; Guild War
EventMission := [{x: 1650, y: 690}, {x: 1650, y: 775}] ; Guild War
gwMissionsSelect := [{x: 1520, y: 690}, {x: 1660, y: 690}, {x: 1800, y: 690}] ; Guild War

BrowserSearch := [{x: 1630, y: 63}] 		; Raid ID /Browser Search Bar/

; Next part is a little difficult to assign, Very Specific quests
TreasureQuestList := [{x: 1800, y: 470}, {x: 1800, y: 590}, {x: 1800, y: 710}, {x: 1800, y: 830}]
SubQuestLengthOne := [{x: 1810, y: 580}] 	; Position after hitting ANY quest with a sub quest list of 1
SubQuestLengthThree := [{x: 0, y: 0}, {x: 1810, y: 577}, {x: 1810, y: 650}] ; Position after hitting ANY quest with a sub quest list of 3
SubQuestLengthSix :=  [{x: 1810, y: 190}, {x: 1810, y: 457}, {x: 1810, y: 530}, {x: 1810, y: 605} ] ; fire, water, earth so far
AngelHellList := [{x: 1800, y: 495}] 		; Must hit End to scroll to end of web page.
ElementalTreasure := [{x: 1800, y: 255}] 

; __________________________________________________________________________________________
; Simplified with subroutines for quick setup
; ";" are commented out lines, remove to reactivate
; 
; __________________________________________________________________________________________

\:: 	; "BASIC RAID MENU LOOP" This grabs a raid id from browser and pastes it within the raid search/join ID field
	Sleep 50 ; Used so inputs don't overlap "50ms"
	Gosub GetRaidID	 		; Go to tab and copy RAID ID
	Gosub NavigateRaidMenu		; Must be at raid listing page! "gbf.jp/#quest/assist" auto clicks RAID ID tab
	Gosub autoSummon  		; SUMMON Selection Page
	Gosub PartyReady		; Ready Party, wait and select OK to ready party
	
	; attackSummon(1) ; bonito
	; ***Team Skill rotation setup, This is only for first turn, can be setup for more than ONE turn :) ***
	; TeamRotation(1, 1, 0, 0, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my mch T1 ougi
	; TeamRotation(2, 0, 1, 0, 0)	; 2nd party member
	; TeamRotation(3, 1, 0, 0, 0)	; 3rd party member
	; TeamRotation(4, 0, 0, 1, 0)	; 4th party member	Light Ferry, 2nd skill
	
	
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return


; __________________________________________________________________________________________
; Examples of quick skill queue
; Bind a button and copy&paste -> change skills as needed. TODO: ADD SUMMONS TO SKILL QUEUE
; __________________________________________________________________________________________

; *Earth Grid Europa farm
p::
	TeamRotation(1, 1, 0, 0, 0) 	; MC
	TeamRotation(2, 0, 0, 1, 0)	; 2nd party member Eugen instant ougi
	TeamRotation(3, 1, 1, 0, 0)	; 3rd party member
	TeamRotation(4, 0, 1, 1, 0)	; Vira instant ougi
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return

; *Dark Grid, MHC1T
o::
	Sleep 50
	TeamRotation(1, 1, 1, 1, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my mch T1 ougi
	TeamRotation(2, 0, 1, 0, 0)	; 2nd party member
	TeamRotation(3, 0, 1, 0, 0)	; 3rd party member
	TeamRotation(4, 0, 1, 0, 0)	; 4th party member	Ferry, 2nd skill
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return

; Fire -> Grim farm
NumPad7:: 
	Sleep 50
	TeamRotation(1, 1, 1, 0, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my mch T1 ougi
	; TeamRotation(2, 0, 0, 0, 0)	; 2nd party member
	; TeamRotation(3, 0, 0, 0, 0)	; 3rd party member
	TeamRotation(4, 0, 1, 0, 0)	; 4th party member	
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return

; Dark Spartan -> Akasha 
NumPad6::
	attackSummon(1) ; Bahamut
	TeamRotation(4, 1, 1, 1, 0)	; 4th party member	kolo
	; TeamRotation(1, 0, 0, 0, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing)
	TeamRotation(2, 1, 1, 0, 0)	; 2nd party member
	; TeamRotation(3, 0, 0, 0, 0)	; 3rd party member
	; TeamRotation(4, 0, 1, 0, 0)	; 4th party member	kolo
	Gosub autoAttack  		; 
	return

u::
	attackSummon(6) ; shiva
	TeamRotation(1, 1, 1, 1, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my mch T1 ougi
	TeamRotation(2, 1, 0, 0, 0)	; 2nd party member
	TeamRotation(3, 0, 1, 0, 0)	; 3rd party membera
	TeamRotation(4, 1, 1, 1, 0)	; 4th party member	
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return

y::
	attackSummon(6) ; shiva
	TeamRotation(1, 1, 0, 1, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my mch T1 ougi
	TeamRotation(2, 1, 0, 0, 0)	; 2nd party member
	TeamRotation(3, 1, 0, 1, 1)	; 3rd party membera
	TeamRotation(4, 0, 0, 1, 0)	; 4th party member	
	Gosub autoAttack  		; After MCH OUGI -> AUTOATTACK
	return
; __________________________________________________________________________________________
; Menus, skills queues, and other timings
; Avoid touching below. YOU MAY NEED TO ADJUST TIMINGS ON DEPENDING ON YOUR INTERNET
; __________________________________________________________________________________________

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




;; rise of beast lesser event grind
f::
	clipboard := "http://game.granbluefantasy.jp/#event/advent"
	MouseClick, , BrowserSearch[1].x , BrowserSearch[1].y
	Sleep 50
	Send ^a
	Sleep 50
	Send ^v{Enter}
	Sleep 50
	Send {Enter}
   	clipboard := temp 		 ; Clipboard to previous text
	Sleep 2000
	MouseClick, , 1670 , 820 	; main frame
	Sleep 500
	
	MouseClick, , 1510 , 665 	; select beast
	Sleep randomDelay(900)
	
	Gosub autoSummon  		; SUMMON Selection Page
	Gosub PartyReady		; Ready Party, wait and select OK to ready party
	
	attackSummon(1) ; bonito
	Sleep randomDelay(6000)
	Gosub autoAttack  		; After kengo OUGI -> AUTOATTACK
	Sleep randomDelay(800)
	Send {F5}
	Sleep randomDelay(3000)
	Send {f}
	
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

r:: ; Return to Special Quest Page
	Sleep 50
	temp := clipboardall ; Store clipboard
   	clipboard := "http://game.granbluefantasy.jp/#quest/extra/event/11030"
	MouseClick, , BrowserSearch[1].x , BrowserSearch[1].y
	Sleep 50
	Send ^a
	Sleep 50
	Send ^v{Enter}
	Sleep 50
	Send {Enter}
   	clipboard := temp ; Clipboard to previous text
	Return

; *!RobomiZ!* Grinding for silver relics 
t:: 	
	Send {r}
	Sleep randomDelay(2000)
	MouseClick, , AngelHellList[1].x, AngelHellList[1].y
	Sleep randomDelay(1500)
	MouseClick, , SubQuestLengthThree[2].x, SubQuestLengthThree[2].y 	; SubQuestLengthThree := {x: 1810, y: 580}
	Sleep randomDelay(1500)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 850
	Gosub autoAttack
	
	Sleep 20000
	Send {t} 	; Repeat RobomiZ!
	Return


':: 
	Gosub autoAttack
	Return
	
autoAttack:
	Sleep 100
	MouseClick, , Attack[1].x, Attack[1].y
	Sleep randomDelay(1200)
	MouseClick, , Attack[2].x, Attack[2].y
	Return

; Summon rotations
attackSummon(n){	
	Global AttackSummon
	Sleep 800
	Mouseclick, , AttackSummon[7].x, AttackSummon[7].y
	Sleep 100
	Mouseclick, , AttackSummon[n].x, AttackSummon[n].y
	Sleep 100
	Mouseclick, , AttackSummon[8].x, AttackSummon[8].y + 70 ; bonito
	Sleep 100
}	

; Used mostly to prevent repetition, less likely to get caught? lol
autoSummon: 			; subroutine for Support Summon selection ; Support Summon Selection Page
	Random, n, 1, 3 	; random # between 1-3, grab SUMMON coordinates
	a := Summons[n].x	; Grab coords for Support Summon list positions!
	b := Summons[n].y	
	Sleep randomDelay(800)
	MouseClick, , a, b
	Return

GetRaidID:
	ControlClick, x180 y175, Granblue Raid Finder,,,, NA
	; MouseClick, , RaidFinder[1].x, RaidFinder[1].y ; Grab raid ID
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
	Sleep 5500
	Send {.}
	return

; *!Angel Halo!* Grinding for silver relics 
/:: 	
	Send {,}
	Sleep randomDelay(2000)
	Send {End}
	Sleep 1000
	MouseClick, , AngelHellList[1].x, AngelHellList[1].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x, SubQuestLengthThree[3].y 	; SubQuestLengthThree := {x: 1810, y: 580}
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 6000
	Gosub autoAttack
	
	Sleep 29000
	Send {/} 	; Repeat angel halo
	Return
	

; *!Violet Trial Very HARD!*
k::
	Send {,}
	Sleep randomDelay(1800)
	MouseClick, , TreasureQuestList[1].x, TreasureQuestList[1].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x, SubQuestLengthThree[3].y 		; SubQuestLengthThree := [{x: 0, y: 0}, {x: 0, y: 0}, {x: 1810, y: 650}]
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthThree[3].x, SubQuestLengthThree[3].y
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 5600
	Gosub autoAttack

	Sleep 26000
	Send {k} 	; Repeat angel halo
	return

; SubQuestLengthSix Wind deluge Farm
b::
	Send {,}
	Sleep randomDelay(2100)
	Send {End}
	Sleep 1000
	MouseClick, , ElementalTreasure[1].x, ElementalTreasure[1].y
	Sleep randomDelay(1000)
	MouseClick, , SubQuestLengthSix[2].x, SubQuestLengthSix[2].y 	; Change for Diff trial!
	Sleep randomDelay(1000)
	Gosub autoSummon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    ; [PartyOK := {x: 1760, y: 730}]
	Sleep 6000
	Gosub autoAttack
	
	Sleep randomDelay(29000)
	send ^{f5}
	Sleep randomDelay(5450)
	Send {b} 	; Repeat angel halo
	Return


; Play again U%F menu skip to summon page
ufSkip: 
	MouseClick, , OkContinue[1].x, OkContinue[1].y 		; Battle ended, OK
	Sleep randomDelay(1400)
	MouseClick, , EventMission[2].x, EventMission[2].y
	Sleep randomDelay(700)
	MouseClick, , EventItem[1].x, EventItem[1].y
	Sleep randomDelay(250)
	MouseClick, , playAgain[1].x, playAgain[1].y		; Play Again, Loop
	Sleep randomDelay(500)
	;MouseClick, , EventMission[1].x, EventMission[1].y
	;Sleep randomDelay(1000)
	Return

afterSummonReady: 
	attackSummon(1)	; Use summon slot 1, AKA Bonito, Change value for different summon slot..
	;TeamRotation(0, 0, 0, 0, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my KENGO BONITO BUILD
	TeamRotation(2, 1, 1, 0, 0)	; 2nd party member
	TeamRotation(3, 1, 0, 0, 0)	; 3rd party member
	TeamRotation(4, 0, 0, 1, 0)	; 4th party member	
	Gosub autoAttack
	Return

NumPad1::
	Gosub ufSkip
	Return
NumPad2::	
	Gosub afterSummonReady
	Sleep 4800
	Mouseclick, , 1675, 950
	Send ^{f5}
	Return

; *Play again UNITE AND FIGHT Ex+
g:: 
	Gosub ufSkip
	Gosub autoSummon					; grab support summon
	Sleep randomDelay(1000)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    		; OK
	Sleep 7800
	
	attackSummon(1)	; Use summon slot 1, AKA Bonito
	Sleep 6000
	TeamRotation(1, 1, 0, 1, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my KENGO BONITO BUILD
	TeamRotation(2, 0, 1, 0, 0)	; 2nd party member
	TeamRotation(3, 1, 1, 1, 0)	; 3rd party member
	TeamRotation(4, 1, 0, 0, 0)	; 4th party member	
	Gosub autoAttack
	Sleep 12000
	Send ^{f5}
	Sleep 5400
	Send j
	Return



; *Play again UNITE AND FIGHT TRASH grindv
j:: 
	MouseClick, , OkContinue[1].x, OkContinue[1].y 		; Battle ended, OK
	Sleep randomDelay(1400)
	MouseClick, , EventMission[2].x, EventMission[2].y
	Sleep randomDelay(800)
	MouseClick, , EventItem[1].x, EventItem[1].y
	Sleep randomDelay(200)
	MouseClick, , playAgain[1].x, playAgain[1].y		; Play Again, Loop
	Sleep randomDelay(500)
	MouseClick, , EventMission[1].x, EventMission[1].y
	Sleep randomDelay(1000)
	Gosub autoSummon					; grab support summon
	Sleep randomDelay(500)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    		; OK
	Sleep 5500

	attackSummon(1)	; Use summon slot 1, AKA Bonito

	Gosub autoAttack
	Send ^{f5}
	Sleep 5400
	Send j
	Return

; Guild War mission grinding. 
e:: 
	
	Sleep 50
	temp := clipboardall ; Store clipboard
   	clipboard := "http://game.granbluefantasy.jp/#event/teamraid053"
	MouseClick, , BrowserSearch[1].x , BrowserSearch[1].y
	Sleep 50
	Send ^a
	Sleep 50
	Send ^v{Enter}
	Sleep 50
	Send {Enter}
   	clipboard := temp ; Clipboard to previous text
	Sleep 2000

	MouseClick, ,1660, 890
	; MouseClick, , 1660, 750
	; gwMissionsSelect 1
	MouseClick, , gwMissionsSelect[3].x, gwMissionsSelect[3].y   
	Sleep 1400
	
	Gosub autoSummon					; grab support summon
	Sleep randomDelay(900)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    		; OK
	Sleep 6600
	attackSummon(1)	; Use summon slot 1, AKA Bonito
	Sleep randomDelay(8500)

	TeamRotation(1, 1, 0, 1, 0) 	; (MC*MEMBER* , skill1, skill2, nothing, nothing) *Currenty setup as my KENGO BONITO BUILD
	TeamRotation(2, 0, 1, 0, 0)	; 2nd party member
	TeamRotation(3, 1, 1, 1, 0)	; 3rd party member
	TeamRotation(4, 1, 0, 0, 0)	; 4th party member

	Gosub autoAttack
	Sleep 54000
	Send ^{f5}
	Sleep 5400
	Send e
	Return



randomDelay(x){
	Random,  n, x, x+500
	return n
}

PartyReady: 	; PartyOK := [{x: 1760, y: 730}]
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y
	Sleep 5800
	Return


; *Play again, normal quest grind
h:: 
	MouseClick, , OkContinue[1].x, OkContinue[1].y 		; Battle ended, OK
	Sleep randomDelay(1400)
	;MouseClick, , playAgain[1].x, playAgain[1].y		; Play Again, Loop
	MouseClick, , EventItem[1].x, EventItem[1].y  
	Sleep randomDelay(1000)
	Gosub autoSummon					; grab support summon
	Sleep randomDelay(1400)
	MouseClick, , PartyOK[1].x, PartyOK[1].y    		; OK
	Sleep 5450
	Gosub autoAttack
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
		Sleep 150
		send ^{f5}
		Sleep randomDelay(6300)	
	}
	if(Member != 1){ 				; Hit back only after MC has been finished
		Sleep 150
		MouseClick, , Attack[2].x, Attack[2].y	; Click Back
		Sleep 150
	}
	Sleep 100
	MouseClick, , Character[Member].x, Character[Member].y			; click portrait
	Sleep 50
	MouseClick, , Character[Member].x, Character[Member].y
	Sleep 50
	QueueSkill(skill1, 1)				; Sleep -> click skill
	QueueSkill(skill2, 2)
	QueueSkill(skill3, 3)
	QueueSkill(skill4, 4) 
}	

; Clicks multiple times due to skill/damage info
QueueSkill(skill, n){
	global SkillCoords
	if(skill = 1){
		Sleep 25
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
		Sleep 25
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
		Sleep 25
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
		Sleep 20
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
		Sleep 10
		MouseClick, , SkillCoords[n].x, SkillCoords[n].y
	}
}

; Testing control click
TeamRotationCC(Member, skill1, skill2, skill3, skill4){
	global Character
	global Attack
	global StrikeTime

	if(Member < 1 or Member > 4){ 			; Base case, Must be a valid member, ignore otherwise
		Return
	}		
	if(StrikeTime = 1 && Member = 1){ 		; If Strike time. Attack immediately, refresh.
		MouseClick, , Attack[1].x, Attack[1].y	; *Click* {ATTACK} 
		Sleep 150
		send ^{f5}
		Sleep randomDelay(6300)	
	}
	if(Member != 1){ 				; Hit back only after MC has been finished
		sleep 150
		MouseClick, , Attack[2].x, Attack[2].y	; Click Back
		Sleep 150
	}
	Sleep 100
	MouseClick, , Character[Member].x, Character[Member].y			; click portrait
	Sleep 50
	MouseClick, , Character[Member].x, Character[Member].y
	Sleep 50
	QueueSkill(skill1, 1)				; Sleep -> click skill
	QueueSkill(skill2, 2)
	QueueSkill(skill3, 3)
	QueueSkill(skill4, 4) 
}


l:: 	; reload script.
	Reload
	Return