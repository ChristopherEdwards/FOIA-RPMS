BUD2RPTS ; IHS/CMI/LAB - UDS REPORT DRIVER 12 Dec 2012 8:11 AM ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
 Q  ;not at top
 ;
EN ;EP
 D EOJ
 W !!,"SEARCH TEMPLATE CREATION FOR PATIENTS INCLUDED IN TABLE 3A.",!
 D GENI
 ;D T3AI
EN1 ;
 S BUDSITE=""
 S DIC="^BUDRSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 D EOJ Q
 S BUDSITE=+Y
 I '$O(^BUDRSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 D TAXCHK^BUD2XTCH
 D YEAR
 I BUDYEAR="" W !!,"Year not entered.",! D EOJ Q
 D QUARTER  ;get time period
 I BUDQTR="" W !,"Time period not entered." D EOJ Q
 ;get indian or not
 S BUDBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EN1
 S BUDBEN=Y
TEMP ;
 S BUDSTMP=""
 D EN^BUD2STMP
 I BUDSTMP="" G EN
ZIS ;call to XBDBQUE
 S BUDT3A=1
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^BUD2RPTC
 U IO
 D PRINTCP
 D PRINT^BUD2RPTP
 D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 D EOJ
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BUD*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUD2RPTS",ZTDTH="",ZTDESC="UDS 12 REPORT SEARCH TEMPLATE" D ^%ZTLOAD D EOJ Q
 Q
PRINTCP ;
 W !
 S X=$$CTR($P(^DIC(4,BUDSITE,0),U),60),$E(X,3)=$P(^VA(200,DUZ,0),U,2),$E(X,10)="UDS 2012",$E(X,70)="Cover Page" W !,X
 W !,"UDS No.  ",$P(^BUDRSITE(BUDSITE,0),U,2),?50,"Date Run: ",$$FMTE^XLFDT(DT)
 W !,"Reporting Period:  ",$$FMTE^XLFDT(BUDBD)," through ",$$FMTE^XLFDT(BUDED)
 W !
 S X=$$REPEAT^XLFSTR("-",79) W X,!
 W !!,"Search Template ",$P(^DIBT(BUDSTMP,0),U,1)," successfully created.",!
 S BUDFNP=1
 Q
T3AI ;intro for table 3A
 W !!,"TABLE 3A:  USERS BY AGE AND GENDER WITH SEARCH TEMPLATE CREATION"
 W !,"This report will produce UDS Table 3A, an itemization of users (patients) by age"
 W !,"and gender.  Users must have at least one visit during the selected time period.",!,"as defined above.  Age is calculated as of June 30th of the year you select.",!
 W !,"The patients included in this table will be stored in a search template"
 W !,"for you to use in other applications (QMAN, PGEN) to assist you in"
 W !,"completing UDS tables not produced the the IHS/RPMS UDS System."
 Q
QUARTER ;
 S BUDQTR=""
 S DIR("?",1)="Select the quarter you want to report on"
 S DIR("?",2)="     1  January 1 - March 31"
 S DIR("?",3)="     2  April 1 - June 30"
 S DIR("?",4)="     3  July 1 - September 30"
 S DIR("?",5)="     4  October 1 - December 31"
 S DIR("?",6)="     F  Full Calender Year January 1 - December 31"
 S DIR(0)="S^1:1st Quarter (January 1 - March 31);2:2nd Quarter (April 1 - June 30);3:3rd Quarter (July 1 - September 30);4:4th Quarter (October 1 - December 31);F:Full Calendar Year (January 1 - December 31)"
 S DIR("A")="Choose the time period to report on",DIR("B")="F" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S BUDQUIT="" Q
 S BUDQTR=Y
 I Y=1 S BUDBD=$E(BUDYEAR,1,3)_"0101",BUDED=$E(BUDYEAR,1,3)_"0331"
 I Y=2 S BUDBD=$E(BUDYEAR,1,3)_"0401",BUDED=$E(BUDYEAR,1,3)_"0630"
 I Y=3 S BUDBD=$E(BUDYEAR,1,3)_"0701",BUDED=$E(BUDYEAR,1,3)_"0930"
 I Y=4 S BUDBD=$E(BUDYEAR,1,3)_"1001",BUDED=$E(BUDYEAR,1,3)_"1231"
 I Y="F" S BUDBD=$E(BUDYEAR,1,3)_"0101",BUDED=$E(BUDYEAR,1,3)_"1231"
 W !!,"Your report will be run for the time period: ",$$FMTE^XLFDT(BUDBD)," to ",$$FMTE^XLFDT(BUDED)
 Q
YEAR ;
 S BUDYEAR=""
 W !
 W !,"Enter the Calendar Year.  Use a 4 digit year, e.g. 2003, 2007"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Calendar Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 Q
 I $D(DIRUT) Q
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YEAR
 S BUDYEAR=Y,BUDBD=$E(BUDYEAR,1,3)_"0101",BUDED=$E(BUDYEAR,1,3)_"1231"
 S BUDCAD=$E(BUDYEAR,1,3)_"0630"
 Q
EOJ ;
 D EN^XBVK("BUD")
 Q
GENI ;general introductions
 W:$D(IOF) @(IOF)
 W !!,$$CTR($$LOC,80),!,$$CTR("UDS 2012",80),!
 W !,"UDS searches your database to find all visits and related patients"
 W !,"during the time period selected. Based on the UDS definition, to be considered"
 W !,"a patient the patient must have had at least one visit meeting the following"
 W !,"criteria:"
 W !?4,"- must be to a location specified in your visit location setup"
 W !?4,"- must be to Service Category Ambulatory (A), Hospitalization (H), Day"
 W !?6,"Surgery (S), Observation (O), Telemedicine (M), Nursing home visit (R), "
 W !?6,"or In-Hospital (I) visit"
 W !?4,"- must NOT have an excluded clinic code (see User Manual for a list)"
 W !?4,"- must have a primary provider and a coded purpose of visit"
 W !
 D PAUSE
 W !,"TABLE 3A:  PATIENTS BY AGE AND GENDER WITH SEARCH TEMPLATE CREATION"
 W !!,"This option will create a search template of all patients who meet"
 W !,"the definition of a patient above and who are included in UDS Table 3A."
 W !,"You may use this search template in other applications (QMAN, PGEN)"
 W !,"to assist you in completing UDS tables not produced by the IHS/RPMS UDS"
 W !,"application."
 W !!,"Patients must have at least one visit during the selected time period,"
 W !,"as defined above.  Age is calculated as of June 30th of the year you"
 W !,"select."
 W !
 W !,"This option will also produce UDS Table 3A, an itemization of users"
 W !,"(patients) by age and gender."
 W !
 Q
 ;
PAUSE ;
  K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
  Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
NRY ;
 W !!,"not developed yet....." H 3
 Q
STEMP ;EP
 S X=0 F  S X=$O(^XTMP("BUD2RPT1",BUDJ,BUDH,"3ATEMP",X)) Q:X'=+X  S ^DIBT(BUDSTMP,1,X)=""
 Q
