BUDRPTP1 ; IHS/CMI/LAB - UDS PRINT TABLE 6 ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
T6 ;EP
 S BUDPG=0,BUDQUIT="",BUDTYPE="D"
 D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"SELECTED INFECTIOUS AND PARASITIC DISEASES"
 W !," 1.  Symptomatic HIV",?35,$$CTR("042.xx",15),?54,$$C($P(BUDT6("V"),U,1)),?70,$$C($P(BUDT6("P"),U,1)),!,BUD80L
 W !," 2.  Asymptomatic HIV",?35,$$CTR("V08",15),?54,$$C($P(BUDT6("V"),U,2)),?70,$$C($P(BUDT6("P"),U,2)),!,BUD80L
 W !," 3.  Tuberculosis",?35,$$CTR("010.xx-018.xx",15),?54,$$C($P(BUDT6("V"),U,3)),?70,$$C($P(BUDT6("P"),U,3)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !," 4.  Syphilis and other venereal",!?6,"diseases",?35,$$CTR("090.xx-099.xx",15),?54,$$C($P(BUDT6("V"),U,4)),?70,$$C($P(BUDT6("P"),U,4)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED DISEASES OF THE RESPIRATORY SYSTEM",!,BUD80L
 W !," 5.  Asthma",?35,$$CTR("493.xx",15),?54,$$C($P(BUDT6("V"),U,5)),?70,$$C($P(BUDT6("P"),U,5)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !," 6.  Chronic bronchitis and ",?35,$$CTR("490.xx-492.xx",15),!?6,"emphysema",?35,$$CTR("496.xx",15),?54,$$C($P(BUDT6("V"),U,6)),?70,$$C($P(BUDT6("P"),U,6)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED OTHER MEDICAL CONDITIONS",!,BUD80L
 W !," 7.  Abnormal breast findings,",?35,$$CTR("174.xx; 198.81;",15),!,?6,"female",?35,$$CTR("233.0x; 793.8",15),?54,$$C($P(BUDT6("V"),U,7)),?70,$$C($P(BUDT6("P"),U,7)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !," 8.  Abnormal cervical findings",?35,$$CTR("180.xx; 198.82;",15),!,?35,"233.1x; 795.0x",?54,$$C($P(BUDT6("V"),U,8)),?70,$$C($P(BUDT6("P"),U,8)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !," 9.  Diabetes mellitus",?35,$$CTR("250.xx; 775.1x",15),!,?35,$$CTR("790.2",15),?54,$$C($P(BUDT6("V"),U,9)),?70,$$C($P(BUDT6("P"),U,9)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"10.  Heart disease (selected)",?35,$$CTR("391.xx-392.0x",15),!?35,$$CTR("410.xx-429.xx",15),?54,$$C($P(BUDT6("V"),U,10)),?70,$$C($P(BUDT6("P"),U,10)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"11.  Hypertension",?35,$$CTR("401.xx-405.xx",15),?54,$$C($P(BUDT6("V"),U,11)),?70,$$C($P(BUDT6("P"),U,11)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"12.  Contact dermatitis and",?35,$$CTR("692.xx",15),!?6,"other eczema",?54,$$C($P(BUDT6("V"),U,12)),?70,$$C($P(BUDT6("P"),U,12)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"13.  Dehydration",?35,$$CTR("276.5x",15),?54,$$C($P(BUDT6("V"),U,13)),?70,$$C($P(BUDT6("P"),U,13)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"14.  Exposure to heat or cold",?35,$$CTR("991.xx-992.xx",15),?54,$$C($P(BUDT6("V"),U,14)),?70,$$C($P(BUDT6("P"),U,14)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED CHILDHOOD CONDITIONS",!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"15.  Otitis Media and other eustachian tube",!?6,"disorders",?35,$$CTR("381.xx-382.xx",15),?54,$$C($P(BUDT6("V"),U,15)),?70,$$C($P(BUDT6("P"),U,15)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"16.  Selected perinatal medical",?35,$$CTR("770.xx; 771.xx; 773.xx",23),!?6," conditions",?35,$$CTR("774.xx-779.xx",15),!,?35,$$CTR("excl 779.3x",15),?54,$$C($P(BUDT6("V"),U,16)),?70,$$C($P(BUDT6("P"),U,16)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"17.  Lack of expected normal",?35,$$CTR("260.xx-269.xx; 779.3x",22),!?6,"physical development...",?35,$$CTR("783.3x-783.4x",15),?54,$$C($P(BUDT6("V"),U,17)),?70,$$C($P(BUDT6("P"),U,17)),!,BUD80L
 I $Y>(IOSL-4) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED MENTAL HEALTH AND SUBSTANCE ABUSE CONDITIONS",!,BUD80L
 W !,?35,$$CTR("291.xx; 303.xx; 305.0x",15),!,"18.  Alcohol related disorders",?35,$$CTR("357.5x",15),?54,$$C($P(BUDT6("V"),U,18)),?70,$$C($P(BUDT6("P"),U,18)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"19.  Other substance related",?35,$$CTR("292.1x-292.8x",15),!?6,"disorders (excluding tobacco",?35,$$CTR("304.xx, 305.2x-305.9x",22)
 W !?6,"use disorders)",?35,$$CTR("357.6x, 648.3x",15),?54,$$C($P(BUDT6("V"),U,19)),?70,$$C($P(BUDT6("P"),U,19)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,?35,$$CTR("290.xx; 293.xx-302.xx;",22),!?35,$$CTR("(excluding 300.0x,",20),!?5,"Other mental disorders,",?35,$$CTR("300.21, 300.22, 300.23,",23)
 W !,"20.  dependence (includes mental",?35,$$CTR("306.xx-319.xx",15),!?5,"retardation)",?35,$$CTR("(excl 308.3, 309.81, 312.8x,",25)
 W !?35,$$CTR("312.9x, 313.81, 314.xx",22),?54,$$C($P(BUDT6("V"),U,20)),?70,$$C($P(BUDT6("P"),U,20)),!,BUD80L
 ;
SRV ;
 S BUDTYPE="S" D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED DIAGNOSTIC TESTS/SCREENING/PREVENTIVE SERVICES",!,BUD80L
 W !,"21.  HIV Test",?30,$$CTR("CPT-4: 86689; 86701-86703",26),!,?30,$$CTR("87390-87391; LOINC & site-",26),!,?35,$$CTR("defined taxonomies",18),?54,$$C($P(BUDT6("V"),U,21)),?70,$$C($P(BUDT6("P"),U,21)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"22.  Mammogram",?30,$$CTR("CPT-4: 76090-76092",20),!,?30,$$CTR("ICD-9: V76.1",15),!,?35,$$CTR("VProc 87.35-.37",15),?54,?54,$$C($P(BUDT6("V"),U,22)),?70,$$C($P(BUDT6("P"),U,22)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"23.  Pap Smear",?30,$$CTR("CPT-4: 88141-88155, 88164-88167",32),!?30,$$CTR("ICD-9: V72.3, V76.2; VLab Pap Smear;",32),!
 W ?30,$$CTR("VProc 91.46; LOINC & site",15),!,?30,$$CTR("defined taxonomies",18),?54,$$C($P(BUDT6("V"),U,23)),?70,$$C($P(BUDT6("P"),U,23)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"24.  Selected immunizations"
 W ?54,$$C($P(BUDT6("V"),U,24)),?70,$$C($P(BUDT6("P"),U,24)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"25.  Contraceptive Management",?35,$$CTR("ICD-9: V25.xx",15),?54,$$C($P(BUDT6("V"),U,25)),?70,$$C($P(BUDT6("P"),U,25)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUDRPTP Q:BUDQUIT  D T6SH
 W !,"26.  Health supervision of infant",?34,"Clinic code 24, 57;",!?6," or child (ages 0 - 11)",?34,"ICD-9: V20.xx; V29.xx",!?34,"CPT-4: 99391-99393;",!?34,"99381-83; 99431-33"
 W ?54,$$C($P(BUDT6("V"),U,26)),?70,$$C($P(BUDT6("P"),U,26)),!,BUD80L
 Q
T6SH ;
 W !,$$CTR("TABLE 6-",80),!
 W $$CTR("SELECTED DIAGNOSES AND SERVICES RENDERED",80)
 W !,$TR($J("",80)," ","-")
 W !,?35,"Applicable",?54,"Number of",?70,"# of Users"
 W !?35,"icd-9-cm",?54,"Encounters by",?69,"w/this prim"
 W !?35,"code",?54,"prim dx",?70,"Diagnosis"
 I BUDTYPE="D" W !,"DIAGNOSTIC CATEGORY",?62,"(a)",?75,"(b)"
 I BUDTYPE="S" W !,"SERVICE CATEGORY",?63,"(a)",?75,"(b)"
 W !,$TR($J("",80)," ","-"),!
 Q
C(X) ;
 S X2=0,X3=9
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
