BUD1RPL2 ; IHS/CMI/LAB - UDS print lists ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
T52 ;EP
 S BUDP=0,BUD1L=35
 I '$D(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L)) D T52H W !!,"No Uncategorized Provider visits to report." Q
 D T52H
 S BUD1L=35,BUD1L2=0,BUDY=$O(^BUDLTFIV("B",BUD1L,0)),BUDY=$P(^BUDLTFIV(BUDY,0),U,2)
 W !!,"Line ",BUD1L,"   ",BUDY
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L,BUD1L2,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L,BUD1L2,BUDCOM,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ..S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L,BUD1L2,BUDCOM,BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L,BUD1L2,BUDCOM,BUDAGE,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D T5W
 ...Q
 ..Q
 .Q
 W !
 Q
T5W ;
 W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12)
 W ?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$E($P($$RACE^BUD1RPTC(DFN),U,4),1,15)," (",$P($$RACE^BUD1RPTC(DFN),U,3),")"
 K BUDVLST S BUDV=0 F  S BUDV=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T5",BUD1L,BUD1L2,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .S BUDVLST($P(^AUPNVSIT(BUDV,0),U),BUDV)=""
 S BUDDD=0 F  S BUDDD=$O(BUDVLST(BUDDD)) Q:BUDDD=""!(BUDQUIT)  D
 .S BUDV=0 F  S BUDV=$O(BUDVLST(BUDDD,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 ..I $Y>(IOSL-3) D T52H Q:BUDQUIT  W !!,"Line ",BUD1L,"   ",BUDY
 ..W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$$PRIMPROV^APCLV(BUDV,"D"),?50,$P(^AUPNVSIT(BUDV,0),U,7),?55,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?70,$E($$LOCENC^APCLV(BUDV,"E"),1,9)
 ..Q
 Q
T52H ;
 G:'BUDGPG T5H2
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T5H2 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 5 Columns B & C, Uncategorized Provider Visits",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all patients, for uncategorized provider visits.  Displays",!,"community, gender, age and visit data, including Provider codes." D
 .W !,"* (R) - denotes the value was obtained from the Race field"
 .W !,"  (C) - denotes the value was obtained from the Classification/Beneficiary field"
 .W !
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE",?60,"RACE*"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"PROV CD",?50,"SRV",?55,"CLINIC",?70,"LOCATION"
 W !,$TR($J("",80)," ","-")
 S BUDP=1
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
T51 ;EP
 S BUDNEWR=1
 S BUD1L="" F  S BUD1L=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T51",BUD1L)) Q:BUD1L=""!(BUDQUIT)  D
 .S BUD1L2="" F  S BUD1L2=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T51",BUD1L,BUD1L2)) Q:BUD1L2=""!(BUDQUIT)  D
 ..S BUD1LL=BUD1L_$S(BUD1L2=0:"",1:BUD1L2)
 ..S BUDY=$O(^BUDLTFIV("B",BUD1LL,0)),BUDY=$P(^BUDLTFIV(BUDY,0),U,2)_" "_$P(^BUDLTFIV(BUDY,0),U,3)_" "_$P(^BUDLTFIV(BUDY,0),U,4)
 ..S BUDSUBT="Line "_BUD1LL_"   "_BUDY
 ..I $Y>(IOSL-3)!$G(BUDNEWR) D T51H Q:BUDQUIT  K BUDNEWR
 ..W !!,"Line ",BUD1LL,"   ",BUDY
 ..S BUDPROV="" F  S BUDPROV=$O(^XTMP("BUD1RPT1",BUDJ,BUDH,"T51",BUD1L,BUD1L2,BUDPROV)) Q:BUDPROV=""!(BUDQUIT)  D
 ...I $Y>(IOSL-3) D T51H Q:BUDQUIT  W !!,"Line ",BUD1LL,"   ",BUDY
 ...W !,BUDPROV,?35,^XTMP("BUD1RPT1",BUDJ,BUDH,"T51",BUD1L,BUD1L2,BUDPROV)
 .Q
 W !
 Q
T51H ;
 G:'BUDGPG T51H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T51H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  BPHC Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Personnel List for Table 5 Column A, By Service Category",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDBEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDBEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDBEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 W !,"List of all Active Provider Personnel sorted by Major Service Category.",!
 W !,"PROVIDER NAME",?35,"PROVIDER CODE",?70,"FTE"
 W !,$TR($J("",80)," ","-")
 Q
