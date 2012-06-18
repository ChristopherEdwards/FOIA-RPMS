IBINI06L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,356.4)
	;;=^IBE(356.4,
	;;^UTILITY(U,$J,356.4,0)
	;;=CLAIMS TRACKING NON-ACUTE CLASSIFICATIONS^356.4I^64^64
	;;^UTILITY(U,$J,356.4,1,0)
	;;=LACK OF FAMILY/SOCIAL SUPPORT^1.01^^1^1
	;;^UTILITY(U,$J,356.4,1,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,1,1,1,0)
	;;=Lack of family/social support/unable to care for self
	;;^UTILITY(U,$J,356.4,2,0)
	;;=HOMELESS^1.02^^1^1
	;;^UTILITY(U,$J,356.4,2,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,2,1,1,0)
	;;=Homeless
	;;^UTILITY(U,$J,356.4,3,0)
	;;=RESPITE CARE^1.03^^1^1
	;;^UTILITY(U,$J,356.4,3,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,3,1,1,0)
	;;=Respite Care
	;;^UTILITY(U,$J,356.4,4,0)
	;;=ADMISSION WAS FOR FAMILY CONVENIENCE^1.04^^1^1
	;;^UTILITY(U,$J,356.4,4,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,4,1,1,0)
	;;=Admission was for family, patient or physician convenience
	;;^UTILITY(U,$J,356.4,5,0)
	;;=OTHER (SOCIAL FACTOR)^1.05^^1^1
	;;^UTILITY(U,$J,356.4,5,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,5,1,1,0)
	;;=Other (specify in comments sections)
	;;^UTILITY(U,$J,356.4,6,0)
	;;=DISTANCE TO TRAVEL TO HOSPITAL^2.01^^2^1
	;;^UTILITY(U,$J,356.4,6,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,6,1,1,0)
	;;=Distance to travel to hospital (over 75 miles)
	;;^UTILITY(U,$J,356.4,7,0)
	;;=OTHER (ENVIRONMENTAL FACTOR)^2.02^^2^1
	;;^UTILITY(U,$J,356.4,7,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,7,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,8,0)
	;;=DELAY IN SCHEDULING APPOINTMENT^3.01^^3^1
	;;^UTILITY(U,$J,356.4,8,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,8,1,1,0)
	;;=Delay is scheduling outpatient clinic appointment
	;;^UTILITY(U,$J,356.4,9,0)
	;;=DELAY IN SCHEDULING PROCEDURE^3.02^^3^1
	;;^UTILITY(U,$J,356.4,9,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,9,1,1,0)
	;;=Delay is scheduling outpatient procedure
	;;^UTILITY(U,$J,356.4,10,0)
	;;=ADMISSION TO CIRCUMENT SLOWNESS^3.03^^3^1
	;;^UTILITY(U,$J,356.4,10,1,0)
	;;=^^3^3^2940201^^^^
	;;^UTILITY(U,$J,356.4,10,1,1,0)
	;;=Admission due to wish to circumvent slowness or lack of timely
	;;^UTILITY(U,$J,356.4,10,1,2,0)
	;;=appointments in ambulatory care system; e.g., timeliness of routine
	;;^UTILITY(U,$J,356.4,10,1,3,0)
	;;=lab, X-rays, procedures, consults
	;;^UTILITY(U,$J,356.4,11,0)
	;;=PREMATURE ADMISSION^3.04^^3^1
	;;^UTILITY(U,$J,356.4,11,1,0)
	;;=^^3^3^2940201^^^
	;;^UTILITY(U,$J,356.4,11,1,1,0)
	;;=Premature admission (Procedures scheduled more than one day after
	;;^UTILITY(U,$J,356.4,11,1,2,0)
	;;=admission or patient admitted on Friday and not evaluated until
	;;^UTILITY(U,$J,356.4,11,1,3,0)
	;;=Monday)
	;;^UTILITY(U,$J,356.4,12,0)
	;;=OTHER (SCHEDULING)^3.05^^3^1
	;;^UTILITY(U,$J,356.4,12,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,12,1,1,0)
	;;=Other (Specify if comments section)
	;;^UTILITY(U,$J,356.4,13,0)
	;;=ALTERNATIVE BEDS UNAVAILABLE^4.01^^4^1
	;;^UTILITY(U,$J,356.4,13,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,13,1,1,0)
	;;=Alternative beds unavailable; e.g., Observations, Intermediate Care,
	;;^UTILITY(U,$J,356.4,13,1,2,0)
	;;=NHCU, Hospice
	;;^UTILITY(U,$J,356.4,14,0)
	;;=OUTPATIENT PROCEDURE UNAVAILABLE^4.02^^4^1
	;;^UTILITY(U,$J,356.4,14,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,14,1,1,0)
	;;=Outpatient procedure unavailable (not offered as an outpatient
	;;^UTILITY(U,$J,356.4,14,1,2,0)
	;;=procedure)
	;;^UTILITY(U,$J,356.4,15,0)
	;;=OTHER OUTPATIENT SERVICES/CARE UNAVAILABLE^4.03^^4^1
	;;^UTILITY(U,$J,356.4,15,1,0)
	;;=^^4^4^2940201^^^
	;;^UTILITY(U,$J,356.4,15,1,1,0)
	;;=Other outpatient services/care unavailable; e.g., board and care,
