BGPDS ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 Q:$G(BGPAREAA)
 S BGPQUIT="",BGPGPG=0
 S BGPL=0 F  S BGPL=$O(^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL)) Q:BGPL'=+BGPL!(BGPQUIT)  D
 .S BGPTITL=$P($T(@BGPL),";;",2),BGPTITL1=$P($T(@BGPL),";;",3),BGPCOUNT=0
 .D HEADER Q:BGPQUIT
 .S BGPCOM="" F  S BGPCOM=$O(^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL,BGPCOM)) Q:BGPCOM=""!(BGPQUIT)  D
 ..S BGPSEX="" F  S BGPSEX=$O(^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX)) Q:BGPSEX=""!(BGPQUIT)  D
 ...S BGPAGE="" F  S BGPAGE=$O(^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE)) Q:BGPAGE=""!(BGPQUIT)  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN)) Q:DFN'=+DFN!(BGPQUIT)  D PRINTL
 ....Q
 ...Q
 ..Q
 .I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 .W !!,"Total Number: ",BGPCOUNT
 .Q
 Q
PRINTL ;print one line
 I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 W !,$E($P(^DPT(DFN,0),U),1,22),?24,$$HRN^AUPNPAT(DFN,DUZ(2)),?31,$E(BGPCOM,1,15),?47,BGPSEX,?51,BGPAGE,?55,^XTMP("BGPD",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN)
 S BGPCOUNT=BGPCOUNT+1
 Q
 ;
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W !,$$CTR("***  IHS GPRA PERFORMANCE INDICATORS  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W $$CTR(X,80),!
 W $$CTR(BGPTITL,80),!
 I BGPTITL1]"" W $$CTR(BGPTITL1,80),!
 W "PATIENT NAME",?24,"HRN",?31,"COMMUNITY",?47,"SEX",?51,"AGE",?55,"VALUE"
 W !,$TR($J("",80)," ","-")
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
1 ;;Indicator 1:  Diabetes;;List of Patients with a Diabetes Diagnosis Ever
2 ;;Indicator 1B: Diabetes;;Lit of Patients with Diabetes Diagnosis in past year
3 ;;Indicator 2A: Diabetes Glycemic Control;;List of Patients in Denominator A & Hgb/Glucose Value
4 ;;Indicator 2B: Diabetes Glycemic Control;;List of Patients in Denominator B & Hgb/Glucose Value
5 ;;Indicator 2C: Diabetes Glycemic Control;;List of Patients in Denominator C & Hgb/Glucose Value
6 ;;Indicator 3A: Diabetes BP Control;;List of Patients in Denominator A & Mean BP
7 ;;Indicator 3B: Diabetes BP Control;;List of Patients in Denominator B & Mean BP
8 ;;Indicator 3C: Diabetes BP Control;;List of Patients in Denominator C & Mean BP
9 ;;Indicator 4A: Diabetes Dyslipidemia Assessment;;List of Patients in Denominator A & Dyslipidemia Assessment
10 ;;Indicator 4B: Diabetes Dyslipidemia Assessment;;List of Patients in Denominator B & Dyslipidemia Assessment
11 ;;Indicator 4C: Diabetes Dyslipidemia Assessment;;List of Patients in Denominator C & Dyslipidemia Assessment
12 ;;Indicator 5A: Diabetes Nephropathy Assessment;;List of Patients in Denominator A & Nephropathy Assessment
13 ;;Indicator 5B: Diabetes Nephropathy Assessment;;List of Patients in Denominator B & Nephropathy Assessment
14 ;;Indicator 5C: Diabetes Nephropathy Assessment;;List of Patients in Denominator C & Nephropathy Assessment
15 ;;Indicator 6:  Women's Health;;Listing of women 40 and over and whether they had a Pap Smear in past 1 yrs
16 ;;Indicator 6A: Women's Health;;List women 18-70 and whether they had a Pap Smear in past 3 yrs
17 ;;Indicator 7: Women's Health;;List of women 40-69 and whether they had a Mammogram w/in 2 years
18 ;;Indicator 8: Child Health;;List of Children turning 27 months old and their # of Well Child Visits
19 ;;Indicator 12: Oral health;;List of active users and date of ADA 0000 during time period
20 ;;Indicator 13:  Oral health;;List of patients 6-8 yrs and 14-15 yrs and Dental Sealant Status
21 ;;Indicator 14:  Oral Health;;List of Diabetic Patients and their Dental Service
22 ;;Indicator 22:  Listing of all Patients and their number of PHN Visits
23 ;;Indicator 23:  Child Health Immunizations;;List all Children turning 27 months of age and immunization status
24 ;;Indicator 24:  Adult Immunizations;;List of all Diabetic Patients >= 65 yrs old and Flu and Pneumovax Status
25 ;;Indicator 29:  Child Obesity;;List of all active patients and BMI
26 ;;Indicator 30:  Tobacco Prevention and Cessation;;List all 15-19 yr olds and 35-44 yr olds and Tobacco Use
27 ;;Indicator A:  Mental Health;;List all diabetics diagnosed with Depressive Disorders
28 ;;Indicator B:  Reduce Colorectal Cancer Death Rate;;List all patients >50 and FOB/DRE/SIG
29 ;;Indicator C:  Diet without Exercise Education;;List all active patients and Education provided
30 ;;Indicator D:  Diabetic Eye Exam;;List all Diabetic Patients and Eye exam status
