BUDCRP6I ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 14 Jan 2015  2:27 PM
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
PRENATT ;EP
 W !!,"UDS does not calculate the prenatal care indicators in Sections A and B."
 W !,"However, you can run a list of patients identified by UDS as pregnant to"
 W !,"determine which of them received prenatal care at your facility or were "
 W !,"referred elsewhere by your facility for prenatal and perinatal services "
 W !,"to assist you with completing Table 6B, Sections A and B.  The menu options"
 W !,"you would select to run the patient list are:  LST, LST2, A-D, PRGA."
 W !
 Q
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;
LISTS ;EP
 I $G(BUDPRGAL) S BUDGPG=0 D PRGAL^BUDCRP6W
 I $G(BUDIMM1L) S BUDGPG=0 D IMM1L
 I $G(BUDIMM2L) S BUDGPG=0 D IMM2L
 I $G(BUDPAP1L) S BUDGPG=0 D PAP1L^BUDCRP6P
 I $G(BUDPAP2L) S BUDGPG=0 D PAP2L^BUDCRP6P
 I $G(BUDWAC1L) S BUDGPG=0 D WAC1L^BUDCRP6F
 I $G(BUDWAC2L) S BUDGPG=0 D WAC2L^BUDCRP6F
 I $G(BUDAWS1L) S BUDGPG=0 D AWS1L^BUDCRP6G
 I $G(BUDAWS2L) S BUDGPG=0 D AWS2L^BUDCRP6G
 I $G(BUDTUA1L) S BUDGPG=0 D TUA1L^BUDCRP6T
 I $G(BUDTUA2L) S BUDGPG=0 D TUA2L^BUDCRP6T
 I $G(BUDAPT1L) S BUDGPG=0 D APT1L^BUDCRP6S
 I $G(BUDAPT2L) S BUDGPG=0 D APT2L^BUDCRP6S
 I $G(BUDCAD1L) S BUDGPG=0 D CAD1L^BUDCRP6J
 I $G(BUDCAD2L) S BUDGPG=0 D CAD2L^BUDCRP6J
 I $G(BUDIVD1L) S BUDGPG=0 D IVD1L^BUDCRP6K
 I $G(BUDIVD2L) S BUDGPG=0 D IVD2L^BUDCRP6K
 I $G(BUDCRC1L) S BUDGPG=0 D CRC1L^BUDCRP6L
 I $G(BUDCRC2L) S BUDGPG=0 D CRC2L^BUDCRP6L
 I $G(BUDHIV1L) S BUDGPG=0 D HIV1L^BUDCRP6A
 I $G(BUDHIV2L) S BUDGPG=0 D HIV2L^BUDCRP6A
 I $G(BUDDEP1L) S BUDGPG=0 D DEP1L^BUDCRP6N
 I $G(BUDDEP2L) S BUDGPG=0 D DEP2L^BUDCRP6N
 I $G(BUDDS1L) S BUDGPG=0 D DS1L^BUDCRP61
 I $G(BUDDS2L) S BUDGPG=0 D DS2L^BUDCRP61
 Q
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP - general introductions
 W !,"NOTE: Patient lists may be hundreds of pages long, depending on the size of your"
 W !,"patient population.  It is recommended that you run these reports at night and"
 W !,"print to an electronic file, not directly to a printer.",!
 K DIR S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR
 W !!,"This Patient List option documents the individual patients and visits"
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
 ;----------
IMM1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients Age 3 w/All Child Immunizations (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of three year old patients who had their first"
 W !,"visit prior to their 3rd birthday, had a medical visit during the report"
 W !,"period, and have all required childhood immunizations."
 W !
 Q
IMM1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IMM1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D IMM1L1
 I BUDROT="P",$Y>(IOSL-3) D IMM1H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS IMMUNIZED: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS IMMUNIZED: "_BUDTOT)
 Q
IMM1L1 ;
 I BUDROT="P" I $Y>(IOSL-7) D IMM1H Q:BUDQUIT
 S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM1",BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ...I BUDROT="P",$Y>(IOSL-3) D IMM1H Q:BUDQUIT
 ...I BUDROT="P" W $E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,$$AGE^AUPNPAT(DFN,BUDED),!
 ...S BUDTOT=BUDTOT+1
 ...S BUDALL=$P(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM,DFN),"|||",1)
 ...S X="" F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D IMM1H Q:BUDQUIT
 ....I BUDROT="P" W ?4,BUDV,!
 ....I BUDROT="D" S X=X_" "_BUDV
 ...I BUDROT="D" S Y=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDED)_U_X D S(Y)
 Q
IMM1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section C, With Childhood Immunizations")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List of all 3-year old patients who had their first visit prior to their")
 D S("3rd birthday, had a medical visit during the report period, and have all")
 D S("required childhood immunizations.")
 D S("Age is calculated as of December 31.")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^IMMUNIZATIONS RCVD, CONTRAIND, EVID OF DISEASE")
 Q
IMM1H ;
 I BUDROT="D" D IMM1HD Q
 G:'BUDGPG IMM1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IMM1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section C, With Childhood Immunizations",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all 3-year old patients who had their first visit prior to their"
 .W !,"3rd birthday, had a medical visit during the report period, and have all"
 .W !,"required childhood immunizations."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"IMMUNIZATIONS RCVD, CONTRAIND, EVID OF DISEASE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
IMM2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients Age 3 w/o All Child Immunizations (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"List of all 3-year old patients who had their first visit prior to their"
 W !,"3rd birthday, had a medical visit during the report period, and are in "
 W !,"need of the following immunizations to complete all required childhood "
 W !,"immunizations."
 W !,"Age is calculated as of December 31."
 W !
 Q
IMM2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IMM2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D IMM2L1
 I BUDROT="P",$Y>(IOSL-3) D IMM2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS NOT IMMUNIZED: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS NOT IMMUNIZED: "_BUDTOT)
 Q
IMM2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D IMM2H Q:BUDQUIT
 S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM2",BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ...I BUDROT="P",$Y>(IOSL-3) D IMM2H Q:BUDQUIT
 ...I BUDROT="P" W $E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,$$AGE^AUPNPAT(DFN,BUDED),!
 ...S BUDTOT=BUDTOT+1
 ...S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM,DFN)
 ...S X="" F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D IMM2H Q:BUDQUIT
 ....I BUDROT="P" W ?4,BUDV,!
 ....I BUDROT="D" S X=X_" "_BUDV
 ...I BUDROT="D" S Y=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDED)_U_X D S(Y)
 Q
IMM2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section C, Without Childhood Immunizations")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List of all 3-year old patients who had their first visit prior to their")
 D S("3rd birthday, had a medical visit during the report period, and are in need")
 D S("of the following immunizations to complete all required childhood ")
 D S("immunizations.")
 D S("Age is calculated as of December 31.")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^IMMUNIZATIONS NOT RECEIVED")
 Q
IMM2H ;
 I BUDROT="D" D IMM2HD Q
 G:'BUDGPG IMM2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IMM2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section C, Without Childhood Immunizations",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all 3-year old patients who had their first visit prior to their "
 .W !,"3rd birthday, had a medical visit during the report period, and are in need"
 .W !,"of the following immunizations to complete all required childhood "
 .W !,"immunizations."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"IMMUNIZATIONS NOT RECEIVED"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;----------
