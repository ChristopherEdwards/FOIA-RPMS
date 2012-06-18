BGPDAREA ; IHS/CMI/LAB - ihs area GPRA ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ;IHS/CMI/LAB - patch 1 modified to allow July-June report
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area GPRA Report",80)
INTRO ;
 D EXIT
 S BGPAREAA=1
DATES ;
 K BGPBD,BGPED,BGPPER
 S BGPQTR=0
 D Y
 I $D(BGPQUIT) D EXIT Q
 S BGPQY=""
 S DIR(0)="S^Q:One Quarter in FY "_$$FMTE^XLFDT(BGPPER)_";F:Full Fiscal Year;A:AREA REPORTING YEAR (July 1 - June 30)",DIR("A")="Run the report for a",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BGPQY=Y
 I BGPQY="F"!(BGPQY="Q") S BGPBD=($E(BGPVDT,1,3)-1)_"1001",BGPED=$E(BGPVDT,1,3)_"0930"
 I BGPQY="A" S BGPBD=($E(BGPVDT,1,3)-1)_"0701",BGPED=$E(BGPVDT,1,3)_"0630"
 I BGPQY="Q" D Q I $D(BGPQUIT) G INTRO
BY ;get baseline year
 W !
 S BGPVDT=""
 W !,"Enter the Baseline Year that you would like to compare the data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 1999)"
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 G DATES
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 I BGPQTR=0,BGPQY="F" S BGPBBD=($E(BGPVDT,1,3)-1)_"1001",BGPBED=$E(BGPVDT,1,3)_"0930" G N
 I BGPQTR=1 S BGPBBD=($E(BGPVDT,1,3)-1)_"1001",BGPBED=($E(BGPVDT,1,3)-1)_"1231" G N
 I BGPQTR=0,BGPQY="A" S BGPBBD=($E(BGPVDT,1,3)-1)_"0701",BGPBED=$E(BGPVDT,1,3)_"0630" G N
 I BGPQTR=2 S BGPBBD=$E(BGPVDT,1,3)_"0101",BGPBED=$E(BGPVDT,1,3)_"0331" G N
 I BGPQTR=3 S BGPBBD=$E(BGPVDT,1,3)_"0401",BGPBED=$E(BGPVDT,1,3)_"0630" G N
 I BGPQTR=4 S BGPBBD=$E(BGPVDT,1,3)_"0701",BGPBED=$E(BGPVDT,1,3)_"0930" G N
N S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
ASU ;
 S BGPSUCNT=0
 S BGPRPTT=""
 S DIR(0)="S^A:AREA Aggregate;F:One Facility",DIR("A")="Run Report for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) BY
 S BGPRPTT=Y
 I BGPRPTT="F" D  G:$D(BGPQUIT) ASU
 .S BGPSUCNT=0,BGPSU="",BGPSUC="" K BGPSUL
 .K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPD(BGPX)) Q:BGPX'=+BGPX  S V=^BGPD(BGPX,0) I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,3)=BGPPER,$P(V,U,4)=BGPQTR S BGPSUL(BGPX)="",BGPSUCNT=BGPSUCNT+1
 .I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! S BGPQUIT=1 Q
 .W !!,"Data from the following Facilities has been received.",!,"Please select the facility.",!
 .K BGPSUL1 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1,BGPSUL1(C)=X
 .S X=0 F  S X=$O(BGPSUL1(X)) Q:X'=+X  S BGP0=^BGPD(BGPSUL1(X),0) W !?2,X,")",?5,"FY: ",$$FMTE^XLFDT($P(BGP0,U,3)),?15,"QTR: ",$$VAL^XBDIQ1(90240.01,BGPSUL1(X),.04),?30,"SU: ",$$SU($P(BGP0,U,6)),?55,"Facility: ",$E($$FAC($P(BGP0,U,5)),1,15)
 .W !?2,"0)",?5,"None of the Above"
 .S DIR(0)="N^0:"_C_":0",DIR("A")="Please Select the Facility",DIR("B")="0" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1 Q
 .I 'Y S BGPQUIT=1 Q
 .K BGPSUL S BGPSUL(BGPSUL1(Y))="",BGPSUCNT=1,X=$P(^BGPD(BGPSUL1(Y),0),U,5),X=$O(^AUTTLOC("C",X,0)) I X S BGPSUNM=$P(^DIC(4,X,0),U)
 .Q
 G:BGPRPTT="F" ZIS
GETSU ;
 K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPD(BGPX)) Q:BGPX'=+BGPX  S V=^BGPD(BGPX,0) I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,3)=BGPPER,$P(V,U,4)=BGPQTR,$P(V,U,8)=BGPBBD,$P(V,U,9)=BGPBED S BGPSUL(BGPX)=""
 I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! G INTRO
 W !!,"Data from the following Facilities has been received and will be used",!,"in the Area Aggregate Report:",!
 S X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGP0=^BGPD(X,0) W !?5,"FY: ",$$FMTE^XLFDT($P(BGP0,U,3)),?15,"QTR: ",$$VAL^XBDIQ1(90240.01,X,.04),?30,"SU: ",$$SU($P(BGP0,U,6)),?55,"Facility: ",$E($$FAC($P(BGP0,U,5)),1,15)
ZIS ;call to XBDBQUE
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 F X=1:1:30 S BGPIND(X)=""
 ;
 W !! S %ZIS="PQM" D ^%ZIS
 ;I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPD(" D ^DIK K DIK D EXIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 U IO
 D PRINT^BGPDPARP
 D ^%ZISC
 D EXIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGPDAREA",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D EXIT Q
 Q
OLD ;
 S XBRP="PRINT^BGPDPARP",XBRC="",XBRX="EXIT^BGPDAREA",XBNS="BGP"
 D ^XBDBQUE
 D EXIT
 Q
 ;
FAC(S) ;
 NEW N S N=$O(^AUTTLOC("C",S,0))
 I N="" Q N
 Q $P(^DIC(4,N,0),U)
SU(S) ;
 NEW N S N=$O(^AUTTSU("C",S,0))
 I N="" Q N
 Q $P(^AUTTSU(N,0),U)
EXIT ;
 D EN^XBVK("BGP")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
Q ;which quarter
 S DIR(0)="N^1:4:0",DIR("A")="Which Quarter" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S BGPQUIT="" Q
 S BGPQTR=Y
 I Y=1 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=($E(BGPPER,1,3)-1)_"1231" Q
 I Y=2 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"0331" Q
 I Y=3 S BGPBD=$E(BGPPER,1,3)_"0401",BGPED=$E(BGPPER,1,3)_"0630" Q
 I Y=4 S BGPBD=$E(BGPPER,1,3)_"0701",BGPED=$E(BGPPER,1,3)_"0930" Q
 Q
Y ;fiscal year
 W !
 S BGPVDT=""
 W !,"Enter the YEAR of interest.  Use a 4 digit year, e.g. 2002"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter the year (e.g. 1999)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G Y
 S BGPPER=BGPVDT
 Q
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
