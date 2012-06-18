AG ; IHS/ASDS/EFG - INITIAL ROUTINE AND UTILITY SUB-ROUTINES ;     
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
 ; ****************************************************************
 ;
 S AG("VERDT")=""
 S AG("VERSION")=""
 S Y=""
 S (AGIEN,Y)=$O(^DIC(9.4,"C","AG",Y))
 I Y S AG("VERSION")=^DIC(9.4,Y,"VERSION")
 I AG("VERSION")]"" S Y=$O(^DIC(9.4,Y,22,"B",AG("VERSION"),""))
 I Y]"" D
 . S Y=$P(^DIC(9.4,AGIEN,22,Y,0),U,2)
 . D DD^%DT
 . S AG("VERDT")=Y
 I '$D(IOF) D
 . S IOP=ION
 . D ^%ZIS
 W $$S^AGVDF("IOF"),!?22
 F I=1:1:35 W "*"
 W !?22,"*",?56,"*"
 W !?22,"*      INDIAN HEALTH SERVICE      *"
 W !?22,"*   PATIENT REGISTRATION SYSTEM   *"
 I AG("VERSION")]"" D
 . ;W !?22,"*     VERSION ",AG("VERSION"),", ",AG("VERDT"),?56,"*"
 . W !?22,"*   VERSION ",AG("VERSION") W ".",$$CURPATCH
 . W ", ",AG("VERDT"),?56,"*"
 W !?22,"*",?56,"*",!?22
 F I=1:1:35 W "*"
 ;
SITE ;EP - From options.
 I '$D(DUZ(2)) D SET^XBSITE G L4:'$D(DUZ(2))
 W !!?80-$L($P(^DIC(4,DUZ(2),0),U))\2,$P(^(0),U)
 W !!,$$CJ^XLFSTR("*** NOTE:  IF YOU EDIT A PATIENT AND SEE THEIR NAME IN REVERSE VIDEO ***",IOM)
 W !,$$CJ^XLFSTR("*** WITH '(RHI)' BLINKING NEXT TO IT, IT MEANS THEY HAVE RESTRICTED ***",IOM)
 W !,$$CJ^XLFSTR("*** HEALTH INFORMATION ***",IOM)
 ;
L4 ;
 W !
 K AG,I,AG("VERDT"),AG("VERSION")
 Q
CURPATCH() ;EP - GET CURRENT PATCH LEVEL FOR HEADER
 N %,I,J
 S I=$O(^DIC(9.4,"B","IHS PATIENT REGISTRATION",0)) Q:'I 0
 S PENTRY=$O(^DIC(9.4,I,22,"B",AG("VERSION"),"")) Q:'PENTRY 0
 S PVER=$O(^DIC(9.4,I,22,PENTRY,"PAH","B"),-1) Q:'PVER 0
 S PVER=$P($G(^DIC(9.4,I,22,PENTRY,"PAH",PVER,0)),U)
 Q PVER
 ; ****************************************************************
READ ;EP - Standard READ sub-routine for Registration.
 K DIRUT  ;AG*7.1*2 ISSUE REPORTED DURING ALPHA TESTING
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT R Y:DTIME I '$T W *7 R Y:5 G READ:Y="." I '$T S (DTOUT,Y)="" Q
 S:Y="/.," (DFOUT,Y)=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y[U) (DQOUT,Y)=""
 Q
 ; ****************************************************************
RTRN ;EP
 S Y=1
 I $E(IOST)="C" D
 . S DIR(0)="E"
 . D ^DIR
 . K DIR
 Q
 ; ****************************************************************
NOW ;EP - Set AGTIME to time now.
 D NOW^%DTC
 S Y=%
 D DD^%DT
 S AGTIME=Y
 Q
 ; ****************************************************************
LINE ;EP - Standard writeline sub-routine.
 W !
 F AG("LI")=1:1:78 W AG("LINE")
 W !
 Q
 ; ****************************************************************
LINES ;EP  "Standard" lines of characters.
 S AG("-")=""
 S $P(AG("-"),"-",80)=""
 S AG("=")=""
 S $P(AG("="),"=",80)=""
 S AG("*")=""
 S $P(AG("*"),"*",80)=""
 Q
 ; ****************************************************************
CTR ;EP - Center X.
 S X=$J("",80-$L(X)\2)_X
 Q
 ; ****************************************************************
YN ;EP
 W !!,"Enter a ""Y"" for YES or an ""N"" for NO."
 Q
 ; ****************************************************************
KILL ;PEP - USED BY TPB TO CLEAN UP VARIABLES
 K ^UTILITY("DIQ1",$J)
 K %DT,A,AG,AGCHRT,AGI,AGLINE,AGOPT,AGPAT,AGSITE,AGUPDT
 K C,DFN,AG("DENT"),DFOUT,DIC,DIE,DLOUT,DTOUT,DQOUT,DUOUT,G,AGL,I,L
 K AGNEW,AGPCC,AGSCRN,AGTEMP,AG("TRBCODE"),X,XY,XYER,Y
 K AGAIN
 K AGSELECT
 Q
 ; ****************************************************************
