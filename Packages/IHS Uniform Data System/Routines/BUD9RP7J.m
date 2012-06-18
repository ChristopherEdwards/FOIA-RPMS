BUD9RP7J ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;
 ;
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;general introductions
 D GENI^BUD9RP7I
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
HTR ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2009",80)
 W !!,"All Hypertension Patients by Race & Hispanic or Latino Identity (Table 7)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race and Hispanic or Latino identity of "
 W !,"patients age 18 to 85 years old who have had two medical visits during"
 W !,"the report period and were diagnosed with hypertension before June 30 "
 W !,"of the report period."
 W !
 Q
HTRL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D HTRH Q:BUDQUIT
 I '$D(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR")) W !!,"No patients to report." Q
 D HTRL1
 I $Y>(IOSL-3) D HTRH G:BUDQUIT HTRLX
 W !!,"TOTAL HTN PATIENTS 18-85 YEARS OLD: ",BUDTOT,!
HTRLX ;
 Q
HTRL1 ;
 I $Y>(IOSL-7) D HTRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D HTRL2
 Q
HTRL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUD9RP7I(BUDRACE,BUDETH)
 W !,BUDRACEL
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 ....W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,BUDA,!  ;,?51,$P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUD9RPTC(DFN)
 ....W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),1,19)
 ....S BUDHISV=$$HISP^BUD9RPTC(DFN)
 ....W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....S BUDALL=^XTMP("BUD9RP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"#",1)
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 .....I $E(BUDV)="P" W ?5,BUDV,! Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 I $Y>(IOSL-4) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 Q
HTRH ;
 G:'BUDGPG HTRH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HTRH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section B",80),!
 W !,$$CTR("Hypertension Patients by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race and Hispanic or Latino identity of all patients 18 to 85"
 .W !,"years old who have had two medical visits during the report period and"
 .W !,"were diagnosed with hypertension before June 30 of the report period."
 .W !,"June 30 of the report period.  The list displays the patient's most"
 .W !,"recent hypertension diagnosis before June 30 of the report period."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST HTN DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
HTCR ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2009",80)
 W !!,"All Hypertension Patients w/Controlled BP by Race and Hispanic or Latino Identity (Table 7)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race and Hispanic or Latino identity"
 W !,"of patients age 18 to 85 years old who have had two medical visits"
 W !,"during the report period, were diagnosed with hypertension before"
 W !,"June 30 of the report period, and who have controlled blood pressure "
 W !,"(<140/90 mm HG) during the report period."
 W !
 Q
HTCRL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D HTCRH Q:BUDQUIT
 I '$D(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR")) W !!,"No patients to report." Q
 D HTCRL1
 I $Y>(IOSL-3) D HTCRH G:BUDQUIT HTCRLX
 W !!,"TOTAL HTN PATIENTS 18+ W/CONTROLLED BP: ",BUDTOT,!
HTCRLX ;
 Q
HTCRL1 ;
 I $Y>(IOSL-7) D HTCRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D HTCRL2
 Q
HTCRL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUD9RP7I(BUDRACE,BUDETH)
 W !,BUDRACEL
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 ....W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,BUDA,!  ;,?51,$P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUD9RPTC(DFN)
 ....W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),1,19)
 ....S BUDHISV=$$HISP^BUD9RPTC(DFN)
 ....W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....S BUDALL=^XTMP("BUD9RP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....W ?5,$P(BUDALL,"^",2),!
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 .....I $E(BUDV)="P" W ?5,BUDV,! Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 I $Y>(IOSL-4) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 Q
HTCRH ;
 G:'BUDGPG HTCRH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HTCRH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section B",80)
 W !,$$CTR("Hypertension w/Controlled BP by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race of patients age 18 and older who have had two medical visits"
 .W !,"during the report period, who were diagnosed with hypertension before"
 .W !,"June 30 of the report period, and have controlled blood pressure"
 .W !,"(BP <140/90 mm Hg)."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST BP VALUE OR CD & DATE"
 W !?5,"LAST HTN DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
HTUR ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2009",80)
 W !!,"Hypertension w/Uncontrolled BP by Race and Hispanic or Latino Identity",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race and Hispanic or Latino Identity"
 W !,"of patients 18 to 85 years old who"
 W !,"have had two medical visits during the report period, were diagnosed"
 W !,"with hypertension before June 30 of the report period, and who do not have"
 W !,"controlled blood pressure (<140/90 mm HG) during the report period."
 W !
 Q
HTURL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D HTURH Q:BUDQUIT
 I '$D(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR")) W !!,"No patients to report." Q
 D HTURL1
 I $Y>(IOSL-3) D HTURH G:BUDQUIT HTURLX
 W !!,"TOTAL HTN PATIENTS 18+ W/UNCONTROLLED BP: ",BUDTOT,!
HTURLX ;
 Q
HTURL1 ;
 I $Y>(IOSL-7) D HTURH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D HTURL2
 Q
HTURL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUD9RP7I(BUDRACE,BUDETH)
 W !,BUDRACEL
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D HTURH Q:BUDQUIT  W !,BUDRACEL,!
 ....W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,BUDA,!  ;,?51,$P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUD9RPTC(DFN)
 ....W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUD9RPTC(DFN),U,3)_"-"_$P($$RACE^BUD9RPTC(DFN),U,4),1,19)
 ....S BUDHISV=$$HISP^BUD9RPTC(DFN)
 ....W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....S BUDALL=^XTMP("BUD9RP7",BUDJ,BUDH,"HTUR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"#",1)
 ....W ?5,$P(BUDALL,"#",2),!
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D HTURH Q:BUDQUIT  W !,BUDRACEL,!
 .....I $E(BUDV)="P" W ?5,BUDV,! Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2),C=$P(C,"^",1)
 .....W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 I $Y>(IOSL-4) D HTURH Q:BUDQUIT  W !,BUDRACEL,!
 W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 Q
HTURH ;
 G:'BUDGPG HTURH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HTURH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section B",80)
 W !,$$CTR("Hypertension w/Uncontrolled BP by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race and Hispanic or Latino Identity of all patients 18 to 85"
 .W !,"years old who have had two medical visits during the report period,"
 .W !,"who were diagnosed with hypertension before June 30 of the report"
 .W !,"period, and do not have controlled blood pressure (BP <140/90 mm Hg)."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST BP VALUE & DATE"
 W !?5,"LAST HTN DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
