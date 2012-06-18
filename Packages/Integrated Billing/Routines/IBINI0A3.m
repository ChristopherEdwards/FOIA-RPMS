IBINI0A3	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,6,1,2,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,8),0)):"",1:$P(^(0),U,1))=""
	;;^DD(399,6,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,8)=DIV,DIH=399,DIG=8 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,6,1,2,2)
	;;=Q
	;;^DD(399,6,1,2,"CREATE CONDITION")
	;;=SECONDARY REVIEWER=""
	;;^DD(399,6,1,2,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(399,6,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,6,1,2,"DT")
	;;=2940310
	;;^DD(399,6,1,2,"FIELD")
	;;=SECONDARY REVIEWER
	;;^DD(399,6,1,3,0)
	;;=^^TRIGGER^399^.13
	;;^DD(399,6,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y=Y(0) X:$D(^DD(399,6,2)) ^(2) S X=Y="YES" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,6,1,3,1.4)
	;;^DD(399,6,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,13)=DIV,DIH=399,DIG=.13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,6,1,3,2)
	;;=Q
	;;^DD(399,6,1,3,"CREATE CONDITION")
	;;=#6="YES"
	;;^DD(399,6,1,3,"CREATE VALUE")
	;;=S X=2
	;;^DD(399,6,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,6,1,3,"FIELD")
	;;=STATUS
	;;^DD(399,6,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,6,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,6,3)
	;;=Enter 'Yes' or '1' if the information in this record is accurate and complete, or 'No' or '0' if the information is inaccurate or incomplete.
	;;^DD(399,6,5,1,0)
	;;=399^3^3
	;;^DD(399,6,21,0)
	;;=^^2^2^2880831^
	;;^DD(399,6,21,1,0)
	;;=This allows the user to approve or disapprove the information contained in
	;;^DD(399,6,21,2,0)
	;;=this billing record during the secondary review stage.
	;;^DD(399,6,"DT")
	;;=2940310
	;;^DD(399,7,0)
	;;=SECONDARY REVIEW DATE^D^^S;7^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,7,3)
	;;=Enter the date on which last review was performed.
	;;^DD(399,7,5,1,0)
	;;=399^6^1
	;;^DD(399,7,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,7,21,1,0)
	;;=This is the date on which this record was last reviewed.
	;;^DD(399,7,"DT")
	;;=2880523
	;;^DD(399,8,0)
	;;=SECONDARY REVIEWER^P200'^VA(200,^S;8^Q
	;;^DD(399,8,3)
	;;=Enter the user who performed the last review on this billing record.
	;;^DD(399,8,5,1,0)
	;;=399^6^2
	;;^DD(399,8,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,8,21,1,0)
	;;=This is the user who performed the last review of this billing record.
	;;^DD(399,8,"DT")
	;;=2900921
	;;^DD(399,9,0)
	;;=AUTHORIZE BILL GENERATION?^FOX^^S;9^I $D(X) D YN^IBCU
	;;^DD(399,9,1,0)
	;;=^.1
	;;^DD(399,9,1,1,0)
	;;=^^TRIGGER^399^10
	;;^DD(399,9,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,10)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,9,1,1,1.4)
	;;^DD(399,9,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,10)=DIV,DIH=399,DIG=10 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,9,1,1,2)
	;;=Q
	;;^DD(399,9,1,1,"CREATE CONDITION")
	;;=AUTHORIZATION DATE=""
	;;^DD(399,9,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,9,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,9,1,1,"DT")
	;;=2940310
	;;^DD(399,9,1,1,"FIELD")
	;;=AUTHORIZATION DATE
	;;^DD(399,9,1,2,0)
	;;=^^TRIGGER^399^11
	;;^DD(399,9,1,2,1)
	;;=X ^DD(399,9,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,9,1,2,1.4)
	;;^DD(399,9,1,2,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,11),0)):"",1:$P(^(0),U,1))=""
