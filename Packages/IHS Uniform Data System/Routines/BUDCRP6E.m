BUDCRP6E ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
REST6B ;EP
 I $Y>(IOSL-13) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION E - WEIGHT ASSESSMENT AND COUNSELING FOR CHILDREN AND ADOLESCENTS"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?45,"|",?65,"|",?67,"PATIENTS WITH",!
 W "CHILD AND ADOLESCENT",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"COUNSELING",!
 W "WEIGHT ASSESSMENT",?23,"|",?26,"AGED 3 - 17 ON",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"AND BMI",!
 W "AND COUNSELING",?23,"|",?26,"DECEMBER 31",?45,"|",?47,"TOTAL",?65,"|",?67,"DOCUMENTED",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"12",?5,"MEASURE: Children",?23,"|",?45,"|",?65,"|",!
 W ?5,"and adolescents",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 3 - 17 during",?23,"|",?45,"|",?65,"|",!
 W ?5,"measurement year",?23,"|",?45,"|",?65,"|",!
 W ?5,"(on or prior to 31",?23,"|",?45,"|",?65,"|",!
 W ?5,"December) with a",?23,"|",?45,"|",?65,"|",!
 W ?5,"BMI percentile, ",?23,"|",?30,$$C($G(BUDSECTE("PTS"))),?45,"|",?50,$$C($G(BUDSECTE("PTS"))),?65,"|",?70,$$C($G(BUDSECTE("AWT"))),!
 W ?5,"and counseling on",?23,"|",?45,"|",?65,"|",!
 W ?5,"nutrition and",?23,"|",?45,"|",?65,"|",!
 W ?5,"physical activity",?23,"|",?45,"|",?65,"|",!
 W ?5,"documented for the",?23,"|",?45,"|",?65,"|",!
 W ?5,"current year",?23,"|",?45,"|",?65,"|",!
 D LINE
 ;SECTION F
 I $Y>(IOSL-13) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION F - ADULT WEIGHT SCREENING AND FOLLOW-UP"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?45,"|",?65,"|",?67,"PATIENTS WITH",!
 W ?23,"|",?45,"|",?65,"|",?67,"BMI CHARTED",!
 W ?23,"|",?45,"|",?65,"|",?67,"AND FOLLOW-UP",!
 W "ADULT WEIGHT SCREENING",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"PLAN DOCU-",!
 W "AND FOLLOW-UP",?23,"|",?26,"AGED 18 AND",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"MENTED AS",!
 W "",?23,"|",?26,"OLDER",?45,"|",?47,"TOTAL",?65,"|",?67,"APPROPRIATE",!
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
 I $Y>(IOSL-13) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION G - TOBACCO USE SCREENING AND CESSATION INTERVENTION"),!
 D LINE
 W ?23,"|",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"PATIENTS",!
 W "TOBACCO USE SCREENING",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ASSESSED FOR",!
 W "AND CESSATION",?23,"|",?26,"AGED 18 AND",?45,"|",?47,"TOTAL",?65,"|",?67,"TOBACCO USE",!
 W "INTERVENTION",?23,"|",?26,"OLDER",?45,"|",?65,"|",?67,"AND PROVIDED",!
 W ?23,"|",?45,"|",?65,"|",?67,"INTERVENTION",!
 W ?23,"|",?45,"|",?65,"|",?67,"IF A TOBACCO",!
 W ?23,"|",?45,"|",?65,"|",?67,"USER",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"14a",?5,"MEASURE: Patients",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 18 and older ",?23,"|",?45,"|",?65,"|",!
 W ?5,"(1) were screened",?23,"|",?45,"|",?65,"|",!
 W ?5,"for tobacco use",?23,"|",?45,"|",?65,"|",!
 W ?5,"one or more times",?23,"|",?45,"|",?65,"|",!
 W ?5,"in the measurement",?23,"|",?45,"|",?65,"|",!
 W ?5,"year or the prior",?23,"|",?45,"|",?65,"|",!
 W ?5,"year AND",?23,"|",?45,"|",?65,"|",!
 W ?5,"(2) for those",?23,"|",?45,"|",?65,"|",!
 W ?5,"found to be a",?23,"|",?45,"|",?65,"|",!
 W ?5,"tobacco user, ",?23,"|",?30,$$C($G(BUDSECG1("PTS"))),?45,"|",?50,$$C($G(BUDSECG1("PTS"))),?65,"|",?70,$$C($G(BUDSECG1("ABM"))),!
 W ?5,"received cessation",?23,"|",?45,"|",?65,"|",!
 W ?5,"counseling",?23,"|",?45,"|",?65,"|",!
 W ?5,"intervention",?23,"|",?45,"|",?65,"|",!
 W ?5,"or medication",?23,"|",?45,"|",?65,"|",!
 D LINE
