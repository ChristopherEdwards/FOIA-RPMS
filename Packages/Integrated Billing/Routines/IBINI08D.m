IBINI08D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,20,1,2,0)
	;;=of a list of address lines each up to 30 characters long. The number of lines
	;;^UTILITY(U,$J,357.6,20,1,3,0)
	;;=is variable, up to 4.
	;;^UTILITY(U,$J,357.6,20,2)
	;;=ADDRESS LINE^45
	;;^UTILITY(U,$J,357.6,20,3)
	;;=PATIENT EMPLOYER ADDRESS MAS
	;;^UTILITY(U,$J,357.6,20,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,20,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,21,0)
	;;=DPT PATIENT'S EMPLOYER TELEPHONE^EMPLOYER^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,21,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,21,1,1,0)
	;;=For displaying the patient's employer's telephone number.
	;;^UTILITY(U,$J,357.6,21,2)
	;;=telephone number^20
	;;^UTILITY(U,$J,357.6,21,3)
	;;=PATIENT EMPLOYER TELEPHONE MAS
	;;^UTILITY(U,$J,357.6,21,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,21,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,22,0)
	;;=DPT SPOUSE'S EMPLOYER NAME^SPSEMPLR^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,22,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,22,1,1,0)
	;;=For displaying the spouse's employer.
	;;^UTILITY(U,$J,357.6,22,2)
	;;=employer name^45
	;;^UTILITY(U,$J,357.6,22,3)
	;;=PATIENT SPOUSE EMPLOYER MAS
	;;^UTILITY(U,$J,357.6,22,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,22,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,23,0)
	;;=DPT SPOUSE'S EMPLOYER ADDRESS LINES^SPSEMPLR^IBDFN2^PATIENT FILE^1^2^4^^1^^^1^^
	;;^UTILITY(U,$J,357.6,23,1,0)
	;;=^^3^3^2930217^
	;;^UTILITY(U,$J,357.6,23,1,1,0)
	;;=For displaying the patient's spouse's employer's address. The address is in the form
	;;^UTILITY(U,$J,357.6,23,1,2,0)
	;;=of a list of address liness each up to 30 characters long. The number of line
	;;^UTILITY(U,$J,357.6,23,1,3,0)
	;;=is variable, up to 4.
	;;^UTILITY(U,$J,357.6,23,2)
	;;=address line^45
	;;^UTILITY(U,$J,357.6,23,3)
	;;=PATIENT SPOUSE EMPLOYER ADDRESS MAS
	;;^UTILITY(U,$J,357.6,23,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,23,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,24,0)
	;;=DPT SPOUSE'S EMPLOYER TELEPHONE^SPSEMPLR^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,24,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,24,1,1,0)
	;;=For displaying the telephone number of the spouse's employer.
	;;^UTILITY(U,$J,357.6,24,2)
	;;=telephone number^20
	;;^UTILITY(U,$J,357.6,24,3)
	;;=PATIENT SPOUSE EMPLOYER TELEPHONE MAS
	;;^UTILITY(U,$J,357.6,24,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,24,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,25,0)
	;;=DPT PATIENT'S MARITAL STATUS^VADPT^IBDFN^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,25,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,25,1,1,0)
	;;=For displaying the patient's marital status.
	;;^UTILITY(U,$J,357.6,25,2)
	;;=MARITAL STATUS^15
	;;^UTILITY(U,$J,357.6,25,3)
	;;=PATIENT MARITAL STATUS MAS
	;;^UTILITY(U,$J,357.6,25,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,25,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,26,0)
	;;=DPT PATIENT'S EMPLOYMENT STATUS^EMPLMNT^IBDFN^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,26,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,357.6,26,1,1,0)
	;;=For displaying the employment status of the patient.
	;;^UTILITY(U,$J,357.6,26,2)
	;;=EMPLOYMENT STATUS^20
	;;^UTILITY(U,$J,357.6,26,3)
	;;=PATIENT EMPLOYER EMPLOYMENT MAS
	;;^UTILITY(U,$J,357.6,26,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,26,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,27,0)
	;;=SD CLINIC NAME^CLINIC^IBDFN1^SCHEDULING^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,27,1,0)
	;;=^^2^2^2930616^^
	;;^UTILITY(U,$J,357.6,27,1,1,0)
	;;= 
	;;^UTILITY(U,$J,357.6,27,1,2,0)
	;;=Outputs the name of the clinic.
	;;^UTILITY(U,$J,357.6,27,2)
	;;=CLINIC NAME^30
