FHINI0E5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8858,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8859,0)
	;;=BF,JUICE,JUICE PLUS,BEECH-NUT STAGE 2^BC-02132^4-floz.^129
	;;^UTILITY(U,$J,112,8859,1)
	;;=0^0^15.194^62.016^^^^^2.101^^^^4.651^^^^^^27.907
	;;^UTILITY(U,$J,112,8859,2)
	;;=.023
	;;^UTILITY(U,$J,112,8859,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8860,0)
	;;=BF,JUICE,MANGO & MIXED FRUIT,GERBER^BC-02133^4.42-floz.^125
	;;^UTILITY(U,$J,112,8860,1)
	;;=.4^.16^14.48^60.8^^^^12.8^.24^^14.4^134.4^4^^^^^^33.6^.024
	;;^UTILITY(U,$J,112,8860,2)
	;;=.024^.24^^.08^^^^^^^^^19.2
	;;^UTILITY(U,$J,112,8860,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8861,0)
	;;=BF,JUICE,MANGO W/GRAPE & PEAR,GERBER^BC-02134^4.42-floz.^125
	;;^UTILITY(U,$J,112,8861,1)
	;;=.32^.08^14.08^58.4^^^^12.8^.24^^12.8^100^4.8^^^^^^33.6^.016
	;;^UTILITY(U,$J,112,8861,2)
	;;=.016^.24^^.048^^^^^^^^^21.6
	;;^UTILITY(U,$J,112,8861,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8862,0)
	;;=BF,JUICE,MIXED FRUIT,BEECH-NUT STAGE 2^BC-02135^4.2-floz.^128
	;;^UTILITY(U,$J,112,8862,1)
	;;=0^0^11.484^46.875^^^^^.297^^^^4.688^^^^^150^32.813^.023
	;;^UTILITY(U,$J,112,8862,2)
	;;=.023^.156
	;;^UTILITY(U,$J,112,8862,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8863,0)
	;;=BF,JUICE,MIXED FRUIT,GERBER SECOND FOOD^BC-02136^4.42-floz.^125
	;;^UTILITY(U,$J,112,8863,1)
	;;=.32^.08^11.84^48.8^^^^8^.32^8^8^117.6^4^.04^.024^.352^^^33.6^.024
	;;^UTILITY(U,$J,112,8863,2)
	;;=.016^.16^^.04^^^^^^^^^1.6
	;;^UTILITY(U,$J,112,8863,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8864,0)
	;;=BF,JUICE,MIXED FRUIT,TODDLER,GERBER^BC-02137^4.42-floz.^125
	;;^UTILITY(U,$J,112,8864,1)
	;;=.32^.08^11.84^48.8^^^^7.2^.24^8^8^115.2^5.6^.04^.024^.352^^^32^.032
	;;^UTILITY(U,$J,112,8864,2)
	;;=.016^.16^^.04^^^^^^^^^3.2
	;;^UTILITY(U,$J,112,8864,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8865,0)
	;;=BF,JUICE,MIXED FRUIT W/ LOWFAT YOGURT,GERBER^BC-02138^4.4-floz.^124
	;;^UTILITY(U,$J,112,8865,1)
	;;=2.339^.726^14.758^75^^^^80.645^.161^^60.484^136.29^36.29^^^^^^33.871^.04
	;;^UTILITY(U,$J,112,8865,2)
	;;=.097^.161^^.048^^^^^^^^^3.226
	;;^UTILITY(U,$J,112,8865,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8866,0)
	;;=BF,JUICE,MIXED TROPICAL FRUIT,GERBER^BC-02139^4.42-floz.^125
	;;^UTILITY(U,$J,112,8866,1)
	;;=.48^.16^14.8^62.4^^^^12.8^.24^^12.8^141.6^4^^^^^^33.6^.032
	;;^UTILITY(U,$J,112,8866,2)
	;;=.024^.32^^.08^^^^^^^^^13.6
	;;^UTILITY(U,$J,112,8866,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8867,0)
	;;=BF,JUICE,ORANGE,BEECH-NUT STAGE 3^BC-02140^4.2-floz.^128
	;;^UTILITY(U,$J,112,8867,1)
	;;=.625^0^10.234^46.094^^^^11.719^^^^^^^^^^79.688^32.813^.039
	;;^UTILITY(U,$J,112,8867,2)
	;;=.023^.234
	;;^UTILITY(U,$J,112,8867,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8868,0)
	;;=BF,JUICE,ORANGE,GERBER SECOND FOOD^BC-02141^4.42-floz.^125
	;;^UTILITY(U,$J,112,8868,1)
	;;=.72^.24^10.48^46.4^^^^10.4^.08^11.2^16.8^180^3.2^.032^.032^.032^^^33.6^.072
	;;^UTILITY(U,$J,112,8868,2)
	;;=.024^.24^^.056^^^^^^^^^7.2
	;;^UTILITY(U,$J,112,8868,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8869,0)
	;;=BF,JUICE,PEAR,BEECH-NUT STAGE 1^BC-02142^4.2-floz.^128
	;;^UTILITY(U,$J,112,8869,1)
	;;=0^0^11.172^46.875^^^^^^^^^^^^^^^33.594
	;;^UTILITY(U,$J,112,8869,2)
	;;=.031^.391
	;;^UTILITY(U,$J,112,8869,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8870,0)
	;;=BF,JUICE,PEAR,GERBER SECOND FOOD^BC-02143^4.42-floz.^125
	;;^UTILITY(U,$J,112,8870,1)
	;;=.24^.08^11.44^47.2^^^^12^.24^8^8.8^125.6^4.8^.12^.04^.08^^^33.6^.016
	;;^UTILITY(U,$J,112,8870,2)
	;;=.024^.24^^.016^^^^^^^^^3.2
	;;^UTILITY(U,$J,112,8870,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8871,0)
	;;=BF,JUICE,PEAR,TODDLER,GERBER^BC-02144^4.42-floz.^125
	;;^UTILITY(U,$J,112,8871,1)
	;;=.24^.08^11.52^48^^^^12.8^.24^8.8^8.8^123.2^5.6^.12^.04^.088^^^32^.016
	;;^UTILITY(U,$J,112,8871,2)
	;;=.032^.4^^.016^^^^^^^^^3.2
	;;^UTILITY(U,$J,112,8871,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8872,0)
	;;=BF,JUICE,PEAR,PEACH W/LOWFAT YOGURT,GERBER^BC-02145^4.4-floz.^124
	;;^UTILITY(U,$J,112,8872,1)
	;;=2.339^.726^14.274^73.387^^^^79.839^.161^^62.097^149.194^33.871^^^^^^33.871^.024
	;;^UTILITY(U,$J,112,8872,2)
	;;=.097^.484^^.032^^^^^^^^^9.677
