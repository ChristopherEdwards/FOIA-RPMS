IBINI01Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.4,0,"GL")
	;;=^IBE(350.4,
	;;^DIC("B","BILLABLE AMBULATORY SURGICAL CODE",350.4)
	;;=
	;;^DIC(350.4,"%D",0)
	;;=^^10^10^2940214^^^^
	;;^DIC(350.4,"%D",1,0)
	;;=Contains the HCFA rate groups for ambulatory surgeries that may
	;;^DIC(350.4,"%D",2,0)
	;;=be billed.  This file is time sensitive, a procedure may have multiple entries
	;;^DIC(350.4,"%D",3,0)
	;;=indicating updates effective on different dates.  These updates include a
	;;^DIC(350.4,"%D",4,0)
	;;=procedure changing rate groups or changing status.
	;;^DIC(350.4,"%D",5,0)
	;;= 
	;;^DIC(350.4,"%D",6,0)
	;;=The data in this file is either transfered from 350.41 or 
	;;^DIC(350.4,"%D",7,0)
	;;=entered interactively and is used to calculate the charge for a procedure
	;;^DIC(350.4,"%D",8,0)
	;;=on any given date.
	;;^DIC(350.4,"%D",9,0)
	;;= 
	;;^DIC(350.4,"%D",10,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.4,0)
	;;=FIELD^^.04^4
	;;^DD(350.4,0,"DDA")
	;;=N
	;;^DD(350.4,0,"DT")
	;;=2920108
	;;^DD(350.4,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^SD(409.71,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(409.71,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(350.4,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(350.1,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(350.1,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(350.4,0,"IX","AIVDT",350.4,.01)
	;;=
	;;^DD(350.4,0,"IX","AIVDT1",350.4,.02)
	;;=
	;;^DD(350.4,0,"IX","B",350.4,.01)
	;;=
	;;^DD(350.4,0,"IX","C",350.4,.02)
	;;=
	;;^DD(350.4,0,"NM","BILLABLE AMBULATORY SURGICAL CODE")
	;;=
	;;^DD(350.4,.01,0)
	;;=EFFECTIVE DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.4,.01,1,0)
	;;=^.1
	;;^DD(350.4,.01,1,1,0)
	;;=350.4^B
	;;^DD(350.4,.01,1,1,1)
	;;=S ^IBE(350.4,"B",$E(X,1,30),DA)=""
	;;^DD(350.4,.01,1,1,2)
	;;=K ^IBE(350.4,"B",$E(X,1,30),DA)
	;;^DD(350.4,.01,1,2,0)
	;;=350.4^AIVDT^MUMPS
	;;^DD(350.4,.01,1,2,1)
	;;=I $P(^IBE(350.4,DA,0),"^",2) S ^IBE(350.4,"AIVDT",$P(^(0),"^",2),-X,DA)=""
	;;^DD(350.4,.01,1,2,2)
	;;=I $P(^IBE(350.4,DA,0),"^",2) K ^IBE(350.4,"AIVDT",$P(^(0),"^",2),-X,DA)
	;;^DD(350.4,.01,1,2,3)
	;;=DO NOT DELETE
	;;^DD(350.4,.01,1,2,"%D",0)
	;;=^^2^2^2911119^^^
	;;^DD(350.4,.01,1,2,"%D",1,0)
	;;=This cross reference is used to find the correct rate group for a 
	;;^DD(350.4,.01,1,2,"%D",2,0)
	;;=procedure on a particular date.
	;;^DD(350.4,.01,1,2,"DT")
	;;=2910829
	;;^DD(350.4,.01,3)
	;;=Enter the date that this new STATUS/RATE GROUP becomes effective.
	;;^DD(350.4,.01,21,0)
	;;=^^2^2^2920415^^^^
	;;^DD(350.4,.01,21,1,0)
	;;=This is the date when the new status or rate group for a procedure
	;;^DD(350.4,.01,21,2,0)
	;;=becomes effective.
	;;^DD(350.4,.01,"DT")
	;;=2910829
	;;^DD(350.4,.02,0)
	;;=PROCEDURE^P409.71'^SD(409.71,^0;2^Q
	;;^DD(350.4,.02,1,0)
	;;=^.1
	;;^DD(350.4,.02,1,1,0)
	;;=350.4^C
	;;^DD(350.4,.02,1,1,1)
	;;=S ^IBE(350.4,"C",$E(X,1,30),DA)=""
	;;^DD(350.4,.02,1,1,2)
	;;=K ^IBE(350.4,"C",$E(X,1,30),DA)
	;;^DD(350.4,.02,1,1,3)
	;;=DO NOT DELETE
	;;^DD(350.4,.02,1,1,"DT")
	;;=2910830
	;;^DD(350.4,.02,1,2,0)
	;;=350.4^AIVDT1^MUMPS
	;;^DD(350.4,.02,1,2,1)
	;;=I $P(^IBE(350.4,DA,0),"^") S ^IBE(350.4,"AIVDT",X,-$P(^(0),"^"),DA)=""
	;;^DD(350.4,.02,1,2,2)
	;;=I $P(^IBE(350.4,DA,0),"^") K ^IBE(350.4,"AIVDT",X,-$P(^(0),"^"),DA)
	;;^DD(350.4,.02,1,2,3)
	;;=DO NOT DELETE
	;;^DD(350.4,.02,1,2,"%D",0)
	;;=^^1^1^2911113^
	;;^DD(350.4,.02,1,2,"%D",1,0)
	;;=Used to find the correct rate group for a procedure on any particular date.
	;;^DD(350.4,.02,1,2,"DT")
	;;=2910830
