IBINI09L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(362.1,0,"GL")
	;;=^IBA(362.1,
	;;^DIC("B","IB AUTOMATED BILLING COMMENTS",362.1)
	;;=
	;;^DIC(362.1,"%D",0)
	;;=^^22^22^2940214^^^
	;;^DIC(362.1,"%D",1,0)
	;;=This file contains entries created by the Third Party automated biller.
	;;^DIC(362.1,"%D",2,0)
	;;=As the auto biller attempts to create bills based on events in Claims
	;;^DIC(362.1,"%D",3,0)
	;;=Tracking it sets entries in this file indicating the action taken by the
	;;^DIC(362.1,"%D",4,0)
	;;=auto biller for the event.  The only way entries are added to this
	;;^DIC(362.1,"%D",5,0)
	;;=file is by the auto biller, there is no user entry.
	;;^DIC(362.1,"%D",6,0)
	;;= 
	;;^DIC(362.1,"%D",7,0)
	;;=An entry may be created for the event if a bill could not be created, this
	;;^DIC(362.1,"%D",8,0)
	;;=entry will contain a comment on why the bill could not be created.
	;;^DIC(362.1,"%D",9,0)
	;;=If the Claims Tracking event could not be billed because the Earliest
	;;^DIC(362.1,"%D",10,0)
	;;=Auto Bill date did not match the time frame set by the parameters, no
	;;^DIC(362.1,"%D",11,0)
	;;=entry is made in this file but the events Earliest Auto Bill Date is 
	;;^DIC(362.1,"%D",12,0)
	;;=reset.
	;;^DIC(362.1,"%D",13,0)
	;;=An entry will be created for every event that a bill was created for, in
	;;^DIC(362.1,"%D",14,0)
	;;=some cases these entries will have comments about the event that may be of
	;;^DIC(362.1,"%D",15,0)
	;;=interest to billing the event.
	;;^DIC(362.1,"%D",16,0)
	;;= 
	;;^DIC(362.1,"%D",17,0)
	;;=Entries are deleted from this file in two ways.  Entries for events that
	;;^DIC(362.1,"%D",18,0)
	;;=were billed are only deleted by the system, when the bill is either 
	;;^DIC(362.1,"%D",19,0)
	;;=cancelled or authorized.  Entries without corresponding bills must be 
	;;^DIC(362.1,"%D",20,0)
	;;=manually deleted by a user, with the option provided.
	;;^DIC(362.1,"%D",21,0)
	;;= 
	;;^DIC(362.1,"%D",22,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(362.1,0)
	;;=FIELD^^11^5
	;;^DD(362.1,0,"DDA")
	;;=N
	;;^DD(362.1,0,"DT")
	;;=2930903
	;;^DD(362.1,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBT(356,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(362.1,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(362.1,0,"IX","B",362.1,.01)
	;;=
	;;^DD(362.1,0,"IX","C",362.1,.02)
	;;=
	;;^DD(362.1,0,"IX","D",362.1,.03)
	;;=
	;;^DD(362.1,0,"NM","IB AUTOMATED BILLING COMMENTS")
	;;=
	;;^DD(362.1,.01,0)
	;;=NUMBER^RNJ3,0^^0;1^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(362.1,.01,1,0)
	;;=^.1
	;;^DD(362.1,.01,1,1,0)
	;;=362.1^B
	;;^DD(362.1,.01,1,1,1)
	;;=S ^IBA(362.1,"B",$E(X,1,30),DA)=""
	;;^DD(362.1,.01,1,1,2)
	;;=K ^IBA(362.1,"B",$E(X,1,30),DA)
	;;^DD(362.1,.01,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(362.1,.01,21,0)
	;;=^^1^1^2931229^
	;;^DD(362.1,.01,21,1,0)
	;;=A reference number that should be unique for each entry.
	;;^DD(362.1,.01,"DT")
	;;=2930903
	;;^DD(362.1,.02,0)
	;;=CLAIMS TRACKING ID^P356'^IBT(356,^0;2^Q
	;;^DD(362.1,.02,1,0)
	;;=^.1
	;;^DD(362.1,.02,1,1,0)
	;;=362.1^C
	;;^DD(362.1,.02,1,1,1)
	;;=S ^IBA(362.1,"C",$E(X,1,30),DA)=""
	;;^DD(362.1,.02,1,1,2)
	;;=K ^IBA(362.1,"C",$E(X,1,30),DA)
	;;^DD(362.1,.02,1,1,"DT")
	;;=2930905
	;;^DD(362.1,.02,3)
	;;=Enter a Claims Tracking event.
	;;^DD(362.1,.02,21,0)
	;;=^^1^1^2931229^
	;;^DD(362.1,.02,21,1,0)
	;;=The Claims Tracking event for this comment entry.
