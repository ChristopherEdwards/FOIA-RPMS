IBINI09C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.6,2.03,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.03,21,0)
	;;=^^3^3^2930528^
	;;^DD(358.6,2.03,21,1,0)
	;;= 
	;;^DD(358.6,2.03,21,2,0)
	;;=A descriptive name of the second field of the record returned by the
	;;^DD(358.6,2.03,21,3,0)
	;;=interface routine.
	;;^DD(358.6,2.03,"DT")
	;;=2930726
	;;^DD(358.6,2.04,0)
	;;=WHAT IS ITS MAXIMUM LENGTH?^NJ3,0^^2;4^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.04,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(358.6,2.04,21,0)
	;;=^^3^3^2930528^
	;;^DD(358.6,2.04,21,1,0)
	;;= 
	;;^DD(358.6,2.04,21,2,0)
	;;=The maximum length of the second field of the record returned by the
	;;^DD(358.6,2.04,21,3,0)
	;;=interface routine.
	;;^DD(358.6,2.04,"DT")
	;;=2930726
	;;^DD(358.6,2.05,0)
	;;=PIECE 3 DESCRIPTIVE NAME^F^^2;5^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.05,.1)
	;;=WHAT IS THE THIRD PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(358.6,2.05,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.05,21,0)
	;;=^^3^3^2930528^
	;;^DD(358.6,2.05,21,1,0)
	;;= 
	;;^DD(358.6,2.05,21,2,0)
	;;=A descriptive name of the third field of the record returned by the
	;;^DD(358.6,2.05,21,3,0)
	;;=interface routine.
	;;^DD(358.6,2.05,"DT")
	;;=2930726
	;;^DD(358.6,2.06,0)
	;;=PIECE 3 MAXIMUM LENGTH^NJ3,0^^2;6^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.06,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.06,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(358.6,2.06,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.06,21,1,0)
	;;= 
	;;^DD(358.6,2.06,21,2,0)
	;;=The maximum length of the 3rd field returned by the interface routine.
	;;^DD(358.6,2.06,"DT")
	;;=2930726
	;;^DD(358.6,2.07,0)
	;;=PIECE 4 DESCRIPTIVE NAME^F^^2;7^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.07,.1)
	;;=WHAT IS THE FOURTH PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(358.6,2.07,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.07,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.07,21,1,0)
	;;= 
	;;^DD(358.6,2.07,21,2,0)
	;;=A descriptive name of the 4th field returned by the interface routine.
	;;^DD(358.6,2.07,"DT")
	;;=2930726
	;;^DD(358.6,2.08,0)
	;;=PIECE 4 MAXIMUM LENGTH^NJ3,0^^2;8^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.08,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.08,3)
	;;=Type a Number between 1 and 200, 0 Decimal Digits
	;;^DD(358.6,2.08,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.08,21,1,0)
	;;= 
	;;^DD(358.6,2.08,21,2,0)
	;;=The maximum length of the 4th field returned by the interface routine.
	;;^DD(358.6,2.08,"DT")
	;;=2930726
	;;^DD(358.6,2.09,0)
	;;=PIECE 5 DESCRIPTIVE NAME^F^^2;9^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.09,.1)
	;;=WHAT IS THE FIFTH PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(358.6,2.09,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.09,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.09,21,1,0)
	;;= 
	;;^DD(358.6,2.09,21,2,0)
	;;=A descriptive name of the 5th field returned by the interface routine.
	;;^DD(358.6,2.09,"DT")
	;;=2930726
	;;^DD(358.6,2.1,0)
	;;=PIECE 5 MAXIMUM LENGTH^NJ3,0^^2;10^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.1,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.1,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(358.6,2.1,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.1,21,1,0)
	;;= 
	;;^DD(358.6,2.1,21,2,0)
	;;=The maximum length of the 5th field returned by the interface routine.
	;;^DD(358.6,2.1,"DT")
	;;=2930726
	;;^DD(358.6,2.11,0)
	;;=PIECE 6 DESCRIPTIVE NAME^F^^2;11^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.11,.1)
	;;=WHAT IS THE SIXTH PIECE OF DATA RETURNED BY THE INTERFACE?
