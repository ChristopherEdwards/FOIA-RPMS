IBINI0D8	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1237,1,2,0)
	;;=the form alignment in the printer may be checked.
	;;^UTILITY(U,$J,"OPT",1237,25)
	;;=IBCF1TP
	;;^UTILITY(U,$J,"OPT",1237,"U")
	;;=UB-82 TEST PATTERN PRINT
	;;^UTILITY(U,$J,"OPT",2248,0)
	;;=IB COPY AND CANCEL^Copy and Cancel^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2248,1,0)
	;;=^^2^2^2900306^^^^
	;;^UTILITY(U,$J,"OPT",2248,1,1,0)
	;;=This option will allow cancelling a bill and then will create an exact
	;;^UTILITY(U,$J,"OPT",2248,1,2,0)
	;;=duplicate bill except its status will be ENTERED/NOT REVIEWED.
	;;^UTILITY(U,$J,"OPT",2248,25)
	;;=IBCCC
	;;^UTILITY(U,$J,"OPT",2248,"U")
	;;=COPY AND CANCEL
	;;^UTILITY(U,$J,"OPT",2300,0)
	;;=IB LIST ALL BILLS FOR PAT.^List all Bills for a Patient^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2300,1,0)
	;;=^^1^1^2900427^
	;;^UTILITY(U,$J,"OPT",2300,1,1,0)
	;;=This option will print a list of all bills for one patient.
	;;^UTILITY(U,$J,"OPT",2300,25)
	;;=IBOA31
	;;^UTILITY(U,$J,"OPT",2300,"U")
	;;=LIST ALL BILLS FOR A PATIENT
	;;^UTILITY(U,$J,"OPT",2311,0)
	;;=IB BILLING RATES FILE^Enter/Edit Billing Rates^^R^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2311,1,0)
	;;=^^2^2^2940207^^^^
	;;^UTILITY(U,$J,"OPT",2311,1,1,0)
	;;=This option allows enter/edit of Billing Rates that will be used in the
	;;^UTILITY(U,$J,"OPT",2311,1,2,0)
	;;=automatic calculation of costs when preparing a third party bill.
	;;^UTILITY(U,$J,"OPT",2311,25)
	;;=IBEBR
	;;^UTILITY(U,$J,"OPT",2311,"U")
	;;=ENTER/EDIT BILLING RATES
	;;^UTILITY(U,$J,"OPT",2320,0)
	;;=IB RETURN BILL LIST^Returned Bill List^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2320,1,0)
	;;=^^3^3^2940207^^
	;;^UTILITY(U,$J,"OPT",2320,1,1,0)
	;;=This option will generate a list of bills returned by Accounts Receivable
	;;^UTILITY(U,$J,"OPT",2320,1,2,0)
	;;=to MCCR.  The output should be directed to a printer as this report may
	;;^UTILITY(U,$J,"OPT",2320,1,3,0)
	;;=take a few minutes to print.
	;;^UTILITY(U,$J,"OPT",2320,25)
	;;=RETN^PRCALST
	;;^UTILITY(U,$J,"OPT",2320,"U")
	;;=RETURNED BILL LIST
	;;^UTILITY(U,$J,"OPT",2321,0)
	;;=IB FAST ENTER BILLING RATES^Fast Enter of New Billing Rates^^R^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2321,1,0)
	;;=^^2^2^2900525^^
	;;^UTILITY(U,$J,"OPT",2321,1,1,0)
	;;=This option is designed to speed the entry of new billing rates  for
	;;^UTILITY(U,$J,"OPT",2321,1,2,0)
	;;=a fiscal year.
	;;^UTILITY(U,$J,"OPT",2321,25)
	;;=IBCBR
	;;^UTILITY(U,$J,"OPT",2321,"U")
	;;=FAST ENTER OF NEW BILLING RATE
	;;^UTILITY(U,$J,"OPT",2322,0)
	;;=IB LIST BILLS FOR EPISODE^Episode of Care Bill List^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2322,1,0)
	;;=^^1^1^2900529^^
	;;^UTILITY(U,$J,"OPT",2322,1,1,0)
	;;=This option will list all bills related to an episode of care
	;;^UTILITY(U,$J,"OPT",2322,25)
	;;=IBOBL
	;;^UTILITY(U,$J,"OPT",2322,"U")
	;;=EPISODE OF CARE BILL LIST
	;;^UTILITY(U,$J,"OPT",2324,0)
	;;=IB LIST OF BILLING RATES^Billing Rates List^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2324,1,0)
	;;=^^1^1^2920304^^^
	;;^UTILITY(U,$J,"OPT",2324,1,1,0)
	;;=This option will print a list of Billing Rates by Effective date.
	;;^UTILITY(U,$J,"OPT",2324,25)
	;;=IBORAT
	;;^UTILITY(U,$J,"OPT",2324,60)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,62)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,63)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,64)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,65)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,66)
	;;=
	;;^UTILITY(U,$J,"OPT",2324,"U")
	;;=BILLING RATES LIST
	;;^UTILITY(U,$J,"OPT",2328,0)
	;;=IB EDIT RETURNED BILL^Edit Returned Bill^^R^^IB EDIT^^^^^^INTEGRATED BILLING
