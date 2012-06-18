FHDMP1	; HISC/REL - Patient Data Log (cont) ;5/7/92  15:25 
	;;5.0;Dietetics;;Oct 11, 1995
	D:$Y>(S1-3) HDR^FHDMP G:QT="^" KIL^FHDMP W !,LN,!?26,"A D M I S S I O N   D A T A"
	I $Y>(S1-9) D HDR^FHDMP G:QT="^" KIL^FHDMP
	S Y=$P($G(^DGPM(ADM,0)),"^",1) W !!,"Admitted: " D DTP
	S Y=$P($G(^DGPM(ADM,0)),"^",17) S:Y>0 Y=$P($G(^DGPM(+Y,0)),"^",1) W ?50,"Discharged: " D DTP
	S X=$G(^FHPT(DFN,"A",ADM,0))
	S Y=$P(X,"^",8) I Y W !!,"Dietetic Ward: ",$P($G(^FH(119.6,Y,0)),"^",1) S Y=$P(X,"^",9) W ?50,"Room-Bed: " I Y W $P($G(^DG(405.4,Y,0)),"^",1)
	W !!,"Current Diet Order: ",?20,$P(X,"^",2) S Y=$P(X,"^",3) W ?50,"Expires: ",?62 D DTP
	S Y=$P(X,"^",5) W !,"Current Service: ",?20,$S(Y="T":"Tray",Y="C":"Cafeteria",Y="D":"Dining Room",1:"")
	S Y=$P(X,"^",10) W !,"Current Isolation: ",?20,$P($G(^FH(119.4,+Y,0)),"^",1)
	W ?50,"Current Tubefeed Order: ",?76,$P(X,"^",4)
	S Y=$P(X,"^",11) W !,"Last Label Ward: ",?20,$P($G(^FH(119.6,+Y,0)),"^",1)
	W ?50,"Current Supp. Fdg. Order: ",?76,$P(X,"^",7)
	W !,"Last Label Room: ",?20,$P(X,"^",12),!
	G ^FHDMP2
DTP	; Printable Date/Time
	Q:Y<1  W $J(+$E(Y,6,7),2)_"-"_$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(Y,4,5))_"-"_$E(Y,2,3)
	I Y["." S %=+$E(Y_"0",9,10) W $J($S(%>12:%-12,1:%),3)_":"_$E(Y_"000",11,12)_$S(%<12:"am",%<24:"pm",1:"m")
	K % Q
