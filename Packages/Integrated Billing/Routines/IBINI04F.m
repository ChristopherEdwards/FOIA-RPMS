IBINI04F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.1,18,10,5,0)
	;;=companies, or hospital-medical plans.
	;;^UTILITY(U,$J,355.1,20,0)
	;;=HOSPITAL EXPENSE INSURANCE^HEI^1
	;;^UTILITY(U,$J,355.1,20,10,0)
	;;=^^2^2^2930604^
	;;^UTILITY(U,$J,355.1,20,10,1,0)
	;;=Health insurance protection against the costs of hospital care
	;;^UTILITY(U,$J,355.1,20,10,2,0)
	;;=resulting from the illness or injury of an insured person.
	;;^UTILITY(U,$J,355.1,22,0)
	;;=INDIVIDUAL PRACTICE ASSOCATION (IPA)^IPA^1
	;;^UTILITY(U,$J,355.1,22,10,0)
	;;=^^3^3^2930604^
	;;^UTILITY(U,$J,355.1,22,10,1,0)
	;;=An organization in which a program administrator contracts with a 
	;;^UTILITY(U,$J,355.1,22,10,2,0)
	;;=number of pysicians who agree to provide treatment to subscribers in
	;;^UTILITY(U,$J,355.1,22,10,3,0)
	;;=their own offices for a fixed capitation payment per month.
	;;^UTILITY(U,$J,355.1,24,0)
	;;=KEY-MAN HEALTH INSURANCE^KMHI^1
	;;^UTILITY(U,$J,355.1,24,10,0)
	;;=^^5^5^2930604^
	;;^UTILITY(U,$J,355.1,24,10,1,0)
	;;=An individual or group insurance policy designed to protect an essential
	;;^UTILITY(U,$J,355.1,24,10,2,0)
	;;=employee or employees of a firm against the loss of income resulting
	;;^UTILITY(U,$J,355.1,24,10,3,0)
	;;=from disability.  If desired, it may be written for the benefit of 
	;;^UTILITY(U,$J,355.1,24,10,4,0)
	;;=the employer, who usually continues to pay the salary during periods 
	;;^UTILITY(U,$J,355.1,24,10,5,0)
	;;=of disability.
	;;^UTILITY(U,$J,355.1,27,0)
	;;=MAJOR MEDICAL EXPENSE INSURANCE^MMEI^1
	;;^UTILITY(U,$J,355.1,27,10,0)
	;;=^^11^11^2930604^
	;;^UTILITY(U,$J,355.1,27,10,1,0)
	;;=Health insurance to finance the expense of major illnesses and
	;;^UTILITY(U,$J,355.1,27,10,2,0)
	;;=injuries.  Major medical policies usually include a deductible
	;;^UTILITY(U,$J,355.1,27,10,3,0)
	;;=clause, which means that the individual or another insurer 
	;;^UTILITY(U,$J,355.1,27,10,4,0)
	;;=contributes toward the cost of the medical expenses.  The
	;;^UTILITY(U,$J,355.1,27,10,5,0)
	;;=larger the deductible, the greater the savings in premium cost.
	;;^UTILITY(U,$J,355.1,27,10,6,0)
	;;=Above this initial deductible, major medical insurance is 
	;;^UTILITY(U,$J,355.1,27,10,7,0)
	;;=characterized by large benefit maximums, ranging up to $25,000
	;;^UTILITY(U,$J,355.1,27,10,8,0)
	;;=or even beyond.  The holder is reimbursed for the major part
	;;^UTILITY(U,$J,355.1,27,10,9,0)
	;;=of all charges for the hospital, the doctor, private nurse, medical 
	;;^UTILITY(U,$J,355.1,27,10,10,0)
	;;=appliances, and prescribed out-of-hospital treatment, drugs, and 
	;;^UTILITY(U,$J,355.1,27,10,11,0)
	;;=medicines.
	;;^UTILITY(U,$J,355.1,28,0)
	;;=MANAGED CARE SYSTEM (MCS)^MCS^1
	;;^UTILITY(U,$J,355.1,28,10,0)
	;;=^^4^4^2930604^
	;;^UTILITY(U,$J,355.1,28,10,1,0)
	;;=A self-administered, self-insured program that is an agreement
	;;^UTILITY(U,$J,355.1,28,10,2,0)
	;;=between the employer and the employee.  The employee may choose
	;;^UTILITY(U,$J,355.1,28,10,3,0)
	;;=the provider.  Once a procedure or service has been approved,
	;;^UTILITY(U,$J,355.1,28,10,4,0)
	;;=the physician is free to charge his or her regular fee.
	;;^UTILITY(U,$J,355.1,29,0)
	;;=MEDICAID^MD^6
	;;^UTILITY(U,$J,355.1,29,10,0)
	;;=^^3^3^2930604^
	;;^UTILITY(U,$J,355.1,29,10,1,0)
	;;=A plan sponsored jointly by the federal and state governments for
	;;^UTILITY(U,$J,355.1,29,10,2,0)
	;;=people eligible for public assistance and some other low-income
	;;^UTILITY(U,$J,355.1,29,10,3,0)
	;;=people.  Coverage and benefits vary widely from state to state.
