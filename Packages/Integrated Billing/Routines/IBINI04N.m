IBINI04N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.3,0,"GL")
	;;=^IBA(355.3,
	;;^DIC("B","GROUP INSURANCE PLAN",355.3)
	;;=
	;;^DIC(355.3,"%D",0)
	;;=^^8^8^2940225^^^^
	;;^DIC(355.3,"%D",1,0)
	;;=This file contains the relevent data for Group insurance plans.
	;;^DIC(355.3,"%D",2,0)
	;;=The data in this file is specific to the plan itself.
	;;^DIC(355.3,"%D",3,0)
	;;= 
	;;^DIC(355.3,"%D",4,0)
	;;=This is in contrast to the patient file which contains data about
	;;^DIC(355.3,"%D",5,0)
	;;=patient's policies, where the policy may be for a group or Health 
	;;^DIC(355.3,"%D",6,0)
	;;=Insurance Plan.
	;;^DIC(355.3,"%D",7,0)
	;;= 
	;;^DIC(355.3,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.3,0)
	;;=FIELD^^11^17
	;;^DD(355.3,0,"DDA")
	;;=N
	;;^DD(355.3,0,"DT")
	;;=2931109
	;;^DD(355.3,0,"ID",.02)
	;;=W:$P(^(0),U,2)=0 "   Individual Policy" W:$P(^(0),U,2) "   Group Policy"
	;;^DD(355.3,0,"ID",.03)
	;;=I $P(^(0),U,3)]"" W "   Group Name: ",$P(^(0),U,3)
	;;^DD(355.3,0,"ID",.04)
	;;=I $P(^(0),U,4)]"" W "   Group No: ",$P(^(0),U,4)
	;;^DD(355.3,0,"IX","AGNA",355.3,.03)
	;;=
	;;^DD(355.3,0,"IX","AGNA1",355.3,.01)
	;;=
	;;^DD(355.3,0,"IX","AGNU",355.3,.04)
	;;=
	;;^DD(355.3,0,"IX","AGNU1",355.3,.01)
	;;=
	;;^DD(355.3,0,"IX","B",355.3,.01)
	;;=
	;;^DD(355.3,0,"IX","D",355.3,.03)
	;;=
	;;^DD(355.3,0,"IX","E",355.3,.04)
	;;=
	;;^DD(355.3,0,"NM","GROUP INSURANCE PLAN")
	;;=
	;;^DD(355.3,0,"PT",2.312,.18)
	;;=
	;;^DD(355.3,0,"PT",355.4,.02)
	;;=
	;;^DD(355.3,0,"PT",355.5,.01)
	;;=
	;;^DD(355.3,.01,0)
	;;=INSURANCE COMPANY^RP36'^DIC(36,^0;1^Q
	;;^DD(355.3,.01,1,0)
	;;=^.1
	;;^DD(355.3,.01,1,1,0)
	;;=355.3^B
	;;^DD(355.3,.01,1,1,1)
	;;=S ^IBA(355.3,"B",$E(X,1,30),DA)=""
	;;^DD(355.3,.01,1,1,2)
	;;=K ^IBA(355.3,"B",$E(X,1,30),DA)
	;;^DD(355.3,.01,1,2,0)
	;;=^^TRIGGER^355.3^1.01
	;;^DD(355.3,.01,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBA(355.3,D0,1)):^(1),1:"") S X=$P(Y(1),U,1)="" I X S X=DIV S Y(1)=$S($D(^IBA(355.3,D0,1)):^(1),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y X ^DD(355.3,.01,1,2,1.1) X ^DD(355.3,.01,1,2,1.4)
	;;^DD(355.3,.01,1,2,1.1)
	;;=S X=DIV S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
	;;^DD(355.3,.01,1,2,1.4)
	;;=S DIH=$S($D(^IBA(355.3,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,1)=DIV,DIH=355.3,DIG=1.01 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(355.3,.01,1,2,2)
	;;=Q
	;;^DD(355.3,.01,1,2,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(355.3,.01,1,2,"%D",1,0)
	;;=Triggers the date/time entered when creating a new entry.
	;;^DD(355.3,.01,1,2,"CREATE CONDITION")
	;;=#1.01=""
	;;^DD(355.3,.01,1,2,"CREATE VALUE")
	;;=NOW
	;;^DD(355.3,.01,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(355.3,.01,1,2,"DT")
	;;=2940213
	;;^DD(355.3,.01,1,2,"FIELD")
	;;=#1.01
	;;^DD(355.3,.01,1,3,0)
	;;=^^TRIGGER^355.3^1.02
	;;^DD(355.3,.01,1,3,1)
	;;=X ^DD(355.3,.01,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^IBA(355.3,D0,1)):^(1),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(355.3,.01,1,3,1.4)
	;;^DD(355.3,.01,1,3,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBA(355.3,D0,1)):^(1),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1))=""
	;;^DD(355.3,.01,1,3,1.4)
	;;=S DIH=$S($D(^IBA(355.3,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,2)=DIV,DIH=355.3,DIG=1.02 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(355.3,.01,1,3,2)
	;;=Q
	;;^DD(355.3,.01,1,3,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(355.3,.01,1,3,"%D",1,0)
	;;=Triggers the user who created this entry.
	;;^DD(355.3,.01,1,3,"CREATE CONDITION")
	;;=#1.02=""
	;;^DD(355.3,.01,1,3,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(355.3,.01,1,3,"DELETE VALUE")
	;;=NO EFFECT
