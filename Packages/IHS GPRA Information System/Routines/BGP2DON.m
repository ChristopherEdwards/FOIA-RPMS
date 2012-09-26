BGP2DON ; IHS/CMI/LAB - NATL COMP EXPORT 13 Nov 2006 12:31 PM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
 W:$D(IOF) @IOF
 D XIT
 W !,$$CTR("IHS 2012 Other National Measures Report",80)
CHOICE ;
 W !!,"Please select the type of report would you like to run:"
 W !!?8,"H  Hard-coded Report:  Report with all parameters set to the"
 W !?11,"same as the National GPRA and Part Report (report period of "
 W !?11,"July 1, 2011 - June 30, 2012, baseline period of July 1, 1999"
 W !?11,"- June 30, 2000, and AI/AN patients only)"
 W !!?8,"U  User-defined Report:  You select the report and baseline"
 W !?11,"periods and beneficiary population"
 W !
 S DIR(0)="F^1:1",DIR("A")="Select a Report Option"
 S DIR("B")="H",DIR("?")="Enter an H for Hard-coded or a U for User-defined"
 D ^DIR
 I $D(DIRUT) D XIT Q
 KILL DIR
 S Y=$$UP^XLFSTR(Y) I Y'="U",Y'="H" W !!,"Please enter an H for Hard-coded or a U for User-defined." G CHOICE
 S BGPRTC=Y
INTRO ;
 W !,$$CTR("IHS 2012 Other National Measures Report",80)
 I BGPRTC="U" D
 .W !!,"This will produce the Other National Measures (ONM) Report for all"
 .W !,"ONM performance measures for a year period you specify.  You will be "
 .W !,"asked to provide: 1) the reporting period, 2) the baseline period to "
 .W !,"compare data to, 3) the community taxonomy  to determine which patients"
 .W !,"will be included, and the 4) beneficiary population."
 .W !!,"You will be given the opportunity to export this data to the Area office."
 .W !,"If you answer yes, this option will produce a report in export format for "
 .W !,"the Area Office to use in Area aggregated data.  Depending on site specific"
 .W !,"configuration, the export file will either be automatically transmitted"
 .W !,"directly to the Area or the site will have to send the file manually."
 .W !
 I BGPRTC="H" D
 .W !!,"This will produce an Other National Measures report.  You will be asked to"
 .W !,"provide the community taxonomy to determine which patients will be included."
 .W !,"This report will be run for the Report Period July 1, 2011 through "
 .W !,"June 30, 2012 with a Baseline Year of July 1, 1999 through June 30, 2000."
 .W !,"This report will include beneficiary population of American Indian/Alaska"
 .W !,"Native only."
 .W !!,"You can choose to export this data to the Area office.  If you answer yes"
 .W !,"at the export prompt, a report will be produced in export format for the "
 .W !,"Area Office to use in Area aggregated data.  Depending on site specific"
 .W !,"configuration, the export file will either be automatically transmitted"
 .W !,"directly to the Area or the site will have to send the file manually."
 .W !
 K DIR S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR,DUOUT,DIRUT
 D TAXCHK^BGP2XTCO
 S X=$$DEMOCHK^BGP2UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP2DU,XIT Q
ST ;
TP ;get time period
 S BGPRTYPE=7,BGPYRPTH=""
 S (BGPBD,BGPED,BGPTP)=""
H I BGPRTC="H" D  G COMM
 .S X=$O(^BGPCTRL("B",2012,0))
 .S Y=^BGPCTRL(X,0)
 .S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 .S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 .S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 .S BGPPER=$P(Y,U,14),BGPQTR=3
 .;BEGIN TEST STUFF
 .G NT  ;COMMENT OUT THIS LINE WHEN TESTING IN TEHR
 .W !!,"for testing purposes only, please enter a report year",!
 .D F
 .I BGPPER="" W !!,"no year entered..bye" D XIT Q
 .S BGPQTR=3
 .S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 .S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 .W !!,"for testing purposes only, please enter a BASELINE year",!
 .D B
 .I BGPBPER="" W !!,"no year entered..bye" D XIT Q
 .S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
NT .;END TEST STUFF
 .W !!,"The date ranges for this report are:"
 .W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 .W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 .W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 .S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 .I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G H1
 .W !!,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
H1 .S BGPBEN=1,BGPBENF(0)="Indian/Alaskan Native (Classification 01)" W !!,"Beneficiary Population is set to American Indian/Alaskan Native Only."
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30;5:User-Defined Report Period",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPQTR=Y
 I BGPQTR=5 D ENDDATE
 I BGPQTR'=5 D F
 I BGPPER="" W !,"Year not entered.",! G TP
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 I BGPED>DT D  G:BGPDO=1 TP
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
 I Y=-1 G CHOICE
 S BGPTAXI=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(BGPTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but does not",!,"exist in the community table.  Please recreate your community taxonomy." S G=1
 .Q
 I G W !!,"The community taxonomy may not be accurate." D  I BGPQUIT D XIT Q
 .S BGPQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you wish to continue running the report" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1
 .I 'Y S BGPQUIT=1
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
 ;I $G(BGPSEAT) G HOME
 I BGPRTC="H" G HOME
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPBEN=Y,BGPBENF(0)=Y(0)
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G AI
 W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
AI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDW("ON",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDW="O"
EXPORT ;export to area or not?
 S BGPEXPT="",BGPYWCHW=0
 ;I $D(BGPSEAT) G EISSEX
 S DIR(0)="Y",DIR("A")="Do you wish to export this data to Area" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPEXPT=Y
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP2UTL2()
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 ;I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 I BGPEXPT,BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." D PAUSE^BGP2DU,XIT Q
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF OTHER NATIONAL MEASURES REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 W !,"The Beneficiary Population is: ",BGPBENF(0)
 ;I $G(BGPSEAT) W !!,"The Patient Population is: ",$P(^DIBT(BGPSEAT,0),U,1)
 ;W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 I 'BGPHOME W !,"No HOME Location selected."
 D PT^BGP2DSL
 I BGPROT="" G BEN
ZIS ;call to XBDBQUE
 D REPORT^BGP2UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 I BGPEXPT D
 .W !!,"A file will be created called BG121",$P(^AUTTLOC(DUZ(2),0),U,10)_".ONM"_BGPRPT," and will reside",!,"in the ",BGPUF," directory.",!
 .W !,"Depending on your site configuration, these files may need to be manually",!,"sent to your Area Office.",!
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCW(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPW(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBW(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGP2D1
 ;I $D(BGPSEAT) D ^BGP2D10
 U IO
 D ^BGP2DP
 D ^%ZISC
 I BGPEXPT D GS^BGP2UTL
 ;I $G(BGPEXCEL) D EXCELGS^BGP2UTL
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP2DON",XBRX="XIT^BGP2DON",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP2D1
 ;I $D(BGPSEAT) D ^BGP2D10
 D ^BGP2DP
 D ^%ZISC
 I BGPEXPT D GS^BGP2UTL
 ;I $G(BGPEXCEL) D EXCELGS^BGP2UTL
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP2DON",ZTDTH="",ZTDESC="Other National Measures REPORT 11" D ^%ZTLOAD D XIT Q
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
F ;fiscal year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the year for the report.  Use a 4 digit ",!,"year, e.g. 2012"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter BASELINE year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPBPER=BGPVDT
 Q
ENDDATE ;EP
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2012)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2010 and you type in 6/30/05 the system will assume the year"
 W !,"as 1905 since that is a date in the past.  You must type 6/30/2010 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter End Date for the Report: (e.g. 11/30/2005)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (BGPPER,BGPVDT)=Y
 Q
