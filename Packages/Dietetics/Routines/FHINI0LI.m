FHINI0LI	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.1,9,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,10,0)
	;;=INTERMITTENT HOURS^NJ6,2^^0;11^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,10,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,10,21,0)
	;;=^^2^2^2921124^^
	;;^DD(117.1,10,21,1,0)
	;;=This field contains the number of intermittent hours worked by
	;;^DD(117.1,10,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,11,0)
	;;=COP HOURS^NJ6,2^^0;12^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,11,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,11,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,11,21,1,0)
	;;=This field contains the number of Continuation-of-Pay hours by
	;;^DD(117.1,11,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,12,0)
	;;=ANNUAL LEAVE HOURS^NJ6,2^^0;13^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,12,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,12,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,12,21,1,0)
	;;=This field contains the number of hours of annual leave taken
	;;^DD(117.1,12,21,2,0)
	;;=by measured personnel.
	;;^DD(117.1,13,0)
	;;=SICK LEAVE HOURS^NJ6,2^^0;14^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,13,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,13,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,13,21,1,0)
	;;=This field contains the number of hours of sick leave taken by
	;;^DD(117.1,13,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,14,0)
	;;=OTHER LEAVE HOURS^NJ6,2^^0;15^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,14,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,14,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,14,21,1,0)
	;;=This field contains the number of hours of other types of leave
	;;^DD(117.1,14,21,2,0)
	;;=taken by measured personnel.
	;;^DD(117.1,15,0)
	;;=LOANED/UNION HOURS^NJ6,2^^0;16^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,15,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,15,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,15,21,1,0)
	;;=This field contains the number of hours worked in other services,
	;;^DD(117.1,15,21,2,0)
	;;=or on union affairs, by measured personnel.
	;;^DD(117.1,16,0)
	;;=COMP. HOURS^NJ6,2^^0;17^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,16,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,16,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,16,21,1,0)
	;;=This field contains the number of compensatory hours worked by
	;;^DD(117.1,16,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,17,0)
	;;=TRAINEE HOURS^NJ6,2^^0;18^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,17,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,17,21,0)
	;;=^^1^1^2891120^
	;;^DD(117.1,17,21,1,0)
	;;=This field contains the number of hours worked by trainees.
	;;^DD(117.1,18,0)
	;;=VOLUNTEER HOURS^NJ6,2^^0;19^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,18,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,18,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,18,21,1,0)
	;;=This field contains the number of hours worked by uncompensated
	;;^DD(117.1,18,21,2,0)
	;;=volunteers.
	;;^DD(117.1,19,0)
	;;=BORROWED HOURS^NJ6,2^^0;20^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,19,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,19,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,19,21,1,0)
	;;=This field contains the number of hours worked by employees borrowed
	;;^DD(117.1,19,21,2,0)
	;;=from other Services.
