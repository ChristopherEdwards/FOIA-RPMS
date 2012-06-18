CIMGAGPA ; CMI/TUCSON/LAB - aberdeen area GPRA ;  [ 03/09/00  4:19 PM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("Aberdeen Area GPRA Report",80)
INTRO ;
 D EXIT
DATES ;
 K CIMBD,CIMED,CIMPER
 S CIMQTR=0
 D Y
 I $D(CIMQUIT) D EXIT Q
 S CIMQY=""
 S DIR(0)="S^Q:One Quarter in FY "_$$FMTE^XLFDT(CIMPER)_";F:Full Fiscal Year",DIR("A")="Run the report for a",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S CIMQY=Y
 I CIMQY="Q" D Q I $D(CIMQUIT) G INTRO
ASU ;
 S CIMSUCNT=0
 S CIMRPTT=""
 S DIR(0)="S^A:AREA Aggregate;F:One Facility",DIR("A")="Run Report for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 S CIMRPTT=Y
 I CIMRPTT="F" D  G:$D(CIMQUIT) ASU
 .S CIMSUCNT=0,CIMSU="",CIMSUC="" K CIMSUL
 .K CIMSUL S CIMX=0 F  S CIMX=$O(^CIMAGP(CIMX)) Q:CIMX'=+CIMX  S V=^CIMAGP(CIMX,0) I $P(V,U)=CIMBD,$P(V,U,2)=CIMED,$P(V,U,3)=CIMPER,$P(V,U,4)=CIMQTR S CIMSUL(CIMX)="",CIMSUCNT=CIMSUCNT+1
 .I '$D(CIMSUL) W !!,"No data from that time period has been uploaded from the service units.",! S CIMQUIT=1 Q
 .W !!,"Data from the following Facilities has been received.",!,"Please select the facility.",!
 .K CIMSUL1 S X=0,C=0 F  S X=$O(CIMSUL(X)) Q:X'=+X  S C=C+1,CIMSUL1(C)=X
 .S X=0 F  S X=$O(CIMSUL1(X)) Q:X'=+X  S CIM0=^CIMAGP(CIMSUL1(X),0) W !?2,X,")",?5,"FY: ",$$FMTE^XLFDT($P(CIM0,U,3)),?15,"QTR: ",$$VAL^XBDIQ1(19255.01,X,.04),?30,"SU: ",$$SU($P(CIM0,U,6)),?55,"Facility: ",$E($$FAC($P(CIM0,U,5)),1,15)
 .W !?2,"0)",?5,"None of the Above"
 .S DIR(0)="N^0:"_C_":0",DIR("A")="Please Select the Facility",DIR("B")="0" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S CIMQUIT=1 Q
 .I 'Y S CIMQUIT=1 Q
 .K CIMSUL S CIMSUL(CIMSUL1(Y))="",CIMSUCNT=1,X=$P(^CIMAGP(CIMSUL1(Y),0),U,5),X=$O(^AUTTLOC("C",X,0)) I X S CIMSUNM=$P(^DIC(4,X,0),U)
 .Q
 G:CIMRPTT="F" ZIS
GETSU ;
 K CIMSUL S CIMX=0 F  S CIMX=$O(^CIMAGP(CIMX)) Q:CIMX'=+CIMX  S V=^CIMAGP(CIMX,0) I $P(V,U)=CIMBD,$P(V,U,2)=CIMED,$P(V,U,3)=CIMPER,$P(V,U,4)=CIMQTR S CIMSUL(CIMX)=""
 I '$D(CIMSUL) W !!,"No data from that time period has been uploaded from the service units.",! G INTRO
 W !!,"Data from the following Facilities has been received and will be used",!,"in the Area Aggregate Report:",!
 S X=0 F  S X=$O(CIMSUL(X)) Q:X'=+X  S CIM0=^CIMAGP(X,0) W !?5,"FY: ",$$FMTE^XLFDT($P(CIM0,U,3)),?15,"QTR: ",$$VAL^XBDIQ1(19255.01,X,.04),?30,"SU: ",$$SU($P(CIM0,U,6)),?55,"Facility: ",$E($$FAC($P(CIM0,U,5)),1,15)
ZIS ;call to XBDBQUE
 S CIMASUF=100090
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 S XBRP="PRINT^CIMGAGPB",XBRC="",XBRX="EXIT^CIMGAGPA",XBNS="CIM"
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
 D EN^XBVK("CIM")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
GETTAX ;
 K CIMTAX
 S CIMTAX=""
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: " D ^DIC
 I Y=-1 Q
 S CIMX=+Y
 D SU1^CIMGAGP0
 Q
Q ;which quarter
 S DIR(0)="N^1:4:0",DIR("A")="Which Quarter" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S CIMQUIT="" Q
 S CIMQTR=Y
 I Y=1 S CIMBD=($E(CIMPER,1,3)-1)_"1001",CIMED=($E(CIMPER,1,3)-1)_"1231" Q
 I Y=2 S CIMBD=$E(CIMPER,1,3)_"0101",CIMED=$E(CIMPER,1,3)_"0331" Q
 I Y=3 S CIMBD=$E(CIMPER,1,3)_"0401",CIMED=$E(CIMPER,1,3)_"0630" Q
 I Y=4 S CIMBD=$E(CIMPER,1,3)_"0701",CIMED=$E(CIMPER,1,3)_"0930" Q
 Q
Y ;fiscal year
 W !
 S CIMVDT=""
 W !,"Enter the FY of interest.  Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Fiscal year (e.g. 1999)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 If $D(DUOUT) S DIRUT=1 S CIMQUIT="" Q
 S CIMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G Y
 S CIMPER=CIMVDT,CIMBD=($E(CIMVDT,1,3)-1)_"1001",CIMED=$E(CIMVDT,1,3)_"0930"
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
