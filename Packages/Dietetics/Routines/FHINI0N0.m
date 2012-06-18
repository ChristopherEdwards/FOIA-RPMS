FHINI0N0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.8,7,21,2,0)
	;;=the From-To Ward and Bed.
	;;^DD(119.8,7,"DT")
	;;=2920704
	;;^DD(119.8,8,0)
	;;=ENTERED CLERK^RP200'^VA(200,^0;9^Q
	;;^DD(119.8,8,21,0)
	;;=^^2^2^2950317^
	;;^DD(119.8,8,21,1,0)
	;;=This field contains the user who entered the order and is
	;;^DD(119.8,8,21,2,0)
	;;=automatically captured at the time of entry.
	;;^DD(119.8,8,"DT")
	;;=2950317
