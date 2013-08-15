BUD2RP6P ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;general introductions
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
 Q
 ;----------
PAP1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2012",80)
 W !!,"All Female Patients w/Pap Test (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all female patients ages 24-64 who have not"
 W !,"had a hysterectomy, had a medical visit during the report period, were"
 W !,"first seen in the clinic by their 65th birthday, and had a Pap test in the"
 W !,"past three years."
 W !
 Q
PAP1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D PAP1H Q:BUDQUIT
 I '$D(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1")) W !!,"No patients to report." Q
 D PAP1L1
 I $Y>(IOSL-3) D PAP1H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITH PAP TEST: ",BUDTOT,!
 Q
PAP1L1 ;
 I $Y>(IOSL-7) D PAP1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D PAP1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?68,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?19,$P(BUDALL,U,2),?35,$P(BUDALL,U,3),?45,$P(BUDALL,U,4),?53,$E($P(BUDALL,U,5),1,11),?65,$E($P(BUDALL,U,6),1,15)
 Q
PAP1H ;
 G:'BUDGPG PAP1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
PAP1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section D, With Pap Test",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all female patients age 24-64 who did not have a hysterectomy, had"
 .W !,"a medical visit during the report period, were first seen in the clinic"
 .W !,"by their 65th birthday, and had a Pap test in the past three years."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?68,"AGE"
 W !?5,"VISIT DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
PAP2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2012",80)
 W !!,"All Female Patients w/o Pap Test (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all female patients ages 24-64 who have not"
 W !,"had a hysterectomy, had a medical visit during the report period, were"
 W !,"first seen in the clinic by their 65th birthday, and did not have a Pap test"
 W !,"in the past three years."
 W !
 Q
PAP2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D PAP2H Q:BUDQUIT
 I '$D(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2")) W !!,"No patients to report." Q
 D PAP2L1
 I $Y>(IOSL-3) D PAP2H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITHOUT PAP TEST: ",BUDTOT,!
 Q
PAP2L1 ;
 I $Y>(IOSL-7) D PAP2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D PAP2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?68,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUD2RP6B",BUDJ,BUDH,"PAP2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?19,$P(BUDALL,U,2),?35,$P(BUDALL,U,3),?45,$P(BUDALL,U,4),?53,$E($P(BUDALL,U,5),1,11),?65,$E($P(BUDALL,U,6),1,15)
 Q
PAP2H ;
 G:'BUDGPG PAP2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
PAP2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section D, Without Pap Test",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all female patients age 24-64 who did not have a hysterectomy, had"
 .W !,"a medical visit during the report period, were first seen in the clinic"
 .W !,"by their 65th birthday, and did not have a Pap test in the past three years."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?68,"AGE"
 W !?5,"VISIT DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
