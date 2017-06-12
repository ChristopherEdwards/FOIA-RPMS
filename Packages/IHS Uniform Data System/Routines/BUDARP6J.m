BUDARP6J ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2013 8:09 PM 14 Dec 2013 1:24 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
CADLIST1 ;EP
 D EOJ
 S BUDCAD1L=1
 D CAD1
 G EN1^BUDARP6B
CAD2LIST ;EP
 D EOJ
 S BUDCAD2L=1
 D CAD2
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
CAD1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All CAD patients 18+ w/Lipid Therapy (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years of age and older"
 W !,"with an active diagnosis of Coronary Artery Disease (CAD) including "
 W !,"myocardial infarction (MI),or have had cardiac surgery, and whose last LDL"
 W !,"was greater than or equal to 130 who were prescribed a lipid-lowering "
 W !,"therapy medication or have documented evidence of use by patient of lipid"
 W !,"lowering medication during the report period, does not have an allergy or"
 W !,"adverse reaction to lipid-lowering therapy medications, had at least two"
 W !,"medical visits ever, and had a medical visit during the report period. "
 W !,"Age is calculated as of December 31."
 W !
 Q
CAD1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D CAD1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1")) W !!,"No patients to report.",! Q
 D CAD1L1
 I $Y>(IOSL-3) D CAD1H Q:BUDQUIT
 W !!,"TOTAL CAD PATIENTS WITH LIPID-LOWERING THERAPY:  ",BUDTOT,!
 Q
CAD1L1 ;
 I $Y>(IOSL-7) D CAD1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D CAD1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 Q
CAD1H ;
 G:'BUDGPG CAD1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
CAD1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section I, ",80)
 W !,$$CTR("Coronary Artery Disease: Lipid Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years of age and older"
 .W !,"with an active diagnosis of Coronary Artery Disease (CAD) including "
 .W !,"myocardial infarction (MI),or have had cardiac surgery, and whose last LDL"
 .W !,"was greater than or equal to 130 who were prescribed a lipid-lowering "
 .W !,"therapy medication or have documented evidence of use by patient of lipid"
 .W !,"lowering medication during the report period, does not have an allergy or"
 .W !,"adverse reaction to lipid-lowering therapy medications, had at least two"
 .W !,"medical visits ever, and had a medical visit during the report period. "
 .W !,"Age is calculated as of December 31."
 .W !
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Date of DX",?16,"DX or Svc CD",?30,"Medication"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
CAD2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All CAD patients 18+ w/o Lipid Therapy (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years of age and older"
 W !,"with an active diagnosis of Coronary Artery Disease (CAD) including "
 W !,"myocardial infarction (MI) or have had cardiac surgery and whose last "
 W !,"LDL was greater than or equal to 130 or last recorded LDL is greater than"
 W !,"1yr from last visit in the report year who were not prescribed a "
 W !,"lipid-lowering therapy medication or has no documented evidence of use by"
 W !,"patient of lipid lowering medication during the report period or has an "
 W !,"allergy or adverse reaction to lipid-lowering therapy medications, had at"
 W !,"least two medical visits ever, and had a medical visit during the report"
 W !,"period."
 W !,"Age is calculated as of December 31."
 W !
 Q
CAD2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0,BUDX2ALG=0
 D CAD2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2")),'$D(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2")) W !!,"No patients to report.",! Q
 D CAD2L1
 I $Y>(IOSL-3) D CAD2H Q:BUDQUIT
 W !!,"TOTAL CAD PATIENTS WITHOUT LIPID-LOWERING THERAPY:  ",BUDTOT,!
 S BUDP=0,BUDQUIT=0,BUDTOT=0,BUDX2ALG=1
 D CAD2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2")) W !!,"TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY: 0",! Q
 D CAD2ALG
 I $Y>(IOSL-3) D CAD2H Q:BUDQUIT
 W !!,"TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY:  ",BUDTOT,!
 Q
CAD2ALG ;
 I $Y>(IOSL-7) D CAD2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D CAD2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 Q
CAD2L1 ;
 I $Y>(IOSL-7) D CAD2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D CAD2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 Q
CAD2H ;
 G:'BUDGPG CAD2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
CAD2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section I, ",80)
 W !,$$CTR("Coronary Artery Disease: Lipid Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 18 years of age and older"
 W !,"with an active diagnosis of Coronary Artery Disease (CAD) including "
 W !,"myocardial infarction (MI) or have had cardiac surgery and whose last "
 W !,"LDL was greater than or equal to 130 or last recorded LDL is greater than"
 W !,"1yr from last visit in the report year who were not prescribed a "
 W !,"lipid-lowering therapy medication or has no documented evidence of use by"
 W !,"patient of lipid lowering medication during the report period or has an "
 W !,"allergy or adverse reaction to lipid-lowering therapy medications, had at"
 W !,"least two medical visits ever, and had a medical visit during the report"
 W !,"period."
 W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Date of DX",?16,"DX or Svc CD",?30,"Medication",?72,"LDL"
 W !,$TR($J("",80)," ","-"),!
 I 'BUDX2ALG W "CAD Patients with LDL >=130 w/o Lipid Lowering Medication",!
 I BUDX2ALG W "CAD Patients w/LDL =>130 and an ALG or ADV Reaction to Lipid Lowering Medication"
 S BUDP=1
 Q
 ;
