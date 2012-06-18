FHINI0AI	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,7063,0)
	;;=COOKIES,ICE CREAM CONE,WAFFLE CONE,KEEBLER^BC-00336^cones^24
	;;^UTILITY(U,$J,112,7063,1)
	;;=7.083^2.917^85^404.167^^^^16.667^.708^^^104.167^0^^^^^^^.042
	;;^UTILITY(U,$J,112,7063,2)
	;;=.25^.417^^^^^^^0
	;;^UTILITY(U,$J,112,7063,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7064,0)
	;;=COOKIES,KEEBIES,KEEBLER^BC-00337^cookies^18
	;;^UTILITY(U,$J,112,7064,1)
	;;=5.556^20^70^477.778^^^^38.889^3.222^^^150^383.333^^^^^^^0
	;;^UTILITY(U,$J,112,7064,2)
	;;=.222^2.222^^^^^^^0^6.111^^1.111
	;;^UTILITY(U,$J,112,7064,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7065,0)
	;;=COOKIES,KRISP KREEM WAFERS,KEEBLER^BC-00338^2-cookies^10
	;;^UTILITY(U,$J,112,7065,1)
	;;=4^26^68^520^^^^20^1.7^^^90^150^^^^^^^0
	;;^UTILITY(U,$J,112,7065,2)
	;;=.4^2^^^^^^^0^5^^2
	;;^UTILITY(U,$J,112,7065,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7066,0)
	;;=COOKIES,MALLOMARS CHOC CAKES,NABISCO^BC-00339^.5-oz.^14
	;;^UTILITY(U,$J,112,7066,1)
	;;=7.143^21.429^64.286^428.571^^^^^^^^^142.857
	;;^UTILITY(U,$J,112,7066,2)
	;;=^^^^^^^^0^7.143
	;;^UTILITY(U,$J,112,7066,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7067,0)
	;;=COOKIES,MARSHMALLOW PUFFS FUDGE CAKES,NABISCO^BC-00340^.75-oz.^21
	;;^UTILITY(U,$J,112,7067,1)
	;;=4.762^19.048^66.667^428.571^^^^^^^^^214.286
	;;^UTILITY(U,$J,112,7067,2)
	;;=^^^^^^^^0^14.286
	;;^UTILITY(U,$J,112,7067,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7068,0)
	;;=COOKIES,MARSHMALLOW TWIRLS FUDGE CAKES,NABISCO^BC-00341^oz.^28
	;;^UTILITY(U,$J,112,7068,1)
	;;=3.571^21.429^71.429^500^^^^^^^^^250
	;;^UTILITY(U,$J,112,7068,2)
	;;=^^^^^^^^0^14.286
	;;^UTILITY(U,$J,112,7068,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7069,0)
	;;=COOKIES,NILLA WAFERS,NABISCO^BC-00342^3-1/2-cook^14
	;;^UTILITY(U,$J,112,7069,1)
	;;=7.143^14.286^78.571^428.571^^^^^^^^^321.429
	;;^UTILITY(U,$J,112,7069,2)
	;;=^^^^^^^^35.714
	;;^UTILITY(U,$J,112,7069,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7070,0)
	;;=COOKIES,NUTTER BUTTER,PEANUT BUTTER SANDWICH,NABISCO^BC-00343^.5-oz.^14
	;;^UTILITY(U,$J,112,7070,1)
	;;=7.143^21.429^64.286^500^^^^^^^^^357.143
	;;^UTILITY(U,$J,112,7070,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7070,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7071,0)
	;;=COOKIES,NUTTER BUTTER,PEANUT CREME PATTIES,NABISCO^BC-00344^2-cookies^14
	;;^UTILITY(U,$J,112,7071,1)
	;;=14.286^28.571^57.143^571.429^^^^^^^^^321.429
	;;^UTILITY(U,$J,112,7071,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7071,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7072,0)
	;;=COOKIES,OAT BRAN,APPLE,FIBER ENRICHED,KEEBLER^BC-00345^cookies^15
	;;^UTILITY(U,$J,112,7072,1)
	;;=5.333^22^64^473.333^^^^20^2.333^^^86.667^373.333^^^^^^^.333
	;;^UTILITY(U,$J,112,7072,2)
	;;=.2^2^^^^^^^0^4^^1.333^^^^^7.333
	;;^UTILITY(U,$J,112,7072,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7073,0)
	;;=COOKIES,OATMEAL FIBER ENRICHED,KEEBLER^BC-00346^cookies^15
	;;^UTILITY(U,$J,112,7073,1)
	;;=6^20^64.667^453.333^^^^20^2.2^^^106.667^433.333^^^^^^^.333
	;;^UTILITY(U,$J,112,7073,2)
	;;=.2^2^^^^^^^0^4^^1.333^^^^^7.333
	;;^UTILITY(U,$J,112,7073,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7074,0)
	;;=COOKIES,OATMEAL,KEEBLER OLD FASHIONED^BC-00347^cookies^18
	;;^UTILITY(U,$J,112,7074,1)
	;;=7.222^17.222^68.889^461.111^^^^27.778^3.278^^^155.556^488.889^^^^^^^.111
	;;^UTILITY(U,$J,112,7074,2)
	;;=.222^2.222^^^^^^^0^5^^2.222
	;;^UTILITY(U,$J,112,7074,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7075,0)
	;;=COOKIES,OATMEAL CREME PIES,LITTLE DEBBIE^BC-00348^1.3-oz.^38
	;;^UTILITY(U,$J,112,7075,1)
	;;=4.474^21.053^62.632^457.895^10.526^^^0^1.605^^^^371.053^^^^^^0^.158
	;;^UTILITY(U,$J,112,7075,2)
	;;=.132^1.316^^^^^^^0^5.789^12.105^3.158
	;;^UTILITY(U,$J,112,7075,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7076,0)
	;;=COOKIES,OREO,NABISCO^BC-00349^.5-oz.^14
	;;^UTILITY(U,$J,112,7076,1)
	;;=7.143^14.286^57.143^357.143^^^^^^^^^535.714
	;;^UTILITY(U,$J,112,7076,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7076,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7077,0)
	;;=COOKIES,OREO BIG STUFF,NABISCO^BC-00350^1.75-oz.^50
	;;^UTILITY(U,$J,112,7077,1)
	;;=4^24^66^500^^^^^^^^^440
	;;^UTILITY(U,$J,112,7077,2)
	;;=^^^^^^^^^8^^2
