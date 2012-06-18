GMPLO013	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2577,15)
	;;=S ^GMPL(125,+GMPLSLST,0)=$P(GMPLSLST,U,2)_U_DT D HDR^GMPLBLD
	;;^UTILITY(U,$J,"PRO",2577,20)
	;;=D SAVE^GMPLBLD2
	;;^UTILITY(U,$J,"PRO",2577,99)
	;;=55908,59609
	;;^UTILITY(U,$J,"PRO",2578,0)
	;;=GMPL LIST SELECT ITEM^Select Item from Menu^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2578,1,0)
	;;=^^6^6^2931213^^
	;;^UTILITY(U,$J,"PRO",2578,1,1,0)
	;;=This action will allow selection of a problem listed in the displayed
	;;^UTILITY(U,$J,"PRO",2578,1,2,0)
	;;=menu, to be added to the current patient's problem list.  The same
	;;^UTILITY(U,$J,"PRO",2578,1,3,0)
	;;=prompts will be stepped through for each problem selected as if it had
	;;^UTILITY(U,$J,"PRO",2578,1,4,0)
	;;=been entered through the regular 'Add' action.  If the item selected
	;;^UTILITY(U,$J,"PRO",2578,1,5,0)
	;;=is a category heading, the list will be expanded to include all the
	;;^UTILITY(U,$J,"PRO",2578,1,6,0)
	;;=problems included in that category for selection.
	;;^UTILITY(U,$J,"PRO",2578,15)
	;;=D CK^GMPLMENU
	;;^UTILITY(U,$J,"PRO",2578,20)
	;;=D ITEM^GMPLMENU
	;;^UTILITY(U,$J,"PRO",2578,99)
	;;=55908,59548
	;;^UTILITY(U,$J,"PRO",2579,0)
	;;=GMPL LIST MENU^List Commonly Seen Problems^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2579,1,0)
	;;=^^3^3^2931213^^^
	;;^UTILITY(U,$J,"PRO",2579,1,1,0)
	;;=This protocol is for use with the List Manager utility, to display
	;;^UTILITY(U,$J,"PRO",2579,1,2,0)
	;;=the user's preferred list of commonly seen problems to facilitate
	;;^UTILITY(U,$J,"PRO",2579,1,3,0)
	;;=selection and addition to the patient's problem list.
	;;^UTILITY(U,$J,"PRO",2579,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",2579,10,0)
	;;=^101.01PA^2^3
	;;^UTILITY(U,$J,"PRO",2579,10,1,0)
	;;=2357^^3
	;;^UTILITY(U,$J,"PRO",2579,10,1,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2579,10,2,0)
	;;=2580^AD^1
	;;^UTILITY(U,$J,"PRO",2579,10,2,"^")
	;;=GMPL LIST CLU
	;;^UTILITY(U,$J,"PRO",2579,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2579,26)
	;;=W:$D(GMPLGRP) !!,"Rebuilding menu ..." D BUILD^GMPLMENU:$D(GMPLGRP),KEYS^GMPLMENU,SHOW^VALM S:XQORM("B")="Quit" XQORM("B")="Quit to Problem List" K GMPLGRP
	;;^UTILITY(U,$J,"PRO",2579,28)
	;;=Select Item(s): 
	;;^UTILITY(U,$J,"PRO",2579,99)
	;;=56005,23978
	;;^UTILITY(U,$J,"PRO",2580,0)
	;;=GMPL LIST CLU^Add a Problem not on the Menu^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2580,1,0)
	;;=^^4^4^2931213^^
	;;^UTILITY(U,$J,"PRO",2580,1,1,0)
	;;=This action will allow selection of a problem not listed in the displayed
	;;^UTILITY(U,$J,"PRO",2580,1,2,0)
	;;=menu, to be added to the current patient's problem list.  The code
	;;^UTILITY(U,$J,"PRO",2580,1,3,0)
	;;=invoked here is the same as for the regular 'Add' action, possibly
	;;^UTILITY(U,$J,"PRO",2580,1,4,0)
	;;=allowing a look-up into the Clinical Lexicon Utility.
	;;^UTILITY(U,$J,"PRO",2580,15)
	;;=D CK^GMPLMENU
	;;^UTILITY(U,$J,"PRO",2580,20)
	;;=D CLU^GMPLMENU
	;;^UTILITY(U,$J,"PRO",2580,99)
	;;=55908,59541
	;;^UTILITY(U,$J,"PRO",2630,0)
	;;=GMPL MENU DELETE GROUP^Delete Category^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2630,1,0)
	;;=^^3^3^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2630,1,1,0)
	;;=This action allows the user to delete a problem category; it will be
	;;^UTILITY(U,$J,"PRO",2630,1,2,0)
	;;=completely removed from the Problem Selection Category file, if no
	;;^UTILITY(U,$J,"PRO",2630,1,3,0)
	;;=list currently contains it.
	;;^UTILITY(U,$J,"PRO",2630,20)
	;;=D DELETE^GMPLBLD2
	;;^UTILITY(U,$J,"PRO",2630,99)
	;;=55908,59607
	;;^UTILITY(U,$J,"PRO",2631,0)
	;;=GMPL MENU CREATE GROUP^Enter/Edit Category^^A^^^^^^^^PROBLEM LIST
