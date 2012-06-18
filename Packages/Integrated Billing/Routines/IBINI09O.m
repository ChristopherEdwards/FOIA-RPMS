IBINI09O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(362.3,.02,1,3,1.4)
	;;=S DIH=$S($D(^IBA(362.3,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=362.3,DIG=.03 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(362.3,.02,1,3,2)
	;;=Q
	;;^DD(362.3,.02,1,3,"%D",0)
	;;=^^1^1^2940112^
	;;^DD(362.3,.02,1,3,"%D",1,0)
	;;=Sets default value for print order.
	;;^DD(362.3,.02,1,3,"CREATE CONDITION")
	;;=ORDER=""
	;;^DD(362.3,.02,1,3,"CREATE VALUE")
	;;=S X=$$ORDNXT^IBCU1(+X)
	;;^DD(362.3,.02,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(362.3,.02,1,3,"DT")
	;;=2940112
	;;^DD(362.3,.02,1,3,"FIELD")
	;;=ORDER
	;;^DD(362.3,.02,3)
	;;=The bill that this diagnosis is related to.
	;;^DD(362.3,.02,12)
	;;=Diagnosis can only be added to open bills.
	;;^DD(362.3,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,13)<3"
	;;^DD(362.3,.02,"DT")
	;;=2940112
	;;^DD(362.3,.03,0)
	;;=ORDER^NJ3,0X^^0;3^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N)!($$DXBSTAT^IBCU1(DA)>2)!($$ORDDUP^IBCU1(+X,DA)) X
	;;^DD(362.3,.03,1,0)
	;;=^.1
	;;^DD(362.3,.03,1,1,0)
	;;=362.3^AO1^MUMPS
	;;^DD(362.3,.03,1,1,1)
	;;=S:+$P(^IBA(362.3,DA,0),U,2) ^IBA(362.3,"AO",+$P(^(0),U,2),+X,DA)=""
	;;^DD(362.3,.03,1,1,2)
	;;=K:+$P(^IBA(362.3,DA,0),U,2) ^IBA(362.3,"AO",+$P(^(0),U,2),+X,DA)
	;;^DD(362.3,.03,1,1,"%D",0)
	;;=^^1^1^2931117^
	;;^DD(362.3,.03,1,1,"%D",1,0)
	;;=Print order by bill, used to prevent duplicate print orders for a bill.
	;;^DD(362.3,.03,1,1,"DT")
	;;=2931117
	;;^DD(362.3,.03,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits.  This is the order that the diagnoses will be printed on a bill.  Each number must be unique for a bill.
	;;^DD(362.3,.03,4)
	;;=D HELP^IBCSC4D
	;;^DD(362.3,.03,5,1,0)
	;;=362.3^.02^3
	;;^DD(362.3,.03,"DT")
	;;=2931123
