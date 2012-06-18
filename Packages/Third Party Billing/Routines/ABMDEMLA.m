ABMDEMLA ; IHS/ASDST/DMJ - Edit Utility - FOR MULTIPLES PART 2 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**4**;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 04/26/01 - V2.4 Patch 9 - NOIS BXX-0401-150085
 ;     Allow resequencing of DX when list contains more than
 ;     30 characters.
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
S2 K ABMX F ABMX=1:1 S ABMX("Y")=$P(Y,",",ABMX) Q:ABMX("Y")=""  Q:+ABMX("Y")'>0!(ABMX("Y")'<(ABMZ("NUM")+1))!$D(ABMX(ABMX("Y")))  S ABMX(ABMX("Y"))=ABMX
 I (ABMZ("NUM")+1)'=ABMX W *7,!!,"ERROR: Invalid input, to re-sequence all sequence numbers must be specified",!,"       and separated with commas.",! Q
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_",",DIC(0)="LE"
 K ^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB")) S ^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB"),0)="^9002274.30"_ABMZ("SUB")_"P^^"
 F ABMX=1:1:ABMZ("NUM") S X=$P(ABMZ(ABMX),U,3),DIC("DR")=".02////"_ABMX(ABMX)_";.05////"_$P($G(ABMZ(ABMX)),U,5) S:ABMZ("X")="DINUM" DINUM=X D DR
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
 .S DR=".02///"_ABMCNT
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
