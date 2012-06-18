IBINI0DE	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",2562,1,1,0)
	;;=This option will compare the soft-link stored in Integrated Billing with
	;;^UTILITY(U,$J,"OPT",2562,1,2,0)
	;;=the pointer in the prescription file pointing back to Integrated Billing.
	;;^UTILITY(U,$J,"OPT",2562,1,3,0)
	;;=A report will print out of all IB Actions that do not verify.
	;;^UTILITY(U,$J,"OPT",2562,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2562,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2562,25)
	;;=IBOCHK
	;;^UTILITY(U,$J,"OPT",2562,"U")
	;;=VERIFY RX CO-PAY LINKS
	;;^UTILITY(U,$J,"OPT",3235,0)
	;;=IB REV CODE TOTALS^Revenue Code Totals by Rate Type^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3235,1,0)
	;;=^^1^1^2911022^
	;;^UTILITY(U,$J,"OPT",3235,1,1,0)
	;;=Print totals of Revenue Code amounts by Rate Type.  To collect data for AMIS Segments 295 and 296
	;;^UTILITY(U,$J,"OPT",3235,25)
	;;=IBOAMS
	;;^UTILITY(U,$J,"OPT",3235,"U")
	;;=REVENUE CODE TOTALS BY RATE TY
	;;^UTILITY(U,$J,"OPT",3346,0)
	;;=IB OUTPUT CLK PROD^Clerk Productivity^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3346,1,0)
	;;=^^2^2^2920616^^^^
	;;^UTILITY(U,$J,"OPT",3346,1,1,0)
	;;=Lists number and type of bills entered by selected clerks, over a
	;;^UTILITY(U,$J,"OPT",3346,1,2,0)
	;;=date range.
	;;^UTILITY(U,$J,"OPT",3346,25)
	;;=IBOCPD
	;;^UTILITY(U,$J,"OPT",3346,"U")
	;;=CLERK PRODUCTIVITY
	;;^UTILITY(U,$J,"OPT",3348,0)
	;;=IB BASC UPDATE MENU^Ambulatory Surgery Maintenance Menu^^M^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3348,1,0)
	;;=^^1^1^2920527^^^^
	;;^UTILITY(U,$J,"OPT",3348,1,1,0)
	;;=This menu contains all Ambulatory Surgery billing options.
	;;^UTILITY(U,$J,"OPT",3348,10,0)
	;;=^19.01IP^11^9
	;;^UTILITY(U,$J,"OPT",3348,10,2,0)
	;;=3350^DIV
	;;^UTILITY(U,$J,"OPT",3348,10,2,"^")
	;;=IB BASC LOCALITY MODIFIER
	;;^UTILITY(U,$J,"OPT",3348,10,4,0)
	;;=3352^RTG
	;;^UTILITY(U,$J,"OPT",3348,10,4,"^")
	;;=IB BASC RATE GROUP ENTRY
	;;^UTILITY(U,$J,"OPT",3348,10,5,0)
	;;=3355^CLN
	;;^UTILITY(U,$J,"OPT",3348,10,5,"^")
	;;=IB PURGE/BASC TRANSFER CLEANUP
	;;^UTILITY(U,$J,"OPT",3348,10,6,0)
	;;=3356^ERR
	;;^UTILITY(U,$J,"OPT",3348,10,6,"^")
	;;=IB BASC TRANSFER ERRORS
	;;^UTILITY(U,$J,"OPT",3348,10,7,0)
	;;=3354^UPD
	;;^UTILITY(U,$J,"OPT",3348,10,7,"^")
	;;=IB BASC TRANSFER
	;;^UTILITY(U,$J,"OPT",3348,10,8,0)
	;;=3360^PRT
	;;^UTILITY(U,$J,"OPT",3348,10,8,"^")
	;;=IB BASC PRINT GROUP ENTRY
	;;^UTILITY(U,$J,"OPT",3348,10,9,0)
	;;=3361^APP
	;;^UTILITY(U,$J,"OPT",3348,10,9,"^")
	;;=IB OUTPUT BASC FORMS FOR APPT
	;;^UTILITY(U,$J,"OPT",3348,10,10,0)
	;;=3370^SHE
	;;^UTILITY(U,$J,"OPT",3348,10,10,"^")
	;;=IB BASC PRINT A GROUP
	;;^UTILITY(U,$J,"OPT",3348,10,11,0)
	;;=3583^INA
	;;^UTILITY(U,$J,"OPT",3348,10,11,"^")
	;;=IB BASC INACTIVE CODES
	;;^UTILITY(U,$J,"OPT",3348,99)
	;;=55301,42711
	;;^UTILITY(U,$J,"OPT",3348,"U")
	;;=AMBULATORY SURGERY MAINTENANCE
	;;^UTILITY(U,$J,"OPT",3350,0)
	;;=IB BASC LOCALITY MODIFIER^Locality Modifier Enter/Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3350,1,0)
	;;=^^1^1^2920626^^^
	;;^UTILITY(U,$J,"OPT",3350,1,1,0)
	;;=Enter or edit division information related to billing.
	;;^UTILITY(U,$J,"OPT",3350,25)
	;;=EN5^IBECPTE
	;;^UTILITY(U,$J,"OPT",3350,"U")
	;;=LOCALITY MODIFIER ENTER/EDIT
	;;^UTILITY(U,$J,"OPT",3352,0)
	;;=IB BASC RATE GROUP ENTRY^Ambulatory Surgery Rate Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3352,1,0)
	;;=^^1^1^2920129^^
	;;^UTILITY(U,$J,"OPT",3352,1,1,0)
	;;=Enter/edit entries in the CPT rate group billing file.
	;;^UTILITY(U,$J,"OPT",3352,25)
	;;=EN4^IBECPTE
	;;^UTILITY(U,$J,"OPT",3352,"U")
	;;=AMBULATORY SURGERY RATE EDIT
