IBINI0E5	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4246,1,2,0)
	;;=been verified.  Run this report and then use the Patient Insurance Info
	;;^UTILITY(U,$J,"OPT",4246,1,3,0)
	;;=View/Edit option and choose the Verify Coverage action to verify 
	;;^UTILITY(U,$J,"OPT",4246,1,4,0)
	;;=coverage for individual patients.
	;;^UTILITY(U,$J,"OPT",4246,25)
	;;=IBCOC1
	;;^UTILITY(U,$J,"OPT",4246,"U")
	;;=LIST NEW NOT VERIFIED POLICIES
	;;^UTILITY(U,$J,"OPT",4461,0)
	;;=IB PRINT BILL ADDENDUM^Print Bill Addendum Sheet^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4461,1,0)
	;;=^^3^3^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4461,1,1,0)
	;;=Prints the Addendum sheets that may accompany HCFA 1500 Rx Refill or
	;;^UTILITY(U,$J,"OPT",4461,1,2,0)
	;;=Prosthetics bills.  The addendum contains information that could not
	;;^UTILITY(U,$J,"OPT",4461,1,3,0)
	;;=fit on the bill form.
	;;^UTILITY(U,$J,"OPT",4461,25)
	;;=IBCF4
	;;^UTILITY(U,$J,"OPT",4461,"U")
	;;=PRINT BILL ADDENDUM SHEET
	;;^UTILITY(U,$J,"OPT",4462,0)
	;;=IB BATCH PRINT BILLS^Print Authorized Bills^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4462,1,0)
	;;=^^1^1^2940119^
	;;^UTILITY(U,$J,"OPT",4462,1,1,0)
	;;=Queues all authorized bills to print in user specified order.
	;;^UTILITY(U,$J,"OPT",4462,25)
	;;=IBCFP
	;;^UTILITY(U,$J,"OPT",4462,"U")
	;;=PRINT AUTHORIZED BILLS
	;;^UTILITY(U,$J,"OPT",4512,0)
	;;=IBT OUTPUT LIST VISITS^List Visits Requiring Reviews^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4512,1,0)
	;;=^^8^8^2940124^^^^
	;;^UTILITY(U,$J,"OPT",4512,1,1,0)
	;;=This option will print a list of visits that require either an insurance
	;;^UTILITY(U,$J,"OPT",4512,1,2,0)
	;;=review, hospital review or both.  In addition only visits that are
	;;^UTILITY(U,$J,"OPT",4512,1,3,0)
	;;=admissions may be printed.   The user may select the date range of visits
	;;^UTILITY(U,$J,"OPT",4512,1,4,0)
	;;=to print.
	;;^UTILITY(U,$J,"OPT",4512,1,5,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4512,1,6,0)
	;;=This option can be used to list the Random Sample cases being tracked
	;;^UTILITY(U,$J,"OPT",4512,1,7,0)
	;;=for Hospital Reviews by answering the prompts that only hospital reviews for
	;;^UTILITY(U,$J,"OPT",4512,1,8,0)
	;;=admissions are wanted.
	;;^UTILITY(U,$J,"OPT",4512,25)
	;;=IBTOLR
	;;^UTILITY(U,$J,"OPT",4512,"U")
	;;=LIST VISITS REQUIRING REVIEWS
	;;^UTILITY(U,$J,"OR",200,0)
	;;=200^IB^^OTHER HOSPITAL SERVICES^
	;;^UTILITY(U,$J,"OR",200,1,0)
	;;=^100.9951PA^42^15
	;;^UTILITY(U,$J,"OR",200,1,1,0)
	;;=IB CATEGORY C BILLING
	;;^UTILITY(U,$J,"OR",200,1,1,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,1,1,1,0)
	;;=DGPM MOVEMENT EVENTS
	;;^UTILITY(U,$J,"OR",200,1,2,0)
	;;=IB MEANS TEST EVENT
	;;^UTILITY(U,$J,"OR",200,1,2,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,2,1,1,0)
	;;=DG MEANS TEST EVENTS
	;;^UTILITY(U,$J,"OR",200,1,3,0)
	;;=IBACM ADD CHARGE
	;;^UTILITY(U,$J,"OR",200,1,3,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,3,1,1,0)
	;;=IBACM1 MENU
	;;^UTILITY(U,$J,"OR",200,1,4,0)
	;;=IBACM ADD CHARGE ONE
	;;^UTILITY(U,$J,"OR",200,1,4,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,4,1,1,0)
	;;=IBACM ADD CHARGE
	;;^UTILITY(U,$J,"OR",200,1,17,0)
	;;=IBACM CANCEL CHARGE
	;;^UTILITY(U,$J,"OR",200,1,17,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,17,1,1,0)
	;;=IBACM1 MENU
	;;^UTILITY(U,$J,"OR",200,1,18,0)
	;;=IBACM CANCEL CHARGE ONE
	;;^UTILITY(U,$J,"OR",200,1,18,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,18,1,1,0)
	;;=IBACM CANCEL CHARGE
	;;^UTILITY(U,$J,"OR",200,1,21,0)
	;;=IBACM OP LINK
	;;^UTILITY(U,$J,"OR",200,1,21,1,0)
	;;=^100.99511PA^1^1
	;;^UTILITY(U,$J,"OR",200,1,21,1,1,0)
	;;=SDAM APPOINTMENT EVENTS
