APCLCAR ; IHS/CMI/LAB - california area GPRA ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("California Annual Utilization Report of Primary Care Clinics",80)
INTRO ;
 W !!,"This report will provide data for the California State Annual Utilization",!,"Report of Primary Care Clinics",!
 W !,$$CTR("Updated for the 2008 Report",80),!!
 D EXIT
Y ;fiscal year
 K DIR
 S APCLVDT=""
 W !,"Enter the Calender Year of interest.  Use a 4 digit year, e.g. 2008, 2007"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Calendar year (e.g. 2008)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 G EXIT
 S APCLVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G Y
VLOC ;get visit location of encounter
 K APCLLOC,APCLLOCT
 W ! S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("B")="Yes"
 S DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to list visits for only one location of encounter enter NO."
 D ^DIR K DIR
 G:$D(DIRUT) Y
 I Y=1 G CHKTAX
LOC1 ;enter location
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EXIT
 D PEP^AMQQGTX0(+Y,"APCLLOCT(")
 I '$D(APCLLOCT) G VLOC
 I $D(APCLLOCT("*")) K APCLLOCT
CHKTAX ;check taxonomies
 S APCLQ=0
 S APCLPER=APCLVDT,APCLBD=$E(APCLVDT,1,3)_"0101",APCLED=$E(APCLVDT,1,3)_"1231"
 F X=60:1:70,74,80:1:90,94 S APCLT="APCL CAR L"_X S Y="APCL"_X_"T" S @Y=$O(^ATXAX("B",APCLT,0))
 I APCLQ W !!,"Cannot continue.  Taxonomies not in place." Q
FEE ;
 W !!,"Please enter the FEE Schedule to use in calculating the primary cpt code.",!
 S DIC="^ABMDFEE(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 S APCLFEE="" G VLOC
 S APCLFEE=+Y
CPTL ;
 S APCLCPTR=""
 S DIR(0)="Y",DIR("A")="Do you want to include a list of visits with no cpt code",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G FEE
 I Y S APCLCPTR=1
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CPTL
 S XBRP="PRINT^APCLCARP",XBRC="PROC^APCLCAR1",XBRX="EXIT^APCLCAR",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
 ;
EXIT ;
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K %,%1
 D EN^XBVK("APCL")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
