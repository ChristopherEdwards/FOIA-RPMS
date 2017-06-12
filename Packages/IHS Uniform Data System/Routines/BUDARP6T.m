BUDARP6T ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
TUALIST1 ;EP
 D EOJ
 S BUDTUA1L=1
 D TUA1
 G EN1^BUDARP6B
TUALIST2 ;EP
 D EOJ
 S BUDTUA2L=1
 D TUA2
 G EN1^BUDARP6B
TCILIST1 ;EP
 D EOJ
 S BUDTCI1L=1
 D TCI1
 G EN1^BUDARP6B
TCILIST2 ;EP
 D EOJ
 S BUDTCI2L=1
 D TCI2
 G EN1^BUDARP6B
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP
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
LOC() ;EP 
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
TUA1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 18 and older w/tobacco use assessment (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years and older who were"
 W !,"queried about any and all forms tobacco use one or more times during the "
 W !,"report period or the prior year, had at least one medical during the report"
 W !,"period, and with at least two medical visits ever, and were ever seen after"
 W !,"their 18th birthday."
 W !
 Q
TUA1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TUA1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1")) W !!,"No patients to report.",! Q
 D TUA1L1
 I $Y>(IOSL-3) D TUA1H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITH TOBACCO USE ASSESSMENT AND COUNSELING: ",BUDTOT,!
 Q
TUA1L1 ;
 I $Y>(IOSL-7) D TUA1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D TUA1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDALL="" W ?5,"Never" Q
 ....W ?5,$P(BUDALL,U,2),?30,$P(BUDALL,U,1)
 Q
TUA1H ;
 G:'BUDGPG TUA1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TUA1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G1, Tobacco Use Assessment",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years and older who were "
 .W !,"queried about any and all forms tobacco use one or more times during the"
 .W !,"report period or the prior year, had at least one medical visit during the"
 .W !,"report period, and with at least two medical visits ever, and were ever"
 .W !,"seen after their 18th birthday. "
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"ASSESSMENT DATE",?30,"DX OR SVC CD"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
TUA2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 18 and older w/o tobacco use assessment (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years and older who were"
 W !,"queried not about any and all forms tobacco use one or more times during "
 W !,"the report period or the prior year, had at least one medical during the"
 W !,"report period, and with at least two medical visits ever, and were ever"
 W !,"seen after their 18th birthday."
 W !
 Q
TUA2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TUA2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2")) W !!,"No patients to report.",! Q
 D TUA2L1
 I $Y>(IOSL-3) D TUA2H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITHOUT TOBACCO USE ASSESSMENT AND COUNSELING: ",BUDTOT,!
 Q
TUA2L1 ;
 I $Y>(IOSL-7) D TUA2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D TUA2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDALL="" W ?5,"Never" Q
 ....W ?5,$E($P(BUDALL,U,2),1,24),?30,$P(BUDALL,U,1)
 Q
TUA2H ;
 G:'BUDGPG TUA2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TUA2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G1, Tobacco Use Assessment",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years and older who were"
 .W !,"not queried about any and all forms tobacco use one or more times during"
 .W !,"the report period or the prior year, had at least one medical visit "
 .W !,"during the report period, and with at least two medical visits ever, and"
 .W !,"were ever seen after their 18th birthday. "
 .W !,"Age is calculated as of December 31st."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"ASSESSMENT DATE",?30,"DX OR SVC CD"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
TCI1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 18 and older smokers or tobacco users w/Cessation"
 W !,"Intervention (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years or older who are "
 W !,"documented smokers or tobacco users and who received documented advice "
 W !,"to quit smoking or tobacco use during the report, had at least two medical"
 W !,"visits ever, had a medical visit during the report period, and were ever "
 W !,"seen after their 18th birthday."
 W !
 Q
TCI1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TCI1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1")) W !!,"No patients to report.",! Q
 D TCI1L1
 I $Y>(IOSL-3) D TCI1H Q:BUDQUIT
 W !!,"TOTAL TOBACCO USER PATIENTS WITH CESSATION INTERVENTION:",BUDTOT,!
 Q
TCI1L1 ;
 I $Y>(IOSL-7) D TCI1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D TCI1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"TCI1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$E($P(BUDALL,U,1),1,24),?40,$P(BUDALL,U,2)
 Q
TCI1H ;
 G:'BUDGPG TCI1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TCI1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G2, Tobacco Cessation Intervention",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years or older who are"
 .W !,"documented smokers or tobacco users and who received documented advice "
 .W !,"to quit smoking or tobacco use during the report period, had at least"
 .W !,"two medical visits ever, had a medical visit during the report period,"
 .W !,"and were ever seen after their 18th birthday."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"TOBACCO STATUS",?40,"CESSATION INTERVENTION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
TCI2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 18 and older smokers or tobacco users w/o cessation ",!
 W !,"Intervention (Table 6B)"
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years or older who are "
 W !,"documented smokers or tobacco users and who have not received documented "
 W !,"advice to quit smoking or tobacco use during the report, had at least two "
 W !,"medical visits ever, had a medical visit during the report period, and "
 W !,"were ever seen after their 18th birthday."
 W !
 Q
TCI2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TCI2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2")) W !!,"No patients to report.",! Q
 D TCI2L1
 I $Y>(IOSL-3) D TCI2H Q:BUDQUIT
 W !!,"TOTAL TOBACCO USER PATIENTS WITHOUT CESSATION INTERVENTION: ",BUDTOT,!
 Q
TCI2L1 ;
 I $Y>(IOSL-7) D TCI2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D TCI2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"TCI2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$E($P(BUDALL,U,1),1,24),?40,$P(BUDALL,U,2)
 Q
TCI2H ;
 G:'BUDGPG TCI2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TCI2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G2, Tobacco Cessation Intervention",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years or older who are"
 .W !,"documented smokers or tobacco users and who have not received documented"
 .W !,"advice to quit smoking or tobacco use during the report period, had at "
 .W !,"least two medical visits ever, had a medical visit during the report "
 .W !,"period, and were ever seen after their 18th birthday. "
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"TOBACCO STATUS",?40,"CESSATION INTERVENTION",?51
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