VIDEO ;EP
 S XY=$G(^%ZIS(2,IOST(0),"XY")),XYER=$P($G(^(5)),"^",6)
 I XYER]"" S XYER="W "_XYER
 Q
 ; ****************************************************************
PTLK ;EP - Standard pt lookup using DIC.
 K DFN,RHIFLAG
 K DIC
 ;ENTER HERE IF YOU WISH TO KILL DIC YOURSELF
PTLKNKIL ;
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 D ^DIC
 ;I Y'=-1 S DFN=+Y D CHKRHI^AG
 I Y'=-1 S (AGPATDFN,DFN)=+Y D CHKRHI^AG  ;IHS/SD/TPF AG*7.1*1 FIX PROBLEM WITH CURRENT PAT. IN EDIT SCREEN CHANGING WHEN PATIENT LOOKUP IS USED (DFN CHANGES)
 I $D(RHIFLAG)  D
 . I RHIFLAG="A" W !,$$S^AGVDF("RVN"),$$S^AGVDF("BLN"),"This patient has Restricted Health Information",$$S^AGVDF("BLF"),$$S^AGVDF("RVF")
 ;ADD ALERT IF PATIENT HAS 'DATE OF DEATH' POPULATED IN VA
 ;PATIENT FILE
 I $D(DFN) I $$CHKDEATH^AGEDERR(DFN) W !!?5,"**** ALERT: DATE OF DEATH ON FILE FOR THIS PATIENT!!" H 2
 Q
 ; ****************************************************************
HDR ;EP - Print menu header.
 K AGNEWINS,DIR
 D:'$D(AGOPT) ^AGVAR
 I $D(X) S X=$P(^DIC(19,$O(^DIC(19,"B",X,0)),0),U,2)
 S Y="AG"
 G SHDR
 ; ****************************************************************
PHDR ;EP - Print parent menu header.
 D:$D(AGOPT) KILL
 I ^XUTL("XQ",$J,"T")=1 Q
 I ^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1)=-1 Q
 S X=$P(^DIC(19,+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1),0),U,2)
 S Y=$P(^DIC(19,+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1),0),U)
 I Y="AGMASTER" D ^AG Q
 ;
SHDR ;EP - Screen header.
 I '$D(IOF) D    ; defensive for menu jumping
 . S IOP="HOME"
 . D ^%ZIS
 I $D(X) D CTR
 W $$S^AGVDF("IOF")
 W !!?30,$S($E(Y,1,2)="AG":"PATIENT REGISTRATION",1:"")
 W !!?40-($L($P(^DIC(4,DUZ(2),0),U))\2),$P(^(0),U)
 I $D(X) W !!,X,!
 Q:$D(AG("RPT"))
 W !!,$$CJ^XLFSTR("*** NOTE:  IF YOU EDIT A PATIENT AND SEE THEIR NAME IN REVERSE VIDEO ***",IOM)
 W !,$$CJ^XLFSTR("*** WITH '(RHI)' BLINKING NEXT TO IT, IT MEANS THEY HAVE RESTRICTED ***",IOM)
 W !,$$CJ^XLFSTR("*** HEALTH INFORMATION ***",IOM)
 Q
 ; ****************************************************************
CPI ;EP
 W !?21,"*** CONFIDENTIAL PATIENT INFORMATION ***"
 Q
 ; ****************************************************************
DFNTR ;EP - External Packages
 ;check transmission required fields for patient DFN
 D ^AGDATCK
 D ^AGBADATA
 K AG,AGOPT,AGQI,AGQT,AGTP
 Q
 ; ****************************************************************
T ;EP - DISPLAY TIME IN HH:MM (AM/PM) FORMAT
 D NOW^%DTC
 S AG("TIME")=$P(%,".",2)
 S AG("HOUR")=$E(AG("TIME"),1,2)
 S AG("MINUTE")=$E(AG("TIME"),3,4)
 S AG("AMPM")="AM"
 I AG("HOUR")>11 D
 .S AG("AMPM")="PM"
 .I AG("HOUR")>12 S AG("HOUR")=AG("HOUR")-12
 W $J(+AG("HOUR"),2),":",AG("MINUTE")," ",AG("AMPM")
 Q
 ; ****************************************************************
CHKNPP ;EP - CHECK PATIENT FOR NOTICE OF PRIVACY PRACTICES ENTRY
 K REC,NPPFLAG
 S REC=$O(^AUPNNPP("B",DFN,""),-1)
 Q:REC=""
 S NPPFLAG=""
 Q
CHKRHI ;EP - CHECK PATIENT FOR RESTRICTED HEALTH INFORMATION
 Q:'$D(DFN)
 S REC=0 S RHIFLAG=""
 F  S REC=$O(^AUPNRHI("B",DFN,REC)) Q:'REC  D
 . I $P($G(^AUPNRHI(REC,0)),U,3)="A" S RHIFLAG="A"
 Q
