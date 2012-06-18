APCLCARP ; IHS/CMI/LAB - california gpra print ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
PRINT ;
 S APCLPG=0
 S APCLQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
SECT2 ;
 D HEADER2
 S APCLP=0 F APCLX=60:1:70,74 D  Q:APCLQUIT
 .S APCLP=APCLP+1
 .I $Y>(IOSL-4) D HEADER Q:APCLQUIT  D HEADER2
 .S APCLT=$P($T(@APCLX),";;",2)
 .W !!?1,APCLX,?5,APCLT,?60,$$C($P($G(^XTMP("APCLCAR",APCLJ,APCLH,2)),U,APCLP),0,8)
 Q:APCLQUIT
 I $Y>(IOSL-4) D HEADER Q:APCLQUIT  D HEADER2
 W !,$TR($J("",80)," ","_")
 W !?1,"75",?5,"Totals",?60,$$C($P($G(^XTMP("APCLCAR",APCLJ,APCLH,2)),U,14),0,8)
SECT21 ;
 D HEADER Q:APCLQUIT
 D HEADER21
 S APCLP=14 F APCLX=80:1:90,94 D  Q:APCLQUIT
 .S APCLP=APCLP+1
 .I $Y>(IOSL-4) D HEADER Q:APCLQUIT  D HEADER21
 .S APCLT=$P($T(@APCLX),";;",2)
 .W !!?1,APCLX,?5,APCLT,?60,$$C($P($G(^XTMP("APCLCAR",APCLJ,APCLH,2)),U,APCLP),0,8)
 Q:APCLQUIT
 I $Y>(IOSL-7) D HEADER Q:APCLQUIT  D HEADER21
 W !,$TR($J("",80)," ","_")
 W !?1,"90",?5,"Totals",?60,$$C($P($G(^XTMP("APCLCAR",APCLJ,APCLH,2)),U,30),0,8)
 I APCLNPRV D
 .W !!,"NOTE:  There were ",APCLNPRV," visits on which the primary provider",!,"did not fit into any of the above categories.",!
 .W !,"A list of these providers appears on the following page.",!
 .D HEADER
 .Q:APCLQUIT
 .D HEADERUN
 .S APCLC="" F  S APCLC=$O(^XTMP("APCLCARUNCAT",APCLJ,APCLH,APCLC)) Q:APCLC=""!(APCLQUIT)  D
 ..S APCLV="" F  S APCLV=$O(^XTMP("APCLCARUNCAT",APCLJ,APCLH,APCLC,APCLV)) Q:APCLV=""!(APCLQUIT)  D
 ...I $Y>(IOSL-3) D HEADER Q:APCLQUIT  D HEADERUN
 ...W !,APCLV,?35,$$VAL^XBDIQ1(7,APCLC,9999999.01)," - ",$$VAL^XBDIQ1(7,APCLC,.01)
 Q:APCLQUIT
RACE ;
 D HEADER
 Q:APCLQUIT
 W !!,"PATIENT DEMOGRAPHICS - SECTION 3"
 W !!,"RACE",!,"LINE",?45,"(1)"
 W !,"NO.",?40,"No. of Patients"
 W !,$TR($J("",80)," ","-")
 W !?3,"1",?7,"White",?40,$$C($G(APCLRACE(1)),0,9)
 W !?3,"2",?7,"Black",?40,$$C($G(APCLRACE(2)),0,9)
 W !?3,"3",?7,"American Indian/Alaskan Native",?40,$$C($G(APCLRACE(3)),0,9)
 W !?3,"4",?7,"Asian/Pacific Islander",?40,$$C($G(APCLRACE(4)),0,9)
 W !?3,"9",?7,"Other/Unknown",?40,$$C($G(APCLRACE(9)),0,9)
 W !?3,"10",?7,"Total Patients",?40,$$C($G(APCLRACE(10)),0,9)
 W !!,$TR($J("",80)," ","-")
ETHNIC ;
 D HEADER
 Q:APCLQUIT
 W !!,"PATIENT DEMOGRAPHICS - SECTION 3"
 W !!,"ETHNICITY",!,"LINE",?45,"(1)"
 W !,"NO.",?40,"No. of Patients"
 W !,$TR($J("",80)," ","-")
 W !?3,"11",?7,"Hispanic",?40,$$C($G(APCLETH(11)),0,9)
 W !?3,"12",?7,"Non-Hispanic",?40,$$C($G(APCLETH(12)),0,9)
 W !?3,"13",?7,"Unknown",?40,$$C($G(APCLETH(13)),0,9)
 W !?3,"15",?7,"Total Patients",?40,$$C($G(APCLRACE(10)),0,9)
 W !!,$TR($J("",80)," ","-")
