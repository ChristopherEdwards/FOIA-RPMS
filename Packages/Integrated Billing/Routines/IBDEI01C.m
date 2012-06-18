IBDEI01C	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.5,327,0)
	;;=SC %^84^8
	;;^UTILITY(U,$J,358.5,327,2,0)
	;;=^357.52I^3^2
	;;^UTILITY(U,$J,358.5,327,2,2,0)
	;;=SC%:^^^17^4^4^22^3^7
	;;^UTILITY(U,$J,358.5,327,2,3,0)
	;;=%^^^25^4
	;;^UTILITY(U,$J,358.5,328,0)
	;;=SC TREATMENT QUESTIONS^85^26
	;;^UTILITY(U,$J,358.5,328,2,0)
	;;=^357.52I^2^2
	;;^UTILITY(U,$J,358.5,328,2,1,0)
	;;=SERVICE CONNECTED?^^I^^^0^0^46^1
	;;^UTILITY(U,$J,358.5,328,2,2,0)
	;;=AO,IR OR EC?^^I^^^1^0^43^5
	;;^UTILITY(U,$J,358.5,329,0)
	;;=Subjective:^88^2^^^Subjective:^^^^0^1^8^2^132
	;;^UTILITY(U,$J,358.5,330,0)
	;;=OBJECTIVE^88^2^^^Objective:^^^^0^9^8^2^132
	;;^UTILITY(U,$J,358.5,331,0)
	;;=ASSESSMENT/DIAGNOSIS^88^2^^^Assessment/Diagnosis:^^^^0^17^8^2^132
	;;^UTILITY(U,$J,358.5,332,0)
	;;=PLAN^88^2^^^Plan:^^^^0^25^4^2^132
	;;^UTILITY(U,$J,358.5,333,0)
	;;=SIGNATURE^88^3
	;;^UTILITY(U,$J,358.5,333,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,333,2,1,0)
	;;=Provider Signature^^^79^31^30^59^60^1
	;;^UTILITY(U,$J,358.5,334,0)
	;;=Subjective:^89^2^^^Subjective:^^^^0^1^8^2^132
	;;^UTILITY(U,$J,358.5,335,0)
	;;=OBJECTIVE^89^2^^^Objective:^^^^0^9^8^2^132
	;;^UTILITY(U,$J,358.5,336,0)
	;;=ASSESSMENT/DIAGNOSIS^89^2^^^Assessment/Diagnosis:^^^^0^17^8^2^132
	;;^UTILITY(U,$J,358.5,337,0)
	;;=PLAN^89^2^^^Plan:^^^^0^25^4^2^132
	;;^UTILITY(U,$J,358.5,338,0)
	;;=SIGNATURE^89^3
	;;^UTILITY(U,$J,358.5,338,2,0)
	;;=^357.52I^1^1
	;;^UTILITY(U,$J,358.5,338,2,1,0)
	;;=Provider Signature:^^^40^29^30^59^60^1
