IBDEI012	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.5,151,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,151,2,1,0)
	;;=Patient Name:^^^1^1^1^15^30^1
	;;^UTILITY(U,$J,358.5,152,0)
	;;=PATIENT DOB^38^22
	;;^UTILITY(U,$J,358.5,152,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,152,2,1,0)
	;;=DOB:^^^1^2^2^6^12^1
	;;^UTILITY(U,$J,358.5,153,0)
	;;=PID^38^7
	;;^UTILITY(U,$J,358.5,153,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,153,2,1,0)
	;;=PID:^^^19^2^2^24^15^1
	;;^UTILITY(U,$J,358.5,154,0)
	;;=SC CONDITION 1^38^11^^1
	;;^UTILITY(U,$J,358.5,154,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,154,2,1,0)
	;;=SC Conditions:^^U^1^4^5^1^40^1
	;;^UTILITY(U,$J,358.5,154,2,2,0)
	;;=%^^I^^^5^42^4^3
	;;^UTILITY(U,$J,358.5,155,0)
	;;=SC CONDITION 2^38^11^^2
	;;^UTILITY(U,$J,358.5,155,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,155,2,1,0)
	;;=CONDITION^^I^^^6^1^40^1
	;;^UTILITY(U,$J,358.5,155,2,2,0)
	;;=%^^I^^^6^42^4^3
	;;^UTILITY(U,$J,358.5,156,0)
	;;=SC CONDITION 3^38^11^^3
	;;^UTILITY(U,$J,358.5,156,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,156,2,1,0)
	;;=CONDITION^^I^^^7^1^40^1
	;;^UTILITY(U,$J,358.5,156,2,2,0)
	;;=%^^I^^^7^42^4^3
	;;^UTILITY(U,$J,358.5,157,0)
	;;=SC CONDITION 4^38^11^1^4
	;;^UTILITY(U,$J,358.5,157,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,157,2,1,0)
	;;=CONDITION^^I^^^8^1^40^1
	;;^UTILITY(U,$J,358.5,157,2,2,0)
	;;=%^^I^^^8^42^4^3
	;;^UTILITY(U,$J,358.5,158,0)
	;;=SEX^38^23
	;;^UTILITY(U,$J,358.5,158,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,158,2,1,0)
	;;=Sex:^^^40^2^2^45^1^2
	;;^UTILITY(U,$J,358.5,159,0)
	;;=ELIGIBILITY^38^8
	;;^UTILITY(U,$J,358.5,159,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,159,2,1,0)
	;;=Eligibility:^^^1^3^3^14^30^1
	;;^UTILITY(U,$J,358.5,160,0)
	;;=MEANS TEST CATEGORY^38^24
	;;^UTILITY(U,$J,358.5,160,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,160,2,1,0)
	;;=Means Test Cat:^^^29^4^4^45^1^3
	;;^UTILITY(U,$J,358.5,161,0)
	;;=SERVICE HISTORY DATA^38^25
	;;^UTILITY(U,$J,358.5,161,2,0)
	;;=^357.52I^4^4
	;;^UTILITY(U,$J,358.5,161,2,1,0)
	;;=AO:^^^1^9^9^5^3^2
	;;^UTILITY(U,$J,358.5,161,2,2,0)
	;;=IR:^^^9^9^9^13^3^3
	;;^UTILITY(U,$J,358.5,161,2,3,0)
	;;=POW:^^^17^9^9^22^3^4
	;;^UTILITY(U,$J,358.5,161,2,4,0)
	;;=EC:^^^26^9^9^30^3^6
	;;^UTILITY(U,$J,358.5,162,0)
	;;=SC %^38^8
	;;^UTILITY(U,$J,358.5,162,2,0)
	;;=^357.52I^3^2
	;;^UTILITY(U,$J,358.5,162,2,2,0)
	;;=SC%:^^^17^4^4^22^3^7
	;;^UTILITY(U,$J,358.5,162,2,3,0)
	;;=%^^^25^4
	;;^UTILITY(U,$J,358.5,163,0)
	;;=SC TREATMENT QUESTIONS^39^26
	;;^UTILITY(U,$J,358.5,163,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,163,2,1,0)
	;;=SERVICE CONNECTED?^^I^^^0^0^46^1
	;;^UTILITY(U,$J,358.5,163,2,2,0)
	;;=AO,IR OR EC?^^I^^^1^0^43^5
	;;^UTILITY(U,$J,358.5,164,0)
	;;=CLINIC^41^5
	;;^UTILITY(U,$J,358.5,164,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,164,2,1,0)
	;;=Clinic:^^^0^0^0^8^30^1
	;;^UTILITY(U,$J,358.5,165,0)
	;;=APPT. DT/TIME^41^4
	;;^UTILITY(U,$J,358.5,165,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,165,2,1,0)
	;;=Appt. DT/Time:^^^0^2^2^15^23^1
	;;^UTILITY(U,$J,358.5,166,0)
	;;=OTHER ALLERGIES^42^3
	;;^UTILITY(U,$J,358.5,166,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,166,2,1,0)
	;;=Other:^^^1^7
	;;^UTILITY(U,$J,358.5,167,0)
	;;=ALLERGY 1^42^15^0^1
	;;^UTILITY(U,$J,358.5,167,2,0)
	;;=^357.52I^4^4
	;;^UTILITY(U,$J,358.5,167,2,1,0)
	;;=ALLERGY^^I^^^3^1^30^1
	;;^UTILITY(U,$J,358.5,167,2,2,0)
	;;=TYPE^^U^32^2^3^32^5^2
	;;^UTILITY(U,$J,358.5,167,2,3,0)
	;;=VER^^U^45^2^3^45^3^4
	;;^UTILITY(U,$J,358.5,167,2,4,0)
	;;=TRUE^^U^39^2^3^40^3^5
	;;^UTILITY(U,$J,358.5,168,0)
	;;=ALLERGY 2^42^15^0^2
	;;^UTILITY(U,$J,358.5,168,2,0)
	;;=^357.52I^4^4
	;;^UTILITY(U,$J,358.5,168,2,1,0)
	;;=ALLERGY^^I^^^4^1^30^1