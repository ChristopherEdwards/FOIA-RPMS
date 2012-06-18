BGP8ELSL ; IHS/CMI/LAB - IHS gpra print ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
START ;
 Q:$G(BGPAREAA)
 Q:'$D(BGPLIST)
 S X=" " D S(X,1,1) D S(X,1,1) D S(X,1,1) S X="PATIENT LISTS" D S(X,1,1) S X=" " D S(X,1,1)
 ;S BGPL=0 F  S BGPL=$O(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL)) Q:BGPL'=+BGPL  D
 S BGPL=0 F  S BGPL=$O(BGPLIST(BGPL)) Q:BGPL'=+BGPL  D
 .S BGPCOUNT=0,BGPPCNT=0
 .S BGPCNT=$G(BGPLIST(BGPL))
 .I 'BGPCNT S BGPCNT=0 G GO
 .I BGPCNT<11!(BGPLIST'="R") S BGPCNT=1 G GO
 .I BGPCNT<100 S BGPCNT=BGPCNT\10 G GO
 .S BGPCNT=10
GO .;
 .S X="**** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****" D S(X,1,1)
 .S X=$P(^BGPELIE(BGPL,0),U,3) D S(X,1,1)
 .S X=" " D S(X,1,1)
 .S X="Denominator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPL,61,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPELIE(BGPL,61,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...S BGPZ=0 F  S BGPZ=$O(^BGPELIE(BGPL,61,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S Y=^BGPELIE(BGPL,61,BGPY,1,BGPZ,0) D S(Y,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S X="Numerator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPL,62,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPELIE(BGPL,62,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...S BGPZ=0 F  S BGPZ=$O(^BGPELIE(BGPL,62,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S X=^BGPELIE(BGPL,62,BGPY,1,BGPZ,0) D S(X,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPL,11,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPELIE(BGPL,11,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPL,51,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPELIE(BGPL,51,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPL,52,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPELIE(BGPL,52,BGPX,0) D S(X,1,1)
 .D H1
 .S BGPCOM="" F  S BGPCOM=$O(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM)) Q:BGPCOM=""  D
 ..S BGPSEX="" F  S BGPSEX=$O(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX)) Q:BGPSEX=""  D
 ...S BGPAGE="" F  S BGPAGE=$O(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE)) Q:BGPAGE=""  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN)) Q:DFN'=+DFN  S BGPCOUNT=BGPCOUNT+1 D PRINTL
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1) S X="  " D S(X,1,1)
 .S X=" " D S(X,1,1) S X="  " D S(X,1,1)
 .S X="Total # of patients on list: "_+$G(BGPPCNT) D S(X,1,1)
 Q
PRINTL ;print one line
 Q:(BGPCOUNT#BGPCNT)
 S BGPPCNT=BGPPCNT+1
 S X=$E($P(^DPT(DFN,0),U),1,22) D S(X,1,1) S X=$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,,2) S X=$E(BGPCOM,1,14) D S(X,,3) S X=BGPSEX D S(X,,4) S X=BGPAGE D S(X,,5)
 S X=$P(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN),"|||",1) D S(X,,6)
 S X=$P(^XTMP("BGP8D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN),"|||",2) D S(X,,7)
 Q
 ;
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W !,$$CTR("***  IHS 2008 ELDER CARE Clinical Performance Report Patient List  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W $$CTR(X,80),!
 W $$CTR($S(BGPLIST="A":"Entire Patient List",BGPLIST="R":"Random Patient List",1:"Patient List by Provider: "_BGPLPROV),80),!
 W !,$TR($J("",80)," ","-")
 Q
H1 ;
 S X=" " D S(X,1,1)
 S X=$S(BGPLIST="A":"Entire Patient List",BGPLIST="R":"Random Patient List",1:"Patient List by Provider: "_BGPLPROV) D S(X,1,1)
 S X=" " D S(X,1,1) S X="UP=User Pop; AC=Active Clinical; AD=Active Diabetic" D S(X,1,1) S X=" " D S(X,1,1)
 S Y=0 F  S Y=$O(^BGPELIE(BGPL,71,Y)) Q:Y'=+Y  S X=^BGPELIE(BGPL,71,Y,0) D S(X,1,1)
 S X=" " D S(X,1,1)
 S X="PATIENT NAME" D S(X,1,1) S X="HRN" D S(X,,2) S X="COMMUNITY" D S(X,,3) S X="SEX" D S(X,,4) S X="AGE" D S(X,,5) S X="DENOMINATOR" D S(X,,6) S X="NUMERATOR" D S(X,,7)
 S X=$TR($J("",80)," ","-") D S(X,1,1)
 Q
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
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
