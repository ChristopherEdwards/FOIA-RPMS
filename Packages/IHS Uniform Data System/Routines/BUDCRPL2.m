BUDCRPL2 ; IHS/CMI/LAB - UDS print lists ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
T52 ;EP
 S BUDP=0,BUDX2L=35
 I BUDROT="P",'$D(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L)) D T52H W !!,"No Uncategorized Provider visits to report." Q
 I BUDROT="D",'$D(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L)) D T52H D S(""),S("No Uncategorized Provider visits to report.") Q
 D T52H
 S BUDX2L=35,BUDX2L2=0,BUDY=$O(^BUDCTFIV("B",BUDX2L,0)),BUDY=$P(^BUDCTFIV(BUDY,0),U,2)
 I BUDROT="P" W !!,"Line ",BUDX2L,"   ",BUDY
 I BUDROT="D" D S(""),S("Line "_BUDX2L_"   "_BUDY)
 S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L,BUDX2L2,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 .S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L,BUDX2L2,BUDCOM,BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 ..S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L,BUDX2L2,BUDCOM,BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L,BUDX2L2,BUDCOM,BUDAGE,BUDSEX,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D T5W
 ...Q
 ..Q
 .Q
 I BUDROT="P" W !
 Q
T5W ;
 I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12)
 I BUDROT="P" W ?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD),?60,$E($P($$RACE^BUDCRPTC(DFN),U,4),1,15)," (",$P($$RACE^BUDCRPTC(DFN),U,3),")"
 K BUDVLST S BUDV=0 F  S BUDV=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T5",BUDX2L,BUDX2L2,BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .S BUDVLST($P(^AUPNVSIT(BUDV,0),U),BUDV)=""
 S BUDDD=0 F  S BUDDD=$O(BUDVLST(BUDDD)) Q:BUDDD=""!(BUDQUIT)  D
 .S BUDV=0 F  S BUDV=$O(BUDVLST(BUDDD,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 ..I BUDROT="P",$Y>(IOSL-3) D T52H Q:BUDQUIT  W !!,"Line ",BUDX2L,"   ",BUDY
 ..I BUDROT="P" W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$$PRIMPROV^APCLV(BUDV,"D"),?50,$P(^AUPNVSIT(BUDV,0),U,7),?55,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?70,$E($$LOCENC^APCLV(BUDV,"E"),1,9)
 ..I BUDROT="D" D
 ...S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD)
 ...S X=X_U_$E($P($$RACE^BUDCRPTC(DFN),U,4),1,15)_" ("_$P($$RACE^BUDCRPTC(DFN),U,3)_")"
 ...S X=X_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),"."))_U_$$PRIMPROV^APCLV(BUDV,"E")_U_$$PRIMPROV^APCLV(BUDV,"D")_U_$P(^AUPNVSIT(BUDV,0),U,7)_U_$$CLINIC^APCLV(BUDV,"E")_U_$$LOCENC^APCLV(BUDV,"E")
 ...D S(X)
 ..Q
 Q
T52DH ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 5 Columns B & C, Uncategorized Provider Visits")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S(" ")
 D S("List of all patients, for uncategorized provider visits.  Displays community, gender, age and visit data, including Provider codes.")
 D S("* (R) - denotes the value was obtained from the Race field")
 D S("  (C) - denotes the value was obtained from the Classification/Beneficiary field")
 D S("")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^VISIT DATE^PROV TYPE^PROV CD^SRV^CLINIC^LOCATION")
 Q
