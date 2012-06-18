IBONI006	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",801,2,0)
	;;=^101.02A^^0
	;;^UTILITY(U,$J,"PRO",801,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",801,10,0)
	;;=^101.01PA^11^11
	;;^UTILITY(U,$J,"PRO",801,10,1,0)
	;;=802^EF^8^^^Edit Form
	;;^UTILITY(U,$J,"PRO",801,10,1,"^")
	;;=IBDF EDIT FORM
	;;^UTILITY(U,$J,"PRO",801,10,2,0)
	;;=815^CR^6^^^Create Blank Form
	;;^UTILITY(U,$J,"PRO",801,10,2,"^")
	;;=IBDF CREATE BLANK FORM
	;;^UTILITY(U,$J,"PRO",801,10,3,0)
	;;=816^CF^5^^^Copy Form
	;;^UTILITY(U,$J,"PRO",801,10,3,1)
	;;=Copy Form:
	;;^UTILITY(U,$J,"PRO",801,10,3,"^")
	;;=IBDF COPY FORM
	;;^UTILITY(U,$J,"PRO",801,10,4,0)
	;;=817^AS^3^^^Add Form to Setup
	;;^UTILITY(U,$J,"PRO",801,10,4,"^")
	;;=IBDF ADD TO CLINIC SETUP
	;;^UTILITY(U,$J,"PRO",801,10,5,0)
	;;=818^DS^4^^^Delete from Setup
	;;^UTILITY(U,$J,"PRO",801,10,5,"^")
	;;=IBDF DELETE FROM CLINIC SETUP
	;;^UTILITY(U,$J,"PRO",801,10,6,0)
	;;=826^PR^9^^^Print Sample Form
	;;^UTILITY(U,$J,"PRO",801,10,6,"^")
	;;=IBDF PRINT SAMPLE FORM
	;;^UTILITY(U,$J,"PRO",801,10,7,0)
	;;=827^DF^7^^^Delete Unused Form
	;;^UTILITY(U,$J,"PRO",801,10,7,"^")
	;;=IBDF DELETE FORM
	;;^UTILITY(U,$J,"PRO",801,10,8,0)
	;;=830^CC^1^^^Change Clinic
	;;^UTILITY(U,$J,"PRO",801,10,8,"^")
	;;=IBDF CHANGE CLINIC
	;;^UTILITY(U,$J,"PRO",801,10,9,0)
	;;=831^NM^2^^^Form Name/Descr/Size
	;;^UTILITY(U,$J,"PRO",801,10,9,"^")
	;;=IBDF EDIT FORM NAME/DESCR/SIZE
	;;^UTILITY(U,$J,"PRO",801,10,10,0)
	;;=854^EX^11^^^Exit
	;;^UTILITY(U,$J,"PRO",801,10,10,"^")
	;;=IBDF QUIT
	;;^UTILITY(U,$J,"PRO",801,10,11,0)
	;;=1082^RC^10^^^Recompile Form
	;;^UTILITY(U,$J,"PRO",801,10,11,"^")
	;;=IBDF COMPILE FORM
	;;^UTILITY(U,$J,"PRO",801,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",801,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",801,99)
	;;=55865,49189
	;;^UTILITY(U,$J,"PRO",802,0)
	;;=IBDF EDIT FORM^Edit Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",802,1,0)
	;;=^^2^2^2930624^^
	;;^UTILITY(U,$J,"PRO",802,1,1,0)
	;;=This protocol calls the list manager to display an encounter form. There
	;;^UTILITY(U,$J,"PRO",802,1,2,0)
	;;=is a menu of actions that allows the form description to be edited.
	;;^UTILITY(U,$J,"PRO",802,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",802,2,1,0)
	;;=EF
	;;^UTILITY(U,$J,"PRO",802,2,"B","EF",1)
	;;=
	;;^UTILITY(U,$J,"PRO",802,10,0)
	;;=^101.01PA^0^0
	;;^UTILITY(U,$J,"PRO",802,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",802,20)
	;;=D EDITFORM^IBDF6
	;;^UTILITY(U,$J,"PRO",802,28)
	;;=Edit Form
	;;^UTILITY(U,$J,"PRO",802,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",803,0)
	;;=IBDF DISPLAY TOOL KIT BLOCKS FOR ADDING^Add Tool Kit Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",803,1,0)
	;;=^^1^1^2931015^^^^
	;;^UTILITY(U,$J,"PRO",803,1,1,0)
	;;=Allows the user to select a block from the tool kit and add it to the form.
	;;^UTILITY(U,$J,"PRO",803,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",803,2,1,0)
	;;=AT
	;;^UTILITY(U,$J,"PRO",803,2,"B","AT",1)
	;;=
	;;^UTILITY(U,$J,"PRO",803,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",803,20)
	;;=D ADD^IBDF7
	;;^UTILITY(U,$J,"PRO",803,28)
	;;=Add Tool Kit Block
	;;^UTILITY(U,$J,"PRO",803,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",804,0)
	;;=IBDF MENU FOR EDITING DISPLAYED FORM^Add Tool Kit Block^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",804,1,0)
	;;=^^1^1^2930211^^^^
	;;^UTILITY(U,$J,"PRO",804,1,1,0)
	;;=Allows the user to edit the form.
	;;^UTILITY(U,$J,"PRO",804,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",804,10,0)
	;;=^101.01PA^12^14
	;;^UTILITY(U,$J,"PRO",804,10,1,0)
	;;=803^AT^5
	;;^UTILITY(U,$J,"PRO",804,10,1,"^")
	;;=IBDF DISPLAY TOOL KIT BLOCKS FOR ADDING
