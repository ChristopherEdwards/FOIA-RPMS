IBONI017	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",868,10,13,"^")
	;;=IBDE EDIT BLOCK'S IMP/EXP NOTES
	;;^UTILITY(U,$J,"PRO",868,10,14,0)
	;;=873^VI^7^^^View Imp/Exp Notes
	;;^UTILITY(U,$J,"PRO",868,10,14,"^")
	;;=IBDE VIEW BLOCK'S IMP/EXP NOTES
	;;^UTILITY(U,$J,"PRO",868,10,15,0)
	;;=874^IE^3^^^Import Entry
	;;^UTILITY(U,$J,"PRO",868,10,15,"^")
	;;=IBDE IMPORT TK BLOCK
	;;^UTILITY(U,$J,"PRO",868,10,16,0)
	;;=854^LF^2^^^List Forms
	;;^UTILITY(U,$J,"PRO",868,10,16,"^")
	;;=IBDF QUIT
	;;^UTILITY(U,$J,"PRO",868,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",868,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",868,99)
	;;=55857,42359
	;;^UTILITY(U,$J,"PRO",869,0)
	;;=IBDE DISPLAY TK BLOCKS^List TK Blocks^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",869,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",869,1,1,0)
	;;=Displays the list of tool kit blocks that are in the imp/exp files.
	;;^UTILITY(U,$J,"PRO",869,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",869,2,1,0)
	;;=DB
	;;^UTILITY(U,$J,"PRO",869,2,"B","DB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",869,20)
	;;=D BLOCKS^IBDE1
	;;^UTILITY(U,$J,"PRO",869,99)
	;;=55789,49889
	;;^UTILITY(U,$J,"PRO",870,0)
	;;=IBDE DELTE TK BLOCK FROM IMP/EXP FILES^Delete Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",870,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",870,1,1,0)
	;;=Allows the user to select a TK block, then deletes it.
	;;^UTILITY(U,$J,"PRO",870,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",870,2,1,0)
	;;=DE
	;;^UTILITY(U,$J,"PRO",870,2,"B","DE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",870,20)
	;;=D DELETE^IBDE3
	;;^UTILITY(U,$J,"PRO",870,99)
	;;=55742,56808
	;;^UTILITY(U,$J,"PRO",871,0)
	;;=IBDE ADD BLOCK TO IMP/EXP WS^Add Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",871,1,0)
	;;=^^1^1^2930816^
	;;^UTILITY(U,$J,"PRO",871,1,1,0)
	;;=Allows the user to choose any block and adds it to the import/export files.
	;;^UTILITY(U,$J,"PRO",871,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",871,2,1,0)
	;;=AE
	;;^UTILITY(U,$J,"PRO",871,2,"B","AE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",871,20)
	;;=D ADD^IBDE3
	;;^UTILITY(U,$J,"PRO",871,99)
	;;=55745,44138
	;;^UTILITY(U,$J,"PRO",872,0)
	;;=IBDE EDIT BLOCK'S IMP/EXP NOTES^Edit Imp/Exp Notes^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",872,1,0)
	;;=^^2^2^2930816^
	;;^UTILITY(U,$J,"PRO",872,1,1,0)
	;;=Allows the user to select a tool kit block from the imp/exp files, then
	;;^UTILITY(U,$J,"PRO",872,1,2,0)
	;;=allows him to edit the imp/exp notes.
	;;^UTILITY(U,$J,"PRO",872,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",872,2,1,0)
	;;=EI
	;;^UTILITY(U,$J,"PRO",872,2,"B","EI",1)
	;;=
	;;^UTILITY(U,$J,"PRO",872,20)
	;;=D EDIT^IBDE3
	;;^UTILITY(U,$J,"PRO",872,99)
	;;=55745,44286
	;;^UTILITY(U,$J,"PRO",873,0)
	;;=IBDE VIEW BLOCK'S IMP/EXP NOTES^View Imp/Exp Notes^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",873,1,0)
	;;=^^2^2^2930816^
	;;^UTILITY(U,$J,"PRO",873,1,1,0)
	;;=Allows the user to select a tool kit block from the imp/exp files, then
	;;^UTILITY(U,$J,"PRO",873,1,2,0)
	;;=allows him to view the imp/exp notes.
	;;^UTILITY(U,$J,"PRO",873,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",873,2,1,0)
	;;=VI
	;;^UTILITY(U,$J,"PRO",873,2,"B","VI",1)
	;;=
	;;^UTILITY(U,$J,"PRO",873,20)
	;;=D VIEW^IBDE3
	;;^UTILITY(U,$J,"PRO",873,99)
	;;=55745,44470
	;;^UTILITY(U,$J,"PRO",874,0)
	;;=IBDE IMPORT TK BLOCK^Import Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",874,1,0)
	;;=^^1^1^2930817^
	;;^UTILITY(U,$J,"PRO",874,1,1,0)
	;;=Allows the user to select a tool kit block from the list, then imports it.
	;;^UTILITY(U,$J,"PRO",874,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",874,2,1,0)
	;;=IE
