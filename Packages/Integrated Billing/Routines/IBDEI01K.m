IBDEI01K	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6)
	;;=^IBE(358.6,
	;;^UTILITY(U,$J,358.6,0)
	;;=IMP/EXP PACKAGE INTERFACE^358.6IO^32^32
	;;^UTILITY(U,$J,358.6,1,0)
	;;=DG SELECT CPT PROCEDURE CODES^CPT^IBDFN4^MAS^^3^2^^1^^^1
	;;^UTILITY(U,$J,358.6,1,1,0)
	;;=^^2^2^2930726^^^
	;;^UTILITY(U,$J,358.6,1,1,1,0)
	;;=Allows for the selection of CPT codes from the CPT file. The user can 
	;;^UTILITY(U,$J,358.6,1,1,2,0)
	;;=limit his selections by choosing a major CPT category if he wishes.
	;;^UTILITY(U,$J,358.6,1,2)
	;;=CODE^5^SHORT NAME^28^DESCRIPTION^161^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,358.6,1,3)
	;;=SELECT CPT CODES
	;;^UTILITY(U,$J,358.6,2,0)
	;;=IBDF UTILITY FOR BLANK LINES^BLANKS^IBDFN^INTEGRATED BILLING^0^2^5^^1^^^1^^
	;;^UTILITY(U,$J,358.6,2,1,0)
	;;=^^2^2^2930408^^
	;;^UTILITY(U,$J,358.6,2,1,1,0)
	;;=No data is returned by this interface - it's purpose is to print blank
	;;^UTILITY(U,$J,358.6,2,1,2,0)
	;;=lines to the form for data entry.
	;;^UTILITY(U,$J,358.6,2,2)
	;;=^0
	;;^UTILITY(U,$J,358.6,2,3)
	;;=UTILITY BLANKS LINES
	;;^UTILITY(U,$J,358.6,3,0)
	;;=IBDF UTILITY FOR LABELS ONLY^LABELS^IBDFN^INTEGRATED BILLING^0^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,3,1,0)
	;;=^^2^2^2930210^^
	;;^UTILITY(U,$J,358.6,3,1,1,0)
	;;=This interface returns no data. Its purpose is to print labels without
	;;^UTILITY(U,$J,358.6,3,1,2,0)
	;;=data to the form.
	;;^UTILITY(U,$J,358.6,3,2)
	;;=Underscore Only^0
	;;^UTILITY(U,$J,358.6,3,3)
	;;=UTILITY BLANKS LABELS
	;;^UTILITY(U,$J,358.6,4,0)
	;;=SD APPOINTMENT DATE/TIME^APPT^IBDFN2^SCHEDULING^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,4,1,0)
	;;=^^2^2^2930602^^^
	;;^UTILITY(U,$J,358.6,4,1,1,0)
	;;= 
	;;^UTILITY(U,$J,358.6,4,1,2,0)
	;;=Returns the date/time of the appointment.
	;;^UTILITY(U,$J,358.6,4,2)
	;;=APPT. DATE/TIME^18^APPT. DATE (MMM DD,YYYY)^12^APPT. TIME (HH:MM)^5
	;;^UTILITY(U,$J,358.6,4,3)
	;;=APPOINTMENT DATE TIME SCHEDULING
	;;^UTILITY(U,$J,358.6,4,7,0)
	;;=^357.67^3^3
	;;^UTILITY(U,$J,358.6,4,7,1,0)
	;;=IBAPPT
	;;^UTILITY(U,$J,358.6,4,7,2,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,4,7,3,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,358.6,5,0)
	;;=SD CLINIC NAME^CLINIC^IBDFN1^SCHEDULING^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,5,1,0)
	;;=^^2^2^2930616^^
	;;^UTILITY(U,$J,358.6,5,1,1,0)
	;;= 
	;;^UTILITY(U,$J,358.6,5,1,2,0)
	;;=Outputs the name of the clinic.
	;;^UTILITY(U,$J,358.6,5,2)
	;;=CLINIC NAME^30
	;;^UTILITY(U,$J,358.6,5,3)
	;;=CLINIC SCHEDULING
	;;^UTILITY(U,$J,358.6,5,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,5,7,1,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,358.6,6,0)
	;;=DPT PATIENT'S NAME^VADPT^IBDFN^PATIENT FILE^1^2^1^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,6,1,0)
	;;=^^2^2^2930212^^^^
	;;^UTILITY(U,$J,358.6,6,1,1,0)
	;;= 
	;;^UTILITY(U,$J,358.6,6,1,2,0)
	;;=Patient's Name
	;;^UTILITY(U,$J,358.6,6,2)
	;;=Patient's Name^30
	;;^UTILITY(U,$J,358.6,6,3)
	;;=PATIENT NAME MAS
	;;^UTILITY(U,$J,358.6,6,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,6,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,7,0)
	;;=DPT PATIENT'S PID^VADPT^IBDFN^PATIENT FILE^1^2^1^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,7,1,0)
	;;=^^1^1^2931015^^
	;;^UTILITY(U,$J,358.6,7,1,1,0)
	;;=Used to display the patient identifier.
	;;^UTILITY(U,$J,358.6,7,2)
	;;=PATIENT IDENTIFIER^15
	;;^UTILITY(U,$J,358.6,7,3)
	;;=PATIENT PID MAS
	;;^UTILITY(U,$J,358.6,7,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,7,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,8,0)
	;;=DPT PATIENT ELIGIBILITY DATA^ELIG^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,358.6,8,1,0)
	;;=^^8^8^2931015^^^^
	;;^UTILITY(U,$J,358.6,8,1,1,0)
	;;=Returns patient eligibility data. Data returned is:
	;;^UTILITY(U,$J,358.6,8,1,2,0)
	;;=   eligibility code in external form
