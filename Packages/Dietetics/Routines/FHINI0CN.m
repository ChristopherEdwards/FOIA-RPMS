FHINI0CN	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8099,0)
	;;=BREAKFAST JACK,JACK-IN-THE-BOX^BC-01372^sandwich^126
	;;^UTILITY(U,$J,112,8099,1)
	;;=14.286^10.317^23.81^243.651^^^^^^^^^691.27
	;;^UTILITY(U,$J,112,8099,2)
	;;=^^^^^^^^161.111^4.127^3.968^1.984
	;;^UTILITY(U,$J,112,8099,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8100,0)
	;;=CAKE,DOUBLE FUDGE,JACK-IN-THE-BOX^BC-01373^3-oz.^85
	;;^UTILITY(U,$J,112,8100,1)
	;;=4.706^10.588^57.647^338.824^^^^^^^^^304.706
	;;^UTILITY(U,$J,112,8100,2)
	;;=^^^^^^^^23.529
	;;^UTILITY(U,$J,112,8100,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8101,0)
	;;=CHEESEBURGER,JACK-IN-THE-BOX^BC-01374^sandwich^112
	;;^UTILITY(U,$J,112,8101,1)
	;;=13.393^12.5^29.464^281.25^^^^^^^^^666.071
	;;^UTILITY(U,$J,112,8101,2)
	;;=^^^^^^^^36.607^5.089^5.268^2.054
	;;^UTILITY(U,$J,112,8101,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8102,0)
	;;=CHEESEBURGER,BACON,JACK-IN-THE-BOX^BC-01375^sandwich^230
	;;^UTILITY(U,$J,112,8102,1)
	;;=15.217^16.957^20.87^306.522^^^^^^^^^490
	;;^UTILITY(U,$J,112,8102,2)
	;;=^^^^^^^^36.957^6.522^6.522^3.043
	;;^UTILITY(U,$J,112,8102,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8103,0)
	;;=CHEESEBURGER,DOUBLE,JACK-IN-THE-BOX^BC-01376^sandwich^149
	;;^UTILITY(U,$J,112,8103,1)
	;;=14.094^18.121^22.148^313.423^^^^^^^^^565.101
	;;^UTILITY(U,$J,112,8103,2)
	;;=^^^^^^^^48.322^8.255^7.785^2.081
	;;^UTILITY(U,$J,112,8103,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8104,0)
	;;=CHEESEBURGER,ULTIMATE,JACK-IN-THE-BOX^BC-01377^sandwich^280
	;;^UTILITY(U,$J,112,8104,1)
	;;=16.786^24.643^11.786^336.429^^^^^^^^^420
	;;^UTILITY(U,$J,112,8104,2)
	;;=^^^^^^^^45.357^9.429^8.643^6.464
	;;^UTILITY(U,$J,112,8104,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8105,0)
	;;=CHEESECAKE,JACK-IN-THE-BOX^BC-01378^serving^99
	;;^UTILITY(U,$J,112,8105,1)
	;;=8.081^17.677^29.293^312.121^^^^^^^^^210.101
	;;^UTILITY(U,$J,112,8105,2)
	;;=^^^^^^^^63.636^9.091^7.071^1.01
	;;^UTILITY(U,$J,112,8105,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8106,0)
	;;=CHICKEN FAJITA PITA,JACK-IN-THE-BOX^BC-01379^sandwich^189
	;;^UTILITY(U,$J,112,8106,1)
	;;=12.698^4.233^15.344^154.497^^^^^^^^^371.958
	;;^UTILITY(U,$J,112,8106,2)
	;;=^^^^^^^^17.989^1.534^1.905^.741
	;;^UTILITY(U,$J,112,8106,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8107,0)
	;;=CHICKEN FILLET,GRILLED SANDWICH,JACK-IN-THE-BOX^BC-01380^sandwich^205
	;;^UTILITY(U,$J,112,8107,1)
	;;=15.122^8.293^16.098^199.024^^^^^^^^^551.22
	;;^UTILITY(U,$J,112,8107,2)
	;;=^^^^^^^^31.22^2^2.244^2.927
	;;^UTILITY(U,$J,112,8107,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8108,0)
	;;=CHICKEN STRIPS,JACK-IN-THE-BOX^BC-01381^4-pieces^125
	;;^UTILITY(U,$J,112,8108,1)
	;;=23.2^11.2^22.4^279.2^^^^^^^^^598.4
	;;^UTILITY(U,$J,112,8108,2)
	;;=^^^^^^^^54.4^5.44^4.72^.56
	;;^UTILITY(U,$J,112,8108,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8109,0)
	;;=CHICKEN SUPREME SANDWICH,JACK-IN-THE-BOX^BC-01382^sandwich^231
	;;^UTILITY(U,$J,112,8109,1)
	;;=11.688^15.584^14.719^248.918^^^^^^^^^660.173
	;;^UTILITY(U,$J,112,8109,2)
	;;=^^^^^^^^26.84^6.19^5.801^3.29
	;;^UTILITY(U,$J,112,8109,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8110,0)
	;;=CRESCENT SANDWICH,SAUSAGE,JACK-IN-THE-BOX^BC-01383^sandwich^156
	;;^UTILITY(U,$J,112,8110,1)
	;;=14.103^27.564^17.949^374.359^^^^^^^^^648.718
	;;^UTILITY(U,$J,112,8110,2)
	;;=^^^^^^^^119.872^9.936^13.782^3.654
	;;^UTILITY(U,$J,112,8110,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8111,0)
	;;=CRESCENT SANDWICH,SUPREME,JACK-IN-THE-BOX^BC-01384^sandwich^146
	;;^UTILITY(U,$J,112,8111,1)
	;;=13.699^27.397^18.493^374.658^^^^^^^^^721.233
	;;^UTILITY(U,$J,112,8111,2)
	;;=^^^^^^^^121.918^9.041^12.945^5.342
	;;^UTILITY(U,$J,112,8111,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8112,0)
	;;=FISH SUPREME SANDWICH,JACK-IN-THE-BOX^BC-01385^sandwich^228
	;;^UTILITY(U,$J,112,8112,1)
	;;=8.772^14.035^20.614^242.982^^^^^^^^^459.211
	;;^UTILITY(U,$J,112,8112,2)
	;;=^^^^^^^^28.947^5.921^4.825^3.246
	;;^UTILITY(U,$J,112,8112,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8113,0)
	;;=FRENCH FRIES,JUMBO,JACK-IN-THE-BOX^BC-01386^serving^136
	;;^UTILITY(U,$J,112,8113,1)
	;;=2.941^17.647^39.706^325^^^^^^^^^241.176
	;;^UTILITY(U,$J,112,8113,2)
	;;=^^^^^^^^11.765^7.353^7.206^2.5
