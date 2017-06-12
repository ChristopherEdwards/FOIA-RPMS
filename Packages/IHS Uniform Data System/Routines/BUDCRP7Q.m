BUDCRP7Q ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
 ;
DMRACE1 ;EP - called from taskman
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 ;S BUDQUIT=0
 D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?29,"|",?41,"NON-HISPANIC/LATINO (2)",?69,"|",!
 W ?29,"|Unreported/Refused",?49,"|",?69,"|",!
 W ?29,"|to Report Race and",?49,"|",?55,"Total",?69,"|",!
 W ?29,"|Identity (h)",?49,"|",?56,"(i)",?69,"|",!
 D LINE^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?69,"|",!
 W $$CTR("SECTION C:  DIABETES BY RACE AND HISPANIC/LATINO IDENTITY",69),?69,"|",!  ;,?79,"|",!
 D LINE^BUDCRP7P
 W $$CTR("Patients 18 to 75 diagnosed with Type I or Type II diabetes:",69),?69,"|",!,$$CTR("Most recent test results",69),?69,"|",!  ;,?79,"|",!
 D LINE^BUDCRP7P
 W ?2,"9",?5,"Total diabetic",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTC(9)),U,17)),?49,"|",$$C($P($G(BUDSECTC(9)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?1,"10",?5,"Charts sampled /",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTC(10)),U,17)),?49,"|",$$C($P($G(BUDSECTC(10)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?1,"11",?5,"Patients with ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c < 7%",?29,"|",$$C($P($G(BUDSECTC(11)),U,17)),?49,"|",$$C($P($G(BUDSECTC(11)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?1,"12a",?5,"Patients with ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c >= 7% and < 8%",?29,"|",$$C($P($G(BUDSECTC(12.1)),U,17)),?49,"|",$$C($P($G(BUDSECTC(12.1)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?1,"12b",?5,"Patients with ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c >= 8% and <= 9%",?29,"|",$$C($P($G(BUDSECTC(12.2)),U,17)),?49,"|",$$C($P($G(BUDSECTC(12.2)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T7H^BUDCRP7P
 W ?1,"13",?5,"Patients with ",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"HBA1c > 9% OR No",?29,"|",?49,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"test during year",?29,"|",$$C($P($G(BUDSECTC(13)),U,17)),?49,"|",$$C($P($G(BUDSECTC(13)),U,18)),?69,"|",!  ;,?79,"|",!
 D LINE1^BUDCRP7P
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
