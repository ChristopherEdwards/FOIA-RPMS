APCLPP2 ; IHS/CMI/LAB - ; 23 May 2014  10:44 AM
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;
 ;
START ;
 D XIT
 S APCLJOB=$J,APCLBTH=$H
 K ^XTMP("APCLPP2",APCLJOB,APCLBTH)
 D INFORM
GETDATES ;
BD ;
 W !!,"Enter the time frame of interest.",! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
PROV ;
 K APCLPROV,APCLPRVN,APCLPRVD
 S APCLPT=""
 S DIR(0)="S^O:ONE Provider;C:COHORT or Selected Set of Providers",DIR("A")="Prepare report for",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 S APCLPT=Y
 I APCLPT="C" G PROVC
PROV1 ;
 S DIC("A")="Prepare report for which PROVIDER: ",DIC=$S($P(^DD(9000001,.14,0),U,2)[200:"^VA(200,",1:"^DIC(6,"),DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 GETDATES
 S APCLPROV(+Y)="",APCLPRVN(+Y)=$S($P(^DD(9000001,.14,0),U,2)[200:$P(^VA(200,+Y,0),U),1:$P(^DIC(16,+Y,0),U))
 S APCLPRVD(+Y)=$$VAL^XBDIQ1($S($P(^DD(9000001,.14,0),U,2)[200:200,1:6),+Y,$S($P(^DD(9000001,.14,0),U,2)[200:53.5,1:2))
 G FAC
PROVC ;cohort
 K APCLPROV,APCLPRVN,APCLPRVD
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLPROV(")
 I '$D(APCLPROV) G PROV
 I $D(APCLPROV("*")) W !,"all not allowed with this report" K APCLPROV G PROV
 S Y=0 F  S Y=$O(APCLPROV(Y)) Q:Y'=+Y  D
 .S APCLPROV(Y)="",APCLPRVN(Y)=$S($P(^DD(9000001,.14,0),U,2)[200:$P(^VA(200,Y,0),U),1:$P(^DIC(16,Y,0),U))
 .S APCLPRVD(Y)=$$VAL^XBDIQ1($S($P(^DD(9000001,.14,0),U,2)[200:200,1:6),Y,$S($P(^DD(9000001,.14,0),U,2)[200:53.5,1:2))
FAC ;
 S APCLSUH=""
 W !!,"For use in reporting Hospital and In-Hospital information, please enter",!,"your Service Unit's Hospital.   If there is no hospital in your service unit",!,"press ENTER to bypass the prompt.",!
 S DIC(0)="AEMQ",DIC="^AUTTLOC(" D ^DIC
 I X="" G LS
 I ($D(DUOUT))!($D(DTOUT)) G PROV
 I Y=-1 G FAC
 S APCLSUH=+Y
LS ;
 S APCLLSV=""
 S DIR(0)="S^L:Long Version (10 items in each list);S:Short Version (5 items in each list)",DIR("A")="Which Report would you like"
 S DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G FAC
 S APCLLSV=Y
EXCL ;exclude any diagnoses codes?
 K APCLEXCL,APCLDXT
 W !!,"In the list of leading purpose of visits you have the option of excluding ",!,"certain ICD diagnoses from the list of top ten diagnoses.",!
 S APCLEXCL=""
 W !,"Do you wish to exclude any diagnoses codes from the list of "
 S DIR(0)="Y",DIR("A")="top "_$S(APCLLSV="L":10,1:5)_" Purpose of Visits",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LS
 S APCLEXCL=Y
EXCL1 ;which ones to exclude
 K APCLDXT
 I 'APCLEXCL G ZIS
 W !,"Enter the diagnoses to be excluded.",!
DX1 ;
 S X="DIAGNOSIS",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLDXT(")
 I '$D(APCLDXT) G EXCL
 I $D(APCLDXT("*")) K APCLDXT
ZIS ;
ST ;;template of patients?
 S APCLSEAT=""
 S DIR(0)="S^A:ALL PATIENTS;S:SEARCH TEMPLATE OF PATIENTS",DIR("A")="Which set of patients should be included in this report",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EXCL
 I Y="A" G DEMO
 S APCLSEAT=""
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLSEAT="" G ST
 S APCLSEAT=+Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G EXCL
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="^APCLPP2P",XBRC="^APCLPP21",XBNS="APCL",XBRX="XIT^APCLPP2"
 D ^XBDBQUE
 Q
 ;
XIT ;
 D EN^XBVK("APCL")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^APCLPP2P"")"
 S XBNS="APCL",XBRC="^APCLPP21",XBRX="XIT^APCLPP2",XBIOP=0 D ^XBDBQUE
 Q
 ;
INFORM ;tell user what is going on
 W:$D(IOF) @IOF
 W $$CTR("*************   PROVIDER PRACTICE DESCRIPTION REPORT  ************",80)
 W !!,"This report will present a profile of services provided by a selected provider."
 W !,"You will be asked to enter a date range and to identify the provider's name.",!
 Q
SET ;EP - ENTRY POINT
 S APCLC=0 F  S APCLC=$O(APCLPROV(APCLC)) Q:APCLC'=+APCLC  D SETC
 Q
SETC ;
 S APCL4="REPORT",APCL1="COMMC",APCL3="COMM" D SET1
 S APCL4="REPORT",APCL1="TRIBEC",APCL3="TRIBE" D SET1
 S APCL4="REPORT",APCL1="SCC",APCL3="SC" D SET1
 S APCL4="REPORT",APCL1="LOCC",APCL3="LOC" D SET1
 S APCL4="REPORT",APCL1="OUTDXC",APCL3="OUTDX" D SET1
 S APCL4="REPORT",APCL1="INPTDXC",APCL3="INPTDX" D SET1
 S APCL4="REPORT",APCL1="PATEDC",APCL3="PATED" D SET1
 S APCL4="REPORT",APCL1="SURGPROCC",APCL3="SURGPROC" D SET1
 S APCL4="REPORT",APCL1="RXC",APCL3="RX" D SET1
 S APCL4="REPORT",APCL1="EMC",APCL3="EM" D SET1
 S APCL4="REPORT",APCL1="INPTSURGPROCC",APCL3="INPTSURGPROC" D SET1
 Q
SET1 ;
 S APCL2="^XTMP(""APCLPP2"",APCLJOB,APCLBTH,""RP"","""_APCLC_""","""_APCL4_""","""_APCL3_""",X)"
 S X="" F  S X=$O(@APCL2) Q:X=""  S %=^(X) S ^XTMP("APCLPP2",APCLJOB,APCLBTH,"RP",APCLC,APCL4,APCL1,9999999-%,X)=%
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Report.  Press return",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
