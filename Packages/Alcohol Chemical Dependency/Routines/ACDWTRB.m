ACDWTRB ;IHS/ADC/EDE/KML - GET TRIBE TO RUN REPORTS FOR 10:14;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;********************************************************
 ;//^ACDWRQ
 ;User is running CDMIS reports by tribe. A futher breakdown is now
 ;determined. Run ALL or SELECTED or CATEGORY
 ;This routine will return a ACDTRB(array) that holds the
 ;six digit code for area service tribe or "*ALL*"
 ;*********************************************************
 ;
EN ;
 K ACDTRB,DIR,DIC
 S DIR(0)="S^1:Print 'ALL' tribes;2:Print 'SELECTED' tribes;3:Print 'CATEGORY' of tribes",DIR("A")="Tribe Print Criteria" D ^DIR G:Y="^" K D @Y,K Q
1 ;All tribes
 S ACDTRB("*ALL*")=""
 S ACDLOC=ACDLOC_" / "_"*ALL TRIBES*"
 Q
2 ;On the fly selected tribes
 S ACDLOC=ACDLOC_" / "_"SELECTED TRIBES"
 F  S DIC=9999999.03,DIC(0)="AEQZM" D ^DIC G:Y<0 K S ACDTRB($P(Y(0),U,2))=""
 Q
3 ;Category
 S DIC="^ACDTRB(",DIC(0)="AEQM" D ^DIC G:Y<0 K S ACDTRB("C")=$P(Y,U,2)
 S ACDLOC=ACDLOC_" / "_"TRIBE CATEGORY: "_ACDTRB("C")
 I $D(^ACDTRB(+Y,1,0)) F ACDDA=0:0 S ACDDA=$O(^ACDTRB(+Y,1,ACDDA)) Q:'ACDDA  I $D(^(ACDDA,0)) S ACDTRBP=^(0),ACDTRBP=$P(^AUTTTRI(ACDTRBP,0),U,2),ACDTRB(ACDTRBP)=""
 Q
K ;
 I '$D(ACDTRB) S ACDQUIT=1
 K DIC,DIR,ACDTRBP,Y
