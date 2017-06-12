BUDCRP7L ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
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
DMR ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients w/DM by Race and Hispanic or Latino Identity (Table 7)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race of patients age 18 to 75 years old who"
 W !,"have had two medical visits during the report period, with a diagnosis"
 W !,"of Type I or Type II diabetes anytime through the end of the report"
 W !,"period, and without a diagnosis of polycystic ovaries, gestational"
 W !,"diabetes, or steroid-induced diabetes."
 W !
 Q
DMRL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DMRH Q:BUDQUIT
 I '$D(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR")) S X="No patients to report." W:BUDROT="P" !!,X D:BUDROT="D" S(),S(X) Q
 D DMRL1
 I BUDROT="P",$Y>(IOSL-3) D DMRH G:BUDQUIT DMRLX
 I BUDROT="P" W !!,"TOTAL DIABETES PATIENTS 18-75 BY RACE AND HISPANIC OR LATINO IDENTITY: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL DIABETES PATIENTS 18-75 BY RACE AND HISPANIC OR LATINO IDENTITY: "_BUDTOT)
DMRLX ;
 Q
DMRL1 ;
 I BUDROT="P",$Y>(IOSL-7) D DMRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D DMRL2
 Q
DMRL2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUDCRP7I(BUDRACE,BUDETH)
 I BUDROT="P" W !,BUDRACEL
 I BUDROT="D" D S(BUDRACEL)
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DMRH Q:BUDQUIT  W !,BUDRACEL,!
 ....I BUDROT="P" W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,$P(^DPT(DFN,0),U,2),?51,BUDA,!  ;
 ....I BUDROT="D" S BUDPV="",BUDPV=$E($P(^DPT(DFN,0),U,1),1,30)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_BUDA
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUDCRPTC(DFN),U,3)_"-"_$P($$RACE^BUDCRPTC(DFN),U,4),1,19)
 ....I BUDROT="D" S BUDPV=BUDPV_U_$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3)_")"
 ....S BUDHISV=$$HISP^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDHISV,U,3)_" ("_$P(BUDHISV,U,2)_")"
 ....S BUDALL=^XTMP("BUDCRP7",BUDJ,BUDH,"DMR",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I BUDROT="P",$Y>(IOSL-3) D DMRH Q:BUDQUIT  W !,BUDRACEL,!
 .....I BUDROT="P" I $E(BUDV)="P" W ?5,BUDV,! Q
 .....I BUDROT="D" I $E(BUDV)="P" S BUDPV=BUDPV_U_BUDV Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....I BUDROT="P" W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 .....I BUDROT="D" S X=BUDPV_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))_U_C_U_$$PRIMPROV^APCLV(V,"D")_U_$P(^AUPNVSIT(V,0),U,7)_U_$$CLINIC^APCLV(V,"C")_U_$$VAL^XBDIQ1(9000010,V,.06) D S(X)
 I BUDROT="P",$Y>(IOSL-4) D DMRH Q:BUDQUIT  W !,BUDRACEL,!
 I BUDROT="P" W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 I BUDROT="D" D S("Sub-TOtal "_BUDRACEL_":  "_BUDSTOT)
 Q
DMRHD ;
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 7, Section C, Diabetes Patients by Race and Hispanic or Latino Identity")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List by race and Hispanic or Latino identity of all patients 18 to 75 years ")
 D S("old who have had two medical visits during the report period and were diagnosed")
 D S("with Type I or Type II diabetes anytime through the end of the report period.")
 D S("Age is calculated as of December 31.")
 D S("* E - denotes the value was obtained from the Ethnicity field.")
 D S("  R - denotes the value was obtained from the Race field")
 D S("  C - denotes the value was obtained from the Classification/Beneficiary field")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^HISPANIC OR LATINO IDENTITY^LAST DM DATE^DX OR SVC CD^PROV TYPE^SVC CAT^CLINIC^LOCATION")
 Q
DMRH ;
 I BUDROT="D" D DMRHD Q
 G:'BUDGPG DMRH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DMRH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section C",80)
 W !,$$CTR("Diabetes Patients by Race and Hispanic or Latino Identity",80),!  ;, DM Patients by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race and Hispanic or Latino identity of all patients 18 to 75 years "
 .W !,"old who have had two medical visits during the report period and were diagnosed"
 .W !,"with Type I or Type II diabetes anytime through the end of the report period."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST DM DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
DMR1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients w/DM and A1c <8 by Race and Hispanic or Latino Identity (Table 7)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list by race and Hispanic or Latino Identity"
 W !,"of patients age 18 to 75 years old who have had two"
 W !,"medical visits during the report period, with a diagnosis"
 W !,"of Type I or Type II diabetes anytime through the end of the report"
 W !,"period, and without a diagnosis of polycystic ovaries, gestational diabetes,"
 W !,"or steroid-induced diabetes and with a most recent hemoglobin A1c of less"
 W !,"than 8%."
 W !
 Q
DMR1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DMR1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1")) S X="No patients to report." W:BUDROT="P" !!,X D:BUDROT="D" S(),S(X) Q
 D DMR1L1
 I BUDROT="P",$Y>(IOSL-3) D DMR1H G:BUDQUIT DMR1LX
 I BUDROT="P" W !!,"TOTAL DIABETES PTS 18-75 W/A1C <8% BY RACE & HISPANIC OR LATINO IDENTITY: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL DIABETES PTS 18-75 W/A1C <8% BY RACE & HISPANIC OR LATINO IDENTITY: "_BUDTOT)
