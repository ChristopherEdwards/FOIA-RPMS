FHINI0KE	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(114.4,0,"GL")
	;;=^FH(114.4,
	;;^DIC("B","EQUIPMENT",114.4)
	;;=
	;;^DIC(114.4,"%D",0)
	;;=^^3^3^2880515^
	;;^DIC(114.4,"%D",1,0)
	;;=This file contains a list of basic equipment used in the preparation
	;;^DIC(114.4,"%D",2,0)
	;;=of recipes. A recipe may point to this list to indicate the
	;;^DIC(114.4,"%D",3,0)
	;;=primary type of equipment used in the recipe preparation.
	;;^DD(114.4,0)
	;;=FIELD^^.01^1
	;;^DD(114.4,0,"IX","B",114.4,.01)
	;;=
	;;^DD(114.4,0,"NM","EQUIPMENT")
	;;=
	;;^DD(114.4,0,"PT",114.05,.01)
	;;=
	;;^DD(114.4,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>21!($L(X)<3) X
	;;^DD(114.4,.01,1,0)
	;;=^.1
	;;^DD(114.4,.01,1,1,0)
	;;=114.4^B
	;;^DD(114.4,.01,1,1,1)
	;;=S ^FH(114.4,"B",$E(X,1,30),DA)=""
	;;^DD(114.4,.01,1,1,2)
	;;=K ^FH(114.4,"B",$E(X,1,30),DA)
	;;^DD(114.4,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114.4,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(114.4,.01,3)
	;;=ANSWER MUST BE 3-21 CHARACTERS IN LENGTH
	;;^DD(114.4,.01,21,0)
	;;=^^3^3^2880709^
	;;^DD(114.4,.01,21,1,0)
	;;=This is the name of an equipment item (large kettle, convection
	;;^DD(114.4,.01,21,2,0)
	;;=oven, etc.) and is used by the recipe file to indicate the
	;;^DD(114.4,.01,21,3,0)
	;;=usual preparation equipment needed.
	;;^DD(114.4,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(114.4,.01,"DT")
	;;=2880117
