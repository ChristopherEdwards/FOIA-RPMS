BGP8DSTM ; IHS/CMI/LAB - national patient list 20 Dec 2004 9:24 AM ; 07 Mar 2008  2:31 PM
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("IHS GPRA Performance Patient Search Template Creation",80)
 W !,$$CTR($$RPTVER^BGP8BAN,80)
INTRO ;
 D XIT
 W !!,"This will produce a search template of patients who either met or did not meet"
 W !,"a National GPRA Report performance measure.  You will be asked to select "
 W !,"one performance measure topic and then to choose which performance "
 W !,"measure numerators you would like to create a search template for."
 W !,"For example, you can create a search template of all patients who"
 W !,"did not meet the measure for having a Pap Smear in the past 3 years.",!
 W !,"You will also be asked to provide the community taxonomy to determine"
 W !,"which patients will be included, the beneficiary population of the"
 W !,"patients, and the Report Period and Baseline Year.",!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 D TAXCHK^BGP8XTCN
TP ;get time period
 D XIT
 S BGPRTYPE=1,BGP8RPTH="",BGPNPL=1,BGPINDT="G",BGP8GPU=1,BGP8NPLT=1
SI ;
 K DIRUT
 K BGPIND
 D EN^BGP8DSI
 I '$D(BGPIND) W !!,"No measures selected." H 3 D XIT Q
 K DIRUT ;I $D(DIRUT) W !!,"user typed '^' to exit."  H 3 D XIT Q
SI1 ;NOW SELECT ONE OR MORE W/IN THE TOPIC
 S BGPC=0 S BGPIND=0 F  S BGPIND=$O(BGPIND(BGPIND)) Q:BGPIND'=+BGPIND  S BGPC=BGPC+1
 I BGPC>1 W !!,"Only 1 topic is allowed, please select only one." H 2 K BGPIND G TP
 K BGPLIST,BGPX,BGPY,BGPINDL S BGPQ=0
 S BGPIND=0 F  S BGPIND=$O(BGPIND(BGPIND)) Q:BGPIND'=+BGPIND!(BGPQ)!($D(DIRUT))  D
 .S BGPCR=$S(BGPRTYPE=7:"AON",1:"AN")
 .K BGPX S BGPO=0,X=0,BGPC=0 F  S BGPO=$O(^BGPNPLE("AN",BGPIND,BGPO)) Q:BGPO'=+BGPO!($D(DIRUT))  D
 ..S X=$O(^BGPNPLE(BGPCR,BGPIND,BGPO,0))
 ..;I BGPRTYPE=1,$P(^BGPNPLE(X,0),U,4)'="N" Q
 ..;I BGPRTYPE=7,$P(^BGPNPLE(X,0),U,4)'="O" Q
 ..S BGPX(BGPO,X)="",BGPC=BGPC+1
 .;display the choices
 .W !!!,"Please select one or more of these report choices within the",!,IORVON,$P(^BGPINDE(BGPIND,0),U,3),IORVOFF," performance measure topic.",!
 .K BGPY S X=0,BGPC=0,BGPO=0 F  S BGPO=$O(BGPX(BGPO)) Q:BGPO'=+BGPO!($D(DIRUT))  S X=0 F  S X=$O(BGPX(BGPO,X)) Q:X'=+X!($D(DIRUT))  S BGPC=BGPC+1 W !?5,BGPC,")",?9,$P(^BGPNPLE(X,0),U,3) S BGPY(BGPC)=X
 .S DIR(0)="L^1:"_BGPC,DIR("A")="Which item(s)"
 .D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I Y="" W !,"No REPORTS selected for this topic." Q
 .I $D(DIRUT) W !,"No REPORTs selected for this topic." Q
 .S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPINDL(BGPIND,BGPY(BGPC))=""
 .;get report type
 .K BGPNPLT,BGPQUIT
 .S BGPI=0 F  S BGPI=$O(BGPINDL(BGPI)) Q:BGPI'=+BGPI!($D(BGPQUIT))  D
 ..S BGPII=0 F  S BGPII=$O(BGPINDL(BGPI,BGPII)) Q:BGPII'=+BGPII!($D(BGPQUIT))  D
 ...D STMP
 ...I $D(BGPQUIT) W !,"No template created......QUITTING" Q
 ...S BGPINDL(BGPI,BGPII,"TEMP")=BGPSTMP
 ;get report type
 I $D(BGPQUIT) G TP
 I '$D(BGPINDL) G TP
 D RT^BGP8DSL I '$D(BGPLIST)!($D(BGPQUIT)) G SI1
