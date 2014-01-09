BUD1RP6E ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2011 8:09 PM 14 Dec 2011 1:24 PM ; 
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
REST6B ;EP
 I $Y>(IOSL-13) D HEADER^BUD1RPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION E - WEIGHT ASSESSMENT AND COUNSELING FOR CHILDREN AND ADOLESCENTS"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?45,"|",?65,"|",?67,"PATIENTS WITH",!
 W "CHILD AND ADOLESCENT",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"CHARTS",?65,"|",?67,"COUNSELING",!
 W "",?23,"|",?26,"AGED 3 - 17 ON",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"AND BMI",!
 W "WEIGHT ASSESSMENT",?23,"|",?26,"DECEMBER 31",?45,"|",?47,"TOTAL",?65,"|",?67,"DOCUMENTED",!
 W "AND COUNSELING",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"12",?5,"Children and",?23,"|",?45,"|",?65,"|",!
 W ?5,"adolescents aged",?23,"|",?45,"|",?65,"|",!
 W ?5,"2 - 17 with a BMI",?23,"|",?45,"|",?65,"|",!
 W ?5,"percentile, and",?23,"|",?30,$$C($G(BUDSECTE("PTS"))),?45,"|",?50,$$C($G(BUDSECTE("PTS"))),?65,"|",?70,$$C($G(BUDSECTE("AWT"))),!
 W ?5,"counseling on",?23,"|",?45,"|",?65,"|",!
 W ?5,"nutrition and",?23,"|",?45,"|",?65,"|",!
 W ?5,"physical activity",?23,"|",?45,"|",?65,"|",!
 W ?5,"documented for the",?23,"|",?45,"|",?65,"|",!
 W ?5,"current year",?23,"|",?45,"|",?65,"|",!
 D LINE
 ;SECTION F
 I $Y>(IOSL-13) D HEADER^BUD1RPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION F - ADULT WEIGHT SCREENING AND FOLLOW-UP"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?45,"|",?65,"|",?67,"PATIENTS WITH",!
 W ?23,"|",?45,"|",?65,"|",?67,"BMI CHARTED",!
 W ?23,"|",?45,"|",?65,"|",?67,"AND FOLLOW-UP",!
 W "ADULT WEIGHT SCREENING",?23,"|",?26,"",?45,"|",?47,"CHARTS",?65,"|",?67,"PLAN DOCU-",!
 W "AND FOLLOW-UP",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"MENTED AS",!
 W "",?23,"|",?26,"18 AND OVER",?45,"|",?47,"TOTAL",?65,"|",?67,"APPROPRIATE",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"13",?5,"Patients aged 18",?23,"|",?45,"|",?65,"|",!
 W ?5,"and over with (1)",?23,"|",?45,"|",?65,"|",!
 W ?5,"BMI charted and",?23,"|",?45,"|",?65,"|",!
 W ?5,"(2) follow-up plan",?23,"|",?30,$$C($G(BUDSECTF("PTS"))),?45,"|",?50,$$C($G(BUDSECTF("PTS"))),?65,"|",?70,$$C($G(BUDSECTF("PLAN"))),!
 W ?5,"documented if",?23,"|",?45,"|",?65,"|",!
 W ?5,"patients are",?23,"|",?45,"|",?65,"|",!
 W ?5,"overweight or",?23,"|",?45,"|",?65,"|",!
 W ?5,"underweight",?23,"|",?45,"|",?65,"|",!
 ;W ?5,"current year",?23,"|",?45,"|",?65,"|",!
 D LINE
