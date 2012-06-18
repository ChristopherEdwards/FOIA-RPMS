IBONI018	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",874,2,"B","IE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",874,20)
	;;=D IMPORT^IBDE3
	;;^UTILITY(U,$J,"PRO",874,99)
	;;=55746,52359
	;;^UTILITY(U,$J,"PRO",875,0)
	;;=IBDF CHANGE BLOCK TK ORDER^Change TK Order^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",875,1,0)
	;;=^^1^1^2930820^
	;;^UTILITY(U,$J,"PRO",875,1,1,0)
	;;=Allows the user to select a block from the tool kit, then change it's order.
	;;^UTILITY(U,$J,"PRO",875,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",875,2,1,0)
	;;=CH
	;;^UTILITY(U,$J,"PRO",875,2,"B","CH",1)
	;;=
	;;^UTILITY(U,$J,"PRO",875,20)
	;;=D CHGORDER^IBDF13
	;;^UTILITY(U,$J,"PRO",875,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",876,0)
	;;=IBDF PRINT MANAGER CLINIC SETUP^Clinic Print Manager^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",876,1,0)
	;;=^^2^2^2930831^^
	;;^UTILITY(U,$J,"PRO",876,1,1,0)
	;;=Allows the user to edit the setup used by the Print Manager in determining 
	;;^UTILITY(U,$J,"PRO",876,1,2,0)
	;;=what forms to print for an appointment at the clinic level.
	;;^UTILITY(U,$J,"PRO",876,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",876,2,1,0)
	;;=CL
	;;^UTILITY(U,$J,"PRO",876,2,"B","CL",1)
	;;=
	;;^UTILITY(U,$J,"PRO",876,20)
	;;=D CLNCSUP2^IBDF11
	;;^UTILITY(U,$J,"PRO",876,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",876,"MEN","SD PARM PARAMETERS MENU")
	;;=876^CL^9
	;;^UTILITY(U,$J,"PRO",877,0)
	;;=IBDF PRINT MANAGER DIVISION SETUP^Div Print Manager^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",877,1,0)
	;;=^^2^2^2930831^
	;;^UTILITY(U,$J,"PRO",877,1,1,0)
	;;=Allows the user to edit the setup used by the Print Manager in determining
	;;^UTILITY(U,$J,"PRO",877,1,2,0)
	;;=what forms to print for an appointment at the division level.
	;;^UTILITY(U,$J,"PRO",877,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",877,2,1,0)
	;;=DV
	;;^UTILITY(U,$J,"PRO",877,2,"B","DV",1)
	;;=
	;;^UTILITY(U,$J,"PRO",877,20)
	;;=D DIVSUP2^IBDF11
	;;^UTILITY(U,$J,"PRO",877,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",877,"MEN","SD PARM PARAMETERS MENU")
	;;=877^DV^10
	;;^UTILITY(U,$J,"PRO",878,0)
	;;=IBCNSM CHANGE PATIENT^Change Patient^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",878,20)
	;;=D CP^IBCNSM
	;;^UTILITY(U,$J,"PRO",878,24)
	;;=I '$G(IBTRN)
	;;^UTILITY(U,$J,"PRO",878,99)
	;;=55768,35752
	;;^UTILITY(U,$J,"PRO",879,0)
	;;=IBCNSM VIEW PAT POLICY^Policy Edit/View^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",879,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",879,20)
	;;=D VP^IBCNSM1
	;;^UTILITY(U,$J,"PRO",879,99)
	;;=55768,35757
	;;^UTILITY(U,$J,"PRO",880,0)
	;;=IBCNSM UPDATE ANNUAL BENEFITS^Annual Benefits^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",880,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",880,20)
	;;=D AB^IBCNSM1
	;;^UTILITY(U,$J,"PRO",880,99)
	;;=55768,35756
	;;^UTILITY(U,$J,"PRO",881,0)
	;;=IBCNSM UPDATE INS CO.^Ins. Co. Edit^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",881,20)
	;;=D EI^IBCNSM2
	;;^UTILITY(U,$J,"PRO",881,99)
	;;=55768,35756
	;;^UTILITY(U,$J,"PRO",882,0)
	;;=IBCNSM PRINT WORKSHEET^Worksheet Print^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",882,20)
	;;=D WP^IBCNSM1
	;;^UTILITY(U,$J,"PRO",882,99)
	;;=55768,35756
	;;^UTILITY(U,$J,"PRO",883,0)
	;;=IBCNSM PRINT PATIENT INS^Print Insurance Cov.^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",883,20)
	;;=D PC^IBCNSM1
	;;^UTILITY(U,$J,"PRO",883,99)
	;;=55768,35756
	;;^UTILITY(U,$J,"PRO",884,0)
	;;=IBCNSM VERIFY INS^Verify Coverage^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",884,20)
	;;=D VC^IBCNSM2
	;;^UTILITY(U,$J,"PRO",884,99)
	;;=55768,35756
	;;^UTILITY(U,$J,"PRO",885,0)
	;;=IBCNSC INS CO EDIT ALL^Edit All^^A^^^^^^^^INTEGRATED BILLING
