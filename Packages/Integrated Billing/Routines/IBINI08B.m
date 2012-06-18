IBINI08B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,8,2)
	;;=Disability Name^45^Disability % (number only)^3^Disability % (label=%)^4^Disabilty % (label=%SC)^6^Dis.%_"% - SERVICE CONNECTED"^24
	;;^UTILITY(U,$J,357.6,8,3)
	;;=CONDITIONS PATIENT MAS PIMS DISABILITY DISABILITIES
	;;^UTILITY(U,$J,357.6,8,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,8,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,9,0)
	;;=DG SELECT ICD-9 DIAGNOSIS CODES^ICD9^IBDFN4^MAS^^3^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,9,1,0)
	;;=^^3^3^2930126^
	;;^UTILITY(U,$J,357.6,9,1,1,0)
	;;=Allows the user to select ICD-9 diagnosis codes from the ICD Diagnosis file.
	;;^UTILITY(U,$J,357.6,9,1,2,0)
	;;=Allows the user to select from a particular Major Diagnosis Category if
	;;^UTILITY(U,$J,357.6,9,1,3,0)
	;;=desired. Allows only active codes to be selected.
	;;^UTILITY(U,$J,357.6,9,2)
	;;=CODE^7^DIAGNOSIS^30^DESCRIPTION^200^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,357.6,9,3)
	;;=SELECT ICD-9 CODES DX DIAGNOSIS
	;;^UTILITY(U,$J,357.6,10,0)
	;;=DPT PATIENT'S PID^VADPT^IBDFN^PATIENT FILE^1^2^1^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,10,1,0)
	;;=^^1^1^2931015^^
	;;^UTILITY(U,$J,357.6,10,1,1,0)
	;;=Used to display the patient identifier.
	;;^UTILITY(U,$J,357.6,10,2)
	;;=PATIENT IDENTIFIER^15
	;;^UTILITY(U,$J,357.6,10,3)
	;;=PATIENT PID MAS
	;;^UTILITY(U,$J,357.6,10,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,10,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,11,0)
	;;=IBDF UTILITY FOR SELECTING BLANKS^NULL^IBDFN4^INTEGRATED BILLING^^3^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,11,1,0)
	;;=^^2^2^2930414^^^^
	;;^UTILITY(U,$J,357.6,11,1,1,0)
	;;=No data is returned, so this interface allows the user to create a
	;;^UTILITY(U,$J,357.6,11,1,2,0)
	;;=selection list with what ever text he desires.
	;;^UTILITY(U,$J,357.6,11,2)
	;;=Enter Anything!^0^^^^^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,357.6,11,3)
	;;=UTILITY SELECT NULL BLANKS
	;;^UTILITY(U,$J,357.6,12,0)
	;;=DPT PATIENT ADDRESS LINES^ADDRESS^IBDFN6^PATIENT FILE^1^2^3^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,12,1,0)
	;;=^^1^1^2930128^
	;;^UTILITY(U,$J,357.6,12,1,1,0)
	;;=Outputs the patient's address, up to 4 lines of 45 characters each.
	;;^UTILITY(U,$J,357.6,12,2)
	;;=ADDRESS LINE^45
	;;^UTILITY(U,$J,357.6,12,3)
	;;=PATIENT ADDRESS MAS
	;;^UTILITY(U,$J,357.6,12,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,12,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,13,0)
	;;=DPT PATIENT'S TELEPHONE NUMBER^ADDRESS^IBDFN6^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,13,1,0)
	;;=^^1^1^2930217^^
	;;^UTILITY(U,$J,357.6,13,1,1,0)
	;;=Used to display the patient's telephone number.
	;;^UTILITY(U,$J,357.6,13,2)
	;;=TELEPHONE NUMBER^20
	;;^UTILITY(U,$J,357.6,13,3)
	;;=PATIENT TELEPHONE MAS
	;;^UTILITY(U,$J,357.6,13,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,13,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,14,0)
	;;=DPT IS PATIENT INSURED?^INSURED^IBDFN6^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,357.6,14,1,0)
	;;=^^2^2^2931130^^^^
	;;^UTILITY(U,$J,357.6,14,1,1,0)
	;;=Prints 'YES','NO', or 'UNKNOWN' based on the field COVERED BY INSURANCE?
	;;^UTILITY(U,$J,357.6,14,1,2,0)
	;;=from the patient file.
	;;^UTILITY(U,$J,357.6,14,2)
	;;=Covered by Ins?^7
	;;^UTILITY(U,$J,357.6,14,3)
	;;=PATIENT INSURANCE MAS
	;;^UTILITY(U,$J,357.6,14,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,14,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,15,0)
	;;=DPT PATIENT'S INSURANCE POLICIES^INSURANC^IBDFN6^PATIENT FILE^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,15,1,0)
	;;=^^10^10^2931201^
	;;^UTILITY(U,$J,357.6,15,1,1,0)
	;;=For displaying information on the patient's health insurance. Returns
	;;^UTILITY(U,$J,357.6,15,1,2,0)
	;;=active insurance policies and policies that do not reimburse (Medicare).
