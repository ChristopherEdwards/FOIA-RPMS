IBINI0D5	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1214,1,0)
	;;=^^3^3^2940120^^^^
	;;^UTILITY(U,$J,"OPT",1214,1,1,0)
	;;=This option allows the user to print a third party bill 
	;;^UTILITY(U,$J,"OPT",1214,1,2,0)
	;;=after all required information has been input, and after
	;;^UTILITY(U,$J,"OPT",1214,1,3,0)
	;;=the billing information has been reviewed and authorized.
	;;^UTILITY(U,$J,"OPT",1214,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1214,25)
	;;=6^IBCMENU
	;;^UTILITY(U,$J,"OPT",1214,"U")
	;;=PRINT BILL
	;;^UTILITY(U,$J,"OPT",1215,0)
	;;=IB BILL STATUS REPORT^Bill Status Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1215,1,0)
	;;=^^1^1^2880629^^^^
	;;^UTILITY(U,$J,"OPT",1215,1,1,0)
	;;=This option generates a report which lists each bill with its status.
	;;^UTILITY(U,$J,"OPT",1215,25)
	;;=3^IBCMENU
	;;^UTILITY(U,$J,"OPT",1215,"U")
	;;=BILL STATUS REPORT
	;;^UTILITY(U,$J,"OPT",1216,0)
	;;=IB CANCEL BILL^Cancel Bill^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1216,1,0)
	;;=^^5^5^2930905^^^^
	;;^UTILITY(U,$J,"OPT",1216,1,1,0)
	;;=This option allows the user to cancel a bill. A mandatory
	;;^UTILITY(U,$J,"OPT",1216,1,2,0)
	;;=comment field exists to document the reason for cancellation,
	;;^UTILITY(U,$J,"OPT",1216,1,3,0)
	;;=and a log is maintained to audit responsible user and date/time
	;;^UTILITY(U,$J,"OPT",1216,1,4,0)
	;;=bill is cancelled. A bulletin is sent to the billing supervisor
	;;^UTILITY(U,$J,"OPT",1216,1,5,0)
	;;=each time a bill is cancelled.
	;;^UTILITY(U,$J,"OPT",1216,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1216,25)
	;;=4^IBCMENU
	;;^UTILITY(U,$J,"OPT",1216,"U")
	;;=CANCEL BILL
	;;^UTILITY(U,$J,"OPT",1217,0)
	;;=IB BILLING CLERK MENU^Billing Clerk's Menu^^M^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",1217,1,0)
	;;=^^4^4^2940125^^^^
	;;^UTILITY(U,$J,"OPT",1217,1,1,0)
	;;=This menu contains the basic Medical Care Cost Recovery Billing Module
	;;^UTILITY(U,$J,"OPT",1217,1,2,0)
	;;=options. Through this option, a user may inquire to billing records,
	;;^UTILITY(U,$J,"OPT",1217,1,3,0)
	;;=generate a limited number of reports, and with the proper security
	;;^UTILITY(U,$J,"OPT",1217,1,4,0)
	;;=keys, may also establish and review billing records.
	;;^UTILITY(U,$J,"OPT",1217,10,0)
	;;=^19.01PI^6^5
	;;^UTILITY(U,$J,"OPT",1217,10,1,0)
	;;=3372^UBCF
	;;^UTILITY(U,$J,"OPT",1217,10,1,"^")
	;;=IB THIRD PARTY BILLING MENU
	;;^UTILITY(U,$J,"OPT",1217,10,2,0)
	;;=3373^CATC
	;;^UTILITY(U,$J,"OPT",1217,10,2,"^")
	;;=IB MEANS TEST MENU
	;;^UTILITY(U,$J,"OPT",1217,10,3,0)
	;;=2523^OUTP
	;;^UTILITY(U,$J,"OPT",1217,10,3,"^")
	;;=IB OUTPUT PATIENT REPORT MENU
	;;^UTILITY(U,$J,"OPT",1217,10,5,0)
	;;=1208^BILL
	;;^UTILITY(U,$J,"OPT",1217,10,5,"^")
	;;=IB EDIT BILLING INFO
	;;^UTILITY(U,$J,"OPT",1217,10,6,0)
	;;=4182^BI
	;;^UTILITY(U,$J,"OPT",1217,10,6,"^")
	;;=IBT USER MENU (BI)
	;;^UTILITY(U,$J,"OPT",1217,20)
	;;=I $D(^%ZOSF("TEST")) S X="PRCAUT2" X ^%ZOSF("TEST") I $T D COUNT^PRCAUT2
	;;^UTILITY(U,$J,"OPT",1217,99)
	;;=55907,52875
	;;^UTILITY(U,$J,"OPT",1217,"U")
	;;=BILLING CLERK'S MENU
	;;^UTILITY(U,$J,"OPT",1218,0)
	;;=IB OUTPATIENT VET REPORT^Veterans w/Insurance and Opt. Visits^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1218,1,0)
	;;=^^4^4^2930712^^^^
	;;^UTILITY(U,$J,"OPT",1218,1,1,0)
	;;=This option prints a list of all patients with non-service connected
	;;^UTILITY(U,$J,"OPT",1218,1,2,0)
	;;=disabilities who have insurance and who had outpatient visits during
	;;^UTILITY(U,$J,"OPT",1218,1,3,0)
	;;=a user-specified date range. Eligibility status is provided for each 
	;;^UTILITY(U,$J,"OPT",1218,1,4,0)
	;;=patient on list.
