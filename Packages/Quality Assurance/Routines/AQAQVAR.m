AQAQVAR ;IHS/ANMC/LJF - MENU ENTRY AND EXIT ACTIONS [ 09/28/92  1:30 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
ENTER ;EP;***> entry actions for AQAQ MENU
 S Y=0,Y=$O(^DIC(9.4,"C","AQAQ",Y)),AQAQ("VERS")=^DIC(9.4,Y,"VERSION")
 S Y=$P(^DIC(9.4,Y,22,AQAQ("VERS"),0),U,2) X ^DD("DD") S AQAQ("VERDT")=Y
 ;
 D ^XBCLS W !?22 F AQAQ("I")=1:1:35 W "*"
 W !?22,"*",?56,"*",!?22,"*      INDIAN HEALTH SERVICE      *"
 W !?22,"*    MEDICAL STAFF CREDENTIALS    *"
 W !?22,"*     VERSION ",AQAQ("VERS"),", ",AQAQ("VERDT"),?56,"*"
 W !?22,"*",?56,"*",!?22 F AQAQ("I")=1:1:35 W "*"
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE STAFF CREDENTIALS!" S XQUIT=1 G XQUIT
 S X=$S($D(^DIC(4,DUZ(2),0))#2:$P(^(0),U),1:"") W !!?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=""
 ;
QUEUE ;check if delinquent report is queued
 G XQUIT:'$D(^ADGIC) G XQUIT:'$O(^ADGIC(0))  ;not running Incomp Charts
 S AQAQX=$O(^DIC(19,"B","AQAQ DELINQUENT ADD",0))
 I AQAQX="" W *7,!!?13,"**OPTION TO RUN DELINQUENT CHART NUMBERS IS MISSING!**",!?23,"**PLEASE CALL YOUR SITE MANAGER**" G XQUIT
 I $P($G(^DIC(19,AQAQX,200)),U)<DT W *7,!!?11,"**OPTION TO TRACK DELINQUENT CHART NUMBERS IS NOT QUEUED!!**",!?20,"**PLEASE CHECK WITH YOUR SITE MANAGER**",!! G XQUIT
 W !!?3,"**DELINQUENT CHART TRACKING OPTION Scheduled to run on "
 S Y=$P(^DIC(19,AQAQX,200),U) X ^DD("DD") W Y,"**"
 S AQAQY=$P(^DIC(19,AQAQX,200),U,3),AQAQZ=$E(AQAQY,$L(AQAQY))
 W !?18,"**Rescheduling frequency is every ",+AQAQY," "
 W $S(AQAQZ="D":"day",AQAQZ="M":"month",AQAQZ="H":"hour",1:"second")
 W:+AQAQY>1 "s" W "**"
XQUIT W ! K AQAQ,X,Y,AQAQX,AQAQY,AQAQZ
 Q
 ;
 ;
RPTENT ;EP;***> entry action for reports menu
 S X="CREDENTIALS REPORTS MENU" W @IOF,!!?80-$L(X)\2,X
 S X=$S($D(^DIC(4,DUZ(2),0))#2:$P(^(0),U),1:"") W !!?80-$L(X)\2,X
 K X Q
 ;
 ;
SUPENT ;EP;***> entry action for supervisor menu
 S X="CREDENTIALS SUPERVISOR MENU" W @IOF,!!?80-$L(X)\2,X
 S X=$S($D(^DIC(4,DUZ(2),0))#2:$P(^(0),U),1:"") W !!?80-$L(X)\2,X
 K X Q
 ;
 ;
PRTOPT ;EP;***> exit action for print options
 K DIR S DIR(0)="E",DIR("A")="Hit <RETURN> to continue" D ^DIR W @IOF
 K DIR Q
 ;
 ;
XIT ;EP;***> exit actions for AQAQ MENU
 Q
