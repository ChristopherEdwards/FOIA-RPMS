BUD9RP7T ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;general introductions
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
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
 ;
DMR3 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2009",80)
 W !!,"All Patients w/DM and A1c >9 by Race and Hispanic or Latino Identity (Table 7)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race and Hispanic or Latino Identity of "
 W !,"patients age 18 to 75 years old who have had two"
 W !,"medical visits during the report period, with a diagnosis"
 W !,"of Type I or Type II diabetes anytime through the end of the report"
 W !,"period, and without a diagnosis of polycystic ovaries, gestational diabetes,"
 W !,"or steroid-induced diabetes and with a most recent hemoglobin A1c greater"
 W !,"than 9%, or with an A1c with no result, or with no A1c test during the"
 W !,"report period."
 W !
 Q
DMR3L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DMR3H Q:BUDQUIT
 I '$D(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3")) W !!,"No patients to report." Q
 D DMR3L1
 I $Y>(IOSL-3) D DMR3H G:BUDQUIT DMR3LX
 W !!,"TOTAL DM PATIENTS 18+ W/A1C >9%: ",BUDTOT,!
DMR3LX ;
 Q
DMR3L1 ;
 I $Y>(IOSL-7) D DMR3H Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D DMR3L2
 Q
DMR3L2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUD9RP7I(BUDRACE,BUDETH)
 W !,BUDRACEL
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D DMR3H Q:BUDQUIT  W !,BUDRACEL,!
 ....W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,BUDA,!  ;,?51,$P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUD9RPTC(DFN)
 ....W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),1,19)
 ....S BUDHISV=$$HISP^BUD9RPTC(DFN)
 ....W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....S BUDALL=^XTMP("BUD9RP7",BUDJ,BUDH,"DMR3",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....W ?5,$P(BUDALL,"^",2),!
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D DMR3H Q:BUDQUIT  W !,BUDRACEL,!
 .....I $E(BUDV)="P" W ?5,BUDV,! Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 I $Y>(IOSL-4) D DMR3H Q:BUDQUIT  W !,BUDRACEL,!
 W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 Q
DMR3H ;
 G:'BUDGPG DMR3H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DMR3H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section C, DM w/A1c >9 by Race",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race of patients age 18 and older who have had two medical visits"
 .W !,"during the report period and were diagnosed with Type I or Type II diabetes"
 .W !,"anytime through the end of the report period and whose most recent"
 .W !,"hemoglobin A1c is >9%, or did not have a result, or the patient did not"
 .W !,"have an A1c test during the report period."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST A1C VALUE OR CD & DATE"
 W !?5,"LAST DM DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
