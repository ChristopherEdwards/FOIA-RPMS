IBINI06N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,356.4,27,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,28,0)
	;;=OTHER (COMMUNICATION PROBLEM)^7.01^^7^1
	;;^UTILITY(U,$J,356.4,28,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,28,1,1,0)
	;;=Other (Specify in Comments section)
	;;^UTILITY(U,$J,356.4,29,0)
	;;=OTHER REASON IDENTIFIED^8.01^^8^1
	;;^UTILITY(U,$J,356.4,29,1,0)
	;;=^^2^2^2940201^^^^
	;;^UTILITY(U,$J,356.4,29,1,1,0)
	;;=If you have been unable to identify any reasons from this list, please
	;;^UTILITY(U,$J,356.4,29,1,2,0)
	;;=use 8.01, Other reason identified.
	;;^UTILITY(U,$J,356.4,30,0)
	;;=PATIENT IS CONVALESCING^9.01^^1^2
	;;^UTILITY(U,$J,356.4,30,1,0)
	;;=^^3^3^2940201^^^
	;;^UTILITY(U,$J,356.4,30,1,1,0)
	;;=Patient is convalescing from an illness, and it is anticipated
	;;^UTILITY(U,$J,356.4,30,1,2,0)
	;;=that his/her stay in an alternative facility would be less than
	;;^UTILITY(U,$J,356.4,30,1,3,0)
	;;=72 hours
	;;^UTILITY(U,$J,356.4,31,0)
	;;=PATIENT FROM UNHEALTHY ENVIRONMENT^9.02^^1^2
	;;^UTILITY(U,$J,356.4,31,1,0)
	;;=^^2^2^2940201^^^
	;;^UTILITY(U,$J,356.4,31,1,1,0)
	;;=Patient from unhealthy environment, patient kept until environment
	;;^UTILITY(U,$J,356.4,31,1,2,0)
	;;=becomes acceptable or alternative facility found
	;;^UTILITY(U,$J,356.4,32,0)
	;;=LACK OF FAMILY FOR HOME CARE^9.03^^1^2
	;;^UTILITY(U,$J,356.4,32,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,32,1,1,0)
	;;=Lack of family for home care (or lack of supportive family)
	;;^UTILITY(U,$J,356.4,33,0)
	;;=HOMELESS^9.04^^1^2
	;;^UTILITY(U,$J,356.4,33,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,33,1,1,0)
	;;=Homeless
	;;^UTILITY(U,$J,356.4,34,0)
	;;=RESPITE CARE^9.05^^1^2
	;;^UTILITY(U,$J,356.4,34,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,34,1,1,0)
	;;=Respite Care
	;;^UTILITY(U,$J,356.4,35,0)
	;;=OTHER (SOCIAL FACTORS)^9.06^^1^2
	;;^UTILITY(U,$J,356.4,35,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,35,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,36,0)
	;;=WEATHER DEEMED INAPROPRIATE^10.01^^2^2
	;;^UTILITY(U,$J,356.4,36,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,36,1,1,0)
	;;=Weather deemed inappropriate by practitioner for patients to travel
	;;^UTILITY(U,$J,356.4,37,0)
	;;=DISTANCE TO TRAVEL OVER 75 MILES^10.02^^2^2
	;;^UTILITY(U,$J,356.4,37,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,37,1,1,0)
	;;=Distance to travel between hospital and home (over 75 miles)
	;;^UTILITY(U,$J,356.4,38,0)
	;;=OTHER (ENVIRONMENTAL FACTORS)^10.03^^2^2
	;;^UTILITY(U,$J,356.4,38,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,38,1,1,0)
	;;=Other (Specify in comments section)
	;;^UTILITY(U,$J,356.4,39,0)
	;;=PROBLEM IN TIMELY SCHEDULING^11.01^^3^2
	;;^UTILITY(U,$J,356.4,39,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,39,1,1,0)
	;;=Problem in timely scheduling/canceling of procedure
	;;^UTILITY(U,$J,356.4,40,0)
	;;=WAITING FOR APPROPRIATE PROCEDURE^11.02^^3^2
	;;^UTILITY(U,$J,356.4,40,1,0)
	;;=^^1^1^2940218^^^^
	;;^UTILITY(U,$J,356.4,40,1,1,0)
	;;=Waiting for appropriate procedure to be done at non-VA facility
	;;^UTILITY(U,$J,356.4,41,0)
	;;=OTHER (SCHEDULING)^11.05^^3^2
	;;^UTILITY(U,$J,356.4,41,1,0)
	;;=^^1^1^2940201^^^
	;;^UTILITY(U,$J,356.4,41,1,1,0)
	;;=Other (Specify in comments sections)
	;;^UTILITY(U,$J,356.4,42,0)
	;;=ALTERNATE BEDS UNAVAILABLE^12.01^^4^2
	;;^UTILITY(U,$J,356.4,42,1,0)
	;;=^^4^4^2940201^^^
	;;^UTILITY(U,$J,356.4,42,1,1,0)
	;;=Alternate beds unavailable within the facility; e.g., Observation, 
	;;^UTILITY(U,$J,356.4,42,1,2,0)
	;;=Intermediate Care, NHCU, or Hospice; e.g. type of beds available
