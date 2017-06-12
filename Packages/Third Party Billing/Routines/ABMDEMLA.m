ABMDEMLA ; IHS/ASDST/DMJ - Edit Utility - FOR MULTIPLES PART 2 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**4,9,11,14**;NOV 12, 2009;Build 238
 ;
 ; IHS/ASDS/LSL - 04/26/01 - V2.4 Patch 9 - NOIS BXX-0401-150085
 ;     Allow resequencing of DX when list contains more than 30 characters.
 ;
 ;IHS/SD/SDR - 2.6*14 - ICD10 002F - Added code to populate new .06 field, ICD Indicator
 ;IHS/SD/SDR - 2.6*14 - HEAT163742 - Fixed issue with sequencing when 'garbage' is entered
 ;
 ; *********************************************************************
 ;
S1 ; Sequence Multiple
 K DIR S DIR("B")=1 F ABMX=2:1:ABMZ("NUM") Q:ABMX>ABMZ("NUM")  S DIR("B")=DIR("B")_","_ABMX
 I DIR("B")=1 G XIT
 S DIR(0)="FO^1:40"
 S DIR("A")="Enter the desired billing sequence"
 S DIR("?")="Enter the billing sequence, separated by commas"
 S DIR("A",1)=" "
 S DIR("A",2)="          If you need to change the current billing order then"
 S DIR("A",3)="          enter the sequence numbers above in the desired order"
 S DIR("A",4)="          separated by commas."
 S DIR("A",5)=" "
 S DIR("A",6)="          NOTE: If the billing sequence is different from that noted"
 ;S DIR("A",7)="                in the file then a Physcian's Attestation is required!"  ;abm*2.6*4 NOHEAT
 S DIR("A",7)="                in the file then a Physician's Attestation is required!"  ;abm*2.6*4 NOHEAT
 S DIR("A",8)=" "
 D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)
S2 ;
 ;K ABMX F ABMX=1:1 S ABMX("Y")=$P(Y,",",ABMX) Q:ABMX("Y")=""  Q:+ABMX("Y")'>0!(ABMX("Y")'<(ABMZ("NUM")+1))!$D(ABMX(ABMX("Y")))  S ABMX(ABMX("Y"))=ABMX  ;abm*2.6*11 HEAT116046
 ;start new abm*2.6*14 HEAT163742
 S ABMCHKFG=0
 F ABMX=1:1:$L(Y) D
 .S ABMXTEST=$E(Y,ABMX)
 .I '((ABMXTEST=",")!(($A(ABMXTEST)>48)&($A(ABMXTEST)<58))) S ABMCHKFG=1
 I ABMCHKFG=1 D  G S1
 .W !!,"Non-numeric data entered during sequencing.  Separate using commas."
 .W !,"Please try again"
 ;end new NOHEAT7
 K ABMX F ABMX=1:1 S ABMX("Y")=+$P(Y,",",ABMX) Q:ABMX("Y")=""  Q:+ABMX("Y")'>0!(ABMX("Y")'<(ABMZ("NUM")+1))!$D(ABMX(ABMX("Y")))  S ABMX(ABMX("Y"))=ABMX  ;abm*2.6*11 HEAT116046
 I (ABMZ("NUM")+1)'=ABMX W *7,!!,"ERROR: Invalid input, to re-sequence all sequence numbers must be specified",!,"       and separated with commas.",! Q
 ;S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_",",DIC(0)="LE"  ;abm*2.6*14 ICD10 002F
 ;K ^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB")) S ^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB"),0)="^9002274.30"_ABMZ("SUB")_"P^^"  ;abm*2.6*14 ICD10 002F
 ;start new code abm*2.6*14 ICD10 002F
 S ABMTMP=0
 F  S ABMTMP=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),"C",ABMTMP)) Q:'ABMTMP  D
 .S ABMTMP2=0
 .F  S ABMTMP2=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),"C",ABMTMP,ABMTMP2)) Q:'ABMTMP2  D
 ..S DA(1)=ABMP("CDFN")
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 ..S DA=ABMTMP2
 ..D ^DIK
 K ABMTMP,ABMTMP2
 D ^XBFMK
 ;end new code ICD10 002F
 ;F ABMX=1:1:ABMZ("NUM") S X=$P(ABMZ(ABMX),U,3),DIC("DR")=".02////"_ABMX(ABMX)_";.05////"_$P($G(ABMZ(ABMX)),U,5) S:ABMZ("X")="DINUM" DINUM=X D DR  ;abm*2.6*9 HEAT63840
 ;F ABMX=1:1:ABMZ("NUM") S X=$P(ABMZ(ABMX),U,3),DIC("DR")=".02////"_ABMX(ABMX)_";.03////"_$P($G(ABMZ(ABMX)),U,3)_";.04////"_$P($G(ABMZ(ABMX)),U,5)_";.05////"_$P($G(ABMZ(ABMX)),U,6) S:ABMZ("X")="DINUM" DINUM=X D DR  ;abm*2.6*9 HEAT63840  ;abm*2.6*14 ICD10 002F
 ;start new code abm*2.6*14 ICD10 002F
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 S DIC(0)="LE"
 F ABMX=1:1:ABMZ("NUM") D
 .S X=$P(ABMZ(ABMX),U,3)
 .S DIC("DR")=".02////"_ABMX(ABMX)
 .S DIC("DR")=DIC("DR")_";.03////"_$P($G(ABMZ(ABMX)),U,3)_";.04////"_$P($G(ABMZ(ABMX)),U,5)_";.05////"_$P($G(ABMZ(ABMX)),U,6)_";.06////"_$P($G(ABMZ(ABMX)),U,7)
 .S:ABMZ("X")="DINUM" DINUM=X
 .D DR
 ;end new code ICD10 002F
 Q
 ;
