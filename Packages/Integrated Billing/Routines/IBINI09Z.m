IBINI09Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.11,1,1,2)
	;;=Q
	;;^DD(399,.11,1,1,"CREATE CONDITION")
	;;=S X=(X="i"&($S('$D(^DGCR(399,DA,"M")):1,'+^("M"):1,'$D(^DIC(36,+^("M"),0)):1,1:0)))
	;;^DD(399,.11,1,1,"CREATE VALUE")
	;;=D EN1^IBCU5
	;;^DD(399,.11,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.11,1,1,"DT")
	;;=2930908
	;;^DD(399,.11,1,1,"FIELD")
	;;=#112
	;;^DD(399,.11,1,2,0)
	;;=399^AML1^MUMPS
	;;^DD(399,.11,1,2,1)
	;;=D EN^IBCU5
	;;^DD(399,.11,1,2,2)
	;;=D DEL^IBCU5
	;;^DD(399,.11,1,2,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399,.11,1,2,"%D",1,0)
	;;=Loads/deletes the mailing address.
	;;^DD(399,.11,1,3,0)
	;;=399^AREV6^MUMPS
	;;^DD(399,.11,1,3,1)
	;;=S DGRVRCAL=1
	;;^DD(399,.11,1,3,2)
	;;=S DGRVRCAL=2
	;;^DD(399,.11,1,3,"%D",0)
	;;=^^2^2^2940214^
	;;^DD(399,.11,1,3,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399,.11,1,3,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399,.11,3)
	;;=Enter the code which identifies the party responsible for payment of this bill.
	;;^DD(399,.11,5,1,0)
	;;=399^.07^2
	;;^DD(399,.11,21,0)
	;;=^^1^1^2880928^
	;;^DD(399,.11,21,1,0)
	;;=This identifies the party responsible for payment of this bill.
	;;^DD(399,.11,"DT")
	;;=2930908
	;;^DD(399,.13,0)
	;;=STATUS^RS^1:ENTERED/NOT REVIEWED;2:REVIEWED;3:AUTHORIZED;4:PRINTED;5:TRANSMITTED;7:CANCELLED;0:CLOSED;^0;13^Q
	;;^DD(399,.13,1,0)
	;;=^.1
	;;^DD(399,.13,1,1,0)
	;;=^^TRIGGER^399^.14
	;;^DD(399,.13,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,.13,1,1,1.4)
	;;^DD(399,.13,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,14)=DIV,DIH=399,DIG=.14 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.13,1,1,2)
	;;=Q
	;;^DD(399,.13,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,.13,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.13,1,1,"FIELD")
	;;=#.14
	;;^DD(399,.13,1,2,0)
	;;=399^AOP^MUMPS
	;;^DD(399,.13,1,2,1)
	;;=I X>0,X<3,$P(^DGCR(399,DA,0),U,2) S ^DGCR(399,"AOP",$P(^(0),U,2),DA)=""
	;;^DD(399,.13,1,2,2)
	;;=I $P(^DGCR(399,DA,0),U,2) K ^DGCR(399,"AOP",$P(^(0),U,2),DA)
	;;^DD(399,.13,1,3,0)
	;;=399^AST^MUMPS
	;;^DD(399,.13,1,3,1)
	;;=I +X=3 S ^DGCR(399,"AST",+X,DA)=""
	;;^DD(399,.13,1,3,2)
	;;=K ^DGCR(399,"AST",+X,DA)
	;;^DD(399,.13,1,3,"%D",0)
	;;=^^1^1^2940214^^^^
	;;^DD(399,.13,1,3,"%D",1,0)
	;;=Cross reference of all Authorized bills.
	;;^DD(399,.13,1,3,"DT")
	;;=2940127
	;;^DD(399,.13,3)
	;;=Enter the code which defines whether or not billing record is editable.
	;;^DD(399,.13,5,1,0)
	;;=399^.01^6
	;;^DD(399,.13,5,2,0)
	;;=399^17^1
	;;^DD(399,.13,5,3,0)
	;;=399^14^1
	;;^DD(399,.13,5,4,0)
	;;=399^9^3
	;;^DD(399,.13,5,5,0)
	;;=399^6^3
	;;^DD(399,.13,21,0)
	;;=^^5^5^2940216^^^^
	;;^DD(399,.13,21,1,0)
	;;=This identifies the status of this billing record. That is, whether or not
	;;^DD(399,.13,21,2,0)
	;;=this record is open for editing.  Current valid statuss are:
	;;^DD(399,.13,21,3,0)
	;;=1=ENTERED/NOT REVIEWED, 2=REVIEWED, 3=AUTHORIZED, 4=PRINTED, 5=TRANSMITTED,
	;;^DD(399,.13,21,4,0)
	;;=7=CANCELLED, 0=CLOSED
	;;^DD(399,.13,21,5,0)
	;;=Only ENTERED/NOT REVIEWED and REVIEWED bills are editable.
	;;^DD(399,.13,"DT")
	;;=2940127
	;;^DD(399,.14,0)
	;;=STATUS DATE^RD^^0;14^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,.14,3)
	;;=Enter the date of last status change.
	;;^DD(399,.14,5,1,0)
	;;=399^.13^1
	;;^DD(399,.14,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,.14,21,1,0)
	;;=This is the date of the last status change.
	;;^DD(399,.14,"DT")
	;;=2880608
	;;^DD(399,.15,0)
	;;=BILL COPIED FROM^*P399'^DGCR(399,^0;15^S DIC("S")="I $P(^(0),U,13)=7" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
