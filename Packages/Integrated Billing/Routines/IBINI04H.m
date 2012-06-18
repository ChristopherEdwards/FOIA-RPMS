IBINI04H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.1,41,10,7,0)
	;;=the terms of the health insurance contract.  Such a plan is
	;;^UTILITY(U,$J,355.1,41,10,8,0)
	;;=one form of a Health maintenance organization.
	;;^UTILITY(U,$J,355.1,42,0)
	;;=QUALIFIED IMPAIRMENT INSURANCE^QII
	;;^UTILITY(U,$J,355.1,42,10,0)
	;;=2
	;;^UTILITY(U,$J,355.1,42,10,1,0)
	;;=A form of substandard or special class insurance that restricts
	;;^UTILITY(U,$J,355.1,42,10,2,0)
	;;=benefits to the insured's particular condition.
	;;^UTILITY(U,$J,355.1,43,0)
	;;=REGULAR MEDICAL EXPENSE INSURANCE^RMEI
	;;^UTILITY(U,$J,355.1,43,10,0)
	;;=^^4^4^2930604^^
	;;^UTILITY(U,$J,355.1,43,10,1,0)
	;;=Coverage that provides benefits toward the cost of such services as
	;;^UTILITY(U,$J,355.1,43,10,2,0)
	;;=doctor fees for nonsurgical care in the hospital, at home, or in a
	;;^UTILITY(U,$J,355.1,43,10,3,0)
	;;=physician's office and x-rays or laboratory tests performed outside
	;;^UTILITY(U,$J,355.1,43,10,4,0)
	;;=of the hospital.
	;;^UTILITY(U,$J,355.1,44,0)
	;;=SENIOR CITIZEN POLICIES^SCP^1
	;;^UTILITY(U,$J,355.1,44,10,0)
	;;=^^3^3^2930604^
	;;^UTILITY(U,$J,355.1,44,10,1,0)
	;;=Contracts insuring persons 65 years of age or over.  In most cases
	;;^UTILITY(U,$J,355.1,44,10,2,0)
	;;=these policies supplement the coverage afforded by the government
	;;^UTILITY(U,$J,355.1,44,10,3,0)
	;;=under Medicare.
	;;^UTILITY(U,$J,355.1,46,0)
	;;=SPECIAL CLASS INSURANCE^SCI^1
	;;^UTILITY(U,$J,355.1,46,10,0)
	;;=^^2^2^2930604^
	;;^UTILITY(U,$J,355.1,46,10,1,0)
	;;=Coverage for health insurance applicants who cannot qualify for
	;;^UTILITY(U,$J,355.1,46,10,2,0)
	;;=a standard policy because of their health.
	;;^UTILITY(U,$J,355.1,47,0)
	;;=SPECIAL RISK INSURANCE^SRI^1
	;;^UTILITY(U,$J,355.1,47,10,0)
	;;=^^1^1^2930604^
	;;^UTILITY(U,$J,355.1,47,10,1,0)
	;;=Coverage for risks or hazards of a special or unusual nature.
	;;^UTILITY(U,$J,355.1,48,0)
	;;=SPECIFIED DISEASE INSURANCE^SDI^1
	;;^UTILITY(U,$J,355.1,48,10,0)
	;;=^^3^3^2930604^
	;;^UTILITY(U,$J,355.1,48,10,1,0)
	;;=A policy that provides benefits, usually of large amounts, toward
	;;^UTILITY(U,$J,355.1,48,10,2,0)
	;;=the expense of the treatment of the disease or diseases named in 
	;;^UTILITY(U,$J,355.1,48,10,3,0)
	;;=the policy.
	;;^UTILITY(U,$J,355.1,50,0)
	;;=SURGICAL EXPENSE INSURANCE^SEI^1
	;;^UTILITY(U,$J,355.1,50,10,0)
	;;=^^3^3^2930604^
	;;^UTILITY(U,$J,355.1,50,10,1,0)
	;;=A health insurance policy that provides benefits toward the doctor's
	;;^UTILITY(U,$J,355.1,50,10,2,0)
	;;=operating fees.  Benefits usually consist of scheduled amounts for
	;;^UTILITY(U,$J,355.1,50,10,3,0)
	;;=each surgical procedure.
	;;^UTILITY(U,$J,355.1,54,0)
	;;=WORKERS' COMPENSATION INSURANCE^WCI^8
	;;^UTILITY(U,$J,355.1,54,10,0)
	;;=^^2^2^2930604^
	;;^UTILITY(U,$J,355.1,54,10,1,0)
	;;=A contract that insures a person against on-the-job injury or
	;;^UTILITY(U,$J,355.1,54,10,2,0)
	;;=illness.  The employer pays the premium for his or her employees.
	;;^UTILITY(U,$J,355.1,55,0)
	;;=LABS, PROCEDURES, X-RAY, ETC. (ONLY)^LP^12
	;;^UTILITY(U,$J,355.1,55,10,0)
	;;=^^1^1^2940105^
	;;^UTILITY(U,$J,355.1,55,10,1,0)
	;;=Insurance policy that pays only for labs, procedures, X-rays, etc.
	;;^UTILITY(U,$J,355.1,56,0)
	;;=INDEMNITY^IN^9
	;;^UTILITY(U,$J,355.1,56,10,0)
	;;=^^2^2^2940226^^
	;;^UTILITY(U,$J,355.1,56,10,1,0)
	;;=A form of health insurance that pays for injuries resulting from a
	;;^UTILITY(U,$J,355.1,56,10,2,0)
	;;=third party's negligence.
	;;^UTILITY(U,$J,355.1,57,0)
	;;=PRESCRIPTION ONLY^Rx Plan^10
	;;^UTILITY(U,$J,355.1,57,10,0)
	;;=^^1^1^2940111^^
