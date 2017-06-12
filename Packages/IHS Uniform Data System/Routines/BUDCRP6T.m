BUDCRP6T ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;----------
TUALIST1 ;EP
 D EOJ
 S BUDTUA1L=1
 D TUA1
 G EN1^BUDCRP6B
TUALIST2 ;EP
 D EOJ
 S BUDTUA2L=1
 D TUA2
 G EN1^BUDCRP6B
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
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 18+ w/tobacco use scrn & cessation intervention (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years and older who were"
 W !,"queried/screened about any and all forms tobacco use AND received documented"
 W !,"cessation counseling intervention (counseling) or medication (smoking"
 W !,"(cessation agents) if identified as a tobacco user one or more times during the "
 W !,"report period or the prior year, had at least one medical during the report"
 W !,"period, and with at least two medical visits ever, and were ever seen after"
 W !,"their 18th birthday."
 W !
 Q
TUA1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TUA1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D TUA1L1
 I BUDROT="P",$Y>(IOSL-3) D TUA1H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS WITH TOBACCO USE SCREEN AND CESSATION INTERVENTION: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH TOBACCO USE SCREEN AND CESSATION INTERVENTION: "_BUDTOT)
 Q
TUA1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D TUA1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D TUA1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDALL="",BUDROT="P" W ?5,"Never" Q
 ....S BUDSCR=$P(BUDALL,"|"),BUDUSER=$P(BUDALL,"|",2),BUDCESS=$P(BUDALL,"|",3)
 ....I BUDROT="P" W ?5,$P(BUDSCR,U,2),?20,$E($P(BUDSCR,U,1),1,18) I BUDUSER]"" W ?40,"USER: ",BUDUSER," CESS: ",$P(BUDCESS,U,1)_" "_$P(BUDCESS,U,2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_BUDAGE D
 .....I BUDALL="" S X=X_U_"Never" D S(X) Q
 .....S X=X_U_$P(BUDSCR,U,2)_" "_$P(BUDSCR,U,1) I BUDUSER]"" S X=X_U_"USER: "_BUDUSER_U_"CESS: "_$P(BUDCESS,U,1)_" "_$P(BUDCESS,U,2)
 .....D S(X)
 ....;S %=$P(BUDALL,"|",2)
 ....;W ?60,$P(%,U)
 Q
TUA1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section G, Tobacco Screening and Cessation Intervention")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 18 years and older who were ")
 D S("queried/screened about any and all forms tobacco use AND received documented")
 D S("cessation counseling intervention (counseling) or medication (smoking ")
 D S("cessation agents) if identified as a tobacco user one or more times during the")
 D S("report period or the prior year, had at least one medical visit during the")
 D S("report period, and with at least two medical visits ever, and were ever")
 D S("seen after their 18th birthday. ")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^SCREEN DATE AND CODE^TOBACCO STATUS^CESSATION")
 Q
TUA1H ;
 I BUDROT="D" D TUA1HD Q
 G:'BUDGPG TUA1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TUA1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G, Tobacco Screening and Cessation Intervention",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years and older who were "
 .W !,"queried/screened about any and all forms tobacco use AND received documented"
 .W !,"cessation counseling intervention (counseling) or medication (smoking "
 .W !,"cessation agents) if identified as a tobacco user one or more times during the"
 .W !,"report period or the prior year, had at least one medical visit during the"
 .W !,"report period, and with at least two medical visits ever, and were ever"
 .W !,"seen after their 18th birthday. "
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"SCREEN DATE",?20,"TOBACCO STATUS",?40,"CESSATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
TUA2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 18 and older w/o tobacco use scrn or cessation intervention (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 18 years and older who were"
 W !,"not queried/screened about any and all forms tobacco use or did not "
 W !,"receive a documented cessation counseling intervention (counseling) or"
 W !,"medication (smoking cessation agents) if identified as a tobacco user"
 W !,"one or more times during the report period or the prior year, had at "
 W !,"least one medical during the report period, and with at least two medical"
 W !,"visits ever, and were ever seen after their 18th birthday."
 W !
 Q
TUA2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D TUA2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D TUA2L1
 I BUDROT="P",$Y>(IOSL-3) D TUA2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL PATIENTS WITHOUT TOBACCO USE SCREEN OR CESSATION INERVENTION: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITHOUT TOBACCO USE SCREEN OR CESSATION INERVENTION: "_BUDTOT)
 Q
TUA2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D TUA2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D TUA2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"TUA2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDALL="" W ?5,"Never" Q
 ....S BUDSCR=$P(BUDALL,"|"),BUDUSER=$P(BUDALL,"|",2),BUDCESS=$P(BUDALL,"|",3)
 ....I BUDROT="P" W ?5,$P(BUDSCR,U,2),?20,$E($P(BUDSCR,U,1),1,18) I BUDUSER]"" W ?40,"USER: ",BUDUSER," CESS: ",$P(BUDCESS,U,1)_" "_$P(BUDCESS,U,2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_BUDAGE D
 .....I BUDALL="" S X=X_U_"Never" D S(X) Q
 .....S X=X_U_$P(BUDSCR,U,2)_" "_$P(BUDSCR,U,1) I BUDUSER]"" S X=X_U_"USER: "_BUDUSER_U_"CESS: "_$P(BUDCESS,U,1)_" "_$P(BUDCESS,U,2)
 .....D S(X)
 ....;S %=$P(BUDALL,"|",2)
 ....;W ?60,$P(%,U)
 Q
TUA2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section G, Tobacco Screening and Cessation Intervention")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 18 years and older who were")
 D S("not queried/screened about any and all forms tobacco use or did not ")
 D S("receive a documented cessation counseling intervention (counseling)")
 D S("or medication (smoking cessation agents) if identified as a tobacco")
 D S("user one or more times during the report period or the prior year,")
 D S("had at least one medical visit during the report period, and with at")
 D S("least two medical visits ever, and were ever seen after their 18th")
 D S("birthday. ")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^SCREEN DATE AND CODE^TOBACCO STATUS^CESSATION")
 Q
TUA2H ;
 I BUDROT="D" D TUA2HD Q
 G:'BUDGPG TUA2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TUA2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section G, Tobacco Use Screening and Cessation Intervention",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients 18 years and older who were"
 .W !,"not queried/screened about any and all forms tobacco use or did not "
 .W !,"receive a documented cessation counseling intervention (counseling)"
 .W !,"or medication (smoking cessation agents) if identified as a tobacco"
 .W !,"user one or more times during the report period or the prior year,"
 .W !,"had at least one medical visit during the report period, and with at"
 .W !,"least two medical visits ever, and were ever seen after their 18th"
 .W !,"birthday. "
 .W !,"Age is calculated as of December 31st."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"SCREEN DATE",?30,"TOBACCO STATUS",?60,"CESSATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
