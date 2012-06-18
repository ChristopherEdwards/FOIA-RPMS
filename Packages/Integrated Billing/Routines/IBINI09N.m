IBINI09N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(362.3,0,"GL")
	;;=^IBA(362.3,
	;;^DIC("B","IB BILL/CLAIMS DIAGNOSIS",362.3)
	;;=
	;;^DIC(362.3,"%D",0)
	;;=^^3^3^2940214^^^^
	;;^DIC(362.3,"%D",1,0)
	;;=This file contains all diagnoses for bills in the Bill/Claims file.
	;;^DIC(362.3,"%D",2,0)
	;;= 
	;;^DIC(362.3,"%D",3,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(362.3,0)
	;;=FIELD^^.01^3
	;;^DD(362.3,0,"DDA")
	;;=N
	;;^DD(362.3,0,"DT")
	;;=2931229
	;;^DD(362.3,0,"ID",.02)
	;;=W ""
	;;^DD(362.3,0,"IX","AIFN",362.3,.01)
	;;=
	;;^DD(362.3,0,"IX","AIFN1",362.3,.02)
	;;=
	;;^DD(362.3,0,"IX","AO",362.3,.02)
	;;=
	;;^DD(362.3,0,"IX","AO1",362.3,.03)
	;;=
	;;^DD(362.3,0,"IX","B",362.3,.01)
	;;=
	;;^DD(362.3,0,"NM","IB BILL/CLAIMS DIAGNOSIS")
	;;=
	;;^DD(362.3,0,"PT",399.0304,10)
	;;=
	;;^DD(362.3,0,"PT",399.0304,11)
	;;=
	;;^DD(362.3,0,"PT",399.0304,12)
	;;=
	;;^DD(362.3,0,"PT",399.0304,13)
	;;=
	;;^DD(362.3,.01,0)
	;;=DIAGNOSIS^R*P80'^ICD9(^0;1^S DIC("S")="I '$P(^(0),U,9),'$$DXDUP^IBCU1(+Y,$G(DA)),$$DXBSTAT^IBCU1($G(DA))<3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(362.3,.01,1,0)
	;;=^.1^^-1
	;;^DD(362.3,.01,1,1,0)
	;;=362.3^B
	;;^DD(362.3,.01,1,1,1)
	;;=S ^IBA(362.3,"B",$E(X,1,30),DA)=""
	;;^DD(362.3,.01,1,1,2)
	;;=K ^IBA(362.3,"B",$E(X,1,30),DA)
	;;^DD(362.3,.01,1,2,0)
	;;=362.3^AIFN^MUMPS
	;;^DD(362.3,.01,1,2,1)
	;;=S:+$P(^IBA(362.3,DA,0),U,2) ^IBA(362.3,"AIFN"_+$P(^(0),U,2),+X,DA)=""
	;;^DD(362.3,.01,1,2,2)
	;;=K:+$P(^IBA(362.3,DA,0),U,2) ^IBA(362.3,"AIFN"_+$P(^(0),U,2),+X,DA)
	;;^DD(362.3,.01,1,2,"%D",0)
	;;=^^2^2^2940214^^^^
	;;^DD(362.3,.01,1,2,"%D",1,0)
	;;=Special x-ref set up specifically to provide a regular x-ref of a bill and
	;;^DD(362.3,.01,1,2,"%D",2,0)
	;;=all it's diagnoses for easy look-up.
	;;^DD(362.3,.01,1,2,"DT")
	;;=2931117
	;;^DD(362.3,.01,3)
	;;=Enter a diagnosis for this bill.  Duplicates are not allowed.
	;;^DD(362.3,.01,4)
	;;=D HELP^IBCSC4D
	;;^DD(362.3,.01,12)
	;;=Only active diagnosis, no duplicates for a bill, and bill must not be authorized or cancelled.
	;;^DD(362.3,.01,12.1)
	;;=S DIC("S")="I '$P(^(0),U,9),'$$DXDUP^IBCU1(+Y,$G(DA)),$$DXBSTAT^IBCU1($G(DA))<3"
	;;^DD(362.3,.01,21,0)
	;;=^^1^1^2931123^^^^
	;;^DD(362.3,.01,21,1,0)
	;;=Enter an active diagnosis for this bill.
	;;^DD(362.3,.01,23,0)
	;;=^^1^1^2931123^^^^
	;;^DD(362.3,.01,23,1,0)
	;;=All diagnosis for a bill are stored here, beginning with IB v2.0.
	;;^DD(362.3,.01,"DT")
	;;=2931123
	;;^DD(362.3,.02,0)
	;;=BILL NUMBER^R*P399'^DGCR(399,^0;2^S DIC("S")="I $P(^(0),U,13)<3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(362.3,.02,1,0)
	;;=^.1
	;;^DD(362.3,.02,1,1,0)
	;;=362.3^AIFN1^MUMPS
	;;^DD(362.3,.02,1,1,1)
	;;=S ^IBA(362.3,"AIFN"_X,+^IBA(362.3,DA,0),DA)=""
	;;^DD(362.3,.02,1,1,2)
	;;=K ^IBA(362.3,"AIFN"_X,+^IBA(362.3,DA,0),DA)
	;;^DD(362.3,.02,1,1,"%D",0)
	;;=^^2^2^2940214^^^
	;;^DD(362.3,.02,1,1,"%D",1,0)
	;;=Special x-ref set up specifically to provide a regular x-ref of a bill and
	;;^DD(362.3,.02,1,1,"%D",2,0)
	;;=all it's diagnoses for easy look-up.
	;;^DD(362.3,.02,1,1,"DT")
	;;=2931117
	;;^DD(362.3,.02,1,2,0)
	;;=362.3^AO^MUMPS
	;;^DD(362.3,.02,1,2,1)
	;;=S:+$P(^IBA(362.3,DA,0),U,3) ^IBA(362.3,"AO",+X,+$P(^(0),U,3),DA)=""
	;;^DD(362.3,.02,1,2,2)
	;;=K:+$P(^IBA(362.3,DA,0),U,3) ^IBA(362.3,"AO",+X,+$P(^(0),U,3),DA)
	;;^DD(362.3,.02,1,2,"%D",0)
	;;=^^1^1^2931117^
	;;^DD(362.3,.02,1,2,"%D",1,0)
	;;=Print order by bill, used to prevent duplicate print orders for a bill.
	;;^DD(362.3,.02,1,2,"DT")
	;;=2931117
	;;^DD(362.3,.02,1,3,0)
	;;=^^TRIGGER^362.3^.03
	;;^DD(362.3,.02,1,3,1)
	;;~K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBA(362.3,D0,0)):^(0),1:"") S X=$P(Y(1),U,3)="" I X S X=DIV S Y(1)=$S($D(^IBA(362.3,D0,0)):^(0),1:"") S X=$
	;;=P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=$$ORDNXT^IBCU1(+X) X ^DD(362.3,.02,1,3,1.4)
