FHINI098	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6381,2)
	;;=.176^4.14^^^^^8.4^^66^9.3
	;;^UTILITY(U,$J,112,6382,0)
	;;=LAMB CUTLET ^^oz.^28.38
	;;^UTILITY(U,$J,112,6382,1)
	;;=14.7^18.8^1.5^234^64^^^10^1.3^23.2^113^240^61.9^4.3^^^^^^.177
	;;^UTILITY(U,$J,112,6382,2)
	;;=.177^4.34^^^^^7.5^^57^9.8
	;;^UTILITY(U,$J,112,6383,0)
	;;=CHICKEN STICKS^^oz.^28.38
	;;^UTILITY(U,$J,112,6383,1)
	;;=16^9.5^14^207^^^^^^^^^320
	;;^UTILITY(U,$J,112,6384,0)
	;;=EGGBEATERS^^oz.^28.38
	;;^UTILITY(U,$J,112,6384,1)
	;;=10^^1.7^50^^^^^^^^^150
	;;^UTILITY(U,$J,112,6384,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,6385,0)
	;;=MOUSSE, CHOCOLATE^^oz.^28.38
	;;^UTILITY(U,$J,112,6385,1)
	;;=4.4^9^24.4^200^^^^109^1.5^26.7^122^220^78^.5^.13^^^^^.022
	;;^UTILITY(U,$J,112,6385,2)
	;;=.111^.07
	;;^UTILITY(U,$J,112,6386,0)
	;;=MOUSSE, STRAWBERRY^^oz.^28.38
	;;^UTILITY(U,$J,112,6386,1)
	;;=2.5^9^22.6^190^^^^91^.1^10.7^79^119^59.5^.3^.05^^^^^.023
	;;^UTILITY(U,$J,112,6386,2)
	;;=.119^.07
	;;^UTILITY(U,$J,112,6388,0)
	;;=WHEAT STARCH FLOUR^^oz.^28.38
	;;^UTILITY(U,$J,112,6388,1)
	;;=0^0^88.1^361^^^^^.7^^^6^23.8^^^^^0^^2.25
	;;^UTILITY(U,$J,112,6388,2)
	;;=.255^4
	;;^UTILITY(U,$J,112,6388,20)
	;;=DIETARY PRODUCTS
	;;^UTILITY(U,$J,112,6389,0)
	;;=MILKSHAKE (VASLC)^^oz.^28.38
	;;^UTILITY(U,$J,112,6389,1)
	;;=4.5^20.8^10.6^196
	;;^UTILITY(U,$J,112,6390,0)
	;;=COCA COLA^^oz.^28.35
	;;^UTILITY(U,$J,112,6390,1)
	;;=^^11.17^42.3^^^^^^^17.64^0^4.1^^^^^^0
	;;^UTILITY(U,$J,112,6390,20)
	;;=Coca Cola Co. Prod. Lit., Jun 84. DOE:102284, #516
	;;^UTILITY(U,$J,112,6391,0)
	;;=COCA COLA, CAFFEINE FREE^^oz.^28.35
	;;^UTILITY(U,$J,112,6391,1)
	;;=^^11.76^44.7^^^^^^^15.88^0^1.76^^^^^^0
	;;^UTILITY(U,$J,112,6391,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE:102284, #516
	;;^UTILITY(U,$J,112,6392,0)
	;;=MELLO YELLO^^oz.^28.35
	;;^UTILITY(U,$J,112,6392,1)
	;;=^^12.9^50.57^^^^^^^0^2.35^8.2^^^^^^0
	;;^UTILITY(U,$J,112,6392,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6393,0)
	;;=ROOT BEER^^oz.^28.35
	;;^UTILITY(U,$J,112,6393,1)
	;;=^^13.52^51.74^^^^^^^0^0^5.88^^^^^^0
	;;^UTILITY(U,$J,112,6393,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6394,0)
	;;=FANTA ORANGE^^oz.^28.35
	;;^UTILITY(U,$J,112,6394,1)
	;;=^^13.52^51.74^^^^^^^0^0^4.1^^^^^^0
	;;^UTILITY(U,$J,112,6394,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6395,0)
	;;=GRAPE SODA^^oz.^28.35
	;;^UTILITY(U,$J,112,6395,1)
	;;=^^12.94^50.57^^^^^^^0^0^4.1^^^^^^0
	;;^UTILITY(U,$J,112,6395,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6396,0)
	;;=ORANGE DRINK, W/VIT C^^oz.^28.35
	;;^UTILITY(U,$J,112,6396,1)
	;;=^^11.76^45.28^^^^^^^0^7.06^4.1^^^^^^35.28
	;;^UTILITY(U,$J,112,6396,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6397,0)
	;;=LEMON DRINK, W/VIT C^^oz.^28.35
	;;^UTILITY(U,$J,112,6397,1)
	;;=^^10.58^42.92^^^^^^^11.17^5.88^3.5^^^^^^35.28
	;;^UTILITY(U,$J,112,6397,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6398,0)
	;;=PUNCH, W/VIT C^^oz.^28.35
	;;^UTILITY(U,$J,112,6398,1)
	;;=^^11.76^45.28^^^^^^^0^5.29^3.53^^^^^^35.28
	;;^UTILITY(U,$J,112,6398,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6399,0)
	;;=GRAPE DRINK, W/VIT C^^oz.^28.35
	;;^UTILITY(U,$J,112,6399,1)
	;;=^^11.76^45.28^^^^^^^0^5.88^3.53^^^^^^35.28
	;;^UTILITY(U,$J,112,6399,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6400,0)
	;;=COKE, SUGAR FREE^^oz.^28.35
	;;^UTILITY(U,$J,112,6400,1)
	;;=^^.088^.24^^^^^^^8.23^0^7.64^^^^^^0
	;;^UTILITY(U,$J,112,6400,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6401,0)
	;;=COKE, CAFFEINE FREE, DIET^^oz.^28.35
	;;^UTILITY(U,$J,112,6401,1)
	;;=^^.082^.24^^^^^^^8.23^0^7.64^^^^^^0
	;;^UTILITY(U,$J,112,6401,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6402,0)
	;;=TAB, CAFFEINE FREE^^oz.^28.35
	;;^UTILITY(U,$J,112,6402,1)
	;;=^^.094^.24^^^^^^^13.52^0^8.23^^^^^^0
	;;^UTILITY(U,$J,112,6402,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6403,0)
	;;=ROOT BEER, SUGAR FREE^^oz.^28.35
	;;^UTILITY(U,$J,112,6403,1)
	;;=^^.12^.41^^^^^^^0^0^17.05^^^^^^0
	;;^UTILITY(U,$J,112,6403,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6404,0)
	;;=ORANGE DRINK, SUGAR FREE^^oz.^28.35
	;;^UTILITY(U,$J,112,6404,1)
	;;=^^0^.41^^^^^^^0^0^14.11^^^^^^0
	;;^UTILITY(U,$J,112,6404,20)
	;;=Coca Cola Co. Prod. Lit. Jun 84. DOE: 102284 #516
	;;^UTILITY(U,$J,112,6405,0)
	;;=GRAVY, BROWN LOW SODIUM FROM MIX^^oz.^28.35
