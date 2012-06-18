BUD5RPP1 ; IHS/CMI/LAB - UDS PRINT TABLE 6 ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
T6 ;EP
 S BUDPG=0,BUDQUIT="",BUDTYPE="D"
 D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"SELECTED INFECTIOUS AND PARASITIC DISEASES"
 W !," 1.  Symptomatic HIV",?35,$$CTR("042.xx",15),?56,$$C($P(BUDT6("V"),U,1)),?70,$$C($P(BUDT6("P"),U,1)),!,BUD80L
 W !," 2.  Asymptomatic HIV",?35,$$CTR("V08",15),?56,$$C($P(BUDT6("V"),U,2)),?70,$$C($P(BUDT6("P"),U,2)),!,BUD80L
 W !," 3.  Tuberculosis",?35,$$CTR("010.xx-018.xx",15),?56,$$C($P(BUDT6("V"),U,3)),?70,$$C($P(BUDT6("P"),U,3)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !," 4.  Syphilis and other venereal",!?6,"diseases",?35,$$CTR("090.xx-099.xx",15),?56,$$C($P(BUDT6("V"),U,4)),?70,$$C($P(BUDT6("P"),U,4)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED DISEASES OF THE RESPIRATORY SYSTEM",!,BUD80L
 W !," 5.  Asthma",?35,$$CTR("493.xx",15),?56,$$C($P(BUDT6("V"),U,5)),?70,$$C($P(BUDT6("P"),U,5)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !," 6.  Chronic bronchitis and ",?35,$$CTR("490.xx-492.xx",15),!?6,"emphysema",?35,$$CTR("496.xx",15),?56,$$C($P(BUDT6("V"),U,6)),?70,$$C($P(BUDT6("P"),U,6)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED OTHER MEDICAL CONDITIONS",!,BUD80L
 W !," 7.  Abnormal breast findings,",?35,$$CTR("174.xx; 198.81;",15),!,?6,"female",?35,$$CTR("233.0x; 793.8x",15),?56,$$C($P(BUDT6("V"),U,7)),?70,$$C($P(BUDT6("P"),U,7)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !," 8.  Abnormal cervical findings",?35,$$CTR("180.xx; 198.82;",15),!,?35,"233.1x; 795.0x",?56,$$C($P(BUDT6("V"),U,8)),?70,$$C($P(BUDT6("P"),U,8)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !," 9.  Diabetes mellitus",?35,$$CTR("250.xx; 775.1x",15),!,?35,$$CTR("790.2",15),?56,$$C($P(BUDT6("V"),U,9)),?70,$$C($P(BUDT6("P"),U,9)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"10.  Heart disease (selected)",?35,$$CTR("391.xx-392.0x",15),!?35,$$CTR("410.xx-429.xx",15),?56,$$C($P(BUDT6("V"),U,10)),?70,$$C($P(BUDT6("P"),U,10)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"11.  Hypertension",?35,$$CTR("401.xx-405.xx",15),?56,$$C($P(BUDT6("V"),U,11)),?70,$$C($P(BUDT6("P"),U,11)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"12.  Contact dermatitis and",?35,$$CTR("692.xx",15),!?6,"other eczema",?56,$$C($P(BUDT6("V"),U,12)),?70,$$C($P(BUDT6("P"),U,12)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"13.  Dehydration",?35,$$CTR("276.5x",15),?56,$$C($P(BUDT6("V"),U,13)),?70,$$C($P(BUDT6("P"),U,13)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"14.  Exposure to heat or cold",?35,$$CTR("991.xx-992.xx",15),?56,$$C($P(BUDT6("V"),U,14)),?70,$$C($P(BUDT6("P"),U,14)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED CHILDHOOD CONDITIONS",!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"15.  Otitis Media and other eustachian tube",!?6,"disorders",?35,$$CTR("381.xx-382.xx",15),?56,$$C($P(BUDT6("V"),U,15)),?70,$$C($P(BUDT6("P"),U,15)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"16.  Selected perinatal medical",?35,$$CTR("770.xx; 771.xx; 773.xx",23),!?6," conditions",?35,$$CTR("774.xx-779.xx",15),!,?35,"excluding 779.3x",?56,$$C($P(BUDT6("V"),U,16)),?70,$$C($P(BUDT6("P"),U,16)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"17.  Lack of expected normal",?35,$$CTR("260.xx-269.xx; 779.3x",22),!?6,"physical development...",?35,$$CTR("783.3x-783.4x",15),?56,$$C($P(BUDT6("V"),U,17)),?70,$$C($P(BUDT6("P"),U,17)),!,BUD80L
 I $Y>(IOSL-4) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED MENTAL HEALTH AND SUBSTANCE ABUSE CONDITIONS",!,BUD80L
 W !,?35,"291.xx; 303.xx; ",!,"18.  Alcohol related disorders",?35,"305.0x, 357.5x",?56,$$C($P(BUDT6("V"),U,18)),?70,$$C($P(BUDT6("P"),U,18)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"19.  Other substance related",?35,"292.1x-292.8x",!?6,"disorders (excluding tobacco",?35,"304.xx, 305.2x-305.9x"
 W !?6,"use disorders)",?35,"357.6x, 648.3x",?56,$$C($P(BUDT6("V"),U,19)),?70,$$C($P(BUDT6("P"),U,19)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"20a. Depression and other mood",?35,"296.xx, 300.4"
 W !,?6,"disorders",?35,"301.13, 311.xx",?56,$$C($P(BUDT6("V"),U,40)),?70,$$C($P(BUDT6("P"),U,40)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !?35,"300.0x, 300.21, 300.22"
 W !,"20b. Anxiety disorders including",?35,"300.23, 300.29, 300.3"
 W !,?6,"PTSD",?35,"308.3, 309.81",?56,$$C($P(BUDT6("V"),U,41)),?70,$$C($P(BUDT6("P"),U,41)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !,"20c. Attention Deficit and",?35,"312.8x, 312.9x,"
 W !?5,"disruptive behavior disorders",?35,"313.81, 314.xx",?56,$$C($P(BUDT6("V"),U,42)),?70,$$C($P(BUDT6("P"),U,42)),!,BUD80L
 I $Y>(IOSL-12) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH
 W !?35,"290.xx",!?35,"293.xx - 302.xx",!?35,"(excluding 296.xx",!?35,"300.0x, 300.21, 300.22"
 W !,"20d. Other mental disorders,",?35,"300.23, 300.29, 300.3,"
 W !?6,"excluding drug or alcohol",?35,"300.4, 301.13);",!?6,"dependence",?35,"306.xx-319.xx excluding 308.3,"
 W !?6,"(includes mental retardation)",?35,"(309.81, 311.xx, 312.8x",!?35,"312.9x, 313.81, "
 W !?35,"314.xx",?56,$$C($P(BUDT6("V"),U,43)),?70,$$C($P(BUDT6("P"),U,43)),!,BUD80L
 ;
SRV ;
 S BUDTYPE="S" D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !!,"SELECTED DIAGNOSTIC TESTS/SCREENING/PREVENTIVE SERVICES",!,BUD80L
 W !,"21.  HIV Test",?33,"CPT-4: 86689; 86701-86703",!,?33,"87390-87391; LOINC & site-",!,?33,"defined taxonomies",?56,$$C($P(BUDT6("V"),U,21)),?70,$$C($P(BUDT6("P"),U,21)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"22.  Mammogram",?33,"CPT-4: 76090-76092, G0202, G0204, G0206",!,?33,"ICD-9: V76.1x",!,?33,"VProc 87.36-.37",!?33,"WH Screening Mammogram",!?33,"WH Mammogram DX Bilat",!?33,"WH Mammogram DX Unilat"
 W ?56,$$C($P(BUDT6("V"),U,22)),?70,$$C($P(BUDT6("P"),U,22)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"23.  Pap Smear",?33,"CPT-4: 88141-88155, 88164-88167",!?33,"88160-88162, 88174, 88175, Q0091",!?33,"ICD-9: V72.3, V72.31, V76.2, V72.32,",!?33,"V76.47, V76.49; VLab Pap Smear;",!?33,"WH Pap Smear; "
 W ?33,"VProc 91.46; LOINC & site",!,?33,"defined taxonomies",?56,$$C($P(BUDT6("V"),U,23)),?70,$$C($P(BUDT6("P"),U,23)),!,BUD80L
 I $Y>(IOSL-13) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"24.  Selected immunizations",?33,"CPT-4: 90633-90634",!?33,"90645-90648, 90657-90660"
 W !?33,"90669, 90700-90702",!?33,"90704-90716, 90718",!?33,"90720-90723",!?33,"90743-90744, 90748"
 W !?33,"CVX: 83-84, 46-49, 15,",!?33,"111, 100, 20, 01, 28",!?33,"02-07, 09-10, 21, 94",!?33,"22, 50, 110, 43",!?33,"43, 08, 51"
 W ?56,$$C($P(BUDT6("V"),U,24)),?70,$$C($P(BUDT6("P"),U,24)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"25.  Contraceptive Management",?35,$$CTR("ICD-9: V25.xx",15),?56,$$C($P(BUDT6("V"),U,25)),?70,$$C($P(BUDT6("P"),U,25)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"26.  Health supervision of infant",?34,"Clinic code 24, 57;",!?6," or child (ages 0 - 11)",?34,"ICD-9: V20.xx; V29.xx",!?34,"CPT-4: 99391-99393;",!?34,"99381-83; 99431-33"
 W ?56,$$C($P(BUDT6("V"),U,26)),?70,$$C($P(BUDT6("P"),U,26)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
DENT ;
 W !!,"SELECTED DENTAL SERVICES",!,BUD80L
 W !,"27.  I. Emergency Services",?34,"ADA: 9110",?56,$$C($P(BUDT6("V"),U,27)),?70,$$C($P(BUDT6("P"),U,27)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"28.  II. Oral Exams",?34,"ADA: 0120, 0140, 0150",!?34,"0160, 0170, 0180",?56,$$C($P(BUDT6("V"),U,28)),?70,$$C($P(BUDT6("P"),U,28)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"29.      Prophylaxis - adult",?34,"ADA: 1110, 1120,",!?11,"or child",?34,"1201, 1205",?56,$$C($P(BUDT6("V"),U,29)),?70,$$C($P(BUDT6("P"),U,29)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"30.      Sealants",?34,"ADA: 1351"
 W ?56,$$C($P(BUDT6("V"),U,30)),?70,$$C($P(BUDT6("P"),U,30)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"31.      Fluoride treatment",?34,"ADA: 1201, 1203",!?39,"1204, 1205",?56,$$C($P(BUDT6("V"),U,31)),?70,$$C($P(BUDT6("P"),U,31)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"32.  III. Restorative Services",?34,"ADA: 21xx, 23xx, 27xx"
 W ?56,$$C($P(BUDT6("V"),U,32)),?70,$$C($P(BUDT6("P"),U,32)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"33.  IV. Oral Surgery",?34,"ADA: 7111, 7140, 7210, 7220"
 W !?34,"7230, 7240, 7241, 7250, 7260, 7261"
 W !?34,"7270, 7272, 7280"
 W ?56,$$C($P(BUDT6("V"),U,33)),?70,$$C($P(BUDT6("P"),U,33)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD5RPTP Q:BUDQUIT  D T6SH1
 W !,"34.  V. Rehabilitative services (Endo, Perio, Prostho, Ortho)",!?34,"ADA: 3xxx, 4xxx, 5xxx",!?34,"6xxx, 8xxx"
 W ?56,$$C($P(BUDT6("V"),U,34)),?70,$$C($P(BUDT6("P"),U,34)),!,BUD80L
 Q
T6SH ;
 W !,$$CTR("TABLE 6-",80),!
 W $$CTR("SELECTED DIAGNOSES AND SERVICES RENDERED",80)
 W !,$TR($J("",80)," ","-")
 W !,?35,"Applicable",?54,"Number of",?70,"# of Users"
 W !?35,"icd-9-cm",?54,"Encounters by",?69,"w/this prim"
 W !?35,"code",?54,"prim dx",?70,"Diagnosis"
 I BUDTYPE="D" W !,"DIAGNOSTIC CATEGORY",?60,"(a)",?75,"(b)"
 I BUDTYPE="S" W !,"SERVICE CATEGORY",?61,"(a)",?75,"(b)"
 W !,$TR($J("",80)," ","-"),!
 Q
T6SH1 ;
 W !,$$CTR("TABLE 6-",80),!
 W $$CTR("SELECTED DIAGNOSES AND SERVICES RENDERED",80)
 W !,$TR($J("",80)," ","-")
 W !,?37,"Applicable",?54,"Number of",?70,"# of Users"
 W !?37,"icd-9-cm or",?54,"Encounters"
 W !?37,"CPT-4 codes"
 I BUDTYPE="D" W !,"DIAGNOSTIC CATEGORY",?60,"(a)",?75,"(b)"
 I BUDTYPE="S" W !,"SERVICE CATEGORY",?61,"(a)",?75,"(b)"
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
