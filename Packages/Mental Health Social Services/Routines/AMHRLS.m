AMHRLS ; IHS/CMI/LAB - SHOW SCREENS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
SHOWP ;EP
 I '$D(AMHDONE) W:$D(IOF) @IOF
 W !!?6,"PRINT Items Selected:"
 I AMHCTYP="S" W !?12,"Report includes sub-totals and total only." Q
 I AMHCTYP="T" W !?12,"Report will include total only." Q
 Q:'$D(^AMHTRPT(AMHRPT,12))
 S (AMHI,AMHTCW)=0 F  S AMHI=$O(^AMHTRPT(AMHRPT,12,AMHI)) Q:AMHI'=+AMHI  S AMHCRIT=$P(^AMHTRPT(AMHRPT,12,AMHI,0),U) D
 .W !?12,$P(^AMHSORT(AMHCRIT,0),U)," - column width ",$P(^AMHTRPT(AMHRPT,12,AMHI,0),U,2) S AMHTCW=AMHTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^AMHRL01 W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",AMHTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(AMHDONE) S AMHLHDR="REPORT SUMMARY" W ?((80-$L(AMHLHDR))/2),AMHLHDR,!
 W !!?6,AMHPTTX_" Selection Criteria"
 W:AMHTYPE="D" !?12,"Encounter Date range:  ",AMHBDD," to ",AMHEDD
 W:AMHTYPE="S" !?12,"Search Template: ",$P(^DIBT(AMHSEAT,0),U)
 I $D(AMHRDTR),$D(AMHBDD) W !,"Encounter Date range:  ",AMHBDD," to ",AMHEDD,"."
 Q:'$D(^AMHTRPT(AMHRPT,11))
 S AMHI=0 F  S AMHI=$O(^AMHTRPT(AMHRPT,11,AMHI)) Q:AMHI'=+AMHI  D
 .I $Y>(IOSL-5) D PAUSE^AMHRL01 W @IOF
 .W !?12,$P(^AMHSORT(AMHI,0),U),":  "
 .K AMHQ
 .S AMHY=0,AMHC=0 F  S AMHY=$O(^AMHTRPT(AMHRPT,11,AMHI,11,"B",AMHY)) S AMHC=AMHC+1 Q:AMHY=""!($D(AMHQ))  W:AMHC'=1 " ; " S X=AMHY X:$D(^AMHSORT(AMHI,2)) ^(2) W X
 K AMHC,AMHQ
 Q
SHOWR ;EP
 I '$D(AMHDONE) W:$D(IOF) @IOF
 W !!?6,AMHPTTX_" SORTING Criteria"
 W:AMHTYPE="D"&('$D(AMHDONE)) !?12,"Encounter Date range:  ",AMHBDD," to ",AMHEDD
 W:AMHTYPE="S"&('$D(AMHDONE)) !?12,"Search Template: ",$P(^DIBT(AMHSEAT,0),U)
 Q:'$G(AMHSORT)
 W !?12,AMHPTTS_" will be sorted by:  ",$P(^AMHSORT(AMHSORT,0),U),!
 Q
