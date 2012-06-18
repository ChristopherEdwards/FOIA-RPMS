ACMRLS ; IHS/TUCSON/TMJ - APC visit counts - show screens ; [ 06/01/1999  1:43 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**1**;JAN 10, 1996
 ;
SHOWP ;EP
 I '$D(ACMDONE) W:$D(IOF) @IOF
 I ACMCTYP="F" D FLAT Q  ;IHS/CMI/LAB
 W !!?6,"PRINT Items Selected:"
 I ACMCTYP="S" W !,?12,"Report includes sub-totals and total only." Q
 I ACMCTYP="T" W !,?12,"Report will includes total only." Q
 Q:'$D(^ACM(58.8,ACMRPT,12))
 S (ACMI,ACMTCW)=0 F  S ACMI=$O(^ACM(58.8,ACMRPT,12,ACMI)) Q:ACMI'=+ACMI  S ACMCRIT=$P(^ACM(58.8,ACMRPT,12,ACMI,0),U) D
 .W !?12,$P(^ACM(58.1,ACMCRIT,0),U)," - column width ",$P(^ACM(58.8,ACMRPT,12,ACMI,0),U,2) S ACMTCW=ACMTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^ACMRL01 W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",ACMTCW
 Q
FLAT ;IHS/CMI/LAB - flat file
 W !!?6,"Items selected for flat file output:"
 S (ACMI,ACMTCW)=0 F  S ACMI=$O(^ACM(58.8,ACMRPT,12,ACMI)) Q:ACMI'=+ACMI  S ACMCRIT=$P(^ACM(58.8,ACMRPT,12,ACMI,0),U) D
 .W !?12,$P(^ACM(58.1,ACMCRIT,0),U)
 .I $Y>(IOSL-5) D PAUSE^ACMRL01 W:$D(IOF) @IOF
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(ACMDONE) S ACMLHDR="REPORT SUMMARY" W ?((80-$L(ACMLHDR))/2),ACMLHDR,!
 W !!?6,"CMS REGISTER PATIENT Selection Criteria:"
 Q:'$D(^ACM(58.8,ACMRPT,11))
 S ACMI=0 F  S ACMI=$O(^ACM(58.8,ACMRPT,11,ACMI)) Q:ACMI'=+ACMI  D
 .I $Y>(IOSL-5) D PAUSE^ACMRL01 W @IOF
 .W !?12,$P(^ACM(58.1,ACMI,0),U),":  "
 .K ACMQ
 .S ACMY=0,ACMC=0 F  S ACMY=$O(^ACM(58.8,ACMRPT,11,ACMI,11,"B",ACMY)) S ACMC=ACMC+1 Q:ACMY=""!($D(ACMQ))  W:ACMC'=1 " ; " S X=ACMY X:$D(^ACM(58.1,ACMI,2)) ^(2) W X
 K ACMC,ACMQ
 Q
SHOWR ;EP
 I '$D(ACMDONE) W:$D(IOF) @IOF
 W !!?6,"CMS REGISTER PATIENT SORTING Criteria:"
 Q:'$G(ACMSORT)
 W !?12,"CMS REGISTER PATIENTS will be sorted by:  ",$P(^ACM(58.1,ACMSORT,0),U),!
 Q
