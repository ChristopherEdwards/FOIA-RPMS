IBINI0E0	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4157,1,2,0)
	;;=The option will automatically queue off a task to add refills and when 
	;;^UTILITY(U,$J,"OPT",4157,1,3,0)
	;;=complete send the requesting user a mail message.
	;;^UTILITY(U,$J,"OPT",4157,25)
	;;=EN^IBTRKR3
	;;^UTILITY(U,$J,"OPT",4157,"U")
	;;=MANUALLY ADD RX REFILLS TO CLA
	;;^UTILITY(U,$J,"OPT",4158,0)
	;;=IBT SUP MANUALLY QUE ENCTRS^Manually Add Opt. Encounters to Claims Tracking^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4158,1,0)
	;;=^^5^5^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4158,1,1,0)
	;;=This option allows the user to select a date range of outpatient encounters
	;;^UTILITY(U,$J,"OPT",4158,1,2,0)
	;;=and tries to add them to the Claims tracking module.
	;;^UTILITY(U,$J,"OPT",4158,1,3,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4158,1,4,0)
	;;=The option will automatically queue off a task to add encounters and when 
	;;^UTILITY(U,$J,"OPT",4158,1,5,0)
	;;=complete send the requesting user a mail message.
	;;^UTILITY(U,$J,"OPT",4158,25)
	;;=EN^IBTRKR4
	;;^UTILITY(U,$J,"OPT",4158,99)
	;;=55776,47507
	;;^UTILITY(U,$J,"OPT",4158,"U")
	;;=MANUALLY ADD OPT. ENCOUNTERS T
	;;^UTILITY(U,$J,"OPT",4160,0)
	;;=IBCN INSURANCE MGMT MENU^Patient Insurance Menu^^M^^^^^^^^INSURANCE MANAGEMENT
	;;^UTILITY(U,$J,"OPT",4160,1,0)
	;;=^^1^1^2931104^^^^
	;;^UTILITY(U,$J,"OPT",4160,1,1,0)
	;;=This is the main menu to edit, view, and print insurance information.
	;;^UTILITY(U,$J,"OPT",4160,10,0)
	;;=^19.01PI^7^6
	;;^UTILITY(U,$J,"OPT",4160,10,2,0)
	;;=4161^EI^3
	;;^UTILITY(U,$J,"OPT",4160,10,2,"^")
	;;=IBCN INSURANCE CO EDIT
	;;^UTILITY(U,$J,"OPT",4160,10,3,0)
	;;=4162^PI^1
	;;^UTILITY(U,$J,"OPT",4160,10,3,"^")
	;;=IBCN PATIENT INSURANCE
	;;^UTILITY(U,$J,"OPT",4160,10,4,0)
	;;=4163^VP^2
	;;^UTILITY(U,$J,"OPT",4160,10,4,"^")
	;;=IBCN VIEW PATIENT INSURANCE
	;;^UTILITY(U,$J,"OPT",4160,10,5,0)
	;;=4164^VI^4
	;;^UTILITY(U,$J,"OPT",4160,10,5,"^")
	;;=IBCN VIEW INSURANCE CO
	;;^UTILITY(U,$J,"OPT",4160,10,6,0)
	;;=4187^LC
	;;^UTILITY(U,$J,"OPT",4160,10,6,"^")
	;;=IBCN LIST INACTIVE INS W/PAT
	;;^UTILITY(U,$J,"OPT",4160,10,7,0)
	;;=4246^NV
	;;^UTILITY(U,$J,"OPT",4160,10,7,"^")
	;;=IBCN LIST NEW NOT VER
	;;^UTILITY(U,$J,"OPT",4160,99)
	;;=55892,49766
	;;^UTILITY(U,$J,"OPT",4160,"U")
	;;=PATIENT INSURANCE MENU
	;;^UTILITY(U,$J,"OPT",4161,0)
	;;=IBCN INSURANCE CO EDIT^Insurance Company Entry/Edit^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4161,1,0)
	;;=^^1^1^2930626^
	;;^UTILITY(U,$J,"OPT",4161,1,1,0)
	;;=This option allows edit insurance company information
	;;^UTILITY(U,$J,"OPT",4161,25)
	;;=IBCNSC
	;;^UTILITY(U,$J,"OPT",4161,99)
	;;=55696,36156
	;;^UTILITY(U,$J,"OPT",4161,"U")
	;;=INSURANCE COMPANY ENTRY/EDIT
	;;^UTILITY(U,$J,"OPT",4162,0)
	;;=IBCN PATIENT INSURANCE^Patient Insurance Info View/Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4162,1,0)
	;;=^^1^1^2930813^^
	;;^UTILITY(U,$J,"OPT",4162,1,1,0)
	;;=This option allows viewing and editing of patient insurance information.
	;;^UTILITY(U,$J,"OPT",4162,25)
	;;=IBCNSM4
	;;^UTILITY(U,$J,"OPT",4162,"U")
	;;=PATIENT INSURANCE INFO VIEW/ED
	;;^UTILITY(U,$J,"OPT",4163,0)
	;;=IBCN VIEW PATIENT INSURANCE^View Patient Insurance^^R^^^^^^^^INSURANCE MANAGEMENT^^1^1
	;;^UTILITY(U,$J,"OPT",4163,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"OPT",4163,1,1,0)
	;;=This option allows viewing of patient insurance information.
	;;^UTILITY(U,$J,"OPT",4163,15)
	;;=K IBVIEW
	;;^UTILITY(U,$J,"OPT",4163,20)
	;;=S IBVIEW=1
	;;^UTILITY(U,$J,"OPT",4163,25)
	;;=IBCNSM4
	;;^UTILITY(U,$J,"OPT",4163,99)
	;;=55742,49865
	;;^UTILITY(U,$J,"OPT",4163,"U")
	;;=VIEW PATIENT INSURANCE
