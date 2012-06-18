IBONI012	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",830,1,0)
	;;=^^3^3^2930413^
	;;^UTILITY(U,$J,"PRO",830,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",830,1,2,0)
	;;=Allows the user to specify a different clinic. The  setup for the new
	;;^UTILITY(U,$J,"PRO",830,1,3,0)
	;;=clinic will then be displayed.
	;;^UTILITY(U,$J,"PRO",830,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",830,2,1,0)
	;;=CC
	;;^UTILITY(U,$J,"PRO",830,2,"B","CC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",830,20)
	;;=D CHNGCLNC^IBDF6
	;;^UTILITY(U,$J,"PRO",830,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",831,0)
	;;=IBDF EDIT FORM NAME/DESCR/SIZE^Form Name/Descr/Size^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",831,1,0)
	;;=^^1^1^2930420^
	;;^UTILITY(U,$J,"PRO",831,1,1,0)
	;;=Allows the user to select a form, then edit its name, description, and size.
	;;^UTILITY(U,$J,"PRO",831,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",831,2,1,0)
	;;=NM
	;;^UTILITY(U,$J,"PRO",831,2,"B","NM",1)
	;;=
	;;^UTILITY(U,$J,"PRO",831,20)
	;;=D EDITFORM^IBDF6C
	;;^UTILITY(U,$J,"PRO",831,99)
	;;=55852,54044
	;;^UTILITY(U,$J,"PRO",832,0)
	;;=IBDF SHIFT BLOCK CONTENTS^Shift Contents^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",832,1,0)
	;;=^^4^4^2930510^
	;;^UTILITY(U,$J,"PRO",832,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",832,1,2,0)
	;;=The user can use this action to move the contents of a block. He can
	;;^UTILITY(U,$J,"PRO",832,1,3,0)
	;;=specify the type of object to shift, the area to be affected and the
	;;^UTILITY(U,$J,"PRO",832,1,4,0)
	;;=direction and distance of the shift.
	;;^UTILITY(U,$J,"PRO",832,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",832,2,1,0)
	;;=SH
	;;^UTILITY(U,$J,"PRO",832,2,"B","SH",1)
	;;=
	;;^UTILITY(U,$J,"PRO",832,15)
	;;=D IDXBLOCK^IBDFU4(BLKIDX)
	;;^UTILITY(U,$J,"PRO",832,20)
	;;=D SHIFT^IBDF10()
	;;^UTILITY(U,$J,"PRO",832,99)
	;;=55852,54050
	;;^UTILITY(U,$J,"PRO",833,0)
	;;=IBDF REDRAW FORM^Re Display Screen^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",833,1,0)
	;;=^^5^5^2930510^
	;;^UTILITY(U,$J,"PRO",833,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",833,1,2,0)
	;;=Causes the form to be re-displayed. Should be used if it is suspected that
	;;^UTILITY(U,$J,"PRO",833,1,3,0)
	;;=the display is incorrect. This differs from the refresh action that comes
	;;^UTILITY(U,$J,"PRO",833,1,4,0)
	;;=with the List Processor in that the array which contains the list of form
	;;^UTILITY(U,$J,"PRO",833,1,5,0)
	;;=lines is re-built.
	;;^UTILITY(U,$J,"PRO",833,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",833,2,1,0)
	;;=RD
	;;^UTILITY(U,$J,"PRO",833,2,"B","RD",1)
	;;=
	;;^UTILITY(U,$J,"PRO",833,20)
	;;=D REDRAW^IBDF5C
	;;^UTILITY(U,$J,"PRO",833,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",839,0)
	;;=IBDF TOOL KIT FORMS MENU^IBDF TOOL KIT FORMS MENU^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",839,1,0)
	;;=^^2^2^2930624^^^
	;;^UTILITY(U,$J,"PRO",839,1,1,0)
	;;=Displays the tool kit forms. Allows the user to edit them, create new ones,
	;;^UTILITY(U,$J,"PRO",839,1,2,0)
	;;=etc.
	;;^UTILITY(U,$J,"PRO",839,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",839,10,0)
	;;=^101.01PA^6^10
	;;^UTILITY(U,$J,"PRO",839,10,1,0)
	;;=802^EF^^^^Edit Form
	;;^UTILITY(U,$J,"PRO",839,10,1,"^")
	;;=IBDF EDIT FORM
	;;^UTILITY(U,$J,"PRO",839,10,2,0)
	;;=815^CR^^^^Create Blank Form
	;;^UTILITY(U,$J,"PRO",839,10,2,"^")
	;;=IBDF CREATE BLANK FORM
	;;^UTILITY(U,$J,"PRO",839,10,3,0)
	;;=816^CF^^^^Copy Form
	;;^UTILITY(U,$J,"PRO",839,10,3,1)
	;;=Copy Form:
	;;^UTILITY(U,$J,"PRO",839,10,3,"^")
	;;=IBDF COPY FORM
	;;^UTILITY(U,$J,"PRO",839,10,6,0)
	;;=826^PR^^^^Print Sample Form
	;;^UTILITY(U,$J,"PRO",839,10,6,"^")
	;;=IBDF PRINT SAMPLE FORM
