FHINI0AC	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6976,1)
	;;=.714^11.429^8.571^135.714^80.714^^^7.143^.429^0^57.143^135.714^50
	;;^UTILITY(U,$J,112,6976,2)
	;;=^^^^^^^^0^2.143^4.286^5^^^^^0
	;;^UTILITY(U,$J,112,6976,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6977,0)
	;;=CREAMERS,LIQUID,POLY RICH,NON-DAIRY^BC-00250^1/2-floz.^14
	;;^UTILITY(U,$J,112,6977,1)
	;;=0^9.286^15.714^157.143^75^^^0^.143^0^35.714^85.714^50^0^.021
	;;^UTILITY(U,$J,112,6977,2)
	;;=^^^^^^^^0^2.143^4.286^3.571^^^^^0
	;;^UTILITY(U,$J,112,6977,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6978,0)
	;;=CREAMERS,POWDERED,COFFEE-MATE LITE,NON-DAIRY,CARNATION^BC-00251^tsp.^2
	;;^UTILITY(U,$J,112,6978,1)
	;;=0^15^100^400^5^^^0^0^^350^750^0^0^^^^0^0
	;;^UTILITY(U,$J,112,6978,2)
	;;=^^^^^0^^^0^15^0^0^^^^^0
	;;^UTILITY(U,$J,112,6978,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6979,0)
	;;=CREAMERS,POWDERED,COFFEE-MATE,NON-DAIRY,CARNATION^BC-00252^tsp.^2
	;;^UTILITY(U,$J,112,6979,1)
	;;=0^35^55^500^^^^0^0^^350^750^150^^^^^0^0
	;;^UTILITY(U,$J,112,6979,2)
	;;=^^^^0^0^^^0^35^0^0
	;;^UTILITY(U,$J,112,6979,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6980,0)
	;;=SOUR CREAM,LIGHT,LAND O'LAKES^BC-00253^tbsp.^15
	;;^UTILITY(U,$J,112,6980,1)
	;;=5.333^4.667^12^120^^^^113.333^.133^^113.333^253.333^113.333^^^^^773.333^0^.067
	;;^UTILITY(U,$J,112,6980,2)
	;;=.267^0^^^^^^^20^3.333^1.333^0
	;;^UTILITY(U,$J,112,6980,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6981,0)
	;;=SOUR CREAM DAIRY BLEND,LIGHT LAND O'LAKES^BC-00254^tbsp.^16
	;;^UTILITY(U,$J,112,6981,1)
	;;=6.25^6.25^12.5^125^^^^^^^^218.75^93.75
	;;^UTILITY(U,$J,112,6981,2)
	;;=^^^^^^^^31.25
	;;^UTILITY(U,$J,112,6981,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6982,0)
	;;=WHIPPED TOPPING FROM MIX,DREAM WHIP^BC-00255^tbsp.^5
	;;^UTILITY(U,$J,112,6982,1)
	;;=4^8^20^180^66^^^100^0^20^80^140^80^.4^.02^^^200^0^0
	;;^UTILITY(U,$J,112,6982,2)
	;;=.2^0^.2^0^0^.2^^^20^6^^0
	;;^UTILITY(U,$J,112,6982,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6983,0)
	;;=WHIPPED TOPPING FROM MIX W/NUTRASWEET,D-ZERTA^BC-00256^tbsp.^5
	;;^UTILITY(U,$J,112,6983,1)
	;;=2^12^6^140^78^^^60^0^20^100^160^120^.2^0^^^160^0^0
	;;^UTILITY(U,$J,112,6983,2)
	;;=.2^0^.4^0^0^.2^^^0^10^^0
	;;^UTILITY(U,$J,112,6983,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6984,0)
	;;=WHIPPED TOPPING,FRZN,COOL WHIP EXTRA CREAMY^BC-00257^tbsp.^4
	;;^UTILITY(U,$J,112,6984,1)
	;;=2.5^30^30^325^60^^^25^0^0^50^50^75^.25^0^^^850^0^0
	;;^UTILITY(U,$J,112,6984,2)
	;;=0^0^0^0^0^0^^^0^30^^0
	;;^UTILITY(U,$J,112,6984,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6985,0)
	;;=WHIPPED TOPPING,FRZN,COOL WHIP LITE^BC-00258^tbsp.^4
	;;^UTILITY(U,$J,112,6985,1)
	;;=0^25^25^225^^^^75^^^75^100^75^^^^^450
	;;^UTILITY(U,$J,112,6985,2)
	;;=^^.25^^0^^^^0
	;;^UTILITY(U,$J,112,6985,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6986,0)
	;;=WHIPPED TOPPING,FRZN,COOL WHIP,NON-DAIRY^BC-00259^tbsp.^4
	;;^UTILITY(U,$J,112,6986,1)
	;;=2.5^20^25^275^52.5^^^0^0^0^0^0^25^0^^^^675^0^0
	;;^UTILITY(U,$J,112,6986,2)
	;;=0^0^^^^0^^^0^20^^0
	;;^UTILITY(U,$J,112,6986,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6987,0)
	;;=WHIPPED TOPPING,LIQUID,RICHWHIP^BC-00260^1/4-oz.^7
	;;^UTILITY(U,$J,112,6987,1)
	;;=0^22.857^17.143^285.714^60^^^0^0^0^0^0^57.143^0^0
	;;^UTILITY(U,$J,112,6987,2)
	;;=^^^^^^^^^18.571
	;;^UTILITY(U,$J,112,6987,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6988,0)
	;;=WHIPPED TOPPING,PRESSURIZED,RICHWHIP^BC-00261^1/4-oz.^7
	;;^UTILITY(U,$J,112,6988,1)
	;;=0^24.286^15.714^285.714^60^^^0^0^0^0^14.286^42.857^0^0
	;;^UTILITY(U,$J,112,6988,2)
	;;=^^^^^^^^^20
	;;^UTILITY(U,$J,112,6988,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6989,0)
	;;=WHIPPED TOPPING,PREWHIPPED,RICHWHIP^BC-00262^tbsp.^4
	;;^UTILITY(U,$J,112,6989,1)
	;;=2.5^22.5^25^300^50^^^0^.25^0^50^25^25^0^.075^^^0^0^0
	;;^UTILITY(U,$J,112,6989,2)
	;;=0^0^^^^^^^0^22.5^^^^^^^0
	;;^UTILITY(U,$J,112,6989,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6990,0)
	;;=BROWNIE,FROSTED,MICRORAVE^BC-00263^1.3-oz.^37
	;;^UTILITY(U,$J,112,6990,1)
	;;=5.405^18.919^72.973^486.486^^^^^^^^418.919^324.324
	;;^UTILITY(U,$J,112,6990,2)
	;;=^^^^^^^^0^5.405^10.811^2.703
	;;^UTILITY(U,$J,112,6990,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
