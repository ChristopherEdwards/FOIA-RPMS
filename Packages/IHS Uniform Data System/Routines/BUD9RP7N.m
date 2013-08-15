BUD9RP7N ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
 ;
ETHN ;EP - called from taskman
 ;S BUDPG=0
 ;W:$D(IOF) @IOF
 S BUDQUIT=0
 D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?33,"|",?48,"|",?50,"All Other",?63,"|",?78,"|",!
 W ?33,"|",?48,"|",?50,"including",?63,"|",?78,"|",!
 W ?33,"|",?48,"|",?50,"Unreported/",?63,"|",?78,"|",!
 W ?33,"|",?35,"Hispanic",?48,"|",?51,"Refused to",?63,"|",?78,"|",!
 W ?33,"|",?35,"or Latino",?48,"|",?51,"Report",?63,"|",?67,"TOTAL",?78,"|",!
 W ?33,"|",?37,"(i)",?48,"|",?52,"(j)",?63,"|",?67,"(k)",?78,"|",!
 D LINE1
 W $$CTR("SECTION D: DELIVERIES AND LOW BIRTH WEIGHT BY ETHNICITY"),?78,"|",!
 D LINE
 W $$CTR("Deliveries and Babies by birth weight"),?78,"|",!
 D LINE
 W ?2,"1",?5,"Prenatal care patients",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"who delivered during",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"the year",?33,"|",?48,"|",?63,"|",?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"2",?5,"Live Births ",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"< 1500 grams",?33,"|",?48,"|",?63,"|",?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"3",?5,"Live Births 1500-",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"2400 grams",?33,"|",?48,"|",?63,"|",?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"4",?5,"Live Births ",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,">= 2400 grams",?33,"|",?48,"|",?63,"|",?78,"|",!
 D LINE1
 W $$CTR("SECTION E: HYPERTENSION BY ETHNICITY"),?78,"|",!
 D LINE
 W $$CTR("Patients diagnosed with hypertension whose last blood pressure"),?78,"|",!
 W $$CTR("was less than 140/90"),?78,"|",!
 D LINE
 W ?2,"6",?5,"Total patients aged",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"18 + with hypertension",?33,"|",$$C($P($G(BUDSECTE(6)),U)),?48,"|",$$C($P($G(BUDSECTE(6)),U,2)),?63,"|",$$C($P($G(BUDSECTE(6)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"7",?5,"Charts sampled or EHR Total",?33,"|",$$C($P($G(BUDSECTE(7)),U)),?48,"|",$$C($P($G(BUDSECTE(7)),U,2)),?63,"|",$$C($P($G(BUDSECTE(7)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"8",?5,"Patients with controlled",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"blood pressure",?33,"|",$$C($P($G(BUDSECTE(8)),U)),?48,"|",$$C($P($G(BUDSECTE(8)),U,2)),?63,"|",$$C($P($G(BUDSECTE(8)),U,3)),?78,"|",!
 D LINE1
 ;DM
 D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?33,"|",?48,"|",?50,"All Other",?63,"|",?78,"|",!
 W ?33,"|",?48,"|",?50,"including",?63,"|",?78,"|",!
 W ?33,"|",?48,"|",?50,"Unreported/",?63,"|",?78,"|",!
 W ?33,"|",?35,"Hispanic",?48,"|",?51,"Refused to",?63,"|",?78,"|",!
 W ?33,"|",?35,"or Latino",?48,"|",?51,"Report",?63,"|",?67,"TOTAL",?78,"|",!
 W ?33,"|",?37,"(i)",?48,"|",?52,"(j)",?63,"|",?67,"(k)",?78,"|",!
 D LINE1
 W $$CTR("SECTION F: DIABETES BY ETHNICITY"),?78,"|",!
 D LINE
 W $$CTR("Patients diagnosed with Type I or Type II diabetes:  Most recent test results"),?78,"|",!
 D LINE
 W ?2,"9",?5,"Total patients aged",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"18 + with Type I or II",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"diabetes",?33,"|",$$C($P($G(BUDSECTF(9)),U)),?48,"|",$$C($P($G(BUDSECTF(9)),U,2)),?63,"|",$$C($P($G(BUDSECTF(9)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?1,"10",?5,"Charts sampled or EHR Total",?33,"|",$$C($P($G(BUDSECTF(10)),U)),?48,"|",$$C($P($G(BUDSECTF(10)),U,2)),?63,"|",$$C($P($G(BUDSECTF(10)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?1,"11",?5,"Patients with HBA1c < 7%",?33,"|",$$C($P($G(BUDSECTF(11)),U)),?48,"|",$$C($P($G(BUDSECTF(11)),U,2)),?63,"|",$$C($P($G(BUDSECTF(11)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?1,"12",?5,"Patients with ",?33,"|",?48,"|",?63,"|",?78,"|",!
 W ?5,"7% >= HBA1c <= 9%",?33,"|",$$C($P($G(BUDSECTF(12)),U)),?48,"|",$$C($P($G(BUDSECTF(12)),U,2)),?63,"|",$$C($P($G(BUDSECTF(12)),U,3)),?78,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?1,"13",?5,"Patients with HBA1c > 9%",?33,"|",$$C($P($G(BUDSECTF(13)),U)),?48,"|",$$C($P($G(BUDSECTF(13)),U,2)),?63,"|",$$C($P($G(BUDSECTF(13)),U,3)),?78,"|",!
 D LINE1
 Q
T7H ;
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!,$$REPEAT^XLFSTR("_",79),!
 Q
LINE ;
 W $$REPEAT^XLFSTR("_",78),?78,"|",!
 Q
LINE1 ;
 W $$REPEAT^XLFSTR("_",33),?33,"|",$$REPEAT^XLFSTR("_",14),?48,"|",$$REPEAT^XLFSTR("_",14),?63,"|",$$REPEAT^XLFSTR("_",14),?78,"|",!
 Q
LINE2 ;
 W $$REPEAT^XLFSTR("_",33),?33,"|",$$REPEAT^XLFSTR("_",39),?63,"|_________",?78,"|",!
 Q
 ;
LINE3 ;
 W $$REPEAT^XLFSTR("_",33),?33,"|",$$REPEAT^XLFSTR("_",49),?78,"|",!
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
