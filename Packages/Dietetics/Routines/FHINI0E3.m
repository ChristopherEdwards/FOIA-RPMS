FHINI0E3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8831,2)
	;;=.044^1.327^^.071^^^^^^^^^138.053
	;;^UTILITY(U,$J,112,8831,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8832,0)
	;;=BF,DINNER,CHICKEN W/VEG,GERBER SECOND FOOD^BC-02105^4-oz.^113
	;;^UTILITY(U,$J,112,8832,1)
	;;=5.752^1.77^6.46^64.602^^^^28.319^.531^^^119.469^24.779^^^^^^1.77^.027
	;;^UTILITY(U,$J,112,8832,2)
	;;=.062^1.504^^.062^^^^^^^^^125.664
	;;^UTILITY(U,$J,112,8832,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8833,0)
	;;=BF,DINNER,HAM W/VEG,GERBER THIRD FOOD^BC-02106^4-oz.^113
	;;^UTILITY(U,$J,112,8833,1)
	;;=6.372^2.478^8.319^81.416^^^^6.195^.708^^^138.053^20.354^^^^^^2.655^.097
	;;^UTILITY(U,$J,112,8833,2)
	;;=.053^1.416^^.106^^^^^^^^^40.708
	;;^UTILITY(U,$J,112,8833,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8834,0)
	;;=BF,DINNER,HAM W/VEG,GERBER SECOND FOOD^BC-02107^4-oz.^113
	;;^UTILITY(U,$J,112,8834,1)
	;;=5.929^2.92^7.434^79.646^^^^6.195^.708^^^130.088^19.469^^^^^^2.655^.097
	;;^UTILITY(U,$J,112,8834,2)
	;;=.062^1.327^^.097^^^^^^^^^34.513
	;;^UTILITY(U,$J,112,8834,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8835,0)
	;;=BF,DINNER,TURKEY W/VEG,GERBER THIRD FOOD^BC-02108^4-oz.^113
	;;^UTILITY(U,$J,112,8835,1)
	;;=5.31^3.009^7.965^79.646^^^^7.965^.442^^^120.354^23.894^^^^^^2.655^.027
	;;^UTILITY(U,$J,112,8835,2)
	;;=.044^1.416^^.08^^^^^^^^^82.301
	;;^UTILITY(U,$J,112,8835,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8836,0)
	;;=BF,DINNER,TURKEY W/VEG,GERBER SECOND FOOD^BC-02109^4-oz.^113
	;;^UTILITY(U,$J,112,8836,1)
	;;=5.575^2.478^7.08^73.451^^^^10.619^.442^^^115.044^23.894^^^^^^2.655^.018
	;;^UTILITY(U,$J,112,8836,2)
	;;=.08^1.327^^.08^^^^^^^^^50.442
	;;^UTILITY(U,$J,112,8836,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8837,0)
	;;=BF,JUICE,APPLE,BEECH-NUT STAGE 1^BC-02110^4.2-floz.^128
	;;^UTILITY(U,$J,112,8837,1)
	;;=0^0^10.078^42.188^^^^^.5^^^^7.031^^^^^^33.594
	;;^UTILITY(U,$J,112,8837,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8838,0)
	;;=BF,JUICE,APPLE,GERBER SECOND FOOD^BC-02111^4.42-floz.^125
	;;^UTILITY(U,$J,112,8838,1)
	;;=.08^.16^11.52^48^^^^3.2^.16^4^6.4^92.8^1.6^.024^.016^.184^^^33.6^.016
	;;^UTILITY(U,$J,112,8838,2)
	;;=.016^.08^^.032^^^^^^^^^.8
	;;^UTILITY(U,$J,112,8838,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8839,0)
	;;=BF,JUICE,APPLE,TODDLER,GERBER^BC-02112^4.42-floz.^125
	;;^UTILITY(U,$J,112,8839,1)
	;;=.16^.16^11.6^48^^^^3.2^.16^4^6.4^91.2^1.6^.024^.016^.192^^^32^.008
	;;^UTILITY(U,$J,112,8839,2)
	;;=.008^.08^^.032^^^^^^^^^.8
	;;^UTILITY(U,$J,112,8839,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8840,0)
	;;=BF,JUICE,APPLE APRICOT,GERBER SECOND FOOD^BC-02113^4.6-floz.^130
	;;^UTILITY(U,$J,112,8840,1)
	;;=.231^.077^11.692^49.231^^^^6.154^.2^5.385^7.692^113.077^3.077^.038^.015^.069^^^32.308^.008
	;;^UTILITY(U,$J,112,8840,2)
	;;=.023^.154^^.023^^^^^^^^^45.385^^^^.231
	;;^UTILITY(U,$J,112,8840,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8841,0)
	;;=BF,JUICE,APPLE APRICOT,STR HEINZ^BC-02114^jar^130
	;;^UTILITY(U,$J,112,8841,1)
	;;=.077^.231^11.308^46.923^^^^10.769^.5^^10.769^113.846^6.154^.069^.03^^^425.385^32.308^.023
	;;^UTILITY(U,$J,112,8841,2)
	;;=.008^.154^^.031
	;;^UTILITY(U,$J,112,8841,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8842,0)
	;;=BF,JUICE,APPLE BANANA,GERBER SECOND FOOD^BC-02115^4.42-floz.^125
	;;^UTILITY(U,$J,112,8842,1)
	;;=.24^.16^12.08^51.2^^^^4.8^.16^6.4^7.2^118.4^1.6^.04^.016^.256^^^33.6^.008
	;;^UTILITY(U,$J,112,8842,2)
	;;=.016^.16^^.056^^^^^^^^^1.6
	;;^UTILITY(U,$J,112,8842,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8843,0)
	;;=BF,JUICE,APPLE CHERRY,BEECH-NUT STAGE 2^BC-02116^4.2-floz.^128
	;;^UTILITY(U,$J,112,8843,1)
	;;=0^0^10.625^43.75^^^^^.703^^^^4.688^^^^^^32.813
	;;^UTILITY(U,$J,112,8843,2)
	;;=.008
	;;^UTILITY(U,$J,112,8843,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8844,0)
	;;=BF,JUICE,APPLE CHERRY, GERBER SECOND FOOD^BC-02117^4.42-floz.^125
	;;^UTILITY(U,$J,112,8844,1)
	;;=.16^.08^11.52^48^^^^7.2^.4^5.6^8^108.8^4^.032^.016^.072^^^33.6^.008
	;;^UTILITY(U,$J,112,8844,2)
	;;=.024^.08^^.032^^^^^^^^^0
	;;^UTILITY(U,$J,112,8844,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8845,0)
	;;=BF,JUICE,APPLE CHERRY,TODDLER,GERBER^BC-02118^4.42-floz.^125
