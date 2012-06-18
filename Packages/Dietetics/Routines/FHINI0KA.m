FHINI0KA	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(114.2,0,"GL")
	;;=^FH(114.2,
	;;^DIC("B","PREPARATION AREA",114.2)
	;;=
	;;^DIC(114.2,"%D",0)
	;;=^^5^5^2880515^
	;;^DIC(114.2,"%D",1,0)
	;;=This file contains a list of areas in which food is prepared.
	;;^DIC(114.2,"%D",2,0)
	;;=Recipes may be classified by preparation area and this file
	;;^DIC(114.2,"%D",3,0)
	;;=is used to sort recipes into the various preparation areas
	;;^DIC(114.2,"%D",4,0)
	;;=as well as determine the order in which various lists will
	;;^DIC(114.2,"%D",5,0)
	;;=print.
	;;^DD(114.2,0)
	;;=FIELD^^2^3
	;;^DD(114.2,0,"IX","B",114.2,.01)
	;;=
	;;^DD(114.2,0,"NM","PREPARATION AREA")
	;;=
	;;^DD(114.2,0,"PT",114,12)
	;;=
	;;^DD(114.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>15!($L(X)<3)!'(X'?1P.E) X
	;;^DD(114.2,.01,1,0)
	;;=^.1
	;;^DD(114.2,.01,1,1,0)
	;;=114.2^B
	;;^DD(114.2,.01,1,1,1)
	;;=S ^FH(114.2,"B",$E(X,1,30),DA)=""
	;;^DD(114.2,.01,1,1,2)
	;;=K ^FH(114.2,"B",$E(X,1,30),DA)
	;;^DD(114.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(114.2,.01,3)
	;;=ANSWER MUST BE 3-15 CHARACTERS IN LENGTH
	;;^DD(114.2,.01,21,0)
	;;=^^2^2^2880709^
	;;^DD(114.2,.01,21,1,0)
	;;=This is the name of an area where recipes are prepared (e.g.,
	;;^DD(114.2,.01,21,2,0)
	;;=salad area, bakery, etc.).
	;;^DD(114.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(114.2,1,0)
	;;=CODE^RF^^0;2^K:$L(X)>5!($L(X)<2) X
	;;^DD(114.2,1,3)
	;;=ANSWER MUST BE 2-5 CHARACTERS IN LENGTH
	;;^DD(114.2,1,21,0)
	;;=^^3^3^2880709^
	;;^DD(114.2,1,21,1,0)
	;;=This is a short abbreviation for the preparation area. It is used
	;;^DD(114.2,1,21,2,0)
	;;=on various lists where it is not practical to print the longer
	;;^DD(114.2,1,21,3,0)
	;;=full name. It should be unique.
	;;^DD(114.2,2,0)
	;;=PRINT ORDER^RNJ2,0^^0;3^K:+X'=X!(X>49)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(114.2,2,3)
	;;=Type a Number between 1 and 49, 0 Decimal Digits
	;;^DD(114.2,2,21,0)
	;;=^^3^3^2880709^
	;;^DD(114.2,2,21,1,0)
	;;=This is a numeric value indicating the print order (from low to
	;;^DD(114.2,2,21,2,0)
	;;=high) of various preparation areas when the list is sorted by
	;;^DD(114.2,2,21,3,0)
	;;=preparation area.
	;;^DD(114.2,2,"DT")
	;;=2880328
