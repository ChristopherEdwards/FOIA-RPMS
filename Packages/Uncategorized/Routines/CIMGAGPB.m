CIMGAGPB ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 05/31/00  3:11 PM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
PRINT ;
 S CIMGPG=0
 S CIMQUIT=""
 S CIM3YE=$$FMADD^XLFDT(CIMED,-1096)
 S CIM98B=$S(CIMQTR=0:($E(CIMED,1,3)-2),1:$E(CIMED,1,3)-1)_$E(CIMBD,4,7)
 S CIM98E=($E(CIMED,1,3)-1)_$E(CIMED,4,7)
 ;S CIM98B=$S(CIMQTR<2:297,1:298)_$E(CIMBD,4,7)
 ;S CIM98E=$S(CIMQTR=1:297,1:298)_$E(CIMED,4,7)
 S CIM983B=$$FMADD^XLFDT(CIM98E,-1096)
 D ^CIMGAGPJ
 S CIMQUIT="",CIMGPG=0
 D PRINT1
 Q
 ;
PRINT1 ;
 D HEADER
 W !!,"1/1  Diabetes",!,"Identify Area age-specific diabetes prevalence rates and incidence rates for",!,"American Indian/Alaska Native population.",!
 I $Y>(IOSL-5) D HEADER Q:CIMQUIT
 W !,"Prevalance of Diabetes"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(1,1),CIMGY=$$V(12,1)
 S CIMG1=$$V(1,10),CIMG1B=$$V(12,10)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# active users",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# w/ Diabetes Diagnosis",!?5,"before end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
12 ;
 I $Y>(IOSL-7) D HEADER Q:CIMQUIT
 W !!,"Incidence of Diabetes"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(11,1),CIMGY=$$V(13,1)
 S CIMG1=$$V(11,10),CIMG1B=$$V(13,10)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# active users",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# w/ 1st Diabetes Diagnosis",!?5,"during the time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
