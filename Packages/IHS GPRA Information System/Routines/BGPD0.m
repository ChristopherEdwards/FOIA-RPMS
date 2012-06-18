BGPD0 ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BGPTIND
 Q
 ;; ;
EN ;EP -- main entry point for APCH HMR DISPLAY
 D EN^VALM("BGP GPRA INDICATOR SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS GPRA Performance Indicators"
 S VALMHDR(2)="* indicates the indicator has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BGPTIND S BGPHIGH=""
 S T="INDSL" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  S BGPTIND(J,0)=J_")",$E(BGPTIND(J,0),5)=X,BGPTIND("IDX",J,J)="" I $D(BGPIND(J)) S BGPTIND(J,0)="*"_BGPTIND(J,0)
 S (VALMCNT,BGPHIGH)=J-1
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPIND(BGPC)=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH S BGPIND(X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  K BGPIND(BGPC)
REMX ;
 D BACK
 Q
INDSL ;;
1 ;;1   Indicator 1:  Diabetes Prevalence
2 ;;1B  Indicator 1B: Diabetes Prevalence using # seen w/Diabetes in past year
3 ;;2A  Indicator 2A: Diabetes-Glycemic Control (simple Population)
4 ;;2B  Indicator 2B: Diabetes-Glycemic Control (2 visits & first Dx > 1 yr)
5 ;;2C  Indicator 2C: Diabetes-Glycemic Control (2 visits, >19 yrs, creatinine <5)
6 ;;3A  Indicator 3A: Diabetes-Blood Pressure Control (simple Population)
7 ;;3B  Indicator 3B: Diabetes-Blood Pressure Control (2 visits & first Dx > 1 yr)
8 ;;3C  Indicator 3C: Diabetes-Blood Pressure Control (2 visits, >19 yrs, creatinine <5)
9 ;;4A  Indicator 4A: Diabetes-Assessed for Dyslipidemia (simple Population)
10 ;;4B  Indicator 4B: Diabetes-Assessed for Dyslipidemia (2 visits & first Dx > 1 yr)
11 ;;4C  Indicator 4C: Diabetes-Assessed for Dyslipidemia (2 visits, >19 yrs, creatinine <5)
12 ;;5A  Indicator 5A: Diabetes-Assessed for Nephropathy (simple Population)
13 ;;5B  Indicator 5B: Diabetes-Assessed for Nephropathy (2 visits & first Dx > 1 yr)
14 ;;5C  Indicator 5C: Diabetes-Assessed for Nephropathy (2 visits, >19 yrs, creatinine <5)
15 ;;6   Indicator 6: Women's Health - Pap Smear in past one year
16 ;;6a  Indicator 6A: Women's Health - Pap Smear in past 3 years
17 ;;7   Indicator 7: Women's Health - Reduce Breast Cancer - Mammogram w/in 2 years
18 ;;8   Indicator 8: Child Health - Children 27 months old with 4 Well Child Visits
19 ;;12  Indicator 12: Oral Health - All patients with access to Dental Services
20 ;;13  Indicator 13:  Oral Health - All Patients 6-8 and 14-15 With Dental Sealants
21 ;;14  Indicator 14:  Oral Health Status - All Diabetics with access to Dental Services
22 ;;22  Indicator 22:  Public Health Nursing Visits
23 ;;23  ****NOT AVAILABLE in 2002 GPRA
24 ;;24  Indicator 24: Adult Immunizations-Pneumovax and Flu Vaccine Diabetics >65 yrs
25 ;;29  Indicator 29:  Obesity
26 ;;30  Indicator 30: Tobacco Prevention and Cessation
27 ;;A   Indicator A: Improve Mental Health
28 ;;B   Indicator B: Reduce Colorectal Cancer Death Rate
29 ;;C   Indicator C: Increase Proportion of Persons Provided Diet and Exercise Instruction
30 ;;D   Indicator D: Evaluate the proportion of Diabetics receiving Yearly Eye Exam
 ;;END
 Q
