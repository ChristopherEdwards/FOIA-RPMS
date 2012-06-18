IBDEI01O	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6,25,1,6,0)
	;;=  POW? YES/NO
	;;^UTILITY(U,$J,358.6,25,1,7,0)
	;;=  environmental contaminants exposure? YES/NO
	;;^UTILITY(U,$J,358.6,25,2)
	;;=VIETNAM SERVICE?^3^AGENT ORANGE EXPOSURE?^3^RADIATION EXPOSURE?^3^POW?^3^COMBAT SERVICE?^3^ENVIRONMENTAL CONTAMINANTS?^3
	;;^UTILITY(U,$J,358.6,25,3)
	;;=PATIENT MAS VIETNAM SERVICE AGENT ORANGE RADIATION COMBAT POW HISTORY ENVIRONMENTAL CONTAMINANT PERSIAN
	;;^UTILITY(U,$J,358.6,25,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,25,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,26,0)
	;;=DPT SC TREATMENT QUESTIONS^ELIG^IBDFN^PATIENT FILE^1^2^2^0^1^^^1
	;;^UTILITY(U,$J,358.6,26,1,0)
	;;=^^8^8^2931018^^^^
	;;^UTILITY(U,$J,358.6,26,1,1,0)
	;;=Prints questions concerning whether treatment was related to service.
	;;^UTILITY(U,$J,358.6,26,1,2,0)
	;;=Each question is printed only if it applies to the patient. Questions are:
	;;^UTILITY(U,$J,358.6,26,1,3,0)
	;;= 
	;;^UTILITY(U,$J,358.6,26,1,4,0)
	;;=Was treatment for a SC condition? __ YES __ NO
	;;^UTILITY(U,$J,358.6,26,1,5,0)
	;;=Was treatment related to exposure to Agent Orange? __ YES __ NO
	;;^UTILITY(U,$J,358.6,26,1,6,0)
	;;=Was treatment related to exposure to Ionization Radiation? __ YES __ NO
	;;^UTILITY(U,$J,358.6,26,1,7,0)
	;;=Was treatment related to exposure to Environmental Contaminants? __ YES __ NO
	;;^UTILITY(U,$J,358.6,26,1,8,0)
	;;=Was treatment related to: AO __ IR __ EC __
	;;^UTILITY(U,$J,358.6,26,2)
	;;=RELATED TO SC CONDITION?^46^RELATED TO AO?^63^RELATED TO IR?^71^RELATED TO EC?^77^RELATED TO AO,IR, OR EC?^43
	;;^UTILITY(U,$J,358.6,26,3)
	;;=PATIENT TREATMENT QUESTIONS SERVICE CONNECTED EXPOSURE
	;;^UTILITY(U,$J,358.6,26,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,26,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,26,8)
	;;=^^^1^1
	;;^UTILITY(U,$J,358.6,27,0)
	;;=IBDF UTILITY FOR SELECTING BLANKS^NULL^IBDFN4^INTEGRATED BILLING^^3^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,27,1,0)
	;;=^^2^2^2930414^^^^
	;;^UTILITY(U,$J,358.6,27,1,1,0)
	;;=No data is returned, so this interface allows the user to create a
	;;^UTILITY(U,$J,358.6,27,1,2,0)
	;;=selection list with what ever text he desires.
	;;^UTILITY(U,$J,358.6,27,2)
	;;=Enter Anything!^0^^^^^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,358.6,27,3)
	;;=UTILITY SELECT NULL BLANKS
	;;^UTILITY(U,$J,358.6,28,0)
	;;=GMP PATIENT ACTIVE PROBLEMS^ACTIVE^GMPLENFM^PROBLEM LIST^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,28,1,0)
	;;=^^8^8^2931015^^^^
	;;^UTILITY(U,$J,358.6,28,1,1,0)
	;;=For displaying the patient's active problems. Returns a list.
	;;^UTILITY(U,$J,358.6,28,1,2,0)
	;;=Data returned:
	;;^UTILITY(U,$J,358.6,28,1,3,0)
	;;=  problem text
	;;^UTILITY(U,$J,358.6,28,1,4,0)
	;;=  corresponding ICD-9 code (if there is a mapping)
	;;^UTILITY(U,$J,358.6,28,1,5,0)
	;;=  date of onset (MM/DD/YY)
	;;^UTILITY(U,$J,358.6,28,1,6,0)
	;;=  SC indicator (SC/NSC/"")
	;;^UTILITY(U,$J,358.6,28,1,7,0)
	;;=  special exposure (A/I/P/"")
	;;^UTILITY(U,$J,358.6,28,1,8,0)
	;;=  special exposure (returns the full text of the type of exposure)
	;;^UTILITY(U,$J,358.6,28,2)
	;;=PROBLEM TEXT^210^CORRESPONDNG ICD-9 Dx CODE^7^DATE OF ONSET (MM/DD/YY)^8^SC INDICATOR (SC/NSC/"")^3^SC INDICATOR (Y/N/"")^1^SPECIAL EXPOSURE (A/I/P/"")^1^SPECIAL EXPOSURE (FULL TEXT)^12^^^
	;;^UTILITY(U,$J,358.6,28,3)
	;;=ACTIVE PROBLEMS LIST PATIENT
	;;^UTILITY(U,$J,358.6,28,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,28,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,29,0)
	;;=GMP SELECT CLINIC COMMON PROBLEMS^SELECT^GMPLENFM^PROBLEM LIST^0^3^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,29,1,0)
	;;=^^2^2^2931025^
