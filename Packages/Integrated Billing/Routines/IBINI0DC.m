IBINI0DC	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",2513,1,4,0)
	;;=the last update for a parent even though the update may not be within
	;;^UTILITY(U,$J,"OPT",2513,1,5,0)
	;;=the date range.  The net total within a date range can be derived by
	;;^UTILITY(U,$J,"OPT",2513,1,6,0)
	;;=the formula "new+update-cancel" for any associated action types.
	;;^UTILITY(U,$J,"OPT",2513,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2513,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2513,25)
	;;=IBOST
	;;^UTILITY(U,$J,"OPT",2513,"U")
	;;=STATISTICAL REPORT (IB)
	;;^UTILITY(U,$J,"OPT",2514,0)
	;;=IB OUTPUT LIST ACTIONS^Print IB Actions by Date^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2514,1,0)
	;;=^^3^3^2910311^
	;;^UTILITY(U,$J,"OPT",2514,1,1,0)
	;;=This option will print the IB actions by a user selected date range.
	;;^UTILITY(U,$J,"OPT",2514,1,2,0)
	;;=The user may also select an additional field to sort by, such as
	;;^UTILITY(U,$J,"OPT",2514,1,3,0)
	;;=status.
	;;^UTILITY(U,$J,"OPT",2514,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2514,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2514,25)
	;;=EN2^IBODISP
	;;^UTILITY(U,$J,"OPT",2514,"U")
	;;=PRINT IB ACTIONS BY DATE
	;;^UTILITY(U,$J,"OPT",2516,0)
	;;=IB OUTPUT FULL INQ BY BILL NO^Patient Billing Inquiry^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2516,1,0)
	;;=^^4^4^2940120^^^^
	;;^UTILITY(U,$J,"OPT",2516,1,1,0)
	;;=This option will display information about a bill.  The bill may either
	;;^UTILITY(U,$J,"OPT",2516,1,2,0)
	;;=be a third party bill, a pharmacy co-pay bill, or a means test charge.
	;;^UTILITY(U,$J,"OPT",2516,1,3,0)
	;;=If a full inquiry is selected for non-third party bills, then additional
	;;^UTILITY(U,$J,"OPT",2516,1,4,0)
	;;=information about the care or services is displayed when available.
	;;^UTILITY(U,$J,"OPT",2516,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2516,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2516,25)
	;;=IBOLK
	;;^UTILITY(U,$J,"OPT",2516,"U")
	;;=PATIENT BILLING INQUIRY
	;;^UTILITY(U,$J,"OPT",2523,0)
	;;=IB OUTPUT PATIENT REPORT MENU^Patient Billing Reports Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2523,1,0)
	;;=^^3^3^2930823^^^^
	;;^UTILITY(U,$J,"OPT",2523,1,1,0)
	;;=This menu contains the Billing reports that deal with one
	;;^UTILITY(U,$J,"OPT",2523,1,2,0)
	;;=or a group of patients.   This includes all billing lists of patients and
	;;^UTILITY(U,$J,"OPT",2523,1,3,0)
	;;=billing inquiries.
	;;^UTILITY(U,$J,"OPT",2523,10,0)
	;;=^19.01IP^20^14
	;;^UTILITY(U,$J,"OPT",2523,10,2,0)
	;;=2516^INQU
	;;^UTILITY(U,$J,"OPT",2523,10,2,"^")
	;;=IB OUTPUT FULL INQ BY BILL NO
	;;^UTILITY(U,$J,"OPT",2523,10,3,0)
	;;=2514^DATE
	;;^UTILITY(U,$J,"OPT",2523,10,3,"^")
	;;=IB OUTPUT LIST ACTIONS
	;;^UTILITY(U,$J,"OPT",2523,10,7,0)
	;;=3363^PROF
	;;^UTILITY(U,$J,"OPT",2523,10,7,"^")
	;;=IB MT PROFILE
	;;^UTILITY(U,$J,"OPT",2523,10,8,0)
	;;=3364^ESTM
	;;^UTILITY(U,$J,"OPT",2523,10,8,"^")
	;;=IB MT ESTIMATOR
	;;^UTILITY(U,$J,"OPT",2523,10,9,0)
	;;=3369^MTLS
	;;^UTILITY(U,$J,"OPT",2523,10,9,"^")
	;;=IB MT BILLING REPORT
	;;^UTILITY(U,$J,"OPT",2523,10,10,0)
	;;=3361^APP
	;;^UTILITY(U,$J,"OPT",2523,10,10,"^")
	;;=IB OUTPUT BASC FORMS FOR APPT
	;;^UTILITY(U,$J,"OPT",2523,10,11,0)
	;;=3370^SHEE
	;;^UTILITY(U,$J,"OPT",2523,10,11,"^")
	;;=IB BASC PRINT A GROUP
	;;^UTILITY(U,$J,"OPT",2523,10,12,0)
	;;=2300^LIST
	;;^UTILITY(U,$J,"OPT",2523,10,12,"^")
	;;=IB LIST ALL BILLS FOR PAT.
	;;^UTILITY(U,$J,"OPT",2523,10,13,0)
	;;=2322^EPIS
	;;^UTILITY(U,$J,"OPT",2523,10,13,"^")
	;;=IB LIST BILLS FOR EPISODE
	;;^UTILITY(U,$J,"OPT",2523,10,14,0)
	;;=1225^OUTP
	;;^UTILITY(U,$J,"OPT",2523,10,14,"^")
	;;=IB THIRD PARTY OUTPUT MENU
