BGP4DPH ; IHS/CMI/LAB - AREA REPORT HEADER 01 Jul 2010 7:54 PM ;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
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
H10 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?35,"65-74",?46,"75-84",?58,"85+",!
 Q
H5 ;
 Q:$G(BGPSUMON)
 W !,"Age specific Tobacco Use Prevalence",!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"0-9",?30,"10-19",?37,"20-24",?44,"25-34",?51,"35-44",?58,"45-54",?65,"55-64",?72,">64 yrs"
 Q
H1 ;EP
 Q:$G(BGPSUMON)
 ;I BGPFONE W !!,$P(^BGPINDJ(BGPIC,0),U,3),!
 W !!?21,"REPORT",?31,"%",?35,"PREV YR",?46,"%",?49,"CHG from",?59,"BASE",?69,"%",?72,"CHG from"
 W !?21,"PERIOD",?35,"PERIOD",?49,"PREV YR %",?59,"PERIOD",?72,"BASE %"
 S BGPFONE=0
 Q
H9 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"0-5",?30,"6-21",?37,"22-34",?44,"35-44",?51,"45-54",?58,"55-74",?65,">74 yrs",!  ;?72,">74 yrs",!
 Q
HPA ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"5-11",?30,"12-19",?37,"20-24",?44,"25-34",?51,"35-44",?58,"45-54",?65,"55-74",?72,">74 yrs",!
 Q
HEADER ;EP
 I BGPPTYPE="D",'$G(BGPDASH) Q
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 I BGPPTYPE="P" W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI),BGPPTYPE="P" D W^BGP4DP("ZZZZZZZ",0,0,BGPPTYPE),W^BGP4DP("",0,1,BGPPTYPE)  ;GUI
 I BGPPTYPE="P" S X=$P(^VA(200,DUZ,0),U,2),$E(X,35)=$$FMTE^XLFDT(DT),$E(X,70)="Page "_BGPGPG D W^BGP4DP(X,1,1,BGPPTYPE)
 I BGPPTYPE'="P" S X=$P(^VA(200,DUZ,0),U,2),$P(X,U,2)=$$FMTE^XLFDT(DT) D W^BGP4DP(X,0,1,BGPPTYPE)
 I $G(BGPDASH) D W^BGP4DP("*** IHS 2014 National GPRA Dashboard ***",1,1,BGPPTYPE) G N
 I $G(BGPNPL),BGPRTYPE=1 D W^BGP4DP("*** IHS 2014 GPRA/GPRAMA Patient List ***",1,2,BGPPTYPE) G N
 I $G(BGPNPL),BGPRTYPE=9 D W^BGP4DP("*** IHS 2014 GPRA Developmental Measures Patient List ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=4,$G(BGPYRPTH)="C" D W^BGP4DP("*** IHS 2014 Selected Measures with Community Specified Report ***",1,1,BGPPTYPE)
 I BGPRTYPE=4,$G(BGPYRPTH)="A" D W^BGP4DP("*** IHS 2014 Selected Measures with All Communities Report ***",1,1,BGPPTYPE)
 I BGPRTYPE=4,$G(BGPYRPTH)="P" D W^BGP4DP("*** IHS 2014 Selected Measures with Patient Panel Population Report ***",1,1,BGPPTYPE)
 I BGPRTYPE=1!(BGPRTYPE=9),$G(BGPNGR09) D W^BGP4DP("*** IHS 2014 National GPRA/GPRAMA Report, Run Using 2014 Logic ***",1,1,BGPPTYPE) G N
 I BGPRTYPE=1!(BGPRTYPE=9),$G(BGPDESGP) D W^BGP4DP("*** IHS 2014 National GPRA/GPRAMA Report by Designated Provider ***",1,1,BGPPTYPE)
 I BGPRTYPE=1!(BGPRTYPE=9),'$G(BGPYGPU) D W^BGP4DP("*** IHS 2014 National GPRA/GPRAMA Report ***",1,1,BGPPTYPE)
 I BGPRTYPE=1!(BGPRTYPE=9),$G(BGPYGPU) D W^BGP4DP("*** IHS 2014 GPRA/GPRAMA Performance Report ***",1,1,BGPPTYPE)
 I BGPRTYPE=9 D W^BGP4DP("*** Developmental Measures ***",1,1,BGPPTYPE)
 D:BGPRTYPE=3 W^BGP4DP("*** IHS 2014 HEDIS Clinical Performance ***",1,1,BGPPTYPE)
 D:BGPRTYPE=5 W^BGP4DP("*** IHS 2014 ELDER CARE Clinical Performance ***",1,1,BGPPTYPE)
 I BGPRTYPE=7 D W^BGP4DP("IHS 2014 Other National Measures Report ***",1,1,BGPPTYPE)
N I $G(BGPAREAA) D W^BGP4DP("AREA AGGREGATE",1,1,BGPPTYPE)
 I '$G(BGPAREAA) D W^BGP4DP($P(^DIC(4,DUZ(2),0),U),1,1,BGPPTYPE)
 I $G(BGPDESGP) D W^BGP4DP("Designated Provider: "_$P(^VA(200,BGPDESGP,0),U),1,1,BGPPTYPE)
 S X="Report Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) D W^BGP4DP(X,1,1,BGPPTYPE)
 S X="Previous Year Period:  "_$$FMTE^XLFDT(BGPPBD)_" to "_$$FMTE^XLFDT(BGPPED) D W^BGP4DP(X,1,1,BGPPTYPE)
 I '$G(BGPDASH) S X="Baseline Period:  "_$$FMTE^XLFDT(BGPBBD)_" to "_$$FMTE^XLFDT(BGPBED) D W^BGP4DP(X,1,1,BGPPTYPE)
 D W^BGP4DP($TR($J("",80)," ","-"),0,1,BGPPTYPE)
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
