CIMGAGPK ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 03/15/00  8:57 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
 Q:CIMSUCNT=1
 D HEADER
 W !!,"1/1  Diabetes",!,"Identify Area age-specific diabetes prevalence rates and incidence rates for",!,"American Indian/Alaska Native population.",!
 W !,"Prevalance of Diabetes"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,1,1),CIMGY=$$V(CIMDO,12,1)
 .S CIMG1=$$V(CIMDO,1,10),CIMG1B=$$V(CIMDO,12,10)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
12 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !!,"1/1  Diabetes",!,"Identify Area age-specific diabetes prevalence rates and incidence rates for",!,"American Indian/Alaska Native population.",!
 W !!,"Incidence of Diabetes"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,11,1),CIMGY=$$V(CIMDO,13,1)
 .S CIMG1=$$V(CIMDO,11,10),CIMG1B=$$V(CIMDO,13,10)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND22 ;hgb
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"2/2  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes that have improved their glycemic control by 3% over BASELINE level.",!
 W !,"Glycemic Control"
 W !?44,"% IMPROVED"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,15,6)
 .S CIMG1=$$V(CIMDO,15,7)
 .S CIMG2=$$V(CIMDO,15,8)
 .S CIMG3=$$V(CIMDO,15,9)
 .D LOCW Q:CIMQUIT
 .I CIMGX-CIMG3 S X=+((CIMG1-CIMG2)/(CIMGX-CIMG3)*100) W ?44,$J(X,6,1)
IND33 ;
 D ^CIMGAGPL G EXIT
 D HEADER Q:CIMQUIT
 W !,"3/3  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes and hypertension that have achieved diabetic blood",!,"pressure control.",!
 W !,"Blood Pressure Control"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMDO,1,10),CIMGY=$$V(CIMDO,12,10)
 S CIMG1=$$V(CIMDO,17,1),CIMG1B=$$V(CIMDO,18,1)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# diagnosed diabetes",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# w/ diagnosed Hypertension",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7),!
 S CIMGX=$$V(CIMDO,17,1),CIMGY=$$V(CIMDO,18,1)
 S CIMG1=$$V(CIMDO,17,2),CIMG1B=$$V(CIMDO,18,2)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Blood Pressure recorded within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7),!
 S CIMGX=$$V(CIMDO,17,2),CIMGY=$$V(CIMDO,18,2)
 S CIMG1=$$V(CIMDO,17,3),CIMG1B=$$V(CIMDO,18,3)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Ideal Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(CIMDO,17,4),CIMG1B=$$V(CIMDO,18,4)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Target Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(CIMDO,17,5),CIMG1B=$$V(CIMDO,18,5)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Adequate Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(CIMDO,17,6),CIMG1B=$$V(CIMDO,18,6)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Inadequate Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(CIMDO,17,7),CIMG1B=$$V(CIMDO,18,7)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Markedly Poor Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 D ^CIMGAGPL
EXIT ;
 I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
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
