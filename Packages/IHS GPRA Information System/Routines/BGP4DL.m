BGP4DL ; IHS/CMI/LAB - IHS GPRA 04 SELECTED REPORT DRIVER ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS FY04 Clinical Performance Indicator Report (Selected Indicators)",80)
INTRO ;
 D XIT
 W !,"This will produce an Indicator Report for one or more indicators for a year",!,"period you specify.  You will be asked to provide: 1) the"
 W !,"reporting period, 2) the baseline period to compare data to, and 3) the ",!,"Community taxonomy to determine which patients will be included."
 D TAXCHK^BGP4TXCH
SETIND ;
 D XIT
 S BGPINDT=""
 S DIR(0)="S^DM:Diabetes-Related Indicators;CVD:Cardiovascular Disease-Related Indicators;WH:Women's Health-Related Indicators;PR:Prevention-Related Indicators;SEL:Selected Indicators (User Defined)"
 S DIR("A")="Which set of Indicators should be included in this report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPINDT=$E(Y)
 I BGPINDT="S" D SI I '$D(BGPIND) G SETIND
GI ;gather all indicators
 I BGPINDT="D" D DI
 I BGPINDT="C" D CI
 I BGPINDT="W" D WI
 I BGPINDT="P" D PI
 I '$D(BGPIND) W !!,"no indicators selected" G SETIND
TP ;get time period
 S BGPRTYPE=4
 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPQTR=Y
 D F
 I BGPPER="" W !,"Year not entered.",! G TP
 I BGPQTR=1 S BGPBD=($E(BGPPER,1,3)-1)_"0101",BGPED=($E(BGPPER,1,3)-1)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPED>DT D  G:BGPDO=1 TP
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
BY ;get baseline year
 S BGPVDT=""
 W !!,"Enter the Baseline Year to compare data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 2000)"
 D ^DIR KILL DIR
 I $D(DIRUT) G TP
 I $D(DUOUT) S DIRUT=1 G TP
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
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
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC
 I Y=-1 Q
 S BGPTAXI=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G BEN
 W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I BGPINDT'="S" D LISTS
BEN ;
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPBEN=Y
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF FY 04 GPRA REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I 'BGPHOME W !,"No HOME Location selected."
 W !!,"These indicators will be calculated: " S X=0 F  S X=$O(BGPIND(X)) Q:X'=+X  W $P(^BGPINDF(X,0),U,2)," ; "
 W !!,"Lists will be produced for these indicators: "
 S X=0 F  S X=$O(BGPLIST(X)) Q:X'=+X  W $P(^BGPINDF(X,0),U,2)," ; "
 D PT^BGP4DSL
 I BGPROT="" G LISTS
ZIS ;call to XBDBQUE
 D REPORT^BGP4UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
ZIS1 ;
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCF(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPF(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBF(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGP4D1
 U IO
 D ^BGP4DP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV1 ;
 D ^BGP4D1
 D ^BGP4DP
 D ^%ZISC
 D XIT
 Q
DI ;
 S X=0 F  S X=$O(^BGPINDFC("ADM",1,X)) Q:X'=+X  S BGPIND($P(^BGPINDFC(X,0),U,1))=""
 Q
CI ;
 S X=0 F  S X=$O(^BGPINDFC("ACARD",1,X)) Q:X'=+X  S BGPIND($P(^BGPINDFC(X,0),U,1))=""
 Q
WI ;
 S X=0 F  S X=$O(^BGPINDFC("AWH",1,X)) Q:X'=+X  S BGPIND($P(^BGPINDFC(X,0),U,1))=""
 Q
PI ;
 S X=0 F  S X=$O(^BGPINDFC("APR",1,X)) Q:X'=+X  S BGPIND($P(^BGPINDFC(X,0),U,1))=""
 Q
SI ;
 K BGPIND
 D EN^BGP4DSI
 I '$D(BGPIND) Q
 D LISTS
 Q
LISTS ;any lists with indicators?
 W !!
 K BGPLIST
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any of the indicators",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") Q
 I Y=0 Q
 K BGPLIST
 D EN^BGP4DSL
 I '$D(BGPLIST) W !!,"No lists selected.",!
 I $D(BGPLIST) D RT^BGP4DSL I '$D(BGPLIST)!($D(BGPQUIT)) G LISTS ;get report type for each list
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP4DL",ZTDTH="",ZTDESC="GPRA 04 REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP4DL",XBRX="XIT^BGP4DL",XBNS="BGP"
 D ^XBDBQUE
 ;D XIT
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP")
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
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
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;fiscal year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the Fiscal Year (FY) for the report END date.  Use a 4 digit",!,"year, e.g. 2004"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter FY"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