H ;SECTION H
 I $Y>(IOSL-17) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION H - ASTHMA PHARMACOLOGIC THERAPY"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"AGED 5 - 40",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"PATIENTS WITH",!
 W "ASTHMA PHARMACOLOGIC",?23,"|",?26,"WITH PERSISTENT",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"ACCEPTABLE",!
 W "THERAPY",?23,"|",?26,"ASTHMA",?45,"|",?47,"TOTAL",?65,"|",?67,"PLAN",!
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
 I $Y>(IOSL-17) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION I - CORONARY ARTERY DISEASE (CAD): LIPID THERAPY"),!
 D LINE
 W "CORONARY ARTERY",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "DISEASE (CAD):",?23,"|",?26,"18 AND OLDER",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"PATIENTS ",!
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
 I $Y>(IOSL-20) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION J - ISCHEMIC VASCULAR DISEASE (IVD): ASPIRIN OR ANTITHROMBOTIC THERAPY"),!
 D LINE
 W "ISCHEMIC VASCULAR",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "DISEASE (IVD):",?23,"|",?26,"18 AND OLDER WITH",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS ",!
 W "ASPIRIN OR",?23,"|",?26,"IVD DIAGNOSIS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"WITH ASPIRIN",!
 W "OTHER",?23,"|",?26,"OR AMI, CABG, OR",?45,"|",?47,"TOTAL",?65,"|",?67,"OR OTHER ",!
 W "ANTITHROMBOTIC",?23,"|",?26,"PTCA PROCEDURE",?45,"|",?47,"",?65,"|",?67,"ANTITHROMBOTIC",!
 W "THERAPY",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"THERAPY",!
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
 I $Y>(IOSL-20) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION K - COLORECTAL CANCER SCREENING"),!
 D LINE
 W ?23,"|",?26,"TOTAL PATIENTS",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "",?23,"|",?26,"51 TO 74",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS WITH",!
 W "COLORECTAL CANCER",?23,"|",?26,"YEARS OF AGE",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"APPROPRIATE",!
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
L ;
 I $Y>(IOSL-23) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION L - HIV LINKAGE TO CARE"),!
 D LINE
 W ?23,"|",?26,"TOTAL",?45,"|",?65,"|",?67,"NUMBER OF",!
 W "HIV LINKAGE",?23,"|",?26,"PATIENTS FIRST",?45,"|",?47,"CHARTS",?65,"|",?67,"PATIENTS ",!
 W "TO CARE",?23,"|",?26,"DIAGNOSED",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"SEEN WITHIN",!
 W "",?23,"|",?26,"WITH HIV",?45,"|",?47,"TOTAL",?65,"|",?67,"90 DAYS OF",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"FIRST ",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"DIAGNOSIS",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"OF HIV",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"20",?5,"MEASURE: Patients",?23,"|",?45,"|",?65,"|",!
 W ?5,"whose first ever",?23,"|",?45,"|",?65,"|",!
 W ?5,"HIV diagnosis was",?23,"|",?45,"|",?65,"|",!
 W ?5,"made by health",?23,"|",?45,"|",?65,"|",!
 W ?5,"center staff ",?23,"|",?45,"|",?65,"|",!
 W ?5,"between October 1",?23,"|",?45,"|",?65,"|",!
 W ?5,"and September 30",?23,"|",?45,"|",?65,"|",!
 W ?5,"of the measurement",?23,"|",?45,"|",?65,"|",!
 W ?5,"year and who were",?23,"|"
 W ?30,$$C($G(BUDSECTL("PTS"))),?45,"|",?50,$$C($G(BUDSECTL("PTS"))),?65,"|",?70,$$C($G(BUDSECTL("HIV"))),!
 W ?5,"seen for follow-up",?23,"|",?45,"|",?65,"|",!
 W ?5,"treatment within",?23,"|",?45,"|",?65,"|",!
 W ?5,"90 days of that",?23,"|",?45,"|",?65,"|",!
 W ?5,"first ever",?23,"|",?45,"|",?65,"|",!
 W ?5,"diagnosis",?23,"|",?45,"|",?65,"|",!
 D LINE
