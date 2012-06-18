FHINI007	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(111.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(111.13,0,"UP")
	;;=111.1
	;;^DD(111.13,.01,0)
	;;=ASSOCIATED STANDING ORDERS (E)^MP118.3'^FH(118.3,^0;1^Q
	;;^DD(111.13,.01,1,0)
	;;=^.1
	;;^DD(111.13,.01,1,1,0)
	;;=111.13^B
	;;^DD(111.13,.01,1,1,1)
	;;=S ^FH(111.1,DA(1),"ES","B",$E(X,1,30),DA)=""
	;;^DD(111.13,.01,1,1,2)
	;;=K ^FH(111.1,DA(1),"ES","B",$E(X,1,30),DA)
	;;^DD(111.13,.01,21,0)
	;;=^^3^3^2950717^^
	;;^DD(111.13,.01,21,1,0)
	;;=The Standing Orders on this multiple will all be added to the patient's
	;;^DD(111.13,.01,21,2,0)
	;;=Standing Order entries for the evening meal when this diet or diet
	;;^DD(111.13,.01,21,3,0)
	;;=modification is ordered for the patient.
	;;^DD(111.13,.01,"DT")
	;;=2940721
	;;^DD(111.13,1,0)
	;;=QUANTITY^NJ1,0^^0;2^K:+X'=X!(X>9)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(111.13,1,3)
	;;=Type a Number between 1 and 9, 0 Decimal Digits
	;;^DD(111.13,1,21,0)
	;;=^^1^1^2940722^
	;;^DD(111.13,1,21,1,0)
	;;=This is the quantity of the Standing Order.
	;;^DD(111.13,1,"DT")
	;;=2940722
