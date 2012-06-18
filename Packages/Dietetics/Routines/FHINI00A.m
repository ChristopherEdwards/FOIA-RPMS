FHINI00A	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112,20,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,21,0)
	;;=PHOSPHORUS; MG/100G^NJ9,3^^1;11^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,21,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,21,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,21,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,22,0)
	;;=POTASSIUM; MG/100G^NJ9,3^^1;12^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,22,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,22,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,22,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,23,0)
	;;=SODIUM; MG/100G^NJ9,3^^1;13^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,23,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,23,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,23,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,24,0)
	;;=ZINC; MG/100G^NJ9,3^^1;14^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,24,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,24,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,24,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,25,0)
	;;=COPPER; MG/100G^NJ9,3^^1;15^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,25,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,25,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,25,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,26,0)
	;;=MANGANESE; MG/100G^NJ9,3^^1;16^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,26,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,26,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,26,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,27,0)
	;;=ALPHA TOCOPHEROL; MG/100G^NJ9,3^^1;17^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,27,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,27,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,27,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,28,0)
	;;=VITAMIN A; IU/100G^NJ9,3^^1;18^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,28,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,28,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,28,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,29,0)
	;;=ASCORBIC ACID; MG/100G^NJ9,3^^1;19^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,29,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,29,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,29,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,30,0)
	;;=THIAMIN; MG/100G^NJ9,3^^1;20^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,30,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,30,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,30,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,31,0)
	;;=RIBOFLAVIN; MG/100G^NJ9,3^^2;1^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,31,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,31,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,31,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,32,0)
	;;=NIACIN; MG/100G^NJ9,3^^2;2^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,32,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,32,21,0)
	;;=^^1^1^2930510^^
	;;^DD(112,32,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,33,0)
	;;=PANTOTHENIC ACID; MG/100G^NJ9,3^^2;3^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,33,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,33,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,33,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,34,0)
	;;=VITAMIN B6; MG/100G^NJ9,3^^2;4^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,34,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,34,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,34,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,35,0)
	;;=FOLATE; MCG/100G^NJ9,3^^2;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,35,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,35,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,35,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,36,0)
	;;=VITAMIN B12; MCG/100G^NJ9,3^^2;6^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,36,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,36,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,36,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
