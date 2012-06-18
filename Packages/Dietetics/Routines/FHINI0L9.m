FHINI0L9	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(116.112,.01,1,1,2)
	;;=K ^FH(116.1,DA(2),"RE",DA(1),"D","B",$E(X,1,30),DA)
	;;^DD(116.112,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.112,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the SERVICE POINT field.
	;;^DD(116.112,.01,21,0)
	;;=^^2^2^2911118^^^^
	;;^DD(116.112,.01,21,1,0)
	;;=This is the Service Point for which popularity values are
	;;^DD(116.112,.01,21,2,0)
	;;=applicable.
	;;^DD(116.112,.01,"DT")
	;;=2911204
	;;^DD(116.112,1,0)
	;;=POPULARITY %^NJ5,1^^0;2^K:+X'=X!(X>200)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(116.112,1,3)
	;;=Type a Number between 0 and 200, 1 Decimal Digit
	;;^DD(116.112,1,21,0)
	;;=^^2^2^2911203^^^
	;;^DD(116.112,1,21,1,0)
	;;=This is the percentage of orders for this Service Point
	;;^DD(116.112,1,21,2,0)
	;;=which will select, or have selected, this recipe.
	;;^DD(116.112,1,"DT")
	;;=2911203
	;;^DD(116.12,0)
	;;=RECIPE CATEGORY SUB-FIELD^^1^2
	;;^DD(116.12,0,"DT")
	;;=2950329
	;;^DD(116.12,0,"IX","B",116.12,.01)
	;;=
	;;^DD(116.12,0,"NM","RECIPE CATEGORY")
	;;=
	;;^DD(116.12,0,"UP")
	;;=116.11
	;;^DD(116.12,.01,0)
	;;=RECIPE CATEGORY^MRP114.1'^FH(114.1,^0;1^Q
	;;^DD(116.12,.01,1,0)
	;;=^.1
	;;^DD(116.12,.01,1,1,0)
	;;=116.12^B
	;;^DD(116.12,.01,1,1,1)
	;;=S ^FH(116.1,DA(2),"RE",DA(1),"R","B",$E(X,1,30),DA)=""
	;;^DD(116.12,.01,1,1,2)
	;;=K ^FH(116.1,DA(2),"RE",DA(1),"R","B",$E(X,1,30),DA)
	;;^DD(116.12,.01,21,0)
	;;=^^2^2^2950605^^
	;;^DD(116.12,.01,21,1,0)
	;;=This is the Recipe Category (File 114.1) for the associated
	;;^DD(116.12,.01,21,2,0)
	;;=Production Diets in this meal.
	;;^DD(116.12,.01,"DT")
	;;=2950329
	;;^DD(116.12,1,0)
	;;=PRODUCTION DIETS^RFX^^0;2^K:$L(X)>200!($L(X)<1) X I $D(X) D EN2^FHPRC1
	;;^DD(116.12,1,3)
	;;=
	;;^DD(116.12,1,4)
	;;=D EN3^FHPRC1
	;;^DD(116.12,1,21,0)
	;;=^^4^4^2950329^^^^
	;;^DD(116.12,1,21,1,0)
	;;=This is a list of the production diets which will receive the
	;;^DD(116.12,1,21,2,0)
	;;=recipe. It is a syntactically complex field containing the
	;;^DD(116.12,1,21,3,0)
	;;=production diet code and any specialized tray and cafeteria %'s
	;;^DD(116.12,1,21,4,0)
	;;=associated with that production diet.
	;;^DD(116.12,1,"DT")
	;;=2950330
