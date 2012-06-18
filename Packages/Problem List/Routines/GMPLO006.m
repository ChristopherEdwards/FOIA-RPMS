GMPLO006	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2452,0)
	;;=VALM REFRESH^Re-Display Screen^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2452,1,0)
	;;=^^1^1^2911024^
	;;^UTILITY(U,$J,"PRO",2452,1,1,0)
	;;=This actions allows the user to re-display the current screen.
	;;^UTILITY(U,$J,"PRO",2452,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",2452,2,1,0)
	;;=RE
	;;^UTILITY(U,$J,"PRO",2452,2,"B","RE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",2452,10,0)
	;;=^101.01PA^0^0
	;;^UTILITY(U,$J,"PRO",2452,20)
	;;=D RE^VALM4
	;;^UTILITY(U,$J,"PRO",2452,99)
	;;=55983,43977
	;;^UTILITY(U,$J,"PRO",2452,"MEN","GMPL HIDDEN MENU")
	;;=2452^RD^23
	;;^UTILITY(U,$J,"PRO",2453,0)
	;;=VALM LAST SCREEN^Last Screen^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2453,1,0)
	;;=^^1^1^2911026^
	;;^UTILITY(U,$J,"PRO",2453,1,1,0)
	;;=The action will display the last items.
	;;^UTILITY(U,$J,"PRO",2453,20)
	;;=D LAST^VALM4
	;;^UTILITY(U,$J,"PRO",2453,99)
	;;=55983,43967
	;;^UTILITY(U,$J,"PRO",2453,"MEN","GMPL HIDDEN MENU")
	;;=2453^LS^22
	;;^UTILITY(U,$J,"PRO",2454,0)
	;;=VALM FIRST SCREEN^First Screen^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2454,1,0)
	;;=^^1^1^2911026^
	;;^UTILITY(U,$J,"PRO",2454,1,1,0)
	;;=This action will display the first screen.
	;;^UTILITY(U,$J,"PRO",2454,15)
	;;=
	;;^UTILITY(U,$J,"PRO",2454,20)
	;;=D FIRST^VALM4
	;;^UTILITY(U,$J,"PRO",2454,99)
	;;=55983,43957
	;;^UTILITY(U,$J,"PRO",2454,"MEN","GMPL HIDDEN MENU")
	;;=2454^FS^21
	;;^UTILITY(U,$J,"PRO",2455,0)
	;;=VALM UP ONE LINE^Up a Line^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2455,1,0)
	;;=^^1^1^2911027^
	;;^UTILITY(U,$J,"PRO",2455,1,1,0)
	;;=Move up a line
	;;^UTILITY(U,$J,"PRO",2455,20)
	;;=D UP^VALM40
	;;^UTILITY(U,$J,"PRO",2455,99)
	;;=55983,43978
	;;^UTILITY(U,$J,"PRO",2455,"MEN","GMPL HIDDEN MENU")
	;;=2455^UP^13
	;;^UTILITY(U,$J,"PRO",2456,0)
	;;=VALM DOWN A LINE^Down a Line^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2456,1,0)
	;;=^^2^2^2911027^
	;;^UTILITY(U,$J,"PRO",2456,1,1,0)
	;;=Move down a line.
	;;^UTILITY(U,$J,"PRO",2456,1,2,0)
	;;=
	;;^UTILITY(U,$J,"PRO",2456,20)
	;;=D DOWN^VALM40
	;;^UTILITY(U,$J,"PRO",2456,99)
	;;=55983,43953
	;;^UTILITY(U,$J,"PRO",2456,"MEN","GMPL HIDDEN MENU")
	;;=2456^DN^14
	;;^UTILITY(U,$J,"PRO",2458,0)
	;;=VALM QUIT^Quit^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2458,1,0)
	;;=^^1^1^2911105^
	;;^UTILITY(U,$J,"PRO",2458,1,1,0)
	;;=This protocol can be used as a generic 'quit' action.
	;;^UTILITY(U,$J,"PRO",2458,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",2458,2,1,0)
	;;=EXIT
	;;^UTILITY(U,$J,"PRO",2458,2,2,0)
	;;=QUIT
	;;^UTILITY(U,$J,"PRO",2458,2,"B","EXIT",1)
	;;=
	;;^UTILITY(U,$J,"PRO",2458,2,"B","QUIT",2)
	;;=
	;;^UTILITY(U,$J,"PRO",2458,20)
	;;=Q
	;;^UTILITY(U,$J,"PRO",2458,99)
	;;=55983,43976
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL CODE LIST")
	;;=2458^Q^13
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL DATA ENTRY")
	;;=2458^Q^25
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL DT MENU")
	;;=2458^Q^3^^^Quit to Problem List
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL EDIT MENU")
	;;=2458^Q^3^^^Quit w/o Saving Changes
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL HIDDEN MENU")
	;;=2458^Q^33
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL LIST MENU")
	;;=2458^Q^11^^^Quit to Problem List
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL MENU BUILD GROUP")
	;;=2458^Q^25
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL MENU BUILD LIST")
	;;=2458^Q^27
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL PROBLEM LIST")
	;;=2458^Q^27
	;;^UTILITY(U,$J,"PRO",2458,"MEN","GMPL USER PREFS")
	;;=2458^Q^15^^^Quit w/o Saving Changes
	;;^UTILITY(U,$J,"PRO",2459,0)
	;;=VALM PRINT SCREEN^Print Screen^^A^^^^^^^^LIST MANAGER
