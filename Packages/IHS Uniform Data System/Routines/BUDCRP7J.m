BUDCRP7J ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
 ;----------
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;general introductions
 D GENI^BUDCRP7I
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
 W !,$$CTR("UDS 2015",80)
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
 I '$D(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR")) S X="No patients to report." W:BUDROT="P" !!,X D:BUDROT="D" S(),S(X) Q
 D HTRL1
 I BUDROT="P",$Y>(IOSL-3) D HTRH G:BUDQUIT HTRLX
 S X="TOTAL HTN PATIENTS 18-85 YEARS OLD: "_BUDTOT
 I BUDROT="P" W !!,X,!
 I BUDROT="D" D S(),S(X)
HTRLX ;
 Q
HTRL1 ;
 I BUDROT="P",$Y>(IOSL-7) D HTRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D HTRL2
 Q
HTRL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUDCRP7I(BUDRACE,BUDETH)
 I BUDROT="P" W !,BUDRACEL
 I BUDROT="D" D S(BUDRACEL)
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 ....I BUDROT="P" W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,$P(^DPT(DFN,0),U,2),?51,BUDA,!
 ....I BUDROT="D" S BUDPV="",BUDPV=$E($P(^DPT(DFN,0),U,1),1,30)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_BUDA
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUDCRPTC(DFN),U,3)_"-"_$P($$RACE^BUDCRPTC(DFN),U,4),1,19)
 ....I BUDROT="D" S BUDPV=BUDPV_U_$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3)_")"
 ....S BUDHISV=$$HISP^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDHISV,U,3)_" ("_$P(BUDHISV,U,2)_")"
 ....S BUDALL=^XTMP("BUDCRP7",BUDJ,BUDH,"HTR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....;W ?5,$P(BUDALL,"^",2),!
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I BUDROT="P",$Y>(IOSL-3) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 .....I BUDROT="P" I $E(BUDV)="P" W ?5,BUDV,! Q
 .....I BUDROT="D" I $E(BUDV)="P" S BUDPV=BUDPV_U_BUDV Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....I BUDROT="P" W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 .....I BUDROT="D" S X=BUDPV_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))_U_C_U_$$PRIMPROV^APCLV(V,"D")_U_$P(^AUPNVSIT(V,0),U,7)_U_$$CLINIC^APCLV(V,"C")_U_$$VAL^XBDIQ1(9000010,V,.06) D S(X)
 I BUDROT="P",$Y>(IOSL-4) D HTRH Q:BUDQUIT  W !,BUDRACEL,!
 I BUDROT="P" W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 I BUDROT="D" D S("Sub-Total "_BUDRACEL_":  "_BUDSTOT)
 Q
HTRHD ;
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 7, Section B, Hypertension Patients by Race and Hispanic or Latino Identity")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List by race and Hispanic or Latino identity of all patients 18 to 85")
 D S("years old who have had two medical visits during the report period and")
 D S("were diagnosed with hypertension before June 30 of the report period.")
 D S("The list displays the patient's most recent hypertension diagnosis ")
 D S("before June 30 of the report period.")
 D S("Age is calculated as of December 31.")
 D S("* E - denotes the value was obtained from the Ethnicity field.")
 D S("  R - denotes the value was obtained from the Race field")
 D S("  C - denotes the value was obtained from the Classification/Beneficiary field")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^HISPANIC OR LATINO IDENTITY^VISIT DATE^DX OR SVC CD^PROV TYPE^SVC CAT^CLINIC^LOCATION")
 Q
HTRH ;
 I BUDROT="D" D HTRHD Q
 G:'BUDGPG HTRH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
