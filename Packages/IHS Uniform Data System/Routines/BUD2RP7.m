BUD2RP7 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 12 Dec 2012 6:51 AM 30 Dec 2012 8:19 PM 27 Aug 2012 12:41 PM ; 
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
T7 ;
 D EOJ
EN ;
 D GENI
 D T7I
 D PAUSE
 D PRENATT
 D PAUSE
 ;
EN1 ;
PNC ;
 S BUDPREN=""
 S DIR(0)="Y",DIR("A")="Does your facility provide prenatal care",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 S BUDPREN=Y
 ;
EN2 ;
 S BUDSITE=""
 S DIC="^BUDRSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 G PNC
 S BUDSITE=+Y
 I '$O(^BUDRSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 S BUDTAXT="7" D TAXCHK^BUD2XTCH
 ;S BUDYEAR=3080000,BUDBD=3080101,BUDED=3081231
 ;S BUDCAD=3080630
 ;S BUDYEAR=3030000,BUDBD=3030101,BUDED=3031231
 ;S BUDCAD=3030630
 S BUDYEAR=""
 D YEAR
 I BUDYEAR="" D EOJ Q
 W !!,"Your report will be run for the time period: ",$$FMTE^XLFDT(BUDBD)," to ",$$FMTE^XLFDT(BUDED)
 ;get indian or not
 S BUDBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Classification not entered." D EOJ Q
 S BUDBEN=Y
ZIS ;call to XBDBQUE
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC
 U IO
 D PRINT
 D ^%ZISC
 D EOJ
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BUD*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUD2RP7",ZTDTH="",ZTDESC="UDS 12 REPORT TABLE 7" D ^%ZTLOAD D EOJ Q
 Q
EOJ ;
 D EN^XBVK("BUD")
 Q
PRGHLIST ;EP
 D EOJ
 S BUDPRGHL=1
 D PRGH^BUD2RP7I
 G EN1
 ;
PRGRLIST ;EP
 D EOJ
 S BUDPRGRL=1
 D PRGR^BUD2RP7I
 G EN1
 ;
PRGELIST ;EP
 D EOJ
 S BUDPRGEL=1
 D PRGE^BUD2RP7I
 G EN1
 ;
HTRLIST ;EP
 D EOJ
 S BUDHTRL=1
 D HTR^BUD2RP7J
 G EN1
 ;
HTCRLIST ;EP
 D EOJ
 S BUDHTCRL=1
 D HTCR^BUD2RP7J
 G EN1
 ;
HTURLIST ;EP
 D EOJ
 S BUDHTURL=1
 D HTUR^BUD2RP7J
 G EN1
 ;
HTELIST ;EP
 D EOJ
 S BUDHTEL=1
 D HTE^BUD2RP7K
 G EN1
 ;
HTCELIST ;EP
 D EOJ
 S BUDHTCEL=1
 D HTCE^BUD2RP7K
 G EN1
 ;
HTUELIST ;EP
 D EOJ
 S BUDHTUEL=1
 D HTUE^BUD2RP7K
 G EN1
 ;
 ;
