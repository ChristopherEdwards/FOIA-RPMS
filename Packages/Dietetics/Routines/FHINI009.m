FHINI009	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112,4.2,1,2,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(112,4.2,1,2,"%D",1,0)
	;;=If Field 4.4 is Yes, then this Alternate Name is set under the "AQ"
	;;^DD(112,4.2,1,2,"%D",2,0)
	;;=Quick List for rapid selection.
	;;^DD(112,4.2,3)
	;;=ANSWER MUST BE 3-40 CHARACTERS IN LENGTH
	;;^DD(112,4.2,21,0)
	;;=^^1^1^2880717^
	;;^DD(112,4.2,21,1,0)
	;;=This field may contain an alternate name for the nutrient item.
	;;^DD(112,4.2,"DT")
	;;=2900510
	;;^DD(112,4.4,0)
	;;=ALT NAME QUICK LIST?^S^Y:YES;N:NO;^.6;3^Q
	;;^DD(112,4.4,1,0)
	;;=^.1
	;;^DD(112,4.4,1,1,0)
	;;=112^AE^MUMPS
	;;^DD(112,4.4,1,1,1)
	;;=I X="Y" S X1=$P(^FHNU(DA,.6),U,2) S:X1'="" ^FHNU("AQ",$E(X1,1,30),DA)=""
	;;^DD(112,4.4,1,1,2)
	;;=S X1=$P(^FHNU(DA,.6),U,2) K:X1'="" ^FHNU("AQ",$E(X1,1,30),DA)
	;;^DD(112,4.4,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(112,4.4,1,1,"%D",1,0)
	;;=This field, when answered Yes, will result in the Alternate Name (Field
	;;^DD(112,4.4,1,1,"%D",2,0)
	;;=4.2) being placed under the "AQ" Quick List for rapid selection.
	;;^DD(112,4.4,21,0)
	;;=^^2^2^2880717^
	;;^DD(112,4.4,21,1,0)
	;;=This field, when answered YES, means that the alternate name
	;;^DD(112,4.4,21,2,0)
	;;=of this nutrient is also on the Quick List for rapid look-up.
	;;^DD(112,4.4,"DT")
	;;=2850615
	;;^DD(112,5,0)
	;;=% AS PURCHASED^NJ3,0^^0;5^K:+X'=X!(X>600)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112,5,3)
	;;=Type a Number between 0 and 600, 0 Decimal Digits
	;;^DD(112,5,21,0)
	;;=^^2^2^2930520^^^^
	;;^DD(112,5,21,1,0)
	;;=This field contains the percentage of the as purchased weight
	;;^DD(112,5,21,2,0)
	;;=that is present after preparation.
	;;^DD(112,5,"DT")
	;;=2930520
	;;^DD(112,6,0)
	;;=EDITABLE?^SI^Y:YES;N:NO;^0;6^Q
	;;^DD(112,6,3)
	;;=N means that entry cannot be edited (USDA data)
	;;^DD(112,6,21,0)
	;;=^^3^3^2880717^
	;;^DD(112,6,21,1,0)
	;;=This field, when answered NO, means that the item is an USDA
	;;^DD(112,6,21,2,0)
	;;=item and that the Handbook values for the various nutrients
	;;^DD(112,6,21,3,0)
	;;=cannot be edited by dietetic personnel.
	;;^DD(112,6,"DT")
	;;=2850322
	;;^DD(112,7,0)
	;;=TYPE^S^E:EDIBLE;R:RAW/RARE;X:RECIPE;^0;7^Q
	;;^DD(112,7,21,0)
	;;=^^3^3^2921111^^^^
	;;^DD(112,7,21,1,0)
	;;=This field, if E, will allow selection of edible foods for energy
	;;^DD(112,7,21,2,0)
	;;=analyses; if R, can be selected for recipe analyses.
	;;^DD(112,7,21,3,0)
	;;=If X, analysis is of a recipe in File 114 and cannot be selected.
	;;^DD(112,7,"DT")
	;;=2921111
	;;^DD(112,11,0)
	;;=PROTEIN; GM/100G^NJ9,3^^1;1^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,11,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,11,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,11,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,12,0)
	;;=LIPIDS; GM/100G^NJ9,3^^1;2^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,12,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,12,21,0)
	;;=^^1^1^2930510^^
	;;^DD(112,12,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,13,0)
	;;=CARBOHYDRATE; GM/100G^NJ9,3^^1;3^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,13,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,13,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,13,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,14,0)
	;;=FOOD ENERGY; KCAL/100G^NJ9,3^^1;4^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,14,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,14,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,14,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,15,0)
	;;=WATER; GM/100G^NJ9,3^^1;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,15,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,15,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,15,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,18,0)
	;;=CALCIUM; MG/100G^NJ9,3^^1;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,18,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,18,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,18,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,19,0)
	;;=IRON; MG/100G^NJ9,3^^1;9^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,19,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,19,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,19,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,20,0)
	;;=MAGNESIUM; MG/100G^NJ9,3^^1;10^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,20,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,20,21,0)
	;;=^^1^1^2880710^
