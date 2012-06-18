ABMDEML ; IHS/ASDST/DMJ - Edit Utility - FOR MULTIPLES ;   
 ;;2.6;IHS Third Party Billing;**1,2,3,6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 09/07/01 - V2.4 Patch 7 - NOIS HQW-0701-100066
 ;     Modifications made related to Medicare Part B.
 ; IHS/ASDS/LSL - 10/29/01 - V2.4 Patch 9 - NOIS HQW-0701-100066
 ;     The above change doesn't work as ABMP("HCFA") is undefined.
 ;     Changed code back to listing HCFA modes of export.
 ;
 ; IHS/SD/SDR - 11/19/2003 - v2.5 p4 - IM11671
 ;     Added 837 format to list so it would inquire for corresponding
 ;     diagnosis
 ; IHS/SD/SDR - V2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p8 - 7/9/04 - IM14079 - Edited code to not do TOS prompt
 ;     if 837 format
 ; IHS/SD/SDR - v2.5 p8 - IM12246
 ;    Added In-House and Reference LAB CLIA prompts
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code to populate mileage on page 3A when A0425/A0888 are used
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Coded for new line item provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM20346
 ;   Variables getting carried over for Stuff tag
 ; IHS/SD/SDR - v2.5 p10 - IM21539
 ;   Made OBSTETRICAL? question be asked in correct place
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6566 - populate anes based on MCR/non-MCR
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ; IHS/SD/SDR - abm*2.6*3 - HEAT11696 - added 36415 to use lab prompts
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12742 - removed HEAT6566 changes
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added prompt for 2400 DTP test date
 ; *********************************************************************
 ;
A1 ;
 ; Documentation by Linda Lehman 3/19/97
 ; Entry Point for pages in the claim editor that allow multiple 
 ; additions.  Pages 8A, 8B, 8E, 8F, 8G, 8H, 8I
 ; (If select A as desired ACTION)
 ;
 ; VARIABLES:
 ;
 ; ABMZ("DR")  String of fields to be filed by ^DIE
 ; ABMZ("TITL")  Title corresponding to Claim Editor page number
 ; ABMZ("DICS")  Specific code for lookup screen
 ; ABMZ("SUB")  Number of multiple in 3P Claim File
 ; ABMZ("DICI")
 ; ABMZ("DICW")
 ; ABMZ("ANTH")  Set to null if page 8G, otherwise undefined
 ; ABMZ("REVN")  Revenue code field for DR string (only set on 
 ;               pages 8A, 8E, 8F)
 ; ABMZ("MOD")   Modifier field # in 3P Claim appropriate multiple ^
 ;               modifier category ^
 ;               2nd modifier field #  ^  (only if HCFA)
 ;               3rd modifier field #     (only if HCFA)
 ;
 ;                  Modifier category 1 = Medical      (27)
 ;                                    2 = Anesthesia   (39)
 ;                                    3 = Surgical     (21)
 ;                                    4 = Radiology    (35)
 ;                                    5 = Laboratory   (37)
 ; 
 ; ABMZ("NARR")  Providers narrative, 1st piece is field # for DR
 ; ABMZ("CHRG")  
 I $G(ABM)]"" S ABMZ("DR")=ABM
 E  S ABM=ABMZ("DR")
 K ABMX,DIC
 W:$D(ABMZ("TITL")) !!!,"===============  ADD MODE - ",ABMZ("TITL"),"  ==============="
 I $D(ABMZ("RX")) D  Q:Y<1  G DUPCHK
 .D RX^ABMDEMLB
 .Q:Y<1
 .S Y=$P(Y(0),U,6)
 .S ABMZ("DR")=$P(ABMZ("DR"),".03")_".03//"_$P(Y(0),U,7)_$P(ABMZ("DR"),".03",2)_";.06////"_$P(Y(0),U)
 ;If a special screen exist for this page (only 8G), then use that 
 ;code.  Otherwise, find the screen for the file that the .01 field 
 ;of specified 3P claim file multiple points to.
 I $D(ABMZ("DICS")) S DIC("S")=ABMZ("DICS")
 E  S ABMX("DICS")="9002274.30"_ABMZ("SUB") X:$D(^DD(ABMX("DICS"),.01,12.1)) ^DD(ABMX("DICS"),.01,12.1)
 S DIC=$S($D(ABMZ("DICI")):ABMZ("DICI"),1:ABMZ("DIC"))
 S DIC(0)="QEAM"
 S DIC("A")="Select "_ABMZ("ITEM")_": "
 S:$D(ABMZ("DICW")) DIC("W")=ABMZ("DICW")
 ;
