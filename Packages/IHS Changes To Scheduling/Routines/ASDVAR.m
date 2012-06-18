ASDVAR ; IHS/ADC/PDW/ENM - MENU ENTRY AND EXIT ACTIONS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 ;This rtn contains the entry & exit actions for the main Scheduling
 ;menu as well as common subrtns for other menus and options.
 ;
 Q
ENTER ;ENTRY POINT entry actions for SDMENU
 S Y=0,Y=$O(^DIC(9.4,"C","SD",Y)),ASD("VERS")=^DIC(9.4,Y,"VERSION")
 S Z=$O(^DIC(9.4,Y,22,"B",ASD("VERS"),0)) I Z="" S XQUIT=1 D XQUIT Q
 S Y=$P(^DIC(9.4,Y,22,Z,0),U,2) X ^DD("DD")
 S ASD("VERDT")=Y
 ;
 D ^XBCLS W !?18 F ASD("I")=1:1:41 W "*"
 W !?18,"*",?58,"*",!?18,"*        INDIAN HEALTH SERVICE          *"
 W !?18,"*       CLINIC SCHEDULING SYSTEM        *"
 W !?18,"*       VERSION ",ASD("VERS"),", ",ASD("VERDT"),?58,"*"
 W !?18,"*",?58,"*",!?18 F ASD("I")=1:1:41 W "*"
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) D  G XQUIT
 .W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THE"
 .W " IHS SCHEDULING SYSTEM" S XQUIT=1
 S X=$P($G(^DIC(4,DUZ(2),0)),U) W !!?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=""
 ;
XQUIT W ! K ASD,X,Y
 Q
 ;
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 S ASD("TITLE")=$P($G(XQY0),U,2)
 I $L(ASD("TITLE"))>2 W @IOF,!!?80-$L(ASD("TITLE"))/2,ASD("TITLE")
 S X=$P($G(^DIC(4,DUZ(2),0)),U)
 W !!?80-$L(X)\2,"(",X,")"
 K ASD
 Q
 ;
SITECK ;EP; -- site check for facility
 I '$D(^DG(40.8,"C",DUZ(2))) D  G XQUIT
 . W !!,*7,"You are logged into a site that is NOT set up in the"
 . W !,"Scheduling package.  Please log into the correct site OR"
 . W !,"have this site - ",$$VAL^XBDIQ1(4,DUZ(2),.01)," - set up"
 . W !,"for Scheduling."
 . S XQUIT=1 D PRTOPT
 Q
PRTOPT ;ENTRY POINT  >>> exit action for print options
 NEW X,Y,Z
 Q:IOST'["C-"
 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR W @IOF
 K DIR Q
 ;
EXIT ;ENTRY POINT  >>> exit actions for ASDMENU
 ;kill of system-wide variables
 Q
