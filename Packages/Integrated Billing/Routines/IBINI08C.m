IBINI08C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,15,1,3,0)
	;;=Data returned:
	;;^UTILITY(U,$J,357.6,15,1,4,0)
	;;=    insurance company
	;;^UTILITY(U,$J,357.6,15,1,5,0)
	;;=    policy number
	;;^UTILITY(U,$J,357.6,15,1,6,0)
	;;=    group name
	;;^UTILITY(U,$J,357.6,15,1,7,0)
	;;=    policy holder's relationship to the patient
	;;^UTILITY(U,$J,357.6,15,1,8,0)
	;;=    policy expiration date
	;;^UTILITY(U,$J,357.6,15,1,9,0)
	;;=    group number
	;;^UTILITY(U,$J,357.6,15,1,10,0)
	;;=    name of insured
	;;^UTILITY(U,$J,357.6,15,2)
	;;=INSURANCE COMPANY^30^EXPIRATION DATE^12^POLICY NUMBER^20^GROUP NUMBER^17^GROUP NAME^20^NAME OF INSURED^30^HOLDER'S RELATIONSHIP^9
	;;^UTILITY(U,$J,357.6,15,3)
	;;=PATIENT INSURANCE MAS PIMS
	;;^UTILITY(U,$J,357.6,15,4)
	;;=S ACT=2
	;;^UTILITY(U,$J,357.6,15,6,0)
	;;=^357.66^1^1
	;;^UTILITY(U,$J,357.6,15,6,1,0)
	;;=ACT
	;;^UTILITY(U,$J,357.6,15,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,15,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,16,0)
	;;=IBDF UTILITY FOR BLANK LINES^BLANKS^IBDFN^INTEGRATED BILLING^0^2^5^^1^^^1^^
	;;^UTILITY(U,$J,357.6,16,1,0)
	;;=^^2^2^2930408^^
	;;^UTILITY(U,$J,357.6,16,1,1,0)
	;;=No data is returned by this interface - it's purpose is to print blank
	;;^UTILITY(U,$J,357.6,16,1,2,0)
	;;=lines to the form for data entry.
	;;^UTILITY(U,$J,357.6,16,2)
	;;=^0
	;;^UTILITY(U,$J,357.6,16,3)
	;;=UTILITY BLANKS LINES
	;;^UTILITY(U,$J,357.6,17,0)
	;;=IBDF UTILITY FOR LABELS ONLY^LABELS^IBDFN^INTEGRATED BILLING^0^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,17,1,0)
	;;=^^2^2^2930210^^
	;;^UTILITY(U,$J,357.6,17,1,1,0)
	;;=This interface returns no data. Its purpose is to print labels without
	;;^UTILITY(U,$J,357.6,17,1,2,0)
	;;=data to the form.
	;;^UTILITY(U,$J,357.6,17,2)
	;;=Underscore Only^0
	;;^UTILITY(U,$J,357.6,17,3)
	;;=UTILITY BLANKS LABELS
	;;^UTILITY(U,$J,357.6,18,0)
	;;=GMP PATIENT ACTIVE PROBLEMS^ACTIVE^GMPLENFM^PROBLEM LIST^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,18,1,0)
	;;=^^8^8^2931015^^^^
	;;^UTILITY(U,$J,357.6,18,1,1,0)
	;;=For displaying the patient's active problems. Returns a list.
	;;^UTILITY(U,$J,357.6,18,1,2,0)
	;;=Data returned:
	;;^UTILITY(U,$J,357.6,18,1,3,0)
	;;=  problem text
	;;^UTILITY(U,$J,357.6,18,1,4,0)
	;;=  corresponding ICD-9 code (if there is a mapping)
	;;^UTILITY(U,$J,357.6,18,1,5,0)
	;;=  date of onset (MM/DD/YY)
	;;^UTILITY(U,$J,357.6,18,1,6,0)
	;;=  SC indicator (SC/NSC/"")
	;;^UTILITY(U,$J,357.6,18,1,7,0)
	;;=  special exposure (A/I/P/"")
	;;^UTILITY(U,$J,357.6,18,1,8,0)
	;;=  special exposure (returns the full text of the type of exposure)
	;;^UTILITY(U,$J,357.6,18,2)
	;;=PROBLEM TEXT^210^CORRESPONDNG ICD-9 Dx CODE^7^DATE OF ONSET (MM/DD/YY)^8^SC INDICATOR (SC/NSC/"")^3^SC INDICATOR (Y/N/"")^1^SPECIAL EXPOSURE (A/I/P/"")^1^SPECIAL EXPOSURE (FULL TEXT)^12^^^
	;;^UTILITY(U,$J,357.6,18,3)
	;;=ACTIVE PROBLEMS LIST PATIENT
	;;^UTILITY(U,$J,357.6,18,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,18,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,19,0)
	;;=DPT PATIENT'S EMPLOYER NAME^EMPLOYER^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,19,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,19,1,1,0)
	;;=For displaying the patient's employer.
	;;^UTILITY(U,$J,357.6,19,2)
	;;=employer name^45
	;;^UTILITY(U,$J,357.6,19,3)
	;;=PATIENT EMPLOYER MAS
	;;^UTILITY(U,$J,357.6,19,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,19,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,20,0)
	;;=DPT PATIENT'S EMPLOYER ADDRESS LINES^EMPLOYER^IBDFN2^PATIENT FILE^1^2^3^^1^^^1^^
	;;^UTILITY(U,$J,357.6,20,1,0)
	;;=^^3^3^2930217^
	;;^UTILITY(U,$J,357.6,20,1,1,0)
	;;=For displaying the patient's employer's address. The address is in the form
