FHINI0LG	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117,50,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,50,21,0)
	;;=^^2^2^2900325^
	;;^DD(117,50,21,1,0)
	;;=This field contains the number of cafeteria meals served
	;;^DD(117,50,21,2,0)
	;;=on the census date.
	;;^DD(117,50,"DT")
	;;=2900325
	;;^DD(117,51,0)
	;;=NPO MEALS^NJ4,0^^1;20^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,51,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,51,21,0)
	;;=^^2^2^2910625^^
	;;^DD(117,51,21,1,0)
	;;=This field contains the number of NPO meals for the
	;;^DD(117,51,21,2,0)
	;;=census date.
	;;^DD(117,51,"DT")
	;;=2900325
	;;^DD(117,52,0)
	;;=# PATIENTS STATUS I^NJ4,0^^1;21^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,52,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,52,21,0)
	;;=^^2^2^2911204^
	;;^DD(117,52,21,1,0)
	;;=This field represents the number of patients for which the Nutrition
	;;^DD(117,52,21,2,0)
	;;=Status was I on the given date.
	;;^DD(117,52,"DT")
	;;=2910610
	;;^DD(117,53,0)
	;;=# PATIENTS STATUS II^NJ4,0^^1;22^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,53,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,53,21,0)
	;;=^^2^2^2911204^
	;;^DD(117,53,21,1,0)
	;;=This field represents the number of patients for which the Nutrition
	;;^DD(117,53,21,2,0)
	;;=Status was II on the given date.
	;;^DD(117,54,0)
	;;=# PATIENTS STATUS III^NJ4,0^^1;23^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,54,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,54,21,0)
	;;=^^2^2^2911204^^
	;;^DD(117,54,21,1,0)
	;;=This field represents the number of patients for which the Nutrition
	;;^DD(117,54,21,2,0)
	;;=Status was III on the given date.
	;;^DD(117,55,0)
	;;=# PATIENTS STATUS IV^NJ4,0^^1;24^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,55,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,55,21,0)
	;;=^^2^2^2911204^
	;;^DD(117,55,21,1,0)
	;;=This field represents the number of patients for which the Nutrition
	;;^DD(117,55,21,2,0)
	;;=Status was IV on the given date.
	;;^DD(117,56,0)
	;;=# PATIENTS STATUS UNC^NJ4,0^^1;25^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,56,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117,56,21,0)
	;;=^^2^2^2911204^
	;;^DD(117,56,21,1,0)
	;;=This field represents the number of patients for which the Nutrition
	;;^DD(117,56,21,2,0)
	;;=Status was not available, or invalid, on the given date.
	;;^DD(117,57,0)
	;;=# DAILY MODIFIED DIETS^NJ9,0^^1;26^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,57,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(117,57,21,0)
	;;=^^2^2^2930908^^^^
	;;^DD(117,57,21,1,0)
	;;=This is the number of modified (non-regular) diets served. It
	;;^DD(117,57,21,2,0)
	;;=also includes NPOs and Passes.
	;;^DD(117,57,"DT")
	;;=2920304
	;;^DD(117,58,0)
	;;=# OF TOTAL DIETS^NJ10,0^^1;27^K:+X'=X!(X>9999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,58,3)
	;;=Type a Number between 0 and 9999999999, 0 Decimal Digits
	;;^DD(117,58,21,0)
	;;=^^1^1^2930908^^
	;;^DD(117,58,21,1,0)
	;;=This field contains the number of total Diets.
	;;^DD(117,58,"DT")
	;;=2920618
