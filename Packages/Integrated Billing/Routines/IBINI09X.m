IBINI09X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.07,1,2,1.1)
	;;=S X=DIV S X=$P(^DGCR(399.3,$P(^DGCR(399,DA,0),U,7),0),U,7)
	;;^DD(399,.07,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,11)=DIV,DIH=399,DIG=.11 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.07,1,2,2)
	;;=Q
	;;^DD(399,.07,1,2,"CREATE VALUE")
	;;=S X=$P(^DGCR(399.3,$P(^DGCR(399,DA,0),U,7),0),U,7)
	;;^DD(399,.07,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.07,1,2,"FIELD")
	;;=WHO'S RESPONSIBLE
	;;^DD(399,.07,1,3,0)
	;;=399^AD
	;;^DD(399,.07,1,3,1)
	;;=S ^DGCR(399,"AD",$E(X,1,30),DA)=""
	;;^DD(399,.07,1,3,2)
	;;=K ^DGCR(399,"AD",$E(X,1,30),DA)
	;;^DD(399,.07,1,3,"DT")
	;;=2910912
	;;^DD(399,.07,3)
	;;=Enter the code which identifies the type of bill.
	;;^DD(399,.07,12)
	;;=to screen out Inactive Rate Types
	;;^DD(399,.07,12.1)
	;;=S DIC("S")="I '$P(^(0),U,3)"
	;;^DD(399,.07,21,0)
	;;=^^1^1^2890413^^^
	;;^DD(399,.07,21,1,0)
	;;=This identifies the type of bill.
	;;^DD(399,.07,"DT")
	;;=2910912
	;;^DD(399,.08,0)
	;;=PTF ENTRY NUMBER^RP45X^DGPT(^0;8^D PTF^IBCU S DIC(0)="MN",DIC="^DGPT(",DIC("S")="I $D(IBDD1(+Y))" D ^DIC:X K DIC,IBDD1 S:$D(DIE) DIC=DIE S X=+Y K:Y<0 X
	;;^DD(399,.08,1,0)
	;;=^.1
	;;^DD(399,.08,1,1,0)
	;;=^^TRIGGER^399^159
	;;^DD(399,.08,1,1,1)
	;;=X ^DD(399,.08,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,.08,1,1,1.4)
	;;^DD(399,.08,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(2)=$C(59)_$S($D(^DD(399,159,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,9)_":",2),$C(59),1)=""
	;;^DD(399,.08,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,9)=DIV,DIH=399,DIG=159 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,1,2)
	;;=Q
	;;^DD(399,.08,1,1,"CREATE CONDITION")
	;;=#159=""
	;;^DD(399,.08,1,1,"CREATE VALUE")
	;;=S X=2
	;;^DD(399,.08,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.08,1,1,"FIELD")
	;;=#159
	;;^DD(399,.08,1,2,0)
	;;=^^TRIGGER^399^158
	;;^DD(399,.08,1,2,1)
	;;=X ^DD(399,.08,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,.08,1,2,1.4)
	;;^DD(399,.08,1,2,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(2)=$C(59)_$S($D(^DD(399,158,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,8)_":",2),$C(59),1)=""
	;;^DD(399,.08,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,8)=DIV,DIH=399,DIG=158 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,2,2)
	;;=Q
	;;^DD(399,.08,1,2,"CREATE CONDITION")
	;;=#158=""
	;;^DD(399,.08,1,2,"CREATE VALUE")
	;;=S X=2
	;;^DD(399,.08,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.08,1,2,"FIELD")
	;;=#158
	;;^DD(399,.08,1,3,0)
	;;=^^TRIGGER^399^160
	;;^DD(399,.08,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=99 X ^DD(399,.08,1,3,1.4)
	;;^DD(399,.08,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,10)=DIV,DIH=399,DIG=160 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,3,2)
	;;=Q
	;;^DD(399,.08,1,3,"CREATE VALUE")
	;;=S X=99
	;;^DD(399,.08,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.08,1,3,"FIELD")
	;;=ACCIDENT HOUR
	;;^DD(399,.08,1,4,0)
	;;=^^TRIGGER^399^162
	;;^DD(399,.08,1,4,1)
	;;=X ^DD(399,.08,1,4,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV D DIS^IBCU S X=X X ^DD(399,.08,1,4,1.4)
	;;^DD(399,.08,1,4,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$S('$D(^DGCR(399.1,+$P(Y(1),U,12),0)):"",1:$P(^(0),U,1))=""
