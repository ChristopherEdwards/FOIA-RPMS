FHINI0CM	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8084,2)
	;;=^^^^^^^^35.088^5.263^10.526^15.789
	;;^UTILITY(U,$J,112,8084,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8085,0)
	;;=SALAD DRESSING,REDUCED CALORIE,HARDEE'S^BC-01358^2-oz.^57
	;;^UTILITY(U,$J,112,8085,1)
	;;=1.754^8.772^36.842^228.07^^^^24.561^^^^122.807^842.105
	;;^UTILITY(U,$J,112,8085,2)
	;;=^^^^^^^^0^1.754^1.754^5.263
	;;^UTILITY(U,$J,112,8085,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8086,0)
	;;=SALAD DRESSING,HOUSE,HARDEE'S^BC-01359^2-oz.^57
	;;^UTILITY(U,$J,112,8086,1)
	;;=1.754^50.877^10.526^508.772^^^^31.579^^^^114.035^894.737
	;;^UTILITY(U,$J,112,8086,2)
	;;=^^^^^^^^43.86^7.018^15.789^28.07
	;;^UTILITY(U,$J,112,8086,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8087,0)
	;;=SALAD DRESSING,ITALIAN,REDUCED CALORIE,HARDEE'S^BC-01360^2-oz.^57
	;;^UTILITY(U,$J,112,8087,1)
	;;=0^14.035^8.772^157.895^^^^12.281^^^^26.316^543.86
	;;^UTILITY(U,$J,112,8087,2)
	;;=^^^^^^^^0^1.754^5.263^7.018
	;;^UTILITY(U,$J,112,8087,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8088,0)
	;;=SALAD DRESSING,THOUSAND ISLAND,HARDEE'S^BC-01361^2-oz.^57
	;;^UTILITY(U,$J,112,8088,1)
	;;=1.754^40.351^15.789^438.596^^^^15.789^^^^105.263^947.368
	;;^UTILITY(U,$J,112,8088,2)
	;;=^^^^^^^^61.404^5.263^14.035^21.053
	;;^UTILITY(U,$J,112,8088,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8089,0)
	;;=SALAD W/O DRESSING,CHEF,HARDEE'S^BC-01362^salad^294
	;;^UTILITY(U,$J,112,8089,1)
	;;=7.483^5.102^1.701^81.633^^^^94.898^.68^^^200.68^316.327
	;;^UTILITY(U,$J,112,8089,2)
	;;=^^^^^^^^39.116^3.061^1.701^.34
	;;^UTILITY(U,$J,112,8089,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8090,0)
	;;=SALAD W/O DRESSING,CHICKEN & PASTA,HARDEE'S^BC-01363^salad^414
	;;^UTILITY(U,$J,112,8090,1)
	;;=6.522^.725^5.556^55.556^^^^20.773^2.174^^^149.758^91.787
	;;^UTILITY(U,$J,112,8090,2)
	;;=^^^^^^^^13.285^.242^.242^.242
	;;^UTILITY(U,$J,112,8090,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8091,0)
	;;=SALAD W/O DRESSING,GARDEN,HARDEE'S^BC-01364^salad^241
	;;^UTILITY(U,$J,112,8091,1)
	;;=5.809^5.809^1.245^87.137^^^^119.917^.415^^^178.423^112.033
	;;^UTILITY(U,$J,112,8091,2)
	;;=^^^^^^^^43.568^3.32^2.075^.415
	;;^UTILITY(U,$J,112,8091,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8092,0)
	;;=SALAD W/O DRESSING,SIDE,HARDEE'S^BC-01365^salad^112
	;;^UTILITY(U,$J,112,8092,1)
	;;=1.786^.804^.893^17.857^^^^19.643^^^^151.786^13.393
	;;^UTILITY(U,$J,112,8092,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8092,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8093,0)
	;;=SHAKE,CHOCOLATE,HARDEE'S^BC-01366^shake^341
	;;^UTILITY(U,$J,112,8093,1)
	;;=3.226^2.346^24.927^134.897^^^^140.762^.293^^^152.493^99.707
	;;^UTILITY(U,$J,112,8093,2)
	;;=^^^^^^^^13.196^1.466^.587^0
	;;^UTILITY(U,$J,112,8093,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8094,0)
	;;=SHAKE,STRAWBERRY,HARDEE'S^BC-01367^shake^341
	;;^UTILITY(U,$J,112,8094,1)
	;;=3.226^2.346^24.047^129.032^^^^131.672^^^^111.437^87.977
	;;^UTILITY(U,$J,112,8094,2)
	;;=^^^^^^^^11.73^1.466^.587^0
	;;^UTILITY(U,$J,112,8094,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8095,0)
	;;=SHAKE,VANILLA,HARDEE'S^BC-01368^shake^341
	;;^UTILITY(U,$J,112,8095,1)
	;;=3.226^2.346^24.927^134.897^^^^140.762^.293^^^152.493^99.707
	;;^UTILITY(U,$J,112,8095,2)
	;;=^^^^^^^^13.196^1.466^.587^0
	;;^UTILITY(U,$J,112,8095,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8096,0)
	;;=TURKEY CLUB SANDWICH,HARDEE'S^BC-01369^sandwich^208
	;;^UTILITY(U,$J,112,8096,1)
	;;=13.942^7.692^15.385^187.5^^^^63.462^1.442^^^221.154^615.385
	;;^UTILITY(U,$J,112,8096,2)
	;;=^^^^^^^^33.654^1.923^2.885^2.404
	;;^UTILITY(U,$J,112,8096,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8097,0)
	;;=TURNOVER,APPLE,HARDEE'S^BC-01370^turnover^91
	;;^UTILITY(U,$J,112,8097,1)
	;;=3.297^13.187^41.758^296.703^^^^8.791^^^^82.418^274.725
	;;^UTILITY(U,$J,112,8097,2)
	;;=^^^^^^^^0^4.396^5.495^3.297
	;;^UTILITY(U,$J,112,8097,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8098,0)
	;;=BREADSTICKS,SESAME,JACK-IN-THE-BOX^BC-01371^serving^16
	;;^UTILITY(U,$J,112,8098,1)
	;;=12.5^12.5^75^437.5^^^^^^^^^687.5
	;;^UTILITY(U,$J,112,8098,2)
	;;=^^^^^^^^0
	;;^UTILITY(U,$J,112,8098,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
