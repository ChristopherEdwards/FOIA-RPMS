BUDBRP6A ; IHS/CMI/LAB - HIV/DEP ; 
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
HIVLIST1 ;EP
 D EOJ
 S BUDHIV1L=1
 D HIV1
 G EN1^BUDBRP6B
HIVLIST2 ;EP
 D EOJ
 S BUDHIV2L=1
 D HIV2
 G EN1^BUDBRP6B
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP
 D GENI^BUDBRP6I
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
 W !,$$CTR("UDS 2014",80)
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
 I '$D(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1")) W !!,"No patients to report.",! Q
 D HIV1L1
 I $Y>(IOSL-3) D HIV1H Q:BUDQUIT
 W !,"TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  ",BUDTOT,!
 Q
HIV1L1 ;
 I $Y>(IOSL-7) D HIV1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D HIV1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,"|",1),?35,$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None"),?46,$P(BUDALL,"|",2)
HIV1H ;
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
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
 W !,$$CTR("UDS 2014",80)
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
 I '$D(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2")) W !!,"No patients to report.",! Q
 D HIV2L1
 I $Y>(IOSL-3) D HIV2H Q:BUDQUIT
 W !,"TOTAL PATIENTS WITH FIRST HIV DX & TIMELY FOLLOW-UP:  ",BUDTOT,!
 Q
HIV2L1 ;
 I $Y>(IOSL-7) D HIV2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D HIV2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDBRP6B",BUDJ,BUDH,"HIV2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,"|",1),?35,$S($P(BUDALL,"|",3)]"":$P(BUDALL,"|",3),1:"None"),?46,$P(BUDALL,"|",2)
HIV2H ;
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
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
DEPLIST1 ;EP
 D EOJ
 S BUDDEP1L=1
 D DEP1
 G EN1^BUDBRP6B
DEPLIST2 ;EP
 D EOJ
 S BUDDEP2L=1
 D DEP2
 G EN1^BUDBRP6B
DEP1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2014",80)
 W !!,"All Patients 12+ w/Depression Scrn & if Positive a Follow-up Plan (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 12 years and older who were "
 W !,"screened for depression with a standardized tool during the report year"
 W !,"and had a follow-up plan documented if screened positive, and had at"
 W !,"least one medical visit during the report year."
 W !
 Q
DEP1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DEP1H Q:BUDQUIT
 I '$D(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1")) W !!,"No patients to report.",! Q
 D DEP1L1
 I $Y>(IOSL-3) D DEP1H Q:BUDQUIT
 W !,"TOTAL PATIENTS WITH DEP SCRN & IF POSITIVE, FOLLOW-UP:  ",BUDTOT,!
 Q
DEP1L1 ;
 I $Y>(IOSL-7) D DEP1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D DEP1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....S BUD1=$P(BUDALL,"|",1),BUD2=$P(BUDALL,"|",2)
 ....I BUD1]"" W ?5,$P(BUD1,U,2),": ",$P(BUD1,U,3),": ",$$FMTE^XLFDT($P(BUD1,U,1),5)
 ....W ?35,"Follow-up: " I BUD2]"" W $P(BUD2,U,2),": ",$$FMTE^XLFDT($P(BUD2,U,1),5)
DEP1H ;
 G:'BUDGPG DEP1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DEP1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section M,",80),!,$$CTR("Patients Screened for Depression and Followed Up if Appropriate",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 12 years and older who were "
 .W !,"screened for depression with a standardized tool during the report year and"
 .W !,"had a follow-up plan documented if screened positive, and had at least one"
 .W !,"medical visit during the report year. "
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Depression Scrn: Date/Result",?35,"Follow-up Plan: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
DEP2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2014",80)
 W !!,"All Patients 12+ w/o Depression Scrn or w/o Follow-up (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 12 years and older not"
 W !,"screened for depression or who were screened for depression with a"
 W !,"standardized tool during the report year and does not have a follow-up"
 W !,"plan documented if screened positive, and had at least one medical visit"
 W !,"during the report year."
 W !
 Q
DEP2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DEP2H Q:BUDQUIT
 I '$D(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2")) W !!,"No patients to report.",! Q
 D DEP2L1
 I $Y>(IOSL-3) D DEP2H Q:BUDQUIT
 W !,"TOTAL PATIENTS W/O DEP SCRN OR W/O FOLLOW-UP IF POSITIVE:  ",BUDTOT,!
 Q
DEP2L1 ;
 I $Y>(IOSL-7) D DEP2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D DEP2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDBRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....S BUD1=$P(BUDALL,"|",1),BUD2=$P(BUDALL,"|",2)
 ....I BUD1]"" W ?5,$P(BUD1,U,2),": ",$P(BUD1,U,3),": ",$$FMTE^XLFDT($P(BUD1,U,1),5)
 ....W ?35,"Follow-up: " I BUD2]"" W $P(BUD2,U,2),": ",$$FMTE^XLFDT($P(BUD2,U,1),5)
DEP2H ;
 G:'BUDGPG DEP2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DEP2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section M,",80),!,$$CTR("Patients not Screened for Depression or w/o Follow-up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 12 years and older not"
 .W !,"screened for depression or who were screened for depression with a"
 .W !,"standardized tool during the report year and does not have a follow-up"
 .W !,"plan documented if screened positive, and had at least one medical visit"
 .W !,"during the report year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Depression Scrn: Date/Result",?35,"Follow-up Plan: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
