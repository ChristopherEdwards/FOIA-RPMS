BUDRPTL ; IHS/CMI/LAB - UDS print lists ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
START ;
 S BUDQUIT="",BUDGPG=0
 I $G(BUDT3AL) D T3A
 Q:BUDQUIT
 I $G(BUDT3BL),'$G(BUDT3AL) D T3A
 Q:BUDQUIT
 I $G(BUDT4L) D T4
 Q:BUDQUIT
 I $G(BUDT5L) D T5
 Q:BUDQUIT
 I $G(BUDT5L1) D T51
 Q:BUDQUIT
 I $G(BUDT5L2) D T52
 Q:BUDQUIT
 I $G(BUDT6L) D T6
 Q:BUDQUIT
 I $G(BUDTOL) D TOL
 Q
T4 ;
 Q
T3A ;
 S BUDP=0
 D T3H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"3A",BUDAGE)) Q:BUDAGE'=+BUDAGE!(BUDQUIT)  D
 .S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN="" F  S DFN=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T3H Q:BUDQUIT
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$P($$RACE^BUDRPTC(DFN),U,2)
 ....S BUDV=0 F  S BUDV=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D T3H Q:BUDQUIT
 .....W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?62,$E($$LOCENC^APCLV(BUDV,"E"),1,14)
 Q
T3H ;
 G:'BUDGPG T3H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T3H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Tables 3A, 3B",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all Users, defined as any patient with one or more visits during the",!,"calendar year, with gender, age, race or ethnicity, and visit information.",!,"Age is calculated as of June 30.",!
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE/ETHN"
 S BUDP=1
 W !,$TR($J("",80)," ","-")
 Q
T52 ;
 D T52^BUDRPTL2
 Q
T51 ;
 D T51H Q:BUDQUIT
 S BUD5L="" F  S BUD5L=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T51",BUD5L)) Q:BUD5L=""!(BUDQUIT)  D
 .I $Y>(IOSL-3) D T51H Q:BUDQUIT
 .S BUDY=$O(^BUDTFIVE("B",BUD5L,0)),BUDY=$P(^BUDTFIVE(BUDY,0),U,2)
 .W !!,"Line ",BUD5L,"   ",BUDY
 .S BUDPROV="" F  S BUDPROV=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T51",BUD5L,BUDPROV)) Q:BUDPROV=""!(BUDQUIT)  D
 ..W !,BUDPROV,?35,^XTMP("BUDRPT1",BUDJ,BUDH,"T51",BUD5L,BUDPROV)
 .Q
 Q
T51H ;
 G:'BUDGPG T51H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T51H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Provider List for Table 5 Columns A, By Service Category",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 ;W !,"List of all Active Provider Personnel sorted by Major Service Category.",!
 W !,"PROVIDER NAME",?35,"PROVIDER CODE",?70,"FTE"
 W !,$TR($J("",80)," ","-")
 Q
T5 ;
 S BUDP=0
 ;D T5H Q:BUDQUIT
 S BUD5L="" F   S BUD5L=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L)) Q:BUD5L=""!(BUDQUIT)  D
 .D T5H Q:BUDQUIT
 .S BUDY=$O(^BUDTFIVE("B",BUD5L,0)),BUDY=$P(^BUDTFIVE(BUDY,0),U,2)
 .W !!,"Line ",BUD5L,"   ",BUDY
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L,BUDCOM,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ...S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L,BUDCOM,BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L,BUDCOM,BUDAGE,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D T5W
 ....Q
 ...Q
 ..Q
 .Q
 Q
T5W W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$P($$RACE^BUDRPTC(DFN),U,2)
 K BUDVLST S BUDV=0 F  S BUDV=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T5",BUD5L,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .S BUDVLST($P(^AUPNVSIT(BUDV,0),U),BUDV)=""
 S BUDDD=0 F  S BUDDD=$O(BUDVLST(BUDDD)) Q:BUDDD=""!(BUDQUIT)  D
 .S BUDV=0 F  S BUDV=$O(BUDVLST(BUDDD,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 ..I $Y>(IOSL-3) D T5H Q:BUDQUIT
 ..W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$$PRIMPROV^APCLV(BUDV,"D"),?50,$P(^AUPNVSIT(BUDV,0),U,7),?55,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?70,$E($$LOCENC^APCLV(BUDV,"E"),1,9)
 ..Q
 Q
T5H ;
 G:'BUDGPG T5H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T5H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 5 Columns B & C, By Service Category",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all Users, sorted by defined Service Categories.  Displays",!,"community, gender, age and visit data, including Provider codes."
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE/ETHN"
 W !,$TR($J("",80)," ","-")
 S BUDP=1
 Q
T6 ;
 S BUDP=0
 ;D T6H Q:BUDQUIT
 S BUD6L="" F   S BUD6L=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L)) Q:BUD6L=""!(BUDQUIT)  D
 .D T6H Q:BUDQUIT
 .W !!,"Line ",BUD6L,"   ",$P($T(@BUD6L),";;",2)
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ...S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM,BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM,BUDAGE,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D T6W
 ....Q
 ...Q
 ..Q
 .Q
 Q
T6W ;
 W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$P($$RACE^BUDRPTC(DFN),U,2)
 S BUDV=0 F  S BUDV=$O(^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .I $Y>(IOSL-3) D T6H Q:BUDQUIT
 .W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,^XTMP("BUDRPT1",BUDJ,BUDH,"T6",BUD6L,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV),?40,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,15),?60,$E($$LOCENC^APCLV(BUDV,"E"),1,15)
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
 W !,$$CTR("Patient List for Table 6, By Diagnosis Category",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all Users, sorted by primary diagnosis and tests/screening",!,"categories.  Displays community, gender, age and visit data, and codes."
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE/ETHN"
 W !,$TR($J("",80)," ","-")
 S BUDP=1
 Q
TOL ;
 D TOL^BUDRPTL1
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
4 ;;Syphilis and other venereal diseases
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
18 ;;Alcohol dependence
19 ;;Drug dependence
20 ;;Other Mental disorders, excluding drug or alcohol dependence
21 ;;HIV Test
22 ;;Mammogram
23 ;;Pap Smear
24 ;;Selected Immunizations
25 ;;Contraceptive Management
26 ;;Health supervision of infant or child (ages 0 through 11)
