IBDEI01P	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6,29,1,1,0)
	;;=Allows the user to select common problemslems from the term file of the
	;;^UTILITY(U,$J,358.6,29,1,2,0)
	;;=Problem List package.
	;;^UTILITY(U,$J,358.6,29,2)
	;;=POINTER TO CLINICAL TERM FILE^9^PROBLEM TEXT^210^CORRESPNDNG ICD-9 Dx CODE^7^^^^^^^^^^^0^1
	;;^UTILITY(U,$J,358.6,29,3)
	;;=PROBLEMS SELECT LIST
	;;^UTILITY(U,$J,358.6,30,0)
	;;=SD FUTURE APPTS, SAME DAY^SAMEDAY^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,358.6,30,1,0)
	;;=^^8^8^2931105^^^
	;;^UTILITY(U,$J,358.6,30,1,1,0)
	;;=Returns a list of all the patient's future appointments for the same day.
	;;^UTILITY(U,$J,358.6,30,1,2,0)
	;;= Includes:
	;;^UTILITY(U,$J,358.6,30,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,358.6,30,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,358.6,30,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,358.6,30,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,358.6,30,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,358.6,30,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,358.6,30,2)
	;;=DATE (MMM DD,YYYY)^11^TIME (HH:MM)^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,358.6,30,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,358.6,30,7,0)
	;;=^357.67^2^2
	;;^UTILITY(U,$J,358.6,30,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,30,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,358.6,31,0)
	;;=SD FUTURE APPTS, ALL^ALLFUTR^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,358.6,31,1,0)
	;;=^^8^8^2931105^
	;;^UTILITY(U,$J,358.6,31,1,1,0)
	;;=Returns a list of all future appointments for the same day, all clinics.
	;;^UTILITY(U,$J,358.6,31,1,2,0)
	;;=Includes:
	;;^UTILITY(U,$J,358.6,31,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,358.6,31,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,358.6,31,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,358.6,31,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,358.6,31,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,358.6,31,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,358.6,31,2)
	;;=DATE (MMM DD,YYYY)^11^TIME^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,358.6,31,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,358.6,31,7,0)
	;;=^357.67^2^2
	;;^UTILITY(U,$J,358.6,31,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,31,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,358.6,32,0)
	;;=SD FUTURE APPTS, SAME CLINIC^CLNCFUTR^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,358.6,32,1,0)
	;;=^^8^8^2931105^
	;;^UTILITY(U,$J,358.6,32,1,1,0)
	;;=Returns a list of all the patient's future appointments for the same day
	;;^UTILITY(U,$J,358.6,32,1,2,0)
	;;=and clinic. Includes:
	;;^UTILITY(U,$J,358.6,32,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,358.6,32,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,358.6,32,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,358.6,32,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,358.6,32,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,358.6,32,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,358.6,32,2)
	;;=DATE (MMM DD,YYYY)^11^TIME^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,358.6,32,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,358.6,32,7,0)
	;;=^357.67^3^3
	;;^UTILITY(U,$J,358.6,32,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,32,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,358.6,32,7,3,0)
	;;=IBCLINIC