M ;
 I $Y>(IOSL-23) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION M - PATIENTS SCREENED FOR DEPRESSION AND FOLLOW-UP"),!
 D LINE
 W ?23,"|",?26,"",?45,"|",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?26,"",?45,"|",?65,"|",?67,"PATIENTS",!
 W "PATIENTS SCREENED",?23,"|",?26,"",?45,"|",?47,"CHARTS",?65,"|",?67,"SCREENED FOR",!
 W "FOR DEPRESSION",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"DEPRESSION",!
 W "AND FOLLOW-UP",?23,"|",?26,"AGED 12 AND",?45,"|",?47,"TOTAL",?65,"|",?67,"AND FOLLOW-UP",!
 W "",?23,"|",?26,"OLDER",?45,"|",?47,"",?65,"|",?67,"PLAN",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"DOCUMENTED AS",!
 W "",?23,"|",?26,"",?45,"|",?47,"",?65,"|",?67,"APPROPRIATE",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"21",?5,"MEASURE: Patients",?23,"|",?45,"|",?65,"|",!
 W ?5,"aged 12 and older",?23,"|",?45,"|",?65,"|",!
 W ?5,"who were (1) ",?23,"|",?45,"|",?65,"|",!
 W ?5,"screened for ",?23,"|",?45,"|",?65,"|",!
 W ?5,"depression with a",?23,"|",?45,"|",?65,"|",!
 W ?5,"standardized tool",?23,"|",?45,"|",?65,"|",!
 W ?5,"AND IF SCREENING",?23,"|",?45,"|",?65,"|",!
 W ?5,"WAS POSITIVE (2)",?23,"|"
 W ?30,$$C($G(BUDSECTM("PTS"))),?45,"|",?50,$$C($G(BUDSECTM("PTS"))),?65,"|",?70,$$C($G(BUDSECTM("DEP"))),!
 W ?5,"had a follow-up",?23,"|",?45,"|",?65,"|",!
 W ?5,"plan documented",?23,"|",?45,"|",?65,"|",!
 D LINE
N ;
 I $Y>(IOSL-23) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION N - DENTAL SEALANTS"),!
 D LINE
 W "",?23,"|",?26,"TOTAL PATIENTS",?45,"|",?47,"CHARTS",?65,"|",?67,"NUMBER OF",!
 W "DENTAL SEALANTS",?23,"|",?26,"AGED 6 THROUGH",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"PATIENTS",!
 W "",?23,"|",?26,"9 IDENTIFIED AS",?45,"|",?47,"TOTAL",?65,"|",?67,"WITH",!
 W "",?23,"|",?26,"MODERATE TO",?45,"|",?47,"",?65,"|",?67,"SEALANTS",!
 W "",?23,"|",?26,"HIGH RISK",?45,"|",?47,"",?65,"|",?67,"TO FIRST",!
 W "",?23,"|",?26,"FOR CARIES",?45,"|",?47,"",?65,"|",?67,"MOLARS",!
 W "",?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"22",?5,"MEASURE: Children",?23,"|",?45,"|",?65,"|",!
 W ?5,"age 6-9 years",?23,"|",?45,"|",?65,"|",!
 W ?5,"at moderate to",?23,"|",?45,"|",?65,"|",!
 W ?5,"high risk of",?23,"|",?45,"|",?65,"|",!
 W ?5,"caries who",?23,"|",?45,"|",?65,"|",!
 W ?5,"received a",?23,"|",?45,"|",?65,"|",!
 W ?5,"sealant on a",?23,"|"
 W ?30,$$C($G(BUDSECTN("PTS"))),?45,"|",?50,$$C($G(BUDSECTN("PTS"))),?65,"|",?70,$$C($G(BUDSECTN("SEAL"))),!
 W ?5,"permanent first",?23,"|",?45,"|",?65,"|",!
 W ?5,"molar tooth",?23,"|",?45,"|",?65,"|",!
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
