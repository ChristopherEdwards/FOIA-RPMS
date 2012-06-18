IBINI04M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.2,8,10,0)
	;;=^^3^3^2930603^
	;;^UTILITY(U,$J,355.2,8,10,1,0)
	;;=A form of health insurance that provides periodic payments to replace
	;;^UTILITY(U,$J,355.2,8,10,2,0)
	;;=income when the insured is unable to work as a result of illness,
	;;^UTILITY(U,$J,355.2,8,10,3,0)
	;;=injury or disease.
	;;^UTILITY(U,$J,355.2,9,0)
	;;=HEALTH MAINTENANCE ORG.^HMO
	;;^UTILITY(U,$J,355.2,9,10,0)
	;;=^^5^5^2940105^^
	;;^UTILITY(U,$J,355.2,9,10,1,0)
	;;=An organization that provides a wide range of comprehensive health
	;;^UTILITY(U,$J,355.2,9,10,2,0)
	;;=care services for a specified group at a fixed periodic payment. 
	;;^UTILITY(U,$J,355.2,9,10,3,0)
	;;=An HMO can be sponsored by the government, medical schools,
	;;^UTILITY(U,$J,355.2,9,10,4,0)
	;;=hospitals, employers, labor unions, consumer groups, insurance companies,
	;;^UTILITY(U,$J,355.2,9,10,5,0)
	;;=or hospital-medical plans.
	;;^UTILITY(U,$J,355.2,10,0)
	;;=MEDICAID^MCD
	;;^UTILITY(U,$J,355.2,10,10,0)
	;;=^^4^4^2930604^^
	;;^UTILITY(U,$J,355.2,10,10,1,0)
	;;=A plan sponsored jointly by the federal and state governments for
	;;^UTILITY(U,$J,355.2,10,10,2,0)
	;;=people eligible for public assistance and some other low-income people.
	;;^UTILITY(U,$J,355.2,10,10,3,0)
	;;=Coverage and benefits vary widely from state to state.  In California,
	;;^UTILITY(U,$J,355.2,10,10,4,0)
	;;=this program is known as Medi-Cal.
	;;^UTILITY(U,$J,355.2,13,0)
	;;=WORKERS' COMPENSATION^WC
	;;^UTILITY(U,$J,355.2,13,10,0)
	;;=^^2^2^2930603^
	;;^UTILITY(U,$J,355.2,13,10,1,0)
	;;=A contract that insures a person against on-the-job injury or illness.
	;;^UTILITY(U,$J,355.2,13,10,2,0)
	;;=The employer pays the premium for his or her employees.
	;;^UTILITY(U,$J,355.2,14,0)
	;;=MEDI-CAL^MCL
	;;^UTILITY(U,$J,355.2,14,10,0)
	;;=^^1^1^2930603^
	;;^UTILITY(U,$J,355.2,14,10,1,0)
	;;=California's version of the nationwide program known as Medicaid.
	;;^UTILITY(U,$J,355.2,15,0)
	;;=INDEMNITY^IN
	;;^UTILITY(U,$J,355.2,15,10,0)
	;;=^^2^2^2940226^^
	;;^UTILITY(U,$J,355.2,15,10,1,0)
	;;=A form of health insurance that provides periodic payments when the
	;;^UTILITY(U,$J,355.2,15,10,2,0)
	;;=insured is disabled and in the hospital.
	;;^UTILITY(U,$J,355.2,16,0)
	;;=MENTAL HEALTH ONLY^MHO
	;;^UTILITY(U,$J,355.2,16,10,0)
	;;=^^1^1^2940105^
	;;^UTILITY(U,$J,355.2,16,10,1,0)
	;;= A form of health insurance that provides mental health benefits only.
	;;^UTILITY(U,$J,355.2,17,0)
	;;=PRESCRIPTION ONLY^PO
	;;^UTILITY(U,$J,355.2,17,10,0)
	;;=^^1^1^2940105^
	;;^UTILITY(U,$J,355.2,17,10,1,0)
	;;=A form of health insurance that provides prescription benefits only.
	;;^UTILITY(U,$J,355.2,18,0)
	;;=SUBSTANCE ABUSE ONLY^SAO
	;;^UTILITY(U,$J,355.2,18,10,0)
	;;=^^1^1^2940105^
	;;^UTILITY(U,$J,355.2,18,10,1,0)
	;;=A form of health insurance that provides drug/alcohol abuse benefits only.
	;;^UTILITY(U,$J,355.2,19,0)
	;;=TORT/FEASOR^TF
	;;^UTILITY(U,$J,355.2,19,10,0)
	;;=^^2^2^2940105^
	;;^UTILITY(U,$J,355.2,19,10,1,0)
	;;=A form of health insurance that pays for injuries resulting from a third
	;;^UTILITY(U,$J,355.2,19,10,2,0)
	;;=party's negligence.
