FHINI0H4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112.62,2,"DT")
	;;=2931117
	;;^DD(112.62,3,0)
	;;=PRODUCTION DIET^P116.2^FH(116.2,^0;3^Q
	;;^DD(112.62,3,3)
	;;=
	;;^DD(112.62,3,21,0)
	;;=^^2^2^2931124^^^^
	;;^DD(112.62,3,21,1,0)
	;;=This is a pointer to the Production Diet file (116.2) to indicate
	;;^DD(112.62,3,21,2,0)
	;;=the Production Diet which associates with the menu.
	;;^DD(112.62,3,"DT")
	;;=2931124
	;;^DD(112.62,4,0)
	;;=RECIPE^112.64P^^2;0
	;;^DD(112.62,4,21,0)
	;;=^^2^2^2931117^^
	;;^DD(112.62,4,21,1,0)
	;;=This multiple stores the selected recipes from the Recipe file
	;;^DD(112.62,4,21,2,0)
	;;=used for the Meal Analysis.
	;;^DD(112.63,0)
	;;=FOOD ITEM SUB-FIELD^NL^1^2
	;;^DD(112.63,0,"NM","FOOD ITEM")
	;;=
	;;^DD(112.63,0,"UP")
	;;=112.62
	;;^DD(112.63,.01,0)
	;;=FOOD ITEM^MP112'X^FHNU(^0;1^S:$D(X) DINUM=X
	;;^DD(112.63,.01,21,0)
	;;=^^1^1^2931117^^^^
	;;^DD(112.63,.01,21,1,0)
	;;=This is the food item selected from the Food Nutrient file.
	;;^DD(112.63,.01,"DT")
	;;=2841114
	;;^DD(112.63,1,0)
	;;=AMOUNT^NJ9,3^^0;2^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112.63,1,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 99999
	;;^DD(112.63,1,21,0)
	;;=^^3^3^2931117^^^^
	;;^DD(112.63,1,21,1,0)
	;;=This is the amount of the food item. If grams were selected as
	;;^DD(112.63,1,21,2,0)
	;;=the units type, then the amount is in grams. If common units
	;;^DD(112.63,1,21,3,0)
	;;=were selected, the amount is in terms of those common units.
	;;^DD(112.63,1,"DT")
	;;=2851127
	;;^DD(112.64,0)
	;;=RECIPE SUB-FIELD^^1^2
	;;^DD(112.64,0,"DT")
	;;=2931117
	;;^DD(112.64,0,"NM","RECIPE")
	;;=
	;;^DD(112.64,0,"UP")
	;;=112.62
	;;^DD(112.64,.01,0)
	;;=RECIPE^MP114'X^FH(114,^0;1^S:$D(X) DINUM=X
	;;^DD(112.64,.01,1,0)
	;;=^.1^^0
	;;^DD(112.64,.01,21,0)
	;;=^^1^1^2931220^^^^
	;;^DD(112.64,.01,21,1,0)
	;;=This is the recipe selected from the Recipe file.
	;;^DD(112.64,.01,"DT")
	;;=2931123
	;;^DD(112.64,1,0)
	;;=SERVING PORTION^NJ6,1^^0;2^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."2N.N) X
	;;^DD(112.64,1,3)
	;;=Type a Number between 1 and 9999, 1 Decimal Digit
	;;^DD(112.64,1,21,0)
	;;=^^1^1^2931117^
	;;^DD(112.64,1,21,1,0)
	;;=This is the serving portion of the recipe.
	;;^DD(112.64,1,"DT")
	;;=2931117
