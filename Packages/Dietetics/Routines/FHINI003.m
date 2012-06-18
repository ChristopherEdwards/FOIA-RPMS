FHINI003	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(111)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,111)
	;;=^FH(111,
	;;^UTILITY(U,$J,111,0)
	;;=DIETS^111sI^1^1
	;;^UTILITY(U,$J,111,1,0)
	;;=REGULAR^^^20^1^^REGULAR
