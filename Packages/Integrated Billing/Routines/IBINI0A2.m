IBINI0A2	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,3,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,5)=DIV,DIH=399,DIG=5 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,3,1,2,2)
	;;=Q
	;;^DD(399,3,1,2,"CREATE CONDITION")
	;;=INITIAL REVIEWER=""
	;;^DD(399,3,1,2,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(399,3,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,3,1,2,"DT")
	;;=2940310
	;;^DD(399,3,1,2,"FIELD")
	;;=INITIAL REVIEWER
	;;^DD(399,3,1,3,0)
	;;=^^TRIGGER^399^6
	;;^DD(399,3,1,3,1)
	;;=X ^DD(399,3,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=+X X ^DD(399,3,1,3,1.4)
	;;^DD(399,3,1,3,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:""),Y=$P(Y(1),U,6) X:$D(^DD(399,6,2)) ^(2) S X=Y=""
	;;^DD(399,3,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,5,99))  S DIH=DIH_U" S %=$P(DIH,U,7,999),DIU=$P(DIH,U,6),^("S")=$P(DIH,U,1,5)_U_DIV_$S(%]"":U_%,1:""),DIH=399,DIG=6 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,3,1,3,2)
	;;=Q
	;;^DD(399,3,1,3,"CREATE CONDITION")
	;;=SECONDARY REVIEW=""
	;;^DD(399,3,1,3,"CREATE VALUE")
	;;=S X=+X
	;;^DD(399,3,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,3,1,3,"FIELD")
	;;=SECONDARY REVIEW
	;;^DD(399,3,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,3,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,3,3)
	;;=Enter 'Yes' or '1' if the information in this record is accurate and complete or 'No' or '0' if the information is inaccurate or incomplete.
	;;^DD(399,3,21,0)
	;;=^^2^2^2880831^
	;;^DD(399,3,21,1,0)
	;;=This allows the user to approve or disapprove the information contained in
	;;^DD(399,3,21,2,0)
	;;=this billing record.
	;;^DD(399,3,"DT")
	;;=2940310
	;;^DD(399,4,0)
	;;=INITIAL REVIEW DATE^D^^S;4^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,4,1,0)
	;;=^.1^^0
	;;^DD(399,4,3)
	;;=Enter the date on which this billing record was first reviewed.
	;;^DD(399,4,5,1,0)
	;;=399^3^1
	;;^DD(399,4,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,4,21,1,0)
	;;=This is the date on which this record was initially reviewed.
	;;^DD(399,4,"DT")
	;;=2900116
	;;^DD(399,5,0)
	;;=INITIAL REVIEWER^P200'I^VA(200,^S;5^Q
	;;^DD(399,5,1,0)
	;;=^.1^^0
	;;^DD(399,5,3)
	;;=Enter the user who first reviewed this billing record.
	;;^DD(399,5,5,1,0)
	;;=399^3^2
	;;^DD(399,5,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,5,21,1,0)
	;;=This is the user who performed the initial review on this billing record.
	;;^DD(399,5,"DT")
	;;=2900921
	;;^DD(399,6,0)
	;;=SECONDARY REVIEW^FOX^^S;6^I $D(X) D YN^IBCU
	;;^DD(399,6,.1)
	;;=DO YOU APPROVE THIS BILL? (Y/N)
	;;^DD(399,6,1,0)
	;;=^.1
	;;^DD(399,6,1,1,0)
	;;=^^TRIGGER^399^7
	;;^DD(399,6,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,7)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,6,1,1,1.4)
	;;^DD(399,6,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,7)=DIV,DIH=399,DIG=7 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,6,1,1,2)
	;;=Q
	;;^DD(399,6,1,1,"CREATE CONDITION")
	;;=SECONDARY REVIEW DATE=""
	;;^DD(399,6,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,6,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,6,1,1,"DT")
	;;=2940310
	;;^DD(399,6,1,1,"FIELD")
	;;=SECONDARY REVIEW DATE
	;;^DD(399,6,1,2,0)
	;;=^^TRIGGER^399^8
	;;^DD(399,6,1,2,1)
	;;=X ^DD(399,6,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,6,1,2,1.4)
