GMPLI00Y	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",7785,0)
	;;=GMPL REPLACE PROBLEMS^Replace Removed Problem(s) on Patient's List^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7785,1,0)
	;;=^^3^3^2940203^
	;;^UTILITY(U,$J,"OPT",7785,1,1,0)
	;;=This option will allow the user to list all of the problems that have
	;;^UTILITY(U,$J,"OPT",7785,1,2,0)
	;;=been removed from a selected patient's problem list, and optionally
	;;^UTILITY(U,$J,"OPT",7785,1,3,0)
	;;=place any of them back on the problem list.
	;;^UTILITY(U,$J,"OPT",7785,25)
	;;=EN^GMPLRPTR
	;;^UTILITY(U,$J,"OPT",7785,"U")
	;;=REPLACE REMOVED PROBLEM(S) ON 
	;;^UTILITY(U,$J,"OPT",8021,0)
	;;=GMPL DE-ASSIGN LIST^Remove Selection List from User(s)^^R^^^^^^^^PROBLEM LIST^^1
	;;^UTILITY(U,$J,"OPT",8021,1,0)
	;;=^^4^4^2940314^^^^
	;;^UTILITY(U,$J,"OPT",8021,1,1,0)
	;;=This option allows a selection list to be removed from user(s) as
	;;^UTILITY(U,$J,"OPT",8021,1,2,0)
	;;=his/her preferred menu of problems to select from.  The Add New
	;;^UTILITY(U,$J,"OPT",8021,1,3,0)
	;;=Problem(s) option will no longer automatically present this menu
	;;^UTILITY(U,$J,"OPT",8021,1,4,0)
	;;=for the selected user(s) to choose from.
	;;^UTILITY(U,$J,"OPT",8021,20)
	;;=S GMPLSLST=$$LIST^GMPLBLD2("")
	;;^UTILITY(U,$J,"OPT",8021,25)
	;;=USERS^GMPLBLD3("")
	;;^UTILITY(U,$J,"OPT",8021,"U")
	;;=REMOVE SELECTION LIST FROM USE
	;;^UTILITY(U,$J,"OR",219,0)
	;;=219^GMPL^^ALL SERVICES
	;;^UTILITY(U,$J,"OR",219,1,0)
	;;=^100.9951PA^15^15
	;;^UTILITY(U,$J,"OR",219,1,1,0)
	;;=VALM NEXT SCREEN
	;;^UTILITY(U,$J,"OR",219,1,1,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,1,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,2,0)
	;;=VALM PREVIOUS SCREEN
	;;^UTILITY(U,$J,"OR",219,1,2,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,2,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,3,0)
	;;=VALM UP ONE LINE
	;;^UTILITY(U,$J,"OR",219,1,3,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,3,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,4,0)
	;;=VALM DOWN A LINE
	;;^UTILITY(U,$J,"OR",219,1,4,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,4,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,5,0)
	;;=VALM GOTO PAGE
	;;^UTILITY(U,$J,"OR",219,1,5,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,5,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,6,0)
	;;=VALM FIRST SCREEN
	;;^UTILITY(U,$J,"OR",219,1,6,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,6,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,7,0)
	;;=VALM LAST SCREEN
	;;^UTILITY(U,$J,"OR",219,1,7,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,7,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,8,0)
	;;=VALM REFRESH
	;;^UTILITY(U,$J,"OR",219,1,8,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,8,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,9,0)
	;;=VALM PRINT SCREEN
	;;^UTILITY(U,$J,"OR",219,1,9,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,9,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,10,0)
	;;=VALM PRINT LIST
	;;^UTILITY(U,$J,"OR",219,1,10,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,10,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,11,0)
	;;=VALM SEARCH LIST
	;;^UTILITY(U,$J,"OR",219,1,11,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,11,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,12,0)
	;;=VALM TURN ON/OFF MENUS
	;;^UTILITY(U,$J,"OR",219,1,12,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",219,1,12,1,1,0)
	;;=GMPL HIDDEN MENU
	;;^UTILITY(U,$J,"OR",219,1,13,0)
	;;=VALM QUIT
	;;^UTILITY(U,$J,"OR",219,1,13,1,0)
	;;=^100.99511PA^10^10