RES(ABMULT) ;EP - RESET PRIORITIES - X=MULTIPLE
 N DIE,DA
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),DA(1),ABMULT,"
 S ABMI=0,ABMCNT=0
 F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMULT,"C",ABMI)) Q:'ABMI  D
 .S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMULT,"C",ABMI,0))
 .S ABMCNT=ABMCNT+1
 .;S DR=".02///"_ABMCNT  ;abm*2.6*14 ICD10 002F
 .S DR=".02////"_ABMCNT  ;abm*2.6*14 ICD10 002F
 .D ^DIE
 K ABMI,ABMULT,ABMCNT
 Q
 ;
DR ;DR LINE TAG
 S:$P(ABMZ(ABMX),U,4)]"" DIC("DR")=DIC("DR")_";.03////"_$P(ABMZ(ABMX),U,4)
 S:$P(ABMZ(ABMX),U,5)]"" DIC("DR")=DIC("DR")_";.04////"_$P(ABMZ(ABMX),U,5)
 S:$P(ABMZ(ABMX),U,6)]"" DIC("DR")=DIC("DR")_";.05////"_$P(ABMZ(ABMX),U,6)
 S:$P(ABMZ(ABMX),U,7)]"" DIC("DR")=DIC("DR")_";.06////"_$P(ABMZ(ABMX),U,7)
 S:$P(ABMZ(ABMX),U,8)]"" DIC("DR")=DIC("DR")_";.07////"_$P(ABMZ(ABMX),U,8)
 S:$P(ABMZ(ABMX),U,9)]"" DIC("DR")=DIC("DR")_";.08////"_$P(ABMZ(ABMX),U,9)
 S:$P(ABMZ(ABMX),U,10)]"" DIC("DR")=DIC("DR")_";.09////"_$P(ABMZ(ABMX),U,10)
 K DD,DO D FILE^DICN
 Q
 ;
AN ;EP for Entering Anesthesia info
 Q
 ;
XIT K ABMX
 Q