DMR1LX ;
 Q
DMR1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D DMR1H Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D
 .S BUDETH="" F  S BUDETH=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH)) Q:BUDETH=""!(BUDQUIT)  D DMR1L2
 Q
DMR1L2 ;
 S BUDSTOT=0
 S BUDRACEL=$$RACEL^BUDCRP7I(BUDRACE,BUDETH)
 I BUDROT="P" W !,BUDRACEL
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDA="" F  S BUDA=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH,BUDCOM,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 ..S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DMR1H Q:BUDQUIT  W !,BUDRACEL,!
 ....I BUDROT="P" W !?2,$E($P(^DPT(DFN,0),U,1),1,20),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,10),?47,$P(^DPT(DFN,0),U,2),?51,BUDA,!  ;
 ....I BUDROT="D" S BUDPV="",BUDPV=$E($P(^DPT(DFN,0),U,1),1,30)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_BUDA
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....S BUDRACV=$$RACE^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?2,$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3),")"  ;,?60,$E($P($$RACE^BUDCRPTC(DFN),U,3)_"-"_$P($$RACE^BUDCRPTC(DFN),U,4),1,19)
 ....I BUDROT="D" S BUDPV=BUDPV_U_$E($P(BUDRACV,U,4),1,16)_" ("_$P(BUDRACV,U,3)_")"
 ....S BUDHISV=$$HISP^BUDCRPTC(DFN)
 ....I BUDROT="P" W ?24,$P(BUDHISV,U,3)," (",$P(BUDHISV,U,2),")",!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDHISV,U,3)_" ("_$P(BUDHISV,U,2)_")"
 ....S BUDALL=^XTMP("BUDCRP7",BUDJ,BUDH,"DMR1",BUDRACE,BUDETH,BUDCOM,BUDA,BUDNAME,DFN)
 ....S BUDPPV=$P(BUDALL,"^",1)
 ....I BUDROT="P" W ?5,$P(BUDALL,"^",2),!
 ....I BUDROT="D" S BUDPV=BUDPV_U_$P(BUDALL,"^",2)
 ....F BUDX=1:1 S BUDV=$P(BUDPPV,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I BUDROT="P",$Y>(IOSL-3) D DMR1H Q:BUDQUIT  W !,BUDRACEL,!
 .....I BUDROT="P",$E(BUDV)="P" W ?5,BUDV,! Q
 .....I BUDROT="D",$E(BUDV)="P" S BUDPV=BUDPV_U_BUDV D S(BUDPV) Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....I BUDROT="P" W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?19,C,?35,$$PRIMPROV^APCLV(V,"D"),?45,$P(^AUPNVSIT(V,0),U,7),?53,$$CLINIC^APCLV(V,"C"),?65,$E($$VAL^XBDIQ1(9000010,V,.06),1,15),!
 .....I BUDROT="D" S X=BUDPV_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))_U_C_U_$$PRIMPROV^APCLV(V,"D")_U_$P(^AUPNVSIT(V,0),U,7)_U_$$CLINIC^APCLV(V,"C")_U_$$VAL^XBDIQ1(9000010,V,.06) D S(X)
 I BUDROT="P",$Y>(IOSL-4) D DMR1H Q:BUDQUIT  W !,BUDRACEL,!
 I BUDROT="P" W !,"Sub-Total ",BUDRACEL,":  ",BUDSTOT,!
 I BUDROT="D" D S("Sub-TOtal "_BUDRACEL_":  "_BUDSTOT)
 Q
DMR1HD ;
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 7, Section C, Diabetes w/A1c <8 by Race and Hispanic or Latino Identity")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List by race and Hispanic or Latino identity of all patients 18 to 75 years")
 D S("old who have had two medical visits during the report period and were diagnosed")
 D S("with Type I or Type II diabetes anytime through the end of the report period ")
 D S("and whose most recent hemoglobin A1c is <8%.")
 D S("Age is calculated as of December 31.")
 D S("* E - denotes the value was obtained from the Ethnicity field.")
 D S("  R - denotes the value was obtained from the Race field")
 D S("  C - denotes the value was obtained from the Classification/Beneficiary field")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^HISPANIC OR LATINO IDENTITY^LAST A1C VALUE OR CD & DATE^LAST DM DATE^DX OR SVC CD^PROV TYPE^SVC CAT^CLINIC^LOCATION")
 Q
DMR1H ;
 I BUDROT="D" D DMR1HD Q
 G:'BUDGPG DMR1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DMR1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 7, Section C",80)
 W !,$$CTR("Diabetes w/A1c <8 by Race and Hispanic or Latino Identity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List by race and Hispanic or Latino identity of all patients 18 to 75 years"
 .W !,"old who have had two medical visits during the report period and were diagnosed"
 .W !,"with Type I or Type II diabetes anytime through the end of the report period "
 .W !,"and whose most recent hemoglobin A1c is <8%."
 .W !,"Age is calculated as of December 31."
 .W !,"* E - denotes the value was obtained from the Ethnicity field."
 .W !,"  R - denotes the value was obtained from the Race field"
 .W !,"  C - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !?2,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?47,"SEX",?51,"AGE"
 W !?2,"RACE*",?24,"HISPANIC OR LATINO IDENTITY*"
 W !?5,"LAST A1C VALUE OR CD & DATE"
 W !?5,"LAST DM DATE",?19,"DX OR SVC CD",?35,"PROV TYPE",?45,"SVC CAT",?53,"CLINIC",?65,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
