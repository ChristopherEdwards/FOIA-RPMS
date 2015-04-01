BUD1RPL1 ; IHS/CMI/LAB - UDS print lists ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
TOL ;EP
 I '$D(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS")) D T6H W !!,"No Incomplete visits to report.",!! Q
 S BUDP=0
 S BUD1L="" F   S BUD1L=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L)) Q:BUD1L=""!(BUDQUIT)  D
 .D T6H Q:BUDQUIT
 .W !!,"Line ",BUD1L,"   ",$P($T(@BUD1L),";;",2)
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ...S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM,BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM,BUDAGE,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D T6W
 ....Q
 ...Q
 ..Q
 .Q
 Q
T6W ;
 W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2)
 W ?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$E($P($$RACE^BUD1RPTC(DFN),U,3)_"-"_$P($$RACE^BUD1RPTC(DFN),U,4),1,19)
 S BUDV=0 F  S BUDV=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .I $Y>(IOSL-3) D T6H Q:BUDQUIT  W !!,"Line ",BUD1L,"   ",$P($T(@BUD1L),";;",2)
 .W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,^XTMP("BUD1RPT1",BUDJ,BUDH,"ORPHANS",BUD1L,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV),?40,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?60,$E($$LOCENC^APCLV(BUDV,"E"),1,14)
 .Q
 Q
T6H ;
 G:'BUDGPG T6H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T6H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Incomplete Visit List w/Services relevant to Table 6A",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all incomplete visits with a service relevant to Table 6A.",!,"These services are not included in Table 6A." D
 .W !,"* R- denotes the value was obtained from the Race field"
 .W !,"  C- denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE*"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-")
 S BUDP=1
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
1 ;;Symptomatic HIV
2 ;;Asymptomatic HIV
3 ;;Tuberculosis
4 ;;Syphilis and other sexually transmitted diseases
5 ;;Asthma
6 ;;Chronic bronchitis and emphysema
7 ;;Abnormal breast findings, female
8 ;;Abnormal cervical findings
9 ;;Diabetes mellitus
10 ;;Heart disease (selected)
11 ;;Hypertension
12 ;;Contact dermatitis and other eczema
13 ;;Dehydration
14 ;;Exposure to heat or cold
15 ;;Otitis media and eustachian tube disorders
16 ;;Selected perinatal medical conditions
17 ;;Lack of expected normal physiological development
18 ;;Alcohol related disorders
19 ;;Other substance related disorders (excluding tobacco use disorder)
20 ;;Other Mental disorders, excluding drug or alcohol dependence
21 ;;HIV Test
22 ;;Mammogram
23 ;;Pap Smear
24 ;;Selected Immunizations
25 ;;Contraceptive Management
26 ;;Health supervision of infant or child (ages 0 through 11)
27 ;;Dental: I. Emergency Services
28 ;;Dental: II. Oral Exams
29 ;;Dental:  Prophylaxis - adult or child
30 ;;Dental:  Sealants
31 ;;Dental:  Flouride treatment
32 ;;Dental: III. Restorative Services
33 ;;Dental: IV. Oral Surger (extractions only)
34 ;;Dental: V.  Rehabilitative services (Endo, Perio, Porstho, Ortho)
