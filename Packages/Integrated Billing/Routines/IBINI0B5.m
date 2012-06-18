IBINI0B5	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(399.2,0,"GL")
	;;=^DGCR(399.2,
	;;^DIC("B","REVENUE CODE",399.2)
	;;=
	;;^DIC(399.2,"%D",0)
	;;=^^4^4^2940215^^^^
	;;^DIC(399.2,"%D",1,0)
	;;=This file contains all of the Revenue Codes which may be used on the
	;;^DIC(399.2,"%D",2,0)
	;;=Third Party claim forms.
	;;^DIC(399.2,"%D",3,0)
	;;= 
	;;^DIC(399.2,"%D",4,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(399.2,0)
	;;=FIELD^^4^5
	;;^DD(399.2,0,"DDA")
	;;=N
	;;^DD(399.2,0,"DT")
	;;=2931221
	;;^DD(399.2,0,"ID",1)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(399.2,0,"ID",3)
	;;=W "   ",$P(^(0),U,4)
	;;^DD(399.2,0,"IX","AC",399.2,2)
	;;=
	;;^DD(399.2,0,"IX","B",399.2,.01)
	;;=
	;;^DD(399.2,0,"IX","C",399.2,1)
	;;=
	;;^DD(399.2,0,"IX","D1",399.2,2)
	;;=
	;;^DD(399.2,0,"IX","E",399.2,3)
	;;=
	;;^DD(399.2,0,"IX","F",399.2,.01)
	;;=
	;;^DD(399.2,0,"NM","REVENUE CODE")
	;;=
	;;^DD(399.2,0,"PT",36,.09)
	;;=
	;;^DD(399.2,0,"PT",36,.15)
	;;=
	;;^DD(399.2,0,"PT",350.9,1.18)
	;;=
	;;^DD(399.2,0,"PT",350.9,1.28)
	;;=
	;;^DD(399.2,0,"PT",399.042,.01)
	;;=
	;;^DD(399.2,0,"PT",399.5,.03)
	;;=
	;;^DD(399.2,.01,0)
	;;=REVENUE CODE^RFXI^^0;1^K:X[""""!($A(X)=45) X I $D(X) S:$L(X)<3 X=$E("000",1,3-$L(X))_X K:X="000" X K:$L(X)>3!($L(X)<3)!'(X?3N) X I $D(X) S DINUM=+X K X
	;;^DD(399.2,.01,1,0)
	;;=^.1^^-1
	;;^DD(399.2,.01,1,1,0)
	;;=399.2^B
	;;^DD(399.2,.01,1,1,1)
	;;=S ^DGCR(399.2,"B",$E(X,1,30),DA)=""
	;;^DD(399.2,.01,1,1,2)
	;;=K ^DGCR(399.2,"B",$E(X,1,30),DA)
	;;^DD(399.2,.01,1,3,0)
	;;=399.2^F^MUMPS
	;;^DD(399.2,.01,1,3,1)
	;;=I +X,+X<100 S ^DGCR(399.2,"F",+X,DA)=""
	;;^DD(399.2,.01,1,3,2)
	;;=K ^DGCR(399.2,"F",+X,DA)
	;;^DD(399.2,.01,1,3,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.2,.01,1,3,"%D",1,0)
	;;=All revenue codes less than 100.
	;;^DD(399.2,.01,3)
	;;=Enter the 3-digit numeric code associated with this entry.
	;;^DD(399.2,.01,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.2,.01,21,1,0)
	;;=This is the 3-digit numeric code associated with this entry.
	;;^DD(399.2,.01,"DT")
	;;=2901003
	;;^DD(399.2,1,0)
	;;=STANDARD ABBREVIATION^FX^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>60!($L(X)<1)!'(X?1"*".A!(X?1A.E)) X I $D(X),$E(X)="*" S X=X_"RESERVED" K X
	;;^DD(399.2,1,1,0)
	;;=^.1
	;;^DD(399.2,1,1,1,0)
	;;=399.2^C
	;;^DD(399.2,1,1,1,1)
	;;=S ^DGCR(399.2,"C",$E(X,1,30),DA)=""
	;;^DD(399.2,1,1,1,2)
	;;=K ^DGCR(399.2,"C",$E(X,1,30),DA)
	;;^DD(399.2,1,1,2,0)
	;;=^^TRIGGER^399.2^3
	;;^DD(399.2,1,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=Y(0),X=$E(X)="*" I X S X=DIV S Y(1)=$S($D(^DGCR(399.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X=DIV S X=DIV X ^DD(399.2,1,1,2,1.4)
	;;^DD(399.2,1,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,4)=DIV,DIH=399.2,DIG=3 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.2,1,1,2,2)
	;;=Q
	;;^DD(399.2,1,1,2,"CREATE CONDITION")
	;;=$E(STANDARD ABBREVIATION)="*"
	;;^DD(399.2,1,1,2,"CREATE VALUE")
	;;=STANDARD ABBREVIATION
	;;^DD(399.2,1,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399.2,1,1,2,"FIELD")
	;;=DESCRIPTION
	;;^DD(399.2,1,3)
	;;=Enter the 1-60 character abbreviation of the description field of this entry.
	;;^DD(399.2,1,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.2,1,21,1,0)
	;;=This is the abbreviation of the description field of this entry.
	;;^DD(399.2,1,"DT")
	;;=2880831
	;;^DD(399.2,2,0)
	;;=ACTIVATE^RSX^1:ACTIVATE CODE;0:INACTIVATE CODE;^0;3^Q:'X  S %=^DGCR(399.2,+DA,0) I $E($P(%,"^",2))="*"!($E($P(%,"^",4))="*") W !?4,"Can't activate a RESERVED code...",*7 K X
	;;^DD(399.2,2,1,0)
	;;=^.1
	;;^DD(399.2,2,1,1,0)
	;;=399.2^AC^MUMPS
	;;^DD(399.2,2,1,1,1)
	;;=I $P(^DGCR(399.2,DA,0),"^",3)=1 S ^DGCR(399.2,"AC",DA)=""
