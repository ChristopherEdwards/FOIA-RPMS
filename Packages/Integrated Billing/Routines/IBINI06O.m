IBINI06O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,356.4,42,1,3,0)
	;;=but full, (NHCU has not yet accepted patient), or type of beds are
	;;^UTILITY(U,$J,356.4,42,1,4,0)
	;;=not available at facility
	;;^UTILITY(U,$J,356.4,43,0)
	;;=AWAITING PLACEMENT IN COMMUNITY NURSING HOME^12.02^^4^2
	;;^UTILITY(U,$J,356.4,43,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,43,1,1,0)
	;;=Awaiting placement in a community nursing home
	;;^UTILITY(U,$J,356.4,44,0)
	;;=AWAITING TRANSFER TO ANOTHER ACUTE CARE^12.03^^4^2
	;;^UTILITY(U,$J,356.4,44,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,44,1,1,0)
	;;=Awaiting transfer to another acute care institution
	;;^UTILITY(U,$J,356.4,45,0)
	;;=NON-FACILITY BASED TREATMENT UNAVAILABLE^12.04^^4^2
	;;^UTILITY(U,$J,356.4,45,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,45,1,1,0)
	;;=Non-facility based treatment unavailable; e.g., home health care
	;;^UTILITY(U,$J,356.4,46,0)
	;;=OTHER (BED AVAILABILITY)^12.05^^4^2
	;;^UTILITY(U,$J,356.4,46,1,0)
	;;=^^1^1^2940201^^^^
	;;^UTILITY(U,$J,356.4,46,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,47,0)
	;;=SERVICE-CONNECTED CONSIDERATIONS DELAY DISCHARGE^13.01^^6^2
	;;^UTILITY(U,$J,356.4,47,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,47,1,1,0)
	;;=Service-connected considerations delay discharge
	;;^UTILITY(U,$J,356.4,48,0)
	;;=PATIENT GRANTED PASS^13.02^^6^2
	;;^UTILITY(U,$J,356.4,48,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,48,1,1,0)
	;;=Patient granted pass (which does not have clear therapeutic rationale)
	;;^UTILITY(U,$J,356.4,49,0)
	;;=OTHER (ADMINISTRATIVE)^13.03^^6^2
	;;^UTILITY(U,$J,356.4,49,1,0)
	;;=^^1^1^2940201^^^^
	;;^UTILITY(U,$J,356.4,49,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,50,0)
	;;=DELAY IN RECEIVING RESULTS^14.01^^7^2
	;;^UTILITY(U,$J,356.4,50,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,50,1,1,0)
	;;=Delay in receiving results of diagnostic test or consultation needed to
	;;^UTILITY(U,$J,356.4,50,1,2,0)
	;;=direct further treatment
	;;^UTILITY(U,$J,356.4,51,0)
	;;=OTHER (COMMUNICATION PROBLEMS)^14.02^^7^2
	;;^UTILITY(U,$J,356.4,51,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,51,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,52,0)
	;;=FAILURE TO WRITE DISCHARGE ORDERS^15.01^^5^2
	;;^UTILITY(U,$J,356.4,52,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,52,1,1,0)
	;;=Failure to write discharge orders
	;;^UTILITY(U,$J,356.4,53,0)
	;;=FAILURE TO INITIATE DISCHARGE PLANNING^15.02^^5^2
	;;^UTILITY(U,$J,356.4,53,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,53,1,1,0)
	;;=Failure to initiate timely discharge planning; e.g., developing plan
	;;^UTILITY(U,$J,356.4,53,1,2,0)
	;;=for transfer to non-acute level of care
	;;^UTILITY(U,$J,356.4,54,0)
	;;=OBSERVATION FOR SIGNS/SYMPTOMS^15.03^^5^2
	;;^UTILITY(U,$J,356.4,54,1,0)
	;;=^^3^3^2940201^^^
	;;^UTILITY(U,$J,356.4,54,1,1,0)
	;;=Observation for signs/symptoms such as: medication adjustment,
	;;^UTILITY(U,$J,356.4,54,1,2,0)
	;;=signs of depression, potential relapse from alcohol or drugs,
	;;^UTILITY(U,$J,356.4,54,1,3,0)
	;;=noncompliance
	;;^UTILITY(U,$J,356.4,55,0)
	;;=NO DOCUMENTED PLAN OF TREATMENT^15.04^^5^2
	;;^UTILITY(U,$J,356.4,55,1,0)
	;;=^^2^2^2940201^^^^
	;;^UTILITY(U,$J,356.4,55,1,1,0)
	;;=No documented plan of active treatment or evaluation of patient
	;;^UTILITY(U,$J,356.4,55,1,2,0)
	;;=(Administrative Week)
	;;^UTILITY(U,$J,356.4,56,0)
	;;=OTHER (PRACTITIONER ISSUES)^15.08^^5^2
	;;^UTILITY(U,$J,356.4,56,1,0)
	;;=^^1^1^2940201^^^^
	;;^UTILITY(U,$J,356.4,56,1,1,0)
	;;=Other (Specify in comments section)
