FHINI00D	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112,72,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,73,0)
	;;=MYRISTIC ACID; GM/100G^NJ9,3^^4;3^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,73,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,73,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,73,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,74,0)
	;;=PALMITIC ACID; GM/100G^NJ9,3^^4;4^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,74,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,74,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,74,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,75,0)
	;;=PALMITOLEIC ACID; GM/100G^NJ9,3^^4;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,75,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,75,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,75,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,76,0)
	;;=STEARIC ACID; GM/100G^NJ9,3^^4;6^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,76,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,76,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,76,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,77,0)
	;;=OLEIC ACID; GM/100G^NJ9,3^^4;7^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,77,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,77,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,77,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,78,0)
	;;=ARACHIDONIC ACID; GM/100G^NJ9,3^^4;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,78,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,78,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,78,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
	;;^DD(112,79,0)
	;;=VITAMIN K; MCG/100G^NJ6,2^^4;9^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112,79,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(112,79,21,0)
	;;=^^1^1^2921107^
	;;^DD(112,79,21,1,0)
	;;=This is the value per 100 gms. of this nutrient
	;;^DD(112,79,"DT")
	;;=2920704
	;;^DD(112,80,0)
	;;=SELENIUM; MCG/100G^NJ6,2^^4;10^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112,80,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(112,80,21,0)
	;;=^^1^1^2921107^
	;;^DD(112,80,21,1,0)
	;;=This is the value per 100 gms. of this nutrient.
	;;^DD(112,80,"DT")
	;;=2920704
	;;^DD(112,99,0)
	;;=SOURCE OF DATA^F^^20;1^K:$L(X)>80!($L(X)<1) X
	;;^DD(112,99,3)
	;;=Type a Number between 0 and 99999, 3 Decimal Digits
	;;^DD(112,99,21,0)
	;;=^^1^1^2880710^
	;;^DD(112,99,21,1,0)
	;;=This is the value per 100 grams for this nutrient.
