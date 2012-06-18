FHINI0CP	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8128,2)
	;;=^^^^^^^^42.771^2.53^1.566^.392
	;;^UTILITY(U,$J,112,8128,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8129,0)
	;;=SALAD W/O DRESSING,SIDE,JACK-IN-THE-BOX^BC-01402^salad^111
	;;^UTILITY(U,$J,112,8129,1)
	;;=6.306^2.703^.901^45.946^^^^^^^^^75.676
	;;^UTILITY(U,$J,112,8129,2)
	;;=^^^^^^^^0^1.802^.901^0
	;;^UTILITY(U,$J,112,8129,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8130,0)
	;;=SAUCE,BARBEQUE,JACK-IN-THE-BOX^BC-01403^pkt.^28
	;;^UTILITY(U,$J,112,8130,1)
	;;=1.786^0^37.857^157.143^^^^^^^^^1071.429
	;;^UTILITY(U,$J,112,8130,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8130,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8131,0)
	;;=SAUCE,GUACAMOLE,JACK-IN-THE-BOX^BC-01404^serving^25
	;;^UTILITY(U,$J,112,8131,1)
	;;=3.6^20^7.2^220^^^^^^^^^520
	;;^UTILITY(U,$J,112,8131,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8131,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8132,0)
	;;=SAUCE,SALSA,JACK-IN-THE-BOX^BC-01405^serving^25
	;;^UTILITY(U,$J,112,8132,1)
	;;=.8^0^8^32^^^^^^^^^516
	;;^UTILITY(U,$J,112,8132,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8132,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8133,0)
	;;=SAUCE,SEAFOOD COCKTAIL,JACK-IN-THE-BOX^BC-01406^pkt.^28
	;;^UTILITY(U,$J,112,8133,1)
	;;=3.571^0^24.286^114.286^^^^^^^^^735.714
	;;^UTILITY(U,$J,112,8133,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8133,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8134,0)
	;;=SAUCE,SWEET & SOUR,JACK-IN-THE-BOX^BC-01407^pkt.^28
	;;^UTILITY(U,$J,112,8134,1)
	;;=0^0^39.286^142.857^^^^^^^^^571.429
	;;^UTILITY(U,$J,112,8134,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8134,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8135,0)
	;;=SCRAMBLED EGG POCKET,JACK-IN-THE-BOX^BC-01408^pocket^183
	;;^UTILITY(U,$J,112,8135,1)
	;;=15.847^11.475^16.94^235.519^^^^^^^^^579.235
	;;^UTILITY(U,$J,112,8135,2)
	;;=^^^^^^^^193.443^4.098^4.044^1.257
	;;^UTILITY(U,$J,112,8135,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8136,0)
	;;=SCRAMBLED EGG PLATTER,JACK-IN-THE-BOX^BC-01409^platter^249
	;;^UTILITY(U,$J,112,8136,1)
	;;=9.639^16.064^20.884^265.863^^^^^^^^^477.108
	;;^UTILITY(U,$J,112,8136,2)
	;;=^^^^^^^^142.169^6.867^6.426^1.888
	;;^UTILITY(U,$J,112,8136,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8137,0)
	;;=SHAKE,CHOCOLATE,JACK-IN-THE-BOX^BC-01410^shake^322
	;;^UTILITY(U,$J,112,8137,1)
	;;=3.416^2.174^17.081^102.484^^^^^^^^^83.851
	;;^UTILITY(U,$J,112,8137,2)
	;;=^^^^^^^^7.764^1.335^.652^.311
	;;^UTILITY(U,$J,112,8137,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8138,0)
	;;=SHAKE,STRAWBERRY,JACK-IN-THE-BOX^BC-01411^shake^328
	;;^UTILITY(U,$J,112,8138,1)
	;;=3.049^2.134^16.768^97.561^^^^^^^^^73.171
	;;^UTILITY(U,$J,112,8138,2)
	;;=^^^^^^^^7.622^1.311^.61^.305
	;;^UTILITY(U,$J,112,8138,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8139,0)
	;;=SHAKE,VANILLA,JACK-IN-THE-BOX^BC-01412^shake^317
	;;^UTILITY(U,$J,112,8139,1)
	;;=3.155^1.893^17.981^100.946^^^^^^^^^72.555
	;;^UTILITY(U,$J,112,8139,2)
	;;=^^^^^^^^7.886^1.136^.568^.315
	;;^UTILITY(U,$J,112,8139,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8140,0)
	;;=SHRIMP,JACK-IN-THE-BOX^BC-01413^10-pieces^84
	;;^UTILITY(U,$J,112,8140,1)
	;;=11.905^19.048^26.19^321.429^^^^^^^^^796.429
	;;^UTILITY(U,$J,112,8140,2)
	;;=^^^^^^^^100^8.571^7.738^2.262
	;;^UTILITY(U,$J,112,8140,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8141,0)
	;;=SWISS & BACON BURGER,JACK-IN-THE-BOX^BC-01414^sandwich^187
	;;^UTILITY(U,$J,112,8141,1)
	;;=16.578^25.134^18.182^362.567^^^^^^^^^779.679
	;;^UTILITY(U,$J,112,8141,2)
	;;=^^^^^^^^49.198^10.695^9.626^3.743
	;;^UTILITY(U,$J,112,8141,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8142,0)
	;;=TACO,JACK-IN-THE-BOX^BC-01415^taco^81
	;;^UTILITY(U,$J,112,8142,1)
	;;=9.877^13.58^19.753^235.802^^^^^^^^^501.235
	;;^UTILITY(U,$J,112,8142,2)
	;;=^^^^^^^^25.926^6.42^5.432^1.235
	;;^UTILITY(U,$J,112,8142,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8143,0)
	;;=TACO SALAD,JACK-IN-THE-BOX^BC-01416^salad^402
	;;^UTILITY(U,$J,112,8143,1)
	;;=8.458^7.711^6.965^125.124^^^^^^^^^398.01
	;;^UTILITY(U,$J,112,8143,2)
	;;=^^^^^^^^22.886^3.333^2.96^.398
	;;^UTILITY(U,$J,112,8143,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
