IBINI085	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,.11,21,4,0)
	;;=field #.1 is coded YES.
	;;^DD(357.6,.11,"DT")
	;;=2930617
	;;^DD(357.6,.12,0)
	;;=TOOL KIT MEMBER?^S^0:NO;1:YES;^0;12^Q
	;;^DD(357.6,.12,.1)
	;;=SHOULD THIS PACKAGE INTERFACE BE PART OF THE TOOL KIT?
	;;^DD(357.6,.12,3)
	;;=Enter YES if this PACKAGE INTERFACE was added by the package developers as part of the tool kit, enter NO otherwise.
	;;^DD(357.6,.12,21,0)
	;;=^^3^3^2940224^
	;;^DD(357.6,.12,21,1,0)
	;;= 
	;;^DD(357.6,.12,21,2,0)
	;;=Package Interfaces that are developed for national use will be documented
	;;^DD(357.6,.12,21,3,0)
	;;=as being part of the tool kit.
	;;^DD(357.6,.12,"DT")
	;;=2930811
	;;^DD(357.6,1,0)
	;;=DESCRIPTION^357.61^^1;0
	;;^DD(357.6,1,21,0)
	;;=^^1^1^2930210^^^
	;;^DD(357.6,1,21,1,0)
	;;=Should describe the data being exchanged by the package interface.
	;;^DD(357.6,2.01,0)
	;;=PIECE 1 DESCRIPTIVE NAME^F^^2;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(357.6,2.01,.1)
	;;=WHAT IS THE FIRST PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(357.6,2.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(357.6,2.01,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.6,2.01,21,1,0)
	;;= 
	;;^DD(357.6,2.01,21,2,0)
	;;=Should be a descriptive name of the first field in the record returned by
	;;^DD(357.6,2.01,21,3,0)
	;;=the interface.
	;;^DD(357.6,2.01,"DT")
	;;=2930726
	;;^DD(357.6,2.02,0)
	;;=PIECE 1 MAXIMUM LENGTH^NJ3,0^^2;2^K:+X'=X!(X>210)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.6,2.02,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(357.6,2.02,3)
	;;=Type a Number between 0 and 210, 0 Decimal Digits
	;;^DD(357.6,2.02,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.6,2.02,21,1,0)
	;;= 
	;;^DD(357.6,2.02,21,2,0)
	;;=The maximum length of the first field of the record returned by the
	;;^DD(357.6,2.02,21,3,0)
	;;=interface.
	;;^DD(357.6,2.02,"DT")
	;;=2930726
	;;^DD(357.6,2.03,0)
	;;=PIECE 2 DESCRIPTIVE NAME^F^^2;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(357.6,2.03,.1)
	;;=WHAT IS THE SECOND PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(357.6,2.03,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(357.6,2.03,21,0)
	;;=^^3^3^2930528^
	;;^DD(357.6,2.03,21,1,0)
	;;= 
	;;^DD(357.6,2.03,21,2,0)
	;;=A descriptive name of the second field of the record returned by the
	;;^DD(357.6,2.03,21,3,0)
	;;=interface routine.
	;;^DD(357.6,2.03,"DT")
	;;=2930726
	;;^DD(357.6,2.04,0)
	;;=WHAT IS ITS MAXIMUM LENGTH?^NJ3,0^^2;4^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.6,2.04,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(357.6,2.04,21,0)
	;;=^^3^3^2930528^
	;;^DD(357.6,2.04,21,1,0)
	;;= 
	;;^DD(357.6,2.04,21,2,0)
	;;=The maximum length of the second field of the record returned by the
	;;^DD(357.6,2.04,21,3,0)
	;;=interface routine.
	;;^DD(357.6,2.04,"DT")
	;;=2930726
	;;^DD(357.6,2.05,0)
	;;=PIECE 3 DESCRIPTIVE NAME^F^^2;5^K:$L(X)>30!($L(X)<3) X
	;;^DD(357.6,2.05,.1)
	;;=WHAT IS THE THIRD PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(357.6,2.05,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(357.6,2.05,21,0)
	;;=^^3^3^2930528^
	;;^DD(357.6,2.05,21,1,0)
	;;= 
	;;^DD(357.6,2.05,21,2,0)
	;;=A descriptive name of the third field of the record returned by the
	;;^DD(357.6,2.05,21,3,0)
	;;=interface routine.
	;;^DD(357.6,2.05,"DT")
	;;=2930726
	;;^DD(357.6,2.06,0)
	;;=PIECE 3 MAXIMUM LENGTH^NJ3,0^^2;6^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.6,2.06,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(357.6,2.06,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(357.6,2.06,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.6,2.06,21,1,0)
	;;= 
	;;^DD(357.6,2.06,21,2,0)
	;;=The maximum length of the 3rd field returned by the interface routine.
