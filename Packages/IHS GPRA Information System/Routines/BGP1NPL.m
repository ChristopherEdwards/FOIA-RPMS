BGP1NPL ; IHS/CMI/LAB - national patient list 20 Dec 2004 9:24 AM 30 Jun 2010 5:21 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("IHS GPRA & PART Performance Report Patient List",80)
 W !,$$CTR($$RPTVER^BGP1BAN,80)
INTRO ;
 D XIT
 W !!,"This will produce a list of patients who either met or did not meet a National"
 W !,"GPRA & PART Report performance measure or a list of both those patients"
 W !,"who met and those who did not meet a National GPRA & PART Report performance"
 W !,"measure.  You will be asked to select one or more performance measure"
 W !,"topics and then choose which performance measure numerators you "
 W !,"would like to report on.",!!
 W !,"You will also be asked to provide the community taxonomy to determine"
 W !,"which patients will be included, the beneficiary population of the"
 W !,"patients, and the Report Period and Baseline Year."
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 I '$D(^XUSEC("BGPZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the BGPZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 D TAXCHK^BGP1XTCN
 S X=$$DEMOCHK^BGP1UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP1CL,XIT Q
TP ;get time period
 D XIT
 S BGPRTYPE=1,BGP1RPTH="",BGPNPL=1,BGPINDB="G",BGP1GPU=1
SI ;
 K DIRUT
 K BGPIND
 D EN^BGP1DSI
 I '$D(BGPIND) W !!,"No measures selected." H 3 D XIT Q
SI1 ;NOW SELECT ONE OR MORE W/IN THE TOPIC
 K BGPLIST,BGPX,BGPY,BGPINDL S BGPQ=0
 D TERM^VALM0
 ;REORDER IN AOI FORMAT
 K BGPINDO
 S BGPIND=0 F  S BGPIND=$O(BGPIND(BGPIND)) Q:BGPIND'=+BGPIND  S BGPINDO($P(^BGPINDB(BGPIND,12),U,6),BGPIND)=""
 S BGPORD=0 F  S BGPORD=$O(BGPINDO(BGPORD)) Q:BGPORD'=+BGPORD!(BGPQ)!($D(DIRUT))  D
 .S BGPIND=$O(BGPINDO(BGPORD,0))
 .S BGPCR=$S(BGPRTYPE=7:"AON",1:"AN")
 .K BGPX S BGPO=0,X=0,BGPC=0 F  S BGPO=$O(^BGPNPLB(BGPCR,BGPIND,BGPO)) Q:BGPO'=+BGPO!($D(DIRUT))  D
 ..S X=$O(^BGPNPLB(BGPCR,BGPIND,BGPO,0))
 ..;I BGPRTYPE=1,$P(^BGPNPLB(X,0),U,4)'="N" Q
 ..;I BGPRTYPE=7,$P(^BGPNPLB(X,0),U,4)'="O" Q
 ..S BGPX(BGPO,X)="",BGPC=BGPC+1
 .;display the choices
 .W !!!,"Please select one or more of these report choices within the",!,IORVON,$P(^BGPINDB(BGPIND,0),U,3),IORVOFF," performance measure topic.",!
 .K BGPY S X=0,BGPC=0,BGPO=0 F  S BGPO=$O(BGPX(BGPO)) Q:BGPO'=+BGPO!($D(DIRUT))  S X=0 F  S X=$O(BGPX(BGPO,X)) Q:X'=+X!($D(DIRUT))  S BGPC=BGPC+1 W !?5,BGPC,")",?9,$P(^BGPNPLB(X,0),U,3) S BGPY(BGPC)=X
 .S DIR(0)="L^1:"_BGPC,DIR("A")="Which item(s)"
 .D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I Y="" W !,"No REPORTS selected for this topic." Q
 .I $D(DIRUT) W !,"No REPORTs selected for this topic." Q
 .S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPINDL(BGPIND,BGPY(BGPC))=""
 ;get report type
 I $D(DIRUT) G SI
 K BGPQUIT D RT^BGP1DSL I '$D(BGPLIST)!($D(BGPQUIT)) G SI
TP1 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30;5:User-Defined Report Period",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SI
 S BGPQTR=Y
 I BGPQTR=5 D ENDDATE
 I BGPQTR'=5 D F
 I BGPPER="" W !,"Year not entered.",! G TP1
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 I BGPED>DT D  G:BGPDO=1 TP1
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
BY ;get baseline year
 S BGPVDT=""
 W !!,"Enter the Baseline Year to compare data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 2000)"
 D ^DIR KILL DIR
 I $D(DIRUT) G TP1
 I $D(DUOUT) S DIRUT=1 G TP1
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 I BGPPBD=BGPBBD,BGPPED=BGPBED K Y D CHKY I Y K BGPBBD,BGPBED,BGPPBD,BGPPED G BY
COMM ;
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BGPTAX
 S BGPTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC
 I Y=-1 G BY
 S BGPTAXI=+Y
