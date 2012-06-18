FHINI0F2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9301,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9302,0)
	;;=PEANUTS & CASHEWS,HONEY ROASTED,FISHER^BC-02575^oz.^28
	;;^UTILITY(U,$J,112,9302,1)
	;;=17.857^46.429^21.429^535.714^^^^^^^^^375
	;;^UTILITY(U,$J,112,9302,2)
	;;=^^^^^^^^0^7.143^25^14.286
	;;^UTILITY(U,$J,112,9302,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9303,0)
	;;=PEANUTS,CINN ROASTED,EAGLE SNACKS^BC-02576^oz.^28
	;;^UTILITY(U,$J,112,9303,1)
	;;=25^46.786^24.286^607.143^1.786^^^32.143^^^^614.286^321.429^^^^^^0^.107
	;;^UTILITY(U,$J,112,9303,2)
	;;=.143^10.714^^^^^^^0^^^^^^^^57.143
	;;^UTILITY(U,$J,112,9303,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9304,0)
	;;=PEANUTS,DRY/HONEY ROASTED,FISHER^BC-02577^oz.^28
	;;^UTILITY(U,$J,112,9304,1)
	;;=25^46.429^14.286^535.714^^^^^^^^^392.857
	;;^UTILITY(U,$J,112,9304,2)
	;;=^^^^^^^^0^7.143^25^14.286
	;;^UTILITY(U,$J,112,9304,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9305,0)
	;;=PEANUTS,DRY ROASTED,FISHER^BC-02578^oz.^28
	;;^UTILITY(U,$J,112,9305,1)
	;;=25^50^21.429^571.429^^^^^^^^^750
	;;^UTILITY(U,$J,112,9305,2)
	;;=^^^^^^^^0^7.143^28.571^14.286
	;;^UTILITY(U,$J,112,9305,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9306,0)
	;;=PEANUTS,HONEY ROAST,EAGLE SNACKS^BC-02579^oz.^28
	;;^UTILITY(U,$J,112,9306,1)
	;;=23.571^47.143^22.5^607.143^1.429^^^35.714^1.429^^^657.143^464.286^^^^^21.429^0^.107
	;;^UTILITY(U,$J,112,9306,2)
	;;=.071^11.071^^^^^^^0^^^14.643^^^^^8.571
	;;^UTILITY(U,$J,112,9306,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9307,0)
	;;=PEANUTS,HONEY ROASTED,FISHER^BC-02580^oz.^28
	;;^UTILITY(U,$J,112,9307,1)
	;;=21.429^46.429^17.857^535.714^^^^^^^^^410.714
	;;^UTILITY(U,$J,112,9307,2)
	;;=^^^^^^^^0^7.143^25^14.286
	;;^UTILITY(U,$J,112,9307,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9308,0)
	;;=PEANUTS,HONEY ROASTED,LITTLE DEBBIE^BC-02581^1.1-oz.^32
	;;^UTILITY(U,$J,112,9308,1)
	;;=25.625^45.625^25.625^615.625^1.25^^^28.125^1.313^^^^71.875^^^^^0^0^.125
	;;^UTILITY(U,$J,112,9308,2)
	;;=.125^10^^^^^^^3.125^8.125^23.438^14.063
	;;^UTILITY(U,$J,112,9308,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9309,0)
	;;=PEANUTS,LIGHTLY SALTED,EAGLE SNACKS^BC-02582^oz.^28
	;;^UTILITY(U,$J,112,9309,1)
	;;=29.643^52.5^14.643^607.143^1.429^^^57.143^1.536^^^689.286^321.429^^^^^^0^.107
	;;^UTILITY(U,$J,112,9309,2)
	;;=.143^16.429^^^^^^^0^^^^^^^^7.857
	;;^UTILITY(U,$J,112,9309,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9310,0)
	;;=PEANUTS,OIL ROASTED,FISHER^BC-02583^oz.^28
	;;^UTILITY(U,$J,112,9310,1)
	;;=25^50^21.429^571.429^^^^^^^^^464.286
	;;^UTILITY(U,$J,112,9310,2)
	;;=^^^^^^^^0^7.143^25^17.857
	;;^UTILITY(U,$J,112,9310,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9311,0)
	;;=PEANUTS,ROASTED IN SHELL,FISHER^BC-02584^oz.^28
	;;^UTILITY(U,$J,112,9311,1)
	;;=25^50^17.857^571.429^^^^^^^^^589.286
	;;^UTILITY(U,$J,112,9311,2)
	;;=^^^^^^^^0^7.143^28.571^14.286
	;;^UTILITY(U,$J,112,9311,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9312,0)
	;;=PEANUTS,SALTED,LANCE^BC-02585^1.1-oz.^32
	;;^UTILITY(U,$J,112,9312,1)
	;;=27.5^47.188^20.313^603.125^1.25^^^84.375^1.969^^^109.375^290.625^^^^^^^.063
	;;^UTILITY(U,$J,112,9312,2)
	;;=.156^3.438^^^^^^^0^8.75^24.688^13.75
	;;^UTILITY(U,$J,112,9312,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9313,0)
	;;=PEANUTS,UNSALTED,LANCE^BC-02586^1.1-oz.^32
	;;^UTILITY(U,$J,112,9313,1)
	;;=27.5^47.188^20.313^603.125^1.875^^^84.375^1.969^^^103.125^^^^^^^^.063
	;;^UTILITY(U,$J,112,9313,2)
	;;=.156^3.438^^^^^^^0^9.375^21.875^15.938
	;;^UTILITY(U,$J,112,9313,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9314,0)
	;;=PEANUTS,SPANISH,RAW,FISHER^BC-02587^oz.^28
	;;^UTILITY(U,$J,112,9314,1)
	;;=25^50^17.857^571.429
	;;^UTILITY(U,$J,112,9314,2)
	;;=^^^^^^^^0^7.143^28.571^14.286
	;;^UTILITY(U,$J,112,9314,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9315,0)
	;;=PECANS,RAW,FISHER^BC-02588^oz.^28
	;;^UTILITY(U,$J,112,9315,1)
	;;=7.143^67.857^17.857^678.571^^^^^^^^^0
	;;^UTILITY(U,$J,112,9315,2)
	;;=^^^^^^^^0^7.143^42.857^17.857
	;;^UTILITY(U,$J,112,9315,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9316,0)
	;;=PISTACHIOS,DRY ROASTED,BLUE DIAMOND^BC-02589^oz.^28
