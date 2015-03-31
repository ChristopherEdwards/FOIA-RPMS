BUD0RP6I ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
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
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
PRGA ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2010",80)
 W !!,"Prenatal Patients by Age (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of patients by age that had pregnancy-related"
 W !,"visits during the past 20 months, with at least one pregnancy-related visit"
 W !,"during the report period."
 W !
 Q
PRGAL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D PRGAH Q:BUDQUIT
 I '$D(^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA")) W !!,"No patients to report." Q
 S BUDAB="Less than 15 Years" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 15-19" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 20-24" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 25-44" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 45 and Over" D PRGAL1
 I BUDQUIT G PRGALX
 I $Y>(IOSL-3) D PRGAH G:BUDQUIT PRGALX
 W !!,"TOTAL PREGNANT PATIENTS: ",BUDTOT,!
PRGALX ;
 Q
PRGAL1 ;
 I $Y>(IOSL-7) D PRGAH Q:BUDQUIT
 W !,BUDAB,!
 S BUDSTOT=0
 S BUDA=0 F  S BUDA=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA)) Q:BUDA'=+BUDA!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D PRGAH Q:BUDQUIT
 ....W !?2,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$$AGE^AUPNPAT(DFN,BUDCAD),!
 ....S BUDSTOT=BUDSTOT+1,BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUD0RP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM,DFN)
 ....F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D PRGAH Q:BUDQUIT
 .....I $E(BUDV)="P" W ?5,BUDV,! Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?20,C,?33,$P(^AUPNVSIT(V,0),U,7),?41,$E($$CLINIC^APCLV(V,"E"),1,15),?60,$E($$VAL^XBDIQ1(9000010,V,.06),1,19),!
 W !,"Sub-Total ",BUDAB,":  ",BUDSTOT,!
 Q
PRGAH ;
 G:'BUDGPG PRGAH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
PRGAH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Sections A & B, Pregnant Patients",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all patients with pregnancy-related visits during the past 20"
 .W !,"months, with at least one pregnancy-related visit during the report"
 .W !,"period, with age and visit information.  Displays community, age, and"
 .W !,"visit data, and codes."
 .W !,"Age is calculated as of June 30."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"AGE"
 W !?5,"VISIT DATE",?20,"DX OR SVC CD",?33,"SVC CAT",?41,"CLINIC",?60,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
 ;----------
IMM1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2010",80)
 W !!,"All Patients Age 2 w/All Child Immunizations (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of two year old patients who had their first"
 W !,"visit prior to their 2nd birthday, had a medical visit during the report"
 W !,"period, and have all required childhood immunizations."
 W !
 Q
IMM1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IMM1H Q:BUDQUIT
 I '$D(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM1")) W !!,"No patients to report." Q
 D IMM1L1
 I $Y>(IOSL-3) D IMM1H Q:BUDQUIT
 W !!,"TOTAL PATIENTS IMMUNIZED: ",BUDTOT,!
 Q
IMM1L1 ;
 I $Y>(IOSL-7) D IMM1H Q:BUDQUIT
 S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM1",BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S DFN=0 F  S DFN=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ...I $Y>(IOSL-3) D IMM1H Q:BUDQUIT
 ...W $E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,$$AGE^AUPNPAT(DFN,BUDED),!
 ...S BUDTOT=BUDTOT+1
 ...S BUDALL=$P(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM1",BUDNAME,BUDCOM,DFN),"|||",1)
 ...F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D IMM1H Q:BUDQUIT
 ....W ?4,BUDV,!
 Q
IMM1H ;
 G:'BUDGPG IMM1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IMM1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Sections C, With Childhood Immunizations",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all 2-year old patients who had their first visit prior to their"
 .W !,"2nd birthday, had a medical visit during the report period, and have all"
 .W !,"required childhood immunizations."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"IMMUNIZATIONS RCVD, CONTRAIND, EVID OF DISEASE"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
IMM2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2010",80)
 W !!,"All Patients Age 2 w/o All Child Immunizations (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"List of all 2-year old patients who had their first visit prior to their"
 W !,"2nd birthday, had a medical visit during the report period, and are in "
 W !,"need of the following immunizations to complete all required childhood "
 W !,"immunizations."
 W !,"Age is calculated as of December 31."
 W !
 Q
IMM2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D IMM2H Q:BUDQUIT
 I '$D(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM2")) W !!,"No patients to report." Q
 D IMM2L1
 I $Y>(IOSL-3) D IMM2H Q:BUDQUIT
 W !!,"TOTAL PATIENTS NOT IMMUNIZED: ",BUDTOT,!
 Q
IMM2L1 ;
 I $Y>(IOSL-7) D IMM2H Q:BUDQUIT
 S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM2",BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S DFN=0 F  S DFN=$O(^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ...I $Y>(IOSL-3) D IMM2H Q:BUDQUIT
 ...W $E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,$$AGE^AUPNPAT(DFN,BUDED),!
 ...S BUDTOT=BUDTOT+1
 ...S BUDALL=^XTMP("BUD0RP6B",BUDJ,BUDH,"IMM2",BUDNAME,BUDCOM,DFN)
 ...F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D IMM2H Q:BUDQUIT
 ....W ?4,BUDV,!
 Q
IMM2H ;
 G:'BUDGPG IMM2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
IMM2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Sections C, Without Childhood Immunizations",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all 2-year old patients who had their first visit prior to their "
 .W !,"2nd birthday, had a medical visit during the report period, and are in need"
 .W !,"of the following immunizations to complete all required childhood "
 .W !,"immunizations."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"IMMUNIZATIONS NOT RECEIVED"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;----------
