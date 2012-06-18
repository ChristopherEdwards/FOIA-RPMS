IBINI0AE	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,111,1,2,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399,111,1,2,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399,111,3)
	;;=Enter name of the institution or organization responsible for payment of this bill.
	;;^DD(399,111,21,0)
	;;=^^2^2^2940114^^^
	;;^DD(399,111,21,1,0)
	;;=This is the name of the institution or organization responsible for payment
	;;^DD(399,111,21,2,0)
	;;=of this bill.
	;;^DD(399,111,"DT")
	;;=2900515
	;;^DD(399,112,0)
	;;=PRIMARY INSURANCE POLICY^FXO^^M;12^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<1) X D:$D(X) DD^IBCNS2(X,DA,1)
	;;^DD(399,112,1,0)
	;;=^.1
	;;^DD(399,112,1,1,0)
	;;=^^TRIGGER^399^101
	;;^DD(399,112,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y X ^DD(399,112,1,1,1.1) X ^DD(399,112,1,1,1.4)
	;;^DD(399,112,1,1,1.1)
	;;=S X=DIV S X=+$$INSCO^IBCNS2(DA,$P(^DGCR(399,DA,"M"),U,12))
	;;^DD(399,112,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,1)=DIV,DIH=399,DIG=101 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,112,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" X ^DD(399,112,1,1,2.4)
	;;^DD(399,112,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,1)=DIV,DIH=399,DIG=101 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,112,1,1,"CREATE VALUE")
	;;=S X=+$$INSCO^IBCNS2(DA,$P(^DGCR(399,DA,"M"),U,12))
	;;^DD(399,112,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399,112,1,1,"FIELD")
	;;=#101
	;;^DD(399,112,1,2,0)
	;;=399^AI11^MUMPS
	;;^DD(399,112,1,2,1)
	;;=D IX^IBCNS2(DA,"I1")
	;;^DD(399,112,1,2,2)
	;;=D KIX^IBCNS2(DA,"I1")
	;;^DD(399,112,1,2,"%D",0)
	;;=^^2^2^2931220^^
	;;^DD(399,112,1,2,"%D",1,0)
	;;=Sets "I1" x-ref and "aic" x-ref for bill/claims file.  These indexes 
	;;^DD(399,112,1,2,"%D",2,0)
	;;=previously were set by field #101.
	;;^DD(399,112,1,2,"DT")
	;;=2931220
	;;^DD(399,112,2)
	;;=S Y(0)=Y S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,112,2.1)
	;;=S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,112,3)
	;;=Select this patient's insurance policy that is the primary policy to be billed.  Enter the name of the Ins. Company or the number.
	;;^DD(399,112,4)
	;;=D DDHELP^IBCNS2(DA,1)
	;;^DD(399,112,5,1,0)
	;;=399^.11^1
	;;^DD(399,112,21,0)
	;;=^^1^1^2940214^^^
	;;^DD(399,112,21,1,0)
	;;=The policy to be billed for this episode of care.
	;;^DD(399,112,"DT")
	;;=2931220
	;;^DD(399,113,0)
	;;=SECONDARY INSURANCE POLICY^FOX^^M;13^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>4!($L(X)<1) X D:$D(X) DD^IBCNS2(X,DA,1)
	;;^DD(399,113,1,0)
	;;=^.1
	;;^DD(399,113,1,1,0)
	;;=^^TRIGGER^399^102
	;;^DD(399,113,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y X ^DD(399,113,1,1,1.1) X ^DD(399,113,1,1,1.4)
	;;^DD(399,113,1,1,1.1)
	;;=S X=DIV S X=+$$INSCO^IBCNS2(DA,+$P(^DGCR(399,DA,"M"),U,13))
	;;^DD(399,113,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,2)=DIV,DIH=399,DIG=102 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,113,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,113,1,1,2.4)
	;;^DD(399,113,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,2)=DIV,DIH=399,DIG=102 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,113,1,1,"CREATE VALUE")
	;;=S X=+$$INSCO^IBCNS2(DA,+$P(^DGCR(399,DA,"M"),U,13))
	;;^DD(399,113,1,1,"DELETE VALUE")
	;;=@
