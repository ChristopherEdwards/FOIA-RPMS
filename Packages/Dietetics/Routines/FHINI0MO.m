FHINI0MO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.61,.01,21,2,0)
	;;=feeding) item to be delivered to the ward.
	;;^DD(119.61,.01,"DT")
	;;=2850604
	;;^DD(119.61,1,0)
	;;=QUANTITY^RNJ2,0^^0;2^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.61,1,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 99
	;;^DD(119.61,1,21,0)
	;;=^^2^2^2880717^
	;;^DD(119.61,1,21,1,0)
	;;=This field represents the quantity of the bulk nourishment
	;;^DD(119.61,1,21,2,0)
	;;=item to be delivered.
	;;^DD(119.61,1,"DT")
	;;=2850604
	;;^DD(119.62,0)
	;;=ROOM-BED SUB-FIELD^^1^2
	;;^DD(119.62,0,"DT")
	;;=2940127
	;;^DD(119.62,0,"IX","B",119.62,.01)
	;;=
	;;^DD(119.62,0,"NM","ROOM-BED")
	;;=
	;;^DD(119.62,0,"UP")
	;;=119.6
	;;^DD(119.62,.01,0)
	;;=ROOM-BED^MP405.4'X^DG(405.4,^0;1^I $D(X) S Y=$O(^FH(119.6,"AR",X,0)) I Y>0,Y-DA(1) W *7,"  Room already assigned to ",$P($G(^FH(119.6,+Y,0)),"^",1) K X
	;;^DD(119.62,.01,1,0)
	;;=^.1
	;;^DD(119.62,.01,1,1,0)
	;;=119.62^B
	;;^DD(119.62,.01,1,1,1)
	;;=S ^FH(119.6,DA(1),"R","B",$E(X,1,30),DA)=""
	;;^DD(119.62,.01,1,1,2)
	;;=K ^FH(119.6,DA(1),"R","B",$E(X,1,30),DA)
	;;^DD(119.62,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.62,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the ROOM-BED field.
	;;^DD(119.62,.01,1,2,0)
	;;=119.6^AR
	;;^DD(119.62,.01,1,2,1)
	;;=S ^FH(119.6,"AR",$E(X,1,30),DA(1),DA)=""
	;;^DD(119.62,.01,1,2,2)
	;;=K ^FH(119.6,"AR",$E(X,1,30),DA(1),DA)
	;;^DD(119.62,.01,1,2,"DT")
	;;=2911015
	;;^DD(119.62,.01,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.62,.01,21,1,0)
	;;=This field is a pointer to File 405.4 and indicates that this room-bed
	;;^DD(119.62,.01,21,2,0)
	;;=is to be considered part of this Dietetic Ward.
	;;^DD(119.62,.01,"DT")
	;;=2911030
	;;^DD(119.62,1,0)
	;;=DELIVERY ORDER^NJ2,0^^0;2^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.62,1,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(119.62,1,21,0)
	;;=^^3^3^2940127^
	;;^DD(119.62,1,21,1,0)
	;;=This value will be used to determine the order of printing labels
	;;^DD(119.62,1,21,2,0)
	;;=or tickets for items to be delivered.  Thus, the value represents
	;;^DD(119.62,1,21,3,0)
	;;=the order of delivery for beds on the ward.
	;;^DD(119.62,1,"DT")
	;;=2940127
	;;^DD(119.63,0)
	;;=ASSOCIATED MAS WARD SUB-FIELD^^.01^1
	;;^DD(119.63,0,"DT")
	;;=2911018
	;;^DD(119.63,0,"IX","B",119.63,.01)
	;;=
	;;^DD(119.63,0,"NM","ASSOCIATED MAS WARD")
	;;=
	;;^DD(119.63,0,"UP")
	;;=119.6
	;;^DD(119.63,.01,0)
	;;=ASSOCIATED MAS WARD^MP42'X^DIC(42,^0;1^I $D(X) S Y=$O(^FH(119.6,"AW",X,0)) I Y>0,Y-DA(1) W *7,"  Ward already assigned to ",$P($G(^FH(119.6,+Y,0)),"^",1) K X
	;;^DD(119.63,.01,1,0)
	;;=^.1
	;;^DD(119.63,.01,1,1,0)
	;;=119.63^B
	;;^DD(119.63,.01,1,1,1)
	;;=S ^FH(119.6,DA(1),"W","B",$E(X,1,30),DA)=""
	;;^DD(119.63,.01,1,1,2)
	;;=K ^FH(119.6,DA(1),"W","B",$E(X,1,30),DA)
	;;^DD(119.63,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.63,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the ASSOCIATED MAS WARD field.
	;;^DD(119.63,.01,1,2,0)
	;;=119.6^AW
	;;^DD(119.63,.01,1,2,1)
	;;=S ^FH(119.6,"AW",$E(X,1,30),DA(1),DA)=""
	;;^DD(119.63,.01,1,2,2)
	;;=K ^FH(119.6,"AW",$E(X,1,30),DA(1),DA)
	;;^DD(119.63,.01,1,2,"DT")
	;;=2911018
	;;^DD(119.63,.01,21,0)
	;;=^^5^5^2911204^
	;;^DD(119.63,.01,21,1,0)
	;;=This field indicates that (a) on admission, a patient with no room-bed,
	;;^DD(119.63,.01,21,2,0)
	;;=but assigned to this MAS ward, will be considered to be on this Dietetic
	;;^DD(119.63,.01,21,3,0)
	;;=Ward.
	;;^DD(119.63,.01,21,4,0)
	;;=(b) For forecasting purposes, the census of this MAS ward will be used
	;;^DD(119.63,.01,21,5,0)
	;;=in calculating the forecasted census for this Dietetic ward.
	;;^DD(119.63,.01,"DT")
	;;=2911030
