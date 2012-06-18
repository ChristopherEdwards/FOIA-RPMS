IBINI0BX	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(399.5,0,"GL")
	;;=^DGCR(399.5,
	;;^DIC("B","BILLING RATES",399.5)
	;;=
	;;^DIC(399.5,"%D",0)
	;;=^^8^8^2940215^^^^
	;;^DIC(399.5,"%D",1,0)
	;;=This file contains the historical billing rates, associated with revenue
	;;^DIC(399.5,"%D",2,0)
	;;=codes and bedsections that the DVA has legislative authority to bill third
	;;^DIC(399.5,"%D",3,0)
	;;=parties for reimbursement.
	;;^DIC(399.5,"%D",4,0)
	;;= 
	;;^DIC(399.5,"%D",5,0)
	;;=It is used to automatically associate revenue codes, bedsections and
	;;^DIC(399.5,"%D",6,0)
	;;=amounts with a bill.
	;;^DIC(399.5,"%D",7,0)
	;;= 
	;;^DIC(399.5,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(399.5,0)
	;;=FIELD^^.07^7
	;;^DD(399.5,0,"DDA")
	;;=N
	;;^DD(399.5,0,"DT")
	;;=2900501
	;;^DD(399.5,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399.1,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399.1,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(399.5,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399.2,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399.2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(399.5,0,"ID",.04)
	;;=S DGZX=X,X=$P(^(0),U,4),X2="2$" D COMMA^%DTC W "   ",X S X=DGZX K DGZX,X2
	;;^DD(399.5,0,"ID",.05)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(399.5,.05,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,5)_"":"",2),$C(59),1)")
	;;^DD(399.5,0,"IX","AIVDT",399.5,.01)
	;;=
	;;^DD(399.5,0,"IX","AIVDT1",399.5,.02)
	;;=
	;;^DD(399.5,0,"IX","AIVDT2",399.5,.03)
	;;=
	;;^DD(399.5,0,"IX","B",399.5,.01)
	;;=
	;;^DD(399.5,0,"IX","D",399.5,.03)
	;;=
	;;^DD(399.5,0,"NM","BILLING RATES")
	;;=
	;;^DD(399.5,.01,0)
	;;=EFFECTIVE DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y K:2991001<X!(2861001>X) X
	;;^DD(399.5,.01,1,0)
	;;=^.1
	;;^DD(399.5,.01,1,1,0)
	;;=399.5^B
	;;^DD(399.5,.01,1,1,1)
	;;=S ^DGCR(399.5,"B",$E(X,1,30),DA)=""
	;;^DD(399.5,.01,1,1,2)
	;;=K ^DGCR(399.5,"B",$E(X,1,30),DA)
	;;^DD(399.5,.01,1,2,0)
	;;=399.5^AIVDT^MUMPS
	;;^DD(399.5,.01,1,2,1)
	;;=S:$P(^DGCR(399.5,DA,0),U,2)&($P(^(0),U,3)) ^DGCR(399.5,"AIVDT",$P(^(0),U,2),-X,$P(^(0),U,3),DA)=""
	;;^DD(399.5,.01,1,2,2)
	;;=K:$P(^DGCR(399.5,DA,0),U,2)&($P(^(0),U,3)) ^DGCR(399.5,"AIVDT",$P(^(0),U,2),-X,$P(^(0),U,3),DA)
	;;^DD(399.5,.01,1,2,3)
	;;=DON'T DELETE
	;;^DD(399.5,.01,1,2,"%D",0)
	;;=^^1^1^2940214^^^
	;;^DD(399.5,.01,1,2,"%D",1,0)
	;;=All rates by revenue code, bedsection, and inverse date effective.
	;;^DD(399.5,.01,1,2,"DT")
	;;=2900501
	;;^DD(399.5,.01,3)
	;;=TYPE A DATE BETWEEN 10/1/1986 AND 10/1/1999
	;;^DD(399.5,.01,21,0)
	;;=^^4^4^2900501^^
	;;^DD(399.5,.01,21,1,0)
	;;=This is the date in which changes in billing rates will take effect.
	;;^DD(399.5,.01,21,2,0)
	;;=A new entry, with a new effective date is necessary to change a
	;;^DD(399.5,.01,21,3,0)
	;;=previous entry.  The most recent effective date's entry data will
	;;^DD(399.5,.01,21,4,0)
	;;=be used (even if its null) in calculating current charges.
	;;^DD(399.5,.01,"DT")
	;;=2900525
	;;^DD(399.5,.02,0)
	;;=BILLING BEDSECTION^R*P399.1'^DGCR(399.1,^0;2^S DIC("S")="I $P(^DGCR(399.1,+Y,0),U,5)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.5,.02,1,0)
	;;=^.1^^-1
	;;^DD(399.5,.02,1,2,0)
	;;=399.5^AIVDT1^MUMPS
	;;^DD(399.5,.02,1,2,1)
	;;=S:$P(^DGCR(399.5,DA,0),U,3) ^DGCR(399.5,"AIVDT",X,-^(0),$P(^(0),U,3),DA)=""
	;;^DD(399.5,.02,1,2,2)
	;;=K:$P(^DGCR(399.5,DA,0),U,3) ^DGCR(399.5,"AIVDT",X,-^(0),$P(^(0),U,3),DA)
	;;^DD(399.5,.02,1,2,3)
	;;=DON'T DELETE
	;;^DD(399.5,.02,1,2,"%D",0)
	;;=^^1^1^2940214^^
