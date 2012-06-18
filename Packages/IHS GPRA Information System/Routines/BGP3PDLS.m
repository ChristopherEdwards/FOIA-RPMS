BGP3PDLS ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 Q:$G(BGPAREAA)
 Q:'$D(BGPLIST)
 S X=" " D S(X,1,1) D S(X,1,1) D S(X,1,1) S X="PATIENT LISTS" D S(X,1,1) S X=" " D S(X,1,1)
 S BGPL=0 F  S BGPL=$O(^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL)) Q:BGPL'=+BGPL  D
 .S BGPCOUNT=0
 .S BGPCNT=BGPLIST(BGPL)
 .I BGPCNT<11!(BGPLIST'="R") S BGPCNT=1 G GO
 .I BGPCNT<100 S BGPCNT=BGPCNT\10 G GO
 .S BGPCNT=10
GO .S X=0 F  S X=$O(^BGPIND(BGPL,71,X)) Q:X'=+X  S X=^BGPIND(BGPL,71,X,0) D S(X,1,1) S X=" " D S(X,1,1)
 .D H1
 .S BGPCOM="" F  S BGPCOM=$O(^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL,BGPCOM)) Q:BGPCOM=""  D
 ..S BGPSEX="" F  S BGPSEX=$O(^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX)) Q:BGPSEX=""  D
 ...S BGPAGE="" F  S BGPAGE=$O(^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE)) Q:BGPAGE=""  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN)) Q:DFN'=+DFN  S BGPCOUNT=BGPCOUNT+1 D PRINTL
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1) S X="  " D S(X,1,1)
 Q
PRINTL ;print one line
 Q:(BGPCOUNT#BGPCNT)
 S X=$E($P(^DPT(DFN,0),U),1,22) D S(X,1,1) S X=$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,,2) S X=$E(BGPCOM,1,14) D S(X,,3) S X=BGPSEX D S(X,,4) S X=BGPAGE D S(X,,5) S X=^XTMP("BGP3D",BGPJ,BGPH,"LIST",BGPL,BGPCOM,BGPSEX,BGPAGE,DFN) D S(X,,6)
 Q
 ;
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W !,$$CTR("***  IHS FY03 Clinical Performance Indicator Patient List  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W $$CTR(X,80),!
 W $$CTR($S(BGPLIST="A":"Entire Patient List",BGPLIST="R":"Random Patient List",1:"Patient List by Provider: "_BGPLPROV),80),!
 W !,$TR($J("",80)," ","-")
 Q
H1 ;
 S X="PATIENT NAME" D S(X,1,1) S X="HRN" D S(X,,2) S X="COMMUNITY" D S(X,,3) S X="SEX" D S(X,,4) S X="AGE" D S(X,,5) S X="VALUE" D S(X,,6)
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
