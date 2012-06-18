FHINI0DG	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8523,2)
	;;=.2^4^.72^.2^56^0^^^^^^^^^^^6.4
	;;^UTILITY(U,$J,112,8523,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8524,0)
	;;=GRAINED PRODUCTS,WHOLE WHEAT,100%,ROMAN MEAL^BC-01797^slice^28
	;;^UTILITY(U,$J,112,8524,1)
	;;=10.714^3.214^46.071^232.143^38.571^^^53.571^4.286^^^^464.286^^^^^^^1.071
	;;^UTILITY(U,$J,112,8524,2)
	;;=.357^5^^^^^^^0^^^^^^^^5.714
	;;^UTILITY(U,$J,112,8524,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8525,0)
	;;=GRAINED PRODUCTS,WHOLE WHEAT,100% WHOLE GRAIN,ROMAN MEAL^BC-01798^slice^28
	;;^UTILITY(U,$J,112,8525,1)
	;;=10.714^2.5^46.429^235.714^38.571^^^50^4.643^^^^503.571^^^^^^^.357
	;;^UTILITY(U,$J,112,8525,2)
	;;=.357^5.357^^^^^^^0^^^^^^^^5.714
	;;^UTILITY(U,$J,112,8525,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8526,0)
	;;=BREADSTICKS^BC-01799^2-sticks^20
	;;^UTILITY(U,$J,112,8526,1)
	;;=12^3^75.5^385^5^^^30^.9^^100^90^700^^^^^0^0^.05
	;;^UTILITY(U,$J,112,8526,2)
	;;=.05^1^^^^^^^^.5
	;;^UTILITY(U,$J,112,8526,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8527,0)
	;;=BREADSTICKS,KEEBLER^BC-01800^2-sticks^8
	;;^UTILITY(U,$J,112,8527,1)
	;;=13.75^3.75^71.25^375^^^^25^3.75^^^175^187.5^^^^^^^.625
	;;^UTILITY(U,$J,112,8527,2)
	;;=.25^6.25^^^^^^^0^1.25^^0
	;;^UTILITY(U,$J,112,8527,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8528,0)
	;;=BREADSTICKS,GARLIC,KEEBLER^BC-01801^2-sticks^8
	;;^UTILITY(U,$J,112,8528,1)
	;;=15^3.75^76.25^400^^^^25^4^^^187.5^200^^^^^0^0^.625
	;;^UTILITY(U,$J,112,8528,2)
	;;=.25^7.5^^^^^^^0^^^1.25
	;;^UTILITY(U,$J,112,8528,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8529,0)
	;;=BREADSTICKS,ONION,KEEBLER^BC-01802^2-sticks^8
	;;^UTILITY(U,$J,112,8529,1)
	;;=15^3.75^75^400^^^^25^5.25^^^225^225^^^^^^^.75
	;;^UTILITY(U,$J,112,8529,2)
	;;=.5^7.5^^^^^^^0^^^1.25
	;;^UTILITY(U,$J,112,8529,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8530,0)
	;;=BREADSTICKS,SESAME,KEEBLER^BC-01803^2-sticks^8
	;;^UTILITY(U,$J,112,8530,1)
	;;=15^8.75^66.25^400^^^^25^4^^^162.5^225^^^^^^^.5
	;;^UTILITY(U,$J,112,8530,2)
	;;=.25^6.25^^^^^^^0^1.25^^0
	;;^UTILITY(U,$J,112,8530,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8531,0)
	;;=BREADSTICKS,SOFT FROM REFRIG DOUGH,PILLSBURY^BC-01804^1.4-oz.^39
	;;^UTILITY(U,$J,112,8531,1)
	;;=8.462^5.897^42.564^258.974^39.487^^^17.949^2.692^^74.359^61.538^600^^^^^0^2.564^3.872
	;;^UTILITY(U,$J,112,8531,2)
	;;=.256^3.077
	;;^UTILITY(U,$J,112,8531,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8532,0)
	;;=BREADSTICKS,SOFT,ROMAN MEAL^BC-01805^1.38-oz.^39
	;;^UTILITY(U,$J,112,8532,1)
	;;=7.949^10^44.615^300^^^^20.513^2.103^^^148.718^702.564^^^^^^^2.769
	;;^UTILITY(U,$J,112,8532,2)
	;;=.179^2.564^^^^^^^0^3.077^^2.564^^^^^2.051
	;;^UTILITY(U,$J,112,8532,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8533,0)
	;;=CRACKERS,BETTER CHEDDARS,NABISCO^BC-01806^10-cracker^14
	;;^UTILITY(U,$J,112,8533,1)
	;;=14.286^28.571^57.143^500^^^^^^^^^928.571
	;;^UTILITY(U,$J,112,8533,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8533,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8534,0)
	;;=CRACKERS,BIG TOWN,LANCE^BC-01807^2-oz.^57
	;;^UTILITY(U,$J,112,8534,1)
	;;=4.737^13.86^67.719^415.789^11.579^^^96.491^1.842^^^510.526^247.368^^^^^^^.088
	;;^UTILITY(U,$J,112,8534,2)
	;;=.193^1.053
	;;^UTILITY(U,$J,112,8534,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8535,0)
	;;=CRACKERS,BONNIE,LANCE (SANDWICH)^BC-01808^1.2-oz.^34
	;;^UTILITY(U,$J,112,8535,1)
	;;=6.176^19.118^69.118^458.824^2.941^^^41.176^3.176^^^117.647^514.706^^^^^244.118^5.882^.353
	;;^UTILITY(U,$J,112,8535,2)
	;;=.559^3.824^^^^^^^14.706^5.882^10.588^2.647
	;;^UTILITY(U,$J,112,8535,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8536,0)
	;;=CRACKERS,CHEESE NIPS,NABISCO^BC-01809^13-cracker^14
	;;^UTILITY(U,$J,112,8536,1)
	;;=7.143^21.429^64.286^500^^^^^^^^178.571^928.571
	;;^UTILITY(U,$J,112,8536,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8536,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8537,0)
	;;=CRACKERS,CHEESE RITZ BITS,NABISCO^BC-01810^22-cracker^14
	;;^UTILITY(U,$J,112,8537,1)
	;;=7.143^28.571^64.286^500^^^^^^^^107.143^1071.429
	;;^UTILITY(U,$J,112,8537,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8537,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
