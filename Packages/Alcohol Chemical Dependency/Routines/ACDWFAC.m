ACDWFAC ;IHS/ADC/EDE/KML - GET FACILITY TO RUN REPORTS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;********************************************************
 ;//^ACDWRQ
 ;User is running CDMIS reports by facility. A futher breakdown is now
 ;determined. Run ALL or SELECTED or CATEGORY
 ;This routine will return a ACDFAC(array) that holds the
 ;six digit code for area service facility or "*ALL*"
 ;*********************************************************
 ;
EN ;
 K ACDFAC,DIR
 S DIR(0)="S^1:Print 'ALL' facilities;2:Print 'SELECTED' facilities;3:Print 'CATEGORY' of facilities",DIR("A")="Facility Print Criteria" D ^DIR G:Y="^" K D @Y,K Q
1 ;All facilities
 S ACDFAC("*ALL*")=""
 S ACDLOC="*ALL FACILITIES*"
 Q
2 ;On the fly selected facilities
 S ACDLOC="SELECTED FACILITIES"
 F  S DIC=4,DIC(0)="AEQ" D ^DIC G:Y<0 K I $D(^AUTTLOC(+Y,0)),$P(^(0),U,10)'="" S ACDFAC($P(^(0),U,10))=""
 Q
3 ;Category
 S DIC="^ACDFAC(",DIC(0)="AEQ" D ^DIC G:Y<0 K S ACDFAC("C")=$P(Y,U,2)
 S ACDLOC="FACILITY CATEGORY: "_ACDFAC("C")
 I $D(^ACDFAC(+Y,1,0)) F ACDDA=0:0 S ACDDA=$O(^ACDFAC(+Y,1,ACDDA)) Q:'ACDDA  I $D(^(ACDDA,0)) S ACDFACP=^(0) I $D(^AUTTLOC(ACDFACP,0)),$P(^(0),U,10)'="" S ACDFAC($P(^(0),U,10))=""
 Q
K ;
 I '$D(ACDFAC) S ACDQUIT=1
 K DIC,DIR,ACDFACP,Y
