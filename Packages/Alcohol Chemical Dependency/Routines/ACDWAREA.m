ACDWAREA ;IHS/ADC/EDE/KML - GET AREA TO RUN REPORTS FOR 11/17/93;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;************************************************************
 ;//^ACDWRQ
 ;User is running CDMIS reports by area. A futher breakdown is now
 ;determined. Run ALL or SELECTED or CATEGORY
 ;This routine will return a ACDAREA(array) that holds the
 ;2 digit code for the area's or "*ALL*"
 ;*************************************************************
EN ;
 K ACDAREA,DIR
 S DIR(0)="S^1:Print 'ALL' areas;2:Print 'SELECTED' areas;3:Print a 'CATEGORY' of areas",DIR("A")="Area Print Criteria" D ^DIR S:X["^" ACDQUIT=1 G:$D(ACDQUIT) K D @Y,K Q
1 ;All areas
 S ACDLOC="*ALL AREAS*"
 S ACDAREA("*ALL*")=""
 Q
2 ;On the fly selected area's
 S ACDLOC="SELECTED AREAS:"
 F  S DIC="^AUTTAREA(",DIC(0)="AEQ" D ^DIC G:Y<0 K I $D(^AUTTAREA(+Y,0)),$P(^(0),U,2)'="" S ACDAREA($P(^(0),U,2))=""
 Q
3 ;Category
 S DIC="^ACDAREA(",DIC(0)="AEQ" D ^DIC G:Y<0 K S ACDAREA("C")=$P(Y,U,2)
 S ACDLOC="AREA CATEGORY: "_ACDAREA("C")
 I $D(^ACDAREA(+Y,1,0)) F ACDDA=0:0 S ACDDA=$O(^ACDAREA(+Y,1,ACDDA)) Q:'ACDDA  I $D(^(ACDDA,0)) S ACDAREAP=^(0) I $D(^AUTTAREA(ACDAREAP,0)),$P(^(0),U,2)'="" S ACDAREA($P(^(0),U,2))=""
 Q
K ;
 I '$D(ACDAREA) S ACDQUIT=1
 K ACDAREAP,DIC,Y,DIR
