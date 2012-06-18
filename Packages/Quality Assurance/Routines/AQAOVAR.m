AQAOVAR ; IHS/ORDC/LJF - MENU ENTRY AND EXIT ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the entry and exit actions for the main QAI menu
 ;as well as common subrtns for other menus and options.
 ;
 Q
ENTER ;ENTRY POINT entry actions for AQAOMENU
 S Y=0,Y=$O(^DIC(9.4,"C","AQAO",Y)),AQAO("VERS")=^DIC(9.4,Y,"VERSION")
 S Z=$O(^DIC(9.4,Y,22,"B",+AQAO("VERS"),0)) I Z="" S XQUIT=1 D XQUIT Q
 S Y=$P(^DIC(9.4,Y,22,Z,0),U,2) X ^DD("DD")
 S AQAO("VERDT")=Y
 ;
 D ^XBCLS W !?18 F AQAO("I")=1:1:41 W "*"
 W !?18,"*",?58,"*",!?18,"*        INDIAN HEALTH SERVICE          *"
 W !?18,"*   QUALITY ASSESSMENT & IMPROVEMENT    *"
 W !?18,"*          MANAGEMENT SYSTEM            *"
 W !?18,"*       VERSION ",AQAO("VERS"),", ",AQAO("VERDT"),?58,"*"
 W !?18,"*",?58,"*",!?18 F AQAO("I")=1:1:41 W "*"
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) D  G XQUIT
 .W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THE QAI"
 .W " MANAGEMENT SYSTEM!" S XQUIT=1
 S X=$P($G(^DIC(4,DUZ(2),0)),U) W !!?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=""
 ;
 ; >>> check user's access to package
 K AQAOPT I '$D(^AQAO(9,DUZ,0)) G NOTUSER ;not in qi user file
 S AQAOUA("USER")=^AQAO(9,DUZ,0)
 I $P(AQAOUA("USER"),U,2)="" K AQAOPT G NOTUSER ;not activated
 I $P(AQAOUA("USER"),U,4)'="" K AQAOPT G NOTUSER ;inactivated
 G XQUIT:($P(AQAOUA("USER"),U,6)["Q") ;qi staff
 ;
 ; >>> set user's access by qi team
 S X=0 F  S X=$O(^AQAO(9,DUZ,"TM",X)) Q:X'=+X  D
 .Q:'$D(^AQAO(9,DUZ,"TM",X,0))  S Y=^(0) Q:Y=""
 .I $P(Y,U,2)="" K AQAOPT Q
 .S AQAOUA("USER",$P(Y,U))=$P(Y,U,2)
 .I $P(Y,U,2)>$G(AQAOUA("USER","ACCESS")) S AQAOUA("USER","ACCESS")=$P(Y,U,2) ;set highest access level
 ;
NOTUSER I '$D(AQAOUA("USER")) D
 .S XQUIT=""
 .W *7,!!?10,"**** YOU ARE NOT LISTED AS AN AUTHORIZED QI USER! ****"
 .W !?15,"**** PLEASE SEE YOUR QI STAFF FOR ACCESS ****",!! H 5
 ;
XQUIT W ! K X,Y
 Q
 ;
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 S AQAO("TITLE")=$P($G(XQY0),U,2)
 I $L(AQAO("TITLE"))>2 W @IOF,!!?80-$L(AQAO("TITLE"))/2,AQAO("TITLE")
 S X=$P($G(^DIC(4,DUZ(2),0)),U)
 W !!?80-$L(X)\2,"(",X,")"
 K AQAO
 Q
 ;
PRTOPT ;ENTRY POINT  >>> exit action for print options
 Q:IOST'["C-"  ;PATCH 2
 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR W @IOF
 K DIR Q
 ;
EXIT ;ENTRY POINT  >>> exit actions for AQAOMENU
 K AQAOCHK,AQAOUA,AQAOXYZ,AQAOINAC,AQAOENTR K ^TMP("AQAOCHK",$J)
 Q
