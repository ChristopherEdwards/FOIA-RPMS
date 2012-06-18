BUD0RP7P ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 03 Dec 2010 6:10 AM 30 Dec 2010 8:12 PM ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;
 ;
PRINT ;EP
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 S BUDQUIT=0
 D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?29,"|Unreported/Refused",?49,"|",?69,"|",!
 W ?29,"|to Report Race and",?49,"|",?55,"Total",?69,"|",!
 W ?29,"|Identity (h)",?49,"|",?56,"(i)",?69,"|",!
 D LINE
 W "HIV Positive",?29,"|",?49,"|",?69,"|",!,"Pregnant Women",?29,"|*******************",?49,"|",$$C($P($G(BUDSECTH(1)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1
 W "(NO PRENATAL CARE PROVIDED?  CHECK HERE:  "_$S(BUDPREN=0:"X",1:""),")",?69,"|",!
 D LINE
 W $$CTR("SECTION A: DELIVERIES AND BIRTH WEIGHT BY RACE",80),?69,"|",!,$$CTR("AND HISPANIC/LATINO IDENTITY",80),?69,"|",!
 D LINE
 ;W $$CTR("Deliveries and Babies by birth weight"),?69,"|",!
 ;D LINE
 W ?2,"1",?5,"Prenatal care patients",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"who delivered during ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"the year",?29,"|  ",BUDXX,?49,"|  ",BUDXX,?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"2",?5,"Deliveries performed",?29,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"by Grantee Provider",?29,"|***************************************",?69,"|",!  ;,?79,"|",!
 D LINE2
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"3",?5,"Live Births <1500",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"grams",?29,"|  ",BUDXX,?49,"|  ",BUDXX,?69,"|",!  ;,?79,"|",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"4",?5,"Live Births 1500-",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"2499 grams",?29,"|  ",BUDXX,?49,"|  ",BUDXX,?69,"|",!  ;,?79,"|",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"5",?5,"Live Births >=2500",?29,"|  ",BUDXX,?49,"|  ",BUDXX,?69,"|",!  ;,?79,"|",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 ;SECTION B
 I $Y>(IOSL-16) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?69,"|",!
 W $$CTR("SECTION B: HYPERTENSION BY RACE AND HISPANIC/LATINO IDENTITY",70),?69,"|",!  ;,?79,"|",!
 D LINE
 W $$CTR("Patients 18 to 85 diagnosed with hypertension whose last ",70),?69,"|",!  ;,?79,"|",!
 W $$CTR("blood pressure was less than 140/90",70),?69,"|",!  ;,?79,"|",!
 D LINE
 W ?2,"6",?5,"Total hypertensive",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTB(6)),U,17)),?49,"|",$$C($P($G(BUDSECTB(6)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"7",?5,"Charts sampled or",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTB(7)),U,17)),?49,"|",$$C($P($G(BUDSECTB(7)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD0RPTP Q:BUDQUIT  D T7H
 W ?2,"8",?5,"Patients with ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 ;W ?5,"controlled blood",?29,"|",?49,"|",?69,"|",?79,"|",!
 W ?5,"HTN controlled",?29,"|",$$C($P($G(BUDSECTB(8)),U,17)),?49,"|",$$C($P($G(BUDSECTB(8)),U,18)),?69,"|",!
 D LINE1
 D DMRACE1^BUD0RP7Q  ;rest of page 1
 Q
 ;
 ;
T7H ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!,$$REPEAT^XLFSTR("_",69),!  ;,!?41,"HISPANIC/LATINO",!
 Q
LINE ;EP
 W $$REPEAT^XLFSTR("_",69),?69,"|",!
 Q
LINE1 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",19),?49,"|",$$REPEAT^XLFSTR("_",19),?69,"|",!  ;$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE2 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",39),?69,"|",! ;_________",?79,"|",!
 Q
 ;
LINE3 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",49),?79,"|",!
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
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "********"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
