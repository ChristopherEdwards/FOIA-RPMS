ABMDE ; IHS/ASDST/DMJ - Claim Editor Selection ;      
 ;;2.6;IHS Third Party Billing;**1,3,6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 08/13/2001 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;     Only check eligibility once.
 ;
 ; IHS/ASDS/LSL - 08/10/2001 - V2.4 Patch 9 - NOIS OVA-0801-190038
 ;     Unlock the claim file as the lock table is filling up.
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for new page selection (page 3A and page 8K)
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;   Added code for Next if ADA and page 9F
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - Added check for page9
 ; IHS/SD/SDR - abm*2.6*3 - HEAT10547 - modified page9 check to display 9F & 9G for
 ;  all export modes; all others only for UB or 837I
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added changes for page3B
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - fix for <NOLINE>SCRN+2^ABMDE
 ;
 ; *********************************************************************
 ;
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,15)'="Y" D  G XIT
 .W !!?5,*7,"ACCESS to the CLAIM EDITOR is DENIED until SITE PARAMETERS file",!?5,"has been Reviewed!"
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 K ABMPP,ABMP("PAYM"),DIC
 S ABMPERM("EDITOR")=1
 ;
CLM2 ;EP - CLM2 ENTRY POINT
 G XIT:$G(ABMP("PAYM"))!$D(ABMPP("CLM"))
 K ABM,ABMP,ABMX,ABMV,ABMZ,ABMC,ABMU,ABML,DIROUT,DIRUT,DIR,DTOUT,DUOUT
 W !
 D ^ABMDEDIC
 G XIT:$D(DIROUT)!$D(DIRUT)!$D(DUOUT)!$D(DTOUT)!'+$G(ABMP("CDFN"))
 K ABMP("MULT")
 K ABMLOC
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
EXT ;EP - Entry Point used when Adding New Claim
 L +^ABMDCLM(DUZ(2),ABMP("CDFN")):0 I $T G CHK
 W !!,"Claim # ",ABMP("CDFN")
 W *7," - Another User is Editing this Record, try Later!",!
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q:$D(ABMPP("STATUS"))
 G CLM2
 ;
CHK ;
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="C" D  G CLM2
 . W *7,!!!?5,"**** All billing has been completed for Claim: "
 . W ABMP("CDFN")," ****"
 . W !?10,"The claim is thus closed and uneditable.",!!
 . L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 ;
DFN ;
 S ABMP("PDFN")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,1)
 S ABMP("VTYP")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,7)
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".1////"_DT
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="F" S DR=".04////E;"_DR
 D ^DIE
 K DR
 ;
CNT ;
 S ABMP("SCRN")=0
 S ABMP("RTN")="^ABMDE0"
 D ^ABMDEVAR
 ;
SCRN ;EP - Entry Point for Detailed Claim Display
 S ABMP("LABEL")=""
 D @ABMP("RTN")
 I ($D(ABMP("CHK"))!$D(ABMP("DDL")))&($D(DUOUT)!$D(DIROUT)!$D(DTOUT)) D  Q
 .L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 I $D(DTOUT)!$D(DIROUT)!$D(ABMP("QUIT")) D  G XIT
 .L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 I $D(DIRUT)!$D(DUOUT)!$D(ABMP("OVER")) D  G CLM2
 .L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 I $D(Y),Y="Q" L -^ABMDCLM(DUZ(2),ABMP("CDFN")) G CLM2
 I $G(ABMNOELG) L -^ABMDCLM(DUZ(2),ABMP("CDFN")) G CLM2   ; ABMNOELG set in ABMDE0
 I '$D(ABMP("PAGE")) D PAGE^ABMDEVAR
 I $E(Y)="J",($E(Y,2)>0&($E(Y,2)<10))!($E(Y,2)=0),ABMP("PAGE")[$E(Y,2) D JUMP^ABMDEPG G RTN
 I "BN"'[Y D SCRN^ABMDEPG:Y="J" G XIT:$D(DIROUT),SCRN:$D(DIRUT) W:+Y=0&(Y'=0) *7 G SCRN:+Y=0&(Y'=0) S ABMP("SCRN")=Y G RTN
 I Y="B" D  G RTN
 .S ABMTEMP=$G(ABMP("PAGE"))_","
 .S ABMTEMP=$P(ABMTEMP,(","_ABMP("SCRN")_","))
 .S ABMP("SCRN")=$P(ABMTEMP,",",$L(ABMTEMP,","))
 .K ABMTEMP
 S ABMTEMP=$P(ABMP("PAGE"),ABMP("SCRN")_",",2)
 S ABMP("SCRN")=$P(ABMTEMP,",")
 K ABMTEMP
 ;
RTN ;
 S:ABMP("SCRN")="3A" ABMP("SCRN")="31"
 S:ABMP("SCRN")="3B" ABMP("SCRN")="32"  ;abm*2.6*6 5010
 S:ABMP("SCRN")[5 ABMP("SCRN")=5  ;abm*2.6*8
 ;I ABMP("SCRN")["9" S ABP("SCRN")="9"  ;abm*2.6*1 HEAT6439  ;abm*2.6*6
 I ABMP("SCRN")["9" S ABMP("SCRN")="9"  ;abm*2.6*1 HEAT6439  ;abm*2.6*6
 I $P($G(^ABMDEXP(ABMP("EXP"),0)),U)["837 P",(+ABMP("SCRN")["9") S ABMP("LABEL")="OPT6"  ;abm*2.6*3 HEAT10547
 ;I $P($G(^ABMDEXP(ABMP("EXP"),0)),U)["ADA",(+ABMP("SCRN")["9") S ABMP("LABEL")="OPT6"  ;abm*2.6*8
 S:+ABMP("SCRN")=0 ABMP("SCRN")=0
 S ABMP("RTN")=ABMP("LABEL")_"^ABMDE"_ABMP("SCRN")
 I '$G(ABMPERM("EDITOR")),($G(ABMP("SCRN"))="") G XIT
 G SCRN
 ;
XIT ;EXIT POINT
 I $D(ABMPP("STATUS")) S ABMPP("STATUS")=$S($D(ABMP("OVER")):0,$D(DUOUT)!($G(Y)="Q"):1,1:2)
 I '$D(ABMC("DDL")) K ABMP,ABM,ABMV,ABME,ABMX,ABML,ABMZ,ABMC,ABMU
 K ABMPERM("EDITOR")
 I $D(ABMP("CDFN")) L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 Q
