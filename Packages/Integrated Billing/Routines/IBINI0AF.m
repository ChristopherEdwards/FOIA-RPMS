IBINI0AF	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,113,1,1,"DT")
	;;=2931203
	;;^DD(399,113,1,1,"FIELD")
	;;=SECONDARY INSURANCE CARRIER
	;;^DD(399,113,1,2,0)
	;;=399^AI21^MUMPS
	;;^DD(399,113,1,2,1)
	;;=D IX^IBCNS2(DA,"I2")
	;;^DD(399,113,1,2,2)
	;;=D KIX^IBCNS2(DA,"I2")
	;;^DD(399,113,1,2,"%D",0)
	;;=^^2^2^2931220^
	;;^DD(399,113,1,2,"%D",1,0)
	;;=Sets "I2" x-ref and "aic" x-ref for bill/claims file.  These indexes 
	;;^DD(399,113,1,2,"%D",2,0)
	;;=previously were set by field #102.
	;;^DD(399,113,1,2,"DT")
	;;=2931220
	;;^DD(399,113,2)
	;;=S Y(0)=Y S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,113,2.1)
	;;=S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,113,3)
	;;=Select this patient's insurance policy that is the secondary policy to be billed.  Enter the name of the Ins. Company or the number.
	;;^DD(399,113,4)
	;;=D DDHELP^IBCNS2(DA,2)
	;;^DD(399,113,21,0)
	;;=^^1^1^2940214^
	;;^DD(399,113,21,1,0)
	;;=The secondary policy to be billed for this episode of care.
	;;^DD(399,113,"DT")
	;;=2931220
	;;^DD(399,114,0)
	;;=TERTIARY INSURANCE POLICY^FOX^^M;14^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>4!($L(X)<1) X D:$D(X) DD^IBCNS2(X,DA,1)
	;;^DD(399,114,1,0)
	;;=^.1
	;;^DD(399,114,1,1,0)
	;;=^^TRIGGER^399^103
	;;^DD(399,114,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(399,114,1,1,1.1) X ^DD(399,114,1,1,1.4)
	;;^DD(399,114,1,1,1.1)
	;;=S X=DIV S X=+$$INSCO^IBCNS2(DA,+$P(^DGCR(399,DA,"M"),U,14))
	;;^DD(399,114,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,3)=DIV,DIH=399,DIG=103 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,114,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,114,1,1,2.4)
	;;^DD(399,114,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,3)=DIV,DIH=399,DIG=103 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,114,1,1,"CREATE VALUE")
	;;=S X=+$$INSCO^IBCNS2(DA,+$P(^DGCR(399,DA,"M"),U,14))
	;;^DD(399,114,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399,114,1,1,"DT")
	;;=2931203
	;;^DD(399,114,1,1,"FIELD")
	;;=TERTIARY INSURANCE CARRIER
	;;^DD(399,114,1,2,0)
	;;=399^AI31^MUMPS
	;;^DD(399,114,1,2,1)
	;;=D IX^IBCNS2(DA,"I3")
	;;^DD(399,114,1,2,2)
	;;=D KIX^IBCNS2(DA,"I3")
	;;^DD(399,114,1,2,"%D",0)
	;;=^^2^2^2931220^
	;;^DD(399,114,1,2,"%D",1,0)
	;;=Sets "I3" x-ref and "aic" x-ref for bill/claims file.  These indexes 
	;;^DD(399,114,1,2,"%D",2,0)
	;;=previously were set by field #103.
	;;^DD(399,114,1,2,"DT")
	;;=2931220
	;;^DD(399,114,2)
	;;=S Y(0)=Y S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,114,2.1)
	;;=S Y=$$TRANS^IBCNS2(DA,Y)
	;;^DD(399,114,3)
	;;=Select this patient's insurance policy that is the tertiary policy to be billed.  Enter the name of the Ins. Company or the number.
	;;^DD(399,114,4)
	;;=D DDHELP^IBCNS2(DA,3)
	;;^DD(399,114,21,0)
	;;=^^1^1^2940214^
	;;^DD(399,114,21,1,0)
	;;=The tertiary policy to be billed for this episode of care.
	;;^DD(399,114,"DT")
	;;=2931220
	;;^DD(399,121,0)
	;;=MAILING ADDRESS STREET3^F^^M1;1^K:$L(X)>35!($L(X)<3) X
	;;^DD(399,121,3)
	;;=Enter the 3-35 character street address to which this bill is to be sent.
	;;^DD(399,121,21,0)
	;;=^^1^1^2890110^
	;;^DD(399,121,21,1,0)
	;;=This is the street address to which this bill is to be sent.
	;;^DD(399,121,"DT")
	;;=2890110
	;;^DD(399,122,0)
	;;=PRIMARY PROVIDER #^F^^M1;2^K:$L(X)>13!($L(X)<3) X
	;;^DD(399,122,3)
	;;=Answer must be 3-13 characters in length.
	;;^DD(399,122,5,1,0)
	;;=399^101^5
	;;^DD(399,122,21,0)
	;;=^^2^2^2940201^^
	;;^DD(399,122,21,1,0)
	;;=This is the number assigned to the provider by the primary payer.