G1 ;SECTION G1
 I $Y>(IOSL-13) D HEADER^BUD1RPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION G1 - TOBACCO USE ASSESSMENT"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS",!
 W "TOBACCO ASSESSMENT",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ASSESSED FOR",!
 W "",?23,"|",?26,"18 AND OVER",?45,"|",?47,"TOTAL",?65,"|",?67,"TOBACCO USE",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"14",?5,"Patients queried",?23,"|",?45,"|",?65,"|",!
 W ?5,"about tobacco",?23,"|",?45,"|",?65,"|",!
 W ?5,"use one of more",?23,"|",?45,"|",?65,"|",!
 W ?5,"times in the",?23,"|",?30,$$C($G(BUDSECG1("PTS"))),?45,"|",?50,$$C($G(BUDSECG1("PTS"))),?65,"|",?70,$$C($G(BUDSECG1("ABM"))),!
 W ?5,"measurement",?23,"|",?45,"|",?65,"|",!
 W ?5,"year or prior",?23,"|",?45,"|",?65,"|",!
 W ?5,"year",?23,"|",?45,"|",?65,"|",!
 D LINE
G2 ;SECTION G2
 I $Y>(IOSL-13) D HEADER^BUD1RPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION G2 - TOBACCO CESSATION INTERVENTION"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"WITH DIAGNOSED",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS",!
 W "TOBACCO CESSATION",?23,"|",?26,"TOBACCO",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ADVISED",!
 W "INTERVENTION",?23,"|",?26,"DEPENDENCE",?45,"|",?47,"TOTAL",?65,"|",?67,"TO QUIT",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"15",?5,"Tobacco users",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 18 and",?23,"|",?45,"|",?65,"|",!
 W ?5,"above who have",?23,"|",?45,"|",?65,"|",!
 W ?5,"received",?23,"|",?30,$$C($G(BUDSECG2("PTS"))),?45,"|",?50,$$C($G(BUDSECG2("PTS"))),?65,"|",?70,$$C($G(BUDSECG2("ATOB"))),!
 W ?5,"cessation advise",?23,"|",?45,"|",?65,"|",!
 W ?5,"or medication",?23,"|",?45,"|",?65,"|",!
 ;W ?5,"year",?23,"|",?45,"|",?65,"|",!
 D LINE
H ;SECTION H
 I $Y>(IOSL-13) D HEADER^BUD1RPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION H - ASTHMA PHARMACOLOGICAL THERAPY"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"AGED 5 - 40",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS WITH",!
 W "ASTHMA TREATMENT PLAN",?23,"|",?26,"WITH PERSISTENT",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ACCEPTABLE",!
 W "",?23,"|",?26,"ASTHMA",?45,"|",?47,"TOTAL",?65,"|",?67,"PLAN",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"16",?5,"Patients aged 5",?23,"|",?45,"|",?65,"|",!
 W ?5,"through 40",?23,"|",?45,"|",?65,"|",!
 W ?5,"diagnosed with",?23,"|",?45,"|",?65,"|",!
 W ?5,"persistent asthma",?23,"|",?30,$$C($G(BUDSECTH("PTS"))),?45,"|",?50,$$C($G(BUDSECTH("PTS"))),?65,"|",?70,$$C($G(BUDSECTH("APT"))),!
 W ?5,"who have an",?23,"|",?45,"|",?65,"|",!
 W ?5,"acceptable",?23,"|",?45,"|",?65,"|",!
 W ?5,"pharmacological",?23,"|",?45,"|",?65,"|",!
 W ?5,"treatment plan",?23,"|",?45,"|",?65,"|",!
 D LINE
 Q
T6BH ;
 W !,$$CTR("TABLE 6B - QUALITY OF CARE INDICATORS"),!,$$REPEAT^XLFSTR("_",79),!
 Q
LINE ;
 W $$REPEAT^XLFSTR("_",79),!
 Q
LINE1 ;
 W $$REPEAT^XLFSTR("_",45),"|",$$REPEAT^XLFSTR("_",33),!
 Q
LINE2 ;
 W $$REPEAT^XLFSTR("_",37),"|",$$REPEAT^XLFSTR("_",22),"|",$$REPEAT^XLFSTR("_",18),!
 Q
LINE3 ;
 W $$REPEAT^XLFSTR("_",23),"|",$$REPEAT^XLFSTR("_",21),"|",$$REPEAT^XLFSTR("_",19),"|",$$REPEAT^XLFSTR("_",13),!
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
NRY ;
 W !!,"not developed yet....." H 3
 Q
PAUSE ;
  K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
  Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "********"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
