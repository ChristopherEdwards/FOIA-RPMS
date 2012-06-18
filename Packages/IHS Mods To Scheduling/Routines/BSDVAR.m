BSDVAR ; IHS/ANMC/LJF - MENU ENTRY AND EXIT ACTIONS ;  [ 01/02/2004  10:20 AM ]
 ;;5.3;PIMS;**1011,1012,1013**;APR 26, 2002
 ;
 ;This rtn contains the entry & exit actions for the main Scheduling
 ;menu as well as common subrtns for other menus and options.
 ;
 Q
ENTER ;ENTRY POINT entry actions for SDMENU
 D ^XBCLS W !?18 F BSD("I")=1:1:41 W "*"
 W !?18,"*        INDIAN HEALTH SERVICE          *"
 W !?18,"*       CLINIC SCHEDULING SYSTEM        *"
 W !?18,"*            VERSION ",$$VERSION^XPDUTL("SD"),?58,"*"
 W !?18 F BSD("I")=1:1:41 W "*"
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) D  G XQUIT
 .W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THE"
 .W " IHS SCHEDULING SYSTEM" S XQUIT=1
 ;7/18/02 WAR - omit one line feed
 ;S X=$P($G(^DIC(4,DUZ(2),0)),U) W !!?80-$L(X)\2,X  ;7/18/02 LJF19
 S X=$P($G(^DIC(4,DUZ(2),0)),U) W !?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=""
 ;
XQUIT K BSD,X,Y
 Q
 ;
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 S BSD("TITLE")=$P($G(XQY0),U,2)
 I $L(BSD("TITLE"))>2 W @IOF,!!?80-$L(BSD("TITLE"))/2,BSD("TITLE")
 S X=$P($G(^DIC(4,DUZ(2),0)),U)
 W !!?80-$L(X)\2,"(",X,")"
 K BSD
 Q
 ;
SITECK ;EP; -- site check for facility
 ;I '$D(^DG(40.8,"C",DUZ(2))) D  G XQUIT  ;cmi/maw 10/1/2009 patch 1011 orig
 I '$D(^DG(40.8,"AD",DUZ(2))) D  G XQUIT  ;cmi/maw 10/1/2009 patch 1011 for station number
 . W !!,*7,"You are logged into a site that is NOT set up in the"
 . W !,"Scheduling package.  Please log into the correct site OR"
 . W !,"have this site - ",$$GET1^DIQ(4,DUZ(2),.01)," - set up"
 . W !,"for Scheduling."
 . D PAUSE^BDGF
 . S XQUIT=1
 Q
 ;
EXIT ;ENTRY POINT  >>> exit actions for BSDMENU
 ;kill of system-wide variables
 Q
