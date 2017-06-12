BUDARP6E ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 30 Dec 2013 8:09 PM 14 Dec 2013 1:24 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
REST6B ;EP
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION E - WEIGHT ASSESSMENT AND COUNSELING FOR CHILDREN AND ADOLESCENTS"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?45,"|",?65,"|",?67,"PATIENTS WITH",!
 W "CHILD AND ADOLESCENT",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"CHARTS",?65,"|",?67,"COUNSELING",!
 W "",?23,"|",?26,"AGED 3 - 17 ON",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"AND BMI",!
 W "WEIGHT ASSESSMENT",?23,"|",?26,"DECEMBER 31",?45,"|",?47,"TOTAL",?65,"|",?67,"DOCUMENTED",!
 W "AND COUNSELING",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"12",?5,"MEASURE: Children",?23,"|",?45,"|",?65,"|",!
 W ?5,"and adolescents",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 3 - 17 with a",?23,"|",?45,"|",?65,"|",!
 W ?5,"BMI percentile, ",?23,"|",?30,$$C($G(BUDSECTE("PTS"))),?45,"|",?50,$$C($G(BUDSECTE("PTS"))),?65,"|",?70,$$C($G(BUDSECTE("AWT"))),!
 W ?5,"and counseling on",?23,"|",?45,"|",?65,"|",!
 W ?5,"nutrition and",?23,"|",?45,"|",?65,"|",!
 W ?5,"physical activity",?23,"|",?45,"|",?65,"|",!
 W ?5,"documented for the",?23,"|",?45,"|",?65,"|",!
 W ?5,"current year",?23,"|",?45,"|",?65,"|",!
 D LINE
 ;SECTION F
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
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
 W ?1,"13",?5,"MEASURE: Patients ",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 18 and over",?23,"|",?45,"|",?65,"|",!
 W ?5,"with (1) BMI ",?23,"|",?45,"|",?65,"|",!
 W ?5,"charted and (2) ",?23,"|",?30,$$C($G(BUDSECTF("PTS"))),?45,"|",?50,$$C($G(BUDSECTF("PTS"))),?65,"|",?70,$$C($G(BUDSECTF("PLAN"))),!
 W ?5,"follow-up plan ",?23,"|",?45,"|",?65,"|",!
 W ?5,"documented if ",?23,"|",?45,"|",?65,"|",!
 W ?5,"patients are ",?23,"|",?45,"|",?65,"|",!
 W ?5,"overweight or ",?23,"|",?45,"|",?65,"|",!
 W ?5,"underweight",?23,"|",?45,"|",?65,"|",!
 D LINE
G1 ;SECTION G1
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION G1 - TOBACCO USE ASSESSMENT"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS",!
 W "TOBACCO ASSESSMENT",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ASSESSED FOR",!
 W "",?23,"|",?26,"18 AND OVER",?45,"|",?47,"TOTAL",?65,"|",?67,"TOBACCO USE",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"14",?5,"MEASURE: Patients",?23,"|",?45,"|",?65,"|",!
 W ?5,"queried about ",?23,"|",?45,"|",?65,"|",!
 W ?5,"tobacco use one ",?23,"|",?45,"|",?65,"|",!
 W ?5,"or more times ",?23,"|",?30,$$C($G(BUDSECG1("PTS"))),?45,"|",?50,$$C($G(BUDSECG1("PTS"))),?65,"|",?70,$$C($G(BUDSECG1("ABM"))),!
 W ?5,"in the measurement",?23,"|",?45,"|",?65,"|",!
 W ?5,"year or prior",?23,"|",?45,"|",?65,"|",!
 W ?5,"year",?23,"|",?45,"|",?65,"|",!
 D LINE
G2 ;SECTION G2
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION G2 - TOBACCO CESSATION INTERVENTION"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"WITH DIAGNOSED",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS",!
 W "TOBACCO CESSATION",?23,"|",?26,"TOBACCO",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ADVISED",!
 W "INTERVENTION",?23,"|",?26,"DEPENDENCE",?45,"|",?47,"TOTAL",?65,"|",?67,"TO QUIT",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"15",?5,"MEASURE: Tobacco ",?23,"|",?45,"|",?65,"|",!
 W ?5,"users aged 18 and",?23,"|",?45,"|",?65,"|",!
 W ?5,"above who have",?23,"|",?45,"|",?65,"|",!
 W ?5,"received",?23,"|",?30,$$C($G(BUDSECG2("PTS"))),?45,"|",?50,$$C($G(BUDSECG2("PTS"))),?65,"|",?70,$$C($G(BUDSECG2("ATOB"))),!
 W ?5,"cessation advice",?23,"|",?45,"|",?65,"|",!
 W ?5,"or medication",?23,"|",?45,"|",?65,"|",!
 ;W ?5,"year",?23,"|",?45,"|",?65,"|",!
 D LINE
