FHINI0GD	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9966,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9967,0)
	;;=SPREADS,PROMISE 53%,SOFT^BC-03240^tbsp.^14
	;;^UTILITY(U,$J,112,9967,1)
	;;=0^52.857^0^464.286^45.714^^^7.143^^^7.143^28.571^485.714^^^^^3735.714
	;;^UTILITY(U,$J,112,9967,2)
	;;=^^^^^^^^0^7.857^^25.714
	;;^UTILITY(U,$J,112,9967,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9968,0)
	;;=SPREADS,PROMISE 68%,SOFT^BC-03241^tbsp.^14
	;;^UTILITY(U,$J,112,9968,1)
	;;=0^67.857^1.429^607.143^28.571^^^14.286^^^21.429^64.286^671.429^^^^^3735.714
	;;^UTILITY(U,$J,112,9968,2)
	;;=^^^^^^^^0^10^^32.857
	;;^UTILITY(U,$J,112,9968,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9969,0)
	;;=SPREADS,SHEDD'S SPREAD 52% VEG OIL,SOFT^BC-03242^tbsp.^14
	;;^UTILITY(U,$J,112,9969,1)
	;;=0^52.143^0^457.143^46.429^^^0^^^7.143^21.429^792.857^^^^^3735.714
	;;^UTILITY(U,$J,112,9969,2)
	;;=^^^^^^^^0^8.571^^24.286
	;;^UTILITY(U,$J,112,9969,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9970,0)
	;;=JAM/JELLY/MARMALADE/PRESERVES,ALL FLAVOR,NUTRADIET^BC-03243^tsp.^7
	;;^UTILITY(U,$J,112,9970,1)
	;;=0^0^14.286^57.143^^^^^^^^^0
	;;^UTILITY(U,$J,112,9970,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9971,0)
	;;=JAM/JELLY/MARMALADE/PRESERVES,ALL FLAVORS,WELCH'S^BC-03244^2-tsp.^10
	;;^UTILITY(U,$J,112,9971,1)
	;;=0^0^90^350^^^^^^^^50^50
	;;^UTILITY(U,$J,112,9971,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9971,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9972,0)
	;;=JELLY,ALL FLAVORS,KRAFT^BC-03245^tsp.^7
	;;^UTILITY(U,$J,112,9972,1)
	;;=0^0^60^228.571^32.857^^^14.286^.714^0^0^57.143^28.571^^^^^0^0^0
	;;^UTILITY(U,$J,112,9972,2)
	;;=0^0^0^0^71.429^0^^^0^0^^0
	;;^UTILITY(U,$J,112,9972,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9973,0)
	;;=PRESERVES,STRAWBERRY,REDUCED CALORIE,KRAFT^BC-03246^tsp.^6
	;;^UTILITY(U,$J,112,9973,1)
	;;=0^0^28.333^100^63.333^^^16.667^.333^0^133.333^150^116.667^0^.017^.167^^0^0^0
	;;^UTILITY(U,$J,112,9973,2)
	;;=0^0^0^0^16.667^0^^^0^0^^0
	;;^UTILITY(U,$J,112,9973,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9974,0)
	;;=SUGAR SUB,EQUAL POWDER^BC-03247^pkt.^1
	;;^UTILITY(U,$J,112,9974,1)
	;;=0^0^100^400^^^^^^^^^0
	;;^UTILITY(U,$J,112,9974,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9975,0)
	;;=SUGAR SUB,SPRINKLE SWEET,PILSBURY^BC-03248^tsp.^0.7
	;;^UTILITY(U,$J,112,9975,1)
	;;=0^0^71.429^285.714^28.571^^^0^0^^0^0^142.857^^^^^0^0^0
	;;^UTILITY(U,$J,112,9975,2)
	;;=0^0
	;;^UTILITY(U,$J,112,9975,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9976,0)
	;;=SUGAR SUB,SUGAR TWIN^BC-03249^pkt.^0.8
	;;^UTILITY(U,$J,112,9976,1)
	;;=0^0^0^375^^^^^^^^0^0
	;;^UTILITY(U,$J,112,9976,2)
	;;=^^^^^^^^0^0^0^0^^^^^0
	;;^UTILITY(U,$J,112,9976,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9977,0)
	;;=SUGAR SUB,SUGAR TWIN,BROWN^BC-03250^tsp.^0.4
	;;^UTILITY(U,$J,112,9977,1)
	;;=0^0^0^500^^^^^^^^0^0
	;;^UTILITY(U,$J,112,9977,2)
	;;=^^^^^^^^0^0^0^0^^^^^0
	;;^UTILITY(U,$J,112,9977,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9978,0)
	;;=SUGAR SUB,SWEET 'N LOW^BC-03251^pkt.^1
	;;^UTILITY(U,$J,112,9978,1)
	;;=0^0^90^400^^^^^^^^300^400
	;;^UTILITY(U,$J,112,9978,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,9978,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9979,0)
	;;=SUGAR SUB,SWEET ONE^BC-03252^pkt.^1
	;;^UTILITY(U,$J,112,9979,1)
	;;=0^0^100^400^0^^^^^^^1100
	;;^UTILITY(U,$J,112,9979,2)
	;;=^^^^^^^^0^0^0^0^^^^^0
	;;^UTILITY(U,$J,112,9979,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9980,0)
	;;=SUGAR SUB,SWEET 10,PILSBURY^BC-03253^1/8-tsp.^0.8
	;;^UTILITY(U,$J,112,9980,1)
	;;=0^0^0^0^100^^^0^0^^0^0^250^^^^^0^0^0
	;;^UTILITY(U,$J,112,9980,2)
	;;=0^0
	;;^UTILITY(U,$J,112,9980,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9981,0)
	;;=SYRUP,BLUEBERRY,NUTRADIET^BC-03254^tbsp.^20
	;;^UTILITY(U,$J,112,9981,1)
	;;=0^0^15^60^^^^^^^^^375
	;;^UTILITY(U,$J,112,9981,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9982,0)
	;;=SYRUP,CORN,DARK,KARO^BC-03255^tbsp.^21
	;;^UTILITY(U,$J,112,9982,1)
	;;=0^0^71.429^285.714^25.714^^^^^^^^190.476
	;;^UTILITY(U,$J,112,9982,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9983,0)
	;;=SYRUP,CORN,LIGHT,KARO^BC-03256^tbsp.^21
