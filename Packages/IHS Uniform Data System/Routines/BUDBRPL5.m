BUDBRPL5 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
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
T4IPPL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D T4IPPH Q:BUDQUIT
 I '$D(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL")) W !!,"No patients to report." Q
 D T4IPPL1
 I $Y>(IOSL-3) D T4IPPH G:BUDQUIT T4IPPLX
 W !!,"TOTAL PATIENTS: ",BUDTOT,!
T4IPPLX ;
 Q
T4IPPL1 ;
 I $Y>(IOSL-7) D T4IPPH Q:BUDQUIT
 S BUDTOT=0
 S BUDINCI="" F  S BUDINCI=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI)) Q:BUDINCI=""!(BUDQUIT)  D
 .S BUDINC="" F  S BUDINC=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI,BUDINC)) Q:BUDINC=""!(BUDQUIT)  D T4IPPL2
 Q
T4IPPL2 ;
 S BUDSTOT=0
 W !,"Income as Percent of Poverty Level: ",BUDINC,!
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI,BUDINC,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI,BUDINC,BUDCOM,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ..S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI,BUDINC,BUDCOM,BUDSEX,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4IPPL",BUDINCI,BUDINC,BUDCOM,BUDSEX,BUDAGE,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T4IPPH Q:BUDQUIT  W !,"Income as Percent of Poverty Level: ",BUDINC,!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))
 ....W ?36,$E(BUDCOM,1,13),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD)
 ....W !?5,BUDINC
 I $Y>(IOSL-4) D T4IPPH Q:BUDQUIT
 W !!,"Sub-Total Line ",BUDINCI," ",BUDINC,":  ",BUDSTOT,!
 Q
T4IPPH ;
 G:'BUDGPG T4IPPH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T4IPPH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 4, Income As Percent of Poverty Level",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients with an income percent"
 .W !,"of poverty level (=<100%, 101-150%, 151-200%, >200%, Unknown) during"
 .W !,"the report period."
 .W !,"Age is calculated as of June 30."
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE"
 W !,?5,"INCOME PERCENT OF POVERTY LEVEL"
 ;W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;----------
T4PMIS ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D T4PMIH Q:BUDQUIT
 I '$D(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS")) W !!,"No patients to report." Q
 D T4PMIS1
 I $Y>(IOSL-3) D T4PMIH G:BUDQUIT T4PMISX
 W !!,"TOTAL PATIENTS: ",BUDTOT,!
T4PMISX ;
 Q
T4PMIS1 ;
 I $Y>(IOSL-7) D T4PMIH Q:BUDQUIT
 S BUDTOT=0
 S BUDINCI="" F  S BUDINCI=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI)) Q:BUDINCI=""!(BUDQUIT)  D
 .S BUDINC="" F  S BUDINC=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI,BUDINC)) Q:BUDINC=""!(BUDQUIT)  D T4PMIS2
 Q
T4PMIS2 ;
 S BUDSTOT=0
 W !,"Principle Third Party Medical Insurance Source: ",BUDINC,!
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI,BUDINC,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI,BUDINC,BUDAGE,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI,BUDINC,BUDAGE,BUDCOM,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4PMIS",BUDINCI,BUDINC,BUDAGE,BUDCOM,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T4PMIH Q:BUDQUIT  W !,"Principle Third Party Medical Insurance Source: ",BUDINC,!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))
 ....W ?36,$E(BUDCOM,1,13),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD)
 ....W !?5,BUDINC
 I $Y>(IOSL-4) D T4PMIH Q:BUDQUIT
 W !!,"Sub-Total Line ",$S(BUDINCI=8.1:"8a",BUDINCI=8.2:"8b",BUDINCI=10.1:"10a",BUDINCI=10.2:"10b",1:BUDINCI)," ",BUDINC,":  ",BUDSTOT,!
 Q
T4PMIH ;
 G:'BUDGPG T4PMIH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T4PMIH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 4",80)
 W !,$$CTR("Principle Third Party Medical Insurance Source",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients and the type of medical insurance"
 .W !,"the patient has during the report period, if any."
 .W !,"Age is calculated as of June 30."
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE"
 W !,?5,"PRINCIPLE THIRD PARTY MEDICAL INSURANCE SOURCE"
 ;W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;----------
T4CHAR ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D T4CHAH Q:BUDQUIT
 I '$D(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR")) W !!,"No patients to report." Q
 D T4CHAR1
 I $Y>(IOSL-3) D T4CHAH G:BUDQUIT T4CHARX
 W !!,"TOTAL PATIENTS: ",BUDTOT,!
T4CHARX ;
 Q
T4CHAR1 ;
 I $Y>(IOSL-7) D T4CHAH Q:BUDQUIT
 S BUDTOT=0
 S BUDINCI="" F  S BUDINCI=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI)) Q:BUDINCI=""!(BUDQUIT)  D
 .S BUDINC="" F  S BUDINC=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI,BUDINC)) Q:BUDINC=""!(BUDQUIT)  D T4CHAR2
 Q
T4CHAR2 ;
 S BUDSTOT=0
 W !,"Special Characteristics: ",BUDINC,!
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI,BUDINC,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI,BUDINC,BUDAGE,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ..S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI,BUDINC,BUDAGE,BUDCOM,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDBRPT1",BUDJ,BUDH,"T4CHAR",BUDINCI,BUDINC,BUDAGE,BUDCOM,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T4CHAH Q:BUDQUIT  W !,"Special Characteristics: ",BUDINC,!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))
 ....W ?36,$E(BUDCOM,1,13),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD)
 ....W !?5,BUDINC
 I $Y>(IOSL-4) D T4CHAH Q:BUDQUIT
 W !!,"Sub-Total Line ",BUDINCI," ",BUDINC,":  ",BUDSTOT,!
 Q
T4CHAH ;
 G:'BUDGPG T4CHAH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T4CHAH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 4")
 W !,$$CTR("Characteristics - Special Characteristics",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"This report provides a list of all patients who are migrant workers,"
 .W !,"seasonal workers, homeless, school based health center patients, or a"
 .W !,"veteran during the report period."
 .W !,"Note: Because RPMS does not record Public Housing Patients, those"
 .W !,"patients are not included in this report."
 .W !,"Age is calculated as of June 30."
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE"
 W !,?5,"SPECIAL CHARACTERISTIC"
 ;W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
