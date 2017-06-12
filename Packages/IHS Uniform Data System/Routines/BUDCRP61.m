BUDCRP61 ; IHS/CMI/LAB - UDS REPORT PROCESSOR ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
DSLIST1 ;EP
 D EOJ
 S BUDDS1L=1
 D DS1
 G EN1^BUDCRP6B
DSLIST2 ;EP
 D EOJ
 S BUDDS2L=1
 D DS2
 G EN1^BUDCRP6B
DS1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC^BUDCRP6S,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 6-9 w/first Molar Sealant (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 6-9 years who had an oral "
 W !,"assessment, were determined to be at moderate or high risk for caries"
 W !,"and had a sealant placed on a first molar during the reporing period."
 W !
 Q
DS1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DS1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D DS1L1
 I BUDROT="P",$Y>(IOSL-3) D DS1H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS WITH SEALANT:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH SEALANT:  "_BUDTOT)
 Q
DS1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D DS1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DS1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"DS1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?35,"Sealant: ",BUDALL
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_"Sealant: "_BUDALL D S(X)
 Q
DS1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section N")
 D S("Patients 6-9 years old with sealant on first molar")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 6-9 years who had an oral ")
 D S("assessment, were determined to be at moderate or high risk for caries")
 D S("and had a sealant placed on a first molar during the reporing period.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^SEALANT and DATE")
 Q
DS1H ;
 I BUDROT="D" D DS1HD Q
 G:'BUDGPG DS1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DS1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section M,",80),!,$$CTR("Patients Screened for DSression and Followed Up if Appropriate",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 6-9 years who had an oral "
 .W !,"assessment, were determined to be at moderate or high risk for caries"
 .W !,"and had a sealant placed on a first molar during the reporing period."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"SEALANT DATE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
DS2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC^BUDCRP6S,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 6-9 years of age at risk w/o sealant on first molar (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 6-9 years who had an oral "
 W !,"assessment, were determined to be at moderate or high risk for caries"
 W !,"and did not have a sealant placed on a first molar during the reporing period."
 W !
 Q
DS2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DS2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D DS2L1
 I BUDROT="P",$Y>(IOSL-3) D DS2H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS AT RISK W/O SEALANT:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS AT RISK W/O SEALANT  "_BUDTOT)
 Q
DS2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D DS2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DS2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"DS2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....;I BUDROT="P" W ?35,"Follow-up: " I BUD2]"" W $P(BUD2,U,2),": ",$$FMTE^XLFDT($P(BUD2,U,1),5)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....;S X=X_U_"Follow-up: " I BUD2]"" S X=X_$P(BUD2,U,2)_": "_$$FMTE^XLFDT($P(BUD2,U,1),5) D S(X)
 .....D S(X)
 Q
DS2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section N")
 D S("Patients 6-9 at Risk without dental sealant on first molar")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 6-9 years who had an oral ")
 D S("assessment, were determined to be at moderate or high risk for caries")
 D S("and did not have a sealant placed on a first molar during the reporing period.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^")
 Q
DS2H ;
 I BUDROT="D" D DS2HD Q
 G:'BUDGPG DS2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DS2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section N,",80),!,$$CTR("Patients 6-9 at Risk without dental sealant on first molar",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 6-9 years who had an oral "
 .W !,"assessment, were determined to be at moderate or high risk for caries"
 .W !,"and did not have a sealant placed on a first molar during the reporing period."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP
 D GENI^BUDCRP6I
 Q
 ;
CTR(X,Y) ;
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
EOJ ;
 D EN^XBVK("BUD")
 Q
