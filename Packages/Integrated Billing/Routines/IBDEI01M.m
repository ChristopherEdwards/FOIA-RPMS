IBDEI01M	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.6,13,1,5,0)
	;;=    policy number
	;;^UTILITY(U,$J,358.6,13,1,6,0)
	;;=    group name
	;;^UTILITY(U,$J,358.6,13,1,7,0)
	;;=    policy holder's relationship to the patient
	;;^UTILITY(U,$J,358.6,13,1,8,0)
	;;=    policy expiration date
	;;^UTILITY(U,$J,358.6,13,1,9,0)
	;;=    group number
	;;^UTILITY(U,$J,358.6,13,1,10,0)
	;;=    name of insured
	;;^UTILITY(U,$J,358.6,13,2)
	;;=INSURANCE COMPANY^30^EXPIRATION DATE^12^POLICY NUMBER^20^GROUP NUMBER^17^GROUP NAME^20^NAME OF INSURED^30^HOLDER'S RELATIONSHIP^9
	;;^UTILITY(U,$J,358.6,13,3)
	;;=PATIENT INSURANCE MAS PIMS
	;;^UTILITY(U,$J,358.6,13,4)
	;;=S ACT=2
	;;^UTILITY(U,$J,358.6,13,6,0)
	;;=^357.66^1^1
	;;^UTILITY(U,$J,358.6,13,6,1,0)
	;;=ACT
	;;^UTILITY(U,$J,358.6,13,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,13,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,14,0)
	;;=SD INSTITUTION NAME^INST^IBDFN1^SCHEDULING^1^2^1^0^1^^^1^^
	;;^UTILITY(U,$J,358.6,14,1,0)
	;;=^^1^1^2930603^^
	;;^UTILITY(U,$J,358.6,14,1,1,0)
	;;=Obtains the name of the institution of the clinic of the appointment.
	;;^UTILITY(U,$J,358.6,14,2)
	;;=INSTITUTION NAME^30
	;;^UTILITY(U,$J,358.6,14,3)
	;;=FACILITY INSTITUTION PIMS MAS SCHEDULING
	;;^UTILITY(U,$J,358.6,14,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,14,7,1,0)
	;;=IBCLINIC
	;;^UTILITY(U,$J,358.6,15,0)
	;;=GMRA PATIENT'S ALLERGIES^ALLERGY^IBDFN2^ALLERGY^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,358.6,15,1,0)
	;;=^^7^7^2931015^^
	;;^UTILITY(U,$J,358.6,15,1,1,0)
	;;=Used to disply a list of the patient's allergies, both true and adverse
	;;^UTILITY(U,$J,358.6,15,1,2,0)
	;;=reactions, verified and unverified. Data returned:
	;;^UTILITY(U,$J,358.6,15,1,3,0)
	;;=  allergy name
	;;^UTILITY(U,$J,358.6,15,1,4,0)
	;;=  type of allergen
	;;^UTILITY(U,$J,358.6,15,1,5,0)
	;;=  type (code only - F=food, D=drug,O=other)
	;;^UTILITY(U,$J,358.6,15,1,6,0)
	;;=  verified? YES/NO
	;;^UTILITY(U,$J,358.6,15,1,7,0)
	;;=  true allergy? YES/NO
	;;^UTILITY(U,$J,358.6,15,2)
	;;=ALLERGY NAME^30^TYPE OF ALLERGEN^5^TYPE (F=FOOD,D=DRUG,O=OTHER)^1^VERIFIED? (YES/NO)^3^TRUE ALLERGY? (YES/NO)^3
	;;^UTILITY(U,$J,358.6,15,3)
	;;=ALLERGIES ALLERGY PATIENT
	;;^UTILITY(U,$J,358.6,15,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,15,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,16,0)
	;;=DPT PATIENT'S TELEPHONE NUMBER^ADDRESS^IBDFN6^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,16,1,0)
	;;=^^1^1^2930217^^
	;;^UTILITY(U,$J,358.6,16,1,1,0)
	;;=Used to display the patient's telephone number.
	;;^UTILITY(U,$J,358.6,16,2)
	;;=TELEPHONE NUMBER^20
	;;^UTILITY(U,$J,358.6,16,3)
	;;=PATIENT TELEPHONE MAS
	;;^UTILITY(U,$J,358.6,16,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,16,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,17,0)
	;;=DPT PATIENT'S MARITAL STATUS^VADPT^IBDFN^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,17,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,358.6,17,1,1,0)
	;;=For displaying the patient's marital status.
	;;^UTILITY(U,$J,358.6,17,2)
	;;=MARITAL STATUS^15
	;;^UTILITY(U,$J,358.6,17,3)
	;;=PATIENT MARITAL STATUS MAS
	;;^UTILITY(U,$J,358.6,17,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,17,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,18,0)
	;;=DPT PATIENT'S EMPLOYER NAME^EMPLOYER^IBDFN2^PATIENT FILE^1^2^1^^1^^^1^^
	;;^UTILITY(U,$J,358.6,18,1,0)
	;;=^^1^1^2930217^
	;;^UTILITY(U,$J,358.6,18,1,1,0)
	;;=For displaying the patient's employer.
	;;^UTILITY(U,$J,358.6,18,2)
	;;=employer name^45
	;;^UTILITY(U,$J,358.6,18,3)
	;;=PATIENT EMPLOYER MAS
	;;^UTILITY(U,$J,358.6,18,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,358.6,18,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,358.6,19,0)
	;;=DPT PATIENT'S EMPLOYMENT STATUS^EMPLMNT^IBDFN^PATIENT FILE^1^2^1^^1^^^1^^