HTRH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section B",80)
 W !,$$CTR("Hypertension Patients by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race and Hispanic or Latino identity of all patients 18 to 85"
 .W !,"years old who have had two medical visits during the report period and"
 .W !,"were diagnosed with hypertension before June 30 of the report period."
 .W !,"The list displays the patient's most recent hypertension diagnosis "
 .W !,"before June 30 of the report period."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST HTN DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
HTCR ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
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
 I '$D(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR")) S X="No patients to report." W:BUDROT="P" !!,X D:BUDROT="D" S(),S(X) Q
 D HTCRL1
 I BUDROT="P",$Y>(IOSL-3) D HTCRH G:BUDQUIT HTCRLX
 S X="TOTAL HTN PATIENTS 18+ W/CONTROLLED BP: "_BUDTOT
 I BUDROT="P" W !!,X,!
 I BUDROT="D" D S(),S(X)
HTCRLX ;
 Q
HTCRL1 ;
 I BUDROT="P",$Y>(IOSL-7) D HTCRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D HTCRL2
 Q
HTCRL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUDCRP7I(BUDRACE,BUDETH)
 I BUDROT="P" W !,BUDRACEL
 I BUDROT="D" D S(BUDRACEL)
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 ....I BUDROT="P" W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,$P(^DPT(DFN,0),U,2),?51,BUDA,!
 ....I BUDROT="D" S BUDPV="",BUDPV=$E($P(^DPT(DFN,0),U,1),1,30)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_BUDA
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUDCRPTC(DFN),U,3)_"-"_$P($$RACE^BUDCRPTC(DFN),U,4),1,19)
 ....I BUDROT="D" S BUDPV=BUDPV_U_$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3)_")"
 ....S BUDHISV=$$HISP^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDHISV,U,3)_" ("_$P(BUDHISV,U,2)_")"
 ....S BUDALL=^XTMP("BUDCRP7",BUDJ,BUDH,"HTCR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....I BUDROT="P" W ?5,$P(BUDALL,"^",2),!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDALL,"^",2)
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I BUDROT="P",$Y>(IOSL-3) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 .....I BUDROT="P" I $E(BUDV)="P" W ?5,BUDV,! Q
 .....I BUDROT="D",$E(BUDV)="P" S BUDPV=BUDPV_U_BUDV D S(BUDPV) Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....I BUDROT="P" W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 .....I BUDROT="D" S X=BUDPV_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))_U_C_U_$$PRIMPROV^APCLV(V,"D")_U_$P(^AUPNVSIT(V,0),U,7)_U_$$CLINIC^APCLV(V,"C")_U_$$VAL^XBDIQ1(9000010,V,.06) D S(X)
 I BUDROT="P",$Y>(IOSL-4) D HTCRH Q:BUDQUIT  W !,BUDRACEL,!
 I BUDROT="P" W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 I BUDROT="D" D S("Sub-Total "_BUDRACEL_":  "_BUDSTOT)
 Q
HTCRHD ;
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 7, Section B, Hypertension w/Controlled BP by Race and Hispanic or Latino Identity")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List by race and Hispanic or Latino identity of all patients age 18 to 85 ")
 D S("years old who have had two medical visits during the report period, who were ")
 D S("diagnosed with hypertension before June 30 of the report period, and have ")
 D S("controlled blood pressure (BP <140/90 mm Hg).")
 D S("Age is calculated as of December 31.")
 D S("* E - denotes the value was obtained from the Ethnicity field.")
 D S("  R - denotes the value was obtained from the Race field")
 D S("  C - denotes the value was obtained from the Classification/Beneficiary field")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^HISPANIC OR LATINO IDENTITY^LAST BP VALUE OR CD & DATE^LAST HTN DATE^DX OR SVC CD^PROV TYPE^SVC CAT^CLINIC^LOCATION")
 Q
HTCRH ;
 I BUDROT="D" D HTCRHD Q
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
 .W !,"List by race and Hispanic or Latino identity of all patients age 18 to 85 "
 .W !,"years old who have had two medical visits during the report period, who were "
 .W !,"diagnosed with hypertension before June 30 of the report period, and have "
 .W !,"controlled blood pressure (BP <140/90 mm Hg)."
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
