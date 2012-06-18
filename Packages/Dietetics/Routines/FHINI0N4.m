FHINI0N4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(119.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,119.9)
	;;=^FH(119.9,
	;;^UTILITY(U,$J,119.9,0)
	;;=FH SITE PARAMETERS^119.9^1^1
	;;^UTILITY(U,$J,119.9,1,0)
	;;=1^^^^8:00A^^12:00P^^6:00P^N^^^^^^^^^1^Y^Y^^Y
