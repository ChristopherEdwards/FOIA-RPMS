IBINI04G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.1,30,0)
	;;=MEDI-CAL^MCAL^6
	;;^UTILITY(U,$J,355.1,30,10,0)
	;;=^^1^1^2930604^
	;;^UTILITY(U,$J,355.1,30,10,1,0)
	;;=California's version of the nationwide program known as Medicaid.
	;;^UTILITY(U,$J,355.1,32,0)
	;;=MEDICAL EXPENSE INSURANCE^MEI^1
	;;^UTILITY(U,$J,355.1,32,10,0)
	;;=^^5^5^2940111^^
	;;^UTILITY(U,$J,355.1,32,10,1,0)
	;;=A form of health insurance that provides benefits for medical care
	;;^UTILITY(U,$J,355.1,32,10,2,0)
	;;=on an outpatient basis.  The company may limit the amount it will
	;;^UTILITY(U,$J,355.1,32,10,3,0)
	;;=pay per call or the total amount for all calls.  It may also exclude
	;;^UTILITY(U,$J,355.1,32,10,4,0)
	;;=the first few calls made by the physician at the beginning of an
	;;^UTILITY(U,$J,355.1,32,10,5,0)
	;;=illness.
	;;^UTILITY(U,$J,355.1,33,0)
	;;=MEDICARE (M)^MR^5
	;;^UTILITY(U,$J,355.1,33,10,0)
	;;=^^4^4^2930604^
	;;^UTILITY(U,$J,355.1,33,10,1,0)
	;;=The hospital insurance system and supplementary medical insurance for 
	;;^UTILITY(U,$J,355.1,33,10,2,0)
	;;=the aged created by the 1965 Amendments to the Social Security Act 
	;;^UTILITY(U,$J,355.1,33,10,3,0)
	;;=and operated under the provisions of the act.  Benefits are also
	;;^UTILITY(U,$J,355.1,33,10,4,0)
	;;=extended to the totally disabled and the blind.
	;;^UTILITY(U,$J,355.1,34,0)
	;;=MEDICARE/MEDICAID (MEDI-CAL)^MM^5
	;;^UTILITY(U,$J,355.1,34,10,0)
	;;=^^2^2^2930604^
	;;^UTILITY(U,$J,355.1,34,10,1,0)
	;;=This program, also known as Medi-Medi, covers those persons
	;;^UTILITY(U,$J,355.1,34,10,2,0)
	;;=protected under both Medicare and Medicaid (or Medi-Cal).
	;;^UTILITY(U,$J,355.1,35,0)
	;;=MEDIGAP INSURANCE^MG^11
	;;^UTILITY(U,$J,355.1,35,10,0)
	;;=^^2^2^2931008^^^^
	;;^UTILITY(U,$J,355.1,35,10,1,0)
	;;=Supplemental insurance designed to fill in some, though never all,
	;;^UTILITY(U,$J,355.1,35,10,2,0)
	;;=of the gaps in Medicare's coverage.  Also known as Medifill.
	;;^UTILITY(U,$J,355.1,36,0)
	;;=NO-FAULT INSURANCE^^1
	;;^UTILITY(U,$J,355.1,36,10,0)
	;;=^^4^4^2930604^
	;;^UTILITY(U,$J,355.1,36,10,1,0)
	;;=Automobile insurance that provides coverage against injury or other
	;;^UTILITY(U,$J,355.1,36,10,2,0)
	;;=loss without the need to determine responsibility for an accident.
	;;^UTILITY(U,$J,355.1,36,10,3,0)
	;;=Coverage and benefits vary widely; at present plans exist in many
	;;^UTILITY(U,$J,355.1,36,10,4,0)
	;;=states.
	;;^UTILITY(U,$J,355.1,40,0)
	;;=PREFERRED PROVIDER ORGANIZATION (PPO)^PPO^4
	;;^UTILITY(U,$J,355.1,40,10,0)
	;;=^^4^4^2930604^^
	;;^UTILITY(U,$J,355.1,40,10,1,0)
	;;=An entity that serves as a broker to contract for comprehensive
	;;^UTILITY(U,$J,355.1,40,10,2,0)
	;;=health care services, with both hospitals and physicians, on
	;;^UTILITY(U,$J,355.1,40,10,3,0)
	;;=behalf of an employer or other specific groups of patients,
	;;^UTILITY(U,$J,355.1,40,10,4,0)
	;;=at prearranged discounted rates or on a fee schedule.
	;;^UTILITY(U,$J,355.1,41,0)
	;;=PREPAID GROUP PRACTICE PLAN^PGPP^3
	;;^UTILITY(U,$J,355.1,41,10,0)
	;;=^^8^8^2930604^^
	;;^UTILITY(U,$J,355.1,41,10,1,0)
	;;=A plan under which specified health services are rendered by
	;;^UTILITY(U,$J,355.1,41,10,2,0)
	;;=participating physicians to an enrolled group of persons, with
	;;^UTILITY(U,$J,355.1,41,10,3,0)
	;;=fixed periodic payments made in advance, by or on behalf of
	;;^UTILITY(U,$J,355.1,41,10,4,0)
	;;=each person or family.  If a health insurance carrier is
	;;^UTILITY(U,$J,355.1,41,10,5,0)
	;;=involved, it contracts to pay in advance for the full range 
	;;^UTILITY(U,$J,355.1,41,10,6,0)
	;;=of health services to which the insured is entitled under
