FHINI0DJ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8566,1)
	;;=14.286^28.571^57.143^571.429^^^^^^^^^571.429
	;;^UTILITY(U,$J,112,8566,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8566,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8567,0)
	;;=CRACKERS,RITZ BITS,NABISCO^BC-01840^22-cracker^14
	;;^UTILITY(U,$J,112,8567,1)
	;;=7.143^28.571^64.286^500^^^^^^^^^857.143
	;;^UTILITY(U,$J,112,8567,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8567,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8568,0)
	;;=CRACKERS,RITZ,NABISCO^BC-01841^4-cracker^14
	;;^UTILITY(U,$J,112,8568,1)
	;;=7.143^28.571^64.286^500^^^^^^^^107.143^857.143
	;;^UTILITY(U,$J,112,8568,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8568,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8569,0)
	;;=CRACKERS,RY-KRISP^BC-01842^.5-oz.^14
	;;^UTILITY(U,$J,112,8569,1)
	;;=10.714^1.429^92.857^285.714^^^^85.714^3.143^242.857^664.286^450^800^5.643^.964^^^^^.286
	;;^UTILITY(U,$J,112,8569,2)
	;;=.5^2.143^1.143^.429^50^^^^^^^^^^^^17.857
	;;^UTILITY(U,$J,112,8569,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8570,0)
	;;=CRACKERS,RY-KRISP,SEASONED^BC-01843^.5-oz.^14
	;;^UTILITY(U,$J,112,8570,1)
	;;=10.714^1.429^92.857^285.714^^^^85.714^3.143^242.857^664.286^450^800^5.643^.964^^^^^.286
	;;^UTILITY(U,$J,112,8570,2)
	;;=.5^2.143^1.143^.429^50^^^^^^^^^^^^17.857
	;;^UTILITY(U,$J,112,8570,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8571,0)
	;;=CRACKERS,RY-KRISP,SESAME^BC-01844^.5-oz.^14
	;;^UTILITY(U,$J,112,8571,1)
	;;=11.429^10^85.714^428.571^^^^35.714^3.214^257.143^628.571^435.714^1057.143^5.714^1^^^^^.286
	;;^UTILITY(U,$J,112,8571,2)
	;;=.429^2.857^.857^.357^64.286^^^^^^^^^^^^15
	;;^UTILITY(U,$J,112,8571,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8572,0)
	;;=CRACKERS,SALTINES^BC-01845^2-cracker^6
	;;^UTILITY(U,$J,112,8572,1)
	;;=10^10^73.333^433.333^3.333^^^66.667^2.667^33.333^100^133.333^1333.333^.667^.167^^^0^0^.333
	;;^UTILITY(U,$J,112,8572,2)
	;;=.5^6.667^.333^0^16.667^0
	;;^UTILITY(U,$J,112,8572,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8573,0)
	;;=CRACKERS,KRISPY,SUNSHINE^BC-01846^5-cracker^14
	;;^UTILITY(U,$J,112,8573,1)
	;;=7.143^7.143^78.571^428.571^^^^^^^^^1500
	;;^UTILITY(U,$J,112,8573,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8573,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8574,0)
	;;=CRACKERS,PREMIUM,NABISCO^BC-01847^5-cracker^14
	;;^UTILITY(U,$J,112,8574,1)
	;;=7.143^14.286^71.429^428.571^^^^^^^^142.857^1285.714
	;;^UTILITY(U,$J,112,8574,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8574,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8575,0)
	;;=CRACKERS,ZESTA^BC-01848^2-cracker^6
	;;^UTILITY(U,$J,112,8575,1)
	;;=10^11.667^71.667^433.333^^^^16.667^4.333^^^350^1216.667^^^^^^^.333
	;;^UTILITY(U,$J,112,8575,2)
	;;=.333^5^^^^^^^0^3.333^^1.667
	;;^UTILITY(U,$J,112,8575,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8576,0)
	;;=CRACKERS,SESAME ROUNDS,OLD LONDON^BC-01849^.5-oz.^14
	;;^UTILITY(U,$J,112,8576,1)
	;;=16.429^12.857^63.571^400^^^^114.286^5.786^^^^1064.286^^^^^^^.286
	;;^UTILITY(U,$J,112,8576,2)
	;;=.214^2.143^^^^^^^0^^^^^^^^6.429
	;;^UTILITY(U,$J,112,8576,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8577,0)
	;;=CRACKERS,SOCIABLES,NABISCO^BC-01850^6-cracker^14
	;;^UTILITY(U,$J,112,8577,1)
	;;=7.143^21.429^64.286^500^^^^^^^^214.286^964.286
	;;^UTILITY(U,$J,112,8577,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8577,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8578,0)
	;;=CRACKERS,SWISS CHEESE,NABISCO^BC-01851^7-cracker^14
	;;^UTILITY(U,$J,112,8578,1)
	;;=7.143^21.429^78.571^500^^^^^^^^^1214.286
	;;^UTILITY(U,$J,112,8578,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8578,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8579,0)
	;;=CRACKERS,TOASTED SNACKS,KEEBLER,PUMPERNICKEL^BC-01852^2-cracker^6
	;;^UTILITY(U,$J,112,8579,1)
	;;=8.333^20^66.667^483.333^^^^33.333^3.5^^^150^800^^^^^^^.333
	;;^UTILITY(U,$J,112,8579,2)
	;;=.333^.5^^^^^^^0^3.333^^3.333
	;;^UTILITY(U,$J,112,8579,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8580,0)
	;;=CRACKERS,TOASTED SNACKS,KEEBLER,SESAME^BC-01853^2-cracker^6
	;;^UTILITY(U,$J,112,8580,1)
	;;=10^21.667^63.333^483.333^^^^16.667^4^^^166.667^900^^^^^^^.333
	;;^UTILITY(U,$J,112,8580,2)
	;;=.333^5^^^^^^^0^3.333^^3.333
	;;^UTILITY(U,$J,112,8580,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
