FHINI0I4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(114,8,1,1,2)
	;;=K ^FH(114,"C",$E(X,1,30),DA)
	;;^DD(114,8,3)
	;;=ANSWER MUST BE 3-25 CHARACTERS IN LENGTH
	;;^DD(114,8,21,0)
	;;=^^2^2^2880717^
	;;^DD(114,8,21,1,0)
	;;=This field may contain a synonym, or alternate name, for the
	;;^DD(114,8,21,2,0)
	;;=recipe.
	;;^DD(114,8,"DT")
	;;=2861024
	;;^DD(114,9,0)
	;;=# DAYS PRE-PREP^NJ1,0^^0;10^K:+X'=X!(X>3)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(114,9,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 3
	;;^DD(114,9,21,0)
	;;=^^3^3^2880717^
	;;^DD(114,9,21,1,0)
	;;=This field contains the number of days in advance that the recipe
	;;^DD(114,9,21,2,0)
	;;=must be prepared. It need be answered only when non-zero, that is,
	;;^DD(114,9,21,3,0)
	;;=when the recipe is prepared in advance of the serving day.
	;;^DD(114,9,"DT")
	;;=2861208
	;;^DD(114,10,0)
	;;=PRINT RECIPE^SO^Y:YES;N:NO;^0;8^Q
	;;^DD(114,10,2)
	;;=S Y(0)=Y S:Y="" Y="Y"
	;;^DD(114,10,2.1)
	;;=S:Y="" Y="Y"
	;;^DD(114,10,21,0)
	;;=^^5^5^2910506^^
	;;^DD(114,10,21,1,0)
	;;=This field, when answered NO, will inhibit the printing of the
	;;^DD(114,10,21,2,0)
	;;=recipe even when such printing is requested as part of the
	;;^DD(114,10,21,3,0)
	;;=production summary. It is generally used to inhibit printing
	;;^DD(114,10,21,4,0)
	;;=of one-ingredient recipes or those which require no
	;;^DD(114,10,21,5,0)
	;;=preparation.
	;;^DD(114,10,"DT")
	;;=2861024
	;;^DD(114,11,0)
	;;=PRE-PREP STATE^S^M:MIX;D:DEHYDRATED;F:FROZEN;C:CANNED;X:CONCENTRATED;S:SCRATCH;I:IND/R-T-S;P:PARTIALLY PREP;R:R-T-S;^0;11^Q
	;;^DD(114,11,21,0)
	;;=^^3^3^2880913^^
	;;^DD(114,11,21,1,0)
	;;=This field indicates the state of the recipe, i.e., whether
	;;^DD(114,11,21,2,0)
	;;=a canned item, dehydrated, partially prepared, ready-to-serve,
	;;^DD(114,11,21,3,0)
	;;=etc.
	;;^DD(114,11,"DT")
	;;=2880913
	;;^DD(114,12,0)
	;;=PREPARATION AREA^P114.2'^FH(114.2,^0;12^Q
	;;^DD(114,12,21,0)
	;;=^^2^2^2880717^
	;;^DD(114,12,21,1,0)
	;;=This field indicates the preparation area of the kitchen where
	;;^DD(114,12,21,2,0)
	;;=the recipe would normally be prepared.
	;;^DD(114,12,"DT")
	;;=2871017
	;;^DD(114,20,0)
	;;=DIRECTIONS^114.02^^X;0
	;;^DD(114,20,3)
	;;=ANSWER MUST BE 1-80 CHARACTERS IN LENGTH
	;;^DD(114,20,21,0)
	;;=^^7^7^2880717^^
	;;^DD(114,20,21,1,0)
	;;=This field contains the directions for the preparation of
	;;^DD(114,20,21,2,0)
	;;=the recipe. References to absolute quantities of an
	;;^DD(114,20,21,3,0)
	;;=ingredient should not be made since the recipe will normally
	;;^DD(114,20,21,4,0)
	;;=be printed in an 'adjusted' form -- that is, the number of
	;;^DD(114,20,21,5,0)
	;;=portions will be adjusted and hence the individual ingredient
	;;^DD(114,20,21,6,0)
	;;=amounts will vary from those entered for the yield of the
	;;^DD(114,20,21,7,0)
	;;=recipe.
	;;^DD(114,101,0)
	;;=COST/PORTION^NJ6,3^^0;13^K:+X'=X!(X>30)!(X<.001)!(X?.E1"."4N.N) X
	;;^DD(114,101,3)
	;;=Type a Number between .001 and 30, 3 Decimal Digits
	;;^DD(114,101,21,0)
	;;=^^2^2^2910506^^^^
	;;^DD(114,101,21,1,0)
	;;=This field contains the cost per portion of the recipe based upon
	;;^DD(114,101,21,2,0)
	;;=the current prices shown in the Ingredient file (113).
	;;^DD(114,101,"DT")
	;;=2871018
	;;^DD(114,102,0)
	;;=ASSOCIATED NUTRIENT ANALYSIS^P112'^FHNU(^0;14^Q
	;;^DD(114,102,21,0)
	;;=^^2^2^2930423^
	;;^DD(114,102,21,1,0)
	;;=This is a pointer to the Nutrient file (112) and contains the
	;;^DD(114,102,21,2,0)
	;;=nutrient analysis of this recipe.
	;;^DD(114,102,"DT")
	;;=2921111
	;;^DD(114,103,0)
	;;=DIABETIC EXCHANGE^114.0103P^^DBX;0
	;;^DD(114,103,21,0)
	;;=^^2^2^2950501^^^^
	;;^DD(114,103,21,1,0)
	;;=This multiple contains the Diabetic exchanges associated with this
	;;^DD(114,103,21,2,0)
	;;=recipe.  It is use to handle the Diabetic calculated diets.
	;;^DD(114.01,0)
	;;=INGREDIENT SUB-FIELD^NL^3^4
	;;^DD(114.01,0,"DT")
	;;=2921111
	;;^DD(114.01,0,"NM","INGREDIENT")
	;;=
	;;^DD(114.01,0,"UP")
	;;=114
	;;^DD(114.01,.01,0)
	;;=INGREDIENT^MP113'X^FHING(^0;1^Q
	;;^DD(114.01,.01,21,0)
	;;=^^2^2^2880717^
	;;^DD(114.01,.01,21,1,0)
	;;=This field contains the name of an ingredient used in the
	;;^DD(114.01,.01,21,2,0)
	;;=recipe.
	;;^DD(114.01,.01,"DT")
	;;=2871025
	;;^DD(114.01,1,0)
	;;=QUANTITY^RNJ7,2XO^^0;2^S I9=+^FH(114,D0,"I",D1,0),UNT=$P(^FHING(I9,0),U,16) D EN1^FHREC1 I $D(X) K:X<.00001!(X>5000) X
	;;^DD(114.01,1,2)
	;;=S Y(0)=Y S I9=+^FH(114,D0,"I",D1,0),UNT=$P(^FHING(I9,0),U,16) D:Y'="" EN2^FHREC1
	;;^DD(114.01,1,2.1)
	;;=S I9=+^FH(114,D0,"I",D1,0),UNT=$P(^FHING(I9,0),U,16) D:Y'="" EN2^FHREC1
	;;^DD(114.01,1,3)
	;;=Enter Quantity in proper units
	;;^DD(114.01,1,21,0)
	;;=^^3^3^2920113^^^^
