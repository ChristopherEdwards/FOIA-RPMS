FHINI00B	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112,37,0)
	;;=LINOLEIC ACID; GM/100G^NJ9,3^^2;7^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,37,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,37,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,37,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,38,0)
	;;=LINOLENIC ACID; GM/100G^NJ9,3^^2;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,38,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,38,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,38,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,39,0)
	;;=CHOLESTEROL; MG/100G^NJ9,3^^2;9^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,39,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,39,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,39,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,40,0)
	;;=SATURATED FAT; GM/100G^NJ10,3^^2;10^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,40,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,40,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,40,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,41,0)
	;;=MONOUNSATURATED FAT; GM/100G^NJ10,3^^2;11^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,41,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,41,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,41,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,42,0)
	;;=POLYUNSATURATED FAT; GM/100G^NJ10,3^^2;12^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,42,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,42,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,42,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,43,0)
	;;=VITAMIN A; RE/100G^NJ9,3^^2;13^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,43,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,43,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,43,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,43,"DT")
	;;=2891204
	;;^DD(112,44,0)
	;;=ASH; GM/100G^NJ9,3^^2;14^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,44,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,44,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,44,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,44,"DT")
	;;=2891204
	;;^DD(112,45,0)
	;;=ALCOHOL; GM/100G^NJ9,3^^2;15^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,45,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,45,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,45,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,46,0)
	;;=CAFFEINE; MG/100G^NJ9,3^^2;16^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,46,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,46,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,46,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,46,"DT")
	;;=2891204
	;;^DD(112,47,0)
	;;=TOTAL DIETARY FIBER; GM/100G^NJ9,3^^2;17^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,47,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,47,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,47,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,48,0)
	;;=TOTAL TOCOPHEROL; MG/100G^NJ9,3^^2;18^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,48,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,48,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,48,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,51,0)
	;;=TRYPTOPHAN; GM/100G^NJ9,3^^3;1^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,51,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,51,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,51,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,52,0)
	;;=THREONINE; GM/100G^NJ9,3^^3;2^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,52,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,52,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,52,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,53,0)
	;;=ISOLEUCINE; GM/100G^NJ9,3^^3;3^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,53,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,53,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,53,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,54,0)
	;;=LEUCINE; GM/100G^NJ9,3^^3;4^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,54,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,54,21,0)
	;;=^^1^1^2880710^
