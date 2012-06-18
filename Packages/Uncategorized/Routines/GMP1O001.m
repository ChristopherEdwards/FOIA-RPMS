GMP1O001 ; ; 01-SEP-1995
 ;;2.0;Problem List;**3**;AUG 25, 1994
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",1351,0)
 ;;=GMPL MENU VIEW LIST^View w/wo Seq Numbers^^A^^^^^^^^PROBLEM LIST
 ;;^UTILITY(U,$J,"PRO",1351,1,0)
 ;;=^^3^3^2940202^^^^
 ;;^UTILITY(U,$J,"PRO",1351,1,1,0)
 ;;=This action allows the user to toggle between displaying the sequence
 ;;^UTILITY(U,$J,"PRO",1351,1,2,0)
 ;;=numbers assigned to each category for ordering, or the display numbers
 ;;^UTILITY(U,$J,"PRO",1351,1,3,0)
 ;;=only.
 ;;^UTILITY(U,$J,"PRO",1351,4)
 ;;=^
 ;;^UTILITY(U,$J,"PRO",1351,10,0)
 ;;=^101.01PA^0^0
 ;;^UTILITY(U,$J,"PRO",1351,15)
 ;;=W !,"Rebuilding selection list display to"_$S(GMPLMODE="E":" not",1:"")_" show sequence numbers ..." D BUILD^GMPLBLD("^TMP(""GMPLIST"",$J)",GMPLMODE)
 ;;^UTILITY(U,$J,"PRO",1351,20)
 ;;=S GMPLMODE=$S(GMPLMODE="E":"I",1:"E"),VALMBCK="R",VALMSG=$$MSG^GMPLX
 ;;^UTILITY(U,$J,"PRO",1351,26)
 ;;=
 ;;^UTILITY(U,$J,"PRO",1351,28)
 ;;=
 ;;^UTILITY(U,$J,"PRO",1351,99)
 ;;=56270,61134
 ;;^UTILITY(U,$J,"PRO",1352,0)
 ;;=GMPL MENU RESEQUENCE GROUPS^Resequence Categories^^A^^^^^^^^PROBLEM LIST
 ;;^UTILITY(U,$J,"PRO",1352,1,0)
 ;;=^^2^2^2931213^^^^
 ;;^UTILITY(U,$J,"PRO",1352,1,1,0)
 ;;=This action allows the user to place the problem caetgories on the current
 ;;^UTILITY(U,$J,"PRO",1352,1,2,0)
 ;;=list in a different order; problems will be automatically renumbered.
 ;;^UTILITY(U,$J,"PRO",1352,15)
 ;;=I $D(GMPREBLD) D BUILD^GMPLBLD("^TMP(""GMPLIST"",$J)",GMPLMODE) K GMPREBLD
 ;;^UTILITY(U,$J,"PRO",1352,20)
 ;;=D RESEQ^GMPLBLD1
 ;;^UTILITY(U,$J,"PRO",1352,99)
 ;;=56270,61134
 ;;^UTILITY(U,$J,"PRO",1357,0)
 ;;=GMPL MENU CREATE GROUP^Enter/Edit Category^^A^^^^^^^^PROBLEM LIST
 ;;^UTILITY(U,$J,"PRO",1357,1,0)
 ;;=^^7^7^2940304^^^^
 ;;^UTILITY(U,$J,"PRO",1357,1,1,0)
 ;;=This action transfers control to the List Manager utility, to bring up
 ;;^UTILITY(U,$J,"PRO",1357,1,2,0)
 ;;=a new screen allowing the entry/editing of any problem category.
 ;;^UTILITY(U,$J,"PRO",1357,1,3,0)
 ;;=The user will be asked for the category s/he wishes to review and edit,
 ;;^UTILITY(U,$J,"PRO",1357,1,4,0)
 ;;=and a screen similar to the 'Build List' menu will be shown allowing
 ;;^UTILITY(U,$J,"PRO",1357,1,5,0)
 ;;=similar actions to edit the contents of the selected category.  A new
 ;;^UTILITY(U,$J,"PRO",1357,1,6,0)
 ;;=category may be entered here, which will be available to add to the
 ;;^UTILITY(U,$J,"PRO",1357,1,7,0)
 ;;=current list upon return to the 'Build List' screen when finished.
 ;;^UTILITY(U,$J,"PRO",1357,15)
 ;;=I $D(GMPSAVED) D BUILD^GMPLBLD("^TMP(""GMPLIST"",$J)",GMPLMODE),HDR^GMPLBLD K GMPSAVED
 ;;^UTILITY(U,$J,"PRO",1357,20)
 ;;=D EDIT^GMPLBLD
 ;;^UTILITY(U,$J,"PRO",1357,99)
 ;;=56270,61133
 ;;^UTILITY(U,$J,"PRO",1362,0)
 ;;=GMPL MENU RESEQUENCE PROBLEMS^Resequence Problems^^A^^^^^^^^PROBLEM LIST
 ;;^UTILITY(U,$J,"PRO",1362,1,0)
 ;;=^^3^3^2931213^^
 ;;^UTILITY(U,$J,"PRO",1362,1,1,0)
 ;;=This action allows the user to place the problems in the current category
 ;;^UTILITY(U,$J,"PRO",1362,1,2,0)
 ;;=in a different order; problems will be automatically renumbered for
 ;;^UTILITY(U,$J,"PRO",1362,1,3,0)
 ;;=display and selection purposes.
 ;;^UTILITY(U,$J,"PRO",1362,15)
 ;;=I $D(GMPREBLD) D BUILD^GMPLBLDC("^TMP(""GMPLIST"",$J)",GMPLMODE) K GMPREBLD
 ;;^UTILITY(U,$J,"PRO",1362,20)
 ;;=D RESEQ^GMPLBLD1
 ;;^UTILITY(U,$J,"PRO",1362,99)
 ;;=56270,61134
 ;;^UTILITY(U,$J,"PRO",1364,0)
 ;;=GMPL MENU VIEW GROUP^View w/wo Seq Numbers^^A^^^^^^^^PROBLEM LIST
 ;;^UTILITY(U,$J,"PRO",1364,1,0)
 ;;=^^3^3^2940202^^^
 ;;^UTILITY(U,$J,"PRO",1364,1,1,0)
 ;;=This action allows the user to toggle between displaying the sequence
 ;;^UTILITY(U,$J,"PRO",1364,1,2,0)
 ;;=numbers assigned to each problem for ordering, or the display numbers
 ;;^UTILITY(U,$J,"PRO",1364,1,3,0)
 ;;=only.
 ;;^UTILITY(U,$J,"PRO",1364,4)
 ;;=^
 ;;^UTILITY(U,$J,"PRO",1364,10,0)
 ;;=^101.01PA^0^0
 ;;^UTILITY(U,$J,"PRO",1364,15)
 ;;=W !,"Rebuilding problem category display to"_$S(GMPLMODE="E":" not",1:"")_" show sequence numbers ..." D BUILD^GMPLBLDC("^TMP(""GMPLIST"",$J)",GMPLMODE)
 ;;^UTILITY(U,$J,"PRO",1364,20)
 ;;=S GMPLMODE=$S(GMPLMODE="E":"I",1:"E"),VALMBCK="R",VALMSG=$$MSG^GMPLX
 ;;^UTILITY(U,$J,"PRO",1364,26)
 ;;=
 ;;^UTILITY(U,$J,"PRO",1364,28)
 ;;=
 ;;^UTILITY(U,$J,"PRO",1364,99)
 ;;=56270,61134
