BUDBRP6G ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
 ;----------
AWS2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2014",80)
 W !!,"All Patients 18 and older w/o BMI or does not have a follow-up plan (Table 6B)",!
 D GENI^BUDBRP6F
 D PAUSE^BUDBRP6F
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
 I '$D(^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2")) W !!,"No patients to report.",! Q
 D AWS2L1
 I $Y>(IOSL-3) D AWS2H Q:BUDQUIT
 W !!,"TOTAL PATIENTS WITHOUT ADULT WEIGHT SCREEN OR FOLLOW-UP PLAN: ",BUDTOT,!
 Q
AWS2L1 ;
 I $Y>(IOSL-7) D AWS2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D AWS2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDBRP6B",BUDJ,BUDH,"AWS2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$S($P(BUDALL,U,1)]"":$J($P(BUDALL,U,1),6,2),1:""),?25,$P(BUDALL,U,2),?51,$P(BUDALL,U,3)
 Q
AWS2H ;
 G:'BUDGPG AWS2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
AWS2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section F",80)
 W !,$$CTR("Adult Weight Screen and Follow-up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
