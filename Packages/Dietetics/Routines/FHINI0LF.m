FHINI0LF	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117,34,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,34,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,34,21,1,0)
	;;=This field contains the number of noon meals served
	;;^DD(117,34,21,2,0)
	;;=under contract on the census date.
	;;^DD(117,35,0)
	;;=CONTRACT EVENING^NJ4,0^^1;6^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,35,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,35,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,35,21,1,0)
	;;=This field contains the number of evening meals served
	;;^DD(117,35,21,2,0)
	;;=under contract on the census date.
	;;^DD(117,36,0)
	;;=OTHER PAID BREAK^NJ4,0^^1;7^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,36,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,36,21,0)
	;;=^^2^2^2880716^^
	;;^DD(117,36,21,1,0)
	;;=This field contains the number of breakfast meals served
	;;^DD(117,36,21,2,0)
	;;=to other paid individuals on the census date.
	;;^DD(117,37,0)
	;;=OTHER PAID NOON^NJ4,0^^1;8^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,37,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,37,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,37,21,1,0)
	;;=This field contains the number of noon meals served
	;;^DD(117,37,21,2,0)
	;;=to other paid individuals on the census date.
	;;^DD(117,38,0)
	;;=OTHER PAID EVENING^NJ4,0^^1;9^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,38,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,38,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,38,21,1,0)
	;;=This field contains the number of evening meals served
	;;^DD(117,38,21,2,0)
	;;=to other paid individuals on the census date.
	;;^DD(117,39,0)
	;;=OOD BREAK^NJ4,0^^1;10^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,39,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,39,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,39,21,1,0)
	;;=This field contains the number of breakfast meals served
	;;^DD(117,39,21,2,0)
	;;=to OOD personnel on the census date.
	;;^DD(117,40,0)
	;;=OOD NOON^NJ4,0^^1;11^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,40,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,40,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,40,21,1,0)
	;;=This field contains the number of noon meals served
	;;^DD(117,40,21,2,0)
	;;=to OOD personnel on the census date.
	;;^DD(117,41,0)
	;;=OOD EVENING^NJ4,0^^1;12^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,41,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,41,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,41,21,1,0)
	;;=This field contains the number of evening meals served
	;;^DD(117,41,21,2,0)
	;;=to OOD personnel on the census date.
	;;^DD(117,42,0)
	;;=VOLUNTEER BREAK^NJ4,0^^1;13^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,42,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,42,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,42,21,1,0)
	;;=This field contains the number of breakfast meals served to
	;;^DD(117,42,21,2,0)
	;;=volunteers on the census date.
	;;^DD(117,43,0)
	;;=VOLUNTEER NOON^NJ4,0^^1;14^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,43,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,43,21,0)
	;;=^^2^2^2910612^^
	;;^DD(117,43,21,1,0)
	;;=This field contains the number of noon meals served to
	;;^DD(117,43,21,2,0)
	;;=volunteers on the census date.
	;;^DD(117,44,0)
	;;=VOLUNTEER EVENING^NJ4,0^^1;15^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,44,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,44,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,44,21,1,0)
	;;=This field contains the number of evening meals served to
	;;^DD(117,44,21,2,0)
	;;=volunteers on the census date.
	;;^DD(117,45,0)
	;;=GRAT OTHER BREAK^NJ4,0^^1;16^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,45,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,45,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,45,21,1,0)
	;;=This field contains the number of breakfast meals served
	;;^DD(117,45,21,2,0)
	;;=gratuitously to others on the census date.
	;;^DD(117,46,0)
	;;=GRAT OTHER NOON^NJ4,0^^1;17^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,46,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,46,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,46,21,1,0)
	;;=This field contains the number of noon meals served
	;;^DD(117,46,21,2,0)
	;;=gratuitously to others on the census date.
	;;^DD(117,47,0)
	;;=GRAT OTHER EVENING^NJ4,0^^1;18^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,47,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,47,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,47,21,1,0)
	;;=This field contains the number of evening meals served
	;;^DD(117,47,21,2,0)
	;;=gratuitously to others on the census date.
	;;^DD(117,50,0)
	;;=CAFETERIA MEALS^NJ4,0^^1;19^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
