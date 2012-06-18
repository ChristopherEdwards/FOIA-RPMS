FHINI0I5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(114.01,1,21,1,0)
	;;=This field contains the quantity of the ingredient required. The
	;;^DD(114.01,1,21,2,0)
	;;=units are the 'Recipe Unit' as contained in the Ingredient file
	;;^DD(114.01,1,21,3,0)
	;;=for this ingredient.
	;;^DD(114.01,1,"DT")
	;;=2860812
	;;^DD(114.01,2,0)
	;;=ASSOCIATED NUTRIENT^P112'^FHNU(^0;3^Q
	;;^DD(114.01,2,21,0)
	;;=^^3^3^2930423^
	;;^DD(114.01,2,21,1,0)
	;;=This field is a pointer to the Nutrient file (112) and indicates
	;;^DD(114.01,2,21,2,0)
	;;=the nutrient most closely associated with this ingredient after
	;;^DD(114.01,2,21,3,0)
	;;=preparation.
	;;^DD(114.01,2,"DT")
	;;=2921111
	;;^DD(114.01,3,0)
	;;=NUTRIENT AMOUNT IN LBS.^NJ10,5^^0;4^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."6N.N) X
	;;^DD(114.01,3,3)
	;;=Type a Number between 0 and 9999, 5 Decimal Digits
	;;^DD(114.01,3,21,0)
	;;=^^4^4^2930423^
	;;^DD(114.01,3,21,1,0)
	;;=This value is the amount of the ingredient, in pounds, for
	;;^DD(114.01,3,21,2,0)
	;;=Nutrient Analysis purposes after taking into account removal
	;;^DD(114.01,3,21,3,0)
	;;=of non-edible amounts of the ingredient and any expansion or
	;;^DD(114.01,3,21,4,0)
	;;=shrinkage due to preparation.
	;;^DD(114.01,3,"DT")
	;;=2921111
	;;^DD(114.0103,0)
	;;=DIABETIC EXCHANGE SUB-FIELD^^1^2
	;;^DD(114.0103,0,"DT")
	;;=2950428
	;;^DD(114.0103,0,"IX","B",114.0103,.01)
	;;=
	;;^DD(114.0103,0,"NM","DIABETIC EXCHANGE")
	;;=
	;;^DD(114.0103,0,"UP")
	;;=114
	;;^DD(114.0103,.01,0)
	;;=DIABETIC EXCHANGE^MP114.1'^FH(114.1,^0;1^Q
	;;^DD(114.0103,.01,1,0)
	;;=^.1
	;;^DD(114.0103,.01,1,1,0)
	;;=114.0103^B
	;;^DD(114.0103,.01,1,1,1)
	;;=S ^FH(114,DA(1),"DBX","B",$E(X,1,30),DA)=""
	;;^DD(114.0103,.01,1,1,2)
	;;=K ^FH(114,DA(1),"DBX","B",$E(X,1,30),DA)
	;;^DD(114.0103,.01,21,0)
	;;=^^2^2^2950428^^^^
	;;^DD(114.0103,.01,21,1,0)
	;;=This multiple contains the Diabetic exchanges associated with
	;;^DD(114.0103,.01,21,2,0)
	;;=this recipe.
	;;^DD(114.0103,.01,"DT")
	;;=2950428
	;;^DD(114.0103,1,0)
	;;=QUANTITY^RNJ1,0^^0;2^K:+X'=X!(X>5)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(114.0103,1,3)
	;;=Type a Number between 1 and 5, 0 Decimal Digits
	;;^DD(114.0103,1,21,0)
	;;=^^3^3^2950501^^^^
	;;^DD(114.0103,1,21,1,0)
	;;=This is the quantity of the Diabetic exchange that needs to be
	;;^DD(114.0103,1,21,2,0)
	;;=omitted when the recipe is used in a meal for the Diabetic
	;;^DD(114.0103,1,21,3,0)
	;;=calculated diets.
	;;^DD(114.0103,1,"DT")
	;;=2950428
	;;^DD(114.02,0)
	;;=DIRECTIONS SUB-FIELD^NL^.01^1
	;;^DD(114.02,0,"NM","DIRECTIONS")
	;;=
	;;^DD(114.02,0,"UP")
	;;=114
	;;^DD(114.02,.01,0)
	;;=DIRECTIONS^W^^0;1^Q
	;;^DD(114.02,.01,21,0)
	;;=^^2^2^2880717^
	;;^DD(114.02,.01,21,1,0)
	;;=This field contains the text of the recipe preparation
	;;^DD(114.02,.01,21,2,0)
	;;=instructions.
	;;^DD(114.02,.01,"DT")
	;;=2840822
	;;^DD(114.03,0)
	;;=EMBEDDED RECIPE SUB-FIELD^NL^1^2
	;;^DD(114.03,0,"NM","EMBEDDED RECIPE")
	;;=
	;;^DD(114.03,0,"UP")
	;;=114
	;;^DD(114.03,.01,0)
	;;=EMBEDDED RECIPE^M*P114'X^FH(114,^0;1^S DIC("S")="I +Y'=D0" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(114.03,.01,12)
	;;=Don't allow selection of current recipe
	;;^DD(114.03,.01,12.1)
	;;=S DIC("S")="I +Y'=D0"
	;;^DD(114.03,.01,21,0)
	;;=^^3^3^2880914^^
	;;^DD(114.03,.01,21,1,0)
	;;=This field contains the name of a recipe which is to be
	;;^DD(114.03,.01,21,2,0)
	;;=embedded in the present one. The embedded recipe cannot be
	;;^DD(114.03,.01,21,3,0)
	;;=the same as the present recipe.
	;;^DD(114.03,.01,"DT")
	;;=2860918
	;;^DD(114.03,1,0)
	;;=NO. OF PORTIONS^RNJ7,2^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(114.03,1,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 9999
	;;^DD(114.03,1,21,0)
	;;=^^2^2^2881117^^
	;;^DD(114.03,1,21,1,0)
	;;=This is the number of portions of the embedded recipe required
	;;^DD(114.03,1,21,2,0)
	;;=in the present recipe.
	;;^DD(114.03,1,"DT")
	;;=2851222
	;;^DD(114.05,0)
	;;=EQUIPMENT SUB-FIELD^^.01^1
	;;^DD(114.05,0,"IX","B",114.05,.01)
	;;=
	;;^DD(114.05,0,"NM","EQUIPMENT")
	;;=
	;;^DD(114.05,0,"UP")
	;;=114
	;;^DD(114.05,.01,0)
	;;=EQUIPMENT^MP114.4^FH(114.4,^0;1^Q
	;;^DD(114.05,.01,1,0)
	;;=^.1
	;;^DD(114.05,.01,1,1,0)
	;;=114.05^B
	;;^DD(114.05,.01,1,1,1)
	;;=S ^FH(114,DA(1),"E","B",$E(X,1,30),DA)=""
	;;^DD(114.05,.01,1,1,2)
	;;=K ^FH(114,DA(1),"E","B",$E(X,1,30),DA)
	;;^DD(114.05,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114.05,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the EQUIPMENT field.
	;;^DD(114.05,.01,21,0)
	;;=^^3^3^2880919^
	;;^DD(114.05,.01,21,1,0)
	;;=This field contains a pointer to the Equipment file (114.4) and
	;;^DD(114.05,.01,21,2,0)
	;;=indicates an item of equipment used in the production of this
