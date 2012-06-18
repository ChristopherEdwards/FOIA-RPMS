GMPLO002	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2355,99)
	;;=55908,59625
	;;^UTILITY(U,$J,"PRO",2356,0)
	;;=GMPL INACTIVATE^Inactivate Problems^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2356,1,0)
	;;=^^1^1^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2356,1,1,0)
	;;=This action allows a problem to be inactivated.
	;;^UTILITY(U,$J,"PRO",2356,20)
	;;=D STATUS^GMPL
	;;^UTILITY(U,$J,"PRO",2356,24)
	;;=I +$G(GMPCOUNT)>0,$G(GMPLVIEW("ACT"))'="I"
	;;^UTILITY(U,$J,"PRO",2356,99)
	;;=55965,59688
	;;^UTILITY(U,$J,"PRO",2357,0)
	;;=GMPLX BLANK1^       ^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2357,1,0)
	;;=^^1^1^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2357,1,1,0)
	;;=Blank placeholder for menu actions.
	;;^UTILITY(U,$J,"PRO",2357,20)
	;;=Q
	;;^UTILITY(U,$J,"PRO",2357,99)
	;;=55908,59742
	;;^UTILITY(U,$J,"PRO",2358,0)
	;;=GMPLX BLANK2^       ^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2358,1,0)
	;;=^^1^1^2931001^^^^
	;;^UTILITY(U,$J,"PRO",2358,1,1,0)
	;;=Blank placeholder for menu actions.
	;;^UTILITY(U,$J,"PRO",2358,20)
	;;=Q
	;;^UTILITY(U,$J,"PRO",2358,99)
	;;=55908,59742
	;;^UTILITY(U,$J,"PRO",2362,0)
	;;=GMPL EDIT PROBLEM^Edit a Problem^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2362,1,0)
	;;=^^4^4^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2362,1,1,0)
	;;=This option allows editing of select fields of a problem entry;
	;;^UTILITY(U,$J,"PRO",2362,1,2,0)
	;;=all changes made to a patient's problem are recorded in the
	;;^UTILITY(U,$J,"PRO",2362,1,3,0)
	;;=Problem Audit file.  A problem is selected, and control is
	;;^UTILITY(U,$J,"PRO",2362,1,4,0)
	;;=transferred to the List Manager and GMPL EDIT MENU protocol.
	;;^UTILITY(U,$J,"PRO",2362,20)
	;;=D EDIT^GMPL
	;;^UTILITY(U,$J,"PRO",2362,24)
	;;=I +$G(GMPCOUNT)>0
	;;^UTILITY(U,$J,"PRO",2362,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2422,0)
	;;=GMPL DELETE^Remove Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2422,1,0)
	;;=^^3^3^2930811^^
	;;^UTILITY(U,$J,"PRO",2422,1,1,0)
	;;=This action will remove an entry from a patient's problem list;
	;;^UTILITY(U,$J,"PRO",2422,1,2,0)
	;;=the problem is not physically deleted from the file, but flagged
	;;^UTILITY(U,$J,"PRO",2422,1,3,0)
	;;=as "removed" and, except for historical purposes, generally ignored.
	;;^UTILITY(U,$J,"PRO",2422,20)
	;;=D DELETE^GMPL
	;;^UTILITY(U,$J,"PRO",2422,24)
	;;=I +$G(GMPCOUNT)>0
	;;^UTILITY(U,$J,"PRO",2422,99)
	;;=55965,59664
	;;^UTILITY(U,$J,"PRO",2423,0)
	;;=GMPL EDIT MENU^Edit Problem Values^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2423,1,0)
	;;=^^3^3^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2423,1,1,0)
	;;=This protocol is for use with the List Manager utility, to display
	;;^UTILITY(U,$J,"PRO",2423,1,2,0)
	;;=the current editable values of the selected problem entry in a list
	;;^UTILITY(U,$J,"PRO",2423,1,3,0)
	;;=format for editing.
	;;^UTILITY(U,$J,"PRO",2423,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",2423,10,0)
	;;=^101.01PA^4^5
	;;^UTILITY(U,$J,"PRO",2423,10,1,0)
	;;=2427^RM^11
	;;^UTILITY(U,$J,"PRO",2423,10,1,"^")
	;;=GMPL EDIT REMOVE
	;;^UTILITY(U,$J,"PRO",2423,10,2,0)
	;;=2425^SC^13
	;;^UTILITY(U,$J,"PRO",2423,10,2,"^")
	;;=GMPL EDIT SAVE
	;;^UTILITY(U,$J,"PRO",2423,10,3,0)
	;;=2441^CM^1^^^Additional Comments
	;;^UTILITY(U,$J,"PRO",2423,10,3,"^")
	;;=GMPL EDIT NEW NOTE
	;;^UTILITY(U,$J,"PRO",2423,10,4,0)
	;;=2358^^5
	;;^UTILITY(U,$J,"PRO",2423,10,4,"^")
	;;=GMPLX BLANK2
	;;^UTILITY(U,$J,"PRO",2423,20)
	;;=
	;;^UTILITY(U,$J,"PRO",2423,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2423,26)
	;;=D INIT^GMPLEDIT:$G(GMPREBLD),KEYS^GMPLEDT3,SHOW^VALM S:XQORM("B")="Quit"&$$EDITED^GMPLEDT2 XQORM("B")="Save Changes and Exit"
	;;^UTILITY(U,$J,"PRO",2423,27)
	;;=
	;;^UTILITY(U,$J,"PRO",2423,28)
	;;=Select Item(s): 
