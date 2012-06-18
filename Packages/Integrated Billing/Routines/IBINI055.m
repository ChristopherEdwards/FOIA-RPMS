IBINI055	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.5,1.07,21,2,0)
	;;=verified insurance claims information.
	;;^DD(355.5,1.07,"DT")
	;;=2930702
	;;^DD(355.5,1.08,0)
	;;=COMMENT - CLAIMS FILED^F^^1;8^K:$L(X)>80!($L(X)<3) X
	;;^DD(355.5,1.08,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(355.5,1.08,21,0)
	;;=^^1^1^2930713^
	;;^DD(355.5,1.08,21,1,0)
	;;=Enter any pertinent information here that you did not enter above.
	;;^DD(355.5,1.08,"DT")
	;;=2930611
	;;^DD(355.5,1.09,0)
	;;=CONTACT'S PHONE NUMBER^RF^^1;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(355.5,1.09,.1)
	;;=WHAT WAS THEIR PHONE NUMBER?
	;;^DD(355.5,1.09,3)
	;;=Answer must be 7-20 characters in length.
	;;^DD(355.5,1.09,21,0)
	;;=^^2^2^2930702^^
	;;^DD(355.5,1.09,21,1,0)
	;;=Give the telephone number of the person who verified insurance
	;;^DD(355.5,1.09,21,2,0)
	;;=claims information.
	;;^DD(355.5,1.09,"DT")
	;;=2930702
