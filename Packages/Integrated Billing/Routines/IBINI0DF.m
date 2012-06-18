IBINI0DF	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3354,0)
	;;=IB BASC TRANSFER^Run Amb. Surg. Update^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3354,1,0)
	;;=^^2^2^2920722^^^^
	;;^UTILITY(U,$J,"OPT",3354,1,1,0)
	;;=Transfer procedures from temporary billing file to the permanent file.
	;;^UTILITY(U,$J,"OPT",3354,1,2,0)
	;;=Generally done once a year, after a new HCFA release.
	;;^UTILITY(U,$J,"OPT",3354,25)
	;;=IBECPTT
	;;^UTILITY(U,$J,"OPT",3354,"U")
	;;=RUN AMB. SURG. UPDATE
	;;^UTILITY(U,$J,"OPT",3355,0)
	;;=IB PURGE/BASC TRANSFER CLEANUP^Purge Update File^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3355,1,0)
	;;=^^2^2^2920722^^^^
	;;^UTILITY(U,$J,"OPT",3355,1,1,0)
	;;=Delete all CPT entries in the temporary file that have been transferred
	;;^UTILITY(U,$J,"OPT",3355,1,2,0)
	;;=to the permanent billing file.
	;;^UTILITY(U,$J,"OPT",3355,25)
	;;=PURGE^IBECPTZ
	;;^UTILITY(U,$J,"OPT",3355,"U")
	;;=PURGE UPDATE FILE
	;;^UTILITY(U,$J,"OPT",3356,0)
	;;=IB BASC TRANSFER ERRORS^List Transfer Errors^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3356,1,0)
	;;=^^3^3^2920722^^^^
	;;^UTILITY(U,$J,"OPT",3356,1,1,0)
	;;=Lists all entries in the temporary BASC file that have not been able to
	;;^UTILITY(U,$J,"OPT",3356,1,2,0)
	;;=transfer to the permanent BASC file.  This includes only those procedures
	;;^UTILITY(U,$J,"OPT",3356,1,3,0)
	;;=that could not transfer due to some error.
	;;^UTILITY(U,$J,"OPT",3356,25)
	;;=LIST^IBECPTZ
	;;^UTILITY(U,$J,"OPT",3356,"U")
	;;=LIST TRANSFER ERRORS
	;;^UTILITY(U,$J,"OPT",3360,0)
	;;=IB BASC PRINT GROUP ENTRY^Build CPT Check-off Sheet^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3360,1,0)
	;;=^^1^1^2920527^^^^
	;;^UTILITY(U,$J,"OPT",3360,1,1,0)
	;;=Enter or edit a clinic's CPT list.
	;;^UTILITY(U,$J,"OPT",3360,25)
	;;=IBERSE
	;;^UTILITY(U,$J,"OPT",3360,"U")
	;;=BUILD CPT CHECK-OFF SHEET
	;;^UTILITY(U,$J,"OPT",3361,0)
	;;=IB OUTPUT BASC FORMS FOR APPT^Print Check-off Sheet for Appointments^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3361,1,0)
	;;=^^4^4^2920423^^^^
	;;^UTILITY(U,$J,"OPT",3361,1,1,0)
	;;=For a given date, print Ambulatory Surgery Check-Off Sheets for individual
	;;^UTILITY(U,$J,"OPT",3361,1,2,0)
	;;=appointments or for each appointment in particular clinics.
	;;^UTILITY(U,$J,"OPT",3361,1,3,0)
	;;=No Check-Off Sheet will be printed for appointments that are no-shows
	;;^UTILITY(U,$J,"OPT",3361,1,4,0)
	;;=or have been cancelled.  Requires 132 columns.
	;;^UTILITY(U,$J,"OPT",3361,25)
	;;=IBERS
	;;^UTILITY(U,$J,"OPT",3361,"U")
	;;=PRINT CHECK-OFF SHEET FOR APPO
	;;^UTILITY(U,$J,"OPT",3363,0)
	;;=IB MT PROFILE^Single Patient Category C Billing Profile^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3363,1,0)
	;;=^^3^3^2920109^^
	;;^UTILITY(U,$J,"OPT",3363,1,1,0)
	;;=The Category C Billing Profile may be used to list, for a single patient,
	;;^UTILITY(U,$J,"OPT",3363,1,2,0)
	;;=all Means Test/Category C charges which fall within a user-specified
	;;^UTILITY(U,$J,"OPT",3363,1,3,0)
	;;=date range.
	;;^UTILITY(U,$J,"OPT",3363,25)
	;;=IBOMTP
	;;^UTILITY(U,$J,"OPT",3363,"U")
	;;=SINGLE PATIENT CATEGORY C BILL
	;;^UTILITY(U,$J,"OPT",3364,0)
	;;=IB MT ESTIMATOR^Estimate Category C Charges for an Admission^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3364,1,0)
	;;=^^4^4^2920103^
	;;^UTILITY(U,$J,"OPT",3364,1,1,0)
	;;=This report is used to estimate the Means Test/Category C charges for
	;;^UTILITY(U,$J,"OPT",3364,1,2,0)
	;;=an episode of Hospital or Nursing Home Care, given a proposed length
	;;^UTILITY(U,$J,"OPT",3364,1,3,0)
	;;=of stay.  The report may also be used to determine the remaining
