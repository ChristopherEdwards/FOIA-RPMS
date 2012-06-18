IBINI01J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.2,0,"GL")
	;;=^IBE(350.2,
	;;^DIC("B","IB ACTION CHARGE",350.2)
	;;=
	;;^DIC(350.2,"%D",0)
	;;=^^6^6^2940214^^^
	;;^DIC(350.2,"%D",1,0)
	;;=This file contains the unit charges for an IB ACTION TYPE by the
	;;^DIC(350.2,"%D",2,0)
	;;=effective date of the charge.  The "AIVDT" cross-reference can be
	;;^DIC(350.2,"%D",3,0)
	;;=used to quickly ascertain the most recent charge for an action type.
	;;^DIC(350.2,"%D",4,0)
	;;= 
	;;^DIC(350.2,"%D",5,0)
	;;= 
	;;^DIC(350.2,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.2,0)
	;;=FIELD^^10^7
	;;^DD(350.2,0,"DDA")
	;;=N
	;;^DD(350.2,0,"DT")
	;;=2910913
	;;^DD(350.2,0,"ID",.02)
	;;=W "   ",$E($P(^(0),U,2),4,5)_"-"_$E($P(^(0),U,2),6,7)_"-"_$E($P(^(0),U,2),2,3)
	;;^DD(350.2,0,"IX","AIVDT",350.2,.02)
	;;=
	;;^DD(350.2,0,"IX","AIVDT1",350.2,.03)
	;;=
	;;^DD(350.2,0,"IX","B",350.2,.01)
	;;=
	;;^DD(350.2,0,"IX","C",350.2,.02)
	;;=
	;;^DD(350.2,0,"NM","IB ACTION CHARGE")
	;;=
	;;^DD(350.2,.01,0)
	;;=KEY^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(350.2,.01,1,0)
	;;=^.1
	;;^DD(350.2,.01,1,1,0)
	;;=350.2^B
	;;^DD(350.2,.01,1,1,1)
	;;=S ^IBE(350.2,"B",$E(X,1,30),DA)=""
	;;^DD(350.2,.01,1,1,2)
	;;=K ^IBE(350.2,"B",$E(X,1,30),DA)
	;;^DD(350.2,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(350.2,.01,21,0)
	;;=^^3^3^2910305^
	;;^DD(350.2,.01,21,1,0)
	;;=This is a description unique name for this entry that identifies it.  It
	;;^DD(350.2,.01,21,2,0)
	;;=is not used in the calculation of the charge but rather for editing
	;;^DD(350.2,.01,21,3,0)
	;;=purposes.
	;;^DD(350.2,.02,0)
	;;=EFFECTIVE DATE^D^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.2,.02,1,0)
	;;=^.1
	;;^DD(350.2,.02,1,1,0)
	;;=350.2^C
	;;^DD(350.2,.02,1,1,1)
	;;=S ^IBE(350.2,"C",$E(X,1,30),DA)=""
	;;^DD(350.2,.02,1,1,2)
	;;=K ^IBE(350.2,"C",$E(X,1,30),DA)
	;;^DD(350.2,.02,1,2,0)
	;;=350.2^AIVDT^MUMPS
	;;^DD(350.2,.02,1,2,1)
	;;=I $P(^IBE(350.2,DA,0),U,3) S ^IBE(350.2,"AIVDT",$P(^(0),U,3),-X,DA)=""
	;;^DD(350.2,.02,1,2,2)
	;;=I $P(^IBE(350.2,DA,0),U,3) K ^IBE(350.2,"AIVDT",$P(^(0),U,3),-X,DA)
	;;^DD(350.2,.02,21,0)
	;;=^^1^1^2910305^
	;;^DD(350.2,.02,21,1,0)
	;;=This is the date the charge rate for this entry became effective.
	;;^DD(350.2,.02,"DT")
	;;=2910206
	;;^DD(350.2,.03,0)
	;;=IB TRANSACTION TYPE^P350.1'^IBE(350.1,^0;3^Q
	;;^DD(350.2,.03,1,0)
	;;=^.1
	;;^DD(350.2,.03,1,1,0)
	;;=350.2^AIVDT1^MUMPS
	;;^DD(350.2,.03,1,1,1)
	;;=I $P(^IBE(350.2,DA,0),U,2) S ^IBE(350.2,"AIVDT",X,-$P(^(0),U,2),DA)=""
	;;^DD(350.2,.03,1,1,2)
	;;=I $P(^IBE(350.2,DA,0),U,2) K ^IBE(350.2,"AIVDT",X,-$P(^(0),U,2),DA)
	;;^DD(350.2,.03,21,0)
	;;=^^1^1^2910305^
	;;^DD(350.2,.03,21,1,0)
	;;=This is the IB TRANSACTION TYPE that this rate is for.
	;;^DD(350.2,.03,"DT")
	;;=2910206
	;;^DD(350.2,.04,0)
	;;=UNIT CHARGE, FIXED^NJ10,2^^0;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(350.2,.04,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(350.2,.04,21,0)
	;;=^^1^1^2910305^^
	;;^DD(350.2,.04,21,1,0)
	;;=If this charge is a fixed amount, this field contains the fixed amount.
	;;^DD(350.2,.05,0)
	;;=INACTIVATION DATE^D^^0;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.2,.05,3)
	;;=
	;;^DD(350.2,.05,21,0)
	;;=^^6^6^2910429^^
	;;^DD(350.2,.05,21,1,0)
	;;=If this charge is inactive put in the inactive date.  If the charge
	;;^DD(350.2,.05,21,2,0)
	;;=is not to be used the inactive date should equal the active date.  If
	;;^DD(350.2,.05,21,3,0)
	;;=the charge was effective for a time period but that charge no longer
