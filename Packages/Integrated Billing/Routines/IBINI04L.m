IBINI04L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.2)
	;;=^IBE(355.2,
	;;^UTILITY(U,$J,355.2,0)
	;;=TYPE OF INSURANCE COVERAGE^355.2^19^17
	;;^UTILITY(U,$J,355.2,1,0)
	;;=HEALTH INSURANCE^HI
	;;^UTILITY(U,$J,355.2,1,10,0)
	;;=^^3^3^2930603^
	;;^UTILITY(U,$J,355.2,1,10,1,0)
	;;=The insurance company is generally associated with more than one type
	;;^UTILITY(U,$J,355.2,1,10,2,0)
	;;=of coverage.  The term "HEALTH INSURANCE" encompasses all of the
	;;^UTILITY(U,$J,355.2,1,10,3,0)
	;;=company's types of coverage.
	;;^UTILITY(U,$J,355.2,2,0)
	;;=MEDICARE^MCR
	;;^UTILITY(U,$J,355.2,2,10,0)
	;;=^^6^6^2930603^
	;;^UTILITY(U,$J,355.2,2,10,1,0)
	;;=The hospital insurance system and supplementary medical insurance for
	;;^UTILITY(U,$J,355.2,2,10,2,0)
	;;=those over 65 created by the 1965 Amendments to the Social Security
	;;^UTILITY(U,$J,355.2,2,10,3,0)
	;;=Act and operated under the provisions of the act.  Benefits are also
	;;^UTILITY(U,$J,355.2,2,10,4,0)
	;;=extended to certain disabled people (e.g., totally disabled or blind)
	;;^UTILITY(U,$J,355.2,2,10,5,0)
	;;=as well as coverage and payment for those requiring kidney dialysis
	;;^UTILITY(U,$J,355.2,2,10,6,0)
	;;=and kidney transplant services.
	;;^UTILITY(U,$J,355.2,3,0)
	;;=MEDIGAP^MGP
	;;^UTILITY(U,$J,355.2,3,10,0)
	;;=^^2^2^2930603^
	;;^UTILITY(U,$J,355.2,3,10,1,0)
	;;=Supplemental insurance designed to fill in some, though never all,
	;;^UTILITY(U,$J,355.2,3,10,2,0)
	;;=of the gaps in Medicare's coverage.  Also known as Medifill.
	;;^UTILITY(U,$J,355.2,4,0)
	;;=BLUE CROSS^BC
	;;^UTILITY(U,$J,355.2,4,10,0)
	;;=^^3^3^2930604^^
	;;^UTILITY(U,$J,355.2,4,10,1,0)
	;;=An independent, not-for-profit membership corporation providing
	;;^UTILITY(U,$J,355.2,4,10,2,0)
	;;=protection against the costs of hospital care and, in some policies,
	;;^UTILITY(U,$J,355.2,4,10,3,0)
	;;=protection against the costs of surgical and professional care.
	;;^UTILITY(U,$J,355.2,5,0)
	;;=BLUE SHIELD^BS
	;;^UTILITY(U,$J,355.2,5,10,0)
	;;=^^4^4^2930604^^
	;;^UTILITY(U,$J,355.2,5,10,1,0)
	;;=An independent, not-for-profit membership association providing 
	;;^UTILITY(U,$J,355.2,5,10,2,0)
	;;=protection against the costs of surgery and other items of medical
	;;^UTILITY(U,$J,355.2,5,10,3,0)
	;;=care.  Some policies also offer protection against the costs of
	;;^UTILITY(U,$J,355.2,5,10,4,0)
	;;=hospital care.
	;;^UTILITY(U,$J,355.2,6,0)
	;;=CHAMPUS^CHS
	;;^UTILITY(U,$J,355.2,6,10,0)
	;;=^^5^5^2930604^^
	;;^UTILITY(U,$J,355.2,6,10,1,0)
	;;=The Civilian Health and Medical Program of the Uniformed Services.
	;;^UTILITY(U,$J,355.2,6,10,2,0)
	;;=This government-sponsored program provides hospital and medical
	;;^UTILITY(U,$J,355.2,6,10,3,0)
	;;=services for dependents of active service personnel, retired service
	;;^UTILITY(U,$J,355.2,6,10,4,0)
	;;=personnel and their dependents, and dependents of members who died
	;;^UTILITY(U,$J,355.2,6,10,5,0)
	;;=in active duty.
	;;^UTILITY(U,$J,355.2,7,0)
	;;=CHAMPVA^CHV
	;;^UTILITY(U,$J,355.2,7,10,0)
	;;=^^5^5^2940105^^
	;;^UTILITY(U,$J,355.2,7,10,1,0)
	;;=The Civilian Health and Medical Program of the Veterans Administration.
	;;^UTILITY(U,$J,355.2,7,10,2,0)
	;;=The Veterans Administration shares the medical bills of spouses and
	;;^UTILITY(U,$J,355.2,7,10,3,0)
	;;=children of veterans with total, permanent, service-connected
	;;^UTILITY(U,$J,355.2,7,10,4,0)
	;;=disabilities or of the surviving spouses and children of veterans who
	;;^UTILITY(U,$J,355.2,7,10,5,0)
	;;=died as a result of service-connected disabilities.
	;;^UTILITY(U,$J,355.2,8,0)
	;;=DISABILITY INCOME INSURANCE^DII
