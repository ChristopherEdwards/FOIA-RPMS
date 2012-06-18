BUD9RPT1 ; IHS/CMI/LAB - UDS REPORT DRIVER 12 Dec 2009 8:11 AM ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;
 ;
 Q  ;not at top
 ;
EN ;EP
EN1 ;
 S BUDSITE=""
 S DIC="^BUDNSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 D EOJ Q
 S BUDSITE=+Y
 I '$O(^BUDNSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 D TAXCHK^BUD9XTCH
 D YEAR
 I BUDYEAR="" W !!,"Year not entered.",! D EOJ Q
 D QUARTER  ;get time period
 I BUDQTR="" W !,"Time period not entered." D EOJ Q
 ;S XBRP="PRINT^BUD9RPTP",XBRC="PROC^BUD9RPTC",XBRX="EOJ^BUD9RPT1",XBNS="BUD"
 ;D ^XBDBQUE
ZIS ;call to XBDBQUE
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^BUD9RPTC
 U IO
 D PRINT^BUD9RPTP
 D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 D EOJ
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BUD*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUD9RPT1",ZTDTH="",ZTDESC="UDS 09 REPORT" D ^%ZTLOAD D EOJ Q
 Q
M ;EP - called from option
 D EOJ
 D GENI
 K BUDT3A,BUDT3B,BUDT4,BUDT5,BUDT6,BUDTZ
 W !!,"UDS Table Selection"
 W !!?5,"1   Patients by Zip Code"
 W !?5,"2   Table 3A: Patients by Age and Gender"
 W !?5,"3   Table 3B: Patients by Hispanic or Latino Identity/Race/Language"
 W !?5,"4   Table 5 (a): Staffing List only (column A)"
 W !?5,"5   Table 5 (b&c): Staffing and Utilization (cols b&c)"
 W !?5,"6   Table 6A: Selected Diagnoses and Services Rendered"
 W !?5,"7   Multiple/ALL Tables Zip through 6A"
 S DIR(0)="L^1:7",DIR("A")="Include which Tables",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I Y[7 S (BUDT3A,BUDT3B,BUDT4,BUDT5,BUDT6,BUDTZ,BUDT5L1)=1
 I Y[2 S BUDT3A=1
 I Y[3 S BUDT3B=1
 I Y[4 S BUDT5=1,BUDT5L1=1
 I Y[5 S BUDT5=1
 I Y[6 S BUDT6=1
 I Y[1 S BUDTZ=1
 G EN1
 Q
 ;
T3A ;EP - entry point for Table 3A only
 D EOJ
 S BUDT3A=1
 D GENI
 D T3AI
 G EN1
 ;
TZ ;EP - entry point for Table 3A only
 D EOJ
 S BUDTZ=1
 D GENI
 D TZAI
 G EN1
TZAI ;intro for table Z
 W !!,"Patients by Zip Code"
 W !,"The Patients by Zip Code table reports the number of users by"
 W !,"their zip code as entered in patient registration."
 Q
T3AI ;intro for table 3A
 W !!,"TABLE 3A:  USERS BY AGE AND GENDER"
 W !,"This report will produce UDS Table 3A, an itemization of users (patients) by age"
 W !,"and gender.  Users must have at least one visit during the selected time period."
 W !,"as defined above.  Age is calculated as of June 30th of the year you select.",!
 Q
T3B ;EP
 D EOJ
 S BUDT3B=1
 D GENI
 D T3BI
 G EN1
T3BI ;
 W !!,"TABLE 3B:  USERS BY HISPANIC OR LATINO IDENTITY/RACE/LANGUAGE"
 W !,"This report will produce UDS Table 3B, an itemization of users",!,"by Hispanic or Latino Identity/Race/Language."
 Q
T5 ;EP
 D EOJ
 S BUDT5=1
 D GENI
 D T5I
 G EN1
T5I ;
 W !!,"TABLE 5 (b&c):  STAFFING AND UTILIZATION"
 W !,"This report will produce UDS Table 5 that itemizes visits and patients",!,"(columns b and c only) by primary provider discipline."
 Q
T51 ;EP
 D EOJ
 S BUDT5=1,BUDT5L1=1
 D GENI
 D T51I
 G EN1
T51I ;
 W !!,"STAFF LIST FOR TABLE 5 col a:  STAFFING"
 W !,"This report will produce a Staff List to be used to manually calculate",!,"Column A on Table 5 Staffing and Utilization, itemizing all staff by"
 W !,"disciplines and by FTE."
 Q
T6 ;EP - entry point for Table 6A only
 D EOJ
 S BUDT6=1
 D GENI
 D T6I
 G EN1
T6I ;intro for table 6
 W !!,"TABLE 6:  SELECTED DIAGNOSES AND SERVICES RENDERED"
 W !,"This report will produce UDS Table 6A which itemizes visits",!,"and patients by selected diagnoses and services provided.",!
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
 W !!,$$CTR($$LOC,80),!,$$CTR("UDS 2009",80),!
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
 Q
 ;
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
