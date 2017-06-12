ABMDEMLE ; IHS/ASDST/DMJ - Edit Utility - FOR MULTIPLES ;
 ;;2.6;IHS 3P BILLING SYSTEM;**3,6,8,9,10,11,13,14,15,18**;NOV 12, 2009;Build 289
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p6 - 7/9/04 - IM14079 and IM14121 - Edited code for TOS
 ;     call to not do if 837 format
 ; IHS/SD/SDR - v2.5 p8 - IM12246/IM17548 - Coded new prompts for In-House and Reference Lab CLIAs
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code for mileage population on page 3A and message about editing
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Added code for new provider multiple on service lines
 ; IHS/SD/SDR - v2.5 p9 - IM19820 - Fix for <UNDEF>E2+37^ABMDEMLE
 ; IHS/SD/SDR - v2.5 p10 - task order item 1 - Calls added for Chargemaster.  Calls supplied by Lori Butcher
 ; IHS/SD/SDR - v2.5 p11 - IM23175 - Added code so G0107 could be entered on the lab page.  It needs a CLIA number
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added code for SV5 segment
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added code for 2400 DTP Test Date
 ;IHS/SD/SDR - 2.6*13 - exp mode 35.  Linked occurrence codes (01 and 11) to page 3 questions (Date First Symptom and Injury Date)
 ;IHS/SD/SDR - 2.6*14 - HEAT161263 - Changed to use $$GET1^DIQ so output transform will execute for SNOMED/Provider Narrative; also
 ;  made change so provider narrative can't be edited if there are SNOMED codes present on claim
 ;IHS/SD/SDR - 2.6*14 - HEAT165301 - Removed link between page 9a and 3 introduced in patch 13
 ;IHS/SD/SDR - 2.6*15 - Added change so they can edit the POA even if there is a SNOMED on the claim
 ;IHS/SD/SDR - 2.6*18 - HEAT240919 - put code back from p14 so user can edit provider narrative
 ;
E1 ; Edit Multiple
 I ABMZ("NUM")=0 W *7,!!,"There are no entries to edit, you must first ADD an entry.",! K DIR S DIR(0)="E" D ^DIR K DIR Q
 S ABMX("EDIT")=""
 I $E(Y,2)>0&($E(Y,2)<(ABMZ("NUM")+1)) S Y=$E(Y,2) G E2
 I ABMZ("NUM")=1 S Y=1 G E2
 K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Edit",DIR("A")="Sequence Number to EDIT"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
