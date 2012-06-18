FHINI09W	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6765,0)
	;;=CARBONATED BEV.,DIET RC^BC-00038^cans^360
	;;^UTILITY(U,$J,112,6765,1)
	;;=0^0^.111^.278^^^^^^^11.389^16.667^.278
	;;^UTILITY(U,$J,112,6765,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6766,0)
	;;=CARBONATED BEV.,DIET RITE COLA^BC-00039^cans^360
	;;^UTILITY(U,$J,112,6766,1)
	;;=0^0^.111^.556^^^^^^^11.111^16.667^.278
	;;^UTILITY(U,$J,112,6766,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,6766,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6767,0)
	;;=CARBONATED BEV.,DIET RITE RED RASPBERRY^BC-00040^cans^360
	;;^UTILITY(U,$J,112,6767,1)
	;;=0^0^.278^1.111^^^^^^^0^33.333^0
	;;^UTILITY(U,$J,112,6767,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,6767,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6768,0)
	;;=CARBONATED BEV.,DIET SLICE^BC-00041^cans^360
	;;^UTILITY(U,$J,112,6768,1)
	;;=0^0^1.667^7.222^96.667^^^0^0^^0^27.778^3.056
	;;^UTILITY(U,$J,112,6768,2)
	;;=^^^^^^^^^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6768,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6769,0)
	;;=CARBONATED BEV.,DIET SPRITE^BC-00042^cans^354
	;;^UTILITY(U,$J,112,6769,1)
	;;=0^0^0^1.13^^^^^^^0^15.819^0^^^^^^0
	;;^UTILITY(U,$J,112,6769,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6770,0)
	;;=CARBONATED BEV.,DIET SUNKIST ORANGE^BC-00043^cans^360
	;;^UTILITY(U,$J,112,6770,1)
	;;=0^0^0^1.111^^^^0^0^^^0^6.667
	;;^UTILITY(U,$J,112,6770,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6771,0)
	;;=CARBONATED BEV.,TAB^BC-00044^cans^354
	;;^UTILITY(U,$J,112,6771,1)
	;;=0^0^.085^.282^^^^^^^12.994^5.085^2.26
	;;^UTILITY(U,$J,112,6771,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6772,0)
	;;=CEREAL GRAIN BEV.,PREP FROM POWDER W/WATER,POSTUM^BC-00045^6-floz.^183
	;;^UTILITY(U,$J,112,6772,1)
	;;=.109^0^1.421^6.011^98.361^^^4.372^.109^5.464^10.929^53.005^1.639^.137^.033^^^0^0^.011
	;;^UTILITY(U,$J,112,6772,2)
	;;=.005^.383^.027^.005^2.732^0^^^0^0^0^0
	;;^UTILITY(U,$J,112,6772,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6773,0)
	;;=FRUIT FLAVOR BEV.,BERRY BLEND FROM PWDR,CRYSTAL LIGHT^BC-00046^8-floz.^240
	;;^UTILITY(U,$J,112,6773,1)
	;;=.042^0^.083^1.25^100^^^^^6.667^0^18.75^0^0^^^^0^2.5^0
	;;^UTILITY(U,$J,112,6773,2)
	;;=0^0^0^0^0^0^^^0^0^0^0
	;;^UTILITY(U,$J,112,6773,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6774,0)
	;;=FRUIT FLAVOR BEV.,CITRUS BLEND FROM PWDR,CRYSTAL LIGHT^BC-00047^8-floz.^238
	;;^UTILITY(U,$J,112,6774,1)
	;;=.042^0^.084^1.261^99.37^^^^^8.824^0^19.328^0^0^^^^0^2.521^0
	;;^UTILITY(U,$J,112,6774,2)
	;;=0^0^0^0^0^0^^^0^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6774,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6775,0)
	;;=FRUIT JUICE DRINK,CRANGRAPE DRINK,OCEAN SPRAY^BC-00048^6-floz.^190
	;;^UTILITY(U,$J,112,6775,1)
	;;=0^0^13.684^57.895^^^^3.684^.132^2.105^3.684^19.474^3.684^^.012^^^^31.579^.011
	;;^UTILITY(U,$J,112,6775,2)
	;;=.016^.105
	;;^UTILITY(U,$J,112,6775,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6776,0)
	;;=FRUIT JUICE DRINK,CRANRASPBERRY DRINK,OCEAN SPRAY^BC-00049^6-floz.^190
	;;^UTILITY(U,$J,112,6776,1)
	;;=0^0^14.211^57.895^^^^^^^^18.421^3.158^^^^^^31.579
	;;^UTILITY(U,$J,112,6776,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6777,0)
	;;=FRUIT JUICE DRINK,FRUIT JUICY RED,HAWAIIAN PUNCH^BC-00050^6-floz.^185
	;;^UTILITY(U,$J,112,6777,1)
	;;=0^0^11.892^48.649^^^^1.622^^^1.081^16.216^9.189^^^^^5.405^32.432^0
	;;^UTILITY(U,$J,112,6777,2)
	;;=0^0
	;;^UTILITY(U,$J,112,6777,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6778,0)
	;;=FRUIT JUICE DRINK,FRUIT PUNCH,LOW SUGAR,HAWAIIAN PUNCH^BC-00051^6-floz.^185
	;;^UTILITY(U,$J,112,6778,1)
	;;=0^0^4.324^16.216^^^^2.703^^^1.081^16.216^10.811^^^^^17.297^32.432^0
	;;^UTILITY(U,$J,112,6778,2)
	;;=0^0
	;;^UTILITY(U,$J,112,6778,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6779,0)
	;;=FRUIT JUICE DRINK,FRUIT SLUSH,WYLER'S^BC-00052^4-floz.^132
	;;^UTILITY(U,$J,112,6779,1)
	;;=0^0^29.773^118.939^^^^1.515^0^.758^.758^25.758^7.576^0^0^0^^0^0^0
	;;^UTILITY(U,$J,112,6779,2)
	;;=0^0^^^^^^^0
	;;^UTILITY(U,$J,112,6779,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6780,0)
	;;=FRUIT FLAVOR BEV.,KOOL-AID,FROM PWDR^BC-00053^8-floz.^240
	;;^UTILITY(U,$J,112,6780,1)
	;;=0^0^10.458^40.833^^^^6.25^^^2.917^.417^5.833^0^^^^0^2.5^0