COM1 ;
 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(BGPTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but was not",!,"found in the standard community table." S G=1
 .Q
 I G D  I BGPQUIT D XIT Q
 .W !!,"These communities may have been renamed or there may be patients"
 .W !,"who have been reassigned from this community to a new community and this"
 .W !,"could reduce your patient population."
 .S BGPQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you want to cancel the report and review the communities" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1
 .I Y S BGPQUIT=1
 .Q
MFIC K BGPQUIT
 I $P($G(^BGPSITE(DUZ(2),0)),U,8)=1 D  I BGPMFITI="" G COMM
 .S BGPMFITI=""
 .W !!,"Specify the LOCATION taxonomy to determine which patient visits will be"
 .W !,"used to determine whether a patient is in the denominators for the report."
 .W !,"You should have created this taxonomy using QMAN.",!
 .K BGPMFIT
 .S BGPMFITI=""
 .D ^XBFMK
 .S DIC("S")="I $P(^(0),U,15)=9999999.06",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Location/Facility Taxonomy: "
 .S B=$P($G(^BGPSITE(DUZ(2),0)),U,9) I B S DIC("B")=$P(^ATXAX(B,0),U)
 .D ^DIC
 .I Y=-1 G COMM
 .S BGPMFITI=+Y
BEN ;
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPBEN=Y,BGPBENF=Y(0)
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 ;I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G SUM
 ;W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
SUM ;display summary of this report
 W:$D(IOF) @IOF
 I BGPRTYPE=7 W !,$$CTR("SUMMARY OF "_$S(BGPRTYPE=7:"OTHER ",1:"")_"NATIONAL GPRA REPORT TO BE GENERATED")
 I BGPRTYPE'=7 W !,$$CTR("SUMMARY OF NATIONAL GPRA & PART REPORT TO BE GENERATED")
 W !,$$CTR($$RPTVER^BGP1BAN,80)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 ;I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 ;I 'BGPHOME W !,"No HOME Location selected."
 ;W !!,"All AREA DIRECTOR CLINICAL measures will be calculated."
 D PT^BGP1DSL
 I BGPROT="" G COMM
ZIS ;call to XBDBQUE
 D REPORT^BGP1UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 S BGPUF=$$GETDIR^BGP1UTL2()
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCB(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPB(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBB(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGP1D1
 U IO
 D ^BGP1DP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP1NPL",XBRX="XIT^BGP1NPL",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP1D1
 D ^BGP1DP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP1NPL",ZTDTH="",ZTDESC="NATIONAL GPRA REPORT 06" D ^%ZTLOAD D XIT Q
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
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;calendar year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2011"
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
ENDDATE ;
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2011)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2010 and you type in 6/30/05 the system will assume the year"
 W !,"as 1905 since that is a date in the past.  You must type 6/30/2009 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter End Date for the Report: (e.g. 11/30/2005)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (BGPPER,BGPVDT)=Y
 Q
 ;
NONNPL ;EP
 W:$D(IOF) @IOF
 W !,$$CTR("IHS Other National Measures Performance Report Patient List",80)
 W !,$$CTR($$RPTVER^BGP1BAN,80)
INTRONON ;
 D XIT
 W !!,"This will produce a list of patients who either met or did not meet"
 W !,"an Other National Measures Report performance measure or a list of"
 W !,"both those patients who met and those who did not meet an Other National "
 W !,"Measures Report performance measure.  You will be asked to select one or "
 W !,"more performance measure topics and then choose which performance "
 W !,"measure numerators you would like to report on."
 W !!,"You will also be asked to provide the community taxonomy to determine"
 W !,"which patients will be included, the beneficiary population of the"
 W !,"patients, and the Report Period and Baseline Year."
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 I '$D(^XUSEC("BGPZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the BGPZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 D TAXCHK^BGP1XTCO
 S X=$$DEMOCHK^BGP1UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP1CL,XIT Q
TPNON ;get time period
 D XIT
 S BGPRTYPE=7,BGP1RPTH="",BGPNPL=1,BGPINDB="G",BGP1GPU=1,BGPONMR=1,BGPRTC="U"
 G SI
