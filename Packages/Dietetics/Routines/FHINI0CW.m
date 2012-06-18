FHINI0CW	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8224,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8225,0)
	;;=PAN PIZZA,SUPREME,MED,PIZZA HUT^BC-01498^2-slices^255
	;;^UTILITY(U,$J,112,8225,1)
	;;=12.549^11.765^20.784^230.98^^^^^^^^227.451^534.51
	;;^UTILITY(U,$J,112,8225,2)
	;;=^^^^^^^^18.824^5.412^^^^^^^2.745
	;;^UTILITY(U,$J,112,8225,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8226,0)
	;;=PERSONAL PAN PIZZA,PEPPERONI,PIZZA HUT^BC-01499^pizza^256
	;;^UTILITY(U,$J,112,8226,1)
	;;=14.453^11.328^29.688^263.672^^^^^^^^159.375^521.484
	;;^UTILITY(U,$J,112,8226,2)
	;;=^^^^^^^^20.703^4.883^^^^^^^3.125
	;;^UTILITY(U,$J,112,8226,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8227,0)
	;;=PERSONAL PAN PIZZA,SUPREME,PIZZA HUT^BC-01500^pizza^264
	;;^UTILITY(U,$J,112,8227,1)
	;;=12.5^10.606^28.788^245.076^^^^^^^^184.47^497.348
	;;^UTILITY(U,$J,112,8227,2)
	;;=^^^^^^^^18.561^4.242^^^^^^^3.409
	;;^UTILITY(U,$J,112,8227,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8228,0)
	;;=REGULAR CRUST PIZZA,CHEESE,MED,PIZZA HUT^BC-01501^2-slices^220
	;;^UTILITY(U,$J,112,8228,1)
	;;=15.455^9.091^25^235.455^^^^^^^^180^580
	;;^UTILITY(U,$J,112,8228,2)
	;;=^^^^^^^^25^6.182^^^^^^^3.182
	;;^UTILITY(U,$J,112,8228,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8229,0)
	;;=REGULAR CRUST PIZZA,PEPPERONI,MED,PIZZA HUT^BC-01502^2-slices^197
	;;^UTILITY(U,$J,112,8229,1)
	;;=14.213^11.675^25.381^253.807^^^^^^^^210.66^643.147
	;;^UTILITY(U,$J,112,8229,2)
	;;=^^^^^^^^25.381^6.548^^^^^^^3.046
	;;^UTILITY(U,$J,112,8229,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8230,0)
	;;=REGULAR CRUST PIZZA,SUPER SUPREME,MED,PIZZA HUT^BC-01503^2-slices^243
	;;^UTILITY(U,$J,112,8230,1)
	;;=13.58^10.288^22.222^228.807^^^^^^^^212.346^678.189
	;;^UTILITY(U,$J,112,8230,2)
	;;=^^^^^^^^22.222^5.35^^^^^^^2.881
	;;^UTILITY(U,$J,112,8230,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8231,0)
	;;=REGULAR CRUST PIZZA,SUPREME,MED,PIZZA HUT^BC-01504^2-slices^239
	;;^UTILITY(U,$J,112,8231,1)
	;;=13.389^10.879^20.921^225.941^^^^^^^^241.841^615.063
	;;^UTILITY(U,$J,112,8231,2)
	;;=^^^^^^^^23.013^5.774^^^^^^^2.929
	;;^UTILITY(U,$J,112,8231,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8232,0)
	;;=BURRITO W/RED SCE,BEAN,TACO BELL^BC-01505^burrito^206
	;;^UTILITY(U,$J,112,8232,1)
	;;=7.282^6.796^30.583^216.99^^^^^^^^240.291^557.282
	;;^UTILITY(U,$J,112,8232,2)
	;;=^^^^^^^^4.369^1.942^^.971
	;;^UTILITY(U,$J,112,8232,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8233,0)
	;;=BURRITO W/RED SCE,BEEF,TACO BELL^BC-01506^burrito^206
	;;^UTILITY(U,$J,112,8233,1)
	;;=12.136^10.194^23.301^239.32^^^^^^^^184.466^636.408
	;;^UTILITY(U,$J,112,8233,2)
	;;=^^^^^^^^27.67^3.883^^.971
	;;^UTILITY(U,$J,112,8233,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8234,0)
	;;=BURRITO W/RED SCE,SUPREME,TACO BELL^BC-01507^burrito^255
	;;^UTILITY(U,$J,112,8234,1)
	;;=7.843^8.627^21.569^197.255^^^^^^^^196.471^463.137
	;;^UTILITY(U,$J,112,8234,2)
	;;=^^^^^^^^12.941^3.137^^.784
	;;^UTILITY(U,$J,112,8234,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8235,0)
	;;=BURRITO W/RED SCE,COMBINATION,TACO BELL^BC-01508^burrito^198
	;;^UTILITY(U,$J,112,8235,1)
	;;=9.091^8.081^23.232^205.556^^^^^^^^223.232^573.737
	;;^UTILITY(U,$J,112,8235,2)
	;;=^^^^^^^^16.667^2.525^^1.01
	;;^UTILITY(U,$J,112,8235,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8236,0)
	;;=CHILITO,TACO BELL^BC-01509^chilito^156
	;;^UTILITY(U,$J,112,8236,1)
	;;=11.538^11.538^23.077^245.513^^^^^^^^136.538^572.436
	;;^UTILITY(U,$J,112,8236,2)
	;;=^^^^^^^^30.128^5.128^^1.282
	;;^UTILITY(U,$J,112,8236,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8237,0)
	;;=CINNAMON TWISTS,TACO BELL^BC-01510^twist^35
	;;^UTILITY(U,$J,112,8237,1)
	;;=5.714^22.857^68.571^488.571^^^^^^^^77.143^668.571
	;;^UTILITY(U,$J,112,8237,2)
	;;=^^^^^^^^0^8.571^^2.857
	;;^UTILITY(U,$J,112,8237,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8238,0)
	;;=ENCHIRITO W/RED SCE,TACO BELL^BC-01511^enchirito^213
	;;^UTILITY(U,$J,112,8238,1)
	;;=9.39^9.39^14.554^179.343^^^^^^^^198.592^583.568
	;;^UTILITY(U,$J,112,8238,2)
	;;=^^^^^^^^25.352^4.225^^.939
	;;^UTILITY(U,$J,112,8238,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8239,0)
	;;=JALAPENO PEPPERS,TACO BELL^BC-01512^3.5-oz.^100
