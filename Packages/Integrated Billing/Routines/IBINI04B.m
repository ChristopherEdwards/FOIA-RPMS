IBINI04B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(354.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,354.6)
	;;=^IBE(354.6,
	;;^UTILITY(U,$J,354.6,0)
	;;=IB FORM LETTER^354.6^1^1
	;;^UTILITY(U,$J,354.6,1,0)
	;;=IB NOW EXEMPT^Initial letter of Copay Exemption^1^15
	;;^UTILITY(U,$J,354.6,1,1,0)
	;;=^^25^25^2930512^^^^
	;;^UTILITY(U,$J,354.6,1,1,1,0)
	;;=Public Law 102-568 enacted on October 29, 1992, provided for an exemption
	;;^UTILITY(U,$J,354.6,1,1,2,0)
	;;=to the prescription copayment for those veterans who had income levels
	;;^UTILITY(U,$J,354.6,1,1,3,0)
	;;=less than the maximum rate of VA pension.  Charges established before 
	;;^UTILITY(U,$J,354.6,1,1,4,0)
	;;=October 29, 1992, were not exempted by the legislation.
	;;^UTILITY(U,$J,354.6,1,1,5,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,6,0)
	;;=We have reviewed your income and eligibility information contained in our
	;;^UTILITY(U,$J,354.6,1,1,7,0)
	;;=records and determined that you are eligible for the exemption.  We are 
	;;^UTILITY(U,$J,354.6,1,1,8,0)
	;;=currently reviewing your account and will make the appropriate adjustments
	;;^UTILITY(U,$J,354.6,1,1,9,0)
	;;=to it in the near future.  If you are eligible for a refund for payments
	;;^UTILITY(U,$J,354.6,1,1,10,0)
	;;=made on charges established since October 29, 1992, we will forward you a 
	;;^UTILITY(U,$J,354.6,1,1,11,0)
	;;=check.  While we are reviewing your account we will not be sending out a 
	;;^UTILITY(U,$J,354.6,1,1,12,0)
	;;=statement.
	;;^UTILITY(U,$J,354.6,1,1,13,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,14,0)
	;;=Medication copayment exemptions based upon annual income must be 
	;;^UTILITY(U,$J,354.6,1,1,15,0)
	;;=re-evaluated yearly on the anniversary of your means test or copayment 
	;;^UTILITY(U,$J,354.6,1,1,16,0)
	;;=test.  If a renewal date is shown below the 'in reply' heading you must 
	;;^UTILITY(U,$J,354.6,1,1,17,0)
	;;=complete a new copay income test by that date or you will no longer be 
	;;^UTILITY(U,$J,354.6,1,1,18,0)
	;;=considered exempt from the pharmacy copayment requirement.
	;;^UTILITY(U,$J,354.6,1,1,19,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,20,0)
	;;=Please do not send in any more payments until we have completed this review
	;;^UTILITY(U,$J,354.6,1,1,21,0)
	;;=and forwarded a statement to you.
	;;^UTILITY(U,$J,354.6,1,1,22,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,23,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,24,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,1,25,0)
	;;=FINANCE OFFICER
	;;^UTILITY(U,$J,354.6,1,2,0)
	;;=^^6^6^2930512^^^^
	;;^UTILITY(U,$J,354.6,1,2,1,0)
	;;=Department of Veterans Affairs Medical Center
	;;^UTILITY(U,$J,354.6,1,2,2,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,2,3,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,2,4,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,2,5,0)
	;;= 
	;;^UTILITY(U,$J,354.6,1,2,6,0)
	;;= 
