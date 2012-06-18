FHINI0D2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8318,1)
	;;=1.754^7.018^19.298^157.895^^^^^^^^^149.123
	;;^UTILITY(U,$J,112,8318,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8318,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8319,0)
	;;=PUDDING CHOCOLATE,WENDY'S^BC-01592^1/4-cup^57
	;;^UTILITY(U,$J,112,8319,1)
	;;=0^7.018^21.053^157.895^^^^^^^^^122.807
	;;^UTILITY(U,$J,112,8319,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8319,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8320,0)
	;;=REFRIED BEANS,WENDY'S^BC-01593^2-oz.^56
	;;^UTILITY(U,$J,112,8320,1)
	;;=7.143^5.357^17.857^125^^^^^^^^375^383.929
	;;^UTILITY(U,$J,112,8320,2)
	;;=^^^^^^^^0^1.607^^.893^^^^^5.893
	;;^UTILITY(U,$J,112,8320,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8321,0)
	;;=ROTINI W/OIL,WENDY'S^BC-01594^2-oz.^56
	;;^UTILITY(U,$J,112,8321,1)
	;;=5.357^3.571^26.786^160.714^^^^^^^^17.857^0
	;;^UTILITY(U,$J,112,8321,2)
	;;=^^^^^^^^0^.536^^1.429
	;;^UTILITY(U,$J,112,8321,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8322,0)
	;;=SALAD,CHEF,WENDY'S^BC-01595^salad^331
	;;^UTILITY(U,$J,112,8322,1)
	;;=4.532^2.719^3.021^54.381^^^^^^^^178.248^42.296
	;;^UTILITY(U,$J,112,8322,2)
	;;=^^^^^^^^36.254
	;;^UTILITY(U,$J,112,8322,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8323,0)
	;;=SALAD,GARDEN,WENDY'S^BC-01596^salad^277
	;;^UTILITY(U,$J,112,8323,1)
	;;=2.527^1.805^3.249^36.823^^^^^^^^202.166^39.711
	;;^UTILITY(U,$J,112,8323,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8323,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8324,0)
	;;=SALAD DRESSING,BACON & TOMATO RED. CAL,WENDY'S^BC-01597^tbsp.^15
	;;^UTILITY(U,$J,112,8324,1)
	;;=0^26.667^20^300^^^^^^^^100^1266.667
	;;^UTILITY(U,$J,112,8324,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8324,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8325,0)
	;;=SALAD DRESSING,BLUE CHEESE,WENDY'S^BC-01598^tbsp.^13
	;;^UTILITY(U,$J,112,8325,1)
	;;=0^69.231^0^615.385^^^^^^^^38.462^692.308
	;;^UTILITY(U,$J,112,8325,2)
	;;=^^^^^^^^76.923
	;;^UTILITY(U,$J,112,8325,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8326,0)
	;;=SALAD DRESSING,CREAMY PEPPERCORN,WENDY'S^BC-01599^tbsp.^15
	;;^UTILITY(U,$J,112,8326,1)
	;;=0^53.333^0^533.333^^^^^^^^33.333^900
	;;^UTILITY(U,$J,112,8326,2)
	;;=^^^^^^^^666.667
	;;^UTILITY(U,$J,112,8326,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8327,0)
	;;=SALAD DRESSING,FRENCH,WENDY'S^BC-01600^tbsp.^16
	;;^UTILITY(U,$J,112,8327,1)
	;;=0^37.5^25^437.5^^^^^^^^156.25^1187.5
	;;^UTILITY(U,$J,112,8327,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8327,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8328,0)
	;;=SALAD DRESSING,HIDDEN VALLEY RANCH,WENDY'S^BC-01601^tbsp.^15
	;;^UTILITY(U,$J,112,8328,1)
	;;=0^40^0^333.333^^^^^^^^100^766.667
	;;^UTILITY(U,$J,112,8328,2)
	;;=^^^^^^^^33.333
	;;^UTILITY(U,$J,112,8328,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8329,0)
	;;=SALAD DRESSING,ITALIAN CAESAR,WENDY'S^BC-01602^tbsp.^14
	;;^UTILITY(U,$J,112,8329,1)
	;;=0^57.143^0^500^^^^^^^^35.714^892.857
	;;^UTILITY(U,$J,112,8329,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8329,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8330,0)
	;;=SALAD DRESSING,ITALIAN RED. CAL,WENDY'S^BC-01603^tbsp.^15
	;;^UTILITY(U,$J,112,8330,1)
	;;=0^13.333^13.333^166.667^^^^^^^^66.667^1200
	;;^UTILITY(U,$J,112,8330,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8330,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8331,0)
	;;=SALAD DRESSING,SWEET RED RANCH,WENDY'S^BC-01604^tbsp.^16
	;;^UTILITY(U,$J,112,8331,1)
	;;=0^37.5^31.25^437.5^^^^^^^^125^812.5
	;;^UTILITY(U,$J,112,8331,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8331,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8332,0)
	;;=SALAD DRESSING,THOUSAND ISLAND,WENDY'S^BC-01605^tbsp.^15
	;;^UTILITY(U,$J,112,8332,1)
	;;=0^46.667^13.333^466.667^^^^^^^^100^700
	;;^UTILITY(U,$J,112,8332,2)
	;;=^^^^^^^^33.333
	;;^UTILITY(U,$J,112,8332,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8333,0)
	;;=SAUCE,ALFREDO,WENDY'S^BC-01606^2-oz.^56
	;;^UTILITY(U,$J,112,8333,1)
	;;=1.786^1.786^8.929^62.5^^^^^^^^125^535.714
	;;^UTILITY(U,$J,112,8333,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8333,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8334,0)
	;;=SAUCE,CHEESE,WENDY'S^BC-01607^2-oz.^56
