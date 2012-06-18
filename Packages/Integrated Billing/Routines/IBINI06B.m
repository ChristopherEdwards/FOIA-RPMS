IBINI06B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.214,0)
	;;=APPROVE ON APPEAL FROM SUB-FIELD^^.02^2
	;;^DD(356.214,0,"DT")
	;;=2930825
	;;^DD(356.214,0,"IX","B",356.214,.01)
	;;=
	;;^DD(356.214,0,"NM","APPROVE ON APPEAL FROM")
	;;=
	;;^DD(356.214,0,"UP")
	;;=356.2
	;;^DD(356.214,.01,0)
	;;=APPROVE ON APPEAL FROM^MD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.214,.01,1,0)
	;;=^.1
	;;^DD(356.214,.01,1,1,0)
	;;=356.214^B
	;;^DD(356.214,.01,1,1,1)
	;;=S ^IBT(356.2,DA(1),14,"B",$E(X,1,30),DA)=""
	;;^DD(356.214,.01,1,1,2)
	;;=K ^IBT(356.2,DA(1),14,"B",$E(X,1,30),DA)
	;;^DD(356.214,.01,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(356.214,.01,21,1,0)
	;;=Enter the dates that were approved for payment after an appeal.  If the
	;;^DD(356.214,.01,21,2,0)
	;;=appeal was partially or fully approved enter the dates that this appeal
	;;^DD(356.214,.01,21,3,0)
	;;=was approved from.
	;;^DD(356.214,.01,"DT")
	;;=2930825
	;;^DD(356.214,.02,0)
	;;=APPROVE ON APPEAL TO^D^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.214,.02,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(356.214,.02,21,1,0)
	;;=Enter the dates that were approved for payment after an appeal.  If the
	;;^DD(356.214,.02,21,2,0)
	;;=appeal was partially or fully approved enter the dates that this appeal
	;;^DD(356.214,.02,21,3,0)
	;;=was approved to.
	;;^DD(356.214,.02,"DT")
	;;=2930825
