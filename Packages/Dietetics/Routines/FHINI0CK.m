FHINI0CK	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8055,2)
	;;=^^^^^^^^31.792^1.156^2.312^3.468
	;;^UTILITY(U,$J,112,8055,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8056,0)
	;;=CHICKEN,GRILLED,SANDWICH,HARDEE'S^BC-01329^sandwich^192
	;;^UTILITY(U,$J,112,8056,1)
	;;=12.5^4.688^17.708^161.458^^^^70.833^1.563^^^^463.542
	;;^UTILITY(U,$J,112,8056,2)
	;;=^^^^^^^^31.25^.521^1.563^2.604
	;;^UTILITY(U,$J,112,8056,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8057,0)
	;;=CHICKEN STIX,HARDEE'S^BC-01330^6-pieces^100
	;;^UTILITY(U,$J,112,8057,1)
	;;=19^9^13^210^^^^20^1^^^260^680
	;;^UTILITY(U,$J,112,8057,2)
	;;=^^^^^^^^35^2^4^3
	;;^UTILITY(U,$J,112,8057,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8058,0)
	;;=COOL TWIST CONE,CHOCOLATE,HARDEE'S^BC-01331^cone^119
	;;^UTILITY(U,$J,112,8058,1)
	;;=3.361^5.042^26.05^168.067^^^^103.361^1.681^^^184.874^54.622
	;;^UTILITY(U,$J,112,8058,2)
	;;=^^^^^^^^16.807^3.361^1.681^0
	;;^UTILITY(U,$J,112,8058,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8059,0)
	;;=COOL TWIST CONE,VANILLA,HARDEE'S^BC-01332^cone^119
	;;^UTILITY(U,$J,112,8059,1)
	;;=4.202^5.042^23.529^159.664^^^^102.521^^^^88.235^84.034
	;;^UTILITY(U,$J,112,8059,2)
	;;=^^^^^^^^12.605^3.361^1.681^0
	;;^UTILITY(U,$J,112,8059,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8060,0)
	;;=COOL TWIST CONE,VANILLA/CHOCOLATE,HARDEE'S^BC-01333^cone^119
	;;^UTILITY(U,$J,112,8060,1)
	;;=3.361^5.042^24.37^159.664^^^^103.361^1.681^^^151.261^67.227
	;;^UTILITY(U,$J,112,8060,2)
	;;=^^^^^^^^16.807^3.361^1.681^0
	;;^UTILITY(U,$J,112,8060,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8061,0)
	;;=COOL TWIST SUNDAE,CARAMEL,HARDEE'S^BC-01334^sundae^169
	;;^UTILITY(U,$J,112,8061,1)
	;;=3.55^5.917^31.953^195.266^^^^121.302^^^^130.178^171.598
	;;^UTILITY(U,$J,112,8061,2)
	;;=^^^^^^^^11.834^2.959^1.775^.592
	;;^UTILITY(U,$J,112,8061,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8062,0)
	;;=COOL TWIST SUNDAE,HOT FUDGE,HARDEE'S^BC-01335^sundae^168
	;;^UTILITY(U,$J,112,8062,1)
	;;=4.167^7.143^26.786^190.476^^^^106.548^.595^^^166.667^160.714
	;;^UTILITY(U,$J,112,8062,2)
	;;=^^^^^^^^14.881^3.571^2.381^.595
	;;^UTILITY(U,$J,112,8062,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8063,0)
	;;=COOL TWIST SUNDAE,STRAWBERRY,HARDEE'S^BC-01336^sundae^166
	;;^UTILITY(U,$J,112,8063,1)
	;;=3.012^4.819^25.904^156.627^^^^86.747^^^^90.361^69.277
	;;^UTILITY(U,$J,112,8063,2)
	;;=^^^^^^^^9.036^3.012^1.807^.602
	;;^UTILITY(U,$J,112,8063,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8064,0)
	;;=CRISPY CURLS,HARDEE'S^BC-01337^serving^85
	;;^UTILITY(U,$J,112,8064,1)
	;;=4.706^18.824^42.353^352.941^^^^30.588^1.176^^^435.294^988.235
	;;^UTILITY(U,$J,112,8064,2)
	;;=^^^^^^^^0^3.529^9.412^5.882
	;;^UTILITY(U,$J,112,8064,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8065,0)
	;;=DIPPING SAUCE,BARBECUE,HARDEE'S^BC-01338^oz.^28
	;;^UTILITY(U,$J,112,8065,1)
	;;=0^0^28.571^107.143^^^^32.143^^^^107.143^1071.429
	;;^UTILITY(U,$J,112,8065,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8065,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8066,0)
	;;=DIPPING SAUCE,SWEET MUSTARD,HARDEE'S^BC-01339^oz.^28
	;;^UTILITY(U,$J,112,8066,1)
	;;=0^0^35.714^178.571^^^^53.571^^^^53.571^571.429
	;;^UTILITY(U,$J,112,8066,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8066,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8067,0)
	;;=DIPPING SAUCE,SWEET 'N SOUR,HARDEE'S^BC-01340^oz.^28
	;;^UTILITY(U,$J,112,8067,1)
	;;=0^0^35.714^142.857^^^^21.429^^^^17.857^339.286
	;;^UTILITY(U,$J,112,8067,2)
	;;=^^^^^^^^0^0^0^0
	;;^UTILITY(U,$J,112,8067,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8068,0)
	;;=DANISH,CINNAMON 'N RAISIN,HARDEE'S^BC-01341^danish^80
	;;^UTILITY(U,$J,112,8068,1)
	;;=5^21.25^46.25^400^^^^156.25^2.5^^^100^637.5
	;;^UTILITY(U,$J,112,8068,2)
	;;=^^^^^^^^0^6.25^12.5^2.5
	;;^UTILITY(U,$J,112,8068,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8069,0)
	;;=FISHERMAN'S FILLET SANDWICH,HARDEE'S^BC-01342^sandwich^207
	;;^UTILITY(U,$J,112,8069,1)
	;;=11.111^11.594^23.671^241.546^^^^100.966^1.449^^^198.068^497.585
	;;^UTILITY(U,$J,112,8069,2)
	;;=^^^^^^^^33.816^2.899^3.382^5.314
	;;^UTILITY(U,$J,112,8069,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8070,0)
	;;=FRENCH FRIES (BIG),HARDEE'S^BC-01343^5.5-oz.^156
