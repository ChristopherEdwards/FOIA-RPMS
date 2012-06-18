FHINI0GA	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9923,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9924,0)
	;;=MARGARINE,FLEISCHMANN'S SQUEEZE^BC-03197^tbsp.^13
	;;^UTILITY(U,$J,112,9924,1)
	;;=0^84.615^0^769.231^^^^^^^^38.462^653.846
	;;^UTILITY(U,$J,112,9924,2)
	;;=^^^^^^^^0^15.385^^46.154
	;;^UTILITY(U,$J,112,9924,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9925,0)
	;;=MARGARINE,FLEISCHMANN'S STICK^BC-03198^tbsp.^14
	;;^UTILITY(U,$J,112,9925,1)
	;;=0^78.571^0^714.286^^^^^^^^35.714^678.571
	;;^UTILITY(U,$J,112,9925,2)
	;;=^^^^^^^^0^14.286^^28.571
	;;^UTILITY(U,$J,112,9925,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9926,0)
	;;=MARGARINE,FLEISCHMANN'S WHIPPED,LIGHT SALTED^BC-03199^tbsp.^11
	;;^UTILITY(U,$J,112,9926,1)
	;;=0^63.636^0^636.364^^^^^^^^45.455^545.455
	;;^UTILITY(U,$J,112,9926,2)
	;;=^^^^^^^^0^18.182^^27.273
	;;^UTILITY(U,$J,112,9926,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9927,0)
	;;=MARGARINE,LMPERIAL QUARTERS,STICK^BC-03200^tbsp.^15
	;;^UTILITY(U,$J,112,9927,1)
	;;=0^80^.667^713.333^16.667^^^13.333^^^13.333^40^753.333^^^^^3733.333
	;;^UTILITY(U,$J,112,9927,2)
	;;=^^^^^^^^0^14.667^^21.333
	;;^UTILITY(U,$J,112,9927,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9928,0)
	;;=MARGARINE,IMPERIAL SOFT^BC-03201^tbsp.^14
	;;^UTILITY(U,$J,112,9928,1)
	;;=0^80^.714^714.286^16.429^^^14.286^^^14.286^42.857^750^^^^^3735.714
	;;^UTILITY(U,$J,112,9928,2)
	;;=^^^^^^^^0^13.571^^37.857
	;;^UTILITY(U,$J,112,9928,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9929,0)
	;;=MARGARINE,LAND O LAKES,CORN,STICK^BC-03202^tbsp.^14
	;;^UTILITY(U,$J,112,9929,1)
	;;=0^80^0^721.429^^^^0^0^^0^7.143^728.571^^^^^3650^0^0
	;;^UTILITY(U,$J,112,9929,2)
	;;=0^0^^^^^^^0^12.857^41.429^25.714
	;;^UTILITY(U,$J,112,9929,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9930,0)
	;;=MARGARINE,LAND O LAKES,SOY,STICK/TUB^BC-03203^tbsp.^14
	;;^UTILITY(U,$J,112,9930,1)
	;;=0^85.714^0^750^^^^^^^^0^750
	;;^UTILITY(U,$J,112,9930,2)
	;;=^^^^^^^^0^21.429^42.857^21.429
	;;^UTILITY(U,$J,112,9930,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9931,0)
	;;=MARGARINE,MAZOLA^BC-03204^tbsp.^14
	;;^UTILITY(U,$J,112,9931,1)
	;;=0^80^1.429^714.286^16.429^^^^^^^^714.286^^^^^3571.429
	;;^UTILITY(U,$J,112,9931,2)
	;;=^^^^^^^^0^13.571^37.143^27.857
	;;^UTILITY(U,$J,112,9931,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9932,0)
	;;=MARGARINE,MAZOLA UNSALTED^BC-03205^tbsp.^14
	;;^UTILITY(U,$J,112,9932,1)
	;;=0^80^0^714.286^19.286^^^^^^^^7.143^^^^^3571.429
	;;^UTILITY(U,$J,112,9932,2)
	;;=^^^^^^^^0^14.286^38.571^26.429
	;;^UTILITY(U,$J,112,9932,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9933,0)
	;;=MARGARINE,NUCOA^BC-03206^tbsp.^14
	;;^UTILITY(U,$J,112,9933,1)
	;;=0^80.714^0^714.286^16.429^^^^^^^^1142.857^^^^^3571.429
	;;^UTILITY(U,$J,112,9933,2)
	;;=^^^^^^^^0^17.143^^23.571
	;;^UTILITY(U,$J,112,9933,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9934,0)
	;;=MARGARINE,NUCOA SOFT^BC-03207^tbsp.^13
	;;^UTILITY(U,$J,112,9934,1)
	;;=0^80.769^.769^692.308^15.385^^^^^^^^1153.846^^^^^4000
	;;^UTILITY(U,$J,112,9934,2)
	;;=^^^^^^^^0^15.385^^32.308
	;;^UTILITY(U,$J,112,9934,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9935,0)
	;;=MARGARINE,SHEDD'S LIQUID^BC-03208^tbsp.^14
	;;^UTILITY(U,$J,112,9935,1)
	;;=0^78.571^0^714.286^^^^^^^^^714.286
	;;^UTILITY(U,$J,112,9935,2)
	;;=^^^^^^^^0^14.286^^42.857
	;;^UTILITY(U,$J,112,9935,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9936,0)
	;;=MARGARINE,SHEDD'S SOFT^BC-03209^tbsp.^14
	;;^UTILITY(U,$J,112,9936,1)
	;;=0^80^0^707.143^17.857^^^0^^^7.143^0^785.714^^^^^3735.714
	;;^UTILITY(U,$J,112,9936,2)
	;;=^^^^^^^^0^13.571^^37.857
	;;^UTILITY(U,$J,112,9936,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9937,0)
	;;=MARGARINE,SHEDD'S,WHIPPED,SOFT^BC-03210^tbsp.^11
	;;^UTILITY(U,$J,112,9937,1)
	;;=0^80^0^709.091^17.273^^^0^^^9.091^0^790.909^^^^^3736.364
	;;^UTILITY(U,$J,112,9937,2)
	;;=^^^^^^^^0^13.636^^38.182
	;;^UTILITY(U,$J,112,9937,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9938,0)
	;;=MARGARINE,SHEDD'S,WHIPPED,STICK^BC-03211^tbsp.^11
	;;^UTILITY(U,$J,112,9938,1)
	;;=0^80^0^709.091^18.182^^^0^^^9.091^0^790.909^^^^^3736.364
	;;^UTILITY(U,$J,112,9938,2)
	;;=^^^^^^^^0^14.545^^27.273
