AMHLEOD ; IHS/CMI/LAB - enter outside rx ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;EP - called from option
 D FULL^VALM1
 I 'DFN W !!,"Patient not defined" D EXIT Q
HDR ;write header
 W:$D(IOF) @IOF
 F J=1:1:10 S X=$P($T(TEXT+J),";;",2) W !?80-$L(X)\2,X
 K X,J
 W !!
 ;
BEGIN ;
 D INIT
 G:AMHQUIT EXIT
 G:DFN="" EXIT
 D GETLOC
 F  D GETDRUG Q:AMHQUIT!(AMHDIEN="")  D PROCESS
 D EXIT
 Q
PROCESS ;
 D GETDATE
 Q:AMHDATE=""
 D GETOL
 Q:AMHOL=""
 D GENVISIT
 Q:AMHQUIT
 D GENVMED
 Q
EXIT ;cleanup and exit
 K APCDLOOK,APCDANE,APCDALVR,APCDVSIT,APCDPAT
 K AMHOIEN,AMHDRUG,AMHDIEN,AMHOL,AMHDATE,AMHQUIT,AMHLOC
 D KILL^AUPNPAT K AUPNTALK,AUPNLK("ALL")
 K DIE,DR,DA,DIRUT,DIR,DTOUT,DUOUT,DIV,DIW,DQ,DD,DQ,DI,DIC,DIR,X,Y,I,DDH,DI,D,D0
 Q
INIT ;EP
 S AMHQUIT=0
 S AMHOIEN=$O(^PSDRUG("B","OUTSIDE DRUG",0)) I 'AMHOIEN W !!,$C(7),$C(7),"OUTSIDE DRUG not defined in DRUG file, notify programmer." H 3 S AMHQUIT=1 Q
 Q
GETLOC ; GET LOCATION OF ENCOUNTER
 W !!,"Please enter your service unit's OTHER or UNDESIG location.",!,"If you don't know what that is please ask your PCC Data Entry Operator",!,"for the location of encounter to use for historical activities performed"
 W !,"outside this facility.",!
 S AMHLOC=""
 S DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S AMHLOC=+Y
 Q
 ;
GETDATE ;EP GET DATE OF ENCOUNTER
 K DIR S AMHDATE="",DIR(0)="DO^:"_DT_":EPT",DIR("A")="Enter DATE DISPENSED" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S AMHDATE=Y
 Q
GETOL ;
 S AMHOL=""
 S DIR(0)="9000010,2101",DIR("A")="Enter LOCATION WHERE DISPENSED" K DA D ^DIR K DIR
 S AMHOL=Y
 Q
GETDRUG ;
 S (AMHDRUG,AMHDIEN)=""
 W !! K DD,DIR S DIR(0)="FO^1:40",DIR("A")="Enter DRUG NAME" D ^DIR K DIR S:$D(DTOUT) DIRUT=1
 Q:Y=""
 I $D(DIRUT) W !,"No drug entered!!" Q
 S (X,AMHDRUG)=Y,DIC="^PSDRUG(",DIC(0)="MQE" D ^DIC K DIC
 I Y=-1 D NODRUG Q
 S AMHDIEN=+Y,AMHDRUG="" K DIR,DA,DIRUT,DTOUT,DUOUT
 Q
 ;
NODRUG ;
 W !,"That drug cannot be found in the Drug file."
 K DIR S DIR(0)="Y",DIR("A")="Do you want to try to lookup the drug in the Drug file again",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Exiting..." S AMHQUIT=1 Q
 I Y G GETDRUG
 S AMHDIEN=AMHOIEN
 W ! K DD,DIR S DIR(0)="FO^1:40",DIR("A")="Enter the FULL DRUG NAME...",DIR("A",1)="You must enter the drug name that will appear on the health summary.",DIR("B")=AMHDRUG D ^DIR K DIR S:$D(DTOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT=1 W !!,"Exiting..." Q
 S AMHDRUG=Y
 S AMHDRUG=$TR(AMHDRUG,"-") ;IHS/OKCAO/POC 4/22/98
 Q
GENVISIT ;
 K APCDALVR
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDDATE")=AMHDATE
 S APCDALVR("APCDTYPE")="O"
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDLOC")=AMHLOC
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDAUTO")="",APCDALVR("APCDANE")=""
 S APCDALVR("APCDOLOC")=AMHOL
 D ^APCDALV
 I $D(APCDALVR("APCDAFLG")) W !!,$C(7),"Creating PCC Visit Failed....Notify Supervisor" H 3 S AMHQUIT=1 Q
 S APCDVSIT=APCDALVR("APCDVSIT"),APCDPAT=APCDALVR("APCDPAT") S Y=DFN D ^AUPNPAT
 Q
GENVMED ;
 I '$G(AMHDIEN) W !!,"Error.... no drug entry" H 2 Q
 W !!,"Please enter all available information about this prescription.",!
 S DA=APCDVSIT,DR="[AMH ORX (ADD)]",DIE="^AUPNVSIT(" D ^DIE
 I $D(Y) W !!,"Creating V Medication entry failed!!  Notify supervisor!" H 3 Q
 Q
TEXT ;
 ;;
 ;;IHS BEHAVIORAL HEALTH/PCC Interface
 ;;
 ;;*******************************
 ;;*    Entry of OUTSIDE RX's    *
 ;;*******************************
 ;;
 ;;Use this option to enter medications that the patient is taking
 ;;that were not prescribed by you or that were filled at a pharmacy
 ;;other than the pharmacy at this facility.
