FHINI0MR	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.72)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.721,10,21,1,0)
	;;=This is the number of additional Sunday breakfast meals which are
	;;^DD(119.721,10,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,10,"DT")
	;;=2861126
	;;^DD(119.721,11,0)
	;;=ADD. SUNDAY NOON^NJ4,0^^0;3^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,11,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,11,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.721,11,21,1,0)
	;;=This is the number of additional Sunday noon meals which are
	;;^DD(119.721,11,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,11,"DT")
	;;=2861126
	;;^DD(119.721,12,0)
	;;=ADD. SUNDAY EVENING^NJ4,0^^0;4^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,12,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,12,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,12,21,1,0)
	;;=This is the number of additional Sunday evening meals which are
	;;^DD(119.721,12,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,12,"DT")
	;;=2861126
	;;^DD(119.721,13,0)
	;;=ADD. MONDAY BREAKFAST^NJ4,0^^0;5^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,13,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,13,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,13,21,1,0)
	;;=This is the number of additional Monday breakfast meals which are
	;;^DD(119.721,13,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,13,"DT")
	;;=2861126
	;;^DD(119.721,14,0)
	;;=ADD. MONDAY NOON^NJ4,0^^0;6^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,14,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,14,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,14,21,1,0)
	;;=This is the number of additional Monday noon meals which are
	;;^DD(119.721,14,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,14,"DT")
	;;=2861126
	;;^DD(119.721,15,0)
	;;=ADD. MONDAY EVENING^NJ4,0^^0;7^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,15,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,15,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,15,21,1,0)
	;;=This is the number of additional Monday evening meals which are
	;;^DD(119.721,15,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,15,"DT")
	;;=2861126
	;;^DD(119.721,16,0)
	;;=ADD. TUESDAY BREAKFAST^NJ4,0^^0;8^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,16,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,16,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,16,21,1,0)
	;;=This is the number of additional Tuesday breakfast meals which are
	;;^DD(119.721,16,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,16,"DT")
	;;=2861126
	;;^DD(119.721,17,0)
	;;=ADD. TUESDAY NOON^NJ4,0^^0;9^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,17,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,17,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,17,21,1,0)
	;;=This is the number of additional Tuesday noon meals which are
	;;^DD(119.721,17,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,17,"DT")
	;;=2861126
	;;^DD(119.721,18,0)
	;;=ADD. TUESDAY EVENING^NJ4,0^^0;10^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,18,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,18,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,18,21,1,0)
	;;=This is the number of additional Tuesday evening meals which are
	;;^DD(119.721,18,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,18,"DT")
	;;=2861126
	;;^DD(119.721,19,0)
	;;=ADD. WEDNESDAY BREAKFAST^NJ4,0^^0;11^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,19,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,19,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,19,21,1,0)
	;;=This is the number of additional Wednesday breakfast meals which are
	;;^DD(119.721,19,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,19,"DT")
	;;=2861126
	;;^DD(119.721,20,0)
	;;=ADD. WEDNESDAY NOON^NJ4,0^^0;12^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,20,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,20,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,20,21,1,0)
	;;=This is the number of additional Wednesday noon meals which are
	;;^DD(119.721,20,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,21,0)
	;;=ADD. WEDNESDAY EVENING^NJ4,0^^0;13^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,21,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,21,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,21,21,1,0)
	;;=This is the number of additional Wednesday evening meals which are
	;;^DD(119.721,21,21,2,0)
	;;=to be added to the inpatient forecast.
