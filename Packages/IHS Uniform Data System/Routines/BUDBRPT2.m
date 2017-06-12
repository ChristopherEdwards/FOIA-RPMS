BUDBRPT2 ; IHS/CMI/LAB - UDS REPORT DRIVER  ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
 Q  ;not at top
 ;
EN ;EP
 D EOJ
EN1 ;
 S BUDSITE=""
 W ! S DIC="^BUDBSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 D EOJ Q
 S BUDSITE=+Y
 I '$O(^BUDBSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 D TAXCHK^BUDBXTCH
 D YEAR
 I BUDYEAR="" W !!,"Year not entered.",! D EOJ Q
 D QUARTER  ;get time period
 I BUDQTR="" W !,"Time period not entered." D EOJ Q
 ;get indian or not
 S BUDBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Classification not entered." D EOJ Q
 S BUDBEN=Y
 W !!,"Depending on the size of your database, this report may take 2-4 hours to run"
 W !,"and produce patient reports that are hundreds of pages long.  It is recommended"
 W !,"that these reports be run at night and printed to an electronic file, rather "
 W !,"than directly to a printer."
 W !
 S DIR(0)="Y",DIR("A")="Do you want to exit this program now",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I Y D EOJ Q
 ;S XBRP="PRINT^BUDBRPTP",XBRC="PROC^BUDBRPTC",XBRX="EOJ^BUDBRPT2",XBNS="BUD"
 ;D ^XBDBQUE
 ;D EOJ
ZIS ;call to XBDBQUE
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^BUDBRPTC
 U IO
 D PRINT^BUDBRPTP
 D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 D EOJ
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BUD*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUDBRPT2",ZTDTH="",ZTDESC="UDS 14 REPORT" D ^%ZTLOAD D EOJ Q
 Q
M ;EP - called from option
 D EOJ
 D GENI
 K BUDT3A,BUDT3B,BUDT5,BUDT5L,BUDT5L1,BUDT6,BUDT6L,BUDT5L2,BUDT5L3
 W "UDS Patient and Provider List Selection"
 W !!?5,"1   All Patients w/Visits by ZIP Code and Insurance Source"
 W !?5,"2   All Patients w/Visits, by Age & Gender (Tables 3A)"
 W !?5,"3   All Patients w/Visits, by Hispanic or Latino Identity & Race (Table 3B)"
 W !?5,"4   Income Percent of Poverty Level (Table 4)"
 W !?5,"5   Principle Third Party Medical Insurance Source (Table 4)"
 W !?5,"6   Characteristics of Special Populations (Table 4)"
 W !?5,"7   Provider/Staff List (Table 5 col A)"
 W !?5,"8   All patients by Service Category (Table 5 col B&C)"
 W !?5,"9   All Visits w/Uncategorized Primary Prov (Table 5 col B&C)"
 W !?5,"10   All Patients by Diagnosis (Table 6A)"
 W !?5,"11   ALL Patient Lists for LST1 -Sub Menu"
 S DIR(0)="L^1:11",DIR("A")="Include which Lists",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 F X=1:1 S Z=$P(Y,",",X) Q:Z=""  D
 .I Z=11 S (BUDT3A,BUDT3B,BUDT3BRL,BUDT4,BUDT4IPP,BUDT4PMI,BUDT4CHA,BUDT5,BUDT6,BUDT3AL,BUDT5L,BUDT5L1,BUDT6L,BUDTZ,BUDTZL,BUDT5L2)=1
 .I Z=2 S (BUDT3A,BUDT3AL)=1
 .I Z=3 S (BUDT3B,BUDT3BRL)=1
 .I Z=4 S (BUDT4,BUDT4IPP)=1
 .I Z=5 S (BUDT4,BUDT4PMI)=1
 .I Z=6 S (BUDT4,BUDT4CHA)=1
 .I Z=7 S (BUDT5,BUDT5L1)=1
 .I Z=8 S (BUDT5,BUDT5L)=1
 .I Z=9 S (BUDT5,BUDT5L2)=1
 .I Z=10 S (BUDT6,BUDT6L)=1
 .I Y=1 S (BUDTZ,BUDTZL)=1
 G EN1
 Q
 ;
T3A ;EP - entry point for Table 3A only
 D EOJ
 S (BUDT3A,BUDT3AL)=1
 D GENI
 D T3AI
 G EN1
 ;
