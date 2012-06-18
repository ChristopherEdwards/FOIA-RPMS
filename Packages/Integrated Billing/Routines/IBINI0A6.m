IBINI0A6	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,16,1,0)
	;;=^.1
	;;^DD(399,16,1,1,0)
	;;=^^TRIGGER^399^17
	;;^DD(399,16,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,16,1,1,1.4)
	;;^DD(399,16,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,17)=DIV,DIH=399,DIG=17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,16,1,1,2)
	;;=Q
	;;^DD(399,16,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,16,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,16,1,1,"FIELD")
	;;=#17
	;;^DD(399,16,1,2,0)
	;;=^^TRIGGER^399^18
	;;^DD(399,16,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,18),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,16,1,2,1.4)
	;;^DD(399,16,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,18)=DIV,DIH=399,DIG=18 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,16,1,2,2)
	;;=Q
	;;^DD(399,16,1,2,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(399,16,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,16,1,2,"FIELD")
	;;=#18
	;;^DD(399,16,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,16,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,16,3)
	;;=Enter 'Yes' or '1' if you want this billing record to be cancelled, 'No' or '0' if you do not want this billing record to be cancelled.
	;;^DD(399,16,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,16,21,1,0)
	;;=This allows the user to cancel this bill.
	;;^DD(399,16,"DT")
	;;=2880608
	;;^DD(399,17,0)
	;;=DATE BILL CANCELLED^DI^^S;17^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,17,1,0)
	;;=^.1
	;;^DD(399,17,1,1,0)
	;;=^^TRIGGER^399^.13
	;;^DD(399,17,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,"S"),U,16)=1 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=7 X ^DD(399,17,1,1,1.4)
	;;^DD(399,17,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,13)=DIV,DIH=399,DIG=.13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,17,1,1,2)
	;;=Q
	;;^DD(399,17,1,1,"CREATE CONDITION")
	;;=I $P(^DGCR(399,DA,"S"),U,16)=1
	;;^DD(399,17,1,1,"CREATE VALUE")
	;;=S X=7
	;;^DD(399,17,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,17,1,1,"FIELD")
	;;=STATUS
	;;^DD(399,17,3)
	;;=Enter date on which this bill was cancelled.
	;;^DD(399,17,5,1,0)
	;;=399^16^1
	;;^DD(399,17,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,17,21,1,0)
	;;=This is the date on which this billing record was cancelled.
	;;^DD(399,17,"DT")
	;;=2900119
	;;^DD(399,18,0)
	;;=BILL CANCELLED BY^P200'I^VA(200,^S;18^Q
	;;^DD(399,18,3)
	;;=Enter user who cancelled this bill.
	;;^DD(399,18,5,1,0)
	;;=399^16^2
	;;^DD(399,18,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,18,21,1,0)
	;;=This is the user who cancelled this bill.
	;;^DD(399,18,"DT")
	;;=2900921
	;;^DD(399,19,0)
	;;=REASON CANCELLED^RFX^^S;19^K:$L(X)>100!($L(X)<3)!'(X?1A.ANP) X I '$D(X) X ^DD(399,19,9.3)
	;;^DD(399,19,3)
	;;=Enter the 3-100 character reason(s) why this bill was cancelled.
	;;^DD(399,19,9.3)
	;;=W ?5,"Reason for cancellation is mandatory if you wish to cancel this bill.",!,?5,"Bill will not be cancelled if this field is left unanswered.",!
	;;^DD(399,19,21,0)
	;;=^^3^3^2900417^^^
	;;^DD(399,19,21,1,0)
	;;=This is the reason(s) why this bill was cancelled.  This entry is mandatory
	;;^DD(399,19,21,2,0)
	;;=when cancelling a bill.  Enter 3-100 characters, the first character must
	;;^DD(399,19,21,3,0)
	;;=be an alphabetic character.
	;;^DD(399,19,"DT")
	;;=2920121
	;;^DD(399,40,0)
	;;=CONDITION CODE^399.04SA^^CC;0
	;;^DD(399,40,21,0)
	;;=^^2^2^2931229^^^
