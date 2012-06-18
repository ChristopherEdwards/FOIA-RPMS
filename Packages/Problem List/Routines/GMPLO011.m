GMPLO011	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2554,1,0)
	;;=^^3^3^2930811^
	;;^UTILITY(U,$J,"PRO",2554,1,1,0)
	;;=This menu contains the List Manager functions relevant to the operation
	;;^UTILITY(U,$J,"PRO",2554,1,2,0)
	;;=of the Problem List application; it is accessible from any "Select Action"
	;;^UTILITY(U,$J,"PRO",2554,1,3,0)
	;;=prompt by entering "??".
	;;^UTILITY(U,$J,"PRO",2554,4)
	;;=26
	;;^UTILITY(U,$J,"PRO",2554,10,0)
	;;=^101.01PA^0^15
	;;^UTILITY(U,$J,"PRO",2554,99)
	;;=56097,32061
	;;^UTILITY(U,$J,"PRO",2555,0)
	;;=GMPL EDIT VERIFY^Verify^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2555,1,0)
	;;=^^6^6^2930811^^
	;;^UTILITY(U,$J,"PRO",2555,1,1,0)
	;;=If the parameter "Verify Transcribed Problems" is turned on in the
	;;^UTILITY(U,$J,"PRO",2555,1,2,0)
	;;=Problem List Site Parameters file (#125.99), this action will allow
	;;^UTILITY(U,$J,"PRO",2555,1,3,0)
	;;=a clinician to mark the current problem as verified.  A "$" will
	;;^UTILITY(U,$J,"PRO",2555,1,4,0)
	;;=appear immediately in front of the problem text if the current problem
	;;^UTILITY(U,$J,"PRO",2555,1,5,0)
	;;=was transcribed in by a clerk and the above described parameter is on;
	;;^UTILITY(U,$J,"PRO",2555,1,6,0)
	;;=entering a "$" at the "Select Item" prompt will invoke this action.
	;;^UTILITY(U,$J,"PRO",2555,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2555,20)
	;;=D VERIFY^GMPLEDT2
	;;^UTILITY(U,$J,"PRO",2555,99)
	;;=55908,59538
	;;^UTILITY(U,$J,"PRO",2569,0)
	;;=GMPL MENU BUILD LIST^Build Problem Selection List^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2569,1,0)
	;;=^^4^4^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2569,1,1,0)
	;;=This menu allows the creation of lists of problems, to facilitate
	;;^UTILITY(U,$J,"PRO",2569,1,2,0)
	;;=selecting a new problem to add to a patient's problem list.
	;;^UTILITY(U,$J,"PRO",2569,1,3,0)
	;;=Problems are added or removed in categories, which may also be ordered
	;;^UTILITY(U,$J,"PRO",2569,1,4,0)
	;;=or titled for clarity.
	;;^UTILITY(U,$J,"PRO",2569,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2569,10,0)
	;;=^101.01PA^11^12
	;;^UTILITY(U,$J,"PRO",2569,10,1,0)
	;;=2570^AD^1^^^
	;;^UTILITY(U,$J,"PRO",2569,10,1,"^")
	;;=GMPL MENU ADD GROUP
	;;^UTILITY(U,$J,"PRO",2569,10,2,0)
	;;=2571^CD^13
	;;^UTILITY(U,$J,"PRO",2569,10,2,"^")
	;;=GMPL MENU EDIT GROUP DISPLAY
	;;^UTILITY(U,$J,"PRO",2569,10,3,0)
	;;=2573^RM^3^^^Remove Category
	;;^UTILITY(U,$J,"PRO",2569,10,3,"^")
	;;=GMPL MENU REMOVE GROUP
	;;^UTILITY(U,$J,"PRO",2569,10,4,0)
	;;=2576^SQ^11
	;;^UTILITY(U,$J,"PRO",2569,10,4,"^")
	;;=GMPL MENU RESEQUENCE GROUPS
	;;^UTILITY(U,$J,"PRO",2569,10,5,0)
	;;=2575^VW^21^^^
	;;^UTILITY(U,$J,"PRO",2569,10,5,"^")
	;;=GMPL MENU VIEW LIST
	;;^UTILITY(U,$J,"PRO",2569,10,6,0)
	;;=2577^SV^25
	;;^UTILITY(U,$J,"PRO",2569,10,6,"^")
	;;=GMPL MENU SAVE LIST
	;;^UTILITY(U,$J,"PRO",2569,10,7,0)
	;;=2574^CL^23
	;;^UTILITY(U,$J,"PRO",2569,10,7,"^")
	;;=GMPL MENU NEW LIST
	;;^UTILITY(U,$J,"PRO",2569,10,8,0)
	;;=2357^^7
	;;^UTILITY(U,$J,"PRO",2569,10,8,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2569,10,9,0)
	;;=2358^^17
	;;^UTILITY(U,$J,"PRO",2569,10,9,"^")
	;;=GMPLX BLANK2
	;;^UTILITY(U,$J,"PRO",2569,10,10,0)
	;;=2631^EC^5^^^
	;;^UTILITY(U,$J,"PRO",2569,10,10,"^")
	;;=GMPL MENU CREATE GROUP
	;;^UTILITY(U,$J,"PRO",2569,10,11,0)
	;;=2796^SS^15
	;;^UTILITY(U,$J,"PRO",2569,10,11,"^")
	;;=GMPL MENU ASSIGN LIST
	;;^UTILITY(U,$J,"PRO",2569,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM
	;;^UTILITY(U,$J,"PRO",2569,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2569,99)
	;;=55984,50697
	;;^UTILITY(U,$J,"PRO",2570,0)
	;;=GMPL MENU ADD GROUP^Add Category to List^^A^^^^^^^^PROBLEM LIST
