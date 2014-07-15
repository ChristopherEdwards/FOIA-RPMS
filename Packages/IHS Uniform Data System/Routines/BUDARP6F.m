BUDARP6F ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2013 8:09 PM 14 Dec 2013 1:24 PM ; 
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
WACLIST1 ;EP
 D EOJ
 S BUDWAC1L=1
 D WAC1
 G EN1^BUDARP6B
WACLIST2 ;EP
 D EOJ
 S BUDWAC2L=1
 D WAC2
 G EN1^BUDARP6B
AWSLIST1 ;EP
 D EOJ
 S BUDAWS1L=1
 D AWS1
 G EN1^BUDARP6B
AWSLIST2 ;EP
 D EOJ
 S BUDAWS2L=1
 D AWS2
 G EN1^BUDARP6B
PAUSE ;EP
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
WAC1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 2-17 w/Weight Assessment and Counseling (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients ages 2-17 who have "
 W !,"documented BMI percentile, counseling for nutrition, counseling for"
 W !,"physical activity, had a medical visit during the report period, and"
 W !,"were first ever seen in the clinic by their 17th birthday."
 W !
 Q
WAC1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D WAC1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1")) W !!,"No patients to report.",! Q
 D WAC1L1
 I $Y>(IOSL-3) D WAC1H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITH WEIGHT ASSESSMENT AND COUNSELING: ",BUDTOT,!
 Q
WAC1L1 ;
 I $Y>(IOSL-7) D WAC1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D WAC1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"WAC1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$S($P(BUDALL,U,1):$J($P(BUDALL,U,1),6,2),1:$P(BUDALL,U,1)),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 Q
WAC1H ;
 G:'BUDGPG WAC1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
WAC1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section E",80)
 W !,$$CTR("With Weight Assessment and Counseling",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients ages 2-17 who have documented"
 .W !,"BMI percentile, counseling for nutrition, counseling for physical activity,"
 .W !,"had a medical visit during the report period, and were first ever seen in the"
 .W !,"clnic by their 17th birthday."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"BMI PERCENTILE",?25,"NUTRITION COUNSELING",?51,"PHYSICAL ACTIVITY COUNSELING"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
WAC2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 2-17 w/Weight Assessment and Counseling (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients ages 2-17 who do not have"
 W !,"documented BMI percentile, or counseling for nutrition, or counseling for"
 W !,"physical activity, had a medical visit during the report period, and"
 W !,"were first ever seen in the clinic by their 17th birthday."
 W !
 Q
WAC2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D WAC2H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2")) W !!,"No patients to report.",! Q
 D WAC2L1
 I $Y>(IOSL-3) D WAC2H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITHOUT WEIGHT ASSESSMENT AND COUNSELING: ",BUDTOT,!
 Q
WAC2L1 ;
 I $Y>(IOSL-7) D WAC2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D WAC2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"WAC2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$S($P(BUDALL,U,1):$J($P(BUDALL,U,1),6,2),1:$P(BUDALL,U,1)),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 Q
WAC2H ;
 G:'BUDGPG WAC2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
WAC2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section E",80)
 W !,$$CTR("Without Weight Assessment and Counseling",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients ages 2-17 who do not have documented"
 .W !,"BMI percentile, or counseling for nutrition, or counseling for physical activity,"
 .W !,"had a medical visit during the report period, and were first ever seen in the"
 .W !,"clnic by their 17th birthday."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"BMI PERCENTILE",?25,"NUTRITION COUNSELING",?51,"PHYSICAL ACTIVITY COUNSELING"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
AWS1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2013",80)
 W !!,"All Patients 18 and older w/BMI who were over/underweight w/followup"
 W !,"plan (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 and older who have a"
 W !,"documented BMI percentile on the last visit during the report period"
 W !,"or on any visit within the last 6 months of the last visit during the"
 W !,"report period, and are overweight or underweight, and patient had a"
 W !,"follow-up plan documented, had a medical visit during the report period,"
 W !,"and were ever seen after their 18th birthday."
 W !
 Q
AWS1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D AWS1H Q:BUDQUIT
 I '$D(^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1")) W !!,"No patients to report.",! Q
 D AWS1L1
 I $Y>(IOSL-3) D AWS1H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITH ADULT WEIGHT SCREEN AND FOLLOW-UP PLAN:",BUDTOT,!
 Q
AWS1L1 ;
 I $Y>(IOSL-7) D AWS1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D AWS1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDARP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$J($P(BUDALL,U,1),6,2),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 Q
AWS1H ;
 G:'BUDGPG AWS1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
AWS1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section F",80)
 W !,$$CTR("Adult Weight Screening and Follow-up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 and older who have"
 .W !,"documented BMI percentile on the last visit during the report period"
 .W !,"or on any visit within the last 6 months of the last visit during the"
 .W !,"report period, and are overweight or underweight, and the patient"
 .W !,"had a follow-up plan documented, had a medical visit during the report"
 .W !,"period, and were ever seen after their 18th birthday."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"BMI PERCENTILE",?25,"WEIGHT STATUS",?51,"FOLLOW-UP PLAN"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
AWS2 ;EP
 D AWS2^BUDARP6G
 Q
