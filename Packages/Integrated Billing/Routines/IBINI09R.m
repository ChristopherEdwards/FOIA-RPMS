IBINI09R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(362.5,0,"GL")
	;;=^IBA(362.5,
	;;^DIC("B","IB BILL/CLAIMS PROSTHETICS",362.5)
	;;=
	;;^DIC(362.5,"%D",0)
	;;=^^3^3^2940214^^
	;;^DIC(362.5,"%D",1,0)
	;;=This file contains all prosthetic items for bills in the Bill/Claims file.
	;;^DIC(362.5,"%D",2,0)
	;;= 
	;;^DIC(362.5,"%D",3,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(362.5,0)
	;;=FIELD^^.04^4
	;;^DD(362.5,0,"DDA")
	;;=N
	;;^DD(362.5,0,"DT")
	;;=2931229
	;;^DD(362.5,0,"IX","AIFN",362.5,.01)
	;;=
	;;^DD(362.5,0,"IX","AIFN1",362.5,.02)
	;;=
	;;^DD(362.5,0,"IX","B",362.5,.01)
	;;=
	;;^DD(362.5,0,"NM","IB BILL/CLAIMS PROSTHETICS")
	;;=
	;;^DD(362.5,.01,0)
	;;=DELIVERY DATE^RD^^0;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(362.5,.01,1,0)
	;;=^.1
	;;^DD(362.5,.01,1,1,0)
	;;=362.5^B
	;;^DD(362.5,.01,1,1,1)
	;;=S ^IBA(362.5,"B",$E(X,1,30),DA)=""
	;;^DD(362.5,.01,1,1,2)
	;;=K ^IBA(362.5,"B",$E(X,1,30),DA)
	;;^DD(362.5,.01,1,2,0)
	;;=362.5^AIFN^MUMPS
	;;^DD(362.5,.01,1,2,1)
	;;=S:+$P(^IBA(362.5,+DA,0),U,2) ^IBA(362.5,"AIFN"_+$P(^(0),U,2),+X,+DA)=""
	;;^DD(362.5,.01,1,2,2)
	;;=K:+$P(^IBA(362.5,+DA,0),U,2) ^IBA(362.5,"AIFN"_+$P(^(0),U,2),+X,+DA)
	;;^DD(362.5,.01,1,2,"%D",0)
	;;=^^1^1^2931228^
	;;^DD(362.5,.01,1,2,"%D",1,0)
	;;=Set-up for quick cross reference of all prosthetic devices on a bill.
	;;^DD(362.5,.01,1,2,"DT")
	;;=2931228
	;;^DD(362.5,.01,1,3,0)
	;;=^^TRIGGER^362.5^.04
	;;^DD(362.5,.01,1,3,1)
	;;=Q
	;;^DD(362.5,.01,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(362.5,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(362.5,.01,1,3,2.4)
	;;^DD(362.5,.01,1,3,2.4)
	;;=S DIH=$S($D(^IBA(362.5,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,4)=DIV,DIH=362.5,DIG=.04 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(362.5,.01,1,3,"%D",0)
	;;=^^3^3^2931229^
	;;^DD(362.5,.01,1,3,"%D",1,0)
	;;=Deletes
	;;^DD(362.5,.01,1,3,"%D",2,0)
	;;=the Prescription Transaction Record pointer if the Delivery Date is 
	;;^DD(362.5,.01,1,3,"%D",3,0)
	;;=changed.
	;;^DD(362.5,.01,1,3,"CREATE VALUE")
	;;=NO EFFECT
	;;^DD(362.5,.01,1,3,"DELETE VALUE")
	;;=@
	;;^DD(362.5,.01,1,3,"DT")
	;;=2931229
	;;^DD(362.5,.01,1,3,"FIELD")
	;;=record
	;;^DD(362.5,.01,3)
	;;=Enter the date the item was delivered to the patient.
	;;^DD(362.5,.01,21,0)
	;;=^^2^2^2931229^^
	;;^DD(362.5,.01,21,1,0)
	;;=This is the date the prosthetic item was delivered and accepted by the
	;;^DD(362.5,.01,21,2,0)
	;;=patient.
	;;^DD(362.5,.01,"DT")
	;;=2931229
	;;^DD(362.5,.02,0)
	;;=BILL NUMBER^R*P399'^DGCR(399,^0;2^S DIC("S")="I $P(^(0),U,13)<3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(362.5,.02,1,0)
	;;=^.1
	;;^DD(362.5,.02,1,1,0)
	;;=362.5^AIFN1^MUMPS
	;;^DD(362.5,.02,1,1,1)
	;;=S ^IBA(362.5,"AIFN"_+X,+^IBA(362.5,+DA,0),DA)=""
	;;^DD(362.5,.02,1,1,2)
	;;=K ^IBA(362.5,"AIFN"_+X,+^IBA(362.5,+DA,0),DA)
	;;^DD(362.5,.02,1,1,"%D",0)
	;;=^^1^1^2931228^
	;;^DD(362.5,.02,1,1,"%D",1,0)
	;;=Set-up for quick cross reference of all prosthetic devices on a bill.
	;;^DD(362.5,.02,1,1,"DT")
	;;=2931228
	;;^DD(362.5,.02,3)
	;;=The bill number associated with this prosthetic item.
	;;^DD(362.5,.02,12)
	;;=Only open biils!
	;;^DD(362.5,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,13)<3"
	;;^DD(362.5,.02,"DT")
	;;=2931228
	;;^DD(362.5,.03,0)
	;;=ITEM^RP661'^RMPR(661,^0;3^Q
	;;^DD(362.5,.03,3)
	;;=Enter the prosthetic item to be added to this bill.
	;;^DD(362.5,.03,21,0)
	;;=^^1^1^2931229^^^^
	;;^DD(362.5,.03,21,1,0)
	;;=The prosthetic item added to the bill.
	;;^DD(362.5,.03,23,0)
	;;=^^2^2^2931229^^^
	;;^DD(362.5,.03,23,1,0)
	;;=This should be automatically set by the system if a prosthetic record
