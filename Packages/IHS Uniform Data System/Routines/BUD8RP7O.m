BUD8RP7O ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
 ;
DMRACE1 ;EP - called from taskman
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 ;S BUDQUIT=0
 D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?29,"|",?39,"|",?49,"|",?59,"|",?62,"Black/",?69,"|",?79,"|",!
 W ?29,"|",?39,"|",?42,"Native",?49,"|",?51,"Pacific",?59,"|",?61,"African",?69,"|",?79,"|",!
 W ?29,"|",?32,"Asian",?39,"|",?42,"Hawaiian",?49,"|",?51,"Islander",?59,"|",?61,"American",?69,"|",?79,"|",!
 W ?29,"|",?33,"(a)",?39,"|",?42,"(b1)",?49,"|",?52,"(b2)",?59,"|",?62,"(c)",?69,"|",?79,"|",!
 D LINE^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?79,"|",!
 W $$CTR("SECTION C:  DIABETES BY RACE"),?79,"|",!
 D LINE^BUD8RP71
 W $$CTR("Patients diagnosed with Type I or Type II diabetes:  Most recent test results"),?79,"|",!
 D LINE^BUD8RP71
 W ?2,"9",?5,"Total patients aged",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"18 + with Type I or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"II diabetes",?29,"|",$$C($P($G(BUDSECTC(9)),U)),?39,"|",$$C($P($G(BUDSECTC(9)),U,2)),?49,"|",$$C($P($G(BUDSECTC(9)),U,3)),?59,"|",$$C($P($G(BUDSECTC(9)),U,4)),?69,"|",?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?1,"10",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTC(10)),U)),?39,"|",$$C($P($G(BUDSECTC(10)),U,2)),?49,"|",$$C($P($G(BUDSECTC(10)),U,3)),?59,"|",$$C($P($G(BUDSECTC(10)),U,4)),?69,"|",?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?1,"11",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"HBA1c < 7%",?29,"|",$$C($P($G(BUDSECTC(11)),U)),?39,"|",$$C($P($G(BUDSECTC(11)),U,2)),?49,"|",$$C($P($G(BUDSECTC(11)),U,3)),?59,"|",$$C($P($G(BUDSECTC(11)),U,4)),?69,"|",?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?1,"12",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"7% >= HBA1c <= 9%",?29,"|",$$C($P($G(BUDSECTC(12)),U)),?39,"|",$$C($P($G(BUDSECTC(12)),U,2)),?49,"|",$$C($P($G(BUDSECTC(12)),U,3)),?59,"|",$$C($P($G(BUDSECTC(12)),U,4)),?69,"|",?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?1,"13",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"HBA1c > 9%",?29,"|",$$C($P($G(BUDSECTC(13)),U)),?39,"|",$$C($P($G(BUDSECTC(13)),U,2)),?49,"|",$$C($P($G(BUDSECTC(13)),U,3)),?59,"|",$$C($P($G(BUDSECTC(13)),U,4)),?69,"|",?79,"|",!
 D LINE1^BUD8RP71
 Q
DMRACE2 ;EP - second page of sections a,b
 D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?29,"|",?31,"American",?39,"|",?49,"|",?52,"More",?59,"|",?60,"Unreport-",?69,"|",?79,"|",!
 W ?29,"|",?31,"Indian/",?39,"|",?42,"",?49,"|",?52,"than",?59,"|",?60,"ed/",?69,"|",?79,"|",!
 W ?29,"|",?31,"Alaska",?39,"|",?42,"",?49,"|",?52,"one",?59,"|",?60,"Refused",?69,"|",?79,"|",!
 W ?29,"|",?31,"Native",?39,"|",?42,"White",?49,"|",?52,"race",?59,"|",?60,"to Report",?69,"|",?72,"Total",?79,"|",!
 W ?29,"|",?33,"(d)",?39,"|",?42,"(e)",?49,"|",?52,"(f)",?59,"|",?62,"(g)",?69,"|",?72,"(h)",?79,"|",!
 D LINE^BUD8RP71
 I $Y>(IOSL-16) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?79,"|",!
 W $$CTR("SECTION C:  DIABETES BY RACE"),?79,"|",!
 D LINE^BUD8RP71
 W $$CTR("Patients diagnosed with Type I or Type II diabetes:  Most recent test results"),?79,"|",!
 D LINE^BUD8RP71
 W ?2,"9",?5,"Total patients aged",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"18 + with Type I or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"II diabetes",?29,"|",$$C($P($G(BUDSECTC(9)),U,5)),?39,"|",$$C($P($G(BUDSECTC(9)),U,6)),?49,"|",$$C($P($G(BUDSECTC(9)),U,7)),?59,"|",$$C($P($G(BUDSECTC(9)),U,8)),?69,"|",$$C($P($G(BUDSECTC(9)),U,9)),?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?2,"10",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTC(10)),U,5)),?39,"|",$$C($P($G(BUDSECTC(10)),U,6)),?49,"|",$$C($P($G(BUDSECTC(10)),U,7)),?59,"|",$$C($P($G(BUDSECTC(10)),U,8)),?69,"|",$$C($P($G(BUDSECTC(10)),U,9)),?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?2,"11",?5,"Patients with",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"HBA1c < 7%",?29,"|",$$C($P($G(BUDSECTC(11)),U,5)),?39,"|",$$C($P($G(BUDSECTC(11)),U,6)),?49,"|",$$C($P($G(BUDSECTC(11)),U,7)),?59,"|",$$C($P($G(BUDSECTC(11)),U,8)),?69,"|",$$C($P($G(BUDSECTC(11)),U,9)),?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?2,"12",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"7% >= HBA1c <= 9%",?29,"|",$$C($P($G(BUDSECTC(12)),U,5)),?39,"|",$$C($P($G(BUDSECTC(12)),U,6)),?49,"|",$$C($P($G(BUDSECTC(12)),U,7)),?59,"|",$$C($P($G(BUDSECTC(12)),U,8)),?69,"|",$$C($P($G(BUDSECTC(12)),U,9)),?79,"|",!
 D LINE1^BUD8RP71
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H^BUD8RP71
 W ?2,"13",?5,"Patients with",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"HBA1c > 9%",?29,"|",$$C($P($G(BUDSECTC(13)),U,5)),?39,"|",$$C($P($G(BUDSECTC(13)),U,6)),?49,"|",$$C($P($G(BUDSECTC(13)),U,7)),?59,"|",$$C($P($G(BUDSECTC(13)),U,8)),?69,"|",$$C($P($G(BUDSECTC(13)),U,9)),?79,"|",!
 D LINE1^BUD8RP71
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
