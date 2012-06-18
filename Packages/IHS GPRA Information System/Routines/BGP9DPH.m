BGP9DPH ; IHS/CMI/LAB - AREA REPORT HEADER 01 Jul 2008 7:54 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
 ;HEADERS FOR REPORTS
CALC(N,O) ;ENTRY POINT
 NEW Z
 ;I O=0!(N=0)!(O="")!(N="") Q "**"
 ;NEW X,X2,X3
 ;S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 ;S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 ;I +O=0 Q "**"
 ;S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
H2 ;EP
 Q:$G(BGPSUMON)
 S BGPX="",BGPX=$$C(BGPCYN,0,8),$E(BGPX,9)=$J(BGPCYP,5,1),$E(BGPX,16)=$$C(BGPPRN,0,8),$E(BGPX,24)=$J(BGPPRP,5,1),$E(BGPX,32)=$J($$CALC(BGPCYP,BGPPRP),6),$E(BGPX,39)=$$C(BGPBLN,0,8),$E(BGPX,47)=$J(BGPBLP,5,1)
 S $E(BGPX,55)=$J($$CALC(BGPCYP,BGPBLP),6)
 W ?20,BGPX
 Q
H6 ;EP
 Q:$G(BGPSUMON)
 W !,"Age specific Exercise Education Provided",!!,$$CTR(BGPHD1,80),!
 W !?40,"Age Distribution"
 W !?25,"0-9",?30,"10-19",?37,"20-24",?44,"25-34",?51,"35-44",?58,"45-54",?65,"55-64",?72,">64 yrs",!
 Q
H3 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"<15",?30,"15-19",?37,"20-24",?44,"25-34",?51,"35-44",?58,"45-54",?65,"55-64",?72,">64 yrs",!
 Q
H4 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?35,"<12",?46,"12-17",?58,"=>18",!
 Q
H5 ;
 Q:$G(BGPSUMON)
 W !,"Age specific Tobacco Use Prevalence",!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"0-9",?30,"10-19",?37,"20-24",?44,"25-34",?51,"35-44",?58,"45-54",?65,"55-64",?72,">64 yrs"
 Q
H1 ;EP
 Q:$G(BGPSUMON)
 W !!?21,"REPORT",?31,"%",?35,"PREV YR",?46,"%",?49,"CHG from",?59,"BASE",?69,"%",?72,"CHG from"
 W !?21,"PERIOD",?35,"PERIOD",?49,"PREV YR %",?59,"PERIOD",?72,"BASE %"
 Q
H9 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"0-5",?30,"6-11",?37,"12-19",?44,"20-34",?51,"35-44",?58,"45-54",?65,"55-74",?72,">74 yrs",!
 Q
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI) W "ZZZZZZZ",!  ;maw
 W $P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 I BGPRTYPE=4,$G(BGP9RPTH)="C" W $$CTR("*** IHS 2009 Selected Measures with Community Specified Report ***",80),!
 I BGPRTYPE=4,$G(BGP9RPTH)="A" W $$CTR("*** IHS 2009 Selected Measures with All Communities Report ***",80),!
 I BGPRTYPE=4,$G(BGP9RPTH)="P" W $$CTR("*** IHS 2009 Selected Measures with Patient Panel Population Report ***",80),!
 I BGPRTYPE=1,$G(BGPNGR09) W $$CTR("*** IHS 2010 National GPRA & PART Report, Run Using 2009 Logic ***",80),! G N
 I BGPRTYPE=1,$G(BGPDESGP) W $$CTR("*** IHS 2009 National GPRA & PART Report by Designated Provider ***",80),!
 I BGPRTYPE=1,'$G(BGP9GPU) W $$CTR("*** IHS 2009 National GPRA & PART Report ***",80),!
 I BGPRTYPE=1,$G(BGP9GPU) W $$CTR("*** IHS 2009 GPRA & PART Performance Report ***",80),!
 W:BGPRTYPE=3 $$CTR("*** IHS 2009 HEDIS Clinical Performance ***",80),!
 W:BGPRTYPE=5 $$CTR("*** IHS 2009 ELDER CARE Clinical Performance ***",80),!
 I BGPRTYPE=7 W $$CTR("IHS 2009 Other National Measures Report ***",80),!
N I $G(BGPAREAA) W $$CTR("AREA AGGREGATE",80),!
 I '$G(BGPAREAA) W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 I $G(BGPDESGP) W $$CTR("Designated Provider: "_$P(^VA(200,BGPDESGP,0),U),80),!
 S X="Report Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W $$CTR(X,80),!
 S X="Previous Year Period:  "_$$FMTE^XLFDT(BGPPBD)_" to "_$$FMTE^XLFDT(BGPPED) W $$CTR(X,80),!
 S X="Baseline Period:  "_$$FMTE^XLFDT(BGPBBD)_" to "_$$FMTE^XLFDT(BGPBED) W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
