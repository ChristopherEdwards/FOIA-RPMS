BGPD ; IHS/CMI/LAB - IHS GPRA - report for local use ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS GPRA Indicator Report - Local Use only - No export to Area",80)
INTRO ;
 D XIT
 W !!,"This report will produce a GPRA Indicator Report for a date range you specify.",!,"You will be asked to provide the baseline year and also to specify",!
 W "which indicators that you would like to have printed.  This option does ",!,"NOT send a copy to the Area for Area Aggregation.",!
 W !,"You will be provided the opportunity to have lists of patients printed for",!,"the indicators.  Please be careful when answering this questions as the",!,"lists can be very long and use lots of paper.",!
 D TAXCHK^BGPDT
DATES ;get date range.
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for this Report"
 D ^DIR G:Y<1 XIT S BGPBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for this Report Date"
 D ^DIR G:Y<1 XIT  S BGPED=Y
 ;
 I BGPED<BGPBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S BGPSD=$$FMADD^XLFDT(BGPBD,-1)_".9999"
 ;
BY ;get baseline year
 W !
 S BGPVDT=""
 W !,"Enter the Baseline Year that you would like to compare the data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 1999)"
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1  G DATES
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S X=$E(BGPBD,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
COMM ;
 W !!,"You must now specify the community taxonomy to use when determining which",!,"patients will be included in the GPRA report.  You should have created",!,"this taxonomy using QMAN or some other software.",!
 K BGPTAX
 S BGPX=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: " D ^DIC
 I Y=-1 Q
 S BGPX=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BGPX,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPX,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
HOME ;
 W ! K DIC S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Please enter the Location used by Data Entry for HOME Visits: " D ^DIC
 I Y=-1 W !,"No HOME Location entered!!!  PHN Visits counts to Home will be calculated",!,"using clinic 11 only!!" H 2 S BGPHOME="" G IND
 S BGPHOME=+Y
IND ;choose indicators
 W !! K BGPIND
 S DIR(0)="S^A:ALL GPRA Performance Indicators;S:Selected GPRA Performance Indicators",DIR("A")="Do you want to Report on",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G INTRO
 I Y="A" F X=1:1:54 S BGPIND(X)=""
 I Y="A" K BGPIND(23) G LISTS
 K BGPIND
 D EN^BGPD0
 K BGPIND(23) ;no immunization in this version
 I '$D(BGPIND) W !!,"No indicators selected.",! G INTRO
LISTS ;any lists with indicators?
 W !!
 K BGPLIST
 S DIR(0)="Y",DIR("A")="Do you want any individual lists for the indicators",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G IND
 I Y=0 G SUM
 K BGPLIST
 D EN^BGPDL
 I '$D(BGPLIST) W !!,"No lists selected.",!
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF GPRA REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPX,0),U)
 I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I 'BGPHOME W !,"No HOME Location selected."
 W !!,"These indicators will be calculated: " S X=0 F  S X=$O(BGPIND(X)) Q:X'=+X  I $P($T(@X),";;",2)]"" W $P($T(@X),";;",2)," ; "
 W !!,"Lists will be produced for these indicators: "
 S X=0 F  S X=$O(BGPLIST(X)) Q:X'=+X  W $P($T(@X),";;",2)," ; "
ZIS ;call to XBDBQUE
 W !!
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPD(",DLAYGO=90240.01,DIADD=1,DIC("DR")=".02////"_BGPED_";.07///1;.08////"_BGPBBD_";.09////"_BGPBED
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 D XIT Q
 S BGPRPT=+Y
 ;add communities to 28 multiple
 K ^BGPD(BGPRPT,28)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPD(BGPRPT,28,C,0)=X,^BGPD(BGPRPT,28,"B",X,C)=""
 S ^BGPD(BGPRPT,28,0)="^90240.28A^"_C_"^"_C
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;
 K IOP,%ZIS W !! S %ZIS="PQM" D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPD(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGPD1
 U IO
 D ^BGPDP
 D ^%ZISC
 D XIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGPD",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D XIT Q
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
 K DIADD,DLAYGO
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
 ;
1 ;;1
2 ;;1B
3 ;;2A
4 ;;2B
5 ;;2C
6 ;;3A
7 ;;3B
8 ;;3C
9 ;;4A
10 ;;4B
11 ;;4C
12 ;;5A
13 ;;5B
14 ;;5C
15 ;;6
16 ;;6A
17 ;;7
18 ;;8
19 ;;12
20 ;;13
21 ;;14
22 ;;22
23 ;;23
24 ;;24
25 ;;29
26 ;;30
27 ;;A
28 ;;B
29 ;;C
30 ;;D
