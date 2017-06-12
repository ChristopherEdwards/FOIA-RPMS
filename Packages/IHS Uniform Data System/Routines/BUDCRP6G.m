BUDCRP6G ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;----------
AWS2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 18 and older w/o BMI or does not have a follow-up plan (Table 6B)",!
 D GENI^BUDCRP6F
 D PAUSE^BUDCRP6F
 W !!,"This report provides a list of all patients 18 years and older who do"
 W !,"not have documente BMI percentile on the last visit during the report"
 W !,"period or on any visit within the last 6 months of the last visit during"
 W !,"the report period, or who are not overweight or underweight, or does not"
 W !,"have a follow-up plan documented, had a medical visit during the report"
 W !,"period, and were ever seen after their 18th birthday."
 W !
 Q
AWS2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D AWS2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D AWS2L1
 I BUDROT="P",$Y>(IOSL-3) D AWS2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS WITHOUT ADULT WEIGHT SCREEN OR FOLLOW-UP PLAN: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITHOUT ADULT WEIGHT SCREEN OR FOLLOW-UP PLAN: "_BUDTOT)
 Q
AWS2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D AWS2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D AWS2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$S($P(BUDALL,U,1)]"":$J($P(BUDALL,U,1),6,2),1:""),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_BUDAGE D
 .....S X=X_U_$J($P(BUDALL,U,1),6,2)_U_$P(BUDALL,U,2)_U_$P(BUDALL,U,3) D S(X)
 Q
AWS2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section F")
 D S("Without Adult Weight Screening and Follow-up")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 18 years and older who do not")
 D S("have documented BMI percentile on the last visit during the report")
 D S("period or on any visit within the last 6 months of the last visit during")
 D S("the report period, or who are not overweight or underweight, or does not")
 D S("have a follow-up plan documented, had a medical visit during the report")
 D S("period, and were ever seen after their 18th birthday.")
 D S("Age is calulated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^BMI PERCENTILE^WEIGHT STATUS^FOLLOW-UP PLAN")
 Q
AWS2H ;
 I BUDROT="D" D AWS2HD Q
 G:'BUDGPG AWS2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
AWS2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section F",80)
 W !,$$CTR("Without Adult Weight Screen and Follow-up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years and older who do not"
 .W !,"have documented BMI percentile on the last visit during the report"
 .W !,"period or on any visit within the last 6 months of the last visit during"
 .W !,"the report period, or who are not overweight or underweight, or does not"
 .W !,"have a follow-up plan documented, had a medical visit during the report"
 .W !,"period, and were ever seen after their 18th birthday."
 .W !,"Age is calulated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"BMI PERCENTILE",?25,"WEIGHT STATUS",?51,"FOLLOW-UP PLAN"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
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
AWS1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
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
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D AWS1L1
 I BUDROT="P",$Y>(IOSL-3) D AWS1H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS WITH ADULT WEIGHT SCREEN AND FOLLOW-UP PLAN:",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH ADULT WEIGHT SCREEN AND FOLLOW-UP PLAN: "_BUDTOT)
 Q
AWS1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D AWS1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D AWS1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"AWS1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$J($P(BUDALL,U,1),6,2),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_BUDAGE D
 .....S X=X_U_$J($P(BUDALL,U,1),6,2)_U_$P(BUDALL,U,2)_U_$P(BUDALL,U,3) D S(X)
 Q
AWS1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section F")
 D S("Adult Weight Screening and Follow-up")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 18 and older who have")
 D S("documented BMI percentile on the last visit during the report period")
 D S("or on any visit within the last 6 months of the last visit during the")
 D S("report period, and are overweight or underweight, and the patient")
 D S("had a follow-up plan documented, had a medical visit during the report")
 D S("period, and were ever seen after their 18th birthday.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^BMI PERCENTILE^WEIGHT STATUS^FOLLOW-UP PLAN")
 Q
AWS1H ;
 I BUDROT="D" D AWS1HD Q
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
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
