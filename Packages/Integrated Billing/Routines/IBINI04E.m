IBINI04E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.1)
	;;=^IBE(355.1,
	;;^UTILITY(U,$J,355.1,0)
	;;=TYPE OF PLAN^355.1I^60^38
	;;^UTILITY(U,$J,355.1,1,0)
	;;=ACCIDENT AND HEALTH INSURANCE^ACCIDENT^1
	;;^UTILITY(U,$J,355.1,1,10,0)
	;;=^^2^2^2930603^
	;;^UTILITY(U,$J,355.1,1,10,1,0)
	;;=Insurance under which benefits are payable in case of disease,
	;;^UTILITY(U,$J,355.1,1,10,2,0)
	;;=accidental injury, or accidental death.
	;;^UTILITY(U,$J,355.1,2,0)
	;;=AVIATION TRIP INSURANCE^AVIATION^1
	;;^UTILITY(U,$J,355.1,2,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,2,10,1,0)
	;;=A short-term policy protecting individuals as passengers on scheduled
	;;^UTILITY(U,$J,355.1,2,10,2,0)
	;;=airline flights.  It is generally obtained at airports.
	;;^UTILITY(U,$J,355.1,3,0)
	;;=BLUE CROSS/BLUE SHIELD^BCBS^1
	;;^UTILITY(U,$J,355.1,3,10,0)
	;;=^^4^4^2930603^
	;;^UTILITY(U,$J,355.1,3,10,1,0)
	;;=An independent, not-for-profit membership corporation providing
	;;^UTILITY(U,$J,355.1,3,10,2,0)
	;;=protection against the costs of hospital care (Blue Cross) and
	;;^UTILITY(U,$J,355.1,3,10,3,0)
	;;=against the costs of surgery and other items of medical care
	;;^UTILITY(U,$J,355.1,3,10,4,0)
	;;=(Blue Shield).
	;;^UTILITY(U,$J,355.1,5,0)
	;;=CATASTROPHIC INSURANCE^CI^1
	;;^UTILITY(U,$J,355.1,5,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,5,10,1,0)
	;;=Insurance against catastrophic illness.
	;;^UTILITY(U,$J,355.1,6,0)
	;;=CHAMPUS^CPS^7
	;;^UTILITY(U,$J,355.1,6,10,0)
	;;=^^4^4^2940111^
	;;^UTILITY(U,$J,355.1,6,10,1,0)
	;;=A government-sponsored program that provides hospital and medical
	;;^UTILITY(U,$J,355.1,6,10,2,0)
	;;=services for dependents of active service, retired service personnel
	;;^UTILITY(U,$J,355.1,6,10,3,0)
	;;=and their dependents, and dependents of deceased members who died in
	;;^UTILITY(U,$J,355.1,6,10,4,0)
	;;=active duty.
	;;^UTILITY(U,$J,355.1,7,0)
	;;=COINSURANCE^COINS^1
	;;^UTILITY(U,$J,355.1,7,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,7,10,1,0)
	;;=A plan under which the insured and the insurer share hospital and
	;;^UTILITY(U,$J,355.1,7,10,2,0)
	;;=medical expenses resulting from illness or injury.  Sometimes seen in
	;;^UTILITY(U,$J,355.1,7,10,3,0)
	;;=major medical insurance.
	;;^UTILITY(U,$J,355.1,8,0)
	;;=COMPREHENSIVE MAJOR MEDICAL^CMM^1
	;;^UTILITY(U,$J,355.1,8,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,8,10,1,0)
	;;=A policy designed to give the protection offered by both a basic
	;;^UTILITY(U,$J,355.1,8,10,2,0)
	;;=and a major medical health insurance policy.
	;;^UTILITY(U,$J,355.1,9,0)
	;;=DENTAL INSURANCE^DENIN^2
	;;^UTILITY(U,$J,355.1,9,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,9,10,1,0)
	;;=A form of insurance that provides protectio against the costs of 
	;;^UTILITY(U,$J,355.1,9,10,2,0)
	;;=diagnostic and preventive dental care as well as oral surgery,
	;;^UTILITY(U,$J,355.1,9,10,3,0)
	;;=restorative procedures, and therapeutic dental care.
	;;^UTILITY(U,$J,355.1,12,0)
	;;=DUAL COVERAGE^DC
	;;^UTILITY(U,$J,355.1,12,10,0)
	;;=
	;;^UTILITY(U,$J,355.1,12,10,1,0)
	;;=A plan under which the insured has health insurance coverage from
	;;^UTILITY(U,$J,355.1,12,10,2,0)
	;;=more than one carrier.
	;;^UTILITY(U,$J,355.1,18,0)
	;;=HEALTH MAINTENANCE ORGANIZ^HMO^1
	;;^UTILITY(U,$J,355.1,18,10,0)
	;;=^^5^5^2940105^
	;;^UTILITY(U,$J,355.1,18,10,1,0)
	;;=An organization that provides for a wide range of comprehensive
	;;^UTILITY(U,$J,355.1,18,10,2,0)
	;;=health care services for a specified group at a fixed periodic
	;;^UTILITY(U,$J,355.1,18,10,3,0)
	;;=payment.  An HMO can be sponsored by the government, medical schools,
	;;^UTILITY(U,$J,355.1,18,10,4,0)
	;;=hospitals, employers, labor unions, consumer groups, insurance