DIC ;
 ; Perform look-up into specified file.
 D ^DIC
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(X=""),DIC:+Y<1
 K DIC
 ; if anesthesia page or revenue code multiple . . . 
 I $D(ABMZ("ANTH"))!(ABMZ("SUB")=25) S Y=$P(Y,U,2)
 ;
DUPCHK ;USED TO BE THE DUPLICATE CHECK LINE TAG
 S ABMX("Y")=+Y
 ;if Dental multiple (page) . . . 
 ;and no opsite asked add level of serive to DR string
 I $G(ABMZ("SUB"))=33 D
 .I $P(^AUTTADA(ABMX("Y"),0),U,9)]"" S ABMZ("DR")=$P(ABMZ("DR"),";.05")
 .S ABMX("NEWY")=1_$P(Y,"^",2)
 ;Go get modifiers if no revenue code
 G MOD:'$D(ABMZ("REVN"))
 ;If default revenue code for CPT code, add to DR string and get mods
 I $P($$IHSCPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,3)>0 S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("REVN"),"//")_"//"_$P($$IHSCPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,3) G MOD  ;CSV-c
 ;If CPT category and it has a default revenue code in the
 ;CPT category file, add it DR string and get mods
 I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,4)>0,$P($$IHSCAT^ABMCVAPI($P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,4),ABMP("VDT")),U)'="" D  G MOD  ;CSV-c
 .S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("REVN"),"//")_"//"_$P($$IHSCAT^ABMCVAPI($P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,4),ABMP("VDT")),U)  ;CSV-c
 S ABMZ("DR")=ABMZ("DR")_ABMZ("REVN")
 ;
