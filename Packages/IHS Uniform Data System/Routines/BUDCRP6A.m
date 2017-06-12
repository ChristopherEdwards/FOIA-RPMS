BUDCRP6A ; IHS/CMI/LAB - HIV/DEP ; 16 Nov 2015  8:52 AM
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;----------
HIVLIST1 ;EP
 D EOJ
 S BUDHIV1L=1
 D HIV1
 G EN1^BUDCRP6B
HIVLIST2 ;EP
 D EOJ
 S BUDHIV2L=1
 D HIV2
 G EN1^BUDCRP6B
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP
 D GENI^BUDCRP6I
 Q
 ;
EOJ ;
 D EN^XBVK("BUD")
 Q
CTR(X,Y) ;
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
LOC() ;
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
HIV1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"Newly Idenitifed HIV Cases with Timely Follow-Up (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients whose first ever HIV"
 W !,"diagnosis occurred between October 1 of the prior year through"
 W !,"September 30th of the current report year and had a medical visit for"
 W !,"HIV care within 90 days of the first-ever HIV diagnosis, and had at "
 W !,"least one medical visit during the report year."
 W !,"Age is calculated as of December 31."
 W !
 Q
HIV1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D HIV1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D HIV1L1
 I BUDROT="P",$Y>(IOSL-3) D HIV1H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  "_BUDTOT)
 Q
HIV1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D HIV1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D HIV1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,"|",1),?35,$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None"),?46,$P(BUDALL,"|",2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,"|",1)_U_$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None")_U_$P(BUDALL,"|",2) D S(X)
 Q
HIV1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section L")
 D S("Newly Identified HIV Cases with Timely Follow-Up")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients whose first ever HIV")
 D S("diagnosis occurred between October 1 of the prior year through")
 D S("September 30th of the current report year and had a medical visit for")
 D S("HIV care within 90 days of the first-ever HIV diagnosis, and had at ")
 D S("least one medical visit during the report year.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^First HIV DX: Date^Date of Onset^HIV Follow-up: Date")
 Q
HIV1H ;
 I BUDROT="D" D HIV1HD Q
 G:'BUDGPG HIV1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HIV1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section L,",80),!,$$CTR("Newly Identified HIV Cases with Timely Follow-Up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients whose first ever HIV"
 .W !,"diagnosis occurred between October 1 of the prior year through"
 .W !,"September 30th of the current report year and had a medical visit for"
 .W !,"HIV care within 90 days of the first-ever HIV diagnosis, and had at "
 .W !,"least one medical visit during the report year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"First HIV DX: Date",?35,"Date of Onset",?50,"HIV Follow-up: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;----------
HIV2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"Newly Idenitifed HIV Cases with Timely Follow-Up (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients whose first ever HIV"
 W !,"diagnosis occurred between October 1 of the prior year through"
 W !,"September 30th of the current report year and did not have a medical visit"
 W !,"for HIV care within 90 days of the first-ever HIV diagnosis, and had at "
 W !,"least one medical visit during the report year."
 W !,"Age is calculated as of December 31."
 W !
 Q
HIV2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D HIV2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D HIV2L1
 I BUDROT="P",$Y>(IOSL-3) D HIV2H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  "_BUDTOT)
 Q
HIV2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D HIV2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D HIV2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....I BUDROT="P" W ?5,$P(BUDALL,"|",1),?35,$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None"),?46,$P(BUDALL,"|",2)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....S X=X_U_$P(BUDALL,"|",1)_U_$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None")_U_$P(BUDALL,"|",2) D S(X)
 Q
HIV2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section L")
 D S("Newly Identified HIV Cases without Timely Follow-Up")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients whose first ever HIV")
 D S("diagnosis occurred between October 1 of the prior year through")
 D S("September 30th of the current report year and did not have a medical visit")
 D S("for HIV care within 90 days of the first-ever HIV diagnosis, and had at ")
 D S("least one medical visit during the report year.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^First HIV DX: Date^Date of Onset^HIV Follow-up: Date")
 Q
HIV2H ;
 I BUDROT="D" D HIV2HD Q
 G:'BUDGPG HIV2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HIV2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section L,",80),!,$$CTR("Newly Identified HIV Cases without Timely Follow-Up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients whose first ever HIV"
 .W !,"diagnosis occurred between October 1 of the prior year through"
 .W !,"September 30th of the current report year and did not have a medical visit"
 .W !,"for HIV care within 90 days of the first-ever HIV diagnosis, and had at "
 .W !,"least one medical visit during the report year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"First HIV DX: Date",?35,"Date of Onset",?50,"HIV Follow-up: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
