BGP6DCLP ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
CPPL1 ;EP
 Q:$G(BGPAREAA)
 ;
 S BGPCNT=BGPCPLC,BGPPCNT=0
 I BGPCNT<11!(BGPLIST'="R") S BGPCNT=1 G GO
 I BGPCNT<100 S BGPCNT=BGPCNT\10 G GO
 S BGPCNT=10
GO ;
 S BGPQUIT="",BGPGPG=0,BGP6H1P=1
 S BGP1L=1 D HEADER
 S BGPY=$O(^BGPCTRL("B",2006,0))
 S BGPX=0 F  S BGPX=$O(^BGPCTRL(BGPY,28,BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 .I $Y>(IOSL-2) D HEADER Q:BGPQUIT
 .W !,^BGPCTRL(BGPY,28,BGPX,0)
 S BGP1L=0
 D HEADER
 S BGPCOM="",BGPCOUNT=0 F  S BGPCOM=$O(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM)) Q:BGPCOM=""!(BGPQUIT)  D CPL1
 W !!,"Total # of patients on list: ",+$G(BGPPCNT),!
 Q
CPL1 ;EP
 S BGPSEX="" F  S BGPSEX=$O(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX)) Q:BGPSEX=""!(BGPQUIT)  D CPL2
 Q
CPL2 ;
 S BGPAGE="" F  S BGPAGE=$O(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE)) Q:BGPAGE=""!(BGPQUIT)  D
 .S DFN=0 F  S DFN=$O(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN)) Q:DFN'=+DFN!(BGPQUIT)  S BGPCOUNT=BGPCOUNT+1 D PRINTL
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 Q
PRINTL ;print one line
 Q:(BGPCOUNT#BGPCNT)
 I $Y>(BGPIOSL-2) D HEADER Q:BGPQUIT
 S BGPPCNT=BGPPCNT+1
 W !,$E($P(^DPT(DFN,0),U),1,22),?24,$$HRN^AUPNPAT(DFN,DUZ(2)),?31,$E(BGPCOM,1,14),?46,BGPSEX,?49,BGPAGE
 S W="",X=$P(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN),"|||",1) F Y=1:1:6 I $P(X,"$$",Y)]"" S:W]"" W=W_"," S W=W_$P(X,"$$",Y)
 S Z="",X=$P(^XTMP("BGP06CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN),"|||",2) F Y=1:1  Q:$P(X,"#",Y)=""  S:Z]"" Z=Z_", " S Z=Z_$P(X,"#",Y)
 W ?53,W,?65,Z
 Q
 ;
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI) W "ZZZZZZZ",!  ;maw
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W !,$$CTR("***  IHS Comprehensive National GPRA Patient List  ***",80),!
 W $$CTR("*** List of Patients not meeting a National GPRA measure  ***",80),!
 W $$CTR("CRS 2006, Version 6.1",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 S X="Report Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W $$CTR(X,80),!
 W $$CTR($S(BGPLIST="A":"All Patients",BGPLIST="R":"Random Patient List",1:"Patient List by Provider: "_BGPLPROV),80),!
 W !,$TR($J("",80)," ","-")
 Q:BGP1L
H1 ;
 W !,"UP=User Pop; AC=Active Clinical; AD=Active Diabetic; AAD=Active Adult Diabetic",!,"PREG=Pregnant Female; IMM=Active IMM Pkg Pt",!
 W !,"PATIENT NAME",?24,"HRN",?31,"COMMUNITY",?45,"SEX",?49,"AGE",?53,"DENOMINATOR",?65,"MEASURE NOT MET"
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
