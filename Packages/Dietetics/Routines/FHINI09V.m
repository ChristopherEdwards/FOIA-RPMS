FHINI09V	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6746,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6747,0)
	;;=CARBONATED BEV.,CHERRY,COCA-COLA^BC-00020^cans^370
	;;^UTILITY(U,$J,112,6747,1)
	;;=0^0^10.811^41.081^^^^^^^14.595^0^2.162^^^^^^0
	;;^UTILITY(U,$J,112,6747,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6748,0)
	;;=CARBONATED BEV.,COCA-COLA^BC-00021^cans^370
	;;^UTILITY(U,$J,112,6748,1)
	;;=0^0^10.811^41.622^^^^^^^14.595^0^2.162^^^^^^0
	;;^UTILITY(U,$J,112,6748,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6749,0)
	;;=CARBONATED BEV.,COCA-COLA CLASSIC^BC-00022^cans^369
	;;^UTILITY(U,$J,112,6749,1)
	;;=0^0^10.298^39.024^^^^^^^16.26^0^3.794^^^^^^0
	;;^UTILITY(U,$J,112,6749,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6750,0)
	;;=CARBONATED BEV.,DR. PEPPER^BC-00023^cans^360
	;;^UTILITY(U,$J,112,6750,1)
	;;=^^10.333^40^91.333^^^0^^^14.444^0^5
	;;^UTILITY(U,$J,112,6750,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6751,0)
	;;=CARBONATED BEV.,MR. PIBB^BC-00024^cans^369
	;;^UTILITY(U,$J,112,6751,1)
	;;=0^0^9.756^38.482^^^^^^^11.382^0^5.42^^^^^^0
	;;^UTILITY(U,$J,112,6751,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6752,0)
	;;=CARBONATED BEV.,MOUNTAIN DEW^BC-00025^cans^360
	;;^UTILITY(U,$J,112,6752,1)
	;;=0^0^12.333^49.722^90.667^^^^^^0^2.778^8.611
	;;^UTILITY(U,$J,112,6752,2)
	;;=^^^^^^^^^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6752,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6753,0)
	;;=CARBONATED BEV.,ORANGE CRUSH^BC-00026^cans^360
	;;^UTILITY(U,$J,112,6753,1)
	;;=0^0^13.889^55.556^^^^^^^^^41.667
	;;^UTILITY(U,$J,112,6753,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6754,0)
	;;=CARBONATED BEV.,ORANGE,MINUTE MAID^BC-00027^cans^360
	;;^UTILITY(U,$J,112,6754,1)
	;;=^^12.222^48.333^^^^^^^1.111^29.444^0^^^^^^3.333
	;;^UTILITY(U,$J,112,6754,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6755,0)
	;;=CARBONATED BEV.,PEPSI FREE^BC-00028^cans^360
	;;^UTILITY(U,$J,112,6755,1)
	;;=0^0^11^44.444^91.333^^^0^0^^15.278^3.611^.556
	;;^UTILITY(U,$J,112,6755,2)
	;;=^^^^^^^^^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6755,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6756,0)
	;;=CARBONATED BEV.,RC COLA^BC-00029^cans^360
	;;^UTILITY(U,$J,112,6756,1)
	;;=0^0^12^48.333^^^^^^^16.667^3.333^.556
	;;^UTILITY(U,$J,112,6756,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,6756,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6757,0)
	;;=CARBONATED BEV.,7UP^BC-00030^cans^360
	;;^UTILITY(U,$J,112,6757,1)
	;;=^^10.056^40^91.444^^^^^^^^8.889
	;;^UTILITY(U,$J,112,6757,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6758,0)
	;;=CARBONATED BEV.,SLICE^BC-00031^cans^360
	;;^UTILITY(U,$J,112,6758,1)
	;;=0^0^11^42.222^91.333^^^0^0^^0^27.778^3.056
	;;^UTILITY(U,$J,112,6758,2)
	;;=^^^^^^^^^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6758,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6759,0)
	;;=CARBONATED BEV.,SUNKIST ORANGE^BC-00032^cans^360
	;;^UTILITY(U,$J,112,6759,1)
	;;=0^0^15^58.889^^^^0^0^^^0^7.778
	;;^UTILITY(U,$J,112,6759,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6760,0)
	;;=CARBONATED BEV.,DIET CHERRY,COCA COLA^BC-00033^cans^354
	;;^UTILITY(U,$J,112,6760,1)
	;;=0^0^.085^.282^^^^^^^7.91^5.085^2.26^^^^^^0
	;;^UTILITY(U,$J,112,6760,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6761,0)
	;;=CARBONATED BEV.,DIET COKE,COCA COLA^BC-00034^cans^354
	;;^UTILITY(U,$J,112,6761,1)
	;;=0^0^.085^.282^^^^^^^7.91^5.085^2.26^^^^^^0
	;;^UTILITY(U,$J,112,6761,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6762,0)
	;;=CARBONATED BEV.,DIET DR PEPPER^BC-00035^cans^360
	;;^UTILITY(U,$J,112,6762,1)
	;;=^^.222^.833^98^^^0^^^14.444^0^5
	;;^UTILITY(U,$J,112,6762,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6763,0)
	;;=CARBONATED BEV.,DIET ORANGE CRUSH^BC-00036^cans^360
	;;^UTILITY(U,$J,112,6763,1)
	;;=0^0^1.667^6.667^^^^^^^^^47.222
	;;^UTILITY(U,$J,112,6763,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,6764,0)
	;;=CARBONATED BEV.,DIET PEPSI^BC-00037^cans^360
	;;^UTILITY(U,$J,112,6764,1)
	;;=0^0^.056^.278^98.333^^^0^0^^8.056^8.333^.556
	;;^UTILITY(U,$J,112,6764,2)
	;;=^^^^^^^^^0^^0^^^^^0
	;;^UTILITY(U,$J,112,6764,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
