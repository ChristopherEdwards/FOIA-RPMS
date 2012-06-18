IBINI05Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.2,0,"GL")
	;;=^IBT(356.2,
	;;^DIC("B","INSURANCE REVIEW",356.2)
	;;=
	;;^DIC(356.2,"%D",0)
	;;=^^10^10^2940214^^^^
	;;^DIC(356.2,"%D",1,0)
	;;=This file contains information about the MCCR/UR portion of Utilization
	;;^DIC(356.2,"%D",2,0)
	;;=Review and the associated contacts with Insurance Carriers.  Appropriateness
	;;^DIC(356.2,"%D",3,0)
	;;=of care is inferred from the approval and denial of billing days by
	;;^DIC(356.2,"%D",4,0)
	;;=the insurance carriers UR section.  
	;;^DIC(356.2,"%D",5,0)
	;;= 
	;;^DIC(356.2,"%D",6,0)
	;;=While this information appears to be primarily administrative in nature
	;;^DIC(356.2,"%D",7,0)
	;;=it may contain sensitive clinical information and should be treated with
	;;^DIC(356.2,"%D",8,0)
	;;=the same confidentiality as required of all clinical data.
	;;^DIC(356.2,"%D",9,0)
	;;= 
	;;^DIC(356.2,"%D",10,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.2,0)
	;;=FIELD^^1.07^40
	;;^DD(356.2,0,"DT")
	;;=2940127
	;;^DD(356.2,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBT(356,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.2,0,"ID",.04)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(356.11,+$P(^(0),U,4),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356.11,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.2,0,"ID",.05)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DPT(+$P(^(0),U,5),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.2,0,"ID",.08)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DIC(36,+$P(^(0),U,8),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(36,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.2,0,"ID",1.05)
	;;=W ""
	;;^DD(356.2,0,"IX","AC",356.2,.04)
	;;=
	;;^DD(356.2,0,"IX","ACT",356.2,.11)
	;;=
	;;^DD(356.2,0,"IX","AD",356.2,.03)
	;;=
	;;^DD(356.2,0,"IX","ADFN",356.2,.05)
	;;=
	;;^DD(356.2,0,"IX","ADFN1",356.2,.01)
	;;=
	;;^DD(356.2,0,"IX","AE",356.2,.19)
	;;=
	;;^DD(356.2,0,"IX","AIACT",356.2,.08)
	;;=
	;;^DD(356.2,0,"IX","AIACT1",356.2,.11)
	;;=
	;;^DD(356.2,0,"IX","AP",356.2,.18)
	;;=
	;;^DD(356.2,0,"IX","APACT",356.2,.05)
	;;=
	;;^DD(356.2,0,"IX","APACT1",356.2,.11)
	;;=
	;;^DD(356.2,0,"IX","APEND",356.2,.24)
	;;=
	;;^DD(356.2,0,"IX","APRE",356.2,.02)
	;;=
	;;^DD(356.2,0,"IX","APRE1",356.2,.28)
	;;=
	;;^DD(356.2,0,"IX","ATIDT",356.2,.01)
	;;=
	;;^DD(356.2,0,"IX","ATIDT1",356.2,.02)
	;;=
	;;^DD(356.2,0,"IX","ATRP",356.2,.02)
	;;=
	;;^DD(356.2,0,"IX","ATRTP1",356.2,.04)
	;;=
	;;^DD(356.2,0,"IX","B",356.2,.01)
	;;=
	;;^DD(356.2,0,"IX","C",356.2,.02)
	;;=
	;;^DD(356.2,0,"IX","D",356.2,.05)
	;;=
	;;^DD(356.2,0,"NM","INSURANCE REVIEW")
	;;=
	;;^DD(356.2,0,"PT",356.2,.18)
	;;=
	;;^DD(356.2,.01,0)
	;;=REVIEW DATE^RD^^0;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.2,.01,1,0)
	;;=^.1
	;;^DD(356.2,.01,1,1,0)
	;;=356.2^B
	;;^DD(356.2,.01,1,1,1)
	;;=S ^IBT(356.2,"B",$E(X,1,30),DA)=""
	;;^DD(356.2,.01,1,1,2)
	;;=K ^IBT(356.2,"B",$E(X,1,30),DA)
	;;^DD(356.2,.01,1,2,0)
	;;=356.2^ATIDT^MUMPS
	;;^DD(356.2,.01,1,2,1)
	;;=S:$P(^IBT(356.2,DA,0),U,2) ^IBT(356.2,"ATIDT",+$P(^(0),U,2),-X,DA)=""
	;;^DD(356.2,.01,1,2,2)
	;;=K ^IBT(356.2,"ATIDT",+$P(^IBT(356.2,DA,0),U,2),-X,DA)
	;;^DD(356.2,.01,1,2,"%D",0)
	;;=^^2^2^2930818^^
	;;^DD(356.2,.01,1,2,"%D",1,0)
	;;=Cross-Reference of all entries by tracking ID and by inverse date so can
	;;^DD(356.2,.01,1,2,"%D",2,0)
	;;=list most recent first.
	;;^DD(356.2,.01,1,2,"DT")
	;;=2930818
	;;^DD(356.2,.01,1,3,0)
	;;=356.2^ADFN1^MUMPS
