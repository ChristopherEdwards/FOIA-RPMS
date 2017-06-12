BUDCRP6J ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;------
CADLIST1 ;EP
 D EOJ
 S BUDCAD1L=1
 D CAD1
 G EN1^BUDCRP6B
CAD2LIST ;EP
 D EOJ
 S BUDCAD2L=1
 D CAD2
 G EN1^BUDCRP6B
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
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
 W !,$$CTR("UDS 2015",80)
 W !!,"All CAD patients 18+ w/Lipid Therapy (Table 6B)",!
 D GENI^BUDCRP6P
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
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D CAD1L1
 I BUDROT="P",$Y>(IOSL-3) D CAD1H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL CAD PATIENTS WITH LIPID-LOWERING THERAPY:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL CAD PATIENTS WITH LIPID-LOWERING THERAPY:  "_BUDTOT)
 Q
CAD1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D CAD1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D CAD1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,U,1)_U_$P(BUDALL,U,2)_U_"LDL: "_$P(BUDALL,U,3)_" "_$$FMTE^XLFDT($P(BUDALL,U,4)) D S(X)
 Q
CAD1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section I")
 D S("Coronary Artery Disease: Lipid Therapy")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 18 years of age and older")
 D S("with an active diagnosis of Coronary Artery Disease (CAD) including ")
 D S("myocardial infarction (MI),or have had cardiac surgery, and whose last LDL")
 D S("was greater than or equal to 130 who were prescribed a lipid-lowering ")
 D S("therapy medication or have documented evidence of use by patient of lipid")
 D S("lowering medication during the report period, does not have an allergy or")
 D S("adverse reaction to lipid-lowering therapy medications, had at least two")
 D S("medical visits ever, and had a medical visit during the report period. ")
 D S("Age is calulated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^Date of DX^DX or Svc CD^Medication^LDL")
 Q
CAD1H ;
 I BUDROT="D" D CAD1HD Q
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
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
 W !,$$CTR("UDS 2015",80)
 W !!,"All CAD patients 18+ w/o Lipid Therapy (Table 6B)",!
 D GENI^BUDCRP6P
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
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2")),'$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D CAD2L1
 I BUDROT="P",$Y>(IOSL-3) D CAD2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL CAD PATIENTS WITHOUT LIPID-LOWERING THERAPY:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL CAD PATIENTS WITHOUT LIPID-LOWERING THERAPY: "_BUDTOT)
 S BUDP=0,BUDQUIT=0,BUDTOT=0,BUDX2ALG=1
 ;D CAD2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2")) D  Q
 .I BUDROT="P" W !!,"TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY: 0",! Q
 .I BUDROT="D" D S(),S("TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY: 0")
 D CAD2ALG
 I BUDROT="P",$Y>(IOSL-3) D CAD2H Q:BUDQUIT
 I BUDROT="P" W !!,"TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL CAD PATIENTS WITH ALG OR ADV REACTION TO LIPID-LOWERING THERAPY:  "_BUDTOT)
 Q
CAD2ALG ;
 I BUDROT="P",$Y>(IOSL-7) D CAD2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D CAD2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"ALG","CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD)_U_X D
 .....S X=X_U_$P(BUDALL,U,1)_U_$P(BUDALL,U,2)_U_"LDL: "_$P(BUDALL,U,3)_" "_$$FMTE^XLFDT($P(BUDALL,U,4)) D S(X)
 Q
CAD2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D CAD2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D CAD2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"CAD2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2),!?5,"LDL: ",$P(BUDALL,U,3)," ",$$FMTE^XLFDT($P(BUDALL,U,4))
 ....I BUDROT="D" I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,U,1)_U_$P(BUDALL,U,2)_U_"LDL: "_$P(BUDALL,U,3)_" "_$$FMTE^XLFDT($P(BUDALL,U,4)) D S(X)
 Q
CAD2HD ;
 D CAD2HD^BUDCRP6R Q
CAD2H ;
 I BUDROT="D" D CAD2HD Q
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
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 18 years of age and older"
 .W !,"with an active diagnosis of Coronary Artery Disease (CAD) including "
 .W !,"myocardial infarction (MI) or have had cardiac surgery and whose last "
 .W !,"LDL was greater than or equal to 130 or last recorded LDL is greater than"
 .W !,"1yr from last visit in the report year who were not prescribed a "
 .W !,"lipid-lowering therapy medication or has no documented evidence of use by"
 .W !,"patient of lipid lowering medication during the report period or has an "
 .W !,"allergy or adverse reaction to lipid-lowering therapy medications, had at"
 .W !,"least two medical visits ever, and had a medical visit during the report"
 .W !,"period."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Date of DX",?16,"DX or Svc CD",?30,"Medication",?72,"LDL"
 W !,$TR($J("",80)," ","-"),!
 I 'BUDX2ALG W "CAD Patients with LDL >=130 w/o Lipid Lowering Medication",!
 I BUDX2ALG W "CAD Patients w/LDL =>130 and an ALG or ADV Reaction to Lipid Lowering Medication"
 S BUDP=1
 Q
 ;
