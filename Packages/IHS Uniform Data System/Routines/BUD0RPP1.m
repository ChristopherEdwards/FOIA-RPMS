BUD0RPP1 ; IHS/CMI/LAB - UDS PRINT TABLE 6 05 Dec 2007 6:26 AM 30 Dec 2010 10:42 AM ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
T6 ;EP
 S BUDPG=0,BUDQUIT="",BUDFNP=1,BUDTYPE="D"
 D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 K BUDFNP
 W !,"SELECTED INFECTIOUS AND PARASITIC DISEASES"
 W !," 1,2. Symptomatic and Asymptomatic",!?6,"HIV",?35,$$CTR("042,079.53, V08",15),?56,$$C($P(BUDT6("V"),U,1)),?70,$$C($P(BUDT6("P"),U,1)),!,BUD80L
 ;W !," 2.  Asymptomatic HIV",?35,$$CTR("V08",15),?56,$$C($P(BUDT6("V"),U,2)),?70,$$C($P(BUDT6("P"),U,2)),!,BUD80L
 W !," 3.  Tuberculosis",?35,$$CTR("010.xx-018.xx",15),?56,$$C($P(BUDT6("V"),U,3)),?70,$$C($P(BUDT6("P"),U,3)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 4.  Syphilis and other sexually",!?6,"transmitted diseases",?35,$$CTR("090.xx-099.xx",15),?56,$$C($P(BUDT6("V"),U,4)),?70,$$C($P(BUDT6("P"),U,4)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 4a. Hepatitis B",?35,$$CTR("070.20, 070.22, 070.30",15),!?35,$$CTR("070.32",15),?56,$$C($P(BUDT6("V"),U,67)),?70,$$C($P(BUDT6("P"),U,67)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 4b. Hepatitis C",?35,$$CTR("070.41, 070.44, 070.51",15),!?35,$$CTR("070.54, 070.70, 070.71",15),?56,$$C($P(BUDT6("V"),U,68)),?70,$$C($P(BUDT6("P"),U,68)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED DISEASES OF THE RESPIRATORY SYSTEM",!,BUD80L
 W !," 5.  Asthma",?35,$$CTR("493.xx",15),?56,$$C($P(BUDT6("V"),U,5)),?70,$$C($P(BUDT6("P"),U,5)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 6.  Chronic bronchitis and ",?35,$$CTR("490.xx-492.xx",15),!?6,"emphysema",?56,$$C($P(BUDT6("V"),U,6)),?70,$$C($P(BUDT6("P"),U,6)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED OTHER MEDICAL CONDITIONS",!,BUD80L
 W !," 7.  Abnormal breast findings,",?35,$$CTR("174.xx; 198.81; 233.0x",15),!,?6,"female",?35,$$CTR("238.3; 793.8x",15),?56,$$C($P(BUDT6("V"),U,7)),?70,$$C($P(BUDT6("P"),U,7)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 8.  Abnormal cervical findings",?35,$$CTR("180.xx; 198.82;",15),!,?35,"233.1x; 795.0x",?56,$$C($P(BUDT6("V"),U,8)),?70,$$C($P(BUDT6("P"),U,8)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !," 9.  Diabetes mellitus",?35,$$CTR("250.xx; 648.0x;",15),!?35,"775.1x",?56,$$C($P(BUDT6("V"),U,9)),?70,$$C($P(BUDT6("P"),U,9)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"10.  Heart disease (selected)",?35,$$CTR("391.xx-392.0x",15),!?35,$$CTR("410.xx-429.xx",15),?56,$$C($P(BUDT6("V"),U,10)),?70,$$C($P(BUDT6("P"),U,10)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"11.  Hypertension",?35,$$CTR("401.xx-405.xx",15),?56,$$C($P(BUDT6("V"),U,11)),?70,$$C($P(BUDT6("P"),U,11)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"12.  Contact dermatitis and",?35,$$CTR("692.xx",15),!?6,"other eczema",?56,$$C($P(BUDT6("V"),U,12)),?70,$$C($P(BUDT6("P"),U,12)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"13.  Dehydration",?35,$$CTR("276.5x",15),?56,$$C($P(BUDT6("V"),U,13)),?70,$$C($P(BUDT6("P"),U,13)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"14.  Exposure to heat or cold",?35,$$CTR("991.xx-992.xx",15),?56,$$C($P(BUDT6("V"),U,14)),?70,$$C($P(BUDT6("P"),U,14)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,?35,$$CTR("278.00-278.02,",15)
 W !?35,$$CTR("V85.xx excluding V85.0,",15)
 W !,"14a. Overweight and obesity",?35,$$CTR("V85.1, V85.51, V85.52",14),?56,$$C($P(BUDT6("V"),U,60)),?70,$$C($P(BUDT6("P"),U,60))
 W !,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED CHILDHOOD CONDITIONS",!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"15.  Otitis Media and eustachian tube",!?6,"disorders",?35,$$CTR("381.xx-382.xx",15),?56,$$C($P(BUDT6("V"),U,15)),?70,$$C($P(BUDT6("P"),U,15)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"16.  Selected perinatal medical",?35,$$CTR("770.xx; 771.xx; 773.xx",23),!?6," conditions",?35,$$CTR("774.xx-779.xx",15),!,?35,"excluding 779.3x",?56,$$C($P(BUDT6("V"),U,16)),?70,$$C($P(BUDT6("P"),U,16)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"17.  Lack of expected normal",?35,$$CTR("260.xx-269.xx; 779.3x",22),!?6,"physical development",?35,$$CTR("783.3x-783.4x",15)
 W !?6,"(such as delayed milestone;",!?6,"failure to gain weight; failure to",!?6,"thrive)-does not include sexual"
 W !?6,"or mental development;",!?6,"Nutritional deficiencies",?56,$$C($P(BUDT6("V"),U,17)),?70,$$C($P(BUDT6("P"),U,17)),!,BUD80L
 I $Y>(IOSL-4) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !!,"SELECTED MENTAL HEALTH AND SUBSTANCE ABUSE CONDITIONS",!,BUD80L
 W !,?35,"291.xx; 303.xx; ",!,"18.  Alcohol related disorders",?35,"305.0x, 357.5x",?56,$$C($P(BUDT6("V"),U,18)),?70,$$C($P(BUDT6("P"),U,18)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"19.  Other substance related",?35,"292.1x-292.8x",!?6,"disorders (excluding tobacco",?35,"304.xx, 305.2x-305.9x"
 W !?6,"use disorders)",?35,"357.6x, 648.3x",?56,$$C($P(BUDT6("V"),U,19)),?70,$$C($P(BUDT6("P"),U,19)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"19a. Tobacco use disorder",?35,"305.1",?56,$$C($P(BUDT6("V"),U,61)),?70,$$C($P(BUDT6("P"),U,61)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"20a. Depression and other mood",?35,"296.xx, 300.4"
 W !,?6,"disorders",?35,"301.13, 311.xx",?56,$$C($P(BUDT6("V"),U,40)),?70,$$C($P(BUDT6("P"),U,40)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"20b. Anxiety disorders including",?35,"300.0x, 300.2x, 300.3"
 W !,?6,"PTSD",?35,"308.3, 309.81",?56,$$C($P(BUDT6("V"),U,41)),?70,$$C($P(BUDT6("P"),U,41)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !,"20c. Attention Deficit and",?35,"312.8x, 312.9x,"
 W !?5,"disruptive behavior disorders",?35,"313.81, 314.xx",?56,$$C($P(BUDT6("V"),U,42)),?70,$$C($P(BUDT6("P"),U,42)),!,BUD80L
 I $Y>(IOSL-12) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH
 W !?35,"290.xx",!?35,"293.xx - 302.xx",!?35,"(excluding 296.xx"
 W !,"20d. Other mental disorders,",?35,"300.0x, 300.2x, 300.3"
 W !?6,"excluding drug or alcohol",?35,"300.4, 301.13); ",!?6,"dependence"
 W !?6,"(includes mental",?35,"306.xx-319.xx (excluding 308.3,",!?6," retardation)",?35,"309.81, 311.xx, 312.8x,",!?35,"312.9x, 313.81, "
 W !?35,"314.xx)",?56,$$C($P(BUDT6("V"),U,43)),?70,$$C($P(BUDT6("P"),U,43)),!,BUD80L
 ;
SRV ;
 S BUDTYPE="S" D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !!,"SELECTED DIAGNOSTIC TESTS/SCREENING/PREVENTIVE SERVICES",!,BUD80L
 W !,"21.  HIV Test",?33,"CPT-4: 86689; 86701-86703",!,?33,"87390-87391",!,?33,"LOINC & site-",!,?33,"defined taxonomies",?56,$$C($P(BUDT6("V"),U,21)),?70,$$C($P(BUDT6("P"),U,21)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"21a. Hepatitis B test",?33,"CPT-4: 86704, 86706, 87515-87517 ",!?33,"or VLab ",!?33,"[BUD HEPATITIS B TESTS]"
 W ?56,$$C($P(BUDT6("V"),U,69)),?70,$$C($P(BUDT6("P"),U,69)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"21b. Hepatitis C test",?33,"CPT-4: 86803-86804, 87520-87522  ",!?33,"or VLab ",!?33,"[BUD HEPATITIS C TESTS]"
 W ?56,$$C($P(BUDT6("V"),U,70)),?70,$$C($P(BUDT6("P"),U,70)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"22.  Mammogram",?33,"CPT-4: 77052, 77057",!,?33,"ICD-9: V76.11, V76.12"
 W !?33,"WH Mammogram Screening",!?33,"WH Mammogram DX Bilat",!?33,"WH Mammogram DX Unilat"
 W ?56,$$C($P(BUDT6("V"),U,22)),?70,$$C($P(BUDT6("P"),U,22)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"23.  Pap Test",?33,"CPT-4: 88141-88155, 88164-88167, ",?33,"88174-88175"
 W !?33,"ICD-9: V72.3, V72.31, V76.2",!?33,"VLab Pap Smear; WH Pap Smear; "
 W !?33,"LOINC & site",!,?33,"defined taxonomies",?56,$$C($P(BUDT6("V"),U,23)),?70,$$C($P(BUDT6("P"),U,23)),!,BUD80L
 I $Y>(IOSL-13) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"24.  Selected immunizations;",?33,"CPT-4: 90633-90634"
 W !?6,"Hepatitis A, Hemophilius ",?33,"90645-90648"
 W !?6,"Influenza B (HIB), ",?33,"90670, 90696-90702"
 W !?6,"Pneumococcal, ",?33,"90704-90716,"
 W !?6,"Diphtheria, ",?33,"90718-90723"
 W !?6,"Tetanus, Pertussis (DTap)",?33,"90743-90744, 90748"
 W !?6,"(DTP)(DT), Mumps, Measles,",?33,"CVX: 31,52,83-84,85,104,17,22"
 W !?6,"Rubella, Poliovirus, ",?33,"46-47,48-49,50-51,102,120,132"
 W !?6,"Varicella, ",?33,"33,109,133,01,09,11"
 W !?6,"Hepatitis B Child",?33,"20,22,28,50,106,107,110,113",!?33,"115,130,132,138,139,03-07"
 W !?33,"38,94,02,10,89,21,94,08,42",!?33,"43,44,45"
 W ?56,$$C($P(BUDT6("V"),U,24)),?70,$$C($P(BUDT6("P"),U,24)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"24a. Seasonal Flu vaccine",?33,"CPT-4: 90655-90662, CVX: 16,",!?33,"111, 135, 140, 141",?56,$$C($P(BUDT6("V"),U,65)),?70,$$C($P(BUDT6("P"),U,65)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"24b. H1N1 Flu vaccine",?33,"CPT-4: 90663; 90470",?56,$$C($P(BUDT6("V"),U,66)),?70,$$C($P(BUDT6("P"),U,66)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"25.  Contraceptive Management",?35,$$CTR("ICD-9: V25.xx",15),?56,$$C($P(BUDT6("V"),U,25)),?70,$$C($P(BUDT6("P"),U,25)),!,BUD80L
 I $Y>(IOSL-6) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"26.  Health supervision of infant",?34,"Clinic code 24, 57;",!?6," or child (ages 0 - 11)",?34,"CPT-4: 99381-99383,",!?34," 99391-99393"  ;,!?34,"99431-99433; OR ICD-9",!?34,"V20.xx, V29.xx"
 W ?56,$$C($P(BUDT6("V"),U,26)),?70,$$C($P(BUDT6("P"),U,26)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"26a. Childhood lead test",?35,"CPT-4: 83655"
 W !?6,"screening (9-72 months)",?56,$$C($P(BUDT6("V"),U,62)),?70,$$C($P(BUDT6("P"),U,62)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"26b. Screening, Brief Intervention",?35,"CPT-4: 99408-99409"
 W !?6,"and Referral (SBIRT)",?35,"Pat Ed: AOD-INJ",?56,$$C($P(BUDT6("V"),U,63)),?70,$$C($P(BUDT6("P"),U,63)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"26c. Smoke and tobacco use",?35,"CPT-4: 99406 and 99407;"
 W !?6,"cessation counseling",?35,"S9075; Pat Ed: TO-*;",?56,$$C($P(BUDT6("V"),U,64)),?70,$$C($P(BUDT6("P"),U,64))
 W !?35,"-TO*, *-SHS; 305.1",!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"26d. Comprehensive and intermediate",?35,"CPT-4: 92002, 92004,"
 W !?6,"eye exams",?35,"92012, 92014",?56,$$C($P(BUDT6("V"),U,71)),?70,$$C($P(BUDT6("P"),U,71)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
DENT ;
 W !!,"SELECTED DENTAL SERVICES",!,BUD80L
 W !,"27.  I. Emergency Services",?34,"ADA: 9110",?56,$$C($P(BUDT6("V"),U,27)),?70,$$C($P(BUDT6("P"),U,27)),!?34,"CPT-4: D9110",!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"28.  II. Oral Exams",?34,"ADA: 0120, 0140, 0145, 0150",!?34,"0160, 0170, 0180; CPT-4: D0120",!?34,"D0140, D0145, D0150, D0160",!?34,"D0170, D0180",?56,$$C($P(BUDT6("V"),U,28)),?70,$$C($P(BUDT6("P"),U,28)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"29.      Prophylaxis - adult",?34,"ADA: 1110, 1120,",!?11,"or child",?34,"CPT-4: D1110, D1120",?56,$$C($P(BUDT6("V"),U,29)),?70,$$C($P(BUDT6("P"),U,29)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"30.      Sealants",?34,"ADA: 1351;",!?34,"CPT-4: D1351"
 W ?56,$$C($P(BUDT6("V"),U,30)),?70,$$C($P(BUDT6("P"),U,30)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"31.      Fluoride treatment - ",?34,"ADA: 1203, 1204, 1206",!?10,"adult or child",?34,"CPT-4: D1203, D1204",!?34,"D1206",?56,$$C($P(BUDT6("V"),U,31)),?70,$$C($P(BUDT6("P"),U,31)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"32.  III. Restorative Services",?34,"ADA: 21xx-29xx",!?34,"CPT-4: D21xx-D29xx"
 W ?56,$$C($P(BUDT6("V"),U,32)),?70,$$C($P(BUDT6("P"),U,32)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"33.  IV. Oral Surgery",?34,"ADA: 7111, 7140, 7210, 7220"
 W !?6,"(extractions and other",?34,"7230, 7240, 7241, 7250, 7260"
 W !?6,"surgical procedures)",?34,"7261, 7270, 7272, 7280",!?34,"CPT-4: D7111, D7140, D7210, ",!?34,"D7220, D7230, D7240, D7241,",!?34,"D7250, D7260, D7261, ",!?34,"D7270, D7272, D7280"
 W ?56,$$C($P(BUDT6("V"),U,33)),?70,$$C($P(BUDT6("P"),U,33)),!,BUD80L
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T6SH1
 W !,"34.  V. Rehabilitative services ",!?6,"(Endo, Perio, Prostho, Ortho)",?34,"ADA: 3xxx, 4xxx, 5xxx",!?34,"6xxx, 8xxx",!?34,"CPT-4: D3xxx, D4xxx, D5xxx",!?34,"D6xxx, D8xxx"
 W ?56,$$C($P(BUDT6("V"),U,34)),?70,$$C($P(BUDT6("P"),U,34)),!,BUD80L
 W !
 Q
T6SH ;
 W !,$$CTR("TABLE 6A-",80),!
 W $$CTR("SELECTED DIAGNOSES AND SERVICES RENDERED",80)
 W !,$TR($J("",80)," ","-")
 W !,?35,"Applicable",?54,"Number of",?69,"# of Pts"
 W !?35,"icd-9-cm",?54,"Visits by",?69,"w/this prim"
 W !?35,"code",?54,"prim dx",?70,"Dx"
 I BUDTYPE="D" W !,"DIAGNOSTIC CATEGORY",?60,"(a)",?75,"(b)"
 I BUDTYPE="S" W !,"SERVICE CATEGORY",?61,"(a)",?75,"(b)"
 W !,$TR($J("",80)," ","-"),!
 Q
T6SH1 ;
 W !,$$CTR("TABLE 6A-",80),!
 W $$CTR("SELECTED DIAGNOSES AND SERVICES RENDERED",80)
 W !,$TR($J("",80)," ","-")
 W !,?37,"Applicable",?54,"Number of",?70,"# of Pts"
 W !?37,"icd-9-cm or",?54,"Visits"
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
