GMPLO014	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2631,1,0)
	;;=^^7^7^2940304^^^^
	;;^UTILITY(U,$J,"PRO",2631,1,1,0)
	;;=This action transfers control to the List Manager utility, to bring up
	;;^UTILITY(U,$J,"PRO",2631,1,2,0)
	;;=a new screen allowing the entry/editing of any problem category.
	;;^UTILITY(U,$J,"PRO",2631,1,3,0)
	;;=The user will be asked for the category s/he wishes to review and edit,
	;;^UTILITY(U,$J,"PRO",2631,1,4,0)
	;;=and a screen similar to the 'Build List' menu will be shown allowing
	;;^UTILITY(U,$J,"PRO",2631,1,5,0)
	;;=similar actions to edit the contents of the selected category.  A new
	;;^UTILITY(U,$J,"PRO",2631,1,6,0)
	;;=category may be entered here, which will be available to add to the
	;;^UTILITY(U,$J,"PRO",2631,1,7,0)
	;;=current list upon return to the 'Build List' screen when finished.
	;;^UTILITY(U,$J,"PRO",2631,15)
	;;=I $D(GMPSAVED) D BUILD^GMPLBLD(.GMPLIST,GMPLMODE),HDR^GMPLBLD K GMPSAVED
	;;^UTILITY(U,$J,"PRO",2631,20)
	;;=D EDIT^GMPLBLD
	;;^UTILITY(U,$J,"PRO",2631,99)
	;;=55945,36181
	;;^UTILITY(U,$J,"PRO",2632,0)
	;;=GMPL MENU SAVE GROUP^Save Category and Quit^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2632,1,0)
	;;=^^2^2^2931213^^^^
	;;^UTILITY(U,$J,"PRO",2632,1,1,0)
	;;=This action allows the user to save any changes that have been made to
	;;^UTILITY(U,$J,"PRO",2632,1,2,0)
	;;=the current category and exit the utility.
	;;^UTILITY(U,$J,"PRO",2632,15)
	;;=S ^GMPL(125.11,+GMPLGRP,0)=$P(GMPLGRP,U,2)_U_DT D HDR^GMPLBLDC
	;;^UTILITY(U,$J,"PRO",2632,20)
	;;=D SAVE^GMPLBLD2
	;;^UTILITY(U,$J,"PRO",2632,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2633,0)
	;;=GMPL MENU NEW GROUP^Change Categories^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2633,1,0)
	;;=^^1^1^2931213^^
	;;^UTILITY(U,$J,"PRO",2633,1,1,0)
	;;=This action allows the user to switch to editing a new problem category.
	;;^UTILITY(U,$J,"PRO",2633,20)
	;;=D NEWGRP^GMPLBLD2
	;;^UTILITY(U,$J,"PRO",2633,99)
	;;=55908,59607
	;;^UTILITY(U,$J,"PRO",2634,0)
	;;=GMPL MENU ADD PROBLEM^Add Problems to Category^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2634,1,0)
	;;=^^1^1^2931213^^
	;;^UTILITY(U,$J,"PRO",2634,1,1,0)
	;;=This action allows adding one or more problems to a problem category.
	;;^UTILITY(U,$J,"PRO",2634,20)
	;;=D ADD^GMPLBLDC
	;;^UTILITY(U,$J,"PRO",2634,99)
	;;=55984,51160
	;;^UTILITY(U,$J,"PRO",2635,0)
	;;=GMPL MENU REMOVE PROBLEM^Remove Problem from Category^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2635,1,0)
	;;=^^1^1^2931213^^
	;;^UTILITY(U,$J,"PRO",2635,1,1,0)
	;;=This action allows the user to remove a problem from the current category.
	;;^UTILITY(U,$J,"PRO",2635,20)
	;;=D REMOVE^GMPLBLDC
	;;^UTILITY(U,$J,"PRO",2635,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2636,0)
	;;=GMPL MENU RESEQUENCE PROBLEMS^Resequence Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2636,1,0)
	;;=^^3^3^2931213^^
	;;^UTILITY(U,$J,"PRO",2636,1,1,0)
	;;=This action allows the user to place the problems in the current category
	;;^UTILITY(U,$J,"PRO",2636,1,2,0)
	;;=in a different order; problems will be automatically renumbered for
	;;^UTILITY(U,$J,"PRO",2636,1,3,0)
	;;=display and selection purposes.
	;;^UTILITY(U,$J,"PRO",2636,15)
	;;=I $D(GMPREBLD) D BUILD^GMPLBLDC(.GMPLIST,GMPLMODE) K GMPREBLD
	;;^UTILITY(U,$J,"PRO",2636,20)
	;;=D RESEQ^GMPLBLD1
	;;^UTILITY(U,$J,"PRO",2636,99)
	;;=55908,59608
	;;^UTILITY(U,$J,"PRO",2637,0)
	;;=GMPL MENU EDIT PROBLEM^Edit Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2637,1,0)
	;;=^^2^2^2931213^^^
	;;^UTILITY(U,$J,"PRO",2637,1,1,0)
	;;=This action allows the user to edit the problem and its associated code;
