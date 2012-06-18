APCLIPCT ; IHS/OHPRD/TMJ - DRIVER FOR ACTIVE POP ; [ 03/19/01  9:50 AM ]
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
START ;
 D INIT
 G:$D(APCLQUIT) QUIT
SUF S APCLVFL="",APCLSUF="",DIR(0)="SBO^F:FACILITY;S:SERVICE UNIT",DIR("A")="Report on Patients registered at a particular Facility or in a Service Unit?" D ^DIR K DIR
 G:$D(DIRUT) QUIT
 S APCLFS=Y
 G:Y="S" S
F ;
 S DIC("A")="Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 QUIT
 S APCLSU=+Y
 S APCLSUF=$P(^AUTTLOC(APCLSU,0),U,5) Q:APCLSUF=""
VL S DIR(0)="S^A:All Locations;L:The Location entered above: ",DIR("A")="Do you want to include Visits to",DIR("B")="A" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SUF
 S APCLVFL=Y
 G IND
S W ! S APCLDICB=$P(^AUTTLOC(DUZ(2),0),U,5),APCLDIC("B")=$P(^AUTTSU(APCLDICB,0),U),DIC("A")="Select Service Unit: "_APCLDIC("B")_"//"
 S DIC="^AUTTSU(",DIC(0)="AEMQZ" W ! D ^DIC
 I X="" S (APCLSU,APCLSUF)=APCLDICB G IND
 G:Y=-1 QUIT
 S (APCLSU,APCLSUF)=+Y
IND ;
 W ! S APCLIND="",DIR(0)="YO",DIR("A")="Do you wish to include only INDIAN patients",DIR("?")="If you wish to exclude Non-Indians from the report enter a Y" D ^DIR K DIR
 G:$D(DIRUT) SUF
 S APCLIND=Y
SD ;
 W !
 S Y=DT X ^DD("DD") S APCLDTP=Y
 S %DT("A")="Starting Visit Date for Visit Counts: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G IND
 S APCLSD=Y X ^DD("DD") S APCLSDY=Y
ED S %DT("A")="Ending Visit Date for Visit Counts: " W ! D ^%DT K %DT
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
 S XBRP="^APCLPCT1",XBRC="^APCLPCT2",XBRX="QUIT^APCLPCT",XBNS="APCL"
 D ^XBDBQUE
 D QUIT
 Q
QUIT  ;
PCTEOJ K DIC,%DT,ZTSK,ZTQUEUED,IO("Q"),I,J,K,JK,X,Y,DIRUT,POP,H,M,S,TS,ZTIO
 K APCLSVJ,APCLCOMM,APCLDIC("B"),APCLDICB,APCLJ,APCLCNT,APCLDFN,APCLGOT1,APCLHRN,APCLTRI,APCLTRIC,APCLSU,APCL80D,APCLPG,APCLED,APCLSD,APCLEDY,APCLSDY,APCLFS,APCLFYB,APCLFYE,APCL,APCL3,APCL4,APCL5,APCLT1,APCLT2,APCLT3,APCLT4,APCLT5,APCLVFL
 K APCLACTT,APCLCNTT,APCLVCTT,APCLAPCT,APCLPCPT,APCLQUIT,APCLACT,APCLAPC,APCLVCNT,APCLPCP,APCLCOMN,APCLGOTA,APCLGOTB,APCLSKIP,APCLV,APCLVDFN,APCL1,APCLDISC,APCL2,APCLAP,APCLY,APCLDTP,APCLSUP,APCLVD,APCLSBT,APCLLOCC,APCLPAR
 K APCLVAR,APCLVAR1,APCLVAR2,APCLIND,APCLT,APCLP,APCLI,APCLSUF,APCLCOMN,APCLSUB,APCLSORT,APCLMAJ,APCLMIN,APCLSUN,APCLSUR,APCLVREC,APCLPPOV,APCLCLIN,APCLVLOC,APCLBT,APCLJOB,APCLVFL
 Q
 ;
 Q
INIT ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 I '$D(APCLSORT) W $C(7),$C(7),!!,"Report Type Missing!!",! S APCLQUIT="" Q
 W:$D(IOF) @IOF
 W !!,"This Option will search the Patient file for all patients registered",!,"at the Service Unit or the facility that you select.",!
 W "A Report will result which will give the following counts:",!
 W ?5,"- All Living Patients registered at the facility or SU selected",!
 W ?5,"- All Patients seen in the INPATIENT Visit Date Range specified",!
 W ?5,"- Total number of INPATIENT Visits by these patients",!
 W ?5,"- Total number of APC Visits by these patients",!
 W ?5,"- Total number of Primary Care Provider Visits by these patients",!
 W "The report will be sorted by ",$S(APCLSORT="C":"COMMUNITY OF RESIDENCE",APCLSORT="T":"TRIBE OF MEMBERSHIP",1:"SERVICE UNIT OF RESIDENCE"),".",!!
 Q
