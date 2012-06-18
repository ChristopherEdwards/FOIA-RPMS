IBINI09P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(362.4,0,"GL")
	;;=^IBA(362.4,
	;;^DIC("B","IB BILL/CLAIMS PRESCRIPTION REFILL",362.4)
	;;=
	;;^DIC(362.4,"%D",0)
	;;=^^3^3^2940214^^
	;;^DIC(362.4,"%D",1,0)
	;;=This file contains all prescription refills for bills in the Bill/Claims file.
	;;^DIC(362.4,"%D",2,0)
	;;= 
	;;^DIC(362.4,"%D",3,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(362.4,0)
	;;=FIELD^^.03^8
	;;^DD(362.4,0,"DDA")
	;;=N
	;;^DD(362.4,0,"DT")
	;;=2940208
	;;^DD(362.4,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(362.4,0,"ID",.03)
	;;=W "   ",$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)
	;;^DD(362.4,0,"IX","AIFN",362.4,.01)
	;;=
	;;^DD(362.4,0,"IX","AIFN1",362.4,.02)
	;;=
	;;^DD(362.4,0,"IX","B",362.4,.01)
	;;=
	;;^DD(362.4,0,"IX","C",362.4,.02)
	;;=
	;;^DD(362.4,0,"NM","IB BILL/CLAIMS PRESCRIPTION REFILL")
	;;=
	;;^DD(362.4,.01,0)
	;;=RX #^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>11!($L(X)<1) X
	;;^DD(362.4,.01,1,0)
	;;=^.1
	;;^DD(362.4,.01,1,1,0)
	;;=362.4^B
	;;^DD(362.4,.01,1,1,1)
	;;=S ^IBA(362.4,"B",$E(X,1,30),DA)=""
	;;^DD(362.4,.01,1,1,2)
	;;=K ^IBA(362.4,"B",$E(X,1,30),DA)
	;;^DD(362.4,.01,1,2,0)
	;;=362.4^AIFN^MUMPS
	;;^DD(362.4,.01,1,2,1)
	;;=S:+$P(^IBA(362.4,+DA,0),U,2) ^IBA(362.4,"AIFN"_+$P(^(0),U,2),X,+DA)=""
	;;^DD(362.4,.01,1,2,2)
	;;=K:+$P(^IBA(362.4,+DA,0),U,2) ^IBA(362.4,"AIFN"_+$P(^(0),U,2),X,+DA)
	;;^DD(362.4,.01,1,2,"%D",0)
	;;=^^2^2^2931229^^
	;;^DD(362.4,.01,1,2,"%D",1,0)
	;;=Special x-ref set up specifically to provide a regular x-ref of a bill and
	;;^DD(362.4,.01,1,2,"%D",2,0)
	;;=all it's rx refills for easy look-up.
	;;^DD(362.4,.01,1,2,"DT")
	;;=2931229
	;;^DD(362.4,.01,1,3,0)
	;;=^^TRIGGER^362.4^.05
	;;^DD(362.4,.01,1,3,1)
	;;=Q
	;;^DD(362.4,.01,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(362.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(362.4,.01,1,3,2.4)
	;;^DD(362.4,.01,1,3,2.4)
	;;=S DIH=$S($D(^IBA(362.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=362.4,DIG=.05 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(362.4,.01,1,3,"%D",0)
	;;=^^1^1^2931229^
	;;^DD(362.4,.01,1,3,"%D",1,0)
	;;=Deletes the Prescription Record pointer if the Prescription Number is modified.
	;;^DD(362.4,.01,1,3,"CREATE VALUE")
	;;=NO EFFECT
	;;^DD(362.4,.01,1,3,"DELETE VALUE")
	;;=@
	;;^DD(362.4,.01,1,3,"DT")
	;;=2931229
	;;^DD(362.4,.01,1,3,"FIELD")
	;;=RECORD
	;;^DD(362.4,.01,3)
	;;=Answer must be 1-11 characters in length.
	;;^DD(362.4,.01,21,0)
	;;=^^1^1^2940223^^^^
	;;^DD(362.4,.01,21,1,0)
	;;=The prescription number for the refill.
	;;^DD(362.4,.01,23,0)
	;;=^^3^3^2940223^^^^
	;;^DD(362.4,.01,23,1,0)
	;;=A free text pointer (may correspond to 52,.01).  Because prescriptions 
	;;^DD(362.4,.01,23,2,0)
	;;=may be deleted from file 52 or prescriptions added that may not be from  
	;;^DD(362.4,.01,23,3,0)
	;;=outpatient pharmacy this may not be defined in the Prescription file (52).
	;;^DD(362.4,.01,"DT")
	;;=2931229
	;;^DD(362.4,.02,0)
	;;=BILL NUMBER^R*P399'^DGCR(399,^0;2^S DIC("S")="I $P(^(0),U,13)<3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(362.4,.02,1,0)
	;;=^.1
	;;^DD(362.4,.02,1,1,0)
	;;=362.4^AIFN1^MUMPS
	;;^DD(362.4,.02,1,1,1)
	;;=S ^IBA(362.4,"AIFN"_X,$P(^IBA(362.4,+DA,0),U,1),DA)=""
	;;^DD(362.4,.02,1,1,2)
	;;=K ^IBA(362.4,"AIFN"_X,$P(^IBA(362.4,+DA,0),U,1),DA)
	;;^DD(362.4,.02,1,1,"%D",0)
	;;=^^2^2^2931229^^^
	;;^DD(362.4,.02,1,1,"%D",1,0)
	;;=Special x-ref set up specifically to provide a regular x-ref of a bill and
