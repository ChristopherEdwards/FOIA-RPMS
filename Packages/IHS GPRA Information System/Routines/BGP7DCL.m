BGP7DCL ; IHS/CMI/LAB - national patient list 20 Dec 2004 9:24 AM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("Comprehensive National GPRA Patient List",80)
 W !,$$CTR("CRS 2007, Version 7.0",80)
INTRO ;
 D XIT
 S BGPTEXT="INTROT" F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ) Q:$P(BGPX,";;",2)="END"  S BGPT=$P(BGPX,";;",2) W !,BGPT
 D EOP
 S BGPTEXT="INTROT1" F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ) Q:$P(BGPX,";;",2)="END"  S BGPT=$P(BGPX,";;",2) W !,BGPT
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 D TAXCHK^BGP7XTCN
TP ;get time period
 D XIT
 S BGPRTYPE=1,BGP7RPTH="",BGPCPPL=1,BGPINDT="G",BGP7GPU=1
SI ;
 K DIRUT
 ;K BGPIND
 ;D EN^BGP7DSI
 ;I '$D(BGPIND) W !!,"No measures selected." H 3 D XIT Q
SI1 ;NOW SELECT ONE OR MORE W/IN THE TOPIC
 ;K BGPLIST,BGPX,BGPY,BGPINDL S BGPQ=0
 ;S BGPIND=0 F  S BGPIND=$O(BGPIND(BGPIND)) Q:BGPIND'=+BGPIND!(BGPQ)!($D(DIRUT))  D
 ;.K BGPX S X=0,BGPC=0 F  S X=$O(^BGPANPL("B",BGPIND,X)) Q:X'=+X!($D(DIRUT))  S BGPX(X)="",BGPC=BGPC+1
 ;.;display the choices
 ;.W !!!,"Please select one or more of these report choices within the",!,$P(^BGPINDA(BGPIND,0),U,3)," measure topic.",!
 ;.K BGPY S X=0,BGPC=0 F  S X=$O(BGPX(X)) Q:X'=+X!($D(DIRUT))  S BGPC=BGPC+1 W !?10,BGPC,")",?14,$P(^BGPANPL(X,0),U,3) S BGPY(BGPC)=X
 ;.S DIR(0)="L^1:"_BGPC,DIR("A")="Which item(s)"
 ;.D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;.I Y="" W !,"No REPORTS selected for this topic." Q
 ;.I $D(DIRUT) W !,"No REPORTs selected for this topic." Q
 ;.S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPINDL(BGPIND,BGPY(BGPC))=""
 ;get report type
 I $D(DIRUT) G XIT
 D RT^BGP7DSL I '$D(BGPLIST)!($D(BGPQUIT)) G XIT
 ;BEGIN TEST STUFF
 ;W !!,"for testing purposes only, please enter a report year",!
 ;D F
 ;I BGPPER="" W !!,"no year entered..bye" D XIT Q
 ;S BGPQTR=3
 ;S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 ;S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 ;W !!,"for testing purposes only, please enter a BASELINE year",!
 ;D B
 ;I BGPBPER="" W !!,"no year entered..bye" D XIT Q
 ;S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
 ;END TEST STUFF
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
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
BY ;get baseline year
 S BGPVDT=3000000
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
COM1 S X=0
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
 S BGPBEN=1
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G SUM
 W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
AI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDA("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF COMPREHENSIVE NATIONAL PATIENT LIST REPORT TO BE GENERATED")
 W !,$$CTR("CRS 2007, Version 7.0",80)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I 'BGPHOME W !,"No HOME Location selected."
 ;W !!,"All AREA DIRECTOR CLINICAL measures will be calculated."
 D PT^BGP7DSL
 I BGPROT="" G COMM
ZIS ;call to XBDBQUE
 D REPORT^BGP7UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCA(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPA(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBA(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 S BGPCPLC=0
 D ^BGP7D1
 U IO
 D ^BGP7DP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP7DCL",XBRX="XIT^BGP7DCL",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 S BGPCPLC=0
 D ^BGP7D1
 D ^BGP7DP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP7DCL",ZTDTH="",ZTDESC="COMPREHENSIVE PT LIST GPRA 06" D ^%ZTLOAD D XIT Q
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
 ;Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press ENTER to Continue"
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
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2007"
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
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2007)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2007 and you type in 6/30/06 the system will assume the year"
 W !,"as 1906 since that is a date in the past.  You must type 6/30/2007 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter End Date for the Report: (e.g. 11/30/2005)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (BGPPER,BGPVDT)=Y
 Q
INTROT ;
 ;;This report will enable users to run a patient list that shows all of the
 ;;National GPRA report performance measures that are reported to Congress
 ;;in which a patient was included but did not meet. Performance measures
 ;;not relevant to a patient will not be listed.  For example, if a male
 ;;patient who is 30 years old, he would not be listed as having not met
 ;;the Child Immunizations or Pap Smear measures.
 ;;The list will include the National GPRA report logic and performance measure 
 ;;rates for Report Period, Previous Year, and Baseline Year for all
 ;;the measures, followed by a list of patients that shows which
 ;;measures each patient did not meet.
 ;;
 ;;You will be asked to provide the Community taxonomy to determine
 ;;which patients will be included. This report will be run for a time period
 ;;selected by the user.  This report will include beneficiary population
 ;;of American Indian/Alaska Native only.
 ;;
 ;;
 ;;END
 ;
INTROT1 ;
 ;;W A R N I N G *** W A R N I N G *** W A R N I N G ***
 ;;
 ;;This report will list every patient in your user population that has
 ;;not met one of the measures.  This report can be very, very lengthy.
 ;;For example, if there are 10,000 patients in your user population
 ;;and at least 8,000 of them have not met one or more measures then
 ;;the report will list 8,000 patients. At approximately 45 patients per
 ;;page, the report will be 177 pages long.  It is highly recommended
 ;;that you use the delimited output for this report rather than print
 ;;it to a printer/paper.
 ;;
 ;;END
