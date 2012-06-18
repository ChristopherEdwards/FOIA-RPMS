IBINI0E1	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4164,0)
	;;=IBCN VIEW INSURANCE CO^View Insurance Company^^R^^^^^^^^INSURANCE MANAGEMENT^^1^1
	;;^UTILITY(U,$J,"OPT",4164,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"OPT",4164,1,1,0)
	;;=This option allows viewing of insurance company information.
	;;^UTILITY(U,$J,"OPT",4164,15)
	;;=K IBVIEW
	;;^UTILITY(U,$J,"OPT",4164,20)
	;;=S IBVIEW=1
	;;^UTILITY(U,$J,"OPT",4164,25)
	;;=IBCNSC
	;;^UTILITY(U,$J,"OPT",4164,99)
	;;=55742,46974
	;;^UTILITY(U,$J,"OPT",4164,"U")
	;;=VIEW INSURANCE COMPANY
	;;^UTILITY(U,$J,"OPT",4165,0)
	;;=IBCN VIEW INSURANCE DATA^View Insurance Management Menu^^M^^^^^^^^INSURANCE MANAGEMENT
	;;^UTILITY(U,$J,"OPT",4165,1,0)
	;;=^^2^2^2940311^^^
	;;^UTILITY(U,$J,"OPT",4165,1,1,0)
	;;=This menu contains the view option to Patient Insurance and Insurance
	;;^UTILITY(U,$J,"OPT",4165,1,2,0)
	;;=Company information.
	;;^UTILITY(U,$J,"OPT",4165,10,0)
	;;=^19.01PI^2^2
	;;^UTILITY(U,$J,"OPT",4165,10,1,0)
	;;=4164^IC
	;;^UTILITY(U,$J,"OPT",4165,10,1,"^")
	;;=IBCN VIEW INSURANCE CO
	;;^UTILITY(U,$J,"OPT",4165,10,2,0)
	;;=4163^PI
	;;^UTILITY(U,$J,"OPT",4165,10,2,"^")
	;;=IBCN VIEW PATIENT INSURANCE
	;;^UTILITY(U,$J,"OPT",4165,99)
	;;=55825,69300
	;;^UTILITY(U,$J,"OPT",4165,"U")
	;;=VIEW INSURANCE MANAGEMENT MENU
	;;^UTILITY(U,$J,"OPT",4166,0)
	;;=IB OUTPUT AUTO BILLER^Print Auto Biller Results^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4166,1,0)
	;;=^^1^1^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4166,1,1,0)
	;;=Prints the list of bills and comments resulting from the Automated Biller.
	;;^UTILITY(U,$J,"OPT",4166,25)
	;;=PRINT^IBCDE
	;;^UTILITY(U,$J,"OPT",4166,"U")
	;;=PRINT AUTO BILLER RESULTS
	;;^UTILITY(U,$J,"OPT",4167,0)
	;;=IBT EDIT IR TRACKING ENTRY^Claims Tracking Edit^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4167,1,0)
	;;=^^3^3^2930627^
	;;^UTILITY(U,$J,"OPT",4167,1,1,0)
	;;=This option allows enter/editing of Claims Tracking Entries.  Data
	;;^UTILITY(U,$J,"OPT",4167,1,2,0)
	;;=associated with a CT entry may affect if or how it is billed and the
	;;^UTILITY(U,$J,"OPT",4167,1,3,0)
	;;=types of reviews that may be or must be entered.
	;;^UTILITY(U,$J,"OPT",4167,20)
	;;=S IBTRPRF=2 D ^IBTRE K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4167,"U")
	;;=CLAIMS TRACKING EDIT
	;;^UTILITY(U,$J,"OPT",4168,0)
	;;=IBT EDIT HR TRACKING ENTRY^Claims Tracking Edit^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4168,1,0)
	;;=^^3^3^2930907^^
	;;^UTILITY(U,$J,"OPT",4168,1,1,0)
	;;=This option allows enter/editing of Claims Tracking Entries.  Data
	;;^UTILITY(U,$J,"OPT",4168,1,2,0)
	;;=associated with a CT entry may affect if or how it is billed and the
	;;^UTILITY(U,$J,"OPT",4168,1,3,0)
	;;=types of reviews that may be or must be entered.
	;;^UTILITY(U,$J,"OPT",4168,20)
	;;=S IBTRPRF=1 D ^IBTRE K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4168,"U")
	;;=CLAIMS TRACKING EDIT
	;;^UTILITY(U,$J,"OPT",4169,0)
	;;=IB AUTO BILLER PARAMS^Enter/Edit Automated Billing Parameters^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4169,1,0)
	;;=^^1^1^2930907^
	;;^UTILITY(U,$J,"OPT",4169,1,1,0)
	;;=Enter and edit the parameters controlling Automated Billing.
	;;^UTILITY(U,$J,"OPT",4169,25)
	;;=EDIT^IBCDE
	;;^UTILITY(U,$J,"OPT",4169,"U")
	;;=ENTER/EDIT AUTOMATED BILLING P
	;;^UTILITY(U,$J,"OPT",4170,0)
	;;=IB OUTPUT RANK CARRIERS^Rank Insurance Carriers By Amount Billed^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4170,1,0)
	;;=^^14^14^2930908^^^^
	;;^UTILITY(U,$J,"OPT",4170,1,1,0)
	;;=This option is used to generate a listing of insurance carriers ranked
	;;^UTILITY(U,$J,"OPT",4170,1,2,0)
	;;=by the total amount billed.  The user may specify a date range from
