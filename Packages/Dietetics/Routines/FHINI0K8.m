FHINI0K8	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(114.1,0,"GL")
	;;=^FH(114.1,
	;;^DIC("B","RECIPE CATEGORY",114.1)
	;;=
	;;^DIC(114.1,"%D",0)
	;;=^^3^3^2880515^
	;;^DIC(114.1,"%D",1,0)
	;;=This file contains a basic list of categorizations which may
	;;^DIC(114.1,"%D",2,0)
	;;=be applied to recipes. It is primarily used to sort and/or
	;;^DIC(114.1,"%D",3,0)
	;;=determine the order in which lists of recipes will print.
	;;^DD(114.1,0)
	;;=FIELD^^99^4
	;;^DD(114.1,0,"DT")
	;;=2950428
	;;^DD(114.1,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(114.1,0,"IX","AC",114.1,99)
	;;=
	;;^DD(114.1,0,"IX","B",114.1,.01)
	;;=
	;;^DD(114.1,0,"IX","C",114.1,1)
	;;=
	;;^DD(114.1,0,"NM","RECIPE CATEGORY")
	;;=
	;;^DD(114.1,0,"PT",111.115,.01)
	;;=
	;;^DD(114.1,0,"PT",111.116,.01)
	;;=
	;;^DD(114.1,0,"PT",111.117,.01)
	;;=
	;;^DD(114.1,0,"PT",114,7)
	;;=
	;;^DD(114.1,0,"PT",114.0103,.01)
	;;=
	;;^DD(114.1,0,"PT",116.11,3)
	;;=
	;;^DD(114.1,0,"PT",116.12,.01)
	;;=
	;;^DD(114.1,0,"SCR")
	;;=I '$D(^FH(114.1,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(114.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>15!($L(X)<3)!'(X'?1P.E) X
	;;^DD(114.1,.01,1,0)
	;;=^.1
	;;^DD(114.1,.01,1,1,0)
	;;=114.1^B
	;;^DD(114.1,.01,1,1,1)
	;;=S ^FH(114.1,"B",$E(X,1,30),DA)=""
	;;^DD(114.1,.01,1,1,2)
	;;=K ^FH(114.1,"B",$E(X,1,30),DA)
	;;^DD(114.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(114.1,.01,3)
	;;=ANSWER MUST BE 3-15 CHARACTERS IN LENGTH
	;;^DD(114.1,.01,21,0)
	;;=^^3^3^2880709^
	;;^DD(114.1,.01,21,1,0)
	;;=This is the name of a category of recipes (e.g., beverages,
	;;^DD(114.1,.01,21,2,0)
	;;=condiments, entree meats, etc.) which are used to sort the
	;;^DD(114.1,.01,21,3,0)
	;;=recipe items on the various meal lists.
	;;^DD(114.1,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(114.1,1,0)
	;;=CODE^RFX^^0;2^K:X[""""!$A(X)=45 X I $D(X) D TR^FH K:X'?1U.1U1N.1"X" X I $D(X) S Y=$O(^FH(114.1,"C",X,0)) I Y>0,Y-DA W *7,"  Code used by ",$P(^FH(114.1,Y,0),"^",1) K X
	;;^DD(114.1,1,1,0)
	;;=^.1
	;;^DD(114.1,1,1,1,0)
	;;=114.1^C
	;;^DD(114.1,1,1,1,1)
	;;=S ^FH(114.1,"C",$E(X,1,30),DA)=""
	;;^DD(114.1,1,1,1,2)
	;;=K ^FH(114.1,"C",$E(X,1,30),DA)
	;;^DD(114.1,1,3)
	;;=ANSWER MUST BE ONE TO TWO CHARACTERS AND A NUMBER OR ONE TO TWO CHARACTERS, A NUMBER AND AN 'X' AT THE END.
	;;^DD(114.1,1,21,0)
	;;=^^3^3^2950502^^^^
	;;^DD(114.1,1,21,1,0)
	;;=This field represents a short code for the recipe category. It
	;;^DD(114.1,1,21,2,0)
	;;=consists of one to two characters and a number or one to two characters,
	;;^DD(114.1,1,21,3,0)
	;;=a number, and an 'X' used when printing tray assembly tickets.
	;;^DD(114.1,1,"DT")
	;;=2950428
	;;^DD(114.1,2,0)
	;;=MEAL PRINT ORDER^RNJ2,0^^0;3^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(114.1,2,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(114.1,2,21,0)
	;;=^^3^3^2880717^
	;;^DD(114.1,2,21,1,0)
	;;=This value is used to sort recipes for printing as meals. The
	;;^DD(114.1,2,21,2,0)
	;;=value indicates the relative print order, from low to high, of
	;;^DD(114.1,2,21,3,0)
	;;=recipes in this recipe category.
	;;^DD(114.1,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(114.1,99,1,0)
	;;=^.1
	;;^DD(114.1,99,1,1,0)
	;;=114.1^AC^MUMPS
	;;^DD(114.1,99,1,1,1)
	;;=K:X'="Y" ^FH(114.1,DA,"I")
	;;^DD(114.1,99,1,1,2)
	;;=K ^FH(114.1,DA,"I")
	;;^DD(114.1,99,1,1,"%D",0)
	;;=^^1^1^2940701^
	;;^DD(114.1,99,1,1,"%D",1,0)
	;;=This is a cross reference for Recipe Categories that are inactive.
	;;^DD(114.1,99,1,1,"DT")
	;;=2940701
	;;^DD(114.1,99,21,0)
	;;=^^2^2^2950221^^^^
	;;^DD(114.1,99,21,1,0)
	;;=This field, when answered YES, will prohibit further selection
	;;^DD(114.1,99,21,2,0)
	;;=of this Recipe Category.
	;;^DD(114.1,99,"DT")
	;;=2940701
