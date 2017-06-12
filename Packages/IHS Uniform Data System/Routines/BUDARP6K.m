BUDARP6K ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2013 8:09 PM 14 Dec 2013 1:24 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
IVDLIST1 ;EP
 D EOJ
 S BUDIVD1L=1
 D IVD1
 G EN1^BUDARP6B
IVDLIST2 ;EP
 D EOJ
 S BUDIVD2L=1
 D IVD2
 G EN1^BUDARP6B
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
EOJ ;
 D EN^XBVK("BUD")
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
IVD1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All IVD patients 18+ w/Aspirin or Antithrombotic Therapy (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of patients 18 years of age and older who, "
 W !,"in the current or prior report year, were diagnosed with Ischemic Vascular"
 W !,"Disease (IVD) including acute myocardial infarction (AMI), or discharged"
 W !,"alive after cardiovascular surgery (coronary artery bypass graft (CABG)"
 W !,"or percutaneous transluminal coronary angioplasty (PTCA)) and were "
 W !,"prescribed or dispensed aspirin or another anti-thrombotic medication"
 W !,"or have documented evidence of use by patient of aspirin or another "
 W !,"anti-thrombotic medication during the report period, and had a medical"
 W !,"visit during the report period."
 W !,"Age is calculated as of December 31."
 W !
 Q
IVD1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IVD1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1")) W !!,"No patients to report.",! Q
 D IVD1L1
 I $Y>(IOSL-3) D IVD1H Q:BUDQUIT
 W !!,"TOTAL IVD PATIENTS WITH ASPIRIN OR ANTITHROMBOTIC THERAPY:  ",BUDTOT,!
 Q
IVD1L1 ;
 I $Y>(IOSL-7) D IVD1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D IVD1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"IVD1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 Q
IVD1H ;
 G:'BUDGPG IVD1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IVD1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section J, ",80),!,$$CTR("Ischemic Vascular Disease: Aspirin or Antithrombotic Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of patients 18 years of age and older who, "
 .W !,"in the current or prior report year, were diagnosed with Ischemic Vascular"
 .W !,"Disease (IVD) including acute myocardial infarction (AMI), or discharged"
 .W !,"alive after cardiovascular surgery (coronary artery bypass graft (CABG)"
 .W !,"or percutaneous transluminal coronary angioplasty (PTCA)) and were "
 .W !,"prescribed or dispensed aspirin or another anti-thrombotic medication"
 .W !,"or have documented evidence of use by patient of aspirin or another "
 .W !,"anti-thrombotic medication during the report period, and had a medical"
 .W !,"visit during the report period."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Date of DX",?16,"DX or Svc CD",?30,"Medication"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
IVD2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All IVD patients 18+ w/o Aspirin or Antithrombotic Therapy (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of patients 18 years of age and older who, "
 W !,"in the current or prior report year, were diagnosed with Ischemic Vascular"
 W !,"Disease (IVD) including acute myocardial infarction (AMI), or discharged"
 W !,"alive after cardiovascular surgery (coronary artery bypass graft (CABG)"
 W !,"or percutaneous transluminal coronary angioplasty (PTCA)) and were not"
 W !,"prescribed or dispensed aspirin or another anti-thrombotic medication"
 W !,"or have documented evidence of use by patient of aspirin or another "
 W !,"anti-thrombotic medication during the report period, and had a medical"
 W !,"visit during the report period."
 W !,"Age is calculated as of December 31."
 W !
 Q
IVD2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IVD2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2")) W !!,"No patients to report.",! Q
 D IVD2L1
 I $Y>(IOSL-3) D IVD2H Q:BUDQUIT
 W !!,"TOTAL IVD PATIENTS WITHOUT ASPIRIN OR ANTITHROMBOTIC THERAPY:  ",BUDTOT,!
 Q
IVD2L1 ;
 I $Y>(IOSL-7) D IVD2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D IVD2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"IVD2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 Q
IVD2H ;
 G:'BUDGPG IVD2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IVD2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section J, ",80),!,$$CTR("Ischemic Vascular Disease: Aspirin or Antithrombotic Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of patients 18 years of age and older who, "
 .W !,"in the current or prior report year, were diagnosed with Ischemic Vascular"
 .W !,"Disease (IVD) including acute myocardial infarction (AMI), or discharged"
 .W !,"alive after cardiovascular surgery (coronary artery bypass graft (CABG)"
 .W !,"or percutaneous transluminal coronary angioplasty (PTCA)) and were not"
 .W !,"prescribed or dispensed aspirin or another anti-thrombotic medication"
 .W !,"or have documented evidence of use by patient of aspirin or another "
 .W !,"anti-thrombotic medication during the report period, and had a medical"
 .W !,"visit during the report period."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Date of DX",?16,"DX or Svc CD",?30,"Medication"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
