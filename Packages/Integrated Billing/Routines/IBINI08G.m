IBINI08G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6,47,1,0)
	;;=^^1^1^2930603^^
	;;^UTILITY(U,$J,357.6,47,1,1,0)
	;;=Gets the name of the division that the clinic belongs to.
	;;^UTILITY(U,$J,357.6,47,2)
	;;=DIVISION NAME^30
	;;^UTILITY(U,$J,357.6,47,3)
	;;=DIVISION PIMS FACILITY
	;;^UTILITY(U,$J,357.6,47,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,47,7,1,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,357.6,48,0)
	;;=SD INSTITUTION NAME^INST^IBDFN1^SCHEDULING^1^2^1^0^1^^^1^^
	;;^UTILITY(U,$J,357.6,48,1,0)
	;;=^^1^1^2930603^^
	;;^UTILITY(U,$J,357.6,48,1,1,0)
	;;=Obtains the name of the institution of the clinic of the appointment.
	;;^UTILITY(U,$J,357.6,48,2)
	;;=INSTITUTION NAME^30
	;;^UTILITY(U,$J,357.6,48,3)
	;;=FACILITY INSTITUTION PIMS MAS SCHEDULING
	;;^UTILITY(U,$J,357.6,48,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,48,7,1,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,357.6,49,0)
	;;=DPT PATIENT SHORT ADDRESS^ADDRESS^IBDFN6^PATIENT FILE^1^2^1^1^1^0^^1
	;;^UTILITY(U,$J,357.6,49,1,0)
	;;=^^2^2^2931014^^^
	;;^UTILITY(U,$J,357.6,49,1,1,0)
	;;=The patient's address shortened to fit on a single line. It consists of the
	;;^UTILITY(U,$J,357.6,49,1,2,0)
	;;=first address line followed by the city, state, and ZIP.
	;;^UTILITY(U,$J,357.6,49,2)
	;;=SHORT ADDRESS - SINGLE LINE^65
	;;^UTILITY(U,$J,357.6,49,3)
	;;=PATIENT SHORT ADDRESS
	;;^UTILITY(U,$J,357.6,49,6,0)
	;;=^357.66^^0
	;;^UTILITY(U,$J,357.6,49,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,49,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,50,0)
	;;=DPT SC HIDDEN LABELS^ELIG^IBDFN^PATIENT FILE^1^2^2^0^1^0^^1^^
	;;^UTILITY(U,$J,357.6,50,1,0)
	;;=^^9^9^2931015^^
	;;^UTILITY(U,$J,357.6,50,1,1,0)
	;;=This interface gives the ability to place labels that refer to SC conditions
	;;^UTILITY(U,$J,357.6,50,1,2,0)
	;;=on the form that won't actually be displayed if the patient is not a 
	;;^UTILITY(U,$J,357.6,50,1,3,0)
	;;=service connected veteran. It consists of a list of possible labels that will
	;;^UTILITY(U,$J,357.6,50,1,4,0)
	;;=only print if the veteran is SLabels returned:
	;;^UTILITY(U,$J,357.6,50,1,5,0)
	;;=  %
	;;^UTILITY(U,$J,357.6,50,1,6,0)
	;;=  % - SERVICE CONNECTED
	;;^UTILITY(U,$J,357.6,50,1,7,0)
	;;=  S/C
	;;^UTILITY(U,$J,357.6,50,1,8,0)
	;;=  SERVICE CONNECTED
	;;^UTILITY(U,$J,357.6,50,1,9,0)
	;;=  SC CONDITIONS:
	;;^UTILITY(U,$J,357.6,50,2)
	;;= % ^1^% - SERVICE CONNECTED^21^SERVICE CONNECTED^17^SC CONDITIONS:^13^S/C^3
	;;^UTILITY(U,$J,357.6,50,3)
	;;=SERVICE CONNECTED HIDDEN LABELS DPT PIMS S/C
	;;^UTILITY(U,$J,357.6,50,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,50,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,51,0)
	;;=DPT SC TREATMENT QUESTIONS^ELIG^IBDFN^PATIENT FILE^1^2^2^0^1^^^1
	;;^UTILITY(U,$J,357.6,51,1,0)
	;;=^^8^8^2931018^^^^
	;;^UTILITY(U,$J,357.6,51,1,1,0)
	;;=Prints questions concerning whether treatment was related to service.
	;;^UTILITY(U,$J,357.6,51,1,2,0)
	;;=Each question is printed only if it applies to the patient. Questions are:
	;;^UTILITY(U,$J,357.6,51,1,3,0)
	;;= 
	;;^UTILITY(U,$J,357.6,51,1,4,0)
	;;=Was treatment for a SC condition? __ YES __ NO
	;;^UTILITY(U,$J,357.6,51,1,5,0)
	;;=Was treatment related to exposure to Agent Orange? __ YES __ NO
	;;^UTILITY(U,$J,357.6,51,1,6,0)
	;;=Was treatment related to exposure to Ionization Radiation? __ YES __ NO
	;;^UTILITY(U,$J,357.6,51,1,7,0)
	;;=Was treatment related to exposure to Environmental Contaminants? __ YES __ NO
	;;^UTILITY(U,$J,357.6,51,1,8,0)
	;;=Was treatment related to: AO __ IR __ EC __
	;;^UTILITY(U,$J,357.6,51,2)
	;;=RELATED TO SC CONDITION?^46^RELATED TO AO?^63^RELATED TO IR?^71^RELATED TO EC?^77^RELATED TO AO,IR, OR EC?^43
