CIMGAGPQ ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 03/13/00  9:56 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
IND55 ;
 D HEADER Q:CIMQUIT
 W !,"5/5  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes who have been assessed for nephropathy by 3% over BASELINE level.",!
 W !,"Assessed for Nephropathy"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,1,10),CIMGY=$$V(CIMRPT,12,10)
 S CIMG1=$$V(CIMRPT,19,2),CIMG1B=$$V(CIMRPT,20,2)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# diagnosed diabetes",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# assessed for nephropathy within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND66 ;
 D HEADER Q:CIMQUIT
 W !,"6/6  Women's Health",!,"Increase the proportion of AI/AN women who have annual pap screening to 55%.",!
 W !,"Pap Screening"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,19,3),CIMGY=$$V(CIMRPT,20,3)
 S CIMG1=$$V(CIMRPT,19,4),CIMG1B=$$V(CIMRPT,20,4)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# Women >17 years old",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# with Pap documented within",!?5,"3 years of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND77 ;
 D HEADER Q:CIMQUIT
 W !,"7/7  Women's Health",!,"Increase the proportion of AI/AN female population 40-69 years of age who",!,"had annual screening mammography.",!
 W !,"Mammography Screening"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,19,5),CIMGY=$$V(CIMRPT,20,5)
 S CIMG1=$$V(CIMRPT,19,6),CIMG1B=$$V(CIMRPT,20,6)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# Women 40-69 years old",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# with Mammography documented within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND88 ;
 D HEADER Q:CIMQUIT
 W !,"8/8  Child Health",!,"Determine the proportion of AI/AN children served by",!,"IHS receiving a minimum of four Well Child visits by 27 months of age.",!
 W !,"Well Child Visits by Age 27 Months"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,19,7),CIMGY=$$V(CIMRPT,20,7)
 S CIMG1=$$V(CIMRPT,19,8),CIMG1B=$$V(CIMRPT,20,8)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# Children turning 27 mon old",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# with at least 4 Well Child",!?5,"before age 27 months",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1112 ;
 D HEADER Q:CIMQUIT
 W !,"11/12  Dental Health",!,"Assure that at least 21% of the AI/AN population obtain",!,"access to dental services.",!
 W !,"Dental Visit 0000"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,1,1),CIMGY=$$V(CIMRPT,12,1)
 S CIMG1=$$V(CIMRPT,19,9),CIMG1B=$$V(CIMRPT,20,9)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# active users",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# with a dental visit 0000 within",!?5,"1 year of end of time period",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1213 ;
 D HEADER Q:CIMQUIT
 W !,"12/13  Dental Health",!,"Assure that the percentage of AI/AN children 6-8 and 14-15",!,"who have received protective dental sealants on permanent molar teeth is ",!,"restored to 90% of the FY 1991 IHS Oral Health Survey level",!
 W !,"Dental Visit 1351"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,19,10),CIMGY=$$V(CIMRPT,20,10)
 S CIMG1=$$V(CIMRPT,19,11),CIMG1B=$S($E(CIMPER,1,3)'=299:$$V(CIMRPT,20,11),1:"**")
 I $E(CIMPER,1,3)'=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 I $E(CIMPER,1,3)=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=65.0,CIMGY="**",CIMG1B="**"
 W !?3,"# children 6-8",?36,$S(CIMGY="**":CIMGY,1:$$C(CIMGY,0,9)),?54,$$C(CIMGX,0,9)
 W !?3,"# with a dental visit 1351",!?5,"anytime in their history",?36,$S(CIMG1B="**":CIMG1B,1:$$C(CIMG1B,0,9)),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMGX=$$V(CIMRPT,19,27),CIMGY=$$V(CIMRPT,20,27)
 S CIMG1=$$V(CIMRPT,19,28),CIMG1B=$S($E(CIMPER,1,3)'=299:$$V(CIMRPT,20,28),1:"**")
 I $E(CIMPER,1,3)'=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 I $E(CIMPER,1,3)=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=62.0,CIMGY="**",CIMG1B="**"
 W !!?3,"# children 14-15",?36,$S(CIMGY="**":CIMGY,1:$$C(CIMGY,0,9)),?54,$$C(CIMGX,0,9)
 W !?3,"# with a dental visit 1351",!?5,"anytime in their history",?36,$S(CIMG1B="**":CIMG1B,1:$$C(CIMG1B,0,9)),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1820 ;
 D HEADER Q:CIMQUIT
 W !,"18/20  Child Health",!,"Immunization  Increase by 3% the proportion of AI/AN",!,"children who have completed all recommended immunizations by the age of two.",!
 W !,"Immunizations Up to date"
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 S CIMGX=$$V(CIMRPT,19,12),CIMGY=$$V(CIMRPT,20,12)
 S CIMG1=$$V(CIMRPT,19,13),CIMG1B=$$V(CIMRPT,20,13)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !?3,"# children 2 yrs of age",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# immunized with basic series",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
 S CIMGX=$$V(CIMRPT,22,12),CIMGY=$$V(CIMRPT,23,12)
 S CIMG1=$$V(CIMRPT,22,13),CIMG1B=$$V(CIMRPT,23,13)
 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 W !!!?3,"# children 27 months of age",?36,$$C(CIMGY,0,9),?54,$$C(CIMGX,0,9)
 W !?3,"# immunized with basic series",?36,$$C(CIMG1B,0,9),?44,$J(CIMG1BP,6,1),?54,$$C(CIMG1,0,9),?62,$J(CIMG1P,6,1),?72,$J($$CALC(CIMG1P,CIMG1BP),7)
IND2023 ;
 D IND2023^CIMGAGPT
 Q:CIMQUIT
 D ^CIMGAGPT Q:CIMQUIT
 D ^CIMGAGPS
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
 W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
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
