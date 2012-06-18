FHINI0H0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(112.2,9,0)
	;;=FOLATE MCG^NJ4,0^^1;9^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,9,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(112.2,9,21,0)
	;;=^^2^2^2891117^^^
	;;^DD(112.2,9,21,1,0)
	;;=This field represents the recommended amount of Folate per
	;;^DD(112.2,9,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,10,0)
	;;=VITAMIN B12 MCG^NJ3,1^^1;10^K:+X'=X!(X>5)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,10,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 5
	;;^DD(112.2,10,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,10,21,1,0)
	;;=This field represents the recommended amount of Vitamin B12 per
	;;^DD(112.2,10,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,11,0)
	;;=CALCIUM MG^NJ4,0^^1;11^K:+X'=X!(X>2000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,11,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 2000
	;;^DD(112.2,11,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,11,21,1,0)
	;;=This field represents the recommended amount of Calcium per
	;;^DD(112.2,11,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,12,0)
	;;=PHOSPHORUS MG^NJ4,0^^1;12^K:+X'=X!(X>2000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,12,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 2000
	;;^DD(112.2,12,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,12,21,1,0)
	;;=This field represents the recommended amount of Phosphorus per
	;;^DD(112.2,12,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,13,0)
	;;=MAGNESIUM MG^NJ4,0^^1;13^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,13,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(112.2,13,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,13,21,1,0)
	;;=This field represents the recommended amount of Magnesium per
	;;^DD(112.2,13,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,14,0)
	;;=IRON MG^NJ3,0^^1;14^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,14,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 100
	;;^DD(112.2,14,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,14,21,1,0)
	;;=This field represents the recommended amount of Iron per
	;;^DD(112.2,14,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,15,0)
	;;=ZINC MG^NJ2,0^^1;15^K:+X'=X!(X>50)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,15,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 50
	;;^DD(112.2,15,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,15,21,1,0)
	;;=This field represents the recommended amount of Zinc per
	;;^DD(112.2,15,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,16,0)
	;;=PANTOTHENIC ACID MG^NJ4,1^^1;16^K:+X'=X!(X>20)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,16,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 20
	;;^DD(112.2,16,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,16,21,1,0)
	;;=This field represents the recommended amount of Pantothenic Acid per
	;;^DD(112.2,16,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,17,0)
	;;=COPPER MG^NJ5,2^^1;17^K:+X'=X!(X>10)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112.2,17,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 10
	;;^DD(112.2,17,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,17,21,1,0)
	;;=This field represents the recommended amount of Copper per
	;;^DD(112.2,17,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,18,0)
	;;=MANGANESE MG^NJ5,2^^1;18^K:+X'=X!(X>20)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112.2,18,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 20
	;;^DD(112.2,18,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,18,21,1,0)
	;;=This field represents the recommended amount of Manganese per
	;;^DD(112.2,18,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,19,0)
	;;=SODIUM MG^NJ4,0^^1;19^K:+X'=X!(X>5000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,19,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 5000
	;;^DD(112.2,19,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,19,21,1,0)
	;;=This field represents the recommended amount of Sodium per
	;;^DD(112.2,19,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,20,0)
	;;=POTASSIUM MG^NJ5,0^^1;20^K:+X'=X!(X>20000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,20,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 20000
	;;^DD(112.2,20,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,20,21,1,0)
	;;=This field represents the recommended amount of Potassium per
	;;^DD(112.2,20,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,21,0)
	;;=VITAMIN K MCG^NJ6,2^^1;21^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112.2,21,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(112.2,21,21,0)
	;;=^^2^2^2921107^
	;;^DD(112.2,21,21,1,0)
	;;=This field represents the recommended amount of Vitamin K
	;;^DD(112.2,21,21,2,0)
	;;=per day for this RDA group.
	;;^DD(112.2,21,"DT")
	;;=2920704
	;;^DD(112.2,22,0)
	;;=SELENIUM MCG^NJ6,2^^1;22^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(112.2,22,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(112.2,22,21,0)
	;;=^^2^2^2921107^^
	;;^DD(112.2,22,21,1,0)
	;;=This field represents the recommended amount of Selenium
