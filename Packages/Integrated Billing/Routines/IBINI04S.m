IBINI04S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.4,0,"GL")
	;;=^IBA(355.4,
	;;^DIC("B","ANNUAL BENEFITS",355.4)
	;;=
	;;^DIC(355.4,"%D",0)
	;;=^^4^4^2940214^^^^
	;;^DIC(355.4,"%D",1,0)
	;;=This file contains the fields to maintain the annual benefits by year 
	;;^DIC(355.4,"%D",2,0)
	;;=for an insurance policy.
	;;^DIC(355.4,"%D",3,0)
	;;= 
	;;^DIC(355.4,"%D",4,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.4,0)
	;;=FIELD^^5.14^60
	;;^DD(355.4,0,"DDA")
	;;=N
	;;^DD(355.4,0,"DT")
	;;=2940228
	;;^DD(355.4,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBA(355.3,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(355.3,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(355.4,0,"IX","APY",355.4,.02)
	;;=
	;;^DD(355.4,0,"IX","APY1",355.4,.01)
	;;=
	;;^DD(355.4,0,"IX","B",355.4,.01)
	;;=
	;;^DD(355.4,0,"IX","C",355.4,.02)
	;;=
	;;^DD(355.4,0,"NM","ANNUAL BENEFITS")
	;;=
	;;^DD(355.4,.01,0)
	;;=BENEFIT YEAR BEGINNING ON^RDX^^0;1^S %DT="EX" D:$D(X) ^%DT S X=Y K:Y<1 X D DATECHK^IBCNSA2
	;;^DD(355.4,.01,1,0)
	;;=^.1
	;;^DD(355.4,.01,1,1,0)
	;;=355.4^B
	;;^DD(355.4,.01,1,1,1)
	;;=S ^IBA(355.4,"B",$E(X,1,30),DA)=""
	;;^DD(355.4,.01,1,1,2)
	;;=K ^IBA(355.4,"B",$E(X,1,30),DA)
	;;^DD(355.4,.01,1,2,0)
	;;=355.4^APY1^MUMPS
	;;^DD(355.4,.01,1,2,1)
	;;=S:$P(^IBA(355.4,DA,0),U,2) ^IBA(355.4,"APY",$P(^(0),U,2),-X,DA)=""
	;;^DD(355.4,.01,1,2,2)
	;;=K ^IBA(355.4,"APY",+$P(^IBA(355.4,DA,0),U,2),-X,DA)
	;;^DD(355.4,.01,1,2,3)
	;;=DO NOT DELETE
	;;^DD(355.4,.01,1,2,"%D",0)
	;;=^^1^1^2930831^^^^
	;;^DD(355.4,.01,1,2,"%D",1,0)
	;;=Cross-reference of all policies by calendar year.
	;;^DD(355.4,.01,1,2,"DT")
	;;=2930831
	;;^DD(355.4,.01,1,3,0)
	;;=^^TRIGGER^355.4^1.01
	;;^DD(355.4,.01,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBA(355.4,D0,1)):^(1),1:"") S X=$P(Y(1),U,1)="" I X S X=DIV S Y(1)=$S($D(^IBA(355.4,D0,1)):^(1),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(355.4,.01,1,3,1.4)
	;;^DD(355.4,.01,1,3,1.4)
	;;=S DIH=$S($D(^IBA(355.4,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,1)=DIV,DIH=355.4,DIG=1.01 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(355.4,.01,1,3,2)
	;;=Q
	;;^DD(355.4,.01,1,3,"CREATE CONDITION")
	;;=#1.01=""
	;;^DD(355.4,.01,1,3,"CREATE VALUE")
	;;=S X=DT
	;;^DD(355.4,.01,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(355.4,.01,1,3,"DT")
	;;=2930604
	;;^DD(355.4,.01,1,3,"FIELD")
	;;=#1.01
	;;^DD(355.4,.01,1,4,0)
	;;=^^TRIGGER^355.4^1.02
	;;^DD(355.4,.01,1,4,1)
	;;=X ^DD(355.4,.01,1,4,1.3) I X S X=DIV S Y(1)=$S($D(^IBA(355.4,D0,1)):^(1),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(355.4,.01,1,4,1.4)
	;;^DD(355.4,.01,1,4,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBA(355.4,D0,1)):^(1),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1))=""
	;;^DD(355.4,.01,1,4,1.4)
	;;=S DIH=$S($D(^IBA(355.4,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,2)=DIV,DIH=355.4,DIG=1.02 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(355.4,.01,1,4,2)
	;;=Q
	;;^DD(355.4,.01,1,4,"CREATE CONDITION")
	;;=#1.02=""
	;;^DD(355.4,.01,1,4,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(355.4,.01,1,4,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(355.4,.01,1,4,"DT")
	;;=2930604
	;;^DD(355.4,.01,1,4,"FIELD")
	;;=#1.02
	;;^DD(355.4,.01,3)
	;;=Partial benefit years not allowed.
	;;^DD(355.4,.01,21,0)
	;;=^^1^1^2940228^^^^
	;;^DD(355.4,.01,21,1,0)
	;;=This is the year to which the health insurance policy's benefits apply.
	;;^DD(355.4,.01,"DT")
	;;=2930903
	;;^DD(355.4,.02,0)
	;;=HEALTH INSURANCE POLICY^P355.3'^IBA(355.3,^0;2^Q
	;;^DD(355.4,.02,1,0)
	;;=^.1
	;;^DD(355.4,.02,1,1,0)
	;;=355.4^C
