BGP8DEMO ; IHS/CMI/LAB - demo patient search template ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 ;
UPDATE ;create/update Demo Patient Search Template
 D INTRO
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
SELECT ;
 W !!
 K DIC
 S DIC(0)="AEMQL",DIC("A")="Enter DEMO PATIENT Search Template: ",DIR("B")=$$VAL^XBDIQ1(90241.01,DUZ(2),.12),DIC="^DIBT(",DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" D ^DIC
 I Y=-1 D XIT Q
 S BGPSTMP=+Y
 I $P(^DIBT(+Y,0),U,4)="" S DA=+Y,DIE="^DIBT(",DR="4////2" D ^DIE K DIE,DA,DR
 ;
 ;display the existing template patients
 D EP
 D XIT
 Q
XIT ;
 D EN^XBVK("BGP")
 K DIR
 D ^XBFMK
 Q
 ;
INTRO ;
 W:$D(IOF) @IOF
 W !!,"CREATE/UPDATE ""DEMO"" PATIENT SEARCH TEMPLATE"
 W !!,"This option is used to create or update a patient search template that"
 W !,"contains the names of all of the ""demo"" or ""test"" patients in your"
 W !,"database.  This template will be used to exclude these patients from"
 W !,"all CRS reports.  Once the template is created you must remember to "
 W !,"enter the name of the template into your site's CRS Site Parameter file"
 W !,"using the Update Site Parameters option."
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
 D EN^XBVK("BGP")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BGP 08 DEMO SEARCH TEMPLATE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="DEMO/TEST PATIENTS TO EXCLUDE FROM CRS REPORTS"
 S VALMHDR(2)="* Patients currently included in the "_$P(^DIBT(BGPSTMP,0),U)_" search template"
 S X="",$E(X,7)="Patient Name",$E(X,40)="HRN"
 S VALMHDR(3)=X
 Q
 ;
INIT ; -- init variables and list array
 K BGPDEMO S BGPHIGH="",C=0
 S X=0 F  S X=$O(^DIBT(BGPSTMP,1,X)) Q:X'=+X  D
 .S C=C+1
 .S BGPDEMO(C,0)=C_")  "_$P(^DPT(X,0),U),$E(BGPDEMO(C,0),40)=$$HRN^AUPNPAT(X,DUZ(2))
 .S BGPDEMO("IDX",C,C)=X
 .Q
 S (VALMCNT,BGPHIGH)=C
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
 K DIC S DIC=9000001,DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G ADDX
 I $D(^DIBT(BGPSTMP,1,+Y)) W !!,"That patient is already in the template." G ADD1
 S ^DIBT(BGPSTMP,1,+Y)=""
 G ADD1
ADDX ;
 D BACK
 Q
REM ;EP - REMOVE PATIENT FROM SEARCH TEMPLATE
 W !
 S DIR(0)="NO^1:"_BGPHIGH,DIR("A")="Remove which Patient (enter the number from the list)"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No patient selected." G REMX
 I $D(DIRUT) W !,"No patient selected." G REMX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPPATI=BGPDEMO("IDX",Y,Y)
 W !!,$P(^DPT(BGPPATI,0),U)," removed from template.",!!
 K ^DIBT(BGPSTMP,1,BGPPATI)
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
REMX ;
 D BACK
 Q
