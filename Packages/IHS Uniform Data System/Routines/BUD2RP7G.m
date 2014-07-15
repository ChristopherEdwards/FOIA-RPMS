BUD2RP7G ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
 ;
DMRACE1 ;EP - called from taskman
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 ;S BUDQUIT=0
 D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?29,"|",?39,"NON-HISPANIC/LATINO (2)",?69,"|",!
 W ?29,"|",?39,"|",?49,"|",?59,"|",?62,"Black/",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?39,"|",?42,"Native",?49,"|",?51,"Pacific",?59,"|",?61,"African",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?32,"Asian",?39,"|",?42,"Hawaiian",?49,"|",?51,"Islander",?59,"|",?61,"American",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?33,"(a)",?39,"|",?42,"(b1)",?49,"|",?52,"(b2)",?59,"|",?62,"(c)",?69,"|",!  ;,?79,"|",!
 D LINE^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?69,"|",!
 W $$CTR("SECTION C:  DIABETES BY RACE AND HISPANIC/LATINO IDENTITY",69),?69,"|",!  ;,?79,"|",!
 D LINE^BUD2RP7F
 W $$CTR("Patients 18 to 75 diagnosed with Type I or Type II diabetes:",69),?69,"|",!,$$CTR("Most recent test results",69),?69,"|",!  ;,?79,"|",!
 D LINE^BUD2RP7F
 W ?2,"9",?5,"Total diabetic",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTC(9)),U,9)),?39,"|",$$C($P($G(BUDSECTC(9)),U,10)),?49,"|",$$C($P($G(BUDSECTC(9)),U,11)),?59,"|",$$C($P($G(BUDSECTC(9)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?1,"10",?5,"Charts sampled /",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTC(10)),U,9)),?39,"|",$$C($P($G(BUDSECTC(10)),U,10)),?49,"|",$$C($P($G(BUDSECTC(10)),U,11)),?59,"|",$$C($P($G(BUDSECTC(10)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?1,"11",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c < 7%",?29,"|",$$C($P($G(BUDSECTC(11)),U,9)),?39,"|",$$C($P($G(BUDSECTC(11)),U,10)),?49,"|",$$C($P($G(BUDSECTC(11)),U,11)),?59,"|",$$C($P($G(BUDSECTC(11)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?1,"12a",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c >= 7% and < 8%",?29,"|",$$C($P($G(BUDSECTC(12.1)),U,9)),?39,"|",$$C($P($G(BUDSECTC(12.1)),U,10)),?49,"|",$$C($P($G(BUDSECTC(12.1)),U,11)),?59,"|",$$C($P($G(BUDSECTC(12.1)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?1,"12b",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c >= 8% and <= 9% ",?29,"|",$$C($P($G(BUDSECTC(12.2)),U,9)),?39,"|",$$C($P($G(BUDSECTC(12.2)),U,10)),?49,"|",$$C($P($G(BUDSECTC(12.2)),U,11)),?59,"|",$$C($P($G(BUDSECTC(12.2)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H^BUD2RP7F
 W ?1,"13",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c > 9% OR No",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"test during year",?29,"|",$$C($P($G(BUDSECTC(13)),U,9)),?39,"|",$$C($P($G(BUDSECTC(13)),U,10)),?49,"|",$$C($P($G(BUDSECTC(13)),U,11)),?59,"|",$$C($P($G(BUDSECTC(13)),U,12)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUD2RP7F
 Q
DMRACE2 ;EP - second page of sections a,b
 D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?29,"|",?41,"NON-HISPANIC/LATINO (2)",?59,"|",!
 W ?29,"|",?31,"American",?39,"|",?49,"|",?52,"More",?59,"|",?60,"Unreport-",?69,"|",! ;?79,"|",!
 W ?29,"|",?31,"Indian/",?39,"|",?42,"",?49,"|",?52,"than",?59,"|",?60,"ed/",?69,"|",! ;?79,"|",!
 W ?29,"|",?31,"Alaska",?39,"|",?42,"",?49,"|",?52,"one",?59,"|",?60,"Refused",?69,"|",! ;?79,"|",!
 W ?29,"|",?31,"Native",?39,"|",?42,"White",?49,"|",?52,"race",?59,"|",?60,"to Report",?69,"|",! ;?72,"Total",?79,"|",!
 W ?29,"|",?33,"(d)",?39,"|",?42,"(e)",?49,"|",?52,"(f)",?59,"|",?62,"(g)",?69,"|",! ;?72,"(h)",?79,"|",!
 D LINE^BUD2RP7F
 I $Y>(IOSL-16) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?69,"|",!
 W $$CTR("SECTION C: DIABETES BY RACE AND HISPANIC/LATINO IDENTITY",70),?69,"|",!
 D LINE^BUD2RP7F
 W $$CTR("Patients 18 to 75 diagnosed with Type I or Type II",70),?69,"|",!
 W $$CTR("diabetes: Most recent test results",70),?69,"|",!
 D LINE^BUD2RP7F
 W ?2,"9",?5,"Total diabetic",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 ;W ?5,"18 + with Type I or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTC(9)),U,13)),?39,"|",$$C($P($G(BUDSECTC(9)),U,14)),?49,"|",$$C($P($G(BUDSECTC(9)),U,15)),?59,"|",$$C($P($G(BUDSECTC(9)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(9)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?2,"10",?5,"Charts sampled /",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTC(10)),U,13)),?39,"|",$$C($P($G(BUDSECTC(10)),U,14)),?49,"|",$$C($P($G(BUDSECTC(10)),U,15)),?59,"|",$$C($P($G(BUDSECTC(10)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(10)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?2,"11",?5,"Patients with",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"HBA1c < 7%",?29,"|",$$C($P($G(BUDSECTC(11)),U,13)),?39,"|",$$C($P($G(BUDSECTC(11)),U,14)),?49,"|",$$C($P($G(BUDSECTC(11)),U,15)),?59,"|",$$C($P($G(BUDSECTC(11)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(11)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?1,"12a",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"HBA1c >= 7% and < 8%",?29,"|",$$C($P($G(BUDSECTC(12.1)),U,13)),?39,"|",$$C($P($G(BUDSECTC(12.1)),U,14)),?49,"|",$$C($P($G(BUDSECTC(12.1)),U,15)),?59,"|",$$C($P($G(BUDSECTC(12.1)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(12)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?1,"12b",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"HBA1c >= 8% and <= 9% ",?29,"|",$$C($P($G(BUDSECTC(12.2)),U,13)),?39,"|",$$C($P($G(BUDSECTC(12.2)),U,14)),?49,"|",$$C($P($G(BUDSECTC(12.2)),U,15)),?59,"|",$$C($P($G(BUDSECTC(12.2)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(12)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
 I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T7H1^BUD2RP7F
 W ?2,"13",?5,"Patients with",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"HBA1c > 9% OR No",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",! ;?79,"|",!
 W ?5,"test during year",?29,"|",$$C($P($G(BUDSECTC(13)),U,13)),?39,"|",$$C($P($G(BUDSECTC(13)),U,14)),?49,"|",$$C($P($G(BUDSECTC(13)),U,15)),?59,"|",$$C($P($G(BUDSECTC(13)),U,16)),?69,"|",! ;$$C($P($G(BUDSECTC(13)),U,9)),?79,"|",!
 D LINE1^BUD2RP7F
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
