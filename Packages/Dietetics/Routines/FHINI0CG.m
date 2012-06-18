FHINI0CG	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,7999,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8000,0)
	;;=SALAD DRESSING,BLUE CHEESE,BURGER KING^BC-01273^serving^59
	;;^UTILITY(U,$J,112,8000,1)
	;;=5.085^54.237^3.39^508.475^^^^^^^^^867.797
	;;^UTILITY(U,$J,112,8000,2)
	;;=^^^^^^^^98.305^11.864^11.864^27.119
	;;^UTILITY(U,$J,112,8000,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8001,0)
	;;=SALAD DRESSING,FRENCH,BURGER KING^BC-01274^serving^64
	;;^UTILITY(U,$J,112,8001,1)
	;;=0^34.375^35.938^453.125^^^^^^^^^625
	;;^UTILITY(U,$J,112,8001,2)
	;;=^^^^^^^^3.125^4.688^15.625^12.5
	;;^UTILITY(U,$J,112,8001,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8002,0)
	;;=SALAD DRESSING,ITALIAN,REDUCED CALORIE LIGHT,BURGER KING^BC-01275^serving^59
	;;^UTILITY(U,$J,112,8002,1)
	;;=0^30.508^5.085^288.136^^^^^^^^^1291.525
	;;^UTILITY(U,$J,112,8002,2)
	;;=^^^^^^^^5.085^5.085^8.475^16.949
	;;^UTILITY(U,$J,112,8002,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8003,0)
	;;=SALAD DRESSING,RANCH,BURGER KING^BC-01276^serving^57
	;;^UTILITY(U,$J,112,8003,1)
	;;=1.754^64.912^7.018^614.035^^^^^^^^^554.386
	;;^UTILITY(U,$J,112,8003,2)
	;;=^^^^^^^^35.088^12.281^14.035^36.842
	;;^UTILITY(U,$J,112,8003,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8004,0)
	;;=SALAD DRESSING,OLIVE OIL & VINEGAR,BURGER KING^BC-01277^serving^56
	;;^UTILITY(U,$J,112,8004,1)
	;;=0^58.929^3.571^553.571^^^^^^^^^382.143
	;;^UTILITY(U,$J,112,8004,2)
	;;=^^^^^^^^10.714^8.929^32.143^16.071
	;;^UTILITY(U,$J,112,8004,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8005,0)
	;;=SALAD DRESSING,THOUSAND ISLAND,BURGER KING^BC-01278^serving^63
	;;^UTILITY(U,$J,112,8005,1)
	;;=1.587^41.27^23.81^460.317^^^^^^^^^639.683
	;;^UTILITY(U,$J,112,8005,2)
	;;=^^^^^^^^57.143^7.937^7.937^22.222
	;;^UTILITY(U,$J,112,8005,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8006,0)
	;;=SALAD W/O DRESSING,CHEF,BURGER KING^BC-01279^salad^273
	;;^UTILITY(U,$J,112,8006,1)
	;;=6.227^3.297^2.564^65.201^^^^^^^^^208.059
	;;^UTILITY(U,$J,112,8006,2)
	;;=^^^^^^^^37.729^1.465^1.099^.366
	;;^UTILITY(U,$J,112,8006,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8007,0)
	;;=SALAD W/O DRESSING,CHUNKY CHICKEN,BURGER KING^BC-01280^salad^258
	;;^UTILITY(U,$J,112,8007,1)
	;;=7.752^1.55^3.101^55.039^^^^^^^^^171.705
	;;^UTILITY(U,$J,112,8007,2)
	;;=^^^^^^^^18.992^.388^.388^.388
	;;^UTILITY(U,$J,112,8007,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8008,0)
	;;=SALAD W/O DRESSING,GARDEN,BURGER KING^BC-01281^salad^223
	;;^UTILITY(U,$J,112,8008,1)
	;;=2.691^2.242^3.587^42.601^^^^^^^^^56.054
	;;^UTILITY(U,$J,112,8008,2)
	;;=^^^^^^^^6.726^1.345^.448^0
	;;^UTILITY(U,$J,112,8008,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8009,0)
	;;=SALAD W/O DRESSING,SIDE,BURGER KING^BC-01282^salad^135
	;;^UTILITY(U,$J,112,8009,1)
	;;=.741^0^3.704^18.519^^^^^^^^^20
	;;^UTILITY(U,$J,112,8009,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8009,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8010,0)
	;;=SAUCE,BARBEQUE DIPPING SCE,BURGER KING^BC-01283^serving^28
	;;^UTILITY(U,$J,112,8010,1)
	;;=0^0^32.143^128.571^^^^^^^^^1417.857
	;;^UTILITY(U,$J,112,8010,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8010,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8011,0)
	;;=SAUCE,BROILER SCE,BURGER KING^BC-01284^serving^14
	;;^UTILITY(U,$J,112,8011,1)
	;;=0^71.429^0^642.857^^^^^^^^^678.571
	;;^UTILITY(U,$J,112,8011,2)
	;;=^^^^^^^^50^7.143^14.286^35.714
	;;^UTILITY(U,$J,112,8011,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8012,0)
	;;=SAUCE,AM EXPRESS DIP,BURGER KING^BC-01285^serving^28
	;;^UTILITY(U,$J,112,8012,1)
	;;=0^0^75^300^^^^^^^^^64.286
	;;^UTILITY(U,$J,112,8012,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8012,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8013,0)
	;;=SAUCE,HONEY DIPPING SCE,BURGER KING^BC-01286^serving^28
	;;^UTILITY(U,$J,112,8013,1)
	;;=0^0^82.143^325^^^^^^^^^42.857
	;;^UTILITY(U,$J,112,8013,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8013,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8014,0)
	;;=SAUCE,RANCH DIPPING SCE,BURGER KING^BC-01287^serving^28
	;;^UTILITY(U,$J,112,8014,1)
	;;=0^64.286^7.143^610.714^^^^^^^^^742.857
	;;^UTILITY(U,$J,112,8014,2)
	;;=^^^^^^^^0^10.714^14.286^35.714
