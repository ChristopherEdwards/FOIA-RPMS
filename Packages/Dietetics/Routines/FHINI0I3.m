FHINI0I3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(114)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(114,0,"GL")
	;;=^FH(114,
	;;^DIC("B","RECIPE",114)
	;;=
	;;^DIC(114,"%D",0)
	;;=^^3^3^2950221^^
	;;^DIC(114,"%D",1,0)
	;;=This file contains all recipes necessary to build meals. Each
	;;^DIC(114,"%D",2,0)
	;;=recipe consists of basic data concerning the recipe, various
	;;^DIC(114,"%D",3,0)
	;;=ingredients, and may also contain 'embedded' recipes.
	;;^DD(114,0)
	;;=FIELD^^103^18
	;;^DD(114,0,"DT")
	;;=2950428
	;;^DD(114,0,"IX","B",114,.01)
	;;=
	;;^DD(114,0,"IX","C",114,8)
	;;=
	;;^DD(114,0,"NM","RECIPE")
	;;=
	;;^DD(114,0,"PT",112.64,.01)
	;;=
	;;^DD(114,0,"PT",114.03,.01)
	;;=
	;;^DD(114,0,"PT",115.2,3)
	;;=
	;;^DD(114,0,"PT",115.21,.01)
	;;=
	;;^DD(114,0,"PT",116.11,.01)
	;;=
	;;^DD(114,0,"PT",118,11)
	;;=
	;;^DD(114,0,"PT",118.2,11)
	;;=
	;;^DD(114,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(114,.01,1,0)
	;;=^.1
	;;^DD(114,.01,1,1,0)
	;;=114^B
	;;^DD(114,.01,1,1,1)
	;;=S ^FH(114,"B",$E(X,1,30),DA)=""
	;;^DD(114,.01,1,1,2)
	;;=K ^FH(114,"B",$E(X,1,30),DA)
	;;^DD(114,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(114,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(114,.01,3)
	;;=ANSWER MUST BE 3-30 CHARACTERS IN LENGTH
	;;^DD(114,.01,21,0)
	;;=^^3^3^2940701^^
	;;^DD(114,.01,21,1,0)
	;;=This is the name of the recipe. A recipe is anything served and
	;;^DD(114,.01,21,2,0)
	;;=may consist of a single ingredient which requires no
	;;^DD(114,.01,21,3,0)
	;;=preparation.
	;;^DD(114,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(114,.01,"DT")
	;;=2860102
	;;^DD(114,1,0)
	;;=INGREDIENT^114.01PA^^I;0
	;;^DD(114,1,21,0)
	;;=^^1^1^2880717^
	;;^DD(114,1,21,1,0)
	;;=This multiple contains the ingredients used in the recipe.
	;;^DD(114,1.5,0)
	;;=EMBEDDED RECIPE^114.03PA^^R;0
	;;^DD(114,1.5,21,0)
	;;=^^4^4^2881117^^^^
	;;^DD(114,1.5,21,1,0)
	;;=This field contains recipes which are 'embedded' in this recipe.
	;;^DD(114,1.5,21,2,0)
	;;=For example, a hot roast beef sandwich might contain bread
	;;^DD(114,1.5,21,3,0)
	;;=as an ingredient but roast beef as an embedded recipe and
	;;^DD(114,1.5,21,4,0)
	;;=perhaps even brown gravy as another embedded recipe.
	;;^DD(114,2,0)
	;;=NUMBER OF PORTIONS^RNJ4,0^^0;2^K:+X'=X!(X>1000)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(114,2,3)
	;;=Type a Number between 1 and 1000, 0 Decimal Digits
	;;^DD(114,2,21,0)
	;;=^^3^3^2881117^^^
	;;^DD(114,2,21,1,0)
	;;=This is the yield, in terms of number of portions, of the
	;;^DD(114,2,21,2,0)
	;;=recipe. It should be within a factor of 10 of the normal quantity
	;;^DD(114,2,21,3,0)
	;;=needed and need not be 100.
	;;^DD(114,2,"DT")
	;;=2881117
	;;^DD(114,3,0)
	;;=PORTION SIZE^RFX^^0;3^K:$L(X)>8!($L(X)<1) X I $D(X) D EN3^FHREC1
	;;^DD(114,3,3)
	;;=ANSWER MUST BE A NUMBER FOLLOWED BY OZ, FLOZ OR EACH
	;;^DD(114,3,21,0)
	;;=^^2^2^2930916^^^^
	;;^DD(114,3,21,1,0)
	;;=This is a short description of the portion size, e.g., 3-oz. or
	;;^DD(114,3,21,2,0)
	;;=1 each. Size must be a number followed by OZ, EACH or FLOZ.
	;;^DD(114,3,"DT")
	;;=2880918
	;;^DD(114,4,0)
	;;=PREPARATION TIME^F^^0;4^K:$L(X)>10!($L(X)<1) X
	;;^DD(114,4,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(114,4,21,0)
	;;=^^2^2^2880717^
	;;^DD(114,4,21,1,0)
	;;=This field indicates the amount of preparation time this
	;;^DD(114,4,21,2,0)
	;;=recipe will require.
	;;^DD(114,5,0)
	;;=EQUIPMENT^114.05P^^E;0
	;;^DD(114,5,3)
	;;=
	;;^DD(114,5,21,0)
	;;=^^2^2^2880919^
	;;^DD(114,5,21,1,0)
	;;=This multiple is used to indicate the various types of equipment
	;;^DD(114,5,21,2,0)
	;;=necessary to produce this recipe.
	;;^DD(114,5,"DT")
	;;=2871114
	;;^DD(114,6,0)
	;;=SERVING UTENSIL^P114.3'^FH(114.3,^0;6^Q
	;;^DD(114,6,3)
	;;=
	;;^DD(114,6,21,0)
	;;=^^2^2^2930127^^
	;;^DD(114,6,21,1,0)
	;;=This field indicates the primary serving utensil which will be
	;;^DD(114,6,21,2,0)
	;;=required by tray line personnel or cafeteria line personnel.
	;;^DD(114,6,"DT")
	;;=2871114
	;;^DD(114,7,0)
	;;=DEFAULT CATEGORY^RP114.1'^FH(114.1,^0;7^Q
	;;^DD(114,7,3)
	;;=
	;;^DD(114,7,21,0)
	;;=^^4^4^2880717^
	;;^DD(114,7,21,1,0)
	;;=This is the primary category of the recipe. Selection does not
	;;^DD(114,7,21,2,0)
	;;=prohibit the use of the recipe in other ways (e.g., a 'salad'
	;;^DD(114,7,21,3,0)
	;;=being used for dessert) but does influence the printing order
	;;^DD(114,7,21,4,0)
	;;=of the recipe in various lists.
	;;^DD(114,7,"DT")
	;;=2940120
	;;^DD(114,8,0)
	;;=SYNONYM^F^^0;9^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>25!($L(X)<3) X
	;;^DD(114,8,1,0)
	;;=^.1
	;;^DD(114,8,1,1,0)
	;;=114^C
	;;^DD(114,8,1,1,1)
	;;=S ^FH(114,"C",$E(X,1,30),DA)=""
