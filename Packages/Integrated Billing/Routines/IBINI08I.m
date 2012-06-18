IBINI08I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,55,1,5,0)
	;;=  policy number
	;;^UTILITY(U,$J,357.6,55,1,6,0)
	;;=  group name
	;;^UTILITY(U,$J,357.6,55,1,7,0)
	;;=  policy holder's relationship to the patient
	;;^UTILITY(U,$J,357.6,55,1,8,0)
	;;=  policy expiration date
	;;^UTILITY(U,$J,357.6,55,1,9,0)
	;;=  group number
	;;^UTILITY(U,$J,357.6,55,1,10,0)
	;;=  name of insured
	;;^UTILITY(U,$J,357.6,55,2)
	;;=INSURANCE COMPANY^30^EXPIRATION DATE^12^POLICY NUMBER^20^GROUP NUMBER^17^GROUP NAME^20^NAME OF INSURED^30^HOLDER'S RELATIONSHIP^9
	;;^UTILITY(U,$J,357.6,55,3)
	;;=PATIENT INSURANCE MAS PIMS
	;;^UTILITY(U,$J,357.6,55,4)
	;;=S ACT=""
	;;^UTILITY(U,$J,357.6,55,6,0)
	;;=^357.66^1^1
	;;^UTILITY(U,$J,357.6,55,6,1,0)
	;;=ACT
	;;^UTILITY(U,$J,357.6,55,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,55,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,56,0)
	;;=DPT PATIENT'S INSURANCE - ACTIVE ONLY^INSURANC^IBDFN6^PATIENT FILE^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,357.6,56,1,0)
	;;=^^10^10^2931201^
	;;^UTILITY(U,$J,357.6,56,1,1,0)
	;;=For displaying information on the patient's health insurance. Returns ONLY
	;;^UTILITY(U,$J,357.6,56,1,2,0)
	;;=active insurance, excluding policies that do not reimburse.
	;;^UTILITY(U,$J,357.6,56,1,3,0)
	;;=Data returned:
	;;^UTILITY(U,$J,357.6,56,1,4,0)
	;;=  insurance company
	;;^UTILITY(U,$J,357.6,56,1,5,0)
	;;=  policy number
	;;^UTILITY(U,$J,357.6,56,1,6,0)
	;;=  group name
	;;^UTILITY(U,$J,357.6,56,1,7,0)
	;;=  policy holder's relationship to the patient
	;;^UTILITY(U,$J,357.6,56,1,8,0)
	;;=  policy expiration date
	;;^UTILITY(U,$J,357.6,56,1,9,0)
	;;=  group number
	;;^UTILITY(U,$J,357.6,56,1,10,0)
	;;=  name of insured
	;;^UTILITY(U,$J,357.6,56,2)
	;;=INSURANCE COMPANY^30^EXPIRATION DATE^12^POLICY NUMBER^20^GROUP NUMBER^17^GROUP NAME^20^NAME OF INSURED^30^HOLDER'S RELATIONSHIP^9
	;;^UTILITY(U,$J,357.6,56,3)
	;;=PATIENT INSURANCE MAS PIMS ACTIVE
	;;^UTILITY(U,$J,357.6,56,4)
	;;=S ACT=1
	;;^UTILITY(U,$J,357.6,56,6,0)
	;;=^357.66^1^1
	;;^UTILITY(U,$J,357.6,56,6,1,0)
	;;=ACT
	;;^UTILITY(U,$J,357.6,56,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,56,7,1,0)
	;;=DFN
