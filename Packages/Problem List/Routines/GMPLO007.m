GMPLO007	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2459,1,0)
	;;=^^3^3^2920113^^
	;;^UTILITY(U,$J,"PRO",2459,1,1,0)
	;;=This action allows the user to print the current List Manager
	;;^UTILITY(U,$J,"PRO",2459,1,2,0)
	;;=display screen.  The header and the current portion of the
	;;^UTILITY(U,$J,"PRO",2459,1,3,0)
	;;=list are printed.
	;;^UTILITY(U,$J,"PRO",2459,20)
	;;=D PRT^VALM1
	;;^UTILITY(U,$J,"PRO",2459,99)
	;;=55983,43974
	;;^UTILITY(U,$J,"PRO",2459,"MEN","GMPL HIDDEN MENU")
	;;=2459^PS^24
	;;^UTILITY(U,$J,"PRO",2460,0)
	;;=VALM PRINT LIST^Print List^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2460,1,0)
	;;=^^2^2^2920113^
	;;^UTILITY(U,$J,"PRO",2460,1,1,0)
	;;=This action allws the user to print the entire list of
	;;^UTILITY(U,$J,"PRO",2460,1,2,0)
	;;=entries currently being displayed.
	;;^UTILITY(U,$J,"PRO",2460,20)
	;;=D PRTL^VALM1
	;;^UTILITY(U,$J,"PRO",2460,99)
	;;=56097,32061
	;;^UTILITY(U,$J,"PRO",2460,"MEN","GMPL HIDDEN MENU")
	;;=2460^PL^25
	;;^UTILITY(U,$J,"PRO",2462,0)
	;;=VALM TURN ON/OFF MENUS^Auto-Display(On/Off)^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2462,20)
	;;=D MENU^VALM2
	;;^UTILITY(U,$J,"PRO",2462,99)
	;;=55983,43978
	;;^UTILITY(U,$J,"PRO",2462,"MEN","GMPL HIDDEN MENU")
	;;=2462^ADPL^32
	;;^UTILITY(U,$J,"PRO",2464,0)
	;;=VALM SEARCH LIST^Search List^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2464,1,0)
	;;=^^1^1^2920303^^
	;;^UTILITY(U,$J,"PRO",2464,1,1,0)
	;;=Finds text in list of entries.
	;;^UTILITY(U,$J,"PRO",2464,20)
	;;=D FIND^VALM40
	;;^UTILITY(U,$J,"PRO",2464,99)
	;;=55983,43977
	;;^UTILITY(U,$J,"PRO",2464,"MEN","GMPL HIDDEN MENU")
	;;=2464^SL^31
	;;^UTILITY(U,$J,"PRO",2465,0)
	;;=VALM BLANK 2^^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2465,1,0)
	;;=^^1^1^2920203^
	;;^UTILITY(U,$J,"PRO",2465,1,1,0)
	;;=This protocol is used to format spaces in menu lists.
	;;^UTILITY(U,$J,"PRO",2465,"MEN","GMPL HIDDEN MENU")
	;;=2465^^34
	;;^UTILITY(U,$J,"PRO",2466,0)
	;;=VALM BLANK 3^^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2466,1,0)
	;;=^^1^1^2920203^
	;;^UTILITY(U,$J,"PRO",2466,1,1,0)
	;;=This protocol is used to format spaces in menu lists.
	;;^UTILITY(U,$J,"PRO",2466,"MEN","GMPL HIDDEN MENU")
	;;=2466^^35
	;;^UTILITY(U,$J,"PRO",2479,0)
	;;=VALM GOTO PAGE^Go to Page^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2479,1,0)
	;;=^^1^1^2930113^
	;;^UTILITY(U,$J,"PRO",2479,1,1,0)
	;;=
	;;^UTILITY(U,$J,"PRO",2479,20)
	;;=D GOTO^VALM40
	;;^UTILITY(U,$J,"PRO",2479,99)
	;;=55983,43958
	;;^UTILITY(U,$J,"PRO",2479,"MEN","GMPL HIDDEN MENU")
	;;=2479^GO^15
	;;^UTILITY(U,$J,"PRO",2494,0)
	;;=GMPL VERIFY^Verify Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2494,1,0)
	;;=^^6^6^2930811^
	;;^UTILITY(U,$J,"PRO",2494,1,1,0)
	;;=If the parameter "Verify Transcribed Problems" is turned on in the
	;;^UTILITY(U,$J,"PRO",2494,1,2,0)
	;;=Problem List Site Parameters file (#125.99), this action will allow
	;;^UTILITY(U,$J,"PRO",2494,1,3,0)
	;;=a clinician to mark the selected problem(s) as verified.  A "$" will
	;;^UTILITY(U,$J,"PRO",2494,1,4,0)
	;;=appear immediately in front of the problem text for problems that were
	;;^UTILITY(U,$J,"PRO",2494,1,5,0)
	;;=transcribed in by a clerk and the above described parameter is on;
	;;^UTILITY(U,$J,"PRO",2494,1,6,0)
	;;=entering a "$" at the "Select Action" prompt will invoke this action.
	;;^UTILITY(U,$J,"PRO",2494,20)
	;;=D VERIFY^GMPL
	;;^UTILITY(U,$J,"PRO",2494,24)
	;;=I ('$P($G(^GMPL(125.99,1,0)),U,2))!(+$G(GMPCOUNT)>0)
	;;^UTILITY(U,$J,"PRO",2494,99)
	;;=55965,59778
	;;^UTILITY(U,$J,"PRO",2495,0)
	;;=GMPL DT CONTINUE^Continue to Next Selected Problem^^A^^^^^^^^PROBLEM LIST
