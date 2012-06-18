CIMGAGPL ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 03/16/00  3:55 PM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
IND44 ;
 D HEADER Q:CIMQUIT
 W !,"4/4  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes who have been assessed for dyslipidemia by 3% over BASELINE level.",!
 W !,"Assessed for Dyslipidemia"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,1,10),CIMGY=$$V(CIMDO,12,10)
 .S CIMG1=$$V(CIMDO,19,1),CIMG1B=$$V(CIMDO,20,1)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND55 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"5/5  Diabetes",!,"Increase the proportion of I/T/U clients with diagnosed",!,"diabetes who have been assessed for nephropathy by 3% over BASELINE level.",!
 W !,"Assessed for Nephropathy"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,1,10),CIMGY=$$V(CIMDO,12,10)
 .S CIMG1=$$V(CIMDO,19,2),CIMG1B=$$V(CIMDO,20,2)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND66 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"6/6  Women's Health",!,"Increase the proportion of AI/AN women who have annual pap screening to 55%.",!
 W !,"Pap Screening"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,3),CIMGY=$$V(CIMDO,20,3)
 .S CIMG1=$$V(CIMDO,19,4),CIMG1B=$$V(CIMDO,20,4)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND77 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"7/7  Women's Health",!,"Increase the proportion of AI/AN female population 40-69 years of age who",!,"had annual screening mammography.",!
 W !,"Mammography Screening"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,5),CIMGY=$$V(CIMDO,20,5)
 .S CIMG1=$$V(CIMDO,19,6),CIMG1B=$$V(CIMDO,20,6)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND88 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"8/8  Child Health",!,"Determine the proportion of AI/AN children served by",!,"IHS receiving a minimum of four Well Child visits by 27 months of age.",!
 W !,"Well Child Visits by Age 27 Months"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,7),CIMGY=$$V(CIMDO,20,7)
 .S CIMG1=$$V(CIMDO,19,8),CIMG1B=$$V(CIMDO,20,8)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1112 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"11/12  Dental Health",!,"Assure that at least 21% of the AI/AN population obtain",!,"access to dental services.",!
 W !,"Dental Visit 0000"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,1,1),CIMGY=$$V(CIMDO,12,1)
 .S CIMG1=$$V(CIMDO,19,9),CIMG1B=$$V(CIMDO,20,9)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1213 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"12/13  Dental Health",!,"Assure that the percentage of AI/AN children 6-8 and 14-15",!,"who have received protective dental sealants on permanent molar teeth is ",!,"restored to 90% of the FY 1991 IHS Oral Health Survey level",!
 W !,"Dental Visit 1351 - Children ages 6-8"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,10),CIMGY=$$V(CIMDO,20,10)
 .S CIMG1=$$V(CIMDO,19,11),CIMG1B=$S($E(CIMPER,1,3)'=299:$$V(CIMDO,20,11),1:"**")
 .I $E(CIMPER,1,3)'=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .I $E(CIMPER,1,3)=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=65.0,CIMGY="**",CIMG1B="**"
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND122 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"12/13  Dental Health",!,"Assure that the percentage of AI/AN children 6-8 and 14-15",!,"who have received protective dental sealants on permanent molar teeth is ",!,"restored to 90% of the FY 1991 IHS Oral Health Survey level",!
 W !,"Dental Visit 1351 - Children ages 14-15"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,27),CIMGY=$$V(CIMDO,20,27)
 .S CIMG1=$$V(CIMDO,19,28),CIMG1B=$S($E(CIMPER,1,3)'=299:$$V(CIMDO,20,28),1:"**")
 .I $E(CIMPER,1,3)'=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .I $E(CIMPER,1,3)=299 S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=62.0,CIMGY="**",CIMG1B="**"
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND1820 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"18/20  Child Health",!,"Immunization  Increase by 3% the proportion of AI/AN",!,"children who have completed all recommended immunizations by the age of two.",!
 W !,"Immunizations Up to date - Children Age 2"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,12),CIMGY=$$V(CIMDO,20,12)
 .S CIMG1=$$V(CIMDO,19,13),CIMG1B=$$V(CIMDO,20,13)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"18/20  Child Health",!,"Immunization  Increase by 3% the proportion of AI/AN",!,"children who have completed all recommended immunizations by the age of two.",!
 W !,"Immunizations Up to date - Children Age 27 Months"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,22,12),CIMGY=$$V(CIMDO,23,12)
 .S CIMG1=$$V(CIMDO,22,13),CIMG1B=$$V(CIMDO,23,13)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
IND2023 ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"20/23 Child Obesity",!,"Identify the Area specific prevalance of obesity in AI/AN",!,"Head Start population (3-5 yr olds) and in third grade children (8-10 year olds)",!
 W !,"Child Obesity - Children ages 3-5"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,23),CIMGY=$$V(CIMDO,20,23)
 .S CIMG1=$$V(CIMDO,19,15),CIMG1B=$$V(CIMDO,20,15)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
A ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"20/23 Child Obesity",!,"Identify the Area specific prevalance of obesity in AI/AN",!,"Head Start population (3-5 yr olds) and in third grade children (8-10 year olds)",!
 W !,"Children Overweight - Children ages 3-5"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,23),CIMGY=$$V(CIMDO,20,23)
 .S CIMG1=$$V(CIMDO,19,29),CIMG1B=$$V(CIMDO,20,29)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT
 .W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
B ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"20/23 Child Obesity",!,"Identify the Area specific prevalance of obesity in AI/AN",!,"Head Start population (3-5 yr olds) and in third grade children (8-10 year olds)",!
 W !,"Child Obesity - Children ages 8-10"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,24),CIMGY=$$V(CIMDO,20,24)
 .S CIMG1=$$V(CIMDO,19,17),CIMG1B=$$V(CIMDO,20,17)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT  W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
C ;
 Q:CIMQUIT
 D HEADER Q:CIMQUIT
 W !,"20/23 Child Obesity",!,"Identify the Area specific prevalance of obesity in AI/AN",!,"Head Start population (3-5 yr olds) and in third grade children (8-10 year olds)",!
 W !,"Children Overweight - Children ages 8-10"
 W !?44,"% CHANGE"
 S CIMDO=0 F  S CIMDO=$O(CIMSUL(CIMDO)) Q:CIMDO'=+CIMDO!(CIMQUIT)  D
 .S CIMGX=$$V(CIMDO,19,24),CIMGY=$$V(CIMDO,20,24)
 .S CIMG1=$$V(CIMDO,19,30),CIMG1B=$$V(CIMDO,20,30)
 .S CIMG1P=$S(CIMGX:((CIMG1/CIMGX)*100),1:""),CIMG1BP=$S(CIMGY:((CIMG1B/CIMGY)*100),1:"")
 .D LOCW Q:CIMQUIT  W ?44,$J($$CALC(CIMG1P,CIMG1BP),7)
 D ^CIMGAGPM
 Q
CALC(N,O) ;ENTRY POINT
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
