ACDRLS ;IHS/ADC/EDE/KML - SHOW SCREENS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
SHOWP ;EP
 I '$D(ACDDONE) W:$D(IOF) @IOF
 W !!?6,"PRINT Items Selected:"
 I ACDCTYP="S" W !?12,"Report includes sub-totals and total only." Q
 I ACDCTYP="T" W !?12,"Report will includes total only." Q
 Q:'$D(^ACDRPTD(ACDRPT,12))
 S (ACDI,ACDTCW)=0 F  S ACDI=$O(^ACDRPTD(ACDRPT,12,ACDI)) Q:ACDI'=+ACDI  S ACDCRIT=$P(^ACDRPTD(ACDRPT,12,ACDI,0),U) D
 .W !?12,$P(^ACDTITEM(ACDCRIT,0),U)," - column width ",$P(^ACDRPTD(ACDRPT,12,ACDI,0),U,2) S ACDTCW=ACDTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^ACDRL01 W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",ACDTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(ACDDONE) S ACDLHDR="REPORT SUMMARY" W ?((80-$L(ACDLHDR))/2),ACDLHDR,!
 W !!?6,$S(ACDPTVS="V":"VISIT",1:"PATIENT")_" Selection Criteria"
 W:ACDPTVS="V" !?12,"Visit Date range:  ",ACDBDD," to ",ACDEDD
 I $D(ACDRDTR),$D(ACDBDD) W !,"Visit Date range:  ",ACDBDD," to ",ACDEDD,"."
 Q:'$D(^ACDRPTD(ACDRPT,11))
 S ACDI=0 F  S ACDI=$O(^ACDRPTD(ACDRPT,11,ACDI)) Q:ACDI'=+ACDI  D
 .I $Y>(IOSL-5) D PAUSE^ACDRL01 W @IOF
 .W !?12,$P(^ACDTITEM(ACDI,0),U),":  "
 .K ACDQ
 .S ACDY=0,ACDC=0 F  S ACDY=$O(^ACDRPTD(ACDRPT,11,ACDI,11,"B",ACDY)) S ACDC=ACDC+1 Q:ACDY=""!($D(ACDQ))  W:ACDC'=1 " ; " S X=ACDY X:$D(^ACDTITEM(ACDI,2)) ^(2) W X
 K ACDC,ACDQ
 Q
SHOWR ;EP
 I '$D(ACDDONE) W:$D(IOF) @IOF
 W !!?6,$S(ACDPTVS="V":"Visit",1:"Patient")_" SORTING Criteria"
 W:ACDPTVS="V"&('$D(ACDDONE)) !?12,"Visit Date range:  ",ACDBDD," to ",ACDEDD
 Q:'$G(ACDSORT)
 W !?12,$S(ACDPTVS="V":"Visits",1:"Patients")_" will be sorted by:  ",$P(^ACDTITEM(ACDSORT,0),U),!
 Q