T4IPPL ;EP - called from option
 D EOJ
 S BUDT4IPP=1,BUDT4=1
 D GENI
 D T4IPPLI
 G EN1
 ;
 ;
T4IPPLI ;intro for table 3A
 W !!,"INCOME PERCENT OF POVERTY LEVEL (TABLE 4)"
 W !,"This report provides a list of all patients with an income percent "
 W !,"of poverty level (=<100%, 101-150%, 151-200% >200%, Unknown) during"
 W !,"the report period."
 W !
 Q
 ;
T4PMIS ;EP - called from option
 D EOJ
 S BUDT4PMI=1,BUDT4=1
 D GENI
 D T4IPMIS
 G EN1
 ;
 ;
T4IPMIS ;intro for table 4 PMIS
 W !!,"PRINCIPLE THIRD PARTY MEDICAL INSURANCE SOURCE (TABLE 4)"
 W !,"This report will provide a list of all patients and the type of medical"
 W !,"insurance the patient had as of the patient's last visit during the"
 W !,"report period."
 W !
 Q
T4CHAR ;EP - called from option
 D EOJ
 S BUDT4CHA=1,BUDT4=1
 D GENI
 D T4ICHAR
 G EN1
 ;
 ;
T4ICHAR ;intro for table 4 CHAR
 W !!,"CHARACTERISTICS OF SPECIAL POPULATIONS (TABLE 4)"
 W !,"This report provides a list of all patients who are migrant workers,"
 W !,"seasonal workers, homeless, school based health center patients, or"
 W !,"a veteran during the report period."
 W !
 Q
TUSVE ;EP
 D EOJ
 S (BUDT3B,BUDT3BEL)=1
 D GENI
 D T3BEI
 G EN1
 ;
TUSVR ;EP
 D EOJ
 S (BUDT3B,BUDT3BRL)=1
 D GENI
 D T3BRI
 G EN1
 ;
T3AI ;intro for table 3A
 W !!,"ALL PATIENTS BY AGE & GENDER (Tables 3A)"
 W !,"This report lists all patients who have at least one visit for the specified"
 W !,"time period that meets the visit definition criteria. Sorted by community, "
 W !,"age, and gender and lists all visits that fit the definition. Age is "
 W !,"calculated as of June 30th of the report year."
 Q
T3BRI ;intro for table 3B - RACE
 W !!,"ALL PATIENTS BY HISPANIC IDENTITY & RACE (Tables 3B)"
 W !,"This report lists all patients by Hispanic or Latino Identity/Race/Language"
 W !,"who have at least one visit for the specified time period that meets the "
 W !,"visit definition criteria. Sorted by race/Hispanic identity, age, gender, "
 W !,"and community and lists all visits that fit the definition. Age is calculated"
 W !,"as of June 30th of the report year."
 Q
T3BEI ;intro for table 3B - RACE
 W !!,"ALL PATIENTS BY ETHNICITY (TABLE 3B)"
 W !,"This report lists all patients who have at least on visit for the specified"
 W !,"time period that meet the above criteria.  Sorted by ethncicity, age, sex "
 W !,"and community."
 W !,"Lists all visits that fit the definition.  Age is calculated as of June 30th"
 W !,"of the report year."
 Q
TZ ;EP - entry point for Table 3A only
 D EOJ
 S (BUDTZ,BUDTZL)=1
 D GENI
 D TZAI
 G EN1
TZAI ;intro for table Z
 W !!,"Patients by Zip Code and Insurance Source"
 W !,"The Patient Zip Code by Insurance Source table reports the number of patients"
 W !,"by their zip code as entered in patient registration and their insurance source."
 Q
T5 ;EP
 D EOJ
 S BUDT5=1,BUDT5L=1
 D GENI
 D T5I
 G EN1
 ;
T5I ;
 W !,"ALL PATIENTS BY SERVICE CATEGORY (Table 5, columns b and c)"
 W !,"This report lists all patients and related visits as defined above, categorized"
 W !,"by UDS-defined service categories (primary provider code). Sorted by"
 W !,"community, age and gender.  See UDS User Manual for how UDS disciplines are"
 W !,"mapped to RPMS provider codes."
 Q
T5B ;EP
 D EOJ
 S BUDT5=1,BUDT5L2=1
 D GENI
 D T5BI
 G EN1
 ;
