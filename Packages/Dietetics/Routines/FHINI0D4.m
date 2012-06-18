FHINI0D4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8351,1)
	;;=10.714^14.286^41.071^339.286^^^^^^^^196.429^562.5
	;;^UTILITY(U,$J,112,8351,2)
	;;=^^^^^^^^8.929
	;;^UTILITY(U,$J,112,8351,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8352,0)
	;;=TOAST,WHITE W/MARGARINE,WENDY'S^BC-01625^2-slices^69
	;;^UTILITY(U,$J,112,8352,1)
	;;=8.696^13.043^50.725^362.319^^^^^^^^115.942^594.203
	;;^UTILITY(U,$J,112,8352,2)
	;;=^^^^^^^^28.986
	;;^UTILITY(U,$J,112,8352,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8353,0)
	;;=TORTELLINI,CHEESE W/SPAGHETTI SCE,WENDY'S^BC-01626^2-oz.^56
	;;^UTILITY(U,$J,112,8353,1)
	;;=3.571^.714^21.429^107.143^^^^^^^^196.429^500
	;;^UTILITY(U,$J,112,8353,2)
	;;=^^^^^^^^8.929^.536^^.179
	;;^UTILITY(U,$J,112,8353,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8354,0)
	;;=TORTILLA,FLOUR,WENDY'S^BC-01627^tortilla^37
	;;^UTILITY(U,$J,112,8354,1)
	;;=8.108^8.108^51.351^297.297^^^^^^^^^594.595
	;;^UTILITY(U,$J,112,8354,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8355,0)
	;;=TUNA SALAD,WENDY'S^BC-01628^2-oz.^56
	;;^UTILITY(U,$J,112,8355,1)
	;;=14.286^10.714^7.143^178.571^^^^^^^^160.714^517.857
	;;^UTILITY(U,$J,112,8355,2)
	;;=^^^^^^^^0^1.607^^5.714
	;;^UTILITY(U,$J,112,8355,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8356,0)
	;;=VEGETABLE OILS,CANOLA,WESSON^BC-01629^tbsp.^14
	;;^UTILITY(U,$J,112,8356,1)
	;;=0^100^0^857.143^^^^0^0^^^0^0^^^^^^0^0
	;;^UTILITY(U,$J,112,8356,2)
	;;=0^0^^^^^^^0^28.571^^7.143^0^^^^0
	;;^UTILITY(U,$J,112,8356,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8357,0)
	;;=VEGETABLE OILS,CORN,CRISCO^BC-1630^tbsp.^14
	;;^UTILITY(U,$J,112,8357,1)
	;;=0^100^0^857.143^0^^^^^^^^0
	;;^UTILITY(U,$J,112,8357,2)
	;;=^^^^^^^^0^14.286^28.571^57.143^^^^^0
	;;^UTILITY(U,$J,112,8357,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8358,0)
	;;=VEGETABLE OILS,CORN,FLEISCHMANN'S^BC-01631^tbsp.^14
	;;^UTILITY(U,$J,112,8358,1)
	;;=0^100^0^857.143^^^^^^^^0^0
	;;^UTILITY(U,$J,112,8358,2)
	;;=^^^^^^^^0^14.286^^57.143
	;;^UTILITY(U,$J,112,8358,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8359,0)
	;;=VEGETABLE OILS,CORN,MAZOLA^BC-01632^tbsp.^14
	;;^UTILITY(U,$J,112,8359,1)
	;;=0^100^0^892.857^0^^^^^^^^0
	;;^UTILITY(U,$J,112,8359,2)
	;;=^^^^^^^^0^12.857^25.714^60
	;;^UTILITY(U,$J,112,8359,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8360,0)
	;;=VEGETABLE OILS,CORN,WESSON^BC-01633^tbsp.^14
	;;^UTILITY(U,$J,112,8360,1)
	;;=0^100^0^857.143^^^^0^0^^^0^0^^^^^^0^0
	;;^UTILITY(U,$J,112,8360,2)
	;;=0^0^^^^^^^0^13.571^^57.143^0^^^^0
	;;^UTILITY(U,$J,112,8360,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8361,0)
	;;=VEGETABLE OILS,CRISCO^BC-01634^tbsp.^14
	;;^UTILITY(U,$J,112,8361,1)
	;;=0^100^0^885.714^0
	;;^UTILITY(U,$J,112,8361,2)
	;;=^^^^^^^^0^12.857^^52.143^^^^^0
	;;^UTILITY(U,$J,112,8361,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8362,0)
	;;=VEGETABLE OILS,OLIVE,WESSON^BC-01635^tbsp.^14
	;;^UTILITY(U,$J,112,8362,1)
	;;=0^100^0^857.143^^^^0^0^^^0^0^^^^^^0^0
	;;^UTILITY(U,$J,112,8362,2)
	;;=0^0^^^^^^^0^7.143^^14.286^0^^^^0
	;;^UTILITY(U,$J,112,8362,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8363,0)
	;;=VEGETABLE OILS,POPPING & TOPPING ORVILLE REDENBACHER'S^BC-01636^tbsp.^14
	;;^UTILITY(U,$J,112,8363,1)
	;;=0^100^0^857.143^^^^^^^^0^0
	;;^UTILITY(U,$J,112,8363,2)
	;;=^^^^^^^^0^14.286^^57.143^^^^^0
	;;^UTILITY(U,$J,112,8363,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8364,0)
	;;=VEGETABLE OILS,PURITAN^BC-01637^tbsp.^14
	;;^UTILITY(U,$J,112,8364,1)
	;;=0^100^0^885.714^0^^^^^^^^0
	;;^UTILITY(U,$J,112,8364,2)
	;;=^^^^^^^^0^12.143^^67.857^^^^^0
	;;^UTILITY(U,$J,112,8364,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8365,0)
	;;=VEGETABLE OILS,SUNFLOWER,WESSON^BC-01638^tbsp.^14
	;;^UTILITY(U,$J,112,8365,1)
	;;=0^100^0^857.143^^^^0^^^^0^0^^^^^^0^0
	;;^UTILITY(U,$J,112,8365,2)
	;;=0^0^^^^^^^0^12.143^^69.286^0^^^^^0
	;;^UTILITY(U,$J,112,8365,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8366,0)
	;;=VEGETABLE OILS,WESSON^BC-01639^tbsp.^14
	;;^UTILITY(U,$J,112,8366,1)
	;;=0^100^0^857.143^^^^0^0^^^0^0^^^^^^0^0
	;;^UTILITY(U,$J,112,8366,2)
	;;=0^0^^^^^^^0^14.286^^57.143^0^^^^0
	;;^UTILITY(U,$J,112,8366,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
