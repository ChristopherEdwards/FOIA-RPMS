IBINI08A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.6)
	;;=^IBE(357.6,
	;;^UTILITY(U,$J,357.6,0)
	;;=PACKAGE INTERFACE^357.6I^55^46
	;;^UTILITY(U,$J,357.6,1,0)
	;;=DPT PATIENT'S NAME^VADPT^IBDFN^PATIENT FILE^1^2^1^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,1,1,0)
	;;=^^2^2^2930212^^^^
	;;^UTILITY(U,$J,357.6,1,1,1,0)
	;;= 
	;;^UTILITY(U,$J,357.6,1,1,2,0)
	;;=Patient's Name
	;;^UTILITY(U,$J,357.6,1,2)
	;;=Patient's Name^30
	;;^UTILITY(U,$J,357.6,1,3)
	;;=PATIENT NAME MAS
	;;^UTILITY(U,$J,357.6,1,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,1,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,2,0)
	;;=DPT PATIENT'S SEX^VADPT^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,2,1,0)
	;;=^^1^1^2931015^^^^
	;;^UTILITY(U,$J,357.6,2,1,1,0)
	;;=Patient's sex, either 'MALE' or 'FEMALE', or "M" or "F".
	;;^UTILITY(U,$J,357.6,2,2)
	;;=Patient's Sex^6^Patient's Sex (Code)^1
	;;^UTILITY(U,$J,357.6,2,3)
	;;=PATIENT SEX MAS
	;;^UTILITY(U,$J,357.6,2,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,2,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,3,0)
	;;=DPT PATIENT'S DOB/AGE^VADPT^IBDFN^PATIENT FILE^1^2^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,3,1,0)
	;;=^^2^2^2930726^^
	;;^UTILITY(U,$J,357.6,3,1,1,0)
	;;=Patient's DOB in MMM DD, YYYY format
	;;^UTILITY(U,$J,357.6,3,1,2,0)
	;;=Patient's age in years.
	;;^UTILITY(U,$J,357.6,3,2)
	;;=Patient's DOB^12^Patient's Age^3
	;;^UTILITY(U,$J,357.6,3,3)
	;;=PATIENT DOB AGE MAS PIMS
	;;^UTILITY(U,$J,357.6,3,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,3,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,4,0)
	;;=GMRA PATIENT'S ALLERGIES^ALLERGY^IBDFN2^ALLERGY^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,4,1,0)
	;;=^^7^7^2931015^^
	;;^UTILITY(U,$J,357.6,4,1,1,0)
	;;=Used to disply a list of the patient's allergies, both true and adverse
	;;^UTILITY(U,$J,357.6,4,1,2,0)
	;;=reactions, verified and unverified. Data returned:
	;;^UTILITY(U,$J,357.6,4,1,3,0)
	;;=  allergy name
	;;^UTILITY(U,$J,357.6,4,1,4,0)
	;;=  type of allergen
	;;^UTILITY(U,$J,357.6,4,1,5,0)
	;;=  type (code only - F=food, D=drug,O=other)
	;;^UTILITY(U,$J,357.6,4,1,6,0)
	;;=  verified? YES/NO
	;;^UTILITY(U,$J,357.6,4,1,7,0)
	;;=  true allergy? YES/NO
	;;^UTILITY(U,$J,357.6,4,2)
	;;=ALLERGY NAME^30^TYPE OF ALLERGEN^5^TYPE (F=FOOD,D=DRUG,O=OTHER)^1^VERIFIED? (YES/NO)^3^TRUE ALLERGY? (YES/NO)^3
	;;^UTILITY(U,$J,357.6,4,3)
	;;=ALLERGIES ALLERGY PATIENT
	;;^UTILITY(U,$J,357.6,4,7,0)
	;;=^357.67^1^1
	;;^UTILITY(U,$J,357.6,4,7,1,0)
	;;=DFN
	;;^UTILITY(U,$J,357.6,7,0)
	;;=DG SELECT CPT PROCEDURE CODES^CPT^IBDFN4^MAS^^3^2^^1^^^1^^
	;;^UTILITY(U,$J,357.6,7,1,0)
	;;=^^2^2^2930726^^^
	;;^UTILITY(U,$J,357.6,7,1,1,0)
	;;=Allows for the selection of CPT codes from the CPT file. The user can 
	;;^UTILITY(U,$J,357.6,7,1,2,0)
	;;=limit his selections by choosing a major CPT category if he wishes.
	;;^UTILITY(U,$J,357.6,7,2)
	;;=CODE^5^SHORT NAME^28^DESCRIPTION^161^^^^^^^^^^^1^1
	;;^UTILITY(U,$J,357.6,7,3)
	;;=SELECT CPT CODES
	;;^UTILITY(U,$J,357.6,8,0)
	;;=DPT PATIENT'S SC CONDITIONS^ELIG^IBDFN^PATIENT FILE^1^2^4^1^1^^^1^^
	;;^UTILITY(U,$J,357.6,8,1,0)
	;;=^^7^7^2931015^^^^
	;;^UTILITY(U,$J,357.6,8,1,1,0)
	;;=Used to output a list of the patients service connected conditons, along with
	;;^UTILITY(U,$J,357.6,8,1,2,0)
	;;=the percentage ratings. Data returned:
	;;^UTILITY(U,$J,357.6,8,1,3,0)
	;;=  disability name
	;;^UTILITY(U,$J,357.6,8,1,4,0)
	;;=  disability percentage
	;;^UTILITY(U,$J,357.6,8,1,5,0)
	;;=  disability percentage with the label "%"
	;;^UTILITY(U,$J,357.6,8,1,6,0)
	;;=  disabilty percentage with the label "%SC"
	;;^UTILITY(U,$J,357.6,8,1,7,0)
	;;=  disability percentage with the label "% - SERVICE CONNECTED"
