IBINI059	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.7,0,"GL")
	;;=^IBA(355.7,
	;;^DIC("B","PERSONAL POLICY",355.7)
	;;=
	;;^DIC(355.7,"%D",0)
	;;=^^5^5^2940214^^^^
	;;^DIC(355.7,"%D",1,0)
	;;=This file contains the insurance riders that have been purchased as
	;;^DIC(355.7,"%D",2,0)
	;;=add on coverage to a group plan.  This information is used internally
	;;^DIC(355.7,"%D",3,0)
	;;=for display purposes only.  
	;;^DIC(355.7,"%D",4,0)
	;;= 
	;;^DIC(355.7,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.7,0)
	;;=FIELD^^.03^3
	;;^DD(355.7,0,"DDA")
	;;=N
	;;^DD(355.7,0,"DT")
	;;=2931129
	;;^DD(355.7,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DPT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(355.7,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(355.7,0,"IX","AC",355.7,.02)
	;;=
	;;^DD(355.7,0,"IX","APP",355.7,.01)
	;;=
	;;^DD(355.7,0,"IX","APP1",355.7,.02)
	;;=
	;;^DD(355.7,0,"IX","APP2",355.7,.03)
	;;=
	;;^DD(355.7,0,"IX","B",355.7,.01)
	;;=
	;;^DD(355.7,0,"NM","PERSONAL POLICY")
	;;=
	;;^DD(355.7,.01,0)
	;;=RIDER^RP355.6'^IBE(355.6,^0;1^Q
	;;^DD(355.7,.01,1,0)
	;;=^.1
	;;^DD(355.7,.01,1,1,0)
	;;=355.7^B
	;;^DD(355.7,.01,1,1,1)
	;;=S ^IBA(355.7,"B",$E(X,1,30),DA)=""
	;;^DD(355.7,.01,1,1,2)
	;;=K ^IBA(355.7,"B",$E(X,1,30),DA)
	;;^DD(355.7,.01,1,2,0)
	;;=355.7^APP^MUMPS
	;;^DD(355.7,.01,1,2,1)
	;;=S:$P(^IBA(355.7,DA,0),U,2)&($P(^(0),U,3)) ^IBA(355.7,"APP",+$P(^(0),U,2),+$P(^(0),U,3),X,DA)=""
	;;^DD(355.7,.01,1,2,2)
	;;=K ^IBA(355.7,"APP",+$P(^IBA(355.7,DA,0),U,2),+$P(^(0),U,3),X,DA)
	;;^DD(355.7,.01,1,2,"%D",0)
	;;=^^2^2^2931129^^
	;;^DD(355.7,.01,1,2,"%D",1,0)
	;;=Cross reference of riders by patient, policy, rider.  Used to make sure
	;;^DD(355.7,.01,1,2,"%D",2,0)
	;;=only one entry for each policy.
	;;^DD(355.7,.01,1,2,"DT")
	;;=2931129
	;;^DD(355.7,.01,3)
	;;=
	;;^DD(355.7,.01,21,0)
	;;=^^4^4^2931129^
	;;^DD(355.7,.01,21,1,0)
	;;=Select the Insurance Rider that best describes the personal rider you are
	;;^DD(355.7,.01,21,2,0)
	;;=adding or editing for this patient.  A personal rider is add-on coverage
	;;^DD(355.7,.01,21,3,0)
	;;=that an individual may purchase as part of their group plan but is
	;;^DD(355.7,.01,21,4,0)
	;;=has additional cost.
	;;^DD(355.7,.01,"DT")
	;;=2931130
	;;^DD(355.7,.02,0)
	;;=PATIENT^P2'^DPT(^0;2^Q
	;;^DD(355.7,.02,1,0)
	;;=^.1
	;;^DD(355.7,.02,1,1,0)
	;;=355.7^AC
	;;^DD(355.7,.02,1,1,1)
	;;=S ^IBA(355.7,"AC",$E(X,1,30),DA)=""
	;;^DD(355.7,.02,1,1,2)
	;;=K ^IBA(355.7,"AC",$E(X,1,30),DA)
	;;^DD(355.7,.02,1,1,"DT")
	;;=2931130
	;;^DD(355.7,.02,1,2,0)
	;;=355.7^APP1^MUMPS
	;;^DD(355.7,.02,1,2,1)
	;;=S:$P(^IBA(355.7,DA,0),U,3) ^IBA(355.7,"APP",X,+$P(^(0),U,3),+^(0),DA)=""
	;;^DD(355.7,.02,1,2,2)
	;;=K ^IBA(355.7,"APP",X,+$P(^IBA(355.7,DA,0),U,3),+^(0),DA)
	;;^DD(355.7,.02,1,2,"%D",0)
	;;=^^2^2^2931129^
	;;^DD(355.7,.02,1,2,"%D",1,0)
	;;=Cross reference of riders by patient, policy, rider.  Used to make sure
	;;^DD(355.7,.02,1,2,"%D",2,0)
	;;=only one entry for each policy.
	;;^DD(355.7,.02,1,2,"DT")
	;;=2931129
	;;^DD(355.7,.02,21,0)
	;;=^^3^3^2940213^^
	;;^DD(355.7,.02,21,1,0)
	;;=Select the patient that this is a rider for.
	;;^DD(355.7,.02,21,2,0)
	;;=For any patients' policy there may be a number of riders associated
	;;^DD(355.7,.02,21,3,0)
	;;=with it.
	;;^DD(355.7,.02,"DT")
	;;=2931130
	;;^DD(355.7,.03,0)
	;;=HEALTH INSURANCE POLICY^FXO^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1) X S:$D(X) X=$$SEL^IBTRC2(X,$P(^IBA(355.7,DA,0),"^",2),DT,2)
	;;^DD(355.7,.03,1,0)
	;;=^.1
