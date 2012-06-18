IBINI0AC	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,101,"DT")
	;;=2940201
	;;^DD(399,102,0)
	;;=SECONDARY INSURANCE CARRIER^*P36'X^DIC(36,^M;2^D ^DIC K DIC,IBDD S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,102,1,0)
	;;=^.1
	;;^DD(399,102,1,1,0)
	;;=399^AI2^MUMPS
	;;^DD(399,102,1,1,1)
	;;=Q
	;;^DD(399,102,1,1,2)
	;;=Q
	;;^DD(399,102,1,1,"DT")
	;;=2931220
	;;^DD(399,102,1,2,0)
	;;=^^TRIGGER^399^123
	;;^DD(399,102,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(399,102,1,2,1.1) X ^DD(399,102,1,2,1.4)
	;;^DD(399,102,1,2,1.1)
	;;=S X=DIV S I(0,0)=$S($D(D0):D0,1:""),D0=DIV S:'$D(^DIC(36,+D0,0)) D0=-1 S Y(101)=$S($D(^DIC(36,D0,0)):^(0),1:"") S X=$P(Y(101),U,11) S D0=I(0,0)
	;;^DD(399,102,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M1")):^("M1"),1:""),DIV=X S $P(^("M1"),U,3)=DIV,DIH=399,DIG=123 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,102,1,2,2)
	;;=Q
	;;^DD(399,102,1,2,"%D",0)
	;;=^^2^2^2940201^
	;;^DD(399,102,1,2,"%D",1,0)
	;;=Loads the Secondary Provider # with the Hospital Provider Number of the
	;;^DD(399,102,1,2,"%D",2,0)
	;;=Secondary Insurance Carrier.
	;;^DD(399,102,1,2,"CREATE VALUE")
	;;=SECONDARY INSURANCE CARRIER:HOSPITAL PROVIDER NUMBER
	;;^DD(399,102,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,102,1,2,"DT")
	;;=2940201
	;;^DD(399,102,1,2,"FIELD")
	;;=SECONDARY PROVIDER #
	;;^DD(399,102,3)
	;;=Enter name of secondary insurance carrier from which the provider might expect some payment for this bill.
	;;^DD(399,102,5,1,0)
	;;=399^113^1
	;;^DD(399,102,12)
	;;=Only valid insurance companies for this date of care.
	;;^DD(399,102,12.1)
	;;=S DIC("S")="I $D(IBDD(+Y)),'$D(^DGCR(399,DA,""AIC"",+Y))"
	;;^DD(399,102,21,0)
	;;=^^2^2^2880831^
	;;^DD(399,102,21,1,0)
	;;=This is the name of the secondary insurance carrier from which the provider
	;;^DD(399,102,21,2,0)
	;;=might expect some payment for this bill.
	;;^DD(399,102,"DT")
	;;=2940201
	;;^DD(399,103,0)
	;;=TERTIARY INSURANCE CARRIER^*P36'X^DIC(36,^M;3^D ^DIC K DIC,IBDD S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,103,1,0)
	;;=^.1
	;;^DD(399,103,1,1,0)
	;;=399^AI3^MUMPS
	;;^DD(399,103,1,1,1)
	;;=Q
	;;^DD(399,103,1,1,2)
	;;=Q
	;;^DD(399,103,1,1,"DT")
	;;=2931220
	;;^DD(399,103,1,2,0)
	;;=^^TRIGGER^399^124
	;;^DD(399,103,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(399,103,1,2,1.1) X ^DD(399,103,1,2,1.4)
	;;^DD(399,103,1,2,1.1)
	;;=S X=DIV S I(0,0)=$S($D(D0):D0,1:""),D0=DIV S:'$D(^DIC(36,+D0,0)) D0=-1 S Y(101)=$S($D(^DIC(36,D0,0)):^(0),1:"") S X=$P(Y(101),U,11) S D0=I(0,0)
	;;^DD(399,103,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M1")):^("M1"),1:""),DIV=X S $P(^("M1"),U,4)=DIV,DIH=399,DIG=124 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,103,1,2,2)
	;;=Q
	;;^DD(399,103,1,2,"%D",0)
	;;=^^2^2^2940201^
	;;^DD(399,103,1,2,"%D",1,0)
	;;=Loads the Tertiary Provider # with the Hospital Provider Number of the
	;;^DD(399,103,1,2,"%D",2,0)
	;;=Tertiary Insurance Carrier.
	;;^DD(399,103,1,2,"CREATE VALUE")
	;;=TERTIARY INSURANCE CARRIER:HOSPITAL PROVIDER NUMBER
	;;^DD(399,103,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,103,1,2,"DT")
	;;=2940201
	;;^DD(399,103,1,2,"FIELD")
	;;=TERTIARY PROVIDER #
	;;^DD(399,103,3)
	;;=Enter name of tertiary insurance carrier from which the provider might expect some payment for this bill.
	;;^DD(399,103,5,1,0)
	;;=399^114^1
	;;^DD(399,103,12)
	;;=Only valid insurance companies for this date of care.
	;;^DD(399,103,12.1)
	;;=S DIC("S")="I $D(IBDD(+Y)),'$D(^DGCR(399,DA,""AIC"",+Y))"
	;;^DD(399,103,21,0)
	;;=^^2^2^2880831^
