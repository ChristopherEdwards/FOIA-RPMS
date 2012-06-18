FHINI0MU	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.72)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.722,5,21,0)
	;;=^^2^2^2920108^
	;;^DD(119.722,5,21,1,0)
	;;=This is the date on which the last forecast was made for this
	;;^DD(119.722,5,21,2,0)
	;;=census date.
	;;^DD(119.722,5,"DT")
	;;=2920108
