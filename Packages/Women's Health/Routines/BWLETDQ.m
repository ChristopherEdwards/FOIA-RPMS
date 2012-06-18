BWLETDQ ; CMI/TUCSON/LAB - PRINT QUEUED LETTERS ;03-Sep-2003 20:09;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8,9**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW PRINT QUEUED LETTERS" TO PRINT LETTERS
 ;;  BY "APRT" XREF IN ^BWNOT("APRT".
 ;
 ;IHS/CMI/LAB - patched to allow printing of letters by case manager
 ;and to reprint letters - patch 6
 ;IHS/CIA/PLS - logic added to disallow printing if Status is ERROR - Patch 9
 ;
START ;EP
 D SETUP G:BWPOP EXIT
 D CASEMAN G:BWPOP EXIT ;IHS/CMI/LAB - patch 6
 D DEVICE G:BWPOP EXIT
 D PRINT
 ;
EXIT ;EP
 D ^%ZISC
 D KILLALL^BWUTL8
 Q
 ;
CASEMAN ;print letters for one case manager or all
 ;IHS/CMI/LAB - patch 6 added this subroutine
 S BWPOP=0
 S BWCASEM="",BWCASEMN=""
 S DIR(0)="S^A:All Case Managers (Print ALL Queued Letters);O:One Case Manager (Letters for ONE Case Manager's Patients)",DIR("A")="Print Queued Letters for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BWPOP=1 Q
 S BWCASEM=Y
 Q:BWCASEM="A"
 K DIC,DA,DR,DD S DIC("A")="Which Case Manager:  ",DIC="^BWMGR(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,DR,DO
 I Y=-1 G CASEMAN
 S BWCASEMN=+Y
 Q
SETUP ;EP
 D SETVARS^BWUTL5 S BWPOP=0 K DIR
 S BWDUZ2=$G(DUZ(2))
 D TITLE^BWUTL5("PRINT QUEUED PATIENT LETTERS")
 I '$D(^BWNOT("APRT")) D  S BWPOP=1
 .S BWTITLE="* There are no letters waiting to be printed. *"
 .D CENTERT^BWUTL5(.BWTITLE)
 .W !!!!,BWTITLE,!!
 .D DIRZ^BWUTL3
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 K %ZIS,IOP
 S ZTRTN="PRINT^BWLETDQ",ZTSAVE("BWDUZ2")="",ZTSAVE("BWCAS*")=""
 D ZIS^BWUTL2(.BWPOP,1)
 Q
 ;
PRINT ;EP
 D SETVARS^BWUTL5
 S BWCRT=$S($E(IOST)="C":1,1:0)
 ;---> USE BWION TO PRESERVE ION WHEN PRINTING MULTIPLE LETTERS.
 S (BWN,BWM)=0,BWION=ION
 F  S BWN=$O(^BWNOT("APRT",BWN)) Q:'BWN!(BWPOP)!(BWN>DT)  D
 .S BWDA=0
 .F  S BWDA=$O(^BWNOT("APRT",BWN,BWDA)) Q:'BWDA!(BWPOP)  D
 ..;---> QUIT IF NOT ASSOCIATED WITH THE USER'S CURRENT FACILITY.
 ..N BWFACIL S BWFACIL=$P(^BWNOT(BWDA,0),U,7)
 ..Q:((BWFACIL'=BWDUZ2)&(BWFACIL))
 ..;IHS/CIA/PLS - patch 9 - Kill xref and quit if status = ERROR
 ..I $P(^BWNOT(BWDA,0),U,14)="e" D  Q
 ...D KILLXREF^BWLETPR(BWDA,BWN)
 ..;IHS/CMI/LAB - patch 6 added next 3 lines to allow printing by
 ..;case manager
 ..;---> QUIT if BWCASEMN and BWCASEM="O" and this patients
 ..;     case manager is not equal to BWCASEMN
 ..I BWCASEM="O",BWCASEMN,$P(^BWP($P(^BWNOT(BWDA,0),U),0),U,10)'=BWCASEMN Q
 ..;---> BWKDT=DATE USED TO KILL "APRT" XREF IN ^BWLETPR
 ..S BWKDT=BWN,ION=BWION
 ..D PRINT^BWLETPR
 ..S BWM=BWM+1 K BWKDT
 I 'BWM D
 .W !!?17,"No letters are due to be printed at this time.",!!
 .D:BWCRT DIRZ^BWUTL3 W:'BWCRT @IOF
 Q
 ;
 ;
 ;----------
 ;----------
REPRINT ;EP
 ;---> FOR REPRINTING LETTERS,  REMAINDER OF THIS ROUTINE IS NEW.
 ;---> MENU OPTION FOR THIS SHOULD BE CREATED (SYNONYM "RQ") AND
 ;---> ADDED TO OPTION BW MENU-MANAGER'S FUNCTIONS.
 ;---> Prototype code for menu option to reprint letters.
 ;
 D SETVARS^BWUTL5 S BWPOP=0 K DIR
 D TITLE^BWUTL5("RE-PRINT PATIENT LETTERS"),REPRINTX
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP)
 Q:BWPOP
 D CASEMANX
 I BWPOP K BWCASEM,BWCASEMN Q
 ;
 N BWCOUNT S BWCOUNT=0
 N BWIEN S BWIEN=0
 F  S BWIEN=$O(^BWNOT(BWIEN)) Q:'BWIEN  D
 .N BWDATE
 .S BWDATE=$P(^BWNOT(BWIEN,0),U,11)
 .Q:BWDATE<BWBEGDT  Q:BWDATE>(BWENDDT+.9999)
 .;IHS/CIA/PLS - patch 9 - quit if status = ERROR
 .Q:$P(^BWNOT(BWIEN,0),U,14)="e"
 .I BWCASEM="O",BWCASEMN,$P(^BWP($P(^BWNOT(BWIEN,0),U),0),U,10)'=BWCASEMN Q
 .S ^BWNOT("APRT",BWDATE,BWIEN)=""
 .S BWCOUNT=BWCOUNT+1
 ;
 D
 .I 'BWCOUNT D  Q
 ..W !!?5,"No letters to re-queue for the selected date range."
 .;
 .W !!?5,BWCOUNT," letters re-queued for the selected date range."
 .W !?5,"This may include letters that never printed the first time."
 .W !?5,"In order to print these letters, you must run the"
 .W !?5,"PQ  PRINT QUEUED LETTERS menu option."
 ;
 D DIRZ^BWUTL3
 Q
 ;
 ;
 ;----------
REPRINTX ;EP
 ;;This option allows you to re-print letters for a date range.
 ;;
 ;;You will first be asked for a date range.  Any letter that has
 ;;a Print Date that falls within the date range specified by you
 ;;(first and last day inclusive) will be re-queued for printing.
 ;;
 ;;NOTE: This option does NOT actually print the letters; it merely
 ;;re-queues them for printing.  In order to re-print the letters
 ;;you must run the "PQ   PRINT QUEUED LETTERS" option.
 ;;
 N BWTAB,BWLINL
 S BWTAB=5,BWLINL="REPRINTX" D PRINTX(BWTAB,BWLINL)
 ;
 Q
 ;
 ;
 ;----------
CASEMANX ;
 ;IHS/CMI/LAB - patch 6 added this subroutine
 S BWPOP=0
 S BWCASEM="",BWCASEMN=""
 S DIR(0)="S^A:All Case Managers (Re-print ALL Letters);O:One Case Manager (Reprint Letters for ONE Case Manager)",DIR("A")="Reprint Letters for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BWPOP=1 Q
 S BWCASEM=Y
 Q:BWCASEM="A"
 K DIC,DA,DR,DD S DIC("A")="Which Case Manager:  ",DIC="^BWMGR(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,DR,DO
 I Y=-1 G CASEMAN
 S BWCASEMN=+Y
 Q
PRINTX(BWTAB,BWLINL) ;EP
 ;---> Print text at specified line label.
 ;
 S:'$G(BWTAB) BWTAB=0
 Q:$G(BWLINL)=""
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
