IBINI0A4	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,9,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,11)=DIV,DIH=399,DIG=11 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,9,1,2,2)
	;;=Q
	;;^DD(399,9,1,2,"CREATE CONDITION")
	;;=AUTHORIZER=""
	;;^DD(399,9,1,2,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(399,9,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,9,1,2,"DT")
	;;=2940310
	;;^DD(399,9,1,2,"FIELD")
	;;=AUTHORIZER
	;;^DD(399,9,1,3,0)
	;;=^^TRIGGER^399^.13
	;;^DD(399,9,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y=Y(0) X:$D(^DD(399,9,2)) ^(2) S X=Y="YES" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=3 X ^DD(399,9,1,3,1.4)
	;;^DD(399,9,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,13)=DIV,DIH=399,DIG=.13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,9,1,3,2)
	;;=Q
	;;^DD(399,9,1,3,"CREATE CONDITION")
	;;=#9="YES"
	;;^DD(399,9,1,3,"CREATE VALUE")
	;;=S X=3
	;;^DD(399,9,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,9,1,3,"FIELD")
	;;=STATUS
	;;^DD(399,9,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,9,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,9,3)
	;;=Enter 'Yes' or '1' if the billing record has been reviewed and is ready for authorization, or 'No' or '0' if the billing record is not ready to be authorized.
	;;^DD(399,9,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,9,21,1,0)
	;;=This allows the user to authorize the printing of this bill.
	;;^DD(399,9,"DT")
	;;=2940310
	;;^DD(399,10,0)
	;;=AUTHORIZATION DATE^DI^^S;10^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,10,3)
	;;=Enter date on which this billing record was authorized for generation.
	;;^DD(399,10,5,1,0)
	;;=399^9^1
	;;^DD(399,10,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,10,21,1,0)
	;;=This is the date on which this bill was authorized for printing.
	;;^DD(399,10,"DT")
	;;=2880526
	;;^DD(399,11,0)
	;;=AUTHORIZER^P200'I^VA(200,^S;11^Q
	;;^DD(399,11,3)
	;;=Enter user who authorized this bill for generation.
	;;^DD(399,11,5,1,0)
	;;=399^9^2
	;;^DD(399,11,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,11,21,1,0)
	;;=This is the user who authorized the generation of this bill.
	;;^DD(399,11,"DT")
	;;=2900921
	;;^DD(399,12,0)
	;;=DATE FIRST PRINTED^RD^^S;12^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,12,1,0)
	;;=^.1
	;;^DD(399,12,1,1,0)
	;;=^^TRIGGER^399^14
	;;^DD(399,12,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,14)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,12,1,1,1.4)
	;;^DD(399,12,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,14)=DIV,DIH=399,DIG=14 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,12,1,1,2)
	;;=Q
	;;^DD(399,12,1,1,"CREATE CONDITION")
	;;=#14=""
	;;^DD(399,12,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,12,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,12,1,1,"FIELD")
	;;=#14
	;;^DD(399,12,1,2,0)
	;;=^^TRIGGER^399^15
	;;^DD(399,12,1,2,1)
	;;=X ^DD(399,12,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,12,1,2,1.4)
	;;^DD(399,12,1,2,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,15),0)):"",1:$P(^(0),U,1))=""
	;;^DD(399,12,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,15)=DIV,DIH=399,DIG=15 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,12,1,2,2)
	;;=Q
	;;^DD(399,12,1,2,"CREATE CONDITION")
	;;=#15=""
	;;^DD(399,12,1,2,"CREATE VALUE")
	;;=S X=DUZ