POVERTY ;
 D HEADER
 Q:APCLQUIT
 W !!,"PATIENT DEMOGRAPHICS - SECTION 3"
 W !!,"FEDERAL POVERTY LEVEL"
 W !,"LINE",?45,"(1)",!,"NO.",?45,"PATIENTS"
 W !,$TR($J("",80)," ","-")
 W !?3,"20",?7,"Under 100%",?40,$$C($G(APCLINC("UNDER 100%")),0,9)
 W !?3,"21",?7,"100-200%",?40,$$C($G(APCLINC("100-200%")),0,9)
 W !?3,"22",?7,"Above 200%",?40,$$C($G(APCLINC("ABOVE 200%")),0,9)
 W !?3,"23",?7,"Unknown",?40,$$C($G(APCLINC("UNKNOWN/UNREPORTED")),0,9)
 W !?3,"24",?7,"Total Patients",?40,$$C($G(APCLRACE(10)),0,9)
 W !!,$TR($J("",80)," ","-")
 Q:APCLQUIT
AGE ;
 D HEADER
 Q:APCLQUIT
 W !!,"PATIENT DEMOGRAPHICS - SECTION 3"
 W !?5,"AGE CATEGORIES"
 W !,"LINE",?40,"(1)",?55,"(2)"
 W !,"NO.",?40,"MALES",?55,"FEMALES"
 W !,$TR($J("",80)," ","-")
 W !?3,"40",?7,"Under 1 year",?40,$$C($P($G(APCLAGEG("Under 1 year")),U,1),0,9),?55,$$C($P($G(APCLAGEG("Under 1 year")),U,2),0,9)
 W !?3,"41",?7,"1-4 years",?40,$$C($P($G(APCLAGEG("1-4 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("1-4 years")),U,2),0,9)
 W !?3,"42",?7,"5-12 years",?40,$$C($P($G(APCLAGEG("5-12 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("5-12 years")),U,2),0,9)
 W !?3,"43",?7,"13-14 years",?40,$$C($P($G(APCLAGEG("13-14 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("13-14 years")),U,2),0,9)
 W !?3,"44",?7,"15-19 years",?40,$$C($P($G(APCLAGEG("15-19 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("15-19 years")),U,2),0,9)
 W !?3,"45",?7,"20-34 years",?40,$$C($P($G(APCLAGEG("20-34 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("20-34 years")),U,2),0,9)
 W !?3,"46",?7,"35-44 years",?40,$$C($P($G(APCLAGEG("35-44 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("35-44 years")),U,2),0,9)
 W !?3,"47",?7,"45-64 years",?40,$$C($P($G(APCLAGEG("45-64 years")),U,1),0,9),?55,$$C($P($G(APCLAGEG("45-64 years")),U,2),0,9)
 W !?3,"48",?7,"65 and over",?40,$$C($P($G(APCLAGEG("65 and over")),U,1),0,9),?55,$$C($P($G(APCLAGEG("65 and over")),U,2),0,9)
 W !!?3,"55",?7,"Total Patients",?40,$$C($G(APCLSEX(1)),0,9),?55,$$C($G(APCLSEX(2)),0,9)
 W !!,$TR($J("",80)," ","-")
SECT4 ;
 D HEADER Q:APCLQUIT
 D HEADER3
 S APCLP=0 F APCLX=1:1:19,21 D  Q:APCLQUIT
 .S APCLP=APCLP+1
 .I $Y>(IOSL-4) D HEADER Q:APCLQUIT  D HEADER3
 .S APCLT=$P($T(@APCLX),";;",2)
 .W !!?1,APCLX,?5,APCLT,?60,$P($T(@APCLX),";;",3),?70,$$C($G(APCLS4(APCLX)),0,8)
 Q:APCLQUIT
 I $Y>(IOSL-4) D HEADER Q:APCLQUIT  D HEADER3
 W !,$TR($J("",80)," ","_")
 W !?1,"25",?5,"Totals",?70,$$C($G(APCLS4(25)),0,9)
SECT5 ;
 D ^APCLCARQ
 ;cpt list
 I 'APCLQUIT,APCLCPTR D PCPT^APCLCART
 K ^XTMP("APCLCAR",APCLJ,APCLH)
 K ^XTMP("APCLCARUNCAT",APCLJ,APCLH),APCLJ,APCLH
 Q
HEADER3 ;
 W !,"SECTION 4",!,"ENCOUNTERS BY PRINCIPAL DIAGNOSIS"
 W !?72,"(1)"
 W !,"LINE",?5,"Classification of Diseases and/or Injuries",?71,"NO. OF"
 W !,"NO.",?5,"for each Principal Diagnosis",?60,"ICD-9",?70,"Encounters"
 W !,$TR($J("",80)," ","-")
 Q
HEADER2 ;
 W !,"SECTION 2",!,"FTEs AND ENCOUNTERS BY PRIMARY CARE PROVIDER    Column 5 - No. of Encounters"
 W !?63,"(5)"
 W !,"LINE",?62,"NO. OF"
 W !,"NO.",?5,"PRIMARY CARE PROVIDERS",?60,"ENCOUNTERS"
 W !,$TR($J("",80)," ","-")
 Q
HEADER21 ;
 W !,"SECTION 2",!,"FTEs AND CONTACTS BY PRIMARY CARE PROVIDER    Column 5 - No. of Contacts"
 W !?62,"(5)"
 W !,"LINE",?61,"NO. OF"
 W !,"NO.",?5,"PRIMARY CARE PROVIDERS",?60,"CONTACTS"
 W !,$TR($J("",80)," ","-")
 Q
HEADERUN ;
 W !!,"LISTING OF PROVIDERS WHO WERE NOT CATEGORIZED INTO ANY OF THE LINES ABOVE."
 W !!,"PROVIDER",?35,"PROVIDER CLASS"
 W !,$TR($J("",80)," ","-")
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
V(R,N,P) ;
 Q $P($G(^APCLCAAR(R,N)),U,P)
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0) Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  CALIFORNIA ANNUAL UTILIZATION REPORT OF PRIMARY CARE CLINICS, 2008  ***",80),!
 ;W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 I '$D(APCLLOCT) S X="ALL LOCATIONS OF ENCOUNTER SELECTED" W $$CTR(X,80),!
 I $D(APCLLOCT) D
 .S X="Locations Selected:"
 .S Y=0 F  S Y=$O(APCLLOCT(Y)) Q:Y'=+Y  S X=X_"  "_$P(^DIC(4,Y,0),U)
 .W X,!
 S X="Reporting Period: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
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
 ;;
 ;;LINE LABELS
60 ;;Physicians
61 ;;Physician Assistants
62 ;;Family Nurse Practitioners
63 ;;Certified Nurse Midwives
64 ;;Visiting Nurses
65 ;;Dentists
66 ;;Registered Dental Hygenists (Alternative Practice)
67 ;;Psychiatrist
68 ;;Clincial Psychologist
69 ;;Licensed Clinical Social Worker (LCSW)
70 ;;Other Providers billable to Medi-Cal**
74 ;;Other Certified CPSP providers not listed above
 ;;
80 ;;Registered Dental Hygenists
81 ;;Registered Dental Assistants
82 ;;Dental Assistants - Not licensed
83 ;;Marriage and Family Therapists (MFT)
84 ;;Registered Nurses
85 ;;Licensed Vocational Nurses
86 ;;Medical Assistants - Not licensed
87 ;;Non-Licensed Patient Education Staff
88 ;;Substance Abuse Counselors
89 ;;Billing Staff
90 ;;Other Administrative Staff
94 ;;Other Providers not listed above
 ;;
1 ;;Infectious and Parasitic Diseases;;001-139
2 ;;Neoplasms;;140-239
3 ;;Endocrine, Nutritional, Metabolic, Immunity;;240-279
4 ;;Blood and Blood Forming Disorders;;280-289
5 ;;Mental Disorders;;290-319
6 ;;Nervous System and Sense Organs Diseases;;320-389
7 ;;Circulatory System Diseases;;390-459
8 ;;Respiratory System Diseases;;460-519
9 ;;Digestive System Diseases;;530-579
10 ;;Geniourinary System Diseases;;580-629
11 ;;Pregnancy, Childbirth & the Puerperium;;630-679
12 ;;Skin and Subcutaneous Tissue Diseases;;680-709
13 ;;Musculoskeletal and Connective Tissue Dis;;710-739
14 ;;Congenital Anomalies;;740-759
15 ;;Certain Conditions Originating/Perinatal;;760-779
16 ;;Symptoms, Signs, and Ill-defined Cond;;780-799
17 ;;Injury and Poisoning;;800-999
18 ;;Factors Influencing Health Status;;V01-V89
19 ;;Dental Diagnoses;;Clinic=56
20 ;;Family Planning S-codes
21 ;;Other
 ;;
