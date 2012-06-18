BTIUVAR ; IHS/ITSC/LJF - MENU ENTRY & EXIT ACTIONS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ;This rtn contains the entry & exit actions for the IHS TIU Menus
 ;
 Q
ENTER(TIUZ) ;EP; entry actions for BTIU MAIN MENUs
 NEW TIU,Y,X,Z
 S Y=0,Y=$O(^DIC(9.4,"C","TIU",Y)),TIU("VERS")=^DIC(9.4,Y,"VERSION")
 S Z=$O(^DIC(9.4,Y,22,"B",+TIU("VERS"),0))
 I Z="" S Z=$O(^DIC(9.4,Y,22,"B",TIU("VERS"),0)) I Z="" S XQUIT=1 Q
 S Y=$P(^DIC(9.4,Y,22,Z,0),U,2) X ^DD("DD")
 S TIU("VERDT")=Y
 ;
 D ^XBCLS W !?18,$$REPEAT^XLFSTR("*",41)
 W !?18,"*        INDIAN HEALTH SERVICE          *"
 W !?18,"*",$$SP(9),$S(TIUZ=1:"TIU CLINICIAN'S MENU"_$$SP(10),1:"TIU MEDICAL RECORDS MENU"_$$SP(6)),"*"
 W !?18,"*       VERSION ",TIU("VERS"),", ",TIU("VERDT"),?58,"*"
 W !?18,$$REPEAT^XLFSTR("*",41)
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) D  G XQUIT
 .W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THE"
 .W " IHS TEXT-INTEGRATION UTILITY SYSTEM" S XQUIT=1
 S X=$P($G(^DIC(4,DUZ(2),0)),U) W !!?74-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=""
 ;
XQUIT Q
 ;
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 NEW TIU
 S TIU("TITLE")=$P($G(XQY0),U,2)
 I $L(TIU("TITLE"))>2 W @IOF,!!?80-$L(TIU("TITLE"))/2,TIU("TITLE")
 S X=$P($G(^DIC(4,DUZ(2),0)),U)
 W !!?80-$L(X)\2,"(",X,")"
 Q
 ;
EXIT ;ENTRY POINT  >>> exit actions for BTIU MENUs
 D EN^XBVK("TIU"),EN^XBVK("VALM"),EN^XBVK("USR") K IOSTBM
 Q
 ;
 ; -- archive copies of PAD and SP subrtns
PAD(DATA,LENGTH) ; pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; pad spaces
 Q $$PAD(" ",NUM)
