VALMO002 ; ; 13-AUG-1993
 ;;1;List Manager;;Aug 13, 1993
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",643,1,3,0)
 ;;=list are printed.
 ;;^UTILITY(U,$J,"PRO",643,20)
 ;;=D PRT^VALM1
 ;;^UTILITY(U,$J,"PRO",643,99)
 ;;=55598,37538
 ;;^UTILITY(U,$J,"PRO",644,0)
 ;;=VALM PRINT LIST^Print List^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",644,1,0)
 ;;=^^2^2^2920113^
 ;;^UTILITY(U,$J,"PRO",644,1,1,0)
 ;;=This action allws the user to print the entire list of
 ;;^UTILITY(U,$J,"PRO",644,1,2,0)
 ;;=entries currently being displayed.
 ;;^UTILITY(U,$J,"PRO",644,20)
 ;;=D PRTL^VALM1
 ;;^UTILITY(U,$J,"PRO",644,99)
 ;;=55598,37537
 ;;^UTILITY(U,$J,"PRO",645,0)
 ;;=VALM EXPAND^Expand Entry^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",645,15)
 ;;=S:'VALMCC VALMBCK="R"
 ;;^UTILITY(U,$J,"PRO",645,20)
 ;;=I $D(^TMP("VALM DATA",$J,VALMEVL,"EXP")),^("EXP")]"" X ^("EXP")
 ;;^UTILITY(U,$J,"PRO",645,99)
 ;;=55598,37466
 ;;^UTILITY(U,$J,"PRO",646,0)
 ;;=VALM TURN ON/OFF MENUS^Auto-Display(On/Off)^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",646,20)
 ;;=D MENU^VALM2
 ;;^UTILITY(U,$J,"PRO",646,99)
 ;;=55598,37546
 ;;^UTILITY(U,$J,"PRO",647,0)
 ;;=VALM BLANK 1^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",647,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",647,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",648,0)
 ;;=VALM SEARCH LIST^Search List^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",648,1,0)
 ;;=^^1^1^2920303^^
 ;;^UTILITY(U,$J,"PRO",648,1,1,0)
 ;;=Finds text in list of entries.
 ;;^UTILITY(U,$J,"PRO",648,20)
 ;;=D FIND^VALM40
 ;;^UTILITY(U,$J,"PRO",648,99)
 ;;=55598,37545
 ;;^UTILITY(U,$J,"PRO",649,0)
 ;;=VALM BLANK 2^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",649,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",649,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",650,0)
 ;;=VALM BLANK 3^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",650,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",650,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",651,0)
 ;;=VALM BLANK 4^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",651,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",651,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",652,0)
 ;;=VALM BLANK 5^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",652,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",652,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",653,0)
 ;;=VALM BLANK 6^^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",653,1,0)
 ;;=^^1^1^2920203^
 ;;^UTILITY(U,$J,"PRO",653,1,1,0)
 ;;=This protocol is used to format spaces in menu lists.
 ;;^UTILITY(U,$J,"PRO",654,0)
 ;;=VALM DISPLAY W/EXPAND^Display List^^M^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",654,1,0)
 ;;=^^2^2^2920303^^^^
 ;;^UTILITY(U,$J,"PRO",654,1,1,0)
 ;;=This protocaol is the default protocol for the List Manager
 ;;^UTILITY(U,$J,"PRO",654,1,2,0)
 ;;=utility.
 ;;^UTILITY(U,$J,"PRO",654,4)
 ;;=26^4
 ;;^UTILITY(U,$J,"PRO",654,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",654,10,1,0)
 ;;=645^EP
 ;;^UTILITY(U,$J,"PRO",654,10,1,"^")
 ;;=VALM EXPAND
 ;;^UTILITY(U,$J,"PRO",654,26)
 ;;=D SHOW^VALM
 ;;^UTILITY(U,$J,"PRO",654,28)
 ;;=Select Action:
 ;;^UTILITY(U,$J,"PRO",654,99)
 ;;=55598,37465
 ;;^UTILITY(U,$J,"PRO",659,0)
 ;;=VALM RIGHT^Shift View to Right^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",659,20)
 ;;=D RIGHT^VALM40(XQORNOD(0))
 ;;^UTILITY(U,$J,"PRO",659,99)
 ;;=55598,37543
 ;;^UTILITY(U,$J,"PRO",660,0)
 ;;=VALM LEFT^Shift View to Left^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",660,20)
 ;;=D LEFT^VALM40(XQORNOD(0))
 ;;^UTILITY(U,$J,"PRO",660,99)
 ;;=55598,37505
 ;;^UTILITY(U,$J,"PRO",662,0)
 ;;=VALM HIDDEN ACTIONS^Standard Hidden Actions^^M^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",662,4)
 ;;=26
 ;;^UTILITY(U,$J,"PRO",662,10,0)
 ;;=^101.01PA^18^19
 ;;^UTILITY(U,$J,"PRO",662,10,1,0)
 ;;=634^+^11
 ;;^UTILITY(U,$J,"PRO",662,10,1,"^")
 ;;=VALM NEXT SCREEN
 ;;^UTILITY(U,$J,"PRO",662,10,2,0)
 ;;=635^-^12
 ;;^UTILITY(U,$J,"PRO",662,10,2,"^")
 ;;=VALM PREVIOUS SCREEN
 ;;^UTILITY(U,$J,"PRO",662,10,3,0)
 ;;=639^UP^13
 ;;^UTILITY(U,$J,"PRO",662,10,3,"^")
 ;;=VALM UP ONE LINE
 ;;^UTILITY(U,$J,"PRO",662,10,4,0)
 ;;=640^DN^14
 ;;^UTILITY(U,$J,"PRO",662,10,4,"^")
 ;;=VALM DOWN A LINE
 ;;^UTILITY(U,$J,"PRO",662,10,5,0)
 ;;=636^RD^24
 ;;^UTILITY(U,$J,"PRO",662,10,5,"^")
 ;;=VALM REFRESH
 ;;^UTILITY(U,$J,"PRO",662,10,6,0)
 ;;=643^PS^25
 ;;^UTILITY(U,$J,"PRO",662,10,6,"^")
 ;;=VALM PRINT SCREEN
 ;;^UTILITY(U,$J,"PRO",662,10,7,0)
 ;;=644^PL^26^
 ;;^UTILITY(U,$J,"PRO",662,10,7,"^")
 ;;=VALM PRINT LIST
 ;;^UTILITY(U,$J,"PRO",662,10,8,0)
 ;;=659^>^15