H ;SECTION H
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION H - ASTHMA PHARMACOLOGICAL THERAPY"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"AGED 5 - 40",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS WITH",!
 W "ASTHMA TREATMENT PLAN",?23,"|",?26,"WITH PERSISTENT",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ACCEPTABLE",!
 W "",?23,"|",?26,"ASTHMA",?45,"|",?47,"TOTAL",?65,"|",?67,"PLAN",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"16",?5,"MEASURE: Patients ",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 5 through 40",?23,"|",?45,"|",?65,"|",!
 W ?5,"diagnosed with",?23,"|",?45,"|",?65,"|",!
 W ?5,"persistent asthma",?23,"|",?30,$$C($G(BUDSECTH("PTS"))),?45,"|",?50,$$C($G(BUDSECTH("PTS"))),?65,"|",?70,$$C($G(BUDSECTH("APT"))),!
 W ?5,"who have an",?23,"|",?45,"|",?65,"|",!
 W ?5,"acceptable",?23,"|",?45,"|",?65,"|",!
 W ?5,"pharmacological",?23,"|",?45,"|",?65,"|",!
 W ?5,"treatment plan",?23,"|",?45,"|",?65,"|",!
 D LINE
I ;SECTION I
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION I - CORONARY ARTERY DISEASE: LIPID THERAPY"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"18 AND OLDER",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS ",!
 W "LIPID THERAPY",?23,"|",?26,"WITH CAD",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"PRESCRIBED",!
 W "",?23,"|",?26,"DIAGNOSIS",?45,"|",?47,"TOTAL",?65,"|",?67,"A LIPID LOW-",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"ERING THERAPY",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"17",?5,"MEASURE: Patients ",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 18 and older",?23,"|",?45,"|",?65,"|",!
 W ?5,"with a diagnosis ",?23,"|",?45,"|",?65,"|",!
 W ?5,"of CAD prescribed",?23,"|",?30,$$C($G(BUDSECTI("PTS"))),?45,"|",?50,$$C($G(BUDSECTI("PTS"))),?65,"|",?70,$$C($G(BUDSECTI("CAD"))),!
 W ?5,"a lipid lowering",?23,"|",?45,"|",?65,"|",!
 W ?5,"therapy",?23,"|",?45,"|",?65,"|",!
 D LINE
J ;SECTION I
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION J - ISCHEMIC VASCULAR DISEASE: ASPIRIN OR ANTITHROMBOTIC THERAPY"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"18 AND OLDER WITH",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS ",!
 W "ASPIRIN OR",?23,"|",?26,"IVD DIAGNOSIS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"WITH ASPIRIN",!
 W "ANTITHROMBOTIC",?23,"|",?26,"OR AMI, CABG, OR",?45,"|",?47,"TOTAL",?65,"|",?67,"OR ANTITHROM-",!
 W "THERAPY",?23,"|",?26,"PTCA PROCEDURE",?45,"|",?47,"",?65,"|",?67,"BOTIC THERAPY",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"18",?5,"MEASURE: Patients ",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 18 and older",?23,"|",?45,"|",?65,"|",!
 W ?5,"with a diagnosis",?23,"|",?45,"|",?65,"|",!
 W ?5,"of IVD or AMI, ",?23,"|",?30,$$C($G(BUDSECTJ("PTS"))),?45,"|",?50,$$C($G(BUDSECTJ("PTS"))),?65,"|",?70,$$C($G(BUDSECTJ("IVD"))),!
 W ?5,"CABG, or PTCA ",?23,"|",?45,"|",?65,"|",!
 W ?5,"procedure with ",?23,"|",?45,"|",?65,"|",!
 W ?5,"aspirin or another",?23,"|",?45,"|",?65,"|",!
 W ?5,"antithrombotic ",?23,"|",?45,"|",?65,"|",!
 W ?5,"therapy",?23,"|",?45,"|",?65,"|",!
 D LINE
K ;SECTION I
 I $Y>(IOSL-13) D HEADER^BUDARPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION K - COLORECTAL CANCER SCREENING"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"51 TO 74",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS WITH",!
 W "COLORECTAL CANCER",?23,"|",?26,"YEARS OLD",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"APPROPRIATE",!
 W "SCREENING",?23,"|",?26,"",?45,"|",?47,"TOTAL",?65,"|",?67,"SCREENING FOR",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"COLORECTAL",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"CANCER",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"19",?5,"MEASURE: Patients",?23,"|",?45,"|",?65,"|",!
 W ?5,"age 51 through ",?23,"|",?45,"|",?65,"|",!
 W ?5,"74 years of age ",?23,"|",?45,"|",?65,"|",!
 W ?5,"during the ",?23,"|",?45,"|",?65,"|",!
 W ?5,"measurement year ",?23,"|",?45,"|",?65,"|",!
 W ?5,"(on or prior to 31",?23,"|",?45,"|",?65,"|",!
 W ?5,"December) with ",?23,"|",?45,"|",?65,"|",!
 W ?5,"appropriate",?23,"|"
 W ?30,$$C($G(BUDSECTK("PTS"))),?45,"|",?50,$$C($G(BUDSECTK("PTS"))),?65,"|",?70,$$C($G(BUDSECTK("CRC"))),!
 W ?5,"screening for",?23,"|",?45,"|",?65,"|",!
 W ?5,"colorectal cancer",?23,"|",?45,"|",?65,"|",!
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
