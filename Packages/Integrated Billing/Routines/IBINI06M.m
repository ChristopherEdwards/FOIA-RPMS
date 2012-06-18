IBINI06M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,356.4,15,1,2,0)
	;;=(appointment availability not frequent enough to allow for close
	;;^UTILITY(U,$J,356.4,15,1,3,0)
	;;=follow-up in outpatient setting for care such as medication adjustments,
	;;^UTILITY(U,$J,356.4,15,1,4,0)
	;;=blood transusions, chemotherapy, etc.)
	;;^UTILITY(U,$J,356.4,16,0)
	;;=OTHER (BED/SERVICE AVAILABILITY)^4.04^^4^1
	;;^UTILITY(U,$J,356.4,16,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,16,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,17,0)
	;;=AMBULATORY CARE SEEMS APPROPRIATE^5.01^^5^1
	;;^UTILITY(U,$J,356.4,17,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,17,1,1,0)
	;;=Ambulatory Care seem appropriate and services or specialty is
	;;^UTILITY(U,$J,356.4,17,1,2,0)
	;;=available/offered
	;;^UTILITY(U,$J,356.4,18,0)
	;;=PHYSICIAN DETERMINED PATIENT NEEDED HOSPITALIZATION^5.02^^5^1
	;;^UTILITY(U,$J,356.4,18,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,18,1,1,0)
	;;=Physician determined that patient needed hospitalization for medical
	;;^UTILITY(U,$J,356.4,18,1,2,0)
	;;=reasons (serious illness or needed hospital services)
	;;^UTILITY(U,$J,356.4,19,0)
	;;=PHYSICIAN CHOSE TO ADMIT^5.03^^5^1
	;;^UTILITY(U,$J,356.4,19,1,0)
	;;=^^5^5^2940201^^^
	;;^UTILITY(U,$J,356.4,19,1,1,0)
	;;=Physician chose to admit though care and service could be rendered
	;;^UTILITY(U,$J,356.4,19,1,2,0)
	;;=safely and effectively (causing no harm/potential harm to patient) in
	;;^UTILITY(U,$J,356.4,19,1,3,0)
	;;=an alternate setting (causing no harm/potential harm to patient)
	;;^UTILITY(U,$J,356.4,19,1,4,0)
	;;=in an alternate/non ambulatory setting, e.g., Hospice, Board
	;;^UTILITY(U,$J,356.4,19,1,5,0)
	;;=and care, Nursing Home (No medical justification given)
	;;^UTILITY(U,$J,356.4,20,0)
	;;=MONITORING ORDERS DO NOT REFLECT ACUITY^5.04^^5^1
	;;^UTILITY(U,$J,356.4,20,1,0)
	;;=^^1^1^2940201^^^^
	;;^UTILITY(U,$J,356.4,20,1,1,0)
	;;=Monitoring Orders do not reflect acuity as indicated by SI criteria
	;;^UTILITY(U,$J,356.4,21,0)
	;;=ADMITTED FOR NURSING HOME PLACEMENT^6.01^^6^1
	;;^UTILITY(U,$J,356.4,21,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,21,1,1,0)
	;;=Admitted for Nursing Home Placement
	;;^UTILITY(U,$J,356.4,22,0)
	;;=ADMITTED FOR TRANSFER^6.02^^6^1
	;;^UTILITY(U,$J,356.4,22,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,22,1,1,0)
	;;=Admitted for transfer to anohter acute care hospital
	;;^UTILITY(U,$J,356.4,23,0)
	;;=ADMITTED TO BE ELIGIBLE FOR OTHER CARE^6.03^^6^1
	;;^UTILITY(U,$J,356.4,23,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,23,1,1,0)
	;;=Admitted to be eligible for other VA care; e.g., Dental
	;;^UTILITY(U,$J,356.4,24,0)
	;;=ADMITTED AS A TRANFER FROM ANOTHER HOSPITAL^6.04^^6^1
	;;^UTILITY(U,$J,356.4,24,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,24,1,1,0)
	;;=Admitted as a transfer from another hospital
	;;^UTILITY(U,$J,356.4,25,0)
	;;=ADMITTED FROM BOARDING HOME/CNH^6.05^^6^1
	;;^UTILITY(U,$J,356.4,25,1,0)
	;;=^^3^3^2940201^^^
	;;^UTILITY(U,$J,356.4,25,1,1,0)
	;;=Admitted from a boarding home/Contract Nursing Home for 
	;;^UTILITY(U,$J,356.4,25,1,2,0)
	;;=psychosocial reasons; e.g. contract home returned patient
	;;^UTILITY(U,$J,356.4,25,1,3,0)
	;;=to hospital due to behavioral problems
	;;^UTILITY(U,$J,356.4,26,0)
	;;=ADMITTED FOR C&P EXAM^6.06^^6^1
	;;^UTILITY(U,$J,356.4,26,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,26,1,1,0)
	;;=Admitted for Compensation & Pension Exam
	;;^UTILITY(U,$J,356.4,27,0)
	;;=OTHER (ADMINISTRATIVE)^6.07^^6^1
	;;^UTILITY(U,$J,356.4,27,1,0)
	;;=^^1^1^2940201^^^
