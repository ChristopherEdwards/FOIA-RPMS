FHINI0FI	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9532,1)
	;;=0^0^46.667^166.667^^^^^^^^33.333^1266.667
	;;^UTILITY(U,$J,112,9532,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9532,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9533,0)
	;;=SAUCE,SZECHWAN,HOT & SPICY,LACHOY^BC-02806^tbsp.^15
	;;^UTILITY(U,$J,112,9533,1)
	;;=0^0^40^166.667^^^^^^^^33.333^466.667^^^^^^13.333
	;;^UTILITY(U,$J,112,9533,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9533,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9534,0)
	;;=SAUCE,TACO,MED CHUNKY,ROSARITA^BC-02807^3-tbsp.^43
	;;^UTILITY(U,$J,112,9534,1)
	;;=2.326^0^13.953^58.14^^^^46.512^1.628^^^232.558^720.93^^^^^^37.209^.116
	;;^UTILITY(U,$J,112,9534,2)
	;;=.465^1.628^^^^^^^0^^^^202.326^^^^0
	;;^UTILITY(U,$J,112,9534,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9535,0)
	;;=SAUCE,TACO,MILD CHUNKY,ROSARITA^BC-02808^3-tbsp.^43
	;;^UTILITY(U,$J,112,9535,1)
	;;=2.326^0^13.953^58.14^^^^44.186^1.628^^^209.302^697.674^^^^^^37.209^.116
	;;^UTILITY(U,$J,112,9535,2)
	;;=.442^1.628^^^^^^^0^^^^186.047^^^^0
	;;^UTILITY(U,$J,112,9535,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9536,0)
	;;=SAUCE,TACO,MILD,ROSARITA^BC-02809^3-tbsp.^43
	;;^UTILITY(U,$J,112,9536,1)
	;;=0^0^9.302^34.884^^^^58.14^.465^^^302.326^720.93^^^^^^16.279^.07
	;;^UTILITY(U,$J,112,9536,2)
	;;=.047^1.163^^^^^^^0^^^^106.977^^^^0
	;;^UTILITY(U,$J,112,9536,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9537,0)
	;;=SAUCE,TARTAR,BEST FOODS/HELLMANN'S^BC-02810^tbsp.^14
	;;^UTILITY(U,$J,112,9537,1)
	;;=1.429^57.143^.714^500^37.143^^^^^^^^1357.143
	;;^UTILITY(U,$J,112,9537,2)
	;;=^^^^^^^^35.714
	;;^UTILITY(U,$J,112,9537,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9538,0)
	;;=SAUCE,TERIYAKI,KIKKOMAN^BC-02811^tbsp.^15
	;;^UTILITY(U,$J,112,9538,1)
	;;=^0^21.333^100^68^^^^^^^300^4173.333
	;;^UTILITY(U,$J,112,9538,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9538,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9539,0)
	;;=SAUCE,TERIYAKI,KIKKOMAN BASTE & GLAZE^BC-02812^tbsp.^15
	;;^UTILITY(U,$J,112,9539,1)
	;;=^0^34.667^160^58.667^^^^^^^213.333^2066.667
	;;^UTILITY(U,$J,112,9539,2)
	;;=^^^^^^^^0^^^^^^^^.667
	;;^UTILITY(U,$J,112,9539,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9540,0)
	;;=SAUCE,TERIYAKI,LACHOY^BC-02813^tbsp.^15
	;;^UTILITY(U,$J,112,9540,1)
	;;=0^0^40^200^^^^^^^^600^11600
	;;^UTILITY(U,$J,112,9540,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9540,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9541,0)
	;;=SAUCE,TOMATO,CND,CONTADINA^BC-02814^1/2-cup^122
	;;^UTILITY(U,$J,112,9541,1)
	;;=.82^0^5.738^24.59^91.803^^^18.852^.598^24.59^28.689^327.869^475.41^^^^^1322.951^20.492^.066
	;;^UTILITY(U,$J,112,9541,2)
	;;=.057^.738^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,9541,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9542,0)
	;;=SAUCE,TOMATO,CND,CONTADINA,ITALIAN STYLE^BC-02815^1/2-cup^124
	;;^UTILITY(U,$J,112,9542,1)
	;;=.806^0^5.645^24.194^91.129^^^23.387^.581^27.419^24.194^338.71^540.323^^^^^786.29^20.161^.04
	;;^UTILITY(U,$J,112,9542,2)
	;;=.032^.968^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,9542,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9543,0)
	;;=SAUCE,TOMATO,CND,CONTADINA,THICK & ZESTY^BC-02816^1/2-cup^124
	;;^UTILITY(U,$J,112,9543,1)
	;;=1.613^0^6.452^32.258^^^^23.387^1.25^13.71^25.806^370.968^524.194^^^^^1172.581^24.194^.065
	;;^UTILITY(U,$J,112,9543,2)
	;;=.04^1.048
	;;^UTILITY(U,$J,112,9543,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9544,0)
	;;=SAUCE,TOMATO,CND,HEINZ,NO SALT ADDED^BC-02817^3.5-oz.^100
	;;^UTILITY(U,$J,112,9544,1)
	;;=1^.1^6.9^32^91.3^^^14^.5^14^20^299^17^.17^.15^^^618^5^.05
	;;^UTILITY(U,$J,112,9544,2)
	;;=.04^.9
	;;^UTILITY(U,$J,112,9544,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9545,0)
	;;=SAUCE,TOMATO,CND,HUNT^BC-02818^4-oz.^113
	;;^UTILITY(U,$J,112,9545,1)
	;;=.885^0^6.195^26.549^^^^15.044^.531^^^292.035^575.221^^^^^^13.274^.053
	;;^UTILITY(U,$J,112,9545,2)
	;;=.053^1.062^^^^^^^0^^^^88.496^^^^1.77
	;;^UTILITY(U,$J,112,9545,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9546,0)
	;;=SAUCE,TOMATO,CND,HUNT,HERB FLAVORED^BC-02819^4-oz.^113
	;;^UTILITY(U,$J,112,9546,1)
	;;=1.77^1.77^10.619^61.947^^^^25.664^.885^^^367.257^415.929^^^^^^15.929^.088
	;;^UTILITY(U,$J,112,9546,2)
	;;=.053^1.062^^^^^^^0^.531^^.973^110.619^^^^1.77
