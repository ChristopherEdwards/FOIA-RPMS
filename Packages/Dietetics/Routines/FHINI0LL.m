FHINI0LL	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.2,24,21,0)
	;;=^^1^1^2950217^^^
	;;^DD(117.2,24,21,1,0)
	;;=The % Cost Recommended for Food Group VI.
	;;^DD(117.2,24,"DT")
	;;=2910506
