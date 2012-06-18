IBONI005	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",797,0)
	;;=IBDF EDIT GROUP HDR/ORDER^Group Header/Order^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",797,1,0)
	;;=^^3^3^2930510^
	;;^UTILITY(U,$J,"PRO",797,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",797,1,2,0)
	;;=Allows a group to be selected. Then the header and print order can be
	;;^UTILITY(U,$J,"PRO",797,1,3,0)
	;;=edited.
	;;^UTILITY(U,$J,"PRO",797,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",797,2,1,0)
	;;=EG
	;;^UTILITY(U,$J,"PRO",797,2,2,0)
	;;=EH
	;;^UTILITY(U,$J,"PRO",797,2,"B","EG",1)
	;;=
	;;^UTILITY(U,$J,"PRO",797,2,"B","EH",2)
	;;=
	;;^UTILITY(U,$J,"PRO",797,20)
	;;=D EDITGRP^IBDF3
	;;^UTILITY(U,$J,"PRO",797,99)
	;;=55852,54044
	;;^UTILITY(U,$J,"PRO",798,0)
	;;=IBDF EDIT GROUP'S SELECTIONS MENU^Edit Selections^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",798,1,0)
	;;=^^1^1^2930212^^^^
	;;^UTILITY(U,$J,"PRO",798,1,1,0)
	;;=Used to edit a group's selections.
	;;^UTILITY(U,$J,"PRO",798,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",798,2,1,0)
	;;=ES
	;;^UTILITY(U,$J,"PRO",798,2,"B","ES",1)
	;;=
	;;^UTILITY(U,$J,"PRO",798,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",798,10,0)
	;;=^101.01PA^6^6
	;;^UTILITY(U,$J,"PRO",798,10,1,0)
	;;=799^AS^1^^^Add Selection
	;;^UTILITY(U,$J,"PRO",798,10,1,"^")
	;;=IBDF ADD SELECTION
	;;^UTILITY(U,$J,"PRO",798,10,2,0)
	;;=808^ES^2^^^Edit Selection
	;;^UTILITY(U,$J,"PRO",798,10,2,"^")
	;;=IBDF EDIT SELECTION
	;;^UTILITY(U,$J,"PRO",798,10,3,0)
	;;=809^DS^3^^^Delete Selection
	;;^UTILITY(U,$J,"PRO",798,10,3,1)
	;;=Delete Selection
	;;^UTILITY(U,$J,"PRO",798,10,3,"^")
	;;=IBDF DELETE SELECTION
	;;^UTILITY(U,$J,"PRO",798,10,4,0)
	;;=824^EX^6^^^Exit
	;;^UTILITY(U,$J,"PRO",798,10,4,"^")
	;;=IBDF EXIT
	;;^UTILITY(U,$J,"PRO",798,10,5,0)
	;;=1069^AB^4^^^Add Blank
	;;^UTILITY(U,$J,"PRO",798,10,5,"^")
	;;=IBDF ADD BLANK SELECTION
	;;^UTILITY(U,$J,"PRO",798,10,6,0)
	;;=1072^FA^5^^^Format All
	;;^UTILITY(U,$J,"PRO",798,10,6,"^")
	;;=IBDF FORMAT GROUP'S SELECTIONS
	;;^UTILITY(U,$J,"PRO",798,15)
	;;=
	;;^UTILITY(U,$J,"PRO",798,20)
	;;=
	;;^UTILITY(U,$J,"PRO",798,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",798,99)
	;;=55866,36594
	;;^UTILITY(U,$J,"PRO",799,0)
	;;=IBDF ADD SELECTION^Add Selection^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",799,1,0)
	;;=^^1^1^2930607^^
	;;^UTILITY(U,$J,"PRO",799,1,1,0)
	;;=Adds a new selection to the selection list.
	;;^UTILITY(U,$J,"PRO",799,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",799,2,1,0)
	;;=AS
	;;^UTILITY(U,$J,"PRO",799,2,"B","AS",1)
	;;=
	;;^UTILITY(U,$J,"PRO",799,15)
	;;=
	;;^UTILITY(U,$J,"PRO",799,20)
	;;=D ADDSLCTN^IBDF4
	;;^UTILITY(U,$J,"PRO",799,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",800,0)
	;;=IBDF DISPLAY GRP'S SLCTNS FOR EDIT^Group's Contents^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",800,1,0)
	;;=^^1^1^2930510^
	;;^UTILITY(U,$J,"PRO",800,1,1,0)
	;;=Displays the group's selections and a menu of edit actions.
	;;^UTILITY(U,$J,"PRO",800,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",800,2,1,0)
	;;=ES
	;;^UTILITY(U,$J,"PRO",800,2,"B","ES",1)
	;;=
	;;^UTILITY(U,$J,"PRO",800,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",800,20)
	;;=D EDTSLCTN^IBDF3
	;;^UTILITY(U,$J,"PRO",800,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",801,0)
	;;=IBDF CLINIC'S FORMS MENU^Clinic's Setup^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",801,1,0)
	;;=^^3^3^2931214^^^^
	;;^UTILITY(U,$J,"PRO",801,1,1,0)
	;;=Displays all of the forms used by a particular clinic. Allows the user
	;;^UTILITY(U,$J,"PRO",801,1,2,0)
	;;=to change the clinic setup, create new blank forms, copy forms, delete
	;;^UTILITY(U,$J,"PRO",801,1,3,0)
	;;=to change the clinic setup, create new blank forms, copy forms, delete
