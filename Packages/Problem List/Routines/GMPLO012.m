GMPLO012	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2570,1,0)
	;;=^^2^2^2931213^^^
	;;^UTILITY(U,$J,"PRO",2570,1,1,0)
	;;=This action allows adding one or more problem categories to a selection
	;;^UTILITY(U,$J,"PRO",2570,1,2,0)
	;;=list.
	;;^UTILITY(U,$J,"PRO",2570,20)
	;;=D ADD^GMPLBLD
	;;^UTILITY(U,$J,"PRO",2570,99)
	;;=55945,36852
	;;^UTILITY(U,$J,"PRO",2571,0)
	;;=GMPL MENU EDIT GROUP DISPLAY^Edit Category Display^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2571,1,0)
	;;=^^3^3^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2571,1,1,0)
	;;=This action allows the user to change the text that appears as the subheader
	;;^UTILITY(U,$J,"PRO",2571,1,2,0)
	;;=of a category of problems, and whether or not to display the problems in
	;;^UTILITY(U,$J,"PRO",2571,1,3,0)
	;;=the category automatically on entry to the list.
	;;^UTILITY(U,$J,"PRO",2571,20)
	;;=D EDIT^GMPLBLD1
	;;^UTILITY(U,$J,"PRO",2571,99)
	;;=55908,59607
	;;^UTILITY(U,$J,"PRO",2573,0)
	;;=GMPL MENU REMOVE GROUP^Remove Category from List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2573,1,0)
	;;=^^2^2^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2573,1,1,0)
	;;=This action allows the user to remove a problem category from the current
	;;^UTILITY(U,$J,"PRO",2573,1,2,0)
	;;=list; it remains in the Problem Selection Category file for future use.
	;;^UTILITY(U,$J,"PRO",2573,20)
	;;=D REMOVE^GMPLBLD
	;;^UTILITY(U,$J,"PRO",2573,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2574,0)
	;;=GMPL MENU NEW LIST^Change Selection Lists^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2574,1,0)
	;;=^^2^2^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2574,1,1,0)
	;;=This action allows the user to switch to editing a new problem selection
	;;^UTILITY(U,$J,"PRO",2574,1,2,0)
	;;=list.
	;;^UTILITY(U,$J,"PRO",2574,20)
	;;=D NEWLST^GMPLBLD2
	;;^UTILITY(U,$J,"PRO",2574,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2575,0)
	;;=GMPL MENU VIEW LIST^View w/wo Seq Numbers^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2575,1,0)
	;;=^^3^3^2940202^^^^
	;;^UTILITY(U,$J,"PRO",2575,1,1,0)
	;;=This action allows the user to toggle between displaying the sequence
	;;^UTILITY(U,$J,"PRO",2575,1,2,0)
	;;=numbers assigned to each category for ordering, or the display numbers
	;;^UTILITY(U,$J,"PRO",2575,1,3,0)
	;;=only.
	;;^UTILITY(U,$J,"PRO",2575,4)
	;;=^
	;;^UTILITY(U,$J,"PRO",2575,10,0)
	;;=^101.01PA^0^
	;;^UTILITY(U,$J,"PRO",2575,15)
	;;=W !,"Rebuilding selection list display to"_$S(GMPLMODE="E":" not",1:"")_" show sequence numbers ..." D BUILD^GMPLBLD(.GMPLIST,GMPLMODE)
	;;^UTILITY(U,$J,"PRO",2575,20)
	;;=S GMPLMODE=$S(GMPLMODE="E":"I",1:"E"),VALMBCK="R",VALMSG=$$MSG^GMPLX
	;;^UTILITY(U,$J,"PRO",2575,26)
	;;=
	;;^UTILITY(U,$J,"PRO",2575,28)
	;;=
	;;^UTILITY(U,$J,"PRO",2575,99)
	;;=55915,45086
	;;^UTILITY(U,$J,"PRO",2576,0)
	;;=GMPL MENU RESEQUENCE GROUPS^Resequence Categories^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2576,1,0)
	;;=^^2^2^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2576,1,1,0)
	;;=This action allows the user to place the problem caetgories on the current
	;;^UTILITY(U,$J,"PRO",2576,1,2,0)
	;;=list in a different order; problems will be automatically renumbered.
	;;^UTILITY(U,$J,"PRO",2576,15)
	;;=I $D(GMPREBLD) D BUILD^GMPLBLD(.GMPLIST,GMPLMODE) K GMPREBLD
	;;^UTILITY(U,$J,"PRO",2576,20)
	;;=D RESEQ^GMPLBLD1
	;;^UTILITY(U,$J,"PRO",2576,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2577,0)
	;;=GMPL MENU SAVE LIST^Save List and Quit^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2577,1,0)
	;;=^^2^2^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2577,1,1,0)
	;;=This action allows the user to save any changes that have been made to
	;;^UTILITY(U,$J,"PRO",2577,1,2,0)
	;;=the current list and exit the utility.
