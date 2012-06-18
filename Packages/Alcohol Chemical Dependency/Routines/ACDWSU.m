ACDWSU ;IHS/ADC/EDE/KML - GET SERVICE UNIT TO RUN REPORT;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;**********************************************************
 ;//^ACDWRQ
 ;User is running reports by service units. A futher breakdown is now
 ;determined. Run ALL or SELECTED or CATEGORY
 ;This routine will return a ACDSU(array) that holds the
 ;four digit code associated with the area survice unit or "*ALL*"
 ;************************************************************
EN ;
 K ACDSU,DIR
 S DIR(0)="S^1:Print 'ALL' service units;2:Print 'SELECTED' service units;3:Print 'CATEGORY' of service units",DIR("A")="Service Unit Print Criteria" D ^DIR S:X["^" ACDQUIT=1 G:$D(ACDQUIT) K D @Y,K Q
1 ;All service units
 S ACDLOC="*ALL SERVICE UNITS*"
 S ACDSU("*ALL*")=""
 Q
2 ;On the fly selected service units
 S ACDLOC="SELECTED SERVICE UNITS:"
 F  S DIC="^AUTTSU(",DIC(0)="AEQ" D ^DIC G:Y<0 K I $D(^AUTTSU(+Y,0)),$P(^(0),U,4)'="" S ACDSU($P(^(0),U,4))=""
 Q
3 ;Category of service units
 S DIC="^ACDSU(",DIC(0)="AEQ" D ^DIC G:Y<0 K S ACDSU("C")=$P(Y,U,2)
 S ACDLOC="SERVICE UNIT CATEGORY: "_ACDSU("C")
 I $D(^ACDSU(+Y,1,0)) F ACDDA=0:0 S ACDDA=$O(^ACDSU(+Y,1,ACDDA)) Q:'ACDDA  I $D(^(ACDDA,0)) S ACDSUP=^(0) I $D(^AUTTSU(ACDSUP,0)),$P(^(0),U,4)'="" S ACDSU($P(^(0),U,4))=""
 Q
K ;
 I '$D(ACDSU) S ACDQUIT=1
 K ACDSUP,DIC,DIR,Y
