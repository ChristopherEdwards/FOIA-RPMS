APCLHCT ; IHS/CMI/LAB - DRIVER FOR ACTIVE POP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 D INIT
 G:$D(APCLEOJ) EOJ
F ;
 W !,"For which Hospital (Location of Encounter) should the report be run?",!
 S DIC("A")="Which Location (Hospital)? ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 EOJ
 S APCLLOC=+Y
IND ;
 W ! S APCLIND="",DIR(0)="YO",DIR("A")="Do you wish to include only INDIAN patients",DIR("?")="If you wish to exclude Non-Indians from the report enter a Y" D ^DIR K DIR
 G:$D(DIRUT) F
 S APCLIND=Y
SD ;
 W !
 S Y=DT X ^DD("DD") S APCLDTP=Y
 S %DT("A")="Starting Discharge Date for Inpatient Counts: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G IND
 S APCLSD=Y X ^DD("DD") S APCLSDY=Y
ED S %DT("A")="Ending Discharge Date for Inpatient Counts: " W ! D ^%DT K %DT
 I Y=-1 G SD
 S APCLED=Y X ^DD("DD") S APCLEDY=Y
 I APCLED<APCLSD W !!,"Ending Date cannot be before Starting Date! Please reenter.",! G SD
SBT ;subtotal by tribe?
 G:APCLSORT'="C" SBC
 W ! S APCLSUB="" S DIR(0)="YO",DIR("A")="Do you wish to Sub-Total by Tribe",DIR("?")="If you want sub-totals by tribe for each community enter a Y" D ^DIR K DIR
 G:$D(DIRUT) SD
 S APCLSUB=Y
 G ZIS
SBC ;subtotal by community
 W ! S APCLSUB="" S DIR(0)="YO",DIR("A")="Do you wish to Sub-Total by Current Community of Residence",DIR("?")="If you want sub-totals by community for each Tribe enter a Y" D ^DIR K DIR
 G:$D(DIRUT) SD
 S APCLSUB=Y
 W !!!,"THIS REPORT WILL SEARCH THE ENTIRE PATIENT AND VISIT FILES!",!!,"IT IS STRONGLY RECOMMENDED THAT YOU QUEUE THIS REPORT FOR A TIME WHEN THE",!,"SYSTEM IS NOT IN HEAVY USE!",!
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SD
 S XBRP="^APCLHCT1",XBRC="^APCLHCT2",XBRX="EOJ^APCLHCT",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
EOJ K DIC,%DT,IO("Q"),I,J,K,JK,X,Y,DIRUT,POP,H,M,S,TS
 D EN^XBVK("APCL")
 Q
 ;
INIT ;
 I '$D(APCLSORT) W $C(7),$C(7),!!,"Report Type Missing!!",! S APCLQUIT="" Q
 W:$D(IOF) @IOF
 W !!,"This Option will search the Patient file for all patients registered",!,"at the Service Unit or the facility that you select.",!
 W "A Report will result which will give the following counts:",!
 ;W ?5,"- All Living Patients registered at the facility or SU selected",!
 W ?5,"- The Number of ADULT/PEDIATRIC Discharges in the date range specified",!
 W ?5,"- Total number of Inpatient Days by Adult/Peds",!
 W ?5,"- The Number of NEWBORN discharges",!
 W ?5,"- The number of NEWBORN Days",!
 W ?5,"- The number of transfers in",!
 W ?5,"- The number with MCR/MCD/PI on the date of admission",!
 W "The report will be sorted by ",$S(APCLSORT="C":"COMMUNITY OF RESIDENCE",APCLSORT="T":"TRIBE OF MEMBERSHIP",1:"SERVICE UNIT OF RESIDENCE"),".",!!
 Q
