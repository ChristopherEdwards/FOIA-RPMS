IBINI04J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.2,0,"GL")
	;;=^IBE(355.2,
	;;^DIC("B","TYPE OF INSURANCE COVERAGE",355.2)
	;;=
	;;^DIC(355.2,"%D",0)
	;;=^^8^8^2940214^^^^
	;;^DIC(355.2,"%D",1,0)
	;;=This file contains the types of coverages that an insurance company is
	;;^DIC(355.2,"%D",2,0)
	;;=generally associated with.  If an insurer is identified with more than 
	;;^DIC(355.2,"%D",3,0)
	;;=one type of coverage then  it should be identified as HEALTH INSURANCE as
	;;^DIC(355.2,"%D",4,0)
	;;=this encompases all.
	;;^DIC(355.2,"%D",5,0)
	;;= 
	;;^DIC(355.2,"%D",6,0)
	;;=Sites should not add, edit or delete entries from this file.
	;;^DIC(355.2,"%D",7,0)
	;;= 
	;;^DIC(355.2,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.2,0)
	;;=FIELD^^10^3
	;;^DD(355.2,0,"DDA")
	;;=N
	;;^DD(355.2,0,"DT")
	;;=2930603
	;;^DD(355.2,0,"IX","B",355.2,.01)
	;;=
	;;^DD(355.2,0,"IX","C",355.2,.02)
	;;=
	;;^DD(355.2,0,"NM","TYPE OF INSURANCE COVERAGE")
	;;=
	;;^DD(355.2,0,"PT",36,.13)
	;;=
	;;^DD(355.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(355.2,.01,1,0)
	;;=^.1
	;;^DD(355.2,.01,1,1,0)
	;;=355.2^B
	;;^DD(355.2,.01,1,1,1)
	;;=S ^IBE(355.2,"B",$E(X,1,30),DA)=""
	;;^DD(355.2,.01,1,1,2)
	;;=K ^IBE(355.2,"B",$E(X,1,30),DA)
	;;^DD(355.2,.01,3)
	;;=This is the name of the type of policy.  Answer must be 3-30 characters in length.
	;;^DD(355.2,.01,21,0)
	;;=^^16^16^2940213^^^^
	;;^DD(355.2,.01,21,1,0)
	;;=This is name of the type of coverage that an insurance company generally
	;;^DD(355.2,.01,21,2,0)
	;;=provides.  The entries in this file are a limited set of choices
	;;^DD(355.2,.01,21,3,0)
	;;=that are exported with the IB package.  The entries may have special
	;;^DD(355.2,.01,21,4,0)
	;;=meaning interanally in the billing package.
	;;^DD(355.2,.01,21,5,0)
	;;= 
	;;^DD(355.2,.01,21,6,0)
	;;=If this insurance carrier provides only one type of coverage then select
	;;^DD(355.2,.01,21,7,0)
	;;=the entry that best describes this carriers' type of coverage.  If this
	;;^DD(355.2,.01,21,8,0)
	;;=carrier provides more than one type of coverage then select HEALTH
	;;^DD(355.2,.01,21,9,0)
	;;=INSURANCE.  The default answer if left unanswered is Health Insurance.
	;;^DD(355.2,.01,21,10,0)
	;;= 
	;;^DD(355.2,.01,21,11,0)
	;;=This is useful information when contacting carriers, when creating 
	;;^DD(355.2,.01,21,12,0)
	;;=claims for reimbursement and when estimating if the payment received is
	;;^DD(355.2,.01,21,13,0)
	;;=appropriate.
	;;^DD(355.2,.01,21,14,0)
	;;= 
	;;^DD(355.2,.01,21,15,0)
	;;=If this field is answered it may affect choices that can be selected when
	;;^DD(355.2,.01,21,16,0)
	;;=entering policy or benefit information.
	;;^DD(355.2,.01,"DT")
	;;=2930603
	;;^DD(355.2,.02,0)
	;;=ABBREVIATION^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>8!($L(X)<2) X
	;;^DD(355.2,.02,1,0)
	;;=^.1
	;;^DD(355.2,.02,1,1,0)
	;;=355.2^C
	;;^DD(355.2,.02,1,1,1)
	;;=S ^IBE(355.2,"C",$E(X,1,30),DA)=""
	;;^DD(355.2,.02,1,1,2)
	;;=K ^IBE(355.2,"C",$E(X,1,30),DA)
	;;^DD(355.2,.02,1,1,"DT")
	;;=2930602
	;;^DD(355.2,.02,3)
	;;=Enter a standard abbreviation.  Answer must be 2-8 characters in length.
	;;^DD(355.2,.02,21,0)
	;;=^^3^3^2930603^^
	;;^DD(355.2,.02,21,1,0)
	;;=This is the standard abbreviation for this type of coverage.  Enter
	;;^DD(355.2,.02,21,2,0)
	;;=the 2 to 8 character abbreviation.  The abbreviation may appear on 
	;;^DD(355.2,.02,21,3,0)
	;;=reports that have limited space available.
	;;^DD(355.2,.02,"DT")
	;;=2930602
	;;^DD(355.2,10,0)
	;;=DESCRIPTION^355.21^^10;0
	;;^DD(355.2,10,21,0)
	;;=^^1^1^2930603^^
