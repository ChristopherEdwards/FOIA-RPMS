FHINI0KK	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.011,19,21,2,0)
	;;=indicating the current classification of the patient for
	;;^DD(115.011,19,21,3,0)
	;;=this assessment.
	;;^DD(115.011,19,"DT")
	;;=2890705
	;;^DD(115.011,20,0)
	;;=APPEARANCE^F^^2;1^K:$L(X)>60!($L(X)<1) X
	;;^DD(115.011,20,3)
	;;=Answer must be 1-60 characters in length.
	;;^DD(115.011,20,21,0)
	;;=^^3^3^2900411^^
	;;^DD(115.011,20,21,1,0)
	;;=This field is used to store the a free-text description of the
	;;^DD(115.011,20,21,2,0)
	;;=appearance of the patient when such notation may be of importance
	;;^DD(115.011,20,21,3,0)
	;;=in understanding or treating the patient.
	;;^DD(115.011,20,"DT")
	;;=2900411
	;;^DD(115.011,21,0)
	;;=BODY MASS INDEX^NJ4,1^^0;21^K:+X'=X!(X>50)!(X<10)!(X?.E1"."2N.N) X
	;;^DD(115.011,21,3)
	;;=Type a Number between 10 and 50, 1 Decimal Digit
	;;^DD(115.011,21,21,0)
	;;=^^2^2^2900404^
	;;^DD(115.011,21,21,1,0)
	;;=This field contains the Body Mass Index calculated from the
	;;^DD(115.011,21,21,2,0)
	;;=height and weight.
	;;^DD(115.011,21,"DT")
	;;=2900404
	;;^DD(115.011,22,0)
	;;=BODY MASS INDEX %^NJ2,0^^0;22^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,22,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,22,21,0)
	;;=^^2^2^2910506^^
	;;^DD(115.011,22,21,1,0)
	;;=This field contains the percentile rank of the Body Mass Index
	;;^DD(115.011,22,21,2,0)
	;;=value.
	;;^DD(115.011,22,"DT")
	;;=2900404
	;;^DD(115.011,23,0)
	;;=NITROGEN BALANCE^NJ2,0^^0;25^K:+X'=X!(X>99)!(X<-99)!(X?.E1"."1N.N) X
	;;^DD(115.011,23,3)
	;;=Type a Number between -99 and 99, 0 Decimal Digits
	;;^DD(115.011,23,21,0)
	;;=^^2^2^2900625^
	;;^DD(115.011,23,21,1,0)
	;;=This field contains the value of the Nitrogen Balance calculated
	;;^DD(115.011,23,21,2,0)
	;;=during the assessment.
	;;^DD(115.011,23,"DT")
	;;=2900622
	;;^DD(115.011,40,0)
	;;=TRICEPS SKIN FOLD (MM)^NJ3,0^^1;1^K:+X'=X!(X>100)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,40,3)
	;;=Type a Number between 1 and 100, 0 Decimal Digits
	;;^DD(115.011,40,21,0)
	;;=^^1^1^2900411^^^
	;;^DD(115.011,40,21,1,0)
	;;=This is the triceps skin fold measurement in mm.
	;;^DD(115.011,40,"DT")
	;;=2900411
	;;^DD(115.011,41,0)
	;;=TRICEPS %^NJ2,0^^1;2^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,41,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,41,21,0)
	;;=^^1^1^2900411^^^
	;;^DD(115.011,41,21,1,0)
	;;=This is the percentile rank of the triceps skin fold measurement.
	;;^DD(115.011,41,"DT")
	;;=2900411
	;;^DD(115.011,42,0)
	;;=SUBSCAPULAR SKINFOLD (MM)^NJ3,0^^1;3^K:+X'=X!(X>100)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,42,3)
	;;=Type a Number between 1 and 100, 0 Decimal Digits
	;;^DD(115.011,42,21,0)
	;;=1^^1^1^2900411^
	;;^DD(115.011,42,21,1,0)
	;;=This is the subscapular skin fold measurement in mm.
	;;^DD(115.011,42,"DT")
	;;=2900411
	;;^DD(115.011,43,0)
	;;=SUBSCAPULAR %^NJ2,0^^1;4^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,43,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,43,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,43,21,1,0)
	;;=This is the percentile rank of the subscapular skin fold measurement.
	;;^DD(115.011,43,"DT")
	;;=2900411
	;;^DD(115.011,44,0)
	;;=ARM CIRCUMFERENCE (CM)^NJ5,1^^1;5^K:+X'=X!(X>100)!(X<5)!(X?.E1"."2N.N) X
	;;^DD(115.011,44,3)
	;;=Type a Number between 5 and 100, 1 Decimal Digit
	;;^DD(115.011,44,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.011,44,21,1,0)
	;;=This is the arm circumference in cm.
	;;^DD(115.011,44,"DT")
	;;=2891107
	;;^DD(115.011,45,0)
	;;=ARM CIRCUMFERENCE %^NJ2,0^^1;6^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,45,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,45,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,45,21,1,0)
	;;=This is the percentile rank of the arm circumference.
	;;^DD(115.011,45,"DT")
	;;=2900411
	;;^DD(115.011,46,0)
	;;=CALF CIRCUMFERENCE (CM)^NJ5,1^^1;7^K:+X'=X!(X>250)!(X<10)!(X?.E1"."2N.N) X
	;;^DD(115.011,46,3)
	;;=Type a Number between 10 and 250, 1 Decimal Digit
	;;^DD(115.011,46,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.011,46,21,1,0)
	;;=This is the calf circumference in cm.
	;;^DD(115.011,46,"DT")
	;;=2891107
	;;^DD(115.011,47,0)
	;;=CALF CIRCUMFERENCE %^NJ2,0^^1;8^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,47,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,47,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,47,21,1,0)
	;;=This is the percentile rank of the calf circumference.
	;;^DD(115.011,47,"DT")
	;;=2900411
	;;^DD(115.011,48,0)
	;;=BONE-FREE AMA  (CM2)^NJ5,1^^1;9^K:+X'=X!(X>100)!(X<5)!(X?.E1"."2N.N) X
	;;^DD(115.011,48,3)
	;;=Type a Number between 5 and 100, 1 Decimal Digit