E2 W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S ABMX("Y")=+Y
 I $P(ABMZ(+Y),U)="A0",$P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)="A3" W !,"Please edit this value on page 3A1" H 1 K ABMZ("Y"),ABMZ("DR") Q
 ;only execute MOD2^ABMDEMLC if it is not a tran code entry (Chargemaster)
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),0),U,17)'["|TC" D
 .I $D(ABMZ("MOD")),$P($G(^ABMDPARM(DUZ(2),1,2)),"^",5) D MOD2^ABMDEMLC S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")_"////"_ABMZ("MODFEE")
 ;start new code abm*2.6*9 NARR
 ;I ABMZ("SUB")>21,ABMZ("SUB")<47,ABMZ("SUB")'=41,$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN)) D  ;abm*2.6*10 HEAT74291
 I ABMZ("SUB")>21,ABMZ("SUB")<47,ABMZ("SUB")'=41,$G(ABMZIEN)'="",$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN)) D  ;abm*2.6*10 HEAT74291
 .Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;only 5010 formats
 .S ABMCNCK=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN,0))
 .I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S ABMZ("DR")=ABMZ("DR")_";22"
 ;end new code NARR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $D(ABMZ("DIAG")) D DX^ABMDEMLC G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABMZ("DR")=ABMZ("DR")_ABMZ("DIAG")_"////"_$G(Y(0))
 I $D(ABMZ("NARR")),$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3)) D  ;abm*2.6*14 HEAT161263  ;abm*2.6*18 IHS/SD/SDR HEAT240919  uncommented line
 .;I $D(ABMZ("NARR")),$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,$P(ABMZ(ABMX("Y")),U,2),1))="",$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3)) D  ;only allow editing of prv narr if SNOMED not present  ;abm*2.6*14 HEAT161263
 .;S ABMX("DICB")=$G(^AUTNPOV($P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3)),0))_U_$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3))  ;abm*2.6*14 HEAT161263
 .S IENS=$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3))  ;abm*2.6*14 HEAT161263
 .S ABMX("DICB")=$$GET1^DIQ(9999999.27,IENS,".01","E")  ;abm*2.6*14 HEAT161263
 .D NARR^ABMDEMLC S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("NARR"),U)_+Y
 .;I $G(ABMZ("SUB"))=17&($P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y")&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) S ABMZ("DR")=ABMZ("DR")_";.05//"  ;abm*2.6*15
 ;end old abm*2.6*18 IHS/SD/SDR HEAT240919
 I $G(ABMZ("SUB"))=17&($P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y")&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) S ABMZ("DR")=ABMZ("DR")_";.05//"  ;abm*2.6*15
 ; don't do POS if page 5 (Dxs)
 I $G(ABMZ("SUB"))'=17 D
 .D POSA^ABMDEMLC  ;abm*2.6*9 NOHEAT  ;abm*2.6*10 IHS/SD/AML HEAT76189 - <<REACTIVATED LINE>> REMOVE DUPLICATE POS FIELD FROM 8G, ASKS FOR POS NOW
 .I ABMP("EXP")'=21,(ABMP("EXP")'=22),(ABMP("EXP")'=23) D TOSA^ABMDEMLC  ;don't do for 837 formats
 ;I $G(ABMZIEN)'="",((ABMZIEN>79999)&(ABMZIEN<90000))!($P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,2)="G0107") D  ;G0107 or Lab charges only  ;CSV-c  ;abm*2.6*3 HEAT11696
 ;I $G(ABMZIEN)'="",((ABMZIEN>79999)&(ABMZIEN<90000))!($P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,2)="G0107")!(ABMZIEN=36415) D  ;G0107 or Lab charges only  ;CSV-c  ;abm*2.6*3 HEAT11696  ;abm*2.6*8 HEAT40295
 I $G(ABMZIEN)'="",((ABMZIEN>79999)&(ABMZIEN<90000))!($E($P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,2))="G")!(ABMZIEN=36415) D  ;G0107 or Lab charges only  ;CSV-c  ;abm*2.6*3 HEAT11696  ;abm*2.6*8 HEAT40295
 .S ABMXMOD=""
 .S DA=$P(ABMZ(ABMX("Y")),U,2)
 .I ABMZ("SUB")=43 F ABMMOD=5,8,9 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,ABMMOD)=90 S ABMXMOD=1
 .I ABMZ("SUB")=37 F ABMMOD=6,7,8 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,ABMMOD)=90 S ABMXMOD=1
 .I $G(ABMXMOD)'="" D
 ..S ABMODFLT=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,14):$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,14),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23))
 ..S ABMODFLT=$$GET1^DIQ(9002274.35,ABMODFLT,".01","E")  ;display ref lab by name, not IEN into ref lab file  ;abm*2.6*11 HEAT85498
 ..S ABMZ("DR")=ABMZ("DR")_";.13////@;.14//^S X=ABMODFLT"
 .E  S ABMZ("DR")=ABMZ("DR")_";.14////@;.13//"_$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,13):$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,13),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22))
 I ABMZ("SUB")=37 D
 .Q:+$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMZIEN,0))=0
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMZIEN,0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"
 .S:(ABMP("EXP")=22) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21"
 .S:(ABMP("EXP")=32) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21;.22"  ;abm*2.6*6 5010
 .S:(ABMP("EXP")=21) ABMZ("DR")=ABMZ("DR")_";W !,!,""Value Code 48 or 49 should be present on Page 9C"",!"
 I $D(ABMZ("REVN")) S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("REVN"),"//")
 I $D(ABMZ("CONTRACT")) D CONT^ABMDEMLB
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $D(ABMZ("OUTLAB")) D LAB^ABMDEMLB
 ;I $D(ABMP(638)),$D(ABMZ("CHRG")) S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")  ;abm*2.6*3
 I $D(ABMZ("CHRG")) S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")  ;abm*2.6*3
 I $D(ABMZ("RX")),'$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,$P(ABMZ(ABMX("Y")),U,2),0),U,6) D
 .W !!,"Select PRESCRIPTION NUMBER: "
 .D RX^ABMDEMLB
 .I Y>0 S ABMZ("DR")=ABMZ("DR")_";.06////"_$P(Y(0),U) Q
 .W !,*7,"No match was found in the PRESCRIPTION FILE for this Drug and Patient!",!
 I ABMZ("SUB")=39 D 39^ABMDEML
 I ABMZ("SUB")=43&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,4)="Y") S ABM("DR")=$S($G(ABM("DR")):ABM("DR")_";11;12;13;14",1:"11;12;13;14")  ;abm*2.6*6 5010
 S DA(1)=ABMP("CDFN"),DA=$P(ABMZ(ABMX("Y")),U,2),DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_",",DR=$E(ABMZ("DR"),2,200) D ^DIE K DR
 S DR=".17///M" D ^DIE
 ;start new code abm*2.6*6 5010
 I ABMZ("SUB")=21!(ABMZ("SUB")=27)!(ABMZ("SUB")=35)!(ABMZ("SUB")=37)!(ABMZ("SUB")=39)!(ABMZ("SUB")=43)!(ABMZ("SUB")=47) D
 .I $P($G(^ICPT($P(ABMZ(ABMX("Y")),U),0)),U,3)="" Q  ;CPT has no CPT category to check
 .I ($P($G(^DIC(81.1,$P($G(^ICPT(+$P(ABMZ(ABMX("Y")),U),0)),U,3),0)),U)["IMMUNIZATION") S DR="15//" D ^DIE
 ;end new code 5010
 ;I ABMZ("SUB")=51,"^01^11^"[("^"_$P($G(^ABMDCODE($P(ABMZ(ABMX("Y")),U,2),0)),U)_"^") S ABMOIEN=$P(ABMZ(ABMX("Y")),U,2) D OCCURCD^ABMDEML  ;abm*2.6*13 exp mode 35  ;abm*2.6*14 HEAT165301
PROV ;
 S DA=$P(ABMZ(ABMX("Y")),U,2)
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",0))>0 D
 .W !
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN)) Q:+ABMIEN=0  D
 ..W !?5,$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U),0)),U)
 ..W ?40,$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="R":"RENDERING",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="D":"ORDERING",1:"")
 .W !
 K DIC,DR,DIE,DA
 S DA(2)=ABMP("CDFN")
 S DA(1)=$P(ABMZ(ABMX("Y")),U,2)
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P($G(^DD(ABMFLNM,.18,0)),U,2)
 Q:DIC("P")=""
 I $G(ABMDPRV)'="" S DIC("B")=ABMDPRV  ;abm*2.6*10
 S DIC("DR")=".01;.02//RENDERING"
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA(1),"P","C","R",0))>0 S DIC("DR")=".01;.02//ORDERING"
 D ^DIC
 K DIC,DR,DIE,DA
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=$P(ABMZ(ABMX("Y")),U,2)
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 I $G(ABMP("EXP"))=14!($G(ABMP("EXP"))=22) D
 .S ABMPVCKR=0
 .S ABMPVCKD=0
 .S ABMTYP=""
 .S ABMLN=$P(ABMZ(ABMX("Y")),U,2)
 .F  S ABMTYP=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMLN,"P","C",ABMTYP)) Q:ABMTYP=""  D
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMLN,"P","C",ABMTYP,ABMIEN)) Q:+ABMIEN=0  D
 ...I ABMTYP="R" S ABMPVCKR=+$G(ABMPVCKR)+1
 ...I ABMTYP="D" S ABMPVCKD=+$G(ABMPVCKD)+1
 .I ABMPVCKR>1!(ABMPVCKD>1) D  G PROV
 ..W !!,"YOU HAVE ENTERED TWO ",$S(ABMPVCKR>1:"RENDERING",1:"ORDERING")," PROVIDERS AND ONLY ONE CAN BE PUT ON AN 837P."
 ..K ABMPVCKR,ABMPVCKD,ABMTYP,ABMIEN,ABMLN
