GMPLO015	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2637,1,2,0)
	;;=if no code is currently assigned to the problem, one may be entered.
	;;^UTILITY(U,$J,"PRO",2637,20)
	;;=D EDIT^GMPLBLDC
	;;^UTILITY(U,$J,"PRO",2637,99)
	;;=55984,51170
	;;^UTILITY(U,$J,"PRO",2638,0)
	;;=GMPL MENU BUILD GROUP^Build Problem Categories^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2638,1,0)
	;;=^^4^4^2931213^^
	;;^UTILITY(U,$J,"PRO",2638,1,1,0)
	;;=This menu allows the creation of categories of problems, to facilitate
	;;^UTILITY(U,$J,"PRO",2638,1,2,0)
	;;=selecting a new problem to add to a patient's problem list.  Categories
	;;^UTILITY(U,$J,"PRO",2638,1,3,0)
	;;=may then be linked together to form lists, in which they may be ordered
	;;^UTILITY(U,$J,"PRO",2638,1,4,0)
	;;=and titled.  Categories may be reused in multiple lists, as well.
	;;^UTILITY(U,$J,"PRO",2638,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2638,10,0)
	;;=^101.01PA^10^11
	;;^UTILITY(U,$J,"PRO",2638,10,1,0)
	;;=2634^AD^1^^^Add Problems
	;;^UTILITY(U,$J,"PRO",2638,10,1,"^")
	;;=GMPL MENU ADD PROBLEM
	;;^UTILITY(U,$J,"PRO",2638,10,2,0)
	;;=2635^RM^3^^^Remove a Problem
	;;^UTILITY(U,$J,"PRO",2638,10,2,"^")
	;;=GMPL MENU REMOVE PROBLEM
	;;^UTILITY(U,$J,"PRO",2638,10,3,0)
	;;=2636^SQ^11
	;;^UTILITY(U,$J,"PRO",2638,10,3,"^")
	;;=GMPL MENU RESEQUENCE PROBLEMS
	;;^UTILITY(U,$J,"PRO",2638,10,4,0)
	;;=2637^ED^5
	;;^UTILITY(U,$J,"PRO",2638,10,4,"^")
	;;=GMPL MENU EDIT PROBLEM
	;;^UTILITY(U,$J,"PRO",2638,10,5,0)
	;;=2357^^7
	;;^UTILITY(U,$J,"PRO",2638,10,5,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2638,10,6,0)
	;;=2632^SV^21
	;;^UTILITY(U,$J,"PRO",2638,10,6,"^")
	;;=GMPL MENU SAVE GROUP
	;;^UTILITY(U,$J,"PRO",2638,10,7,0)
	;;=2630^DL^13
	;;^UTILITY(U,$J,"PRO",2638,10,7,"^")
	;;=GMPL MENU DELETE GROUP
	;;^UTILITY(U,$J,"PRO",2638,10,8,0)
	;;=2633^CC^23
	;;^UTILITY(U,$J,"PRO",2638,10,8,"^")
	;;=GMPL MENU NEW GROUP
	;;^UTILITY(U,$J,"PRO",2638,10,9,0)
	;;=2645^VW^15
	;;^UTILITY(U,$J,"PRO",2638,10,9,"^")
	;;=GMPL MENU VIEW GROUP
	;;^UTILITY(U,$J,"PRO",2638,10,10,0)
	;;=2358^^17
	;;^UTILITY(U,$J,"PRO",2638,10,10,"^")
	;;=GMPLX BLANK2
	;;^UTILITY(U,$J,"PRO",2638,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM
	;;^UTILITY(U,$J,"PRO",2638,99)
	;;=55984,61082
	;;^UTILITY(U,$J,"PRO",2645,0)
	;;=GMPL MENU VIEW GROUP^View w/wo Seq Numbers^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2645,1,0)
	;;=^^3^3^2940202^^^
	;;^UTILITY(U,$J,"PRO",2645,1,1,0)
	;;=This action allows the user to toggle between displaying the sequence
	;;^UTILITY(U,$J,"PRO",2645,1,2,0)
	;;=numbers assigned to each problem for ordering, or the display numbers
	;;^UTILITY(U,$J,"PRO",2645,1,3,0)
	;;=only.
	;;^UTILITY(U,$J,"PRO",2645,4)
	;;=^
	;;^UTILITY(U,$J,"PRO",2645,10,0)
	;;=^101.01PA^0^
	;;^UTILITY(U,$J,"PRO",2645,15)
	;;=W !,"Rebuilding problem category display to"_$S(GMPLMODE="E":" not",1:"")_" show sequence numbers ..." D BUILD^GMPLBLDC(.GMPLIST,GMPLMODE)
	;;^UTILITY(U,$J,"PRO",2645,20)
	;;=S GMPLMODE=$S(GMPLMODE="E":"I",1:"E"),VALMBCK="R",VALMSG=$$MSG^GMPLX
	;;^UTILITY(U,$J,"PRO",2645,26)
	;;=
	;;^UTILITY(U,$J,"PRO",2645,28)
	;;=
	;;^UTILITY(U,$J,"PRO",2645,99)
	;;=55915,44904
	;;^UTILITY(U,$J,"PRO",2771,0)
	;;=GMPL CODE LIST^Problem List ICD Codes^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2771,1,0)
	;;=^^4^4^2931105^
	;;^UTILITY(U,$J,"PRO",2771,1,1,0)
	;;=This menu uses the List Manager utility to display all of a patient's
	;;^UTILITY(U,$J,"PRO",2771,1,2,0)
	;;=problems with data relevant to a billing clerk/coder.  Only the ICD code
	;;^UTILITY(U,$J,"PRO",2771,1,3,0)
	;;=may be edited, but a detailed display of all information stored about
