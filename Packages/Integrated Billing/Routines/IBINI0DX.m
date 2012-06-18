IBINI0DX	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4144,1,2,0)
	;;=Claims Tracking Module.
	;;^UTILITY(U,$J,"OPT",4144,25)
	;;=IBTRP
	;;^UTILITY(U,$J,"OPT",4144,"U")
	;;=CLAIMS TRACKING PARAMETER EDIT
	;;^UTILITY(U,$J,"OPT",4145,0)
	;;=IBT EDIT REVIEWS TO DO^Pending Reviews^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4145,1,0)
	;;=^^7^7^2940307^^^^
	;;^UTILITY(U,$J,"OPT",4145,1,1,0)
	;;=This option will list all reviews that have a next review date in the
	;;^UTILITY(U,$J,"OPT",4145,1,2,0)
	;;=past seven days.  All screens and actions necessary to complete the 
	;;^UTILITY(U,$J,"OPT",4145,1,3,0)
	;;=pending reviews are available from within this option.  You may also
	;;^UTILITY(U,$J,"OPT",4145,1,4,0)
	;;=select a different date range of pending reviews if desired.
	;;^UTILITY(U,$J,"OPT",4145,1,5,0)
	;;=Both Hospital and Insurance reviews can be accessed with this option.
	;;^UTILITY(U,$J,"OPT",4145,1,6,0)
	;;=Many pending reviews may have automatically been created by the computer 
	;;^UTILITY(U,$J,"OPT",4145,1,7,0)
	;;=when a patient is admitted.
	;;^UTILITY(U,$J,"OPT",4145,20)
	;;=S IBTRPRF=12 D ^IBTRPR K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4145,99)
	;;=55774,51555
	;;^UTILITY(U,$J,"OPT",4145,"U")
	;;=PENDING REVIEWS
	;;^UTILITY(U,$J,"OPT",4146,0)
	;;=IBT OUTPUT DENIED DAYS REPORT^Days Denied Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4146,1,0)
	;;=^^2^2^2931104^
	;;^UTILITY(U,$J,"OPT",4146,1,1,0)
	;;=This option prints a summary of days denied by insurance company for a
	;;^UTILITY(U,$J,"OPT",4146,1,2,0)
	;;=user specified date range.  A summary report by service is also generated.
	;;^UTILITY(U,$J,"OPT",4146,25)
	;;=IBTODD
	;;^UTILITY(U,$J,"OPT",4146,"U")
	;;=DAYS DENIED REPORT
	;;^UTILITY(U,$J,"OPT",4147,0)
	;;=IBT OUTPUT UR ACTIVITY REPORT^UR Activity Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4147,1,0)
	;;=^^2^2^2931110^^
	;;^UTILITY(U,$J,"OPT",4147,1,1,0)
	;;=This option prints by clinical service, information about the mccr/ur
	;;^UTILITY(U,$J,"OPT",4147,1,2,0)
	;;=activity.
	;;^UTILITY(U,$J,"OPT",4147,25)
	;;=IBTOUR
	;;^UTILITY(U,$J,"OPT",4147,"U")
	;;=UR ACTIVITY REPORT
	;;^UTILITY(U,$J,"OPT",4148,0)
	;;=IBT OUTPUT SCHED ADM W/INS^Scheduled Admissions w/Insurance^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4148,1,0)
	;;=^^4^4^2940307^^^
	;;^UTILITY(U,$J,"OPT",4148,1,1,0)
	;;=This option will print a list of Admission that are scheduled but
	;;^UTILITY(U,$J,"OPT",4148,1,2,0)
	;;=not admitted and/or scheduled admissions that have been admitted.
	;;^UTILITY(U,$J,"OPT",4148,1,3,0)
	;;=All admissions must be for patients who were insured on their admission
	;;^UTILITY(U,$J,"OPT",4148,1,4,0)
	;;=date.
	;;^UTILITY(U,$J,"OPT",4148,25)
	;;=IBTOSA
	;;^UTILITY(U,$J,"OPT",4148,"U")
	;;=SCHEDULED ADMISSIONS W/INSURAN
	;;^UTILITY(U,$J,"OPT",4149,0)
	;;=IBT OUTPUT UNSCHE ADM W/INS^Unscheduled Admissions w/Insurance^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4149,1,0)
	;;=^^2^2^2940207^^
	;;^UTILITY(U,$J,"OPT",4149,1,1,0)
	;;=This option will print a list of patients who were insured on their
	;;^UTILITY(U,$J,"OPT",4149,1,2,0)
	;;=admission date but were not scheduled admissions.
	;;^UTILITY(U,$J,"OPT",4149,25)
	;;=IBTOUA
	;;^UTILITY(U,$J,"OPT",4149,"U")
	;;=UNSCHEDULED ADMISSIONS W/INSUR
	;;^UTILITY(U,$J,"OPT",4150,0)
	;;=IBT OUTPUT MCCR/UR SUMMARY^MCCR/UR Summary Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4150,1,0)
	;;=^^6^6^2940214^^^
	;;^UTILITY(U,$J,"OPT",4150,1,1,0)
	;;=This report can be run for either admissions or discharges for a
