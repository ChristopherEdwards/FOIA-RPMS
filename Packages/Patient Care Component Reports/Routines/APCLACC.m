APCLACC ; IHS/CMI/LAB - active users by community ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - added a template creation option
START ;
 D INIT
 G:$D(APCLQUIT) EOJ
SUF ;S (APCLSUF,APCLFS)="",DIR(0)="SBO^F:FACILITY;S:SERVICE UNIT",DIR("A")="Report for a particular Facility or for a Service Unit?" D ^DIR K DIR
 S (APCLSUF,APCLFS)="",DIR(0)="S^F:ONE OR MORE FACILITIES;S:ONE OR MORE SERVICE UNITS",DIR("A")="Report on patients registered at",DIR("B")="F" K DA D ^DIR K DIR
 G:$D(DIRUT) EOJ
 S APCLFS=Y
 G:Y="S" S
F ;
 K APCLSU,APCLSUF
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"APCLSU(")
 I '$D(APCLSU) G SUF
 I $D(APCLSU("*")) K APCLSU G SUF
 S X=0 F  S X=$O(APCLSU(X)) Q:X'=+X  I $P(^AUTTLOC(X,0),U,5) S APCLSUF($P(^AUTTLOC(X,0),U,5))="" ;set all service units in APCLSUF
 G SUR
S ;
 K APCLSU
 S X="SERVICE UNIT",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"APCLSU(")
 I '$D(APCLSU) G SUF
 I $D(APCLSU("*")) K APCLSU G SUF
 S X=0 F  S X=$O(APCLSU(X)) Q:X'=+X  S APCLSUF(X)=""
SUR ;
 W !
 S APCLSSUR=""
 W ! S DIR("A")="Do you want to include only patients living in these"_$S(APCLFS="F":" Facility's",1:"")_" SERVICE UNIT's"
 S DIR(0)="YO"
 S DIR("?")="If you want to only include those people living in the SU indicated or the SU of the Facility indicated enter Y" D ^DIR K DIR
 G:$D(DIRUT) SUF
 S APCLSSUR=Y
IND ;
 W ! S APCLIND="",DIR(0)="YO",DIR("A")="Do you wish to include only INDIAN patients",DIR("?")="If you wish to exclude Non-Indians from the report enter a Y" D ^DIR K DIR
 G:$D(DIRUT) SUF
 S APCLIND=Y
FY ;
 S Y=DT X ^DD("DD") S APCLDTP=Y
 S %DT("A")="** Patients are to be considered ACTIVE 'as of' what date: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G IND
 S APCLFYE=Y X ^DD("DD") S APCLFYEY=Y
RPT ;report type
 S APCLRPTT=""
 S DIR(0)="S^F:Full Report;T:Create a Template of the Active Patients",DIR("A")="Which report type do you want",DIR("B")="F" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) FY
 S APCLRPTT=Y
 I APCLRPTT="T" W !!,$C(7),"The name of the template will be:  ACTIVE USERS AS OF "_$$FMTE^XLFDT(APCLFYE,"2E")_" and it will be attached to the IHS PATIENT file" G ZIS
SBT ;subtotal by tribe?
 G:APCLSORT'="C" SBC
 W ! S APCLSUB="" S DIR(0)="YO",DIR("A")="Do you wish to Sub-Total by Tribe",DIR("?")="If you want sub-totals by tribe for each community enter a Y" D ^DIR K DIR
 G:$D(DIRUT) FY
 S APCLSUB=Y
 G ZIS
SBC ;subtotal by community
 W ! S APCLSUB="" S DIR(0)="YO",DIR("A")="Do you wish to Sub-Total by Current Community of Residence",DIR("?")="If you want sub-totals by community for each Tribe enter a Y" D ^DIR K DIR
 G:$D(DIRUT) FY
 S APCLSUB=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G RPT
 W !!!,"THIS REPORT WILL SEARCH THE ENTIRE PATIENT FILE!",!!,"IT IS STRONGLY RECOMMENDED THAT YOU QUEUE THIS REPORT FOR A TIME WHEN THE",!,"SYSTEM IS NOT IN HEAVY USE!",!
 S XBRP="^APCLACC1",XBRC="^APCLACC2",XBRX="EOJ^APCLACC",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
 ;
INIT ;
ACC ;
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 W:$D(IOF) @IOF
 I '$D(APCLSORT) W $C(7),$C(7),!!,"Report Type Missing!!",! S APCLQUIT="" Q
 W !,"This option will produce either:"
 W !?5,"1) A Report of Registered Patients and Active Users sorted by",!?8,$S(APCLSORT="C":"Community of Residence",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),", OR"
 W !?5,"2) A Template of Active Users for use in QMan Searches"
 W !!,"Your Report or Template can be generated for one or more Facilities or for",!,"one or more Service Units."
 W !!,"To determine Active Users for your Report or Template, the system will select",!,"patients who have had a visit at the Facility(s) or Service Unit(s) specified",!
 W "within the past 3 years of the date you specify.  IHS, CHS and Tribal"
 W !,"visits will all be included.  Home, telephone, employee health, and chart review",!,"visits are excluded."
 W !!,"You will be asked if the patients must live in the Service Unit specified",!,"and if you only want Indian patients included."
  W "  You must answer YES to both",!,"questions in order to conform to the official IHS definition of Active Users."
 ;W "The report will be sorted by ",$S(APCLSORT="C":"COMMUNITY OF RESIDENCE",APCLSORT="T":"TRIBE OF MEMBERSHIP",1:"SERVICE UNIT OF RESIDENCE"),"."
 Q
 ;
EOJ ;ENTRY POINT
ACCEOJ K DIC,%DT,IO("Q"),I,J,K,JK,X,Y,POP,DIRUT,ZTSK,H,M,S,TS,ZTQUEUED
 K APCLSVJ,APCLCOMM,APCLDIC("B"),APCLDICB,APCLJ,APCLDFN,APCLGOT1,APCLHRN,APCLTRI,APCLTRIC,APCLSU,APCL80D,APCLPG,APCLFYEY,APCLFS,APCLFYB,APCLFYE,APCLRPTT,APCLSTMP
 K APCLQUIT,APCLPCP,APCLCOMN,APCLGOTA,APCLSKIP,APCLV,APCLVDFN,APCL1,APCL2,APCLDTP,APCLSUP,APCLVD,APCLSUB,APCLBT,APCLJOB
 K APCLVAR,APCLVAR1,APCLVAR2,APCLIND,APCLT,APCLP,APCLI,APCLSUF,APCLCOMN,APCLFYBY,APCLFYB,APCLSORT,APCLFYBI,APCLFYEI,APCLSUN,APCLMAJ,APCLMIN,APCLSSUR,APCLSUR
 Q
 ;
 Q
