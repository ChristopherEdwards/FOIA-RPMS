FHINI0G9	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9906,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9907,0)
	;;=SALT,KOSHER,MORTON^BC-03180^tsp.^5
	;;^UTILITY(U,$J,112,9907,1)
	;;=0^0^0^0^^^^^^^^^36000
	;;^UTILITY(U,$J,112,9907,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9908,0)
	;;=SALT,SEASONED,MORTON^BC-03181^tsp.^4
	;;^UTILITY(U,$J,112,9908,1)
	;;=12.5^0^12.5^100^^^^300^^^^275^32500
	;;^UTILITY(U,$J,112,9908,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9909,0)
	;;=SALT SUB,MORTON LITE^BC-03182^tsp.^6
	;;^UTILITY(U,$J,112,9909,1)
	;;=0^0^0^0^^^^0^^66.667^^25000^18333.333
	;;^UTILITY(U,$J,112,9909,2)
	;;=^^^^^^^^0^0^^0
	;;^UTILITY(U,$J,112,9909,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9910,0)
	;;=SALT SUB,MORTON SALT SUBSTITUTE^BC-03183^tsp.^6
	;;^UTILITY(U,$J,112,9910,1)
	;;=0^0^1.667^0^^^^500^^0^466.667^46666.667^0
	;;^UTILITY(U,$J,112,9910,2)
	;;=^^^^^^^^0^0^^0^^^^^0
	;;^UTILITY(U,$J,112,9910,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9911,0)
	;;=SALT SUB,MORTON SEASONED SALT SUBSTITUTE^BC-03184^tsp.^5
	;;^UTILITY(U,$J,112,9911,1)
	;;=0^0^10^40^^^^^^^^42000^0
	;;^UTILITY(U,$J,112,9911,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9912,0)
	;;=SALT SUB,NO SALT SALT ALTERNATIVE,SEASONED^BC-03185^tsp.^4.5
	;;^UTILITY(U,$J,112,9912,1)
	;;=0^0^20^88.889^^^^^^^^29555.556^44.444
	;;^UTILITY(U,$J,112,9912,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,9912,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9913,0)
	;;=SALT SUB,NU SALT^BC-03186^tsp.^1
	;;^UTILITY(U,$J,112,9913,1)
	;;=^^^^^^^0^^0^^52800^0
	;;^UTILITY(U,$J,112,9913,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9914,0)
	;;=SALT,SEASONING BLEND,NATURE'S SEASONS,MORTON^BC-03187^tsp.^4
	;;^UTILITY(U,$J,112,9914,1)
	;;=0^0^12.5^75^^^^125^^^^250^35000
	;;^UTILITY(U,$J,112,9914,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9915,0)
	;;=BUTTER,VEG-OIL,BUTTER BLEND,STICK/SOFT,BLUE BONNET^BC-03188^tbsp.^14
	;;^UTILITY(U,$J,112,9915,1)
	;;=0^78.571^0^642.857^^^^^^^^71.429^678.571
	;;^UTILITY(U,$J,112,9915,2)
	;;=^^^^^^^^35.714^14.286^^35.714
	;;^UTILITY(U,$J,112,9915,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9916,0)
	;;=BUTTER,VEG-OIL,BUTTERMATCH BLEND,SHEDD'S^BC-03189^tbsp.^14
	;;^UTILITY(U,$J,112,9916,1)
	;;=0^71.429^0^642.857
	;;^UTILITY(U,$J,112,9916,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9917,0)
	;;=BUTTER,VEG-OIL,BUTTERMATCH BLEND,WHIPPED,SHEDD'S^BC-03190^tbsp.^10
	;;^UTILITY(U,$J,112,9917,1)
	;;=0^70^0^600
	;;^UTILITY(U,$J,112,9917,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9918,0)
	;;=BUTTER,VEG-OIL,BUTTERY BLEND,LIQUID,MRS. FILBERTS^BC-03191^tbsp.^14
	;;^UTILITY(U,$J,112,9918,1)
	;;=0^100^0^857.143^^^^^^^^^428.571
	;;^UTILITY(U,$J,112,9918,2)
	;;=^^^^^^^^0^21.429^^28.571
	;;^UTILITY(U,$J,112,9918,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9919,0)
	;;=BUTTER,VEG-OIL,LAND O LAKES SWEET CREAM SPREAD^BC-03192^tbsp.^14
	;;^UTILITY(U,$J,112,9919,1)
	;;=0^60^0^542.857^^^^7.143^0^^7.143^42.857^550^^^^^3600^0^0
	;;^UTILITY(U,$J,112,9919,2)
	;;=0^0^^^^^^^7.143^10.714^22.857^25
	;;^UTILITY(U,$J,112,9919,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9920,0)
	;;=MARGARINE,BLUE BONNET SOFT^BC-03193^tbsp.^13
	;;^UTILITY(U,$J,112,9920,1)
	;;=0^84.615^0^769.231^^^^^^^^38.462^730.769
	;;^UTILITY(U,$J,112,9920,2)
	;;=^^^^^^^^0^15.385^^30.769
	;;^UTILITY(U,$J,112,9920,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9921,0)
	;;=MARGARINE,BLUE BONND,STICK^BC-03194^tbsp.^14
	;;^UTILITY(U,$J,112,9921,1)
	;;=0^78.571^0^714.286^^^^^^^^35.714^678.571
	;;^UTILITY(U,$J,112,9921,2)
	;;=^^^^^^^^0^14.286^^21.429
	;;^UTILITY(U,$J,112,9921,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9922,0)
	;;=MARGARINE,BLUE BONNET WHIPPED,SOFT^BC-03195^tbsp.^11
	;;^UTILITY(U,$J,112,9922,1)
	;;=0^63.636^0^636.364^^^^^^^^45.455^636.364
	;;^UTILITY(U,$J,112,9922,2)
	;;=^^^^^^^^0^18.182^^18.182
	;;^UTILITY(U,$J,112,9922,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9923,0)
	;;=MARGARINE,FLEISCHMANN'S SOFT^BC-03196^tbsp.^13
	;;^UTILITY(U,$J,112,9923,1)
	;;=0^84.615^0^769.231^^^^^^^^38.462^730.769
	;;^UTILITY(U,$J,112,9923,2)
	;;=^^^^^^^^0^15.385^^38.462
