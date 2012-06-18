APCLDEMO ; IHS/CMI/LAB - Check for demo patients ; 29 Jun 2009  6:38 AM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
UPDATE ;create/update Demo Patient Search Template
 D INTRO
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
SELECT ;
 S APCLSTMP=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 I APCLSTMP G N
 K DIC
 S DIC(0)="L",X="RPMS DEMO PATIENT NAMES",DIC="^DIBT(",DIADD=1,DLAYGO=.401,DIC("DR")="4///2" D ^DIC
 I Y=-1 W !!,"Unable to create search template." D XIT Q
 K DIC,DLAYGO,DIADD
 S APCLSTMP=+Y
 D ^XBFMK
 ;
N ;display the existing template patients
 D EP
 D XIT
 Q
XIT ;
 D EN^XBVK("APC")
 K DIR,DLAYGO,DIADD
 D ^XBFMK
 Q
 ;
INTRO ;
 W:$D(IOF) @IOF
 W !!,"CREATE/UPDATE ""DEMO"" PATIENT LIST"
 W !!,"This option is used to update a patient search template (list) that"
 W !,"contains the names of all of the ""demo"" or ""test"" patients in your"
 W !,"database.  This template will be used to exclude these patients from"
 W !,"all PCC Management reports.  "
 W !!
 Q
 ;
 ;
 ;
 ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("APC")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCL DEMO SEARCH TEMPLATE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="DEMO/TEST PATIENTS TO EXCLUDE FROM PCC MANAGEMENT REPORTS"
 S VALMHDR(2)="* Patients currently included in the "_$P(^DIBT(APCLSTMP,0),U)_" list"
 S X="",$E(X,7)="Patient Name",$E(X,40)="HRN"
 S VALMHDR(3)=X
 Q
 ;
INIT ; -- init variables and list array
 K APCLDEMO S APCLHIGH="",C=0
 S X=0 F  S X=$O(^DIBT(APCLSTMP,1,X)) Q:X'=+X  D
 .S C=C+1
 .S APCLDEMO(C,0)=C_")  "_$P(^DPT(X,0),U),$E(APCLDEMO(C,0),40)=$$HRN^AUPNPAT(X,DUZ(2))
 .S APCLDEMO("IDX",C,C)=X
 .Q
 S (VALMCNT,APCLHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
ADD1 W !!
 NEW AUPNLK
 S AUPNLK("ALL")="",AUPNLK("INAC")=""
 K DIC S DIC=9000001,DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G ADDX
 I $D(^DIBT(APCLSTMP,1,+Y)) W !!,"That patient is already in the list." G ADD1
 S ^DIBT(APCLSTMP,1,+Y)=""
 G ADD1
ADDX ;
 D BACK
 Q
REM ;EP - REMOVE PATIENT FROM SEARCH TEMPLATE
 W !
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Remove which Patient (enter the number from the list)"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No patient selected." G REMX
 I $D(DIRUT) W !,"No patient selected." G REMX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCLPATI=APCLDEMO("IDX",Y,Y)
 W !!,$P(^DPT(APCLPATI,0),U)," removed from list.",!!
 K ^DIBT(APCLSTMP,1,APCLPATI)
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
REMX ;
 D BACK
 Q
