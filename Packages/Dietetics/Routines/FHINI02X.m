FHINI02X	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,884,2)
	;;=.15^.9^^^^^1.49^^48^4.85^^^^1.4
	;;^UTILITY(U,$J,112,884,4)
	;;=^^^^^^5.25
	;;^UTILITY(U,$J,112,884,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,885,0)
	;;=CAKE, GINGERBREAD, BKD FROM MIX, ENR^18-115^pieces^63^100^N
	;;^UTILITY(U,$J,112,885,1)
	;;=4^10.2^50.7^309^33.1^^^69^3.31^16^168^241^458^.41^.16^.359^^55^.1^.189
	;;^UTILITY(U,$J,112,885,2)
	;;=.186^1.562^.224^.038^10^.07^1.258^.063^35^2.603^5.6^1.336^16^2^^^3.2
	;;^UTILITY(U,$J,112,885,3)
	;;=.054^.143^.175^.298^.201^.078^.083^.197^.133^.196^.205^.089^.159^.295^.987^.144^.323^.235
	;;^UTILITY(U,$J,112,885,4)
	;;=.001^.001^.049^1.392^.025^1.156^5.572^.012
	;;^UTILITY(U,$J,112,885,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,886,0)
	;;=CAKE, HONEY SPICE, BKD FROM MIX, ENR, W/CARA-IC^563-0^pieces^77^100^N
	;;^UTILITY(U,$J,112,886,1)
	;;=4.1^10.8^60.9^352^22.7^^^71^1.6^^193^82^245^^^^^160^.2^.12
	;;^UTILITY(U,$J,112,886,2)
	;;=.16^1^^^^^1.94^^58^3.2^^^^1.5
	;;^UTILITY(U,$J,112,886,4)
	;;=^^^^^^5.05
	;;^UTILITY(U,$J,112,886,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,887,0)
	;;=CAKE, MARBLE, BKD FROM MIX, ENR, W/BOILED WHT ICING^565-0^pieces^65^100^N
	;;^UTILITY(U,$J,112,887,1)
	;;=4.4^8.7^62^331^23.6^^^78^1.5^^171^122^259^^^^^90^.1^.12
	;;^UTILITY(U,$J,112,887,2)
	;;=.15^1^^^^^1.65^^51^2.44^^^^1.3
	;;^UTILITY(U,$J,112,887,4)
	;;=^^^^^^4.18
	;;^UTILITY(U,$J,112,887,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,888,0)
	;;=CAKE, WHITE, BKD FROM MIX, ENR, W/CHOC-IC^567-0^pieces^71^100^N
	;;^UTILITY(U,$J,112,888,1)
	;;=3.9^10.7^62.8^351^21.1^^^99^1.3^^179^116^227^^^^^60^.2^.13
	;;^UTILITY(U,$J,112,888,2)
	;;=.16^1.1^^^^^1.53^^2^3.99^^^^1.5
	;;^UTILITY(U,$J,112,888,4)
	;;=^^^^^^4.7
	;;^UTILITY(U,$J,112,888,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,889,0)
	;;=CAKE, YEL, BKD FROM MIX, ENR, W/CHOC-IC^569-0^pieces^69^100^N
	;;^UTILITY(U,$J,112,889,1)
	;;=4.1^11.3^57.6^337^25.6^^^91^1.4^^182^109^227^^^^^140^.1^.11
	;;^UTILITY(U,$J,112,889,2)
	;;=.15^1^^^^^1.58^^48^4.11^^^^1.4
	;;^UTILITY(U,$J,112,889,4)
	;;=^^^^^^4.98
	;;^UTILITY(U,$J,112,889,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,890,0)
	;;=CAKE ICING, CARAMEL^570-0^cups^340^100^N
	;;^UTILITY(U,$J,112,890,1)
	;;=1.3^6.7^76.5^360^14.1^^^102^2^^63^52^83^^^^^280^.3^.01
	;;^UTILITY(U,$J,112,890,2)
	;;=.06^0^^^^^.2^^22^3.68^^^^1.4
	;;^UTILITY(U,$J,112,890,4)
	;;=^^^^^^2.21
	;;^UTILITY(U,$J,112,890,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,891,0)
	;;=CAKE ICING, CHOCOLATE^571-0^cups^275^100^N
	;;^UTILITY(U,$J,112,891,1)
	;;=3.2^13.9^67.4^376^14.3^^^60^1.2^^111^195^61^^^^^210^.2^.02
	;;^UTILITY(U,$J,112,891,2)
	;;=.1^.2^^^^^.32^^16^7.74^^^^.9
	;;^UTILITY(U,$J,112,891,4)
	;;=^^^^^^4.95
	;;^UTILITY(U,$J,112,891,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,892,0)
	;;=CAKE ICING, COCONUT^572-0^cups^166^100^N
	;;^UTILITY(U,$J,112,892,1)
	;;=1.9^7.7^74.9^364^15^^^6^.5^^30^167^118^^^^^0^0^.01
	;;^UTILITY(U,$J,112,892,2)
	;;=.04^.2^^^^^0^^0^6.62^^^^.5
	;;^UTILITY(U,$J,112,892,4)
	;;=^^^^^^.54
	;;^UTILITY(U,$J,112,892,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,893,0)
	;;=CAKE ICING, WHITE, UNCKD^573-0^cups^319^100^N
	;;^UTILITY(U,$J,112,893,1)
	;;=.5^6.6^81.6^376^11.1^^^15^0^^12^18^49^^^^^270^0^0
	;;^UTILITY(U,$J,112,893,2)
	;;=.02^0^^^^^.2^^20^3.63^^^^.2
	;;^UTILITY(U,$J,112,893,4)
	;;=^^^^^^2.18
	;;^UTILITY(U,$J,112,893,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,894,0)
	;;=CAKE ICING, WHITE, BOILED^574-0^cups^94^100^N
	;;^UTILITY(U,$J,112,894,1)
	;;=1.4^0^80.3^316^17.9^^^2^0^^2^18^143^^^^^0^0^0
	;;^UTILITY(U,$J,112,894,2)
	;;=.03^0^^^^^0^^0^0^^^^.4
	;;^UTILITY(U,$J,112,894,4)
	;;=^^^^^^0
	;;^UTILITY(U,$J,112,894,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,895,0)
	;;=CAKE ICING, CHOCOLATE FUDGE, MADE FROM MIX^576-2^cups^310^100^N
	;;^UTILITY(U,$J,112,895,1)
	;;=2.2^14.4^67^378^15.3^^^16^1^^66^63^156^^^^^270^0^.01
	;;^UTILITY(U,$J,112,895,2)
	;;=.04^.2^^^^^3.3^^0^3.53^^^^1.1
	;;^UTILITY(U,$J,112,895,4)
	;;=^^^^^^7.11
	;;^UTILITY(U,$J,112,895,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,896,0)
	;;=CAKE ICING, CREAMY FUDGE, MADE FROM MIX^579-2^cups^245^100^N
	;;^UTILITY(U,$J,112,896,1)
	;;=2.6^15.2^65.9^383^15.1^^^37^1^^81^89^321^^^^^390^0^.02
	;;^UTILITY(U,$J,112,896,2)
	;;=.07^.3^^^^^3.63^^0^3.53^^^^1.2
	;;^UTILITY(U,$J,112,896,4)
	;;=^^^^^^7.55
	;;^UTILITY(U,$J,112,896,20)
	;;=USDA  Std. Reference, Release 8
	;;^UTILITY(U,$J,112,897,0)
	;;=CANDY, BUTTERSCOTCH^19-070^oz.^28.3^100^N
