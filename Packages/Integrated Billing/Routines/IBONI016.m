IBONI016	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",863,1,2,0)
	;;=the imp/exp notes.
	;;^UTILITY(U,$J,"PRO",863,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",863,2,1,0)
	;;=VI
	;;^UTILITY(U,$J,"PRO",863,2,"B","VI",1)
	;;=
	;;^UTILITY(U,$J,"PRO",863,20)
	;;=D VIEW^IBDE1
	;;^UTILITY(U,$J,"PRO",863,99)
	;;=55742,34209
	;;^UTILITY(U,$J,"PRO",864,0)
	;;=IBDE IMPORT FORM^Import Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",864,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",864,1,1,0)
	;;=Allows the user to select a form from the work space, then imports it.
	;;^UTILITY(U,$J,"PRO",864,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",864,2,1,0)
	;;=IE
	;;^UTILITY(U,$J,"PRO",864,2,"B","IE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",864,20)
	;;=D IMPORT^IBDE1
	;;^UTILITY(U,$J,"PRO",864,99)
	;;=55742,41565
	;;^UTILITY(U,$J,"PRO",865,0)
	;;=IBDE IMP/EXP HELP^Help^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",865,1,0)
	;;=^^2^2^2930813^
	;;^UTILITY(U,$J,"PRO",865,1,1,0)
	;;=Displays help information about the import/export procedures that the user
	;;^UTILITY(U,$J,"PRO",865,1,2,0)
	;;=must follow.
	;;^UTILITY(U,$J,"PRO",865,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",865,2,1,0)
	;;=HE
	;;^UTILITY(U,$J,"PRO",865,2,"B","HE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",865,20)
	;;=D HELP^IBDEHELP
	;;^UTILITY(U,$J,"PRO",865,99)
	;;=55742,48206
	;;^UTILITY(U,$J,"PRO",866,0)
	;;=IBDE EXECUTE DIFROM^DIFROM^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",866,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",866,1,1,0)
	;;=Allows the user to execute ^DIFROM without leaving the imp/exp utility.
	;;^UTILITY(U,$J,"PRO",866,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",866,2,1,0)
	;;=DI
	;;^UTILITY(U,$J,"PRO",866,2,"B","DI",1)
	;;=
	;;^UTILITY(U,$J,"PRO",866,20)
	;;=D DIFROM^IBDE1
	;;^UTILITY(U,$J,"PRO",866,99)
	;;=55742,48356
	;;^UTILITY(U,$J,"PRO",867,0)
	;;=IBDE EXECUTE INITS^Run Inits^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",867,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",867,1,1,0)
	;;=Allows the user to execute the inits without leaving the imp/exp utilities.
	;;^UTILITY(U,$J,"PRO",867,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",867,2,1,0)
	;;=RI
	;;^UTILITY(U,$J,"PRO",867,2,"B","RI",1)
	;;=
	;;^UTILITY(U,$J,"PRO",867,20)
	;;=D INITS^IBDE1
	;;^UTILITY(U,$J,"PRO",867,99)
	;;=55789,49918
	;;^UTILITY(U,$J,"PRO",868,0)
	;;=IBDE IMP/EXP MENU FOR BLOCKS^List TK Blocks^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",868,1,0)
	;;=^^1^1^2930813^^^^
	;;^UTILITY(U,$J,"PRO",868,1,1,0)
	;;=The menu of actions that apply to tool kit blocks in the imp/exp files.
	;;^UTILITY(U,$J,"PRO",868,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",868,2,1,0)
	;;=SB
	;;^UTILITY(U,$J,"PRO",868,2,"B","SB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",868,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",868,10,0)
	;;=^101.01PA^10^16
	;;^UTILITY(U,$J,"PRO",868,10,4,0)
	;;=861^CW^4^^^Clear Work Space
	;;^UTILITY(U,$J,"PRO",868,10,4,"^")
	;;=IBDE DELETE IMP/EXP FILES
	;;^UTILITY(U,$J,"PRO",868,10,8,0)
	;;=865^HE^1^^^Help
	;;^UTILITY(U,$J,"PRO",868,10,8,"^")
	;;=IBDE IMP/EXP HELP
	;;^UTILITY(U,$J,"PRO",868,10,9,0)
	;;=866^DI^9^^^DIFROM
	;;^UTILITY(U,$J,"PRO",868,10,9,"^")
	;;=IBDE EXECUTE DIFROM
	;;^UTILITY(U,$J,"PRO",868,10,10,0)
	;;=867^RI^10^^^Run Inits
	;;^UTILITY(U,$J,"PRO",868,10,10,"^")
	;;=IBDE EXECUTE INITS
	;;^UTILITY(U,$J,"PRO",868,10,11,0)
	;;=870^DE^5^^^Delete Entry
	;;^UTILITY(U,$J,"PRO",868,10,11,"^")
	;;=IBDE DELTE TK BLOCK FROM IMP/EXP FILES
	;;^UTILITY(U,$J,"PRO",868,10,12,0)
	;;=871^AE^6^^^Add Entry
	;;^UTILITY(U,$J,"PRO",868,10,12,"^")
	;;=IBDE ADD BLOCK TO IMP/EXP WS
	;;^UTILITY(U,$J,"PRO",868,10,13,0)
	;;=872^EI^8^^^Edit Imp/Exp Notes
