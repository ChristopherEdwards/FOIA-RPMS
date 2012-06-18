IBINI08H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,51,3)
	;;=PATIENT TREATMENT QUESTIONS SERVICE CONNECTED EXPOSURE
	;;^UTILITY(U,$J,357.6,51,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,51,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,51,8)
	;;=^^^1^1
	;;^UTILITY(U,$J,357.6,52,0)
	;;=SD FUTURE APPTS, SAME DAY^SAMEDAY^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,357.6,52,1,0)
	;;=^^8^8^2931105^^^
	;;^UTILITY(U,$J,357.6,52,1,1,0)
	;;=Returns a list of all the patient's future appointments for the same day.
	;;^UTILITY(U,$J,357.6,52,1,2,0)
	;;= Includes:
	;;^UTILITY(U,$J,357.6,52,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,357.6,52,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,357.6,52,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,357.6,52,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,357.6,52,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,357.6,52,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,357.6,52,2)
	;;=DATE (MMM DD,YYYY)^11^TIME (HH:MM)^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,357.6,52,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,357.6,52,7,0)
	;;=^357.67^2^2
	;;^UTILITY(U,$J,357.6,52,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,52,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,357.6,53,0)
	;;=SD FUTURE APPTS, ALL^ALLFUTR^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,357.6,53,1,0)
	;;=^^8^8^2931105^
	;;^UTILITY(U,$J,357.6,53,1,1,0)
	;;=Returns a list of all future appointments for the same day, all clinics.
	;;^UTILITY(U,$J,357.6,53,1,2,0)
	;;=Includes:
	;;^UTILITY(U,$J,357.6,53,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,357.6,53,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,357.6,53,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,357.6,53,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,357.6,53,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,357.6,53,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,357.6,53,2)
	;;=DATE (MMM DD,YYYY)^11^TIME^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,357.6,53,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,357.6,53,7,0)
	;;=^357.67^2^2
	;;^UTILITY(U,$J,357.6,53,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,53,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,357.6,54,0)
	;;=SD FUTURE APPTS, SAME CLINIC^CLNCFUTR^IBDFN1^SCHEDULING^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,357.6,54,1,0)
	;;=^^8^8^2931105^
	;;^UTILITY(U,$J,357.6,54,1,1,0)
	;;=Returns a list of all the patient's future appointments for the same day
	;;^UTILITY(U,$J,357.6,54,1,2,0)
	;;=and clinic. Includes:
	;;^UTILITY(U,$J,357.6,54,1,3,0)
	;;=  Appointment Date
	;;^UTILITY(U,$J,357.6,54,1,4,0)
	;;=  Appointment Time
	;;^UTILITY(U,$J,357.6,54,1,5,0)
	;;=  Appointment Date@Time
	;;^UTILITY(U,$J,357.6,54,1,6,0)
	;;=  Clinic
	;;^UTILITY(U,$J,357.6,54,1,7,0)
	;;=  Status
	;;^UTILITY(U,$J,357.6,54,1,8,0)
	;;=  Appointment Type
	;;^UTILITY(U,$J,357.6,54,2)
	;;=DATE (MMM DD,YYYY)^11^TIME^5^DATE@TIME^17^CLINIC^30^STATUS^35^APPOINTMENT TYPE^25
	;;^UTILITY(U,$J,357.6,54,3)
	;;=FUTURE APPOINTMENTS SCHEDULING
	;;^UTILITY(U,$J,357.6,54,7,0)
	;;=^357.67^3^3
	;;^UTILITY(U,$J,357.6,54,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,54,7,2,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,357.6,54,7,3,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,357.6,55,0)
	;;=DPT PATIENT'S INSURANCE - ALL^INSURANC^IBDFN6^PATIENT FILE^1^2^4^1^1^^^1
	;;^UTILITY(U,$J,357.6,55,1,0)
	;;=^^10^10^2931201^
	;;^UTILITY(U,$J,357.6,55,1,1,0)
	;;=For displaying information on the patient's health insurance. Returns
	;;^UTILITY(U,$J,357.6,55,1,2,0)
	;;=ALL insurance policies, including inactive ones.
	;;^UTILITY(U,$J,357.6,55,1,3,0)
	;;=Data returned:
	;;^UTILITY(U,$J,357.6,55,1,4,0)
	;;=  insurance company
