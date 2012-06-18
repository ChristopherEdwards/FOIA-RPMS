FHINI00C	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112,54,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,55,0)
	;;=LYSINE; GM/100G^NJ9,3^^3;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,55,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,55,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,55,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,56,0)
	;;=METHIONINE; GM/100G^NJ9,3^^3;6^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,56,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,56,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,56,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,57,0)
	;;=CYSTINE; GM/100G^NJ9,3^^3;7^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,57,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,57,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,57,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,58,0)
	;;=PHENYLALANINE; GM/100G^NJ9,3^^3;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,58,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,58,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,58,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,59,0)
	;;=TYROSINE; GM/100G^NJ9,3^^3;9^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,59,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,59,21,0)
	;;=^^1^1^2940802^^
	;;^DD(112,59,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,59,"DT")
	;;=2940802
	;;^DD(112,60,0)
	;;=VALINE; GM/100G^NJ9,3^^3;10^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,60,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,60,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,60,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,61,0)
	;;=ARGININE; GM/100G^NJ9,3^^3;11^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,61,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,61,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,61,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,62,0)
	;;=HISTIDINE; GM/100G^NJ9,3^^3;12^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,62,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,62,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,62,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,63,0)
	;;=ALANINE; GM/100G^NJ9,3^^3;13^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,63,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,63,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,63,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,64,0)
	;;=ASPARTIC ACID; GM/100G^NJ9,3^^3;14^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,64,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,64,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,64,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,65,0)
	;;=GLUTAMIC ACID; GM/100G^NJ9,3^^3;15^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,65,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,65,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,65,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,66,0)
	;;=GLYCINE; GM/100G^NJ9,3^^3;16^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,66,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,66,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,66,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,67,0)
	;;=PROLINE; GM/100G^NJ9,3^^3;17^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,67,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,67,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,67,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,68,0)
	;;=SERINE; GM/100G^NJ9,3^^3;18^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,68,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,68,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,68,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,68,"DT")
	;;=2891204
	;;^DD(112,71,0)
	;;=CAPRIC ACID; GM/100G^NJ9,3^^4;1^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,71,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,71,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,71,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,71,"DT")
	;;=2891205
	;;^DD(112,72,0)
	;;=LAURIC ACID; GM/100G^NJ9,3^^4;2^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,72,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,72,21,0)
	;;=^^1^1^2880710^
