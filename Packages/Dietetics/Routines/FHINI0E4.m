FHINI0E4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8845,1)
	;;=.16^.16^11.6^48^^^^7.2^.32^5.6^8^110.4^3.2^.032^.016^.08^^^32^.008
	;;^UTILITY(U,$J,112,8845,2)
	;;=.016^.08^^.024^^^^^^^^^.8
	;;^UTILITY(U,$J,112,8845,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8846,0)
	;;=BF,JUICE,APPLE CRANBERRY,BEECH-NUT STAGE 2^BC-02119^4.2-floz.^128
	;;^UTILITY(U,$J,112,8846,1)
	;;=0^0^10.391^42.969^^^^^.5^^^^6.25^^^^^^32.813
	;;^UTILITY(U,$J,112,8846,2)
	;;=.008
	;;^UTILITY(U,$J,112,8846,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8847,0)
	;;=BF,JUICE,APPLE GRAPE,BEECH-NUT STAGE 2^BC-02120^4.2-floz.^128
	;;^UTILITY(U,$J,112,8847,1)
	;;=0^0^11.875^50^^^^^.5^^^^7.031^^^^^^32.813
	;;^UTILITY(U,$J,112,8847,2)
	;;=.023
	;;^UTILITY(U,$J,112,8847,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8848,0)
	;;=BF,JUICE,APPLE GRAPE,GERBER SECOND FOOD^BC-02121^4.42-floz.^125
	;;^UTILITY(U,$J,112,8848,1)
	;;=.16^.16^11.76^48.8^^^^7.2^.24^5.6^7.2^99.2^4.8^.032^.008^.088^^^33.6^.008
	;;^UTILITY(U,$J,112,8848,2)
	;;=.024^.08^^.032^^^^^^^^^0
	;;^UTILITY(U,$J,112,8848,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8849,0)
	;;=BF,JUICE,APPLE GRAPE,TODDLER,GERBER^BC-02122^4.42-floz.^128
	;;^UTILITY(U,$J,112,8849,1)
	;;=.156^.156^11.641^48.438^^^^7.031^.078^4.688^7.031^91.406^3.906^.031^.008^.102^^^31.25^.008
	;;^UTILITY(U,$J,112,8849,2)
	;;=.023^.078^^.023^^^^^^^^^.781
	;;^UTILITY(U,$J,112,8849,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8850,0)
	;;=BF,JUICE,APPLE-N-BERRY,TODDLER,GERBER^BC-02123^4.42-floz.^125
	;;^UTILITY(U,$J,112,8850,1)
	;;=.08^.008^11.2^46.4^^^^10.4^.304^6.4^8^106.4^6.4^.04^.008^.16^^^32^.008
	;;^UTILITY(U,$J,112,8850,2)
	;;=.024^.08^^.024^^^^^^^^^^^^^.08
	;;^UTILITY(U,$J,112,8850,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8851,0)
	;;=BF,JUICE,APPLE PEACH,GERBER SECOND FOOD^BC-02124^4.42-floz.^125
	;;^UTILITY(U,$J,112,8851,1)
	;;=.16^.16^11.12^46.4^^^^5.6^.24^4.8^7.2^108.8^4^.032^.016^.08^^^33.6^.008
	;;^UTILITY(U,$J,112,8851,2)
	;;=.016^.24^^.024^^^^^^^^^8
	;;^UTILITY(U,$J,112,8851,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8852,0)
	;;=BF,JUICE,APPLE PINEAPPLE,GERBER SECOND FOOD^BC-02125^4.6-floz.^130
	;;^UTILITY(U,$J,112,8852,1)
	;;=.231^.231^11.308^47.692^^^^7.692^.1^6.923^6.154^105.385^2.308^.038^.015^.446^^^32.308^.031
	;;^UTILITY(U,$J,112,8852,2)
	;;=.008^.077^^.038^^^^^^^^^.769^^^^.077
	;;^UTILITY(U,$J,112,8852,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8853,0)
	;;=BF,JUICE,APPLE PINEAPPLE,STR,HEINZ^BC-02126^jar^130
	;;^UTILITY(U,$J,112,8853,1)
	;;=.231^.231^11.231^46.923^^^^12.308^.3^^7.692^83.077^5.385^.054^.02^^^16.154^32.308^.023
	;;^UTILITY(U,$J,112,8853,2)
	;;=.008^.077^^.046
	;;^UTILITY(U,$J,112,8853,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8854,0)
	;;=BF,JUICE,APPLE PLUM,GERBER SECOND FOOD^BC-02127^4.42-floz.^125
	;;^UTILITY(U,$J,112,8854,1)
	;;=.24^.16^11.84^49.6^^^^7.2^.24^5.6^7.2^118.4^7.2^.04^.016^.08^^^33.6^.008
	;;^UTILITY(U,$J,112,8854,2)
	;;=.024^.16^^.032^^^^^^^^^.8
	;;^UTILITY(U,$J,112,8854,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8855,0)
	;;=BF,JUICE,APPLE PRUNE,GERBER SECOND FOOD^BC-02128^4.42-floz.^125
	;;^UTILITY(U,$J,112,8855,1)
	;;=.24^.16^12.72^52.8^^^^8.8^.32^8^10.4^129.6^4.8^.056^.016^.088^^^33.6^.008
	;;^UTILITY(U,$J,112,8855,2)
	;;=.088^.24^^.04^^^^^^^^^.8
	;;^UTILITY(U,$J,112,8855,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8856,0)
	;;=BF,JUICE,APPLE W/ LOWFAT YOGURT,GERBER^BC-02129^4.4-floz.^124
	;;^UTILITY(U,$J,112,8856,1)
	;;=2.258^.645^15.161^75.806^^^^79.032^.161^^60.484^132.258^35.484^^^^^^33.871^.024
	;;^UTILITY(U,$J,112,8856,2)
	;;=.113^.161^^.032^^^^^^^^^1.613
	;;^UTILITY(U,$J,112,8856,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8857,0)
	;;=BF,JUICE,BANANA MEDLEY W/LOWFAT YOGURT,GERBER^BC-02130^4.4-floz.^124
	;;^UTILITY(U,$J,112,8857,1)
	;;=2.5^.073^18.065^88.71^^^^79.032^.161^^65.323^161.29^37.097^^^^^^33.871^.024
	;;^UTILITY(U,$J,112,8857,2)
	;;=.097^.242^^.121^^^^^^^^^3.226
	;;^UTILITY(U,$J,112,8857,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8858,0)
	;;=BF,JUICE,FRUIT-A-PLENTY,TODDLER,GERBER^BC-02131^4.42-floz.^125
	;;^UTILITY(U,$J,112,8858,1)
	;;=.16^.16^11.52^48^^^^8.8^.24^5.6^7.2^108^7.2^.04^.008^.136^^^32^.008
	;;^UTILITY(U,$J,112,8858,2)
	;;=.016^.16^^.024^^^^^^^^^.8
