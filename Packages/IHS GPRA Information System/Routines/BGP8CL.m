BGP8CL ; IHS/CMI/LAB - IHS GPRA 08 CMS REPORT DRIVER ; 01 Jul 2008  8:19 PM
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS 2008 CRS - RPMS PATIENT DATA FOR ANNUAL CMS HOSPITAL REPORTING",80)
INTRO ;
 D XIT
 S BGPRPTYR=$O(^BGPCTRL("B",2008,0))
 S X=0 F  S X=$O(^BGPCTRL(BGPRPTYR,42,X)) Q:X'=+X  W !,^BGPCTRL(BGPRPTYR,42,X,0)
 D PAUSE
GETLOC ;
 K DIC S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Enter the name of your Hospital: ",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC
 I Y=-1 D XIT Q
 S BGPHOSP=+Y
SETIND ;
 K BGPIND
 D EP^BGP8CSI
 I '$D(BGPIND) W !!,"No measures selected." D PAUSE,XIT Q
SETLIST ;
 K BGPPLST,BGPPLSTL
 F BGPXX=0 F  S BGPXX=$O(BGPIND(BGPXX)) Q:BGPXX=""  D
 .W !!,"You will now be asked to select which patient lists you want"
 .W !,"within the ",$P(^BGPCMSIE(BGPXX,0),U,3)," topic.",!
 .D PAUSE
 .D EN^BGP8CSII
 .I '$D(BGPPLSTL(BGPXX)) W !!,"No lists selected for topic ",$P(^BGPCMSIE(BGPXX,0),U,3),"." D PAUSE
 I '$D(BGPPLSTL) W !!,"No patient lists selected." D PAUSE,XIT Q
 D TAXCHK^BGP8CTXC
TP1 S (BGPBD,BGPED,BGPTP)=""
 W !
 S DIR(0)="S^1:1st Quarter January 1 - March 31;2:2nd Quarter April 1 - June 30;3:3rd Quarter July 1 - September 30;4:4th Quarter October 1 - December 31;5:User-Defined Report Period (enter beginning and ending date)"
 S DIR("A")="Enter the date range for your report"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPQTR=Y
 I BGPQTR=5 D ENDDATE
 I BGPQTR'=5 D F
 I BGPPER="" W !,"Year not entered.",! G TP1
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=2 S BGPBD=$E(BGPPER,1,3)_"0401",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=3 S BGPBD=$E(BGPPER,1,3)_"0701",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=4 S BGPBD=$E(BGPPER,1,3)_"1001",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=5 S BGPBD=BGPUDBD,BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 I BGPED>DT D  G:BGPDO=1 TP1
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
 W !!,"The date range for this report is: ",$$FMTE^XLFDT(BGPBD)," to ",$$FMTE^XLFDT(BGPED),!!
BEN ;
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP1
 S BGPBEN=Y
TEXT ;
 S BGPTEXD=""
 W !
 S DIR(0)="Y",DIR("A")="Do you want to have the explanatory/logic text printed with your report",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G BEN
 S BGPTEXD=Y
ZIS ;call to XBDBQUE
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D XIT Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^BGP8C1
 U IO
 D ^BGP8CP
 D ^%ZISC
 D XIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP8CL",ZTDTH="",ZTDESC="CRS 08 CMS REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
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
PAUSE ;
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter to Continue",DIR(0)="E" D ^DIR KILL DIR
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
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
ENDDATE ;
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2008)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2008 and you type in 6/30/08 the system will assume the year"
 W !,"as 1908 since that is a date in the past.  You must type 6/30/2008 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
DATES ;
 S BGPUDBD="",BGPUDED=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR Q:Y<1  S BGPUDBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR Q:Y<1  S (BGPPER,BGPVDT)=Y
 ;
 I BGPVDT<BGPUDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 ;
 Q
F ;calendar year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2008"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
