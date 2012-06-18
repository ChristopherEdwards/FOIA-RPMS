IBINI029	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,350.8,30,0)
	;;=IB NO CHARGE - BEDSECTION^Integrated Billing cannot find a charge for a specific bedsection.^IB030^1^1
	;;^UTILITY(U,$J,350.8,31,0)
	;;=IB NO MEDICARE ACTION TYPE^Integrated Billing cannot find an action type for the Medicare Deductible.^IB031^1^1
	;;^UTILITY(U,$J,350.8,32,0)
	;;=IB NO MEDICARE DEDUCTIBLE^Integrated Billing cannot find the Medicare Deductible for the given date.^IB032^1^1
	;;^UTILITY(U,$J,350.8,33,0)
	;;=IB INVALID CHARGES^Means Test charges have been calculated on and/or beyond the discharge date.^IB033^1^1
	;;^UTILITY(U,$J,350.8,34,0)
	;;=IB INVALID CYCLE^The billing cycle has been started after the billable event date.^IB034^1^1
	;;^UTILITY(U,$J,350.8,35,0)
	;;=IB NO CHARGE REMOVE REASON^Integrated Billing CHARGE REMOVE REASON is missing.^IB035^1^1
	;;^UTILITY(U,$J,350.8,36,0)
	;;=IB UNKNOWN IB ACTION TYPE^Unknown IB ACTION TYPE.^IB036^1^1
	;;^UTILITY(U,$J,350.8,37,0)
	;;=IB NO BILLABLE EVENT^Integrated Billing requires inpatient charges to relate to an admission.^IB037^1^1
	;;^UTILITY(U,$J,350.8,38,0)
	;;=IB NO FEE BASIS AMOUNT^Integrated Billing requires a dollar amount for fee basis charges.^IB038^1^1
	;;^UTILITY(U,$J,350.8,39,0)
	;;=IB NO BILLING DATE^Integrated Billing requires a date or date range for charges.^IB039^1^1
	;;^UTILITY(U,$J,350.8,40,0)
	;;=IB ALREADY NEW BILL^Bill is already in New Bill Status in A/R, can't send. Contact supervisor.^IB040^1^3
	;;^UTILITY(U,$J,350.8,41,0)
	;;=IB APPROVING USER^Approving User not in User file or Person file link missing.^IB041^1^3
	;;^UTILITY(U,$J,350.8,42,0)
	;;=IB ASC AND VISITS^Bill has Amb. Surg. Code and more than one visit date.^IB042^1^3
	;;^UTILITY(U,$J,350.8,43,0)
	;;=IB BAD BILL CLASSIFICATION^Bill Classification is missing or incorrect^IB043^1^3
	;;^UTILITY(U,$J,350.8,44,0)
	;;=IB BILL NUMBER^Bill Number is in an incorrect format. Contact supervisor.^IB044^1^3
	;;^UTILITY(U,$J,350.8,45,0)
	;;=IB BILL STATUS^Bill status is undetermined or inappropriate. Contact supervisor.^IB045^1^3
	;;^UTILITY(U,$J,350.8,46,0)
	;;=IB CROSSES CALENDAR YEAR^Bill dates start and end in different calendar years, must be in same year.^IB046^1^3
	;;^UTILITY(U,$J,350.8,47,0)
	;;=IB CROSSES FY^Bill dates start and end in different fiscal years, must be in same FY.^IB047^1^3
	;;^UTILITY(U,$J,350.8,48,0)
	;;=IB ENTERING USER^Entering User not in User file or Person file link missing.^IB048^1^3
	;;^UTILITY(U,$J,350.8,49,0)
	;;=IB EVENT DATE^Event Date is not defined or incorrect.^IB049^1^3
	;;^UTILITY(U,$J,350.8,50,0)
	;;=IB FISCAL YEAR ONE^Fiscal Year is not entered or inappropriate.^IB050^1^3
	;;^UTILITY(U,$J,350.8,51,0)
	;;=IB FY1 CHARGES^Charges for FY 1 are missing or zero.^IB051^1^3
	;;^UTILITY(U,$J,350.8,52,0)
	;;=IB FY1 MINUS OFFSET^FY 1 charges minus the offset less than or equal to zero.^IB052^1^3
	;;^UTILITY(U,$J,350.8,53,0)
	;;=IB INSTITUTION^Other listed as responsible but not in Institution field.^IB053^1^3
	;;^UTILITY(U,$J,350.8,54,0)
	;;=IB INSURER^Insurer listed as responsible but no Primary Insurance Carrier Selected.^IB054^1^3
	;;^UTILITY(U,$J,350.8,55,0)
	;;=IB LOC^Location of Care field is not entered or incorrect.^IB055^1^3
	;;^UTILITY(U,$J,350.8,56,0)
	;;=IB MISSING A/R RECORD^Accounts Receivable record is missing or has different bill number.^IB056^1^3
	;;^UTILITY(U,$J,350.8,57,0)
	;;=IB PATIENT^Patient not defined or Patient not in Patient file. Contact Supervisor.^IB057^1^3
	;;^UTILITY(U,$J,350.8,58,0)
	;;=IB RATE TO DEBTOR^Rate Type chosen expects different selection of Who's Responsible.^IB058^1^3
