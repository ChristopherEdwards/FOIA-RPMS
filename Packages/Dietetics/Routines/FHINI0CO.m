FHINI0CO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8113,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8114,0)
	;;=FRENCH FRIES,REG,JACK-IN-THE-BOX^BC-01387^serving^109
	;;^UTILITY(U,$J,112,8114,1)
	;;=2.752^17.431^39.45^323.853^^^^^^^^^240.367
	;;^UTILITY(U,$J,112,8114,2)
	;;=^^^^^^^^11.927^7.248^7.156^2.477
	;;^UTILITY(U,$J,112,8114,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8115,0)
	;;=GRILLED SOURDOUGH BURGER,JACK-IN-THE-BOX^BC-01388^sandwich^223
	;;^UTILITY(U,$J,112,8115,1)
	;;=14.35^22.422^15.247^319.283^^^^^^^^^511.211
	;;^UTILITY(U,$J,112,8115,2)
	;;=^^^^^^^^48.879^7.13^7.982^3.543
	;;^UTILITY(U,$J,112,8115,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8116,0)
	;;=HAM & TURKEY EMLT SANDWICH,JACK-IN-THE-BOX^BC-01389^sandwich^218
	;;^UTILITY(U,$J,112,8116,1)
	;;=12.385^16.514^18.349^271.56^^^^^^^^^513.761
	;;^UTILITY(U,$J,112,8116,2)
	;;=^^^^^^^^36.239^5.046^5.046^4.128
	;;^UTILITY(U,$J,112,8116,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8117,0)
	;;=HAMBURGER,JACK-IN-THE-BOX^BC-01390^sandwich^96
	;;^UTILITY(U,$J,112,8117,1)
	;;=13.542^11.458^29.167^278.125^^^^^^^^^579.167
	;;^UTILITY(U,$J,112,8117,2)
	;;=^^^^^^^^27.083^4.271^5.104^2.083
	;;^UTILITY(U,$J,112,8117,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8118,0)
	;;=HASH BROWNS,JACK-IN-THE-BOX^BC-01391^serving^62
	;;^UTILITY(U,$J,112,8118,1)
	;;=3.226^11.29^17.742^187.097^^^^^^^^^340.323
	;;^UTILITY(U,$J,112,8118,2)
	;;=^^^^^^^^4.839^5.806^5.161^.645
	;;^UTILITY(U,$J,112,8118,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8119,0)
	;;=JUMBO JACK,JACK-IN-THE-BOX^BC-01392^sandwich^222
	;;^UTILITY(U,$J,112,8119,1)
	;;=11.712^15.315^18.919^263.063^^^^^^^^^330.18
	;;^UTILITY(U,$J,112,8119,2)
	;;=^^^^^^^^32.883^4.955^5.856^3.604
	;;^UTILITY(U,$J,112,8119,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8120,0)
	;;=JUMBO JACK W/CHEESE,JACK-IN-THE-BOX^BC-01393^sandwich^242
	;;^UTILITY(U,$J,112,8120,1)
	;;=13.223^16.529^19.008^279.752^^^^^^^^^450.413
	;;^UTILITY(U,$J,112,8120,2)
	;;=^^^^^^^^42.149^5.785^6.198^3.719
	;;^UTILITY(U,$J,112,8120,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8121,0)
	;;=ONION RINGS,JACK-IN-THE-BOX^BC-01394^serving^108
	;;^UTILITY(U,$J,112,8121,1)
	;;=4.63^21.296^36.111^353.704^^^^^^^^^376.852
	;;^UTILITY(U,$J,112,8121,2)
	;;=^^^^^^^^25^10.278^8.611^1.204
	;;^UTILITY(U,$J,112,8121,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8122,0)
	;;=PANCAKE PLATTER,JACK-IN-THE-BOX^BC-01395^platter^231
	;;^UTILITY(U,$J,112,8122,1)
	;;=6.494^9.524^37.662^264.935^^^^^^^^^384.416
	;;^UTILITY(U,$J,112,8122,2)
	;;=^^^^^^^^42.857^3.723^3.29^1.515
	;;^UTILITY(U,$J,112,8122,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8123,0)
	;;=PANCAKE SYRUP,JACK-IN-THE-BOX^BC-01396^pkt.^42
	;;^UTILITY(U,$J,112,8123,1)
	;;=0^0^71.429^288.095^^^^^^^^^14.286
	;;^UTILITY(U,$J,112,8123,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8123,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8124,0)
	;;=SALAD DRESSING,BLUE CHEESE,JACK-IN-THE-BOX^BC-01397^pkt.^70
	;;^UTILITY(U,$J,112,8124,1)
	;;=1.429^31.429^20^374.286^^^^^^^^^1311.429
	;;^UTILITY(U,$J,112,8124,2)
	;;=^^^^^^^^25.714^5.714^7.714^18
	;;^UTILITY(U,$J,112,8124,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8125,0)
	;;=SALAD DRESSING,BUTTERMILK HOUSE,JACK-IN-THE-BOX^BC-01398^pkt.^70
	;;^UTILITY(U,$J,112,8125,1)
	;;=1.429^51.429^11.429^517.143^^^^^^^^^991.429
	;;^UTILITY(U,$J,112,8125,2)
	;;=^^^^^^^^30^8.286^12^30.857
	;;^UTILITY(U,$J,112,8125,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8126,0)
	;;=SALAD DRESSING,FRENCH,REDUCED CALORIE,JACK-IN-THE-BOX^BC-01399^pkt.^70
	;;^UTILITY(U,$J,112,8126,1)
	;;=1.429^11.429^37.143^257.143^^^^^^^^^857.143
	;;^UTILITY(U,$J,112,8126,2)
	;;=^^^^^^^^0^1.714^2.571^6.857
	;;^UTILITY(U,$J,112,8126,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8127,0)
	;;=SALAD DRESSING,THOUSAND ISLAND,JACK-IN-THE-BOX^BC-01400^pkt.^70
	;;^UTILITY(U,$J,112,8127,1)
	;;=1.429^42.857^17.143^445.714^^^^^^^^^1000
	;;^UTILITY(U,$J,112,8127,2)
	;;=^^^^^^^^32.857^7.143^10.286^25.143
	;;^UTILITY(U,$J,112,8127,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8128,0)
	;;=SALAD W/O DRESSING,CHEF,JACK-IN-THE-BOX^BC-01401^salad^332
	;;^UTILITY(U,$J,112,8128,1)
	;;=9.036^5.422^3.012^97.892^^^^^^^^^271.084
