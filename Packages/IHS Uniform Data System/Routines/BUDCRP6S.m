BUDCRP6S ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;----------
APTLIST1 ;EP
 D EOJ
 S BUDAPT1L=1
 D APT1
 G EN1^BUDCRP6B
APTLIST2 ;EP
 D EOJ
 S BUDAPT2L=1
 D APT2
 G EN1^BUDCRP6B
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
APT1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Asthma patients 5-40 years of age w/prescription (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 5-40 years of age with a "
 W !,"diagnosis of persistent asthma (either mild, moderate, or severe) who "
 W !,"were prescribed either the preferred long term control medication or an"
 W !,"acceptable alternative pharmacological therapy during the report period, "
 W !,"had at least two medical visits ever, and had a medical visit during the "
 W !,"report period.  Age is calculated as of December 31."
 W !
 Q
APT1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D APT1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D APT1L1
 I BUDROT="P",$Y>(IOSL-3) D APT1H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL ASTHMA PATIENTS WITH PREFERRED LONG-TERM CONTROL MEDICATION"
 I BUDROT="P" W !,"OR ACCEPTABLE ALTERNATIVE PHARMACOLOGIC THERAPY: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL ASTHMA PATIENTS WITH PREFERRED LONG-TERM CONTROL MEDICATION OR ACCEPTABLE ALTERNATIVE PHARMACOLOGIC THERAPY: "_BUDTOT)
 Q
APT1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D APT1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D APT1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"APT1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,U,1)_U_$P(BUDALL,U,2) D S(X)
 Q
APT1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section H, Asthma Pharmacological Therapy")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 5-40 years of age with an ")
 D S("active diagnosis of persistent asthma (either mild, moderate, or severe)")
 D S("who were prescribed either the preferred long term control medication or")
 D S("an acceptable alternative pharmacological therapy during the report period,")
 D S("had at least two medical visits ever, and had a medical visit during the")
 D S("report period. ")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^ASTHMA DX^PRESCRIPTION TYPE")
 Q
APT1H ;
 I BUDROT="D" D APT1HD Q
 G:'BUDGPG APT1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
APT1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section H, Asthma Pharmacological Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 5-40 years of age with an "
 .W !,"active diagnosis of persistent asthma (either mild, moderate, or severe)"
 .W !,"who were prescribed either the preferred long term control medication or"
 .W !,"an acceptable alternative pharmacological therapy during the report period,"
 .W !,"had at least two medical visits ever, and had a medical visit during the"
 .W !,"report period. "
 .W !,"Age is calculated as of December 31. "
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"ASTHMA DX",?30,"PRESCRIPTION TYPE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
APT2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Asthma patients 5-40 years of age w/o prescription (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 5-40 years of age with a"
 W !,"diagnosis of persistent asthma (either mild, moderate, or severe) who were"
 W !,"not prescribed either a preferred long term control medication or an "
 W !,"acceptable alternative pharmacological therapy or patients 5-40 years "
 W !,"of age without a diagnosis of persistent asthma who were prescribed either"
 W !,"the preferred long term control medication or an acceptable alternative "
 W !,"pharmacological therapy during the report period, had at least two medical"
 W !,"visits ever, and had a medical visit during the report period. Age is "
 W !,"calculated as of December 31."
 W !
 Q
APT2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D APT2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D APT2L1
 I BUDROT="P",$Y>(IOSL-3) D APT2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL ASTHMA PATIENTS WITHOUT PREFERRED LONG-TERM CONTROL MEDICATION"
 I BUDROT="P" W !,"OR ACCEPTABLE ALTERNATIVE PHARMACOLOGIC THERAPY: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL ASTHMA PATIENTS WITHOUT PREFERRED LONG-TERM CONTROL MEDICATION OR ACCEPTABLE ALTERNATIVE PHARMACOLOGIC THERAPY: "_BUDTOT)
 Q
APT2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D APT2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D APT2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"APT2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,U,1)_U_$P(BUDALL,U,2) D S(X)
 Q
APT2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section H, Asthma Pharmacological Therapy")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 5-40 years of age with a")
 D S("diagnosis of persistent asthma (either mild, moderate, or severe) who were")
 D S("not prescribed either a preferred long term control medication or an ")
 D S("acceptable alternative pharmacological therapy or patients 5-40 years ")
 D S("of age without a diagnosis of persistent asthma who were prescribed either")
 D S("the preferred long term control medication or an acceptable alternative ")
 D S("pharmacological therapy during the report period, had at least two medical")
 D S("visits ever, and had a medical visit during the report period. Age is ")
 D S("calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^ASTHMA DX^PRESCRIPTION TYPE")
 Q
APT2H ;
 I BUDROT="D" D APT2HD Q
 G:'BUDGPG APT2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
APT2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section H, Asthma Pharmacological Therapy",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 5-40 years of age with a"
 .W !,"diagnosis of persistent asthma (either mild, moderate, or severe) who were"
 .W !,"not prescribed either a preferred long term control medication or an "
 .W !,"acceptable alternative pharmacological therapy or patients 5-40 years "
 .W !,"of age without a diagnosis of persistent asthma who were prescribed either"
 .W !,"the preferred long term control medication or an acceptable alternative "
 .W !,"pharmacological therapy during the report period, had at least two medical"
 .W !,"visits ever, and had a medical visit during the report period. Age is "
 .W !,"calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"ASTHMA DX",?30,"PRESCRIPTION TYPE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
