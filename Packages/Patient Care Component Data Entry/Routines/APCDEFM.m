APCDEFM ; IHS/CMI/LAB - prcess visit in list man ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;This routine in the driver routine for data entry option
 ;ENTER DATA W/ITEM LIST.  It prompts for enough information
 ;to create or select a visit and then uses list manager to 
 ;present the data entry items to the user for selection.
 ;
 ;BJPC v1.0 patch 1
EN ;EP - called from option
HDR ; Write Header
 D EN1^APCDEKL ;clean up before starting
 D EN2^APCDEKL
 W:$D(IOF) @IOF
 F APCDJ=1:1:5 S APCDX=$P($T(TEXT+APCDJ),";;",2) W !?80-$L(APCDX)\2,APCDX
 K APCDX,APCDJ,APCDEXIT
 W !!
 D ^APCDEIN ;set up data entry site parameters
 Q:APCDFLG
 S APCDTPLT("NAME")="MNEMONIC",APCDTPLT=0 ;these are needed for data entry routines
 D PROCESS
 D EOJ
 Q
 ;
 ;
 ;
PROCESS ;process each visit
GETLOC ; GET LOCATION OF ENCOUNTER
 S APCDLOC="" I $D(APCDDEFL),APCDDEFL]"" S DIC("B")=$P(^DIC(4,APCDDEFL,0),U)
 S DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDLOC=+Y
 ;
GETTYPE ; GET TYPE OF ENCOUNTER
 S APCDTYPE=""
 K DTOUT,DUOUT,DIRUT,DIROUT,DIR,DA
 I $D(APCDDEFT),APCDDEFT]"" S DIR("B")=APCDDEFT
 S DIR(0)="9000010,.03",DIR("A")="TYPE" D ^DIR K DIR
 G:$D(DIRUT) GETLOC
 S APCDTYPE=X
 ;
GETCAT ; GET SERVICE CATEGORY
 S APCDCAT=""
 K DTOUT,DUOUT,DIRUT,DIROUT,DIR,DA
 I $D(APCDDEFS),APCDDEFS]"" S DIR("B")=APCDDEFS
 S DIR(0)="9000010,.07",DIR("A")="SERVICE CATEGORY" D ^DIR K DIR
 G:$D(DIRUT) GETTYPE
 S APCDCAT=X
 ;
GETDATE ; GET DATE OF ENCOUNTER
 S APCDDATE=""
 W !!,"VISIT DATE: " R X:$S($D(DTIME):DTIME,1:300) S:'$T X=""
 G:X=""!(X="^") GETCAT
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S APCDDATE=Y
GETPAT ; GET PATIENT
 D GETPAT^APCDEA
 Q:APCDPAT=""
GETVISIT ;
 S APCDNOXV="" D ^APCDALV K APCDNOXV
 I $D(APCDAFLG)#2,APCDAFLG=2 W $C(7),!,"VISIT date not valid for current patient!",! S APCDFLG=1 Q
 I APCDVSIT="" W !!,"No visit selected." Q
 I $D(APCDVSIT("NEW")),$P(^APCCCTRL(DUZ(2),0),U,12)]"",$P($P(^AUPNVSIT(APCDVSIT,0),U),".")'<$P(^APCCCTRL(DUZ(2),0),U,12) S DA=APCDVSIT,DIE="^AUPNVSIT(",DR="1111///R" D ^DIE K DIE,DA,DR
 ;above added for EHR and auditing of visits, d/e created
 S APCDLVST=APCDVSIT
 S DIE="^AUPNPAT(",DR=".16///TODAY",DA=APCDPAT D ^DIE
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 I AUPNDOB]"" S X2=AUPNDOB,X1=APCDDATE D ^%DTC S AUPNDAYS=X
CLN ;
 G:$P(^AUPNVSIT(APCDVSIT,0),U,8) LM
 W !!,"Please enter the clinic this patient is attending.",!
 S APCDCLN=""
 S DIC("A")="Enter Clinic Type: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC
 I X="" W !,"Clinic is Required." K APCDDATE,APCDVSIT G GETDATE
 I Y<0 G CLN
 S APCDCLN=+Y
 S DIE="^AUPNVSIT(",DA=APCDVSIT,DR=".08///`"_APCDCLN D ^DIE K DIE,DA,DR
LM ;
 D EN^APCDEFL
 I $G(APCDVSIT) D EP^APCDKDE
 I $G(APCDVSIT) D ^APCDVCHK
 Q
 ;
 ;
EOJ ; END OF JOB
 D KILL^AUPNPAT
 K APCDHIGH,APCDSEL,APCDCUT,APCDDISP,APCDANS,APCDC,APCDI,APCDCRIT,APCDTEXT
 K ^TMP("APCDEF",$J)
 D ^APCDEKL,EN2^APCDEKL
 D ^XBFMK
 Q
TEXT ;
 ;;PCC Data Entry Module
 ;;
 ;;************************************************
 ;;*****  PCC DATA ENTRY UPDATE VISIT BY ITEM *****
 ;;************************************************
 ;;
 Q
