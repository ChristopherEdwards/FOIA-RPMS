BGPDL ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BGPGLIST
 Q
 ;; ;
EN ;EP -- main entry point for GPRA LIST DISPLAY
 D EN^VALM("BGP GPRA LIST SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS GPRA Performance Indicator Lists of Patients"
 S VALMHDR(2)="* indicates the list has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BGPGLIST S BGPHIGH=""
 S T="INDSL" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  D
 .I $D(BGPIND(J)) S BGPGLIST(J,0)=J_")",$E(BGPGLIST(J,0),5)=X,BGPGLIST("IDX",J,J)="" I $D(BGPLIST(J)) S BGPGLIST(J,0)="*"_BGPGLIST(J,0)
 .I '$D(BGPIND(J)) S BGPGLIST(J,0)=J_")",$E(BGPGLIST(J,0),5)="Indicator not selected for calculation-do not select",BGPGLIST("IDX",J,J)="" I $D(BGPLIST(J)) S BGPGLIST(J,0)="*"_BGPGLIST(J,0)
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
 S BGPGANS=Y,BGPGC="" F BGPGI=1:1 S BGPGC=$P(BGPGANS,",",BGPGI) Q:BGPGC=""  I $D(BGPIND(BGPGC)) S BGPLIST(BGPGC)=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH I $D(BGPIND(X)) S BGPLIST(X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPGANS=Y,BGPGC="" F BGPGI=1:1 S BGPGC=$P(BGPGANS,",",BGPGI) Q:BGPGC=""  K BGPLIST(BGPGC)
REMX ;
 D BACK
 Q
INDSL ;;
1 ;;1   Diabetes Prevalence - List of Patients with a Diabetes Diagnosis
2 ;;1B  Diabetes Prevalance - List of Patients w/DM DX in past year
3 ;;2A  Diabetes - List of Patients & HGB or Glucose Value (simple population)
4 ;;2B  Diabetes - List of Patients & HGB or Glucose Value (2 visits, 1st dx > 1 yr
5 ;;2C  Diabetes - List of Pats & HGB/Glucose (2 vis, >19 yrs old, creatinine <5)
6 ;;3A  Diabetes - List of Patients & Mean BP Value (simple population)
7 ;;3B  Diabetes - List of Patients & Mean BP Value (2 visits, 1st dx > 1 yr
8 ;;3C  Diabetes - List of Pats & Mean BP (2 vis, >19 yrs old, creatinine <5)
9 ;;4A  Diabetes - List of Patients & Dyslipidemia Assessment Value (simple population)
10 ;;4B  Diabetes - List of Patients & Dyslipidemia Assessment Value (2 visits, 1st dx > 1 yr
11 ;;4C  Diabetes - List of Pats & Dyslipidemia Assessment (2 vis, >19 yrs old, creatinine <5)
12 ;;5A  Diabetes - List of Patients & Nephropathy Assessment Value (simple population)
13 ;;5B  Diabetes - List of Patients & Nephropathy Assessment Value (2 visits, 1st dx > 1 yr
14 ;;5C  Diabetes - List of Pats & Nephropathy Assessment (2 vis, >19 yrs old, creatinine <5)
15 ;;6  Women's Health - List Women over (18-70) and Pap Smear within 1 year
16 ;;6A  Women's Health - List Women over (18-70) and Pap Smear within 3 years
17 ;;7  Women's Health - List Women 40-69 and Mammogram w/in 2 years
18 ;;8  Child Health - List of Children 27 mon old and # of Well Child Visits
19 ;;12 Oral Health - List active users and whether they had a Dental ADA Code 0000
20 ;;13 Oral Health - List of patients 6-8 and 14-15 and Sealants Status
21 ;;14 Oral Health - List all Diabetics and whether they had dental service
22 ;;22 Public Health Nursing - List of Patients and the Number of PHN visits
23 ;;23 Child Health Immunizations - List Children 27 months old and immunzation status
24 ;;24 Adult Immunizations - List Diabetic Patients >= 65 yrs old and Flu & Pneumovax
25 ;;29 Child Obesity - List all active patients over 2 and BMI
26 ;;30 Tobacco Prevention and Cessation - List 15-19 yr olds and 35-44 yr olds and smoking status
27 ;;A  Mental Health - List all Persons diagnoses with Diabetes and Depressive Disorder
28 ;;B  Reduce Colorectal Cancer Deaths - List all active users over 50 and FOBT test
29 ;;C  Increase the Proportion of persons provided education on Diet and Exercise
30 ;;D  Diabetic Eye Exam - List all diabetic patients and whether they had an eye exam
 ;;END
