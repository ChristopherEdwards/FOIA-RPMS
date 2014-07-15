BUD2RPT1 ; IHS/CMI/LAB - UDS REPORT DRIVER 12 Dec 2012 8:11 AM 06 Oct 2012 1:48 PM ; 
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
 Q  ;not at top
 ;
EN ;EP
EN1 ;
 I $G(BUDT6B) W !,"Table 6B:" D PRENATT^BUD2RP6B
 I $G(BUDT7) W !,"Table 7:" D PRENATT^BUD2RP7
 I $G(BUDT6B)!($G(BUDT7)) D PNC I BUDPREN="" D EOJ Q
 S BUDSITE=""
 S DIC="^BUDRSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 D EOJ Q
 S BUDSITE=+Y
 I '$O(^BUDRSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 S Q=0
 S BUDDIR=$$GETDIR()
 I $G(BUDT9)!($G(BUDT9D)) D  I Q D EOJ Q
 .Q:DUZ(2)=BUDSITE
 .W !!,"WARNING:  You selected a site that is different from the site you are"
 .W !,"logged in as and you selected to run Table 9 or Table 9 (Delimited).  In"
 .W !,"order to get the appropriate data for these 2 tables you must be logged"
 .W !,"into RPMS as the same site as you selected as your UDS Site.  If you"
 .W !,"want to run Tables 9 or 9 (Delimited) for ",$P(^DIC(4,BUDSITE,0),U,1)
 .W !,"you must log out and log back into RPMS selecting Division"
 .W !,$P(^DIC(4,BUDSITE,0),U,1),"."
 .D PAUSE^BUD2RP7
 .S Q=1
 S Q=""
 I $G(BUDT4) D  I Q D EOJ Q
 .S S=$$VAL^XBDIQ1(9999999.06,BUDSITE,.16)
 .I S="" W !!,"SORRY, but I can't tell what state your clinic is located in" D
 ..W !,"so I can't run table 4's income section. Please ask your site manager"
 ..W !,"to put a state in the LOCATION file, field .16."
 ..D PAUSE^BUD2RP7
 ..S Q=1
 D TAXCHK^BUD2XTCH
Y D YEAR
 I BUDYEAR="" W !!,"Year not entered.",! D EOJ Q
 D QUARTER  ;get time period
 I BUDQTR="" W !,"Time period not entered." D EOJ Q
 ;get indian or not
 S BUDBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G Y
 S BUDBEN=Y
 I $G(BUDT9D) D DELF I BUDFILE="" D EOJ Q
ZIS ;call to XBDBQUE
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^BUD2RPTC
 U IO
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
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUD2RPT1",ZTDTH="",ZTDESC="UDS 12 REPORT" D ^%ZTLOAD D EOJ Q
 Q
M ;EP - called from option
 D EOJ
 S BUDXXXXX=1
 D GENI
 K BUDT3A,BUDT3B,BUDT4,BUDT5,BUDT6,BUDTZ,BUDT5L1,BUDT6B,BUDT7
 W !!,"UDS Table Selection"
 W !!?5,"1   Patients by Zip Code"
 W !?5,"2   Table 3A: Patients by Age and Gender"
 W !?5,"3   Table 3B: Patients by Hispanic or Latino Identity/Race/Language"
 W !?5,"4   Table 4: Selected Patient Characteristics"
 W !?5,"5   Table 5 (a): Staffing List only (column A)"
 W !?5,"6   Table 5 (b&c): Staffing and Utilization (cols b&c)"
 W !?5,"7   Table 6A: Selected Diagnoses and Services Rendered"
 W !?5,"8   Table 6B: Quality of Care Indicators"
 W !?5,"9   Table 7: Health Outcomes and Disparities"
 W !?5,"10  Table 9D: Patient-Related Revenue (Total Counts Only)"
 W !?5,"11  Table 9D: Patient-Related Revenue (Delimited Report)"
 W !?5,"12   Multiple/ALL Tables Zip through 9D"
 S DIR(0)="L^1:12",DIR("A")="Include which Tables",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 F X=1:1 S Z=$P(Y,",",X) Q:Z=""  D
 .I Z=12 S (BUDT3A,BUDT3B,BUDT4,BUDT5,BUDT6,BUDTZ,BUDT5L1,BUDT6B,BUDT7,BUDT9,BUDT9D)=1
 .I Z=2 S BUDT3A=1
 .I Z=3 S BUDT3B=1
 .I Z=4 S BUDT4=1
 .I Z=5 S BUDT5=1,BUDT5L1=1
 .I Z=6 S BUDT5=1
 .I Z=7 S BUDT6=1
 .I Z=1 S BUDTZ=1
 .I Z=8 S BUDT6B=1
 .I Z=9 S BUDT7=1
 .I Z=10 S BUDT9=1
 .I Z=11 S BUDT9D=1
 G EN1
 ;
