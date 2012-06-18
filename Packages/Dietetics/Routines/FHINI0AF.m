FHINI0AF	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,7018,2)
	;;=.128^0^^^^^^^0^5.641^8.462^1.795
	;;^UTILITY(U,$J,112,7018,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7019,0)
	;;=SNACK CAKES,ORANGE CUPCAKE,HOSTESS^BC-00292^cupcakes^43
	;;^UTILITY(U,$J,112,7019,1)
	;;=2.326^11.628^65.116^348.837^^^^^^^^^406.977^^^^^0^0
	;;^UTILITY(U,$J,112,7019,2)
	;;=^^^^^^^^30.233
	;;^UTILITY(U,$J,112,7019,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7020,0)
	;;=SNACK CAKES,PECAN TWINS,LITTLE DEBBIE^BC-00293^2-oz.^57
	;;^UTILITY(U,$J,112,7020,1)
	;;=5.088^15.439^59.298^396.491^19.123^^^52.632^2.737^^^^296.491^^^^^0^0^.404
	;;^UTILITY(U,$J,112,7020,2)
	;;=.263^2.456^^^^^^^1.754^2.632^4.737^8.07
	;;^UTILITY(U,$J,112,7020,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7021,0)
	;;=SNACK CAKES,RAISIN CREME PIE,LITTLE DEBBIE^BC-00294^1.2-oz.^33
	;;^UTILITY(U,$J,112,7021,1)
	;;=3.333^26.364^57.273^506.061^12.121^^^0^1.303^^^^278.788^^^^^0^0^.182
	;;^UTILITY(U,$J,112,7021,2)
	;;=.303^1.818^^^^^^^0^7.576^14.848^3.939
	;;^UTILITY(U,$J,112,7021,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7022,0)
	;;=SNACK CAKES,SNO BALLS,HOSTESS^BC-00295^cakes^43
	;;^UTILITY(U,$J,112,7022,1)
	;;=2.326^9.302^65.116^348.837^^^^^^^^^395.349^^^^^0^0
	;;^UTILITY(U,$J,112,7022,2)
	;;=^^^^^^^^4.651
	;;^UTILITY(U,$J,112,7022,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7023,0)
	;;=SNACK CAKE,SUZY Q's CHOC,HOSTESS^BC-00296^cakes^64
	;;^UTILITY(U,$J,112,7023,1)
	;;=3.125^15.625^57.813^375^^^^^^^^^468.75^^^^^0^0
	;;^UTILITY(U,$J,112,7023,2)
	;;=^^^^^^^^25
	;;^UTILITY(U,$J,112,7023,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7024,0)
	;;=SNACK CAKES,SWISS CAKE ROLLS,LITTLE DEBBIE^BC-00297^2.2-oz.^62
	;;^UTILITY(U,$J,112,7024,1)
	;;=2.581^18.871^63.065^432.258^14.516^^^0^1.274^^^^209.677^^^^^0^0^.113
	;;^UTILITY(U,$J,112,7024,2)
	;;=.081^.968^^^^^^^1.613^5^11.613^2.258
	;;^UTILITY(U,$J,112,7024,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7025,0)
	;;=SNACK CAKES,TWINKIES,HOSTESS^BC-00298^cakes^43
	;;^UTILITY(U,$J,112,7025,1)
	;;=2.326^11.628^60.465^372.093^^^^^^^^^348.837^^^^^0^0
	;;^UTILITY(U,$J,112,7025,2)
	;;=^^^^^^^^46.512
	;;^UTILITY(U,$J,112,7025,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7026,0)
	;;=SNACK CAKES,VAN,LITTLE DEBBIE^BC-00299^2.6-oz.^74
	;;^UTILITY(U,$J,112,7026,1)
	;;=2.162^29.189^54.459^487.838^13.514^^^5.405^.378^^^^220.27^^^^^0^0^.135
	;;^UTILITY(U,$J,112,7026,2)
	;;=.257^.946^^^^^^^1.351^7.568^18.514^2.973
	;;^UTILITY(U,$J,112,7026,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7027,0)
	;;=COOKIES,BARNUM'S^BC-00300^.5-oz.^14
	;;^UTILITY(U,$J,112,7027,1)
	;;=7.143^14.286^78.571^428.571^^^^^^^^^500^^^^^214.286
	;;^UTILITY(U,$J,112,7027,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7027,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7028,0)
	;;=COOKIES,APPLE NEWTON,NABISCO^BC-00301^.75-oz.^21
	;;^UTILITY(U,$J,112,7028,1)
	;;=4.762^9.524^71.429^380.952^^^^^^^^^214.286
	;;^UTILITY(U,$J,112,7028,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7028,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7029,0)
	;;=COOKIES,ARROWROOT BISCUIT,NATIONAL^BC-00302^.25-oz.^7
	;;^UTILITY(U,$J,112,7029,1)
	;;=0^14.286^42.857^285.714^^^^^^^^^214.286
	;;^UTILITY(U,$J,112,7029,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,7029,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7030,0)
	;;=COOKIES,BROWN EDGE WAFERS,NABISCO^BC-00303^.5-oz.^14
	;;^UTILITY(U,$J,112,7030,1)
	;;=7.143^21.429^71.429^500^^^^^^^^^321.429
	;;^UTILITY(U,$J,112,7030,2)
	;;=^^^^^^^^7.143
	;;^UTILITY(U,$J,112,7030,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7031,0)
	;;=COOKIES,BUTTERCUP,KEEBLER^BC-00304^3-cookies^15
	;;^UTILITY(U,$J,112,7031,1)
	;;=8^16^72^473.333^^^^26.667^2.533^^^146.667^600^^^^^^^.333
	;;^UTILITY(U,$J,112,7031,2)
	;;=.333^4^^^^^^^0^4^^1.333
	;;^UTILITY(U,$J,112,7031,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7032,0)
	;;=COOKIES,CAMEO CREME SANDWICH,NABISCO^BC-00305^.5-oz.^14
	;;^UTILITY(U,$J,112,7032,1)
	;;=7.143^21.429^71.429^500^^^^^^^^^357.143
	;;^UTILITY(U,$J,112,7032,2)
	;;=^^^^^^^^0^7.143
	;;^UTILITY(U,$J,112,7032,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7033,0)
	;;=COOKIES,CHOC CHIP CHEWY,CHIPS AHOY^BC-00306^.5-oz.^14
