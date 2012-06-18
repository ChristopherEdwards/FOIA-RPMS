FHINI0CF	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,7985,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7986,0)
	;;=CROISSANDWICH W/EGG & CHEESE,BURGER KING^BC-01259^sandwich^110
	;;^UTILITY(U,$J,112,7986,1)
	;;=11.818^18.182^17.273^286.364^^^^^^^^^551.818
	;;^UTILITY(U,$J,112,7986,2)
	;;=^^^^^^^^201.818^6.364^9.091^1.818
	;;^UTILITY(U,$J,112,7986,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7987,0)
	;;=CROISSANDWICH W/HAM,EGG & CHEESE,BURGER KING^BC-01260^sandwich^144
	;;^UTILITY(U,$J,112,7987,1)
	;;=13.194^14.583^13.194^240.278^^^^94.444^1.5^16.667^220.139^177.778^668.056^1.299^^^^295.833^^.34
	;;^UTILITY(U,$J,112,7987,2)
	;;=.222^2.222^^^^^^^167.361^4.861^7.639^1.389
	;;^UTILITY(U,$J,112,7987,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7988,0)
	;;=CROISSANDWICH W/SAUSAGE,EGG & CHEESE,BURGER KING^BC-01261^sandwich^159
	;;^UTILITY(U,$J,112,7988,1)
	;;=13.208^25.157^13.836^335.849^^^^91.195^1.818^11.95^183.648^183.648^619.497^1.528^^^^267.925^^.226
	;;^UTILITY(U,$J,112,7988,2)
	;;=.201^2.642^^^^^^^168.553^8.176^12.579^3.145
	;;^UTILITY(U,$J,112,7988,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7989,0)
	;;=CROISSANT,BURGER KING^BC-01262^croissants^41
	;;^UTILITY(U,$J,112,7989,1)
	;;=9.756^24.39^43.902^439.024^^^^^^^^^695.122
	;;^UTILITY(U,$J,112,7989,2)
	;;=^^^^^^^^9.756^4.878^17.073^2.439
	;;^UTILITY(U,$J,112,7989,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7990,0)
	;;=DANISH,BURGER KING^BC-01263^danish^113
	;;^UTILITY(U,$J,112,7990,1)
	;;=4.425^31.858^35.398^442.478^^^^^^^^^254.867
	;;^UTILITY(U,$J,112,7990,2)
	;;=^^^^^^^^5.31^20.354
	;;^UTILITY(U,$J,112,7990,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7991,0)
	;;=FISH FILLET,OCEAN CATCH,BURGER KING^BC-01264^fillet^194
	;;^UTILITY(U,$J,112,7991,1)
	;;=10.309^12.887^25.258^255.155^^^^^^^^^453.093
	;;^UTILITY(U,$J,112,7991,2)
	;;=^^^^^^^^29.381^2.062^3.093^6.701
	;;^UTILITY(U,$J,112,7991,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7992,0)
	;;=FISH TENDERS,BURGER KING^BC-01265^serving^99
	;;^UTILITY(U,$J,112,7992,1)
	;;=12.121^16.162^12.121^269.697^^^^^^^^^878.788
	;;^UTILITY(U,$J,112,7992,2)
	;;=^^^^^^^^28.283^3.03^7.071^4.04
	;;^UTILITY(U,$J,112,7992,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7993,0)
	;;=FRENCH FRIES,BURGER KING^BC-01266^med-servg^111
	;;^UTILITY(U,$J,112,7993,1)
	;;=3.604^18.018^32.432^307.207^^^^^^^^^217.117
	;;^UTILITY(U,$J,112,7993,2)
	;;=^^^^^^^^18.919^9.009^8.108^0
	;;^UTILITY(U,$J,112,7993,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7994,0)
	;;=FRENCH TOAST STICKS,BURGER KING^BC-01267^serving^141
	;;^UTILITY(U,$J,112,7994,1)
	;;=7.092^22.695^37.589^381.56^^^^^^^^^380.851
	;;^UTILITY(U,$J,112,7994,2)
	;;=^^^^^^^^56.738^3.546^10.638^7.801
	;;^UTILITY(U,$J,112,7994,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7995,0)
	;;=HAMBURGER,BURGER KING^BC-01268^sandwich^108
	;;^UTILITY(U,$J,112,7995,1)
	;;=13.889^10.185^25.926^251.852^^^^34.259^2.528^21.296^114.815^217.593^467.593^^.056^^^138.889^2.778^.213
	;;^UTILITY(U,$J,112,7995,2)
	;;=.231^3.611^^^^^^^34.259^3.704^4.63^.926
	;;^UTILITY(U,$J,112,7995,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7996,0)
	;;=HAMBURGER DELUXE,BURGER KING^BC-01269^sandwich^138
	;;^UTILITY(U,$J,112,7996,1)
	;;=10.87^13.768^20.29^249.275^^^^^^^^^359.42
	;;^UTILITY(U,$J,112,7996,2)
	;;=^^^^^^^^31.159^4.348^4.348^5.072
	;;^UTILITY(U,$J,112,7996,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7997,0)
	;;=HASH BROWNS,BURGER KING^BC-01270^serving^71
	;;^UTILITY(U,$J,112,7997,1)
	;;=2.817^16.901^35.211^300^^^^^^^^^447.887
	;;^UTILITY(U,$J,112,7997,2)
	;;=^^^^^^^^4.225^4.225^8.451^4.225
	;;^UTILITY(U,$J,112,7997,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7998,0)
	;;=ONION RINGS,BURGER KING^BC-01271^reg-servg^86
	;;^UTILITY(U,$J,112,7998,1)
	;;=4.651^19.767^32.558^351.163^^^^144.186^.93^20.93^226.744^201.163^650^.43^.105
	;;^UTILITY(U,$J,112,7998,2)
	;;=^^^^^^^^3.488^4.651^9.302^4.651
	;;^UTILITY(U,$J,112,7998,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7999,0)
	;;=PIE,APPLE,BURGER KING^BC-01272^snack pie^125
	;;^UTILITY(U,$J,112,7999,1)
	;;=2.4^11.2^35.2^248.8^^^^^.944^^24.8^97.6^329.6^^^^^^4^.216
	;;^UTILITY(U,$J,112,7999,2)
	;;=.128^.48^^^^^^^3.2^3.2^6.4^.8
