ACDWSTA ;IHS/ADC/EDE/KML - GET STATE TO RUN REPORTS FOR 10:14;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;********************************************************
 ;//^ACDWRQ
 ;User is running CDMIS reports by state. A futher breakdown is now
 ;determined. Run ALL or SELECTED or CATEGORY
 ;This routine will return a ACDSTA(array) that holds the
 ;six digit code for area service state or "*ALL*"
 ;*********************************************************
 ;
EN ;
 K ACDSTA,DIR,DIC
 S DIR(0)="S^1:Print 'ALL' states;2:Print 'SELECTED' states;3:Print 'CATEGORY' of states",DIR("A")="State Print Criteria" D ^DIR G:Y="^" K D @Y,K Q
1 ;All states
 S ACDSTA("*ALL*")=""
 S ACDLOC=ACDLOC_" / "_"*ALL STATES*"
 Q
2 ;On the fly selected states
 S ACDLOC=ACDLOC_" / "_"SELECTED STATES"
 F  S DIC="^DIC(5,",DIC(0)="AEQZM" D ^DIC G:Y<0 K S ACDSTA($P(Y(0),U,3))=""
 Q
3 ;Category
 S DIC="^ACDSTA(",DIC(0)="AEQM" D ^DIC G:Y<0 K S ACDSTA("C")=$P(Y,U,3)
 S ACDLOC=ACDLOC_" / "_"STATE CATEGORY: "_ACDSTA("C")
 I $D(^ACDSTA(+Y,1,0)) F ACDDA=0:0 S ACDDA=$O(^ACDSTA(+Y,1,ACDDA)) Q:'ACDDA  I $D(^(ACDDA,0)) S ACDSTAP=^(0),ACDSTAP=$P(^DIC(5,ACDSTAP,0),U,3),ACDSTA(ACDSTAP)=""
 Q
K ;
 I '$D(ACDSTA) S ACDQUIT=1
 K DIC,DIR,ACDSTAP,Y