T5BI ;
 W !,"ALL PATIENTS FOR UNCATEGORIZED PROVIDER VISITS (Table 5, columns b and c)"
 W !,"This report lists all patients and related visits as defined above, that"
 W !,"are not counted toward Table 5 because the primary provider code could not "
 W !,"be categorized by UDS-defined service categories. Sorted by community, age"
 W !,"and gender.  See UDS User Manual for how UDS disciplines are mapped to RPMS"
 W !,"provider codes."
 Q
T6 ;EP - entry point for Table 6A only
 D EOJ
 S (BUDT6,BUDT6L)=1
 D GENI
 D T6I
 G EN1
 ;
T6I ;intro for table 6
 W !,"ALL PATIENTS BY DIAGNOSIS (Table 6A)"
 W !,"This report lists all patients and related visits as defined above, categorized"
 W !,"by specific UDS-defined diagnoses or tests/screenings.  Sorted by"
 W !,"community, age and gender."
 Q
T5A ;EP - called from option
 D EOJ
 S (BUDT5,BUDT5L1)=1
 D GENI
 D T5AI
 G EN1
T5AI ;
 W !,"PROVIDER/STAFF LIST (Table 5 column a)"
 W !,"This report provides a list of all Providers and other facility staff who are"
 W !,"documented in RPMS categorized by UDS-defined service categories.  Use this"
 W !,"list to manually calculate FTEs for each staff category to document in Table"
 W !,"5 column a (FTEs)."
 Q
TOL ;EP
 D EOJ
 S (BUDT6,BUDTOL)=1
 D GENI
 D TOLI
 G EN1
TOLI ;
 W !,"This report will list any visit that is incomplete but has a service",!,"relevant to lines 21 through 26 of Table 6A attached to it."
 W !,"Incomplete visits are not looked at when generating this report so ",!,"this list will provide you with a list of visits that potentially should be "
 W !,"completed or merged to a complete visit in order to be counted in Table 6A"
 Q
 ;
T5C ;EP
 D EOJ
 S BUDT5=1,BUDT5L3=1
 D GENI
 D T5CI
 G EN1
 ;
T5CI ;
 W !,"ALL PATIENTS W/MULTIPLE VISIS IN SVC CATS (TABLE 5 COL B&C)"
 W !,"This report provides a list of patients who had more than one visit on"
 W !,"a single day for any of the six BPHC Service Categories.  Per the BPHC "
 W !,"Uniform Data System Manual, 2007 Revision, page 6 each patient may have, "
 W !,"at a maximum:"
 W !,"-   One medical visit (Line 15)"
 W !,"-   One dental visit (Line 19)"
 W !,"-   One mental health visit (Line 20)"
 W !,"-   One substance abuse visit (Line 21)"
 W !,"-   One 'other health' visit for each type of 'other health' provider"
 W !,"      (e.g. nutritionist, podiatrist, speech therapist, acupuncturist, "
 W !,"      optometrist) (Line 22)"
 W !,"-   One enabling service visit for each type of enabling provider"
 W !,"      (e.g. case management or health education) (Line 29)"
 Q
QUARTER ;
 S BUDQTR=""
 S DIR("?",1)="Choose the time period to report on"
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
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2014",80)
 W !,"NOTE: Patient lists may be hundreds of pages long, depending on the size of your"
 W !,"patient population.  It is recommended that you run these reports at night and"
 W !,"print to an electronic file, not directly to a printer.",!
 K DIR S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR
 W !!,"The Patient List option documents the individual patients and visits"
 W !,"that are counted and summarized on each Table report (main menu"
 W !,"option REP).  The summary Table report is included at the beginning of each"
 W !,"List report."
 W !,"UDS searches your database to find all visits and related patients"
 W !,"during the time period selected. Based on the UDS definition, to be counted"
 W !,"as a patient, the patient must have had at least one visit meeting the "
 W !,"following criteria:"
 W !?4,"- must be to a location specified in your visit location setup"
 W !?4,"- must be to Service Category Ambulatory (A), Hospitalization (H), Day"
 W !?6,"Surgery (S), Observation (O), Telemedicine (M), Nursing home visit (R), "
 W !?6,"or In-Hospital (I) visit"
 W !?4,"- must NOT have an excluded clinic code (see User Manual for a list)"
 W !?4,"- must have a primary provider and a coded purpose of visit"
 W !?4,"- the patient must NOT have a gender of 'Unknown'"
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
