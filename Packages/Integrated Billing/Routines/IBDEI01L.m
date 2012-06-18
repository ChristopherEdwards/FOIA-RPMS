IBDEI01L	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6,8,1,3,0)
	;;=   period of service
	;;^UTILITY(U,$J,358.6,8,1,4,0)
	;;=   service connected? YES/NO
	;;^UTILITY(U,$J,358.6,8,1,5,0)
	;;=   veteran? YES/NO
	;;^UTILITY(U,$J,358.6,8,1,6,0)
	;;=   eligible for care? YES/NO
	;;^UTILITY(U,$J,358.6,8,1,7,0)
	;;=   type of patient
	;;^UTILITY(U,$J,358.6,8,1,8,0)
	;;=   SC%
	;;^UTILITY(U,$J,358.6,8,2)
	;;=ELIGIBILTY CODE/EXTERNAL FORM^30^PERIOD OF SERVICE^25^SERVICE CONNECTED?^3^VETERAN?^3^ELIGIBLE FOR CARE?^3^TYPE OF PATIENT^20^SC %^3
	;;^UTILITY(U,$J,358.6,8,3)
	;;=ELIGIBLE ELIGIBILITY PATIENT PERIOD SERVICE CONNECTED VETERAN STATUS
	;;^UTILITY(U,$J,358.6,8,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,8,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,9,0)
	;;=DPT PATIENT ADDRESS LINES^ADDRESS^IBDFN6^PATIENT FILE^1^2^3^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,9,1,0)
	;;=^^1^1^2930128^
	;;^UTILITY(U,$J,358.6,9,1,1,0)
	;;=Outputs the patient's address, up to 4 lines of 45 characters each.
	;;^UTILITY(U,$J,358.6,9,2)
	;;=ADDRESS LINE^45
	;;^UTILITY(U,$J,358.6,9,3)
	;;=PATIENT ADDRESS MAS
	;;^UTILITY(U,$J,358.6,9,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,9,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,10,0)
	;;=IB CURRENT DATE^NOW^IBDFN2^INTEGRATED BILLING^1^2^1^0^1^^^1^^
	;;^UTILITY(U,$J,358.6,10,1,0)
	;;=^^1^1^2930528^^
	;;^UTILITY(U,$J,358.6,10,1,1,0)
	;;=Prints the current date in MMM DD,YYYY format.
	;;^UTILITY(U,$J,358.6,10,2)
	;;=CURRENT DATE (MMM DD, YYYY)^12
	;;^UTILITY(U,$J,358.6,10,3)
	;;=TODAY CURRENT DATE DAY
	;;^UTILITY(U,$J,358.6,11,0)
	;;=DPT PATIENT'S SC CONDITIONS^ELIG^IBDFN^PATIENT FILE^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,11,1,0)
	;;=^^7^7^2931015^^^^
	;;^UTILITY(U,$J,358.6,11,1,1,0)
	;;=Used to output a list of the patients service connected conditons, along with
	;;^UTILITY(U,$J,358.6,11,1,2,0)
	;;=the percentage ratings. Data returned:
	;;^UTILITY(U,$J,358.6,11,1,3,0)
	;;=  disability name
	;;^UTILITY(U,$J,358.6,11,1,4,0)
	;;=  disability percentage
	;;^UTILITY(U,$J,358.6,11,1,5,0)
	;;=  disability percentage with the label "%"
	;;^UTILITY(U,$J,358.6,11,1,6,0)
	;;=  disabilty percentage with the label "%SC"
	;;^UTILITY(U,$J,358.6,11,1,7,0)
	;;=  disability percentage with the label "% - SERVICE CONNECTED"
	;;^UTILITY(U,$J,358.6,11,2)
	;;=Disability Name^45^Disability % (number only)^3^Disability % (label=%)^4^Disabilty % (label=%SC)^6^Dis.%_"% - SERVICE CONNECTED"^24
	;;^UTILITY(U,$J,358.6,11,3)
	;;=CONDITIONS PATIENT MAS PIMS DISABILITY DISABILITIES
	;;^UTILITY(U,$J,358.6,11,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,11,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,12,0)
	;;=DPT IS PATIENT INSURED?^INSURED^IBDFN6^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,12,1,0)
	;;=^^2^2^2931130^^^^
	;;^UTILITY(U,$J,358.6,12,1,1,0)
	;;=Prints 'YES','NO', or 'UNKNOWN' based on the field COVERED BY INSURANCE?
	;;^UTILITY(U,$J,358.6,12,1,2,0)
	;;=from the patient file.
	;;^UTILITY(U,$J,358.6,12,2)
	;;=Covered by Ins?^7
	;;^UTILITY(U,$J,358.6,12,3)
	;;=PATIENT INSURANCE MAS
	;;^UTILITY(U,$J,358.6,12,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,12,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,13,0)
	;;=DPT PATIENT'S INSURANCE POLICIES^INSURANC^IBDFN6^PATIENT FILE^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,13,1,0)
	;;=^^10^10^2931201^
	;;^UTILITY(U,$J,358.6,13,1,1,0)
	;;=For displaying information on the patient's health insurance. Returns
	;;^UTILITY(U,$J,358.6,13,1,2,0)
	;;=active insurance policies and policies that do not reimburse (Medicare).
	;;^UTILITY(U,$J,358.6,13,1,3,0)
	;;=Data returned:
	;;^UTILITY(U,$J,358.6,13,1,4,0)
	;;=    insurance company
