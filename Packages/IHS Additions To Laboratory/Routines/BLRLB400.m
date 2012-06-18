BLRLB400 ;IHS/CIA/PLS - OE/RR Order Lab for MicroCom 400;22-Jul-2005 23:17;SM
 ;;5.2;LR;**1020**;Sep 13, 2005
 ; Direct entry not allowed
 Q
 ; Open Execute for Terminal Type
 ; Input: OFX - X direction offset
OPEN(OFX) ;EP
 U IO
 W "^A22^D45",$C(13)          ; Gap Size
 W "^A49^D91",$C(13)          ; Load value (GAP)
 W "^AB00000000^D23",$C(13)   ; Printer Configuration
 W "^AB00000000^D24",$C(13)   ; Printer Configuration
 W "^AB10001011^D21",$C(13)   ; Printer Communication
 W "^AB00000000^D22",$C(13)   ; Printer Configuration
 W "^A3^D97",$C(13)           ; Tag/Tear - Advance when idle
 W "^A85^D95",$C(13)          ; Label steps advance
 W "^A0^D39",$C(13)           ; Clear autosize format mode
 W "^D57",$C(13)              ; Enter label format mode
 W "15,660,203,,,30,0,10,1,"_+$G(OFX),$C(13)         ; Header
 W "1,17,165,28,1,1",$C(13)   ; Patient Name
 W "2,300,165,14,1,1",$C(13)  ; Lab Order Number
 W "3,17,137,9,1,2",$C(13)    ; HRN
 W "4,185,137,10,1,2",$C(13)  ; DOB
 W "5,317,137,1,1,2",$C(13)   ; Sex
 W "6,17,117,25,1,1",$C(13)   ; Ordering Provider
 W "7,17,95,24,1,1",$C(13)    ; Hospital Location
 W "8,285,95,15,1,1",$C(13)   ; Room/Bed
 W "9,17,70,8,1,1",$C(13)     ; Urgency
 W "10,130,70,24,1,1",$C(13)  ; drawn by text
 W "11,17,46,18,1,1",$C(13)   ; Collection D/T
 W "12,210,46,19,1,1",$C(13)  ; Tube Color
 W "13,17,25,38,1,1",$C(13)   ; Test Name
 W "14,250,2,14,1,2",$C(13)   ; Lab Order Number
 W "15,22,2,14,40,3,,,2,20",$C(13)  ; Lab Order Number (Code 128 Barcode)
 W "^D56",$C(13)              ; Exit label format mode
 Q
 ;
OUT() ; EP
 N ORZTST,TST,SCNT
 U IO
 W "^D2",$C(13)
 W $$NAME^ORU($G(ORPNAME),""),$C(13)
 W "LB#:"_$G(ORPLB),$C(13)
 W $G(HRCN),$C(13)
 W $$DATE^ORU($G(ORPDOB),"MM/DD/CCYY HR:MIN"),$C(13)
 W $G(ORPSEX),$C(13)
 W "PHY:"_$$NAME^ORU($G(ORPRPHY),""),$C(13)
 W "LOC:"_$G(ORPLOC),$C(13)
 W $G(ORPRMBED),$C(13)
 W $G(ORPURG),$C(13)
 W "Drawn By:_______________",$C(13)
 W "CDT:______________",$C(13)
 W $G(ORPCOT),$C(13)
 D GETTST(.ORZTST)
 S TST=$G(ORZTST(1))
 S TST=$P(TST," ",1,$L(TST," ")-4)
 W $G(TST),$C(13)
 W "LB#:"_$G(ORPLB),$C(13)
 W $S($G(ORPLB):ORPLB,1:""),$C(13)
 W "^D3",$C(13)
 Q
TEST ;
 U IO
 W "^D2",$C(13)
 W "TEST,PATIENT WITH LONG NAME",$C(13)
 W "LB#:3392829",$C(13)
 W 449302,$C(13)
 W "01/12/2005",$C(13)
 W "M",$C(13)
 W "Phy:SMITH,PHYSICIAN NAMED",$C(13)
 W "Loc:EMERGENCY ROOM 2ND FLOOR ROOM 103",$C(13)
 W "R/B: A201-1",$C(13)
 W "ROUTINE",$C(13)
 W "Drawn By:_______________",$C(13)
 W "CDT:______________",$C(13)
 W "TUBE TOP IS MARBLE",$C(13)
 W "HEPATITIS B  SURFACE ANTIGEN",$C(13)
 W "LB#:3392829",$C(13)
 W "3392829",$C(13)
 W "^D3",$C(13)
 Q
 ;
GETTST(Y) ;API TO RETURN TESTNAME
 N ORPDAD
 S ORPDAD=$O(^OR(100,ORIFN,2,0)) D TEXT^ORQ12(.Y,ORIFN_$S($G(OACTION):";"_OACTION,1:"")) M ^TMP("ORP:",$J)=Y S OROOT2="^TMP(""ORP:"",$J)"
 Q
 ;
AUTOSIZE ;
 D ^%ZIS
 Q:POP
 U IO
 W "^A1^D39",$C(13)
 D ^%ZISC
 Q
