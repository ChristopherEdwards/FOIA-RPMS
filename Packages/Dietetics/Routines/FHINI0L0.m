FHINI0L0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(115.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,115.4)
	;;=^FH(115.4,
	;;^UTILITY(U,$J,115.4,0)
	;;=NUTRITION STATUS^115.4I^4^4
	;;^UTILITY(U,$J,115.4,1,0)
	;;=I^Normal^NORMAL^30
	;;^UTILITY(U,$J,115.4,2,0)
	;;=II^Mildly Compromised^MILDLY COMPROMISED^30
	;;^UTILITY(U,$J,115.4,3,0)
	;;=III^Moderately Compromised^MODERATELY COMPROMISED^30
	;;^UTILITY(U,$J,115.4,4,0)
	;;=IV^Severely Compromised^SEVERELY COMPROMISED^3
