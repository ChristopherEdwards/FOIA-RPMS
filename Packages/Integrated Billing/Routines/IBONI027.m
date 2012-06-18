IBONI027	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",954,0)
	;;=IBCNSA AN BEN REHAB^Rehab^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",954,4)
	;;=^^^RH
	;;^UTILITY(U,$J,"PRO",954,15)
	;;=S VALMBG=29
	;;^UTILITY(U,$J,"PRO",954,20)
	;;=D ED^IBCNSA2("[IBCN AB REHAB]")
	;;^UTILITY(U,$J,"PRO",954,99)
	;;=55768,35731
	;;^UTILITY(U,$J,"PRO",955,0)
	;;=IBCNSA AN BEN IV MGMT^IV Mgmt.^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",955,4)
	;;=^^^IV
	;;^UTILITY(U,$J,"PRO",955,15)
	;;=S VALMBG=29
	;;^UTILITY(U,$J,"PRO",955,20)
	;;=D ED^IBCNSA2("[IBCN AB IV MGMT]")
	;;^UTILITY(U,$J,"PRO",955,99)
	;;=55768,35730
	;;^UTILITY(U,$J,"PRO",956,0)
	;;=IBCN NEW INSURANCE EVENTS^IB New Insurnace Event Driver^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",956,1,0)
	;;=^^3^3^2930829^^^
	;;^UTILITY(U,$J,"PRO",956,1,1,0)
	;;=This event driver will be invoked whenever a new insurance type entry is
	;;^UTILITY(U,$J,"PRO",956,1,2,0)
	;;=created in the patient file.  The is so that necessary actions can take
	;;^UTILITY(U,$J,"PRO",956,1,3,0)
	;;=place when a new insurance policy is added for a patient.
	;;^UTILITY(U,$J,"PRO",956,4)
	;;=^^^IBCNS
	;;^UTILITY(U,$J,"PRO",956,10,0)
	;;=^101.01PA^1^1
	;;^UTILITY(U,$J,"PRO",956,10,1,0)
	;;=957^^1
	;;^UTILITY(U,$J,"PRO",956,10,1,"^")
	;;=IBCN INSURANCE BULLETIN
	;;^UTILITY(U,$J,"PRO",956,99)
	;;=55768,35728
	;;^UTILITY(U,$J,"PRO",957,0)
	;;=IBCN INSURANCE BULLETIN^New Insurance Bulletin^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",957,1,0)
	;;=^^2^2^2930829^^
	;;^UTILITY(U,$J,"PRO",957,1,1,0)
	;;=This protocol will send a bulletin when ever new insurance policies are 
	;;^UTILITY(U,$J,"PRO",957,1,2,0)
	;;=added and there is covered care that may now be billable.
	;;^UTILITY(U,$J,"PRO",957,15)
	;;=D ^IBCNSBL
	;;^UTILITY(U,$J,"PRO",957,99)
	;;=55768,35727
	;;^UTILITY(U,$J,"PRO",958,0)
	;;=IBTRE  MENU^Claims Tracked Editor Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",958,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",958,10,0)
	;;=^101.01PA^16^16
	;;^UTILITY(U,$J,"PRO",958,10,1,0)
	;;=959^CP^32
	;;^UTILITY(U,$J,"PRO",958,10,1,"^")
	;;=IBTRE CHANGE PATIENT
	;;^UTILITY(U,$J,"PRO",958,10,2,0)
	;;=960^AT^11
	;;^UTILITY(U,$J,"PRO",958,10,2,"^")
	;;=IBTRE ADD TRACKING
	;;^UTILITY(U,$J,"PRO",958,10,3,0)
	;;=961^DT^12
	;;^UTILITY(U,$J,"PRO",958,10,3,"^")
	;;=IBTRE DELETE TRACKING
	;;^UTILITY(U,$J,"PRO",958,10,4,0)
	;;=963^QE^13
	;;^UTILITY(U,$J,"PRO",958,10,4,"^")
	;;=IBTRE QUICK EDIT
	;;^UTILITY(U,$J,"PRO",958,10,5,0)
	;;=965^VE^20
	;;^UTILITY(U,$J,"PRO",958,10,5,"^")
	;;=IBTRE VIEW/EDIT TRACKING
	;;^UTILITY(U,$J,"PRO",958,10,6,0)
	;;=962^HR^21
	;;^UTILITY(U,$J,"PRO",958,10,6,"^")
	;;=IBTRE EDIT REVIEWS
	;;^UTILITY(U,$J,"PRO",958,10,7,0)
	;;=964^IR^22
	;;^UTILITY(U,$J,"PRO",958,10,7,"^")
	;;=IBTRE COMMUNICATIONS EDIT
	;;^UTILITY(U,$J,"PRO",958,10,8,0)
	;;=966^AE^31
	;;^UTILITY(U,$J,"PRO",958,10,8,"^")
	;;=IBTRE DENIALS/APPEALS
	;;^UTILITY(U,$J,"PRO",958,10,9,0)
	;;=967^CD^34
	;;^UTILITY(U,$J,"PRO",958,10,9,"^")
	;;=IBTRE CHANGE DATE
	;;^UTILITY(U,$J,"PRO",958,10,10,0)
	;;=1033^AC^14
	;;^UTILITY(U,$J,"PRO",958,10,10,"^")
	;;=IBTRE ASSIGN CASE
	;;^UTILITY(U,$J,"PRO",958,10,11,0)
	;;=1036^SC^25
	;;^UTILITY(U,$J,"PRO",958,10,11,"^")
	;;=IBTRE SHOW SC CONDITIONS
	;;^UTILITY(U,$J,"PRO",958,10,12,0)
	;;=1040^DU^35
	;;^UTILITY(U,$J,"PRO",958,10,12,"^")
	;;=IBTRE DIAGNOSIS UPDATE
	;;^UTILITY(U,$J,"PRO",958,10,13,0)
	;;=927^EX^41
	;;^UTILITY(U,$J,"PRO",958,10,13,"^")
	;;=IBCNS EXIT
	;;^UTILITY(U,$J,"PRO",958,10,14,0)
	;;=1044^PU^36
	;;^UTILITY(U,$J,"PRO",958,10,14,"^")
	;;=IBTRE PROCEDURE UPDATE
	;;^UTILITY(U,$J,"PRO",958,10,15,0)
	;;=1050^PV^37