MILEAGE ;
 ;I ((ABMZ("SUB")=47)!(ABMZ("SUB")=43)),("A0888^A0425"[$P(ABMZ(ABMX("Y")),U)) D  ;abm*2.6*10 COB billing
 I ((ABMZ("SUB")=47)!(ABMZ("SUB")=43)),("^A0888^A0425^"[("^"_$P(ABMZ(ABMX("Y")),U))_"^") D  ;abm*2.6*10 COB billing
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .;start old code abm*2.6*10 HEAT68832
 .;S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),"B",ABMX("Y"),0))
 .;I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0425" S DR=".128////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8))  ;CSV-c
 .;I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0888" S DR=".129////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9))  ;CSV-c
 .;end old code start new code HEAT68832
 .S ABMIEN=$P(ABMZ(ABMX("Y")),U,2)
 .I $P(ABMZ(ABMX("Y")),U)="A0425" D
 ..;changed below during p10 testing to update page 3A all the time
 ..;S DR=".128////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8))  ;CSV-c  ;abm*2.6*10
 ..S DR=".128////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3)  ;abm*2.6*10
 .I $P(ABMZ(ABMX("Y")),U)="A0888" D
 ..;changed below during p10 testing to update page 3A all the time
 ..;S DR=".129////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9))  ;CSV-c  ;abm*2.6*10
 ..S DR=".129////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3)  ;abm*2.6*10
 .;end new code HEAT68832
 .D ^DIE
 ;
XIT K ABMX
 Q
