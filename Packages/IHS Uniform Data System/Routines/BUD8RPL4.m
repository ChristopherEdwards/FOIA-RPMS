BUD8RPL4 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
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
RACE(R) ;EP
 I R="UNREP/REF" Q "7-Line 10: Unreported"
 I R="ASIAN" Q "3-Line 5a: Asian"
 I R="NATIVE HAWAIIAN" Q "1-Line 5b: Native Hawaiian"
 I R="OTH PAC ISLANDER" Q "2-Line 5c: Other Pacific Islander"
 I R="BLACK" Q "4-Line 6: Black/African American"
 I R="AI/AN" Q "5-Line 7: American Indian/Alaska Native"
 I R="WHITE" Q "6-Line 8: White"
 I R="HISPANIC,WHITE" Q "6-Line 8: White"
 I R="HISPANIC,BLACK" Q "5-Line 7: Black/African American"
 Q ""
T3BR ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D T3BRH Q:BUDQUIT
 I '$D(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR")) W !!,"No patients to report." Q
 D T3BRL1
 I $Y>(IOSL-3) D T3BRH G:BUDQUIT T3BRLX
 W !!,"TOTAL PATIENTS: ",BUDTOT,!
T3BRLX ;
 Q
T3BRL1 ;
 I $Y>(IOSL-7) D T3BRH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D T3BRL2
 Q
T3BRL2 ;
 S BUDSTOT=0
 W !,$P(BUDRACE,"-",2),!
 S BUDA="" F  S BUDA=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 .S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE,BUDA,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE,BUDA,BUDSEX,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE,BUDA,BUDSEX,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T3BRH Q:BUDQUIT  W !,$P(BUDRACE,"-",2),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))
 ....W ?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$E($P($$RACE^BUD8RPTC(DFN),U,3)_"-"_$P($$RACE^BUD8RPTC(DFN),U,4),1,19)
 ....S BUDV=0 F  S BUDV=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BR",BUDRACE,BUDA,BUDSEX,BUDCOM,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D T3BRH Q:BUDQUIT  W !,$P(BUDRACE,"-",2),!
 .....W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?62,$E($$LOCENC^APCLV(BUDV,"E"),1,14)
 I $Y>(IOSL-4) D T3BRH Q:BUDQUIT
 W !!,"Sub-Total ",$P(BUDRACE,"-",2),":  ",BUDSTOT,!
 Q
T3BRH ;
 G:'BUDGPG T3BRH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T3BRH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 3B, Patients by Race",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all patients with one or more visits during the calendar year, with"
 .W !,"gender, age, race, and visit information."
 .W !,"Age is calculated as of June 30."
 .W !,"* R- denotes the value was obtained from the Race field"
 .W !,"  C- denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE*"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
T3BE ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D T3BEH Q:BUDQUIT
 I '$D(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE")) W !!,"No patients to report." Q
 D T3BEL1
 I $Y>(IOSL-3) D T3BEH G:BUDQUIT T3BELX
 W !!,"TOTAL PATIENTS: ",BUDTOT,!
T3BELX ;
 Q
T3BEL1 ;
 I $Y>(IOSL-7) D T3BEH Q:BUDQUIT
 S BUDTOT=0
 S BUDRACE="" F  S BUDRACE=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE)) Q:BUDRACE=""!(BUDQUIT)  D T3BEL2
 Q
T3BEL2 ;
 S BUDSTOT=0
 W !,$P(BUDRACE,"-",1),!
 S BUDA="" F  S BUDA=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE,BUDA)) Q:BUDA=""!(BUDQUIT)  D
 .S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE,BUDA,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE,BUDA,BUDSEX,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE,BUDA,BUDSEX,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I $Y>(IOSL-3) D T3BEH Q:BUDQUIT  W !,$P(BUDRACE,"-",1),!
 ....S BUDTOT=BUDTOT+1,BUDSTOT=BUDSTOT+1
 ....W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))
 ....W ?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$E($P($$HISP^BUD8RPTC(DFN),U,2)_"-"_$P($$HISP^BUD8RPTC(DFN),U,3),1,19)
 ....S BUDV=0 F  S BUDV=$O(^XTMP("BUD8RPT1",BUDJ,BUDH,"3BE",BUDRACE,BUDA,BUDSEX,BUDCOM,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .....I $Y>(IOSL-3) D T3BEH Q:BUDQUIT  W !,$P(BUDRACE,"-",1),!
 .....W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?62,$E($$LOCENC^APCLV(BUDV,"E"),1,14)
 I $Y>(IOSL-4) D T3BEH Q:BUDQUIT
 W !!,"Sub-Total ",$P(BUDRACE,"-",1),":  ",BUDSTOT,!
 Q
T3BEH ;
 G:'BUDGPG T3BEH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T3BEH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 3B, Patients by Ethnicity",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all patients with one or more visits during the calendar year, with"
 .W !,"gender, age, ethnicity, and visit information."
 .W !,"Age is calculated as of June 30."
 .W !,"* E- denotes the value was obtained from the Ethnicity field"
 .W !,"  R- denotes the value was obtained from the Race field"
 .W !,"  C- denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"ETHNICITY*"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
