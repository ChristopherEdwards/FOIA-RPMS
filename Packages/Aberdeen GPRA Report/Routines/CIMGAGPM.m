CIMGAGPM ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 03/15/00  7:28 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
PHN ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"19/2000 Public Health Nursing",!,"Assure the total number of public health nursing services provided to ",!,"individuals in all settings and the total number of home visits are",!,"increased by 5% over the FY 1998 workload baselines",!
 W !,"Public Health Nursing - # served by PHS in any Setting"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,1,1),CIMGY=$$V(CIMDO,12,1)
 .S CIMG1=$$V(CIMDO,19,25),CIMG1B=$$V(CIMDO,20,25)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
A ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"19/2000 Public Health Nursing",!,"Assure the total number of public health nursing services provided to ",!,"individuals in all settings and the total number of home visits are",!,"increased by 5% over the FY 1998 workload baselines",!
 W !,"Public Health Nursing - # served by PHN in HOME setting"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMG1=$$V(CIMDO,19,26),CIMG1B=$$V(CIMDO,20,26)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
B ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"19/2000 Public Health Nursing",!,"Assure the total number of public health nursing services provided to ",!,"individuals in all settings and the total number of home visits are",!,"increased by 5% over the FY 1998 workload baselines",!
 W !,"Public Health Nursing - # PHN Visits any Setting"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .D LOCW Q:CIMQUIT
 .S X=$$V(CIMDO,20,18),Y=$$V(CIMDO,19,18),%=$S(X:((Y-X)/X)*100,1:"") W ?44,$J(%,5,1)
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"19/2000 Public Health Nursing",!,"Assure the total number of public health nursing services provided to ",!,"individuals in all settings and the total number of home visits are",!,"increased by 5% over the FY 1998 workload baselines",!
 W !,"Public Health Nursing - # PHN Visits in the HOME"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .D LOCW Q:CIMQUIT
 .S X=$$V(CIMDO,20,19),Y=$$V(CIMDO,19,19),%=$S(X:((Y-X)/X)*100,1:"") W ?44,$J(%,5,1)
FLUPNEU ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"21/2000 Adult Immunization",!,"Produce an overall pneumoccal and influenza vaccination level of at least 60%",!,"for adults aged 65 and older.",!
 W !,"Adult Immunizations - Pneumovax ever"
 W !?44,"Total Percent"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,20),CIMGY=$$V(CIMDO,20,20)
 .S CIMG1=$$V(CIMDO,19,21),CIMG1B=$$V(CIMDO,20,21)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J(CIMG1P,6,1)
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"21/2000 Adult Immunization",!,"Produce an overall pneumoccal and influenza vaccination level of at least 60%",!,"for adults aged 65 and older.",!
 W !,"Adult Immunizations - Flu Vaccine"
 W !?44,"Total Percent"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMG1=$$V(CIMDO,19,22),CIMG1B=$$V(CIMDO,20,22)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT  W ?44,$J(CIMG1P,6,1)
SMOKER ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !!,"24/2000  Smoking",!,"Determine Area-age specific prevalance rates for the",!,"usage of tobacco products.",!
 I $Y>(IOSL-5) D HEADER Q:CIMQUIT
 W !,"Prevalance of Usage of Tobacco Products"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,22,10),CIMGY=$$V(CIMDO,23,10)
 .S CIMG1=$$V(CIMDO,22,1),CIMG1B=$$V(CIMDO,23,1)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT  W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0)!(O="")!(N="") Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 I +O=0 Q "**"
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
LOCW ;
 I $Y>(IOSL-3) D HEADER Q:CIMQUIT
 W !?3,$P(^CIMAGP(CIMDO,0),U,5)
 S X=$P(^CIMAGP(CIMDO,0),U,5)
 I X="" W ?11,"?????" Q
 S X=$O(^AUTTLOC("C",X,0))
 I X="" W ?11,"?????" Q
 W ?11,$E($P(^DIC(4,X,0),U),1,20)
 Q
V(R,N,P) ;
 Q $P($G(^CIMAGP(R,N)),U,P)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'CIMGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S CIMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S CIMGPG=CIMGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",CIMGPG,!
 W !,$$CTR("***  ABERDEEN AREA GPRA INDICATORS  ***",80),!
 W $S(CIMSUCNT=1:$$CTR(CIMSUNM),1:$$CTR("AREA AGGREGATE")),!
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W $$CTR(X,80),!
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W $$CTR(X,80),!
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