MOD ;
 I $D(ABMZ("MOD")) D MOD^ABMDEMLC   ; Add modifiers
 ;If provider narrative. . . Ask it . . . add to DR string
 I $D(ABMZ("NARR")) D
 .S ABMX("DICB")=$P(@(ABMZ("DIC")_ABMX("Y")_",0)"),U,$P(ABMZ("NARR"),U,2))
 .D NARR^ABMDEMLC
 .I $G(ABMZ("SUB"))=17&($P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y")&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) S ABMZ("DR")=ABMZ("DR")_";.05//"
 .S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("NARR"),U)_+Y
 I '$D(ABMZ("CHRG")) G DIAG
 S ABMX("DIC")=$S($E(ABMZ("DIC"),3,5)="CPT":ABMZ("CAT"),$E(ABMZ("DIC"),6,8)="ADA":21,1:31)
 I ABMX("DIC")=31 S Y=$E(Y,1,2)_"0"
 I $G(ABMZ("CAT"))=13 D
 .I ABMX("Y")<70000 S ABMX("DIC")=11 Q
 .I ABMX("Y")<80000 S ABMX("DIC")=15 Q
 .I ABMX("Y")<90000 S ABMX("DIC")=17 Q
 .I ABMX("Y")<100000 S ABMX("DIC")=19 Q
 I $D(ABMZ("ANTH")) S ABMX("DIC")=23
 I $D(ABMZ("CONTRACT")) D CONT^ABMDEMLB I Y=1 G DIAG
 I $D(ABMZ("OUTLAB")) D LAB^ABMDEMLB I Y=1 G DIAG
 S:'$G(ABMX("NEWY")) ABMX("NEWY")=ABMX("Y")
 S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")
 I $D(^ABMDFEE(ABMP("FEE"),ABMX("DIC"),ABMX("NEWY"),0)) D
 .S ABMZ("DR")=ABMZ("DR")_$S($D(ABMP("638")):"//",ABMZ("SUB")=43:"//",ABMZ("CAT")=23:"//",1:"///")
 .I +$G(ABMZ("MODFEE"))=$G(ABMZ("MODFEE")) D  Q
 ..S ABMZ("DR")=ABMZ("DR")_ABMZ("MODFEE")
 .;S ABMZ("DR")=ABMZ("DR")_$P(^ABMDFEE(ABMP("FEE"),ABMX("DIC"),ABMX("NEWY"),0),"^",2)  ;abm*2.6*2 3PMS10003A
 .S ABMZ("DR")=ABMZ("DR")_$P($$ONE^ABMFEAPI(ABMP("FEE"),ABMX("DIC"),ABMX("NEWY"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 D POSA^ABMDEMLC
 ;I ABMP("EXP")'=21,(ABMP("EXP")'=22),(ABMP("EXP")'=23) D TOSA^ABMDEMLC  ;don't do for 837 formats  ;abm*2.6*6 5010
 ;I ABMP("EXP")'=21,(ABMP("EXP")'=22),(ABMP("EXP")'=23),(ABMP("EXP")'=32) D TOSA^ABMDEMLC  ;don't do for 837 formats  ;abm*2.6*6 5010  ;abm*2.6*8 5010
 I ABMP("EXP")'=21,(ABMP("EXP")'=22),(ABMP("EXP")'=23),(ABMP("EXP")'=31),(ABMP("EXP")'=32),(ABMP("EXP")'=33) D TOSA^ABMDEMLC  ;don't do for 837 formats  ;abm*2.6*6 5010  ;abm*2.6*8 5010
 ;I $G(ABMX("Y"))>79999,$G(ABMX("Y"))<90000 D  ;lab charges only  ;abm*2.6*3 HEAT11696
 I ($G(ABMX("Y"))>79999&($G(ABMX("Y"))<90000))!($G(ABMZ("SUB"))=37&(ABMX("Y")=36415)) D  ;lab charges only  ;abm*2.6*3 HEAT11696
 .I $D(ABMX("MODS",90)) S ABMZ("DR")=ABMZ("DR")_";.14//"_$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)'="":$P($G(^ABMRLABS($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23),0)),U,2),1:"")
 .E  S ABMZ("DR")=ABMZ("DR")_";.13//"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)
 I ABMZ("SUB")=37 D
 .Q:+$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMX("Y"),0))=0
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMX("Y"),0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"
 .S:(ABMP("EXP")=22) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21"
 .S:(ABMP("EXP")=32) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21;.22"  ;abm*2.6*6 5010
 .;S:(ABMP("EXP")=21) ABMZ("DR")=ABMZ("DR")_";W !,!,""Value Code 48 or 49 should be present on Page 9C"",!"  ;abm*2.6*8 5010
 .S:((ABMP("EXP")=21)!(ABMP("EXP")=31)) ABMZ("DR")=ABMZ("DR")_";W !,!,""Value Code 48 or 49 should be present on Page 9C"",!"  ;abm*2.6*8 5010
 I $P($G(^ICPT(ABMX("Y"),0)),U,3),($P($G(^DIC(81.1,$P($G(^ICPT(ABMX("Y"),0)),U,3),0)),U)["IMMUNIZATION") S ABMZ("DR")=ABMZ("DR")_";15"  ;abm*2.6*6 5010
 ;
DIAG ;CORRESPONDING DIAGNOSES
 D
 .Q:'$D(ABMZ("DIAG"))
 .;I '$D(ABMP("EXP",2)),'$D(ABMP("EXP",3)),'$D(ABMP("EXP",14)),'$D(ABMP("EXP",15)),'$D(ABMP("EXP",19)),'$D(ABMP("EXP",20)),'$D(ABMP("EXP",22)),'$D(ABMP("EXP",27)) Q  ;abm*2.6*6 5010
 .I '$D(ABMP("EXP",2)),'$D(ABMP("EXP",3)),'$D(ABMP("EXP",14)),'$D(ABMP("EXP",15)),'$D(ABMP("EXP",19)),'$D(ABMP("EXP",20)),'$D(ABMP("EXP",22)),'$D(ABMP("EXP",27)),'$D(ABMP("EXP",32)) Q  ;abm*2.6*6 5010
 .D DX^ABMDEMLC Q:$G(Y(0))=""
 .S ABMZ("DR")=ABMZ("DR")_ABMZ("DIAG")_"////"_$G(Y(0))
 ;
STUFF ;FILE MULTIPLE
 K DR,DIC,DA
 S ABMZ("DR")=ABMZ("DR")_";.17///M"
 I $L($T(@ABMZ("SUB"))) D @(ABMZ("SUB"))
 I ABMZ("SUB")'=23&(ABMZ("SUB")'=45) D
 .S Y=ABMX("Y")
 .G XIT:'+Y
 .S X=+Y
 .S @ABMZ("X")=X
 .S DA(1)=ABMP("CDFN")
 .S DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 .S DIC("DR")=$P(ABMZ("DR"),";",2,99)
 .S DIC(0)="LE"
 .S:$D(ABMZ("DR2")) DIC("DR")=DIC("DR")_ABMZ("DR2")
 .S:+$G(ABMZ("NUM"))=0 ^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB"),0)="^9002274.30"_ABMZ("SUB")_"P^^"
 .K DD,DO
 .D FILE^DICN
