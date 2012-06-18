BGP3DL ; IHS/CMI/LAB - IHS GPRA - report for local use ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS FY03 GPRA Clinical Performance Indicator Report",80)
INTRO ;
 D XIT
 W !!,"This will produce an Indicator Report for one or more indicators for a year",!,"period ending on a date you specify.  You will be asked to provide: 1) the",!,"baseline year to"
 W " compare data to, and 2) the Community taxonomy to determine",!,"which patients will be included.",!
 D TAXCHK^BGP3TXCH
TP ;get time period
 D XIT
 S BGPPER=""
 S BGPRTYPE=4
 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^Q:FY Quarter End (Q1 December 31, Q2 March 31, Q3 June 30);F:Fiscal Year End (September 30);A:Area Director's Reporting Year End (June 30);D:Date Range (User specified)"
 S DIR("A")="Run Report for which time period",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPTP=Y
 D @BGPTP
 I $D(BGPQUIT) G TP
BY ;get baseline year
 W !
 S BGPVDT=""
 W !,"Enter the Baseline Year to compare data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 2003)"
 D ^DIR KILL DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 G TP
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 I BGPPER]"" S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 I BGPPER="" S X=$E(BGPBD,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 I BGPPBD=BGPBBD,BGPPED=BGPBED K Y D CHKY I Y K BGPBBD,BGPBED,BGPPBD,BGPPED G BY
COMM ;
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN",!,"or the Taxonomy Setup option.",!
 K BGPTAX
 S BGPTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: " D ^DIC
 I Y=-1 Q
 S BGPTAXI=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G IND
 W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
IND ;choose indicators
 K BGPIND
 S BGPINDT=""
 W !!
 S DIR(0)="S^S:Selected Set of Indicators;G:GPRA Indicators (All);A:Area Performance Indicators (All);D:Diabetes Indicators (All);C:Cardiovascular Indicators (All)"
 S DIR("A")="Calculate Which set of Indicators",DIR("B")="G" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G INTRO
 S BGPINDT=Y
 I BGPINDT="G" D GI
 I BGPINDT="A" D AI
 I BGPINDT="D" D DI
 I BGPINDT="C" D CI
 I BGPINDT="S" D SI
 I '$D(BGPIND) W !!,"No indicators selected.",! G INTRO
LISTS ;any lists with indicators?
 W !!
 K BGPLIST
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any selected indicators",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G IND
 I Y=0 G SUM
 K BGPLIST
 D EN^BGP3DSL
 I '$D(BGPLIST) W !!,"No lists selected.",!
 I $D(BGPLIST) D RT^BGP3DSL I '$D(BGPLIST)!($D(BGPQUIT)) G LISTS ;get report type for each list
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF LOCAL REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I 'BGPHOME W !,"No HOME Location selected."
 W !!,"These indicators will be calculated: " S X=0 F  S X=$O(BGPIND(X)) Q:X'=+X  W $P(^BGPIND(X,0),U,2)," ; "
 W !!,"Lists will be produced for these indicators: "
 S X=0 F  S X=$O(BGPLIST(X)) Q:X'=+X  W $P(^BGPIND(X,0),U,2)," ; "
 D PT^BGP3DSL
 I BGPROT="" G LISTS
ZIS ;call to XBDBQUE
 D REPORT^BGP3UTL
 I BGPRPT="" D XIT Q
 I $G(BGPQUIT) D XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDC(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDP(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDB(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGP3D1
 U IO
 D ^BGP3DP
 D ^%ZISC
 D XIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP3DL",ZTDTH="",ZTDESC="GPRA 03 REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
OLD ;
 S XBRP="PRINT^BGPDP",XBRC="PROC^BGPD1",XBRX="XIT^BGPD",XBNS="BGP"
 D ^XBDBQUE
 D XIT
 Q
 ;
XIT ;
 D EN^XBVK("BGP")
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
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
 K DIR,DIRUTUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR KILL DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
D ;get date range.
 K DIR,DIRUT W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for this Report"
 D ^DIR KILL DIR I Y<1 S BGPQUIT="" Q
 S BGPBD=Y
 K DIR,DIRUT S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for this Report Date"
 D ^DIR KILL DIR I Y<1 S BGPQUIT="" Q
 S BGPED=Y
 ;
 I BGPED<BGPBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 Q
Q ;which quarter
 S BGPPER=""
 D F
 I BGPPER="" W !,"No FY entered" S BGPQUIT="" Q
 S DIR("?",1)="Select the end date for your report:",DIR("?",2)="     1  December 31",DIR("?",3)="     2  March 31",DIR("?")="     3  June 30"
 S DIR(0)="N^1:3:0",DIR("A")="Which FY Quarter End Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S BGPQUIT="" Q
 W !!,"Your report will use the last day of the quarter you selected as the End Date",!,"of the Report.  Depending on the indicator, the report will calculate based",!,"on data from at least the year prior"
 W " to the Report End Date, not just on the",!,"quarter selected.",!
 S BGPQTR=Y
 I Y=1 S BGPBD=($E(BGPPER,1,3)-1)_"0101",BGPED=($E(BGPPER,1,3)-1)_"1231" Q
 I Y=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331" Q
 I Y=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630" Q
 I Y=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930" Q
 Q
A ;area dir year
 S BGPPER=""
 W !
 S BGPVDT=""
 W !,"Enter the appropriate AREA REPORTING YEAR.  Use a 4 digit year, e.g. 2002"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter AREA REPORTING Year (e.g. 1999)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G A
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"0701",BGPED=$E(BGPVDT,1,3)_"0630"
 Q
F ;fiscal year
 S BGPPER=""
 S BGPPER=""
 W !
 S BGPVDT=""
 W !,"Enter the Fiscal Year (FY).  Use a 4 digit year, e.g. 2002, 2003"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter FY"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"1001",BGPED=$E(BGPVDT,1,3)_"0930"
 Q
GI ;gather all gpra indicators
 S X=0 F  S X=$O(^BGPINDC("AGPRA",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPINDC("AGPRA",X,Y)) Q:Y'=+Y  S BGPIND($P(^BGPINDC(Y,0),U,1))=""
 Q
AI ;gather up all area directors indicators
 S X=0 F  S X=$O(^BGPINDC("AREA",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPINDC("AREA",X,Y)) Q:Y'=+Y  S BGPIND($P(^BGPINDC(Y,0),U,1))=""
 Q
DI ;
 S X=0 F  S X=$O(^BGPINDC("ADM",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPINDC("ADM",X,Y)) Q:Y'=+Y  S BGPIND($P(^BGPINDC(Y,0),U,1))=""
 Q
CI ;
 S X=0 F  S X=$O(^BGPINDC("ACARD",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPINDC("ACARD",X,Y)) Q:Y'=+Y  S BGPIND($P(^BGPINDC(Y,0),U,1))=""
 Q
SI ;
 K BGPIND
 D EN^BGP3DSI
 Q
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
