IBONI004	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",785,1,4,0)
	;;=and the event record was left open, this action may be used to close
	;;^UTILITY(U,$J,"PRO",785,1,5,0)
	;;=the event record.
	;;^UTILITY(U,$J,"PRO",785,4)
	;;=^^^Change Status
	;;^UTILITY(U,$J,"PRO",785,20)
	;;=D CS^IBECEA51
	;;^UTILITY(U,$J,"PRO",785,99)
	;;=55642,37634
	;;^UTILITY(U,$J,"PRO",786,0)
	;;=IBACME LAST CALC^Last Calc Date^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",786,1,0)
	;;=^^5^5^2930826^
	;;^UTILITY(U,$J,"PRO",786,1,1,0)
	;;=This action is used to adjust the last day that a patient was billing
	;;^UTILITY(U,$J,"PRO",786,1,2,0)
	;;=for the Means Test hospital or nursing home per diem charge.  If an
	;;^UTILITY(U,$J,"PRO",786,1,3,0)
	;;=event record is open and the patient still admitted, the nightly
	;;^UTILITY(U,$J,"PRO",786,1,4,0)
	;;=compilation will start billing the patient on the day following the
	;;^UTILITY(U,$J,"PRO",786,1,5,0)
	;;='Last Calculated' date.
	;;^UTILITY(U,$J,"PRO",786,4)
	;;=^^^Last Calc Date
	;;^UTILITY(U,$J,"PRO",786,20)
	;;=D LC^IBECEA51
	;;^UTILITY(U,$J,"PRO",786,99)
	;;=55642,37687
	;;^UTILITY(U,$J,"PRO",794,0)
	;;=IBDF EDIT SELECTION LIST MENU^EDIT SELECTION LIST^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",794,1,0)
	;;=^^2^2^2930423^^
	;;^UTILITY(U,$J,"PRO",794,1,1,0)
	;;=Displays all the selection groups defined for the list and provides
	;;^UTILITY(U,$J,"PRO",794,1,2,0)
	;;=a menu of actions for editing the contents of the list.
	;;^UTILITY(U,$J,"PRO",794,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",794,10,0)
	;;=^101.01PA^7^7
	;;^UTILITY(U,$J,"PRO",794,10,1,0)
	;;=795^AG^1^^^Add Group
	;;^UTILITY(U,$J,"PRO",794,10,1,"^")
	;;=IBDF ADD GROUP
	;;^UTILITY(U,$J,"PRO",794,10,2,0)
	;;=796^DG^2^^^Delete Group
	;;^UTILITY(U,$J,"PRO",794,10,2,"^")
	;;=IBDF DELETE GROUP
	;;^UTILITY(U,$J,"PRO",794,10,3,0)
	;;=797^GH^4^^^Group Header/Order
	;;^UTILITY(U,$J,"PRO",794,10,3,"^")
	;;=IBDF EDIT GROUP HDR/ORDER
	;;^UTILITY(U,$J,"PRO",794,10,4,0)
	;;=800^GC^3^^^Group's Contents
	;;^UTILITY(U,$J,"PRO",794,10,4,"^")
	;;=IBDF DISPLAY GRP'S SLCTNS FOR EDIT
	;;^UTILITY(U,$J,"PRO",794,10,5,0)
	;;=824^EX^7^^^Exit
	;;^UTILITY(U,$J,"PRO",794,10,5,"^")
	;;=IBDF EXIT
	;;^UTILITY(U,$J,"PRO",794,10,6,0)
	;;=1070^AB^5^^^Add Blank
	;;^UTILITY(U,$J,"PRO",794,10,6,"^")
	;;=IBDF ADD BLANK GROUP
	;;^UTILITY(U,$J,"PRO",794,10,7,0)
	;;=1071^FA^6^^^Format All
	;;^UTILITY(U,$J,"PRO",794,10,7,"^")
	;;=IBDF FORMAT ALL SELECTIONS
	;;^UTILITY(U,$J,"PRO",794,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",794,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",794,99)
	;;=55865,38871
	;;^UTILITY(U,$J,"PRO",795,0)
	;;=IBDF ADD GROUP^Add Group^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",795,1,0)
	;;=^^1^1^2930607^^^
	;;^UTILITY(U,$J,"PRO",795,1,1,0)
	;;=Adds a new group to the selection list.
	;;^UTILITY(U,$J,"PRO",795,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",795,2,1,0)
	;;=AG
	;;^UTILITY(U,$J,"PRO",795,2,"B","AG",1)
	;;=
	;;^UTILITY(U,$J,"PRO",795,20)
	;;=D ADDGRP^IBDF3
	;;^UTILITY(U,$J,"PRO",795,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",796,0)
	;;=IBDF DELETE GROUP^Delete Group^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",796,1,0)
	;;=^^3^3^2930510^
	;;^UTILITY(U,$J,"PRO",796,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",796,1,2,0)
	;;=Allows the user to select a group. The selected group, along with all of
	;;^UTILITY(U,$J,"PRO",796,1,3,0)
	;;=its selections, is deleted.
	;;^UTILITY(U,$J,"PRO",796,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",796,2,1,0)
	;;=DG
	;;^UTILITY(U,$J,"PRO",796,2,"B","DG",1)
	;;=
	;;^UTILITY(U,$J,"PRO",796,20)
	;;=D DELGRP^IBDF3
	;;^UTILITY(U,$J,"PRO",796,99)
	;;=55852,54043
