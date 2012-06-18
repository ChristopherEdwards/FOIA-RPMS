IBDEI01N	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6,19,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,358.6,19,1,1,0)
	;;=For displaying the employment status of the patient.
	;;^UTILITY(U,$J,358.6,19,2)
	;;=EMPLOYMENT STATUS^20
	;;^UTILITY(U,$J,358.6,19,3)
	;;=PATIENT EMPLOYER EMPLOYMENT MAS
	;;^UTILITY(U,$J,358.6,19,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,19,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,20,0)
	;;=DPT SPOUSE'S EMPLOYER NAME^SPSEMPLR^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,20,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,358.6,20,1,1,0)
	;;=For displaying the spouse's employer.
	;;^UTILITY(U,$J,358.6,20,2)
	;;=employer name^45
	;;^UTILITY(U,$J,358.6,20,3)
	;;=PATIENT SPOUSE EMPLOYER MAS
	;;^UTILITY(U,$J,358.6,20,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,20,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,21,0)
	;;=DG SELECT ICD-9 DIAGNOSIS CODES^ICD9^IBDFN4^MAS^^3^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,21,1,0)
	;;=^^3^3^2930126^
	;;^UTILITY(U,$J,358.6,21,1,1,0)
	;;=Allows the user to select ICD-9 diagnosis codes from the ICD Diagnosis file.
	;;^UTILITY(U,$J,358.6,21,1,2,0)
	;;=Allows the user to select from a particular Major Diagnosis Category if
	;;^UTILITY(U,$J,358.6,21,1,3,0)
	;;=desired. Allows only active codes to be selected.
	;;^UTILITY(U,$J,358.6,21,2)
	;;=CODE^7^DIAGNOSIS^30^DESCRIPTION^200^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,358.6,21,3)
	;;=SELECT ICD-9 CODES DX DIAGNOSIS
	;;^UTILITY(U,$J,358.6,22,0)
	;;=DPT PATIENT'S DOB/AGE^VADPT^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,22,1,0)
	;;=^^2^2^2930726^^
	;;^UTILITY(U,$J,358.6,22,1,1,0)
	;;=Patient's DOB in MMM DD, YYYY format
	;;^UTILITY(U,$J,358.6,22,1,2,0)
	;;=Patient's age in years.
	;;^UTILITY(U,$J,358.6,22,2)
	;;=Patient's DOB^12^Patient's Age^3
	;;^UTILITY(U,$J,358.6,22,3)
	;;=PATIENT DOB AGE MAS PIMS
	;;^UTILITY(U,$J,358.6,22,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,22,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,23,0)
	;;=DPT PATIENT'S SEX^VADPT^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,23,1,0)
	;;=^^1^1^2931015^^^^
	;;^UTILITY(U,$J,358.6,23,1,1,0)
	;;=Patient's sex, either 'MALE' or 'FEMALE', or "M" or "F".
	;;^UTILITY(U,$J,358.6,23,2)
	;;=Patient's Sex^6^Patient's Sex (Code)^1
	;;^UTILITY(U,$J,358.6,23,3)
	;;=PATIENT SEX MAS
	;;^UTILITY(U,$J,358.6,23,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,23,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,24,0)
	;;=DPT PATIENT'S MEANS TEST DATA^MT^IBDFN2^MAS^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,24,1,0)
	;;=^^5^5^2931015^^^
	;;^UTILITY(U,$J,358.6,24,1,1,0)
	;;=Returns the patient's current means test category and the date of the most
	;;^UTILITY(U,$J,358.6,24,1,2,0)
	;;=recent means test. Data returned:
	;;^UTILITY(U,$J,358.6,24,1,3,0)
	;;=  means test category
	;;^UTILITY(U,$J,358.6,24,1,4,0)
	;;=  means test code
	;;^UTILITY(U,$J,358.6,24,1,5,0)
	;;=  date of last means test
	;;^UTILITY(U,$J,358.6,24,2)
	;;=MEANS TEST CATEGORY^20^DATE OF LAST MEANS TEST^12^MEANS TEST CODE^1
	;;^UTILITY(U,$J,358.6,24,3)
	;;=MEANS TEST CATEGORY PATIENT MAS
	;;^UTILITY(U,$J,358.6,24,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,24,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,25,0)
	;;=DPT SERVICE HISTORY RELATED DATA^ELIG^IBDFN^PATIENT FILE^1^2^2^0^1^^^1^^
	;;^UTILITY(U,$J,358.6,25,1,0)
	;;=^^7^7^2931015^^^^
	;;^UTILITY(U,$J,358.6,25,1,1,0)
	;;=For displaying service history data. Data returned:
	;;^UTILITY(U,$J,358.6,25,1,2,0)
	;;=  Vietnam service? YES/NO
	;;^UTILITY(U,$J,358.6,25,1,3,0)
	;;=  Agent Orange exposure? YES/NO
	;;^UTILITY(U,$J,358.6,25,1,4,0)
	;;=  radiation exposure? YES/NO
	;;^UTILITY(U,$J,358.6,25,1,5,0)
	;;=  combat service? YES/NO
