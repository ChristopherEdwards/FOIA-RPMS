IBINI0DO	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3941,"U")
	;;=MEDICATION COPAY INCOME EXEMPT
	;;^UTILITY(U,$J,"OPT",3942,0)
	;;=IB RX HARDSHIP^Manually Change Copay Exemption (Hardships)^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",3942,1,0)
	;;=^^7^7^2930419^^
	;;^UTILITY(U,$J,"OPT",3942,1,1,0)
	;;=This option can be used to give a hardship waiver from the Medication
	;;^UTILITY(U,$J,"OPT",3942,1,2,0)
	;;=Copayment.  If a hardship is granted it will be good for one year from
	;;^UTILITY(U,$J,"OPT",3942,1,3,0)
	;;=the date of the hardship. 
	;;^UTILITY(U,$J,"OPT",3942,1,4,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3942,1,5,0)
	;;=This option can also be used to update a single patient's exemption to
	;;^UTILITY(U,$J,"OPT",3942,1,6,0)
	;;=the correct status as computed from his patient record, if the current
	;;^UTILITY(U,$J,"OPT",3942,1,7,0)
	;;=exemption does not match what is computed.
	;;^UTILITY(U,$J,"OPT",3942,25)
	;;=IBARXEX
	;;^UTILITY(U,$J,"OPT",3942,"U")
	;;=MANUALLY CHANGE COPAY EXEMPTIO
	;;^UTILITY(U,$J,"OPT",3943,0)
	;;=IB RX INQUIRE^Inquire to Medication Copay Income Exemptions^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3943,1,0)
	;;=^^2^2^2930122^
	;;^UTILITY(U,$J,"OPT",3943,1,1,0)
	;;=This option will allow a brief inquiry to active exemptions or a full
	;;^UTILITY(U,$J,"OPT",3943,1,2,0)
	;;=inquiry to the history of all exemptions for a patient.
	;;^UTILITY(U,$J,"OPT",3943,25)
	;;=IBARXEI
	;;^UTILITY(U,$J,"OPT",3943,"U")
	;;=INQUIRE TO MEDICATION COPAY IN
	;;^UTILITY(U,$J,"OPT",3944,0)
	;;=IB RX ADD THRESHOLDS^Add Income Thresholds^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3944,1,0)
	;;=^^2^2^2930120^
	;;^UTILITY(U,$J,"OPT",3944,1,1,0)
	;;=This option is used to add the Income Thresholds used in the Medication
	;;^UTILITY(U,$J,"OPT",3944,1,2,0)
	;;=Copayment Income Exemption.
	;;^UTILITY(U,$J,"OPT",3944,25)
	;;=ADD^IBARXET
	;;^UTILITY(U,$J,"OPT",3944,"U")
	;;=ADD INCOME THRESHOLDS
	;;^UTILITY(U,$J,"OPT",3945,0)
	;;=IB RX PRINT THRESHOLDS^List Income Thresholds^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3945,1,0)
	;;=^^3^3^2930120^
	;;^UTILITY(U,$J,"OPT",3945,1,1,0)
	;;=This option will print a listing of the Income Thresholds used in
	;;^UTILITY(U,$J,"OPT",3945,1,2,0)
	;;=the Medication Copayment Income Exemption process.  The output
	;;^UTILITY(U,$J,"OPT",3945,1,3,0)
	;;=is sorted by type of Threshold and Effective Date.  
	;;^UTILITY(U,$J,"OPT",3945,25)
	;;=PRINT^IBARXET
	;;^UTILITY(U,$J,"OPT",3945,"U")
	;;=LIST INCOME THRESHOLDS
	;;^UTILITY(U,$J,"OPT",3946,0)
	;;=IB RX PRINT PAT. EXEMP.^Print Patient Exemptions or summary^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3946,1,0)
	;;=^^5^5^2930323^^^^
	;;^UTILITY(U,$J,"OPT",3946,1,1,0)
	;;=This option can print a list of patients by exemption status
	;;^UTILITY(U,$J,"OPT",3946,1,2,0)
	;;=or exemption reason.  This will enable a facility to print a list 
	;;^UTILITY(U,$J,"OPT",3946,1,3,0)
	;;=of patients who are either exempt or non-exempt.  Optionally the 
	;;^UTILITY(U,$J,"OPT",3946,1,4,0)
	;;=report can print only sub totals without printing the detailed 
	;;^UTILITY(U,$J,"OPT",3946,1,5,0)
	;;=patient listing.
	;;^UTILITY(U,$J,"OPT",3946,25)
	;;=IBARXEP
	;;^UTILITY(U,$J,"OPT",3946,"U")
	;;=PRINT PATIENT EXEMPTIONS OR SU
	;;^UTILITY(U,$J,"OPT",3947,0)
	;;=IB RX PRINT RETRO CHARGES^Print Charges Canceled Due to Income Exemption^^R^^^^^^^^INCOME EXEMPTION PATCH
	;;^UTILITY(U,$J,"OPT",3947,1,0)
	;;=^^5^5^2930304^^
	;;^UTILITY(U,$J,"OPT",3947,1,1,0)
	;;=This report will print a list of patients and Medication Copayment
	;;^UTILITY(U,$J,"OPT",3947,1,2,0)
	;;=charges that have been canceled due to the income exclusion.  Initially
