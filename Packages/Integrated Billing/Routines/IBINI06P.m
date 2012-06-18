IBINI06P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,356.4,57,0)
	;;=OTHER REASON IDENTIFIED^8.02^^8^2
	;;^UTILITY(U,$J,356.4,57,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,57,1,1,0)
	;;=If you have been unable to identify any reasons from this list, please
	;;^UTILITY(U,$J,356.4,57,1,2,0)
	;;=use 8.02, Other reason identified.
	;;^UTILITY(U,$J,356.4,58,0)
	;;=OTHER (PRACTITIONER ISSUES)^5.05^^5^1
	;;^UTILITY(U,$J,356.4,58,1,0)
	;;=^^1^1^2940201^^^^
	;;^UTILITY(U,$J,356.4,58,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,59,0)
	;;=PREMATURE APPROPRIATE ADMISSION^11.03^^3^2
	;;^UTILITY(U,$J,356.4,59,1,0)
	;;=^^3^3^2940201^^^^
	;;^UTILITY(U,$J,356.4,59,1,1,0)
	;;=Premature admission (Procedures scheduled after admission day, or Patient
	;;^UTILITY(U,$J,356.4,59,1,2,0)
	;;=admitted on Friday and not evaluated until Monday {Procedure to be done
	;;^UTILITY(U,$J,356.4,59,1,3,0)
	;;=is an appropriate inpatient admission})
	;;^UTILITY(U,$J,356.4,60,0)
	;;=PREMATURE INAPPROPRIATE ADMISSION^11.04^^3^2
	;;^UTILITY(U,$J,356.4,60,1,0)
	;;=^^3^3^2940201^^
	;;^UTILITY(U,$J,356.4,60,1,1,0)
	;;=Premature admission (Procedures scheduled after admission day, or
	;;^UTILITY(U,$J,356.4,60,1,2,0)
	;;=Patient admitted on Friday and not evaluated until Monday {Procedure
	;;^UTILITY(U,$J,356.4,60,1,3,0)
	;;=to be done is not an appropriate inpatient admission})
	;;^UTILITY(U,$J,356.4,61,0)
	;;=PHYSICIAN CHOSE ACUTE CARE^15.06^^5^2
	;;^UTILITY(U,$J,356.4,61,1,0)
	;;=^^3^3^2940201^^
	;;^UTILITY(U,$J,356.4,61,1,1,0)
	;;=Physician chose to keep in acute care though care and service could
	;;^UTILITY(U,$J,356.4,61,1,2,0)
	;;=be rendered safely and effectively (causing no harm/potential harm
	;;^UTILITY(U,$J,356.4,61,1,3,0)
	;;=to patient) in an alternate setting (No medical Justification given)
	;;^UTILITY(U,$J,356.4,62,0)
	;;=MONITORING ORDERS DO NOT REFLECT ACUITY^15.07^^5^2
	;;^UTILITY(U,$J,356.4,62,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,62,1,1,0)
	;;=Monitoring orders do not reflect acuity as indicated by SI criteria
	;;^UTILITY(U,$J,356.4,62,1,2,0)
	;;=and does not meed Discharge screens
	;;^UTILITY(U,$J,356.4,63,0)
	;;=NO DOCUMENTED PLAN OF TREATMENT (NON-ADM WEEK)^15.05^^5^2
	;;^UTILITY(U,$J,356.4,63,1,0)
	;;=^^2^2^2940201^^
	;;^UTILITY(U,$J,356.4,63,1,1,0)
	;;=No documented plan of active treatment or evaluation of patient
	;;^UTILITY(U,$J,356.4,63,1,2,0)
	;;=(Non-Administrative Week)
	;;^UTILITY(U,$J,356.4,64,0)
	;;=OTHER (OTHER FACTORS)^16.01^^8^2
	;;^UTILITY(U,$J,356.4,64,1,0)
	;;=^^1^1^2940201^
	;;^UTILITY(U,$J,356.4,64,1,1,0)
	;;=Other (Specify in comments Section)
