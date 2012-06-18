FHZVARS ;IHS/ANMC/LJF - MAIN MENU ENTRY ACTIONS ; [ 10/18/94  9:33 AM ]
 ;;3.16;DIETETICS;**1**;NOV 01, 1990
 ;
 ;set FHPAR - site parameter variable
 S X=^DD("SITE",1),FHPAR=$S($D(^FH(119.9,X,0)):^(0),1:"")
 ;
RVON ;set reverse video variables
 S FHNULL="",(FHZRVN,FHZRVF)="FHNULL"
 I $D(^%ZIS(2,IOST(0),5)) S FHZRVN=$P(^(5),"^",4),FHZRVF=$P(^(5),"^",5)
 ;
L1 D ^XBCLS W !?33,"*************",!,?29,"****",?46,"****" ;IHS/ORDC/LJF 10/17/94 PATCH #1
 W !,?27,"****",?48,"****"
L2 W !,?25,"***"," INDIAN HEALTH SERVICE ","***"
 W !,?26,"***  "," DIETETICS SYSTEM "," ***"
 S X=$O(^DIC(9.4,"C","FH",0))
 I X="" W !!,"VERSION ERROR; NOTIFY YOUR SITE MANAGER!",!! Q
VERS W !,?27,"***   "," VERSION ",^DIC(9.4,X,"VERSION")," ","  ***"
 W !,?29,"****",?46,"****",!,?31,"****",?44,"****",!?34,"**********"
 ;
SITE I '$D(DUZ(2)) W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THIS PACKAGE!" S XQUIT=1 Q
 S X=$S($D(^DIC(4,DUZ(2),0))#2:$P(^(0),"^"),1:"") W !!,?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT="" Q
 S SITE=$S($D(^AUTTSITE(1,0)):$P(^(0),"^"),1:"")
 I SITE="" W *7,!!,"RPMS SITE IS NOT DEFINED",!,"NOTIFY YOUR SITE MANGER" S XQUIT=1 Q
 I DUZ(2)'=SITE W *7,!!,"YOU ARE NOT SIGNED ON TO THE RPMS SITE",!,"NOTIFY YOUR SITE MANAGER" S XQUIT=1
 K SITE,X Q
 ;
EXIT K FHZRVN,FHZRVF,FHPAR,FHNULL Q