TP1 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30;5:User-Defined Report Period",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
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
 I Y=-1 Q
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
 .I Y=-1 Q
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
 W !,$$CTR("SUMMARY OF NATIONAL GPRA SEARCH TEMPLATE TO BE GENERATED")
 W !,$$CTR($$RPTVER^BGP8BAN,80)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 ;I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 ;I 'BGPHOME W !,"No HOME Location selected."
 W !,"Search templates to be generated: "
 S X=0 F  S X=$O(BGPINDL(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPINDL(X,Y)) Q:Y'=+Y  D
 .W !?2,$P(^BGPNPLE(Y,0),U,3),":  ",$P(^DIBT(BGPINDL(X,Y,"TEMP"),0),U)
 D PT^BGP8DSL
 I BGPROT="" G COMM
ZIS ;call to XBDBQUE
 D REPORT^BGP8UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCE(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPE(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBE(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGP8D1
 U IO
 D ^BGP8DP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP8NPL",XBRX="XIT^BGP8NPL",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP8D1
 D ^BGP8DP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP8NPL",ZTDTH="",ZTDESC="NATIONAL GPRA REPORT 06" D ^%ZTLOAD D XIT Q
 Q
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
ENDDATE ;
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2008)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2008 and you type in 6/30/05 the system will assume the year"
 W !,"as 1905 since that is a date in the past.  You must type 6/30/2008 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter End Date for the Report: (e.g. 11/30/2005)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (BGPPER,BGPVDT)=Y
 Q
STMP ;
EN1 ;EP Help
 K BGPQUIT S BGPSTMP=""
 W !!!,"Enter a search template name for the following list of patients:"
 S X=0 F  S X=$O(^BGPNPLE(BGPII,11,X)) Q:X'=+X  W !?3,^BGPNPLE(BGPII,11,X,0)
EN2 K DIC,DLAYGO S DLAYGO=.401,DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Patient Search Template: ",DIC("S")="I $P(^(0),U,4)=9000001&($P(^(0),U,5)=DUZ)"
 D ^DIC K DIC,DLAYGO
 I +Y<1 W !!,"No Search Template selected." H 2 S BGPQUIT=1 Q
 S BGPSTMP=+Y,BGPSNAM=$P(^DIBT(BGPSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K BGPSTMP,Y G EN2
 .S Q=""
 .W !
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(BGPSTMP):10 Q:'$T
 .S BGPSTN=$P(^DIBT(BGPSTMP,0),U) S DA=BGPSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(BGPSTMP,0)=BGPSNAM,DA=BGPSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(BGPSTMP)
 .Q
 I BGPSTMP,$D(^DIBT(BGPSTMP)) D
 .W !,?5,"An unduplicated PATIENT list resulting from this report",!,?5,"will be stored in the",BGPSNAM," Search Template.",!
 .K ^DIBT(BGPSTMP,1)
 .S DHIT="S ^DIBT("_BGPSTMP_",1,DFN)="""""
 .S DIE="^DIBT(",DA=BGPSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 .D ^DIE
 .K DIE,DA,DR
 Q
 ;
CT ;EP - create search templates and write message
 W !
 I '$G(BGPDELIM) D HEADER^BGP8DPH
 I '$G(BGPDELIM) W !,$$REPEAT^XLFSTR("-",80)
 I $G(BGPDELIM) S X=" " D S^BGP8NPLD(X,1,1) S X=" " D S^BGP8NPLD(X,1,1)
 S X=0 F  S X=$O(^XTMP("BGP8DNP",BGPJ,BGPH,"LIST",X)) Q:X'=+X  D
 .S Y=0 F  S Y=$O(^XTMP("BGP8DNP",BGPJ,BGPH,"LIST",X,Y)) Q:Y'=+Y  D
 ..S T=$G(BGPINDL(X,Y,"TEMP"))
 ..I T="" Q
 ..I '$D(^DIBT(T,0)) Q
 ..L +^DIBT(T):10 I '$T Q
 ..S C=0
 ..S P=0 F  S P=$O(^XTMP("BGP8DNP",BGPJ,BGPH,"LIST",X,Y,P)) Q:P'=+P  D
 ...S C=C+1
 ...S ^DIBT(T,1,P)=""
 ...Q
 ..L -^DIBT(T)
 ..I '$G(BGPDELIM) W !!,"Search template: ",$P(^DIBT(T,0),U)," created with ",C," members." Q
 ..S X="Search template: "_$P(^DIBT(T,0),U)_" created with "_C_" members." D S^BGP8NPLD(X,1,1)
 .Q
 Q
