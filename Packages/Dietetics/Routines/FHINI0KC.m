FHINI0KC	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(114.3,0,"GL")
	;;=^FH(114.3,
	;;^DIC("B","SERVING UTENSIL",114.3)
	;;=
	;;^DIC(114.3,"%D",0)
	;;=^^4^4^2880515^
	;;^DIC(114.3,"%D",1,0)
	;;=This file contains a list of basic serving utensils. Recipes
	;;^DIC(114.3,"%D",2,0)
	;;=use this file to indicate the most appropriate serving utensil.
	;;^DIC(114.3,"%D",3,0)
	;;=The utensil name is printed on various reports for use by
	;;^DIC(114.3,"%D",4,0)
	;;=serving personnel.
	;;^DD(114.3,0)
	;;=FIELD^^.01^1
	;;^DD(114.3,0,"IX","B",114.3,.01)
	;;=
	;;^DD(114.3,0,"NM","SERVING UTENSIL")
	;;=
	;;^DD(114.3,0,"PT",114,6)
	;;=
	;;^DD(114.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>10!($L(X)<1) X
	;;^DD(114.3,.01,1,0)
	;;=^.1
	;;^DD(114.3,.01,1,1,0)
	;;=114.3^B
	;;^DD(114.3,.01,1,1,1)
	;;=S ^FH(114.3,"B",$E(X,1,30),DA)=""
	;;^DD(114.3,.01,1,1,2)
	;;=K ^FH(114.3,"B",$E(X,1,30),DA)
	;;^DD(114.3,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114.3,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(114.3,.01,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(114.3,.01,21,0)
	;;=^^3^3^2880709^
	;;^DD(114.3,.01,21,1,0)
	;;=This is the name of a serving utensil. It is used by the recipe
	;;^DD(114.3,.01,21,2,0)
	;;=file to indicate the usual utensil used by tray line personnel
	;;^DD(114.3,.01,21,3,0)
	;;=or others to serve the recipe item.
	;;^DD(114.3,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(114.3,.01,"DT")
	;;=2871115
