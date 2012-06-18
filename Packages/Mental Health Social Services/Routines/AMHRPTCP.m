AMHRPTCP ; IHS/CMI/LAB - generic report cover page ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
COVPAGE ;EP
 W:$D(IOF) @IOF
 I '$G(AMHSUIC) W !!!?20,"BEHAVIORAL HEALTH RECORD LISTING"
 I $G(AMHSUIC) W !!!?20,"Aggregate Suicide Data Report - Selected Variables"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following visit listing contains BH visits selected based on the",!,"following criteria:",!
SHOW ;
 W !?28,"RECORD SELECTION CRITERIA"
 I $G(AMHRPTC)'=7 W !!,"Encounter Date range:  ",AMHBDD," to ",AMHEDD,!
 I '$D(^AMHTRPT(AMHRPT,11)) G SHOWP
 S AMHI=0 F  S AMHI=$O(^AMHTRPT(AMHRPT,11,AMHI)) Q:AMHI'=+AMHI  D
 .I $Y>(IOSL-4) D PAUSE^AMHRPTU W @IOF
 .K AMHQ W !,$P(^AMHSORT(AMHI,0),U),":  "
 .S Y=0,C=0 F  S Y=$O(^AMHTRPT(AMHRPT,11,AMHI,11,"B",Y)) S C=C+1 Q:Y=""!($D(AMHQ))  W:C'=1 " ; " S X=Y X:$D(^AMHSORT(AMHI,2)) ^(2) W X
SHOWP ;
 I $Y>(IOSL-4) D PAUSE^AMHRPTU W @IOF
 I $D(AMHRPTC) W !!,"Report Type: ",$P(^AMHRCNT(AMHRPTC,0),U,6)
 I '$D(^AMHTRPT(AMHRPT,12)) G PAUSE
 W !!?29,"PRINT FIELD SELECTION",!
 S AMHI=0 F  S AMHI=$O(^AMHTRPT(AMHRPT,12,AMHI)) Q:AMHI'=+AMHI  S AMHCRIT=$P(^AMHTRPT(AMHRPT,12,AMHI,0),U) D
 .I $Y>(IOSL-4) D PAUSE^AMHRPTU W:$D(IOF) @IOF
 .W !,$P(^AMHSORT(AMHCRIT,0),U),"  (" S X=$O(^AMHTRPT(AMHRPT,12,"B",AMHCRIT,"")) W $P(^AMHTRPT(AMHRPT,12,X,0),U,2),")"
 W !,"     TOTAL column width: ",AMHTCW
 I $Y>(IOSL-5) D PAUSE^AMHRPTU W:$D(IOF) @IOF
SORT ;
 I $G(AMHSORT)]"" W !!,"Records will be sorted by:  ",$P(^AMHSORT(AMHSORT,0),U),!
 I $G(AMHSPAG) W !,"Each ",$P(^AMHSORT(AMHSORT,0),U)," will be on a separate page.",!
 I $Y>(IOSL-4) D PAUSE^AMHRPTU W:$D(IOF) @IOF
 I '$D(^XTMP("AMHRPT",AMHJOB,AMHBTH)) W !!,"NO VISITS TO REPORT.",!
PAUSE D PAUSE^AMHRPTU
 Q