AGE11 ;
 D HEADER Q:CIMQUIT
 W !,"Age specific Diabetes Prevalance"
 W !?40,"Age Distribution"
 W !?23,"<1 yr",?30,"1-4",?37,"5-14",?44,"15-19",?51,"20-24",?56,"25-44",?65,"45-64",?72,">64 yrs",!
 W !," BASELINE"
 W !?2,"# active users"
 S T=23 F X=2:1:9 S Y=$$V(12,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"# w/Diabetes dx"
 S T=23 F X=11:1:18 S Y=$$V(12,X) W ?T,$$C(Y,0,6) S T=T+7
 K CIMX W !?2,"% with DM dx" S T=23 F X=11:1:18 S N=$$V(12,X),D=$$V(12,(X-9)),%=$S('D:"",1:(N/D)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(CIMX(X),U,2)=%
 I $Y>(IOSL-7) D HEADER Q:CIMQUIT
 W !,"CURRENT PERIOD"
 W !?2,"# active users"
 S T=23 F X=2:1:9 S Y=$$V(1,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"# w/Diabetes dx"
 S T=23 F X=11:1:18 S Y=$$V(1,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"% with DM dx" S T=23 F X=11:1:18 S N=$$V(1,X),D=$$V(1,(X-9)),%=$S('D:"",1:(N/D)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(CIMX(X),U)=%
 S T=23 W !!,"% Change" S X=0 F  S X=$O(CIMX(X)) Q:X'=+X  S N=$P(CIMX(X),U),O=$P(CIMX(X),U,2) W ?T,$J($$CALC(N,O),6) S T=T+7
AGE12 ;age distribution 1/2
 I $Y>(IOSL-14) D HEADER Q:CIMQUIT
 W !!!,"Age specific Diabetes Incidence"
 W !?40,"Age Distribution"
 W !?23,"<1 yr",?30,"1-4",?37,"5-14",?44,"15-19",?51,"20-24",?56,"25-44",?65,"45-64",?72,">64 yrs",!
 W !," BASELINE"
 W !?2,"# active users"
 S T=23 F X=2:1:9 S Y=$$V(13,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"# w/Diabetes dx"
 S T=23 F X=11:1:18 S Y=$$V(13,X) W ?T,$$C(Y,0,6) S T=T+7
 K CIMX W !?2,"% with DM dx" S T=23 F X=11:1:18 S N=$$V(13,X),D=$$V(13,(X-9)),%=$S('D:"",1:(N/D)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(CIMX(X),U,2)=%
 I $Y>(IOSL-7) D HEADER Q:CIMQUIT
 W !,"CURRENT PERIOD"
 W !?2,"# active users"
 S T=23 F X=2:1:9 S Y=$$V(11,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"# w/Diabetes dx"
 S T=23 F X=11:1:18 S Y=$$V(11,X) W ?T,$$C(Y,0,6) S T=T+7
 W !?2,"% with DM dx" S T=23 F X=11:1:18 S N=$$V(11,X),D=$$V(11,(X-9)),%=$S('D:"",1:(N/D)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(CIMX(X),U)=%
 S T=23 W !!,"% Change" S X=0 F  S X=$O(CIMX(X)) Q:X'=+X  S N=$P(CIMX(X),U),O=$P(CIMX(X),U,2) W ?T,$J($$CALC(N,O),6) S T=T+7
IND22 ;hgb
 D HEADER Q:CIMQUIT
 W !,"2/2  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes that have improved their glycemic control by 3% over BASELINE level.",!
 W !,"Glycemic Control"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(1,10),CIMGY=$$V(12,10)
 S CIMG1=$$V(14,1),CIMG1B=$$V(15,1)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# diagnosed diabetes",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# w/ HGBA1C/GLUCOSE recorded within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMGX=$$V(14,1),CIMGY=$$V(15,1)
 S CIMG1=$$V(14,2),CIMG1B=$$V(15,2)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !!?3,"# w/ Acceptable Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(14,3),CIMG1B=$$V(15,3)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Fair Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(14,4),CIMG1B=$$V(15,4)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ High",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(14,5),CIMG1B=$$V(15,5)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Very High",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 W !!!?3,"# w/ HGBA1C or GLUCOSE recorded in both time periods"
 S CIMGX=$$V(15,6)
 W ?58,$$C(CIMGX,0,9)
 W !!?3,"# whose control level improved at least one category" S CIMG1=$$V(15,7) W ?58,$$C(CIMG1,0,9)
 W !?3,"# whose control level decreased or stayed the same" S CIMG2=$$V(15,8) W ?58,$$C(CIMG2,0,9)
 W !?3,"# at acceptable level both periods" S CIMG3=$$V(15,9) W ?58,$$C(CIMG3,0,9)
 W !!?3,"Percent improved" I CIMGX-CIMG3 S X=+((CIMG1-CIMG2)/(CIMGX-CIMG3)*100) W ?60,$J(X,6,1)
IND33 ;
 D HEADER Q:CIMQUIT
 W !,"3/3  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes and hypertension that have achieved diabetic blood",!,"pressure control.",!
 W !,"Blood Pressure Control"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(1,10),CIMGY=$$V(12,10)
 S CIMG1=$$V(17,1),CIMG1B=$$V(18,1)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# diagnosed diabetes",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# w/ diagnosed Hypertension",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7),!
 S CIMGX=$$V(17,1),CIMGY=$$V(18,1)
 S CIMG1=$$V(17,2),CIMG1B=$$V(18,2)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Blood Pressure recorded within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7),!
 S CIMGX=$$V(17,2),CIMGY=$$V(18,2)
 S CIMG1=$$V(17,3),CIMG1B=$$V(18,3)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Ideal Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(17,4),CIMG1B=$$V(18,4)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Target Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(17,5),CIMG1B=$$V(18,5)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Adequate Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(17,6),CIMG1B=$$V(18,6)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Inadequate Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMG1=$$V(17,7),CIMG1B=$$V(18,7)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# w/ Markedly Poor Control",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 D ^CIMGAGPC
 I CIMQUIT G EXIT
 D ^CIMGAGPK
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
V(N,P) ;
 NEW X,C S (X,C)=0 F  S X=$O(CIMSUL(X)) Q:X'=+X  S C=C+$P($G(^CIMAGP(X,N)),U,P)
 Q C
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
