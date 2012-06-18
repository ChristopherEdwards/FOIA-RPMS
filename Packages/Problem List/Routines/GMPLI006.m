GMPLI006	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.11)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125.11,0,"GL")
	;;=^GMPL(125.11,
	;;^DIC("B","PROBLEM SELECTION CATEGORY",125.11)
	;;=
	;;^DIC(125.11,"%D",0)
	;;=^^3^3^2940526^^^^
	;;^DIC(125.11,"%D",1,0)
	;;=This file contains problems categorized into groups for inclusion in
	;;^DIC(125.11,"%D",2,0)
	;;=a Selection List.  Items within a category will be ordered according to
	;;^DIC(125.11,"%D",3,0)
	;;=the Sequence number; up to two decimal digits may be used.
	;;^DD(125.11,0)
	;;=FIELD^^1^2
	;;^DD(125.11,0,"DDA")
	;;=N
	;;^DD(125.11,0,"DT")
	;;=2931005
	;;^DD(125.11,0,"IX","B",125.11,.01)
	;;=
	;;^DD(125.11,0,"NM","PROBLEM SELECTION CATEGORY")
	;;=
	;;^DD(125.11,0,"PT",125.1,2)
	;;=
	;;^DD(125.11,0,"PT",125.12,.01)
	;;=
	;;^DD(125.11,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(125.11,.01,1,0)
	;;=^.1
	;;^DD(125.11,.01,1,1,0)
	;;=125.11^B
	;;^DD(125.11,.01,1,1,1)
	;;=S ^GMPL(125.11,"B",$E(X,1,30),DA)=""
	;;^DD(125.11,.01,1,1,2)
	;;=K ^GMPL(125.11,"B",$E(X,1,30),DA)
	;;^DD(125.11,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(125.11,.01,21,0)
	;;=^^1^1^2931004^
	;;^DD(125.11,.01,21,1,0)
	;;=This is the name given to this problem group to identify and describe it.
	;;^DD(125.11,1,0)
	;;=DATE LAST MODIFIED^D^^0;2^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(125.11,1,3)
	;;=Enter the date/time this problem group was edited last.
	;;^DD(125.11,1,21,0)
	;;=^^2^2^2931005^
	;;^DD(125.11,1,21,1,0)
	;;=This is the date/time this group was last changed; it is stuffed in
	;;^DD(125.11,1,21,2,0)
	;;=by the Problem List pkg utilities.
	;;^DD(125.11,1,"DT")
	;;=2931005