T52H ;
 I BUDROT="D" D T52DH Q
 G:'BUDGPG T5H2
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T5H2 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 5 Columns B & C, Uncategorized Provider Visits",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
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
 I BUDROT="D" D T51DH
 S BUDX2L="" F  S BUDX2L=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T51",BUDX2L)) Q:BUDX2L=""!(BUDQUIT)  D
 .S BUDX2L2="" F  S BUDX2L2=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T51",BUDX2L,BUDX2L2)) Q:BUDX2L2=""!(BUDQUIT)  D
 ..S BUDX2LL=BUDX2L_$S(BUDX2L2=0:"",1:BUDX2L2)
 ..S BUDY=$O(^BUDCTFIV("B",BUDX2LL,0)),BUDY=$P(^BUDCTFIV(BUDY,0),U,2)_" "_$P(^BUDCTFIV(BUDY,0),U,3)_" "_$P(^BUDCTFIV(BUDY,0),U,4)
 ..S BUDSUBT="Line "_BUDX2LL_"   "_BUDY
 ..I BUDROT="P",$Y>(IOSL-3)!$G(BUDNEWR) D T51H Q:BUDQUIT  K BUDNEWR
 ..I BUDROT="P" W !!,"Line ",BUDX2LL,"   ",BUDY
 ..I BUDROT="D" D S(""),S("Line "_BUDX2LL_"  "_BUDY)
 ..S BUDPROV="" F  S BUDPROV=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"T51",BUDX2L,BUDX2L2,BUDPROV)) Q:BUDPROV=""!(BUDQUIT)  D
 ...I BUDROT="P",$Y>(IOSL-3) D T51H Q:BUDQUIT  W !!,"Line ",BUDX2LL,"   ",BUDY
 ...I BUDROT="P" W !,BUDPROV,?35,^XTMP("BUDCRPT1",BUDJ,BUDH,"T51",BUDX2L,BUDX2L2,BUDPROV)
 ...I BUDROT="D" S X=BUDPROV_U_^XTMP("BUDCRPT1",BUDJ,BUDH,"T51",BUDX2L,BUDX2L2,BUDPROV) D S(X)
 .Q
 I BUDROT="P" W !
 Q
T51H ;
 I BUDROT="D" D T51DH
 G:'BUDGPG T51H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T51H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Personnel List for Table 5 Column A, By Service Category",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 W !,"List of all Active Provider Personnel sorted by Major Service Category.",!
 W !,"PROVIDER NAME",?35,"PROVIDER CODE",?70,"FTE"
 W !,$TR($J("",80)," ","-")
 Q
T51DH ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Personnel List for Table 5 Column A, By Service Category")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S(" ")
 D S("List of all Active Provider Personnel sorted by Major Service Category.")
 D S(" "),S("PROVIDER NAME^PROVIDER CODE^FTE")
 Q
T3A ;EP
 S BUDP=0
 D T3H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"3A",BUDAGE)) Q:BUDAGE'=+BUDAGE!(BUDQUIT)  D
 .S BUDSEX="" F  S BUDSEX=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX)) Q:BUDSEX=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN="" F  S DFN=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D T3H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,22),?24,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?36,$E(BUDCOM,1,12),?51,$P(^DPT(DFN,0),U,2),?55,$$AGE^AUPNPAT(DFN,BUDCAD) ;
 ....S BUDV=0 F  S BUDV=$O(^XTMP("BUDCRPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN,BUDV)) Q:BUDV'=+BUDV!(BUDQUIT)  D
 .....I BUDROT="P",$Y>(IOSL-3) D T3H Q:BUDQUIT
 .....I BUDROT="P" W !?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),".")),?25,$E($$PRIMPROV^APCLV(BUDV,"E"),1,14),?42,$P(^AUPNVSIT(BUDV,0),U,7),?45,$E($$CLINIC^APCLV(BUDV,"E"),1,14),?62,$E($$LOCENC^APCLV(BUDV,"E"),1,14)
 .....I BUDROT="D" D
 ......S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_$E(BUDCOM,1,12)_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD)
 ......S X=X_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(BUDV,0),U),"."))_U_$$PRIMPROV^APCLV(BUDV,"E")_U_$P(^AUPNVSIT(BUDV,0),U,7)_U_$$CLINIC^APCLV(BUDV,"E")_U_$$LOCENC^APCLV(BUDV,"E")
 ......D S(X)
 I BUDROT="P" W !
 Q
T3H ;
 I BUDROT="D" D T3HD Q
 G:'BUDGPG T3H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
T3H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 3A, Patients by Age and Gender",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all patients with one or more visits during the calendar year,"
 .W !,"with gender, age, and visit information. "
 .W !,"Age is calculated as of June 30.",!
 W !,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"AGE" ;,?60,"RACE/ETHN"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 S BUDP=1
 W !,$TR($J("",80)," ","-")
 Q
T3HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 3A, Patients by Age and Gender")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S(" ")
 D S("List of all patients with one or more visits during the calendar year,")
 D S("with gender, age, and visit information.")
 D S("Age is calculated as of June 30.")
 D S(" "),S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^VISIT DATE^PROV TYPE^SRV^CLINIC^LOCATION")
 Q
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
