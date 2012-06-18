BATLRP1 ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K ^TMP($J,"ASTHMA PATIENTS")
 Q
 ;; ;
EN ;EP -- main entry point for LIST OF PATIENTS
 K BATPATS
 D EN^VALM("BAT REMINDER LETTER LIST")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Patient List for Reminder Letter"
 S VALMHDR(2)="* indicates the patient has been selected"
 S VALMHDR(3)=" "
 S VALMHDR(4)="   PATIENT NAME",$E(VALMHDR(4),40)="HRN",$E(VALMHDR(4),48)="DOB",$E(VALMHDR(4),63)="LAST ASTHMA VISIT"
 ;
 Q
INIT ; -- init variables and list array
 K ^TMP($J,"ASTHMA PATIENTS") S BATHIGH="",BATCNT=0
 S BATP=0 F  S BATP=$O(^BATREG(BATP)) Q:BATP'=+BATP  D
 .Q:$$DOD^AUPNPAT(BATP)]""
 .I $P(^BATREG(BATP,0),U,2)'="A"&($P(^BATREG(BATP,0),U,2)'="U") Q
 .S BATL=$$LASTAV^BATU(BATP,2)
 .S BATD=$$FMDIFF^XLFDT(DT,BATL)
 .Q:BATD<180
 .S BATCNT=BATCNT+1
 .S X=BATCNT_")  "_$P(^DPT(BATP,0),U),$E(X,40)=$$HRN^AUPNPAT(BATP,DUZ(2)),$E(X,48)=$$FMTE^XLFDT($P(^DPT(BATP,0),U,3)),$E(X,63)=$$FMTE^XLFDT($$LASTAV^BATU(BATP,2))
 .I $D(BATPATS(BATCNT)) S X="*"_X
 .S ^TMP($J,"ASTHMA PATIENTS",BATCNT,0)=X,^TMP($J,"ASTHMA PATIENTS","IDX",BATCNT,BATCNT)=BATP
 .Q
 S (VALMCNT,BATHIGH)=BATCNT
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
ADD ;EP - add an patient to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_BATHIGH,DIR("A")="Which patient(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No patients selected." G ADDX
 I $D(DIRUT) W !,"No patients selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BATANS=Y,BATC="" F BATI=1:1 S BATC=$P(BATANS,",",BATI) Q:BATC=""  S BATPATS(BATC)=^TMP($J,"ASTHMA PATIENTS","IDX",BATC,BATC)
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BATHIGH S BATPATS(X)=^TMP($J,"ASTHMA PATIENTS","IDX",X,X)
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BATHIGH,DIR("A")="Which patient(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No patients selected." G ADDX
 I $D(DIRUT) W !,"No patients selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BATANS=Y,BATC="" F BATI=1:1 S BATC=$P(BATANS,",",BATI) Q:BATC=""  K BATPATS(BATC)
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
