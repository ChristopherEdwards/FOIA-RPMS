IBINI0D7	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1222,51)
	;;=
	;;^UTILITY(U,$J,"OPT",1222,"U")
	;;=UPDATE RATE TYPE FILE
	;;^UTILITY(U,$J,"OPT",1223,0)
	;;=IB BILLING TOTALS REPORT^Rate Type Billing Totals Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1223,1,0)
	;;=^^2^2^2911024^^^^
	;;^UTILITY(U,$J,"OPT",1223,1,1,0)
	;;=This report is sorted by rate type and prints all billing totals for
	;;^UTILITY(U,$J,"OPT",1223,1,2,0)
	;;=each rate type.
	;;^UTILITY(U,$J,"OPT",1223,25)
	;;=13^IBCMENU
	;;^UTILITY(U,$J,"OPT",1223,"U")
	;;=RATE TYPE BILLING TOTALS REPOR
	;;^UTILITY(U,$J,"OPT",1224,0)
	;;=IB INPATIENT VET REPORT^Veterans w/Insurance and Inpatient Admissions^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1224,1,0)
	;;=^^4^4^2930712^^^^
	;;^UTILITY(U,$J,"OPT",1224,1,1,0)
	;;=This option prints a list of all patients with non-service connected
	;;^UTILITY(U,$J,"OPT",1224,1,2,0)
	;;=disabilities who have insurance and who had inpatient admissions during
	;;^UTILITY(U,$J,"OPT",1224,1,3,0)
	;;=a user-specified date range. Eligibility status is provided for each
	;;^UTILITY(U,$J,"OPT",1224,1,4,0)
	;;=patient on list.
	;;^UTILITY(U,$J,"OPT",1224,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1224,25)
	;;=INP^IBCONSC
	;;^UTILITY(U,$J,"OPT",1224,"U")
	;;=VETERANS W/INSURANCE AND INPAT
	;;^UTILITY(U,$J,"OPT",1225,0)
	;;=IB THIRD PARTY OUTPUT MENU^Third Party Output Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1225,1,0)
	;;=^^2^2^2920206^^^^
	;;^UTILITY(U,$J,"OPT",1225,1,1,0)
	;;=This option allows the user to generate any of the Third
	;;^UTILITY(U,$J,"OPT",1225,1,2,0)
	;;=Party Outputs.
	;;^UTILITY(U,$J,"OPT",1225,10,0)
	;;=^19.01PI^7^7
	;;^UTILITY(U,$J,"OPT",1225,10,1,0)
	;;=1224^INSC
	;;^UTILITY(U,$J,"OPT",1225,10,1,"^")
	;;=IB INPATIENT VET REPORT
	;;^UTILITY(U,$J,"OPT",1225,10,2,0)
	;;=1218^ONSC
	;;^UTILITY(U,$J,"OPT",1225,10,2,"^")
	;;=IB OUTPATIENT VET REPORT
	;;^UTILITY(U,$J,"OPT",1225,10,3,0)
	;;=907^PATR
	;;^UTILITY(U,$J,"OPT",1225,10,3,"^")
	;;=DG THIRD PARTY PATIENT REVIEW
	;;^UTILITY(U,$J,"OPT",1225,10,4,0)
	;;=850^INFO
	;;^UTILITY(U,$J,"OPT",1225,10,4,"^")
	;;=DG THIRD PARTY REIMBURSEMENT
	;;^UTILITY(U,$J,"OPT",1225,10,5,0)
	;;=3380^DISC
	;;^UTILITY(U,$J,"OPT",1225,10,5,"^")
	;;=IB OUTPUT VETS BY DISCH
	;;^UTILITY(U,$J,"OPT",1225,10,6,0)
	;;=3384^UNKI
	;;^UTILITY(U,$J,"OPT",1225,10,6,"^")
	;;=IB OUTPUT INPTS WITHOUT INS
	;;^UTILITY(U,$J,"OPT",1225,10,7,0)
	;;=3385^UNKO
	;;^UTILITY(U,$J,"OPT",1225,10,7,"^")
	;;=IB OUTPUT OPTS WITHOUT INS
	;;^UTILITY(U,$J,"OPT",1225,99)
	;;=55307,34306
	;;^UTILITY(U,$J,"OPT",1225,"U")
	;;=THIRD PARTY OUTPUT MENU
	;;^UTILITY(U,$J,"OPT",1228,0)
	;;=IB PATIENT BILLING INQUIRY^Patient Billing Inquiry^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1228,1,0)
	;;=^^5^5^2901022^
	;;^UTILITY(U,$J,"OPT",1228,1,1,0)
	;;=This option displays all the actions which have been performed
	;;^UTILITY(U,$J,"OPT",1228,1,2,0)
	;;=on a specified billing record. The user may select by patient name
	;;^UTILITY(U,$J,"OPT",1228,1,3,0)
	;;=or bill number a particular record, and is shown bill status, total
	;;^UTILITY(U,$J,"OPT",1228,1,4,0)
	;;=charges, statement covers period, and all previous actions of that
	;;^UTILITY(U,$J,"OPT",1228,1,5,0)
	;;=billing record.
	;;^UTILITY(U,$J,"OPT",1228,25)
	;;=IBOLK
	;;^UTILITY(U,$J,"OPT",1228,"U")
	;;=PATIENT BILLING INQUIRY
	;;^UTILITY(U,$J,"OPT",1237,0)
	;;=IB UB-82 TEST PATTERN PRINT^UB-82 Test Pattern Print^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1237,1,0)
	;;=^^2^2^2930905^^^^
	;;^UTILITY(U,$J,"OPT",1237,1,1,0)
	;;=This option prints a test pattern on the UB-82 form so that
