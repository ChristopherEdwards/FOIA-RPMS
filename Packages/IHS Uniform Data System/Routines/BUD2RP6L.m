BUD2RP6L ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2012 8:09 PM 14 Dec 2012 1:24 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
CRCLIST1 ;EP
 D EOJ
 S BUDCRC1L=1
 D CRC1
 G EN1^BUD2RP6B
CRCLIST2 ;EP
 D EOJ
 S BUDCRC2L=1
 D CRC2
 G EN1^BUD2RP6B
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
CRC1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2012",80)
 W !!,"All patients 51-74 years of age w/colorectal cancer screen (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients age 51-74 as of December 31"
 W !,"of the report period, not diagnosed with colorectal cancer, who has a "
 W !,"documented colorectal cancer screen, and had at least one medical visit"
 W !,"during the reporting year."
 W !,"Age is calculated as of December 31."
 W !
 Q
CRC1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D CRC1H Q:BUDQUIT
 I '$D(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1")) W !!,"No patients to report.",! Q
 D CRC1L1
 I $Y>(IOSL-3) D CRC1H Q:BUDQUIT
 W !,"TOTAL PATIENTS WITH COLORECTAL CANCER SCREEN:  ",BUDTOT,!
 Q
CRC1L1 ;
 I $Y>(IOSL-7) D CRC1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D CRC1H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 Q
CRC1H ;
 G:'BUDGPG CRC1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
CRC1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section K,",80),!,$$CTR("Colorectal Cancer Screening",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients age 51-74 as of December 31"
 .W !,"of the report period, not diagnosed with colorectal cancer, who has a "
 .W !,"documented colorectal cancer screen, and had at least one medical visit"
 .W !,"during the reporting year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"CRC Screen"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
CRC2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2012",80)
 W !!,"All patients 51-74 years of age w/o colorectal cancer screen (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients age 51-74 as of December 31"
 W !,"of the report period, not diagnosed with colorectal cancer, who did not "
 W !,"have a documented colorectal cancer screen, and had at least one medical"
 W !,"visit during the reporting year."
 W !,"Age is calculated as of December 31."
 W !
 Q
CRC2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D CRC2H Q:BUDQUIT
 I '$D(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2")) W !!,"No patients to report.",! Q
 D CRC2L1
 I $Y>(IOSL-3) D CRC2H Q:BUDQUIT
 W !,"TOTAL PATIENTS WITHOUT COLORECTAL CANCER SCREEN:  ",BUDTOT,!
 Q
CRC2L1 ;
 I $Y>(IOSL-7) D CRC2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D CRC2H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUD2RP6B",BUDJ,BUDH,"CRC2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....W ?5,$P(BUDALL,U,1),?30,$P(BUDALL,U,2)
 Q
CRC2H ;
 G:'BUDGPG CRC2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
CRC2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section K,",80),!,$$CTR("Colorectal Cancer Screening",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients age 51-74 as of December 31"
 .W !,"of the report period, not diagnosed with colorectal cancer, who did not "
 .W !,"have a documented colorectal cancer screen, and had at least one medical"
 .W !,"visit during the reporting year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"CRC Screen"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