PNC ;
 S BUDPREN=""
 S DIR(0)="Y",DIR("A")="Does your facility provide prenatal care",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BUDPREN=Y
 Q
T3A ;EP - entry point for Table 3A only
 D EOJ
 S BUDT3A=1
 D GENI
 D T3AI
 G EN1
 ;
T4 ;EP - entry point for Table 3A only
 D EOJ
 S BUDT4=1
 D GENI
 D T4I
 G EN1
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
T4I ;intro for table 4
 W !!,"TABLE 4:  SELECTED PATIENT CHARACTERISTICS"
 W !,"This report will produce UDS Table 4, selected patient characteristics."
 W !,"Patients must meet additional criteria as specified for each indicator.",!
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
 W !!,"TABLE 6A:  SELECTED DIAGNOSES AND SERVICES RENDERED"
 W !,"This report will produce UDS Table 6A which itemizes visits",!,"and patients by selected diagnoses and services provided.",!
 Q
 ;
T9D ;EP
 D EOJ
 S BUDT9D=1
 D GENI
 S BUDDIR=$$GETDIR()
 D T9DI
 G EN1
T9DI ;
 W !!,"TABLE 9D:  Patient-Related Revenue (Delimited Report)"
 W !,"This is a delimited report, which will can be used to produce UDS Table 9D,"
 W !,"Patient-Related Revenue.  Table 9D collects information on charges, "
 W !,"collections, retroactive settlements, allowances, self-pay sliding "
 W !,"discounts, and self-pay bad debt write-off."
 W !!,"NOTE:  This delimited file will include only A/R Transactions for patients"
 W !,"who are considered 'UDS' patients (i.e. they are included in Table 3A)"
 W !!,"NOTE:  You will be required to enter a name for the delimited output file."
 W !,"This file will be placed in the following directory:"
 W !?10,BUDDIR,!
 Q
 ;
T9 ;EP
 D EOJ
 S BUDT9=1
 D GENI
 D T9I
 G EN1
T9I ;
 W !!,"TABLE 9D:  Patient-Related Revenue (Total Counts Only)"
 W !,"This report will produce UDS Table 9D, Patient-Related Revenue. This table "
 W !,"collects information on charges, collections, retroactive settlements, "
 W !,"allowances, self-pay sliding discounts, and self-pay bad debt write-off. "
 W !,"Because there is currently no way to distinguish between non-managed care "
 W !,"and managed care in RPMS, UDS will only calculate the total counts (lines 3,"
 W !,"6, 9, 12, and 14) for columns a, b, and d."
 W !
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
 Q:'$D(BUDXXXXX)
 W !
 W !,"NOTE: Tables 6B and 7 must be run using the Full Calendar Year option."
 W !,"If these reports are run using the Quarterly options, the totals combined"
 W !,"will not match the yearly totals."
 W !
 D PAUSE^BUD2RP7
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
GETDIR() ;EP - get default directory
 NEW D
 S D=""
 S D=$P($G(^AUTTSITE(1,1)),"^",2)
 I D]"" Q D
 S D=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I D]"" Q D
 ;I $P(^AUTTSITE(1,0),U,21)=1 S D="/usr/spool/uucppublic/"
 Q D
 ;
DELF ;
 S BUDFILE="",BUDDELT="F"
 W !!,"You have selected to create a delimited output file for Table 9D.  "
 ;W !,"You can have this output file created as a text file in the pub directory, "
 ;W !,"OR you can have the delimited output display on your screen so that"
 ;W !,"you can do a file capture.  Keep in mind that if you choose to"
 ;W !,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 ;S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to an output file",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G PT
 ;S BUDDELT=Y
 ;Q:BUDDELT="S"
PT1 S DIR(0)="F^1:40",DIR("A")="Enter a filename for the delimited output (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y["/"!(Y["\") W !!!,"Your filename cannot contain a '/' or a '\'." H 2 G PT1
 S BUDFILE=Y
 W !!,"When the report is finished your delimited output will be found in the",!,BUDDIR," directory.  The filename will be ",BUDFILE,".txt",!
 Q
