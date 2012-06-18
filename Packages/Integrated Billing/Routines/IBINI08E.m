IBINI08E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,27,3)
	;;=CLINIC SCHEDULING
	;;^UTILITY(U,$J,357.6,27,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,27,7,1,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,357.6,28,0)
	;;=SD APPOINTMENT DATE/TIME^APPT^IBDFN2^SCHEDULING^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,28,1,0)
	;;=^^2^2^2930602^^^
	;;^UTILITY(U,$J,357.6,28,1,1,0)
	;;= 
	;;^UTILITY(U,$J,357.6,28,1,2,0)
	;;=Returns the date/time of the appointment.
	;;^UTILITY(U,$J,357.6,28,2)
	;;=APPT. DATE/TIME^18^APPT. DATE (MMM DD,YYYY)^12^APPT. TIME (HH:MM)^5
	;;^UTILITY(U,$J,357.6,28,3)
	;;=APPOINTMENT DATE TIME SCHEDULING
	;;^UTILITY(U,$J,357.6,28,7,0)
	;;=^357.67^3^3
	;;^UTILITY(U,$J,357.6,28,7,1,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,357.6,28,7,2,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,28,7,3,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,357.6,30,0)
	;;=DPT PATIENT ELIGIBILITY DATA^ELIG^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,30,1,0)
	;;=^^8^8^2931015^^^^
	;;^UTILITY(U,$J,357.6,30,1,1,0)
	;;=Returns patient eligibility data. Data returned is:
	;;^UTILITY(U,$J,357.6,30,1,2,0)
	;;=   eligibility code in external form
	;;^UTILITY(U,$J,357.6,30,1,3,0)
	;;=   period of service
	;;^UTILITY(U,$J,357.6,30,1,4,0)
	;;=   service connected? YES/NO
	;;^UTILITY(U,$J,357.6,30,1,5,0)
	;;=   veteran? YES/NO
	;;^UTILITY(U,$J,357.6,30,1,6,0)
	;;=   eligible for care? YES/NO
	;;^UTILITY(U,$J,357.6,30,1,7,0)
	;;=   type of patient
	;;^UTILITY(U,$J,357.6,30,1,8,0)
	;;=   SC%
	;;^UTILITY(U,$J,357.6,30,2)
	;;=ELIGIBILTY CODE/EXTERNAL FORM^30^PERIOD OF SERVICE^25^SERVICE CONNECTED?^3^VETERAN?^3^ELIGIBLE FOR CARE?^3^TYPE OF PATIENT^20^SC %^3
	;;^UTILITY(U,$J,357.6,30,3)
	;;=ELIGIBLE ELIGIBILITY PATIENT PERIOD SERVICE CONNECTED VETERAN STATUS
	;;^UTILITY(U,$J,357.6,30,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,30,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,31,0)
	;;=DPT SERVICE HISTORY RELATED DATA^ELIG^IBDFN^PATIENT FILE^1^2^2^0^1^^^1^^
	;;^UTILITY(U,$J,357.6,31,1,0)
	;;=^^7^7^2931015^^^^
	;;^UTILITY(U,$J,357.6,31,1,1,0)
	;;=For displaying service history data. Data returned:
	;;^UTILITY(U,$J,357.6,31,1,2,0)
	;;=  Vietnam service? YES/NO
	;;^UTILITY(U,$J,357.6,31,1,3,0)
	;;=  Agent Orange exposure? YES/NO
	;;^UTILITY(U,$J,357.6,31,1,4,0)
	;;=  radiation exposure? YES/NO
	;;^UTILITY(U,$J,357.6,31,1,5,0)
	;;=  combat service? YES/NO
	;;^UTILITY(U,$J,357.6,31,1,6,0)
	;;=  POW? YES/NO
	;;^UTILITY(U,$J,357.6,31,1,7,0)
	;;=  environmental contaminants exposure? YES/NO
	;;^UTILITY(U,$J,357.6,31,2)
	;;=VIETNAM SERVICE?^3^AGENT ORANGE EXPOSURE?^3^RADIATION EXPOSURE?^3^POW?^3^COMBAT SERVICE?^3^ENVIRONMENTAL CONTAMINANTS?^3
	;;^UTILITY(U,$J,357.6,31,3)
	;;=PATIENT MAS VIETNAM SERVICE AGENT ORANGE RADIATION COMBAT POW HISTORY ENVIRONMENTAL CONTAMINANT PERSIAN
	;;^UTILITY(U,$J,357.6,31,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,31,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,32,0)
	;;=DPT PATIENT'S MEANS TEST DATA^MT^IBDFN2^MAS^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,32,1,0)
	;;=^^5^5^2931015^^^
	;;^UTILITY(U,$J,357.6,32,1,1,0)
	;;=Returns the patient's current means test category and the date of the most
	;;^UTILITY(U,$J,357.6,32,1,2,0)
	;;=recent means test. Data returned:
	;;^UTILITY(U,$J,357.6,32,1,3,0)
	;;=  means test category
	;;^UTILITY(U,$J,357.6,32,1,4,0)
	;;=  means test code
	;;^UTILITY(U,$J,357.6,32,1,5,0)
	;;=  date of last means test
	;;^UTILITY(U,$J,357.6,32,2)
	;;=MEANS TEST CATEGORY^20^DATE OF LAST MEANS TEST^12^MEANS TEST CODE^1
	;;^UTILITY(U,$J,357.6,32,3)
	;;=MEANS TEST CATEGORY PATIENT MAS
	;;^UTILITY(U,$J,357.6,32,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,32,7,1,0)
	;;=DFN