MHT ;EP
 D EOJ
 D GENI^BUD2RP7I
 S (BUDHTRL,BUDHTCRL,BUDHTURL,BUDHTEL,BUDHTCEL,BUDHTUEL)=0
 W !!,"UDS Table 7 Hypertension Patient List Selection"
 W !!?5,"1   All HTN Patients by Race and Hispanic or Latino Identity"
 ;W !?5,"Z   All HTN Patients by Ethnicity"
 W !?5,"2   All HTN Pts w/Controlled BP by Race and Hispanic or Latino Identity"
 W !?5,"3   All HTN Pts w/Uncontrolled BP by Race and Hispanic or Latino Identity"
 ;W !?5,"Z   All HTN Patients w/Controlled BP by Ethnicity"
 ;W !?5,"Z   All HTN Patients w/Uncontrolled BP by Ethnicity"
 W !?5,"4   ALL Lists for HTN Patients"
 S DIR(0)="L^1:4",DIR("A")="Include which Tables",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I Y[4 S (BUDHTRL,BUDHTCRL,BUDHTURL)=1
 I Y[1 S BUDHTRL=1
 I Y[2 S BUDHTCRL=1
 I Y[3 S BUDHTURL=1
 G EN1
LIST ;
DMRLIST ;EP
 D EOJ
 S BUDDMRL=1
 D DMR^BUD2RP7L
 G EN1
 ;
DMR1LIST ;EP
 D EOJ
 S BUDDMR1L=1
 D DMR1^BUD2RP7L
 G EN1
 ;
DMR2LIST ;EP
 D EOJ
 S BUDDMR2L=1
 D DMR2^BUD2RP7L
 G EN1
 ;
DMR4LIST ;EP
 D EOJ
 S BUDDMR4L=1
 D DMR4^BUD2RP7T
 G EN1
 ;
DMR3LIST ;EP
 D EOJ
 S BUDDMR3L=1
 D DMR3^BUD2RP7T
 G EN1
 ;
DMELIST ;EP
 D EOJ
 S BUDDMEL=1
 D DME^BUD2RP7M
 G EN1
 ;
DME1LIST ;EP
 D EOJ
 S BUDDME1L=1
 D DME1^BUD2RP7M
 G EN1
 ;
DME2LIST ;EP
 D EOJ
 S BUDDME2L=1
 D DME2^BUD2RP7M
 G EN1
 ;
DME3LIST ;EP
 D EOJ
 S BUDDME3L=1
 D DME3^BUD2RP7S
 G EN1
 ;
MDM ;EP
 D EOJ
 D GENI^BUD2RP7I
 S (BUDHTRL,BUDDMR1L,BUDHTURL,BUDHTEL,BUDHTCEL,BUDHTUEL)=0
 W !!,"UDS Table 7 Diabetes Patient List Selection"
 W !!?5,"1   All Patients w/DM by Race and Hispanic or Latino Identity"
 ;W !?5,"2   All Patients w/DM by Ethnicity"
 W !?5,"2   All Patients w/DM and A1c <7 by Race and Hispanic or Latino Identity"
 W !?5,"3   All Pts w/DM and A1c >=7 & <8 by Race and Hispanic or Latino Identity"
 W !?5,"4   All Patients w/A1c >=8 & <=9 by Race and Hispanic or Latino Identity"
 W !?5,"5   All Patients w/DM and A1c >9 or No Test by Race and Hispanic or Latino Identity"
 ;W !?5,"6   All Patients w/DM and A1c <7 by Ethnicity"
 ;W !?5,"7   All Patients w/DM and A1c >=7 and <=9 by Ethnicity"
 ;W !?5,"8   All Patients w/DM and A1c >9 by Ethnicity"
 W !?5,"6   ALL Lists for DM Patients"
 S DIR(0)="L^1:6",DIR("A")="Include which Tables",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I Y[6 S (BUDDMRL,BUDDMR1L,BUDDMR2L,BUDDMR3L,BUDDMR4L)=1
 I Y[1 S BUDDMRL=1
 I Y[2 S BUDDMR1L=1
 I Y[3 S BUDDMR2L=1
 I Y[4 S BUDDMR3L=1
 I Y[5 S BUDDMR4L=1
 G EN1
MPRG ;EP - called from option
 D EOJ
 D GENI^BUD2RP7I
 S (BUDPRGHL,BUDPRGRL,BUDPRGEL)=0
 W !!,"UDS Table 7 Pregnant Patient List Selection"
 W !!?5,"1   All Pregnant Patients w/HIV"
 W !?5,"2   All Pregnant Patients by Race"
 ;W !?5,"3   All Pregnant Patients by Ethnicity"
 W !?5,"3   ALL Lists"
 S DIR(0)="L^1:3",DIR("A")="Include which Tables",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I Y[3 S (BUDPRGHL,BUDPRGRL)=1
 I Y[1 S BUDPRGHL=1
 I Y[2 S BUDPRGRL=1
 ;I Y[3 S BUDPRGEL=1
 G EN1
 ;
PROC ;EP - called from taskman
 S BUDJ=$J,BUDH=$H
 S ^XTMP("BUD2RP7B",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BUD TABLE 7 LISTS"
 ;NOW LOOP THROUGH PATIENT FILE  for imms and paps
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .K ^TMP($J)
 .Q:'$D(^AUPNPAT(DFN,0))
 .Q:'$D(^DPT(DFN,0))
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .Q:$P(^DPT(DFN,0),U,1)["DEMO,PATIENT"
 .Q:$P(^DPT(DFN,0),U,1)["PATIENT,CRS"
 .Q:$P(^DPT(DFN,0),U,1)["PATIENT,UDS"
 .Q:$$DEMO^BUD2DU(DFN,"E")
 .;DO NOT COUNT BASED ON CLASSIFICATION IN V6.0
 .I BUDBEN=1,$$BEN^AUPNPAT(DFN,"C")'="01" Q  ;must be Indian/Alaskan Native
 .I BUDBEN=2,$$BEN^AUPNPAT(DFN,"C")="01" Q  ;must not be I/A
 .S BUDSEX=$P(^DPT(DFN,0),U,2)
 .S BUDCOM=$$COMMRES^AUPNPAT(DFN,"E") I BUDCOM="" S BUDCOM="UNKNOWN"
 .S BUDAGE=$$AGE^AUPNPAT(DFN,BUDED)  ;age at end of time period
 .S BUDAGEP=$$AGE^AUPNPAT(DFN,BUDCAD)  ;age on june 30 for pregnancy 
 .D GETV^BUD2RPTD  ;get visits that meet criteria
 .I BUDT35V=0 Q  ;user doesn't have any countable visits and is not considered a user
 .D PRGHLST^BUD2RP7A
 .D PRGRLST^BUD2RP7A
 .;I $G(BUDPRGEL) D PRGELST^BUD2RP7A
 .D HTN^BUD2RP7B
 .D DM^BUD2RP7C
 Q
 ;
PRINT ;EP - called from taskman
 D PRINT^BUD2RP71
 Q
 ;
T7H ;
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!,$$REPEAT^XLFSTR("_",79),!
 Q
LINE ;
 W $$REPEAT^XLFSTR("_",79),?79,"|",!
 Q
LINE1 ;
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?59,"|",$$REPEAT^XLFSTR("_",9),?69,"|",$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE2 ;
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",39),?69,"|_________",?79,"|",!
 Q
 ;
LINE3 ;
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",49),?79,"|",!
 Q
T7I ;EP
 W !!,"TABLE 7:  HEALTH OUTCOMES AND DISPARITIES"
 W !,"This report will produce UDS Table 7, health outcomes indicators by race"
 W !,"and Hispanic/Latino identity for deliveries and birth weights, controlled"
 W !,"hypertension, and controlled diabetes Glycemic control.  Patients must meet "
 W !,"additional criteria as specified for each indicator."
 W !
 Q
GENI ;general introductions
 W:$D(IOF) @(IOF)
 W !!,$$CTR($$LOC,80),!,$$CTR("UDS 2012",80),!
 W !,"UDS searches your database to find all patients reported for the quality"
 W !,"of care indicators during the time period January 1 - December 31, 2012."
 W !,"Based on the UDS defintion, to be considered a patient, the patient must"
 W !,"have had at least one visit meeting the following criteria:"
 W !?4,"- must be to a location specified in your visit location setup"
 W !?4,"- must be to Service Category Ambulatory (A), Hospitalization (H), Day"
 W !?6,"Surgery (S), Observation (O), Telemedicine (M), Nursing home visit (R), "
 W !?6,"or In-Hospital (I) visit"
 W !?4,"- must NOT have an excluded clinic code (see User Manual for a list)"
 W !?4,"- must have a primary provider and a coded purpose of visit"
 W !
 Q
 ;
PRENATT ;EP
 W !!,"UDS does not calculate the deliveries and birth weight indicators"
 W !,"in Section A.  However, you can run a list of patients identified "
 W !,"by UDS as pregnant to determine which of them received prenatal care at"
 W !,"your facility to assist you with completing Table 7, Section A."
 W !,"The menu options you would select to run the patient list are:  LST, LST3,"
 W !,"PRG, PRGR (list by race and Hispanic or Latino identity)."
 W !
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
PAUSE ;EP
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "********"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
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