IBINI0DG	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3364,1,4,0)
	;;=charges that will be billed to a current inpatient.
	;;^UTILITY(U,$J,"OPT",3364,25)
	;;=IBOMTE
	;;^UTILITY(U,$J,"OPT",3364,"U")
	;;=ESTIMATE CATEGORY C CHARGES FO
	;;^UTILITY(U,$J,"OPT",3365,0)
	;;=IB MT NIGHT COMP^Queue Means Test/Category C Compilation of Charges^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3365,1,0)
	;;=^^3^3^2940303^^^^
	;;^UTILITY(U,$J,"OPT",3365,1,1,0)
	;;=This job creates Means Test/Category C bills for all current inpatients
	;;^UTILITY(U,$J,"OPT",3365,1,2,0)
	;;=through the previous day.  The job should be queued to run each evening
	;;^UTILITY(U,$J,"OPT",3365,1,3,0)
	;;=after the G&L Recalculation has been completed.
	;;^UTILITY(U,$J,"OPT",3365,25)
	;;=IBAMTC
	;;^UTILITY(U,$J,"OPT",3365,200)
	;;=^^1D^
	;;^UTILITY(U,$J,"OPT",3365,"U")
	;;=QUEUE MEANS TEST/CATEGORY C CO
	;;^UTILITY(U,$J,"OPT",3367,0)
	;;=IB OUTPUT TREND REPORT^Insurance Payment Trend Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3367,1,0)
	;;=^^7^7^2940207^^
	;;^UTILITY(U,$J,"OPT",3367,1,1,0)
	;;=This option allows the user to analyze payment trends among
	;;^UTILITY(U,$J,"OPT",3367,1,2,0)
	;;=insurance companies.  In addition, it may be used to track
	;;^UTILITY(U,$J,"OPT",3367,1,3,0)
	;;=receivables which are due the Medical Center.  Many different
	;;^UTILITY(U,$J,"OPT",3367,1,4,0)
	;;=criteria may be specified to limit the selection of bills,
	;;^UTILITY(U,$J,"OPT",3367,1,5,0)
	;;=such as Rate Type, Inpt/Outpt, Treatment Dates, Bill Printed
	;;^UTILITY(U,$J,"OPT",3367,1,6,0)
	;;=Dates, and Insurance Company.  Any additional field may also
	;;^UTILITY(U,$J,"OPT",3367,1,7,0)
	;;=be selected and analyzed depending upon its content.
	;;^UTILITY(U,$J,"OPT",3367,25)
	;;=IBOTR
	;;^UTILITY(U,$J,"OPT",3367,"U")
	;;=INSURANCE PAYMENT TREND REPORT
	;;^UTILITY(U,$J,"OPT",3368,0)
	;;=IB OUTPT VISIT DATE INQUIRY^Outpatient Visit Date Inquiry^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3368,1,0)
	;;=^^5^5^2920106^
	;;^UTILITY(U,$J,"OPT",3368,1,1,0)
	;;=This option displays a billing record which covers a specified
	;;^UTILITY(U,$J,"OPT",3368,1,2,0)
	;;=outpatient visit.  The user may select any patient with billed
	;;^UTILITY(U,$J,"OPT",3368,1,3,0)
	;;=outpatient visits, and then the visit date in question.  The
	;;^UTILITY(U,$J,"OPT",3368,1,4,0)
	;;=option displays the same information as found in the Patient
	;;^UTILITY(U,$J,"OPT",3368,1,5,0)
	;;=Billing Inquiry.
	;;^UTILITY(U,$J,"OPT",3368,25)
	;;=IBCNQ1
	;;^UTILITY(U,$J,"OPT",3368,"U")
	;;=OUTPATIENT VISIT DATE INQUIRY
	;;^UTILITY(U,$J,"OPT",3369,0)
	;;=IB MT BILLING REPORT^Category C Billing Activity List^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3369,1,0)
	;;=^^2^2^2920226^^^^
	;;^UTILITY(U,$J,"OPT",3369,1,1,0)
	;;=This report is used to list all Means Test/Category C charges within a
	;;^UTILITY(U,$J,"OPT",3369,1,2,0)
	;;=user-specified date range.
	;;^UTILITY(U,$J,"OPT",3369,25)
	;;=IBOMTC
	;;^UTILITY(U,$J,"OPT",3369,"U")
	;;=CATEGORY C BILLING ACTIVITY LI
	;;^UTILITY(U,$J,"OPT",3370,0)
	;;=IB BASC PRINT A GROUP^Check off Sheet Print^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3370,1,0)
	;;=^^2^2^2920630^^^^
	;;^UTILITY(U,$J,"OPT",3370,1,1,0)
	;;=Print Check-Off Sheets by group.  Each group can be used for multiple clinics.
	;;^UTILITY(U,$J,"OPT",3370,1,2,0)
	;;=Report requires 132 columns.
	;;^UTILITY(U,$J,"OPT",3370,25)
	;;=IBERSP
	;;^UTILITY(U,$J,"OPT",3370,"U")
	;;=CHECK OFF SHEET PRINT
	;;^UTILITY(U,$J,"OPT",3372,0)
	;;=IB THIRD PARTY BILLING MENU^Third Party Billing Menu^^M^^^^^^^^INTEGRATED BILLING