PROV ;
 I ABMZ("SUB")=21!(ABMZ("SUB")=23)!(ABMZ("SUB")=27)!(ABMZ("SUB")=35)!(ABMZ("SUB")=37)!(ABMZ("SUB")=39)!(ABMZ("SUB")=43) D
 .K DIC,DR,DIE,DA
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=+Y
 .S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DIC(0)="AELMQ"
 .S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 .I $G(ABMDPRV)'="" S DIC("B")=ABMDPRV
 .K ABMDPRV
 .S DIC("P")=$P(^DD(ABMFLNM,.18,0),U,2)
 .;default to rendering
 .S DIC("DR")=".02//RENDERING"
 .;change default to ordering if rendering exists already
 .I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA(1),"P","C","R")) S DIC("DR")=".02//ORDERING"
 .D ^DIC
 D MILEAGE
 I ABMZ("SUB")=23 D A^ABMDE8D
 G XIT:$D(ABMZ("ADD1"))
 S:$D(ABMZ("DR2")) $P(ABMZ("DR2"),"////",2)=$P(ABMZ("DR2"),"////",2)+1
XIT ;
 K ABMX,DIC
 Q
39 ;EP - dr string for anesthesia page
 S ABMZ("DR")=ABMZ("DR")_";.15//11;.07:.08"  ;abm*2.6*1 HEAT6566
 ;I ABMP("ITYP")'="R" S ABMZ("DR")=ABMZ("DR")_";.15//11;.07:.08"  ;abm*2.6*1 HEAT6566
 ;I ABMP("ITYP")="R" S ABMZ("DR")=ABMZ("DR")_";.12//1;.06;.07:.09;.03"  ;abm*2.6*1 HEAT6566
 Q
MILEAGE ;
 I (ABMZ("SUB")=47)!(ABMZ("SUB")=43),"A0888^A0425"[$P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2) D  ;CSV-c
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),"B",ABMX("Y"),0))
 .I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0425" S DR=".128////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8))  ;CSV-c
 .I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0888" S DR=".129////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9))  ;CSV-c
 .D ^DIE
 Q
