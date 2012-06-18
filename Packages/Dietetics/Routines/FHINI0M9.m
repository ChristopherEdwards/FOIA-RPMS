FHINI0M9	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(118.2,0,"GL")
	;;=^FH(118.2,
	;;^DIC("B","TUBEFEEDING",118.2)
	;;=
	;;^DIC(118.2,"%D",0)
	;;=^^3^3^2871124^
	;;^DIC(118.2,"%D",1,0)
	;;=This file contains the products commonly used for tube-feedings
	;;^DIC(118.2,"%D",2,0)
	;;=as well as their characteristics such as Kcals/cc, cost, and
	;;^DIC(118.2,"%D",3,0)
	;;=synonyms.
	;;^DD(118.2,0)
	;;=FIELD^^99^8
	;;^DD(118.2,0,"DT")
	;;=2920928
	;;^DD(118.2,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(118.2,0,"IX","AC",118.2,99)
	;;=
	;;^DD(118.2,0,"IX","B",118.2,.01)
	;;=
	;;^DD(118.2,0,"IX","C",118.21,.01)
	;;=
	;;^DD(118.2,0,"NM","TUBEFEEDING")
	;;=
	;;^DD(118.2,0,"PT",115.1,.01)
	;;=
	;;^DD(118.2,0,"SCR")
	;;=I '$D(^FH(118.2,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(118.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(118.2,.01,1,0)
	;;=^.1
	;;^DD(118.2,.01,1,1,0)
	;;=118.2^B
	;;^DD(118.2,.01,1,1,1)
	;;=S ^FH(118.2,"B",$E(X,1,30),DA)=""
	;;^DD(118.2,.01,1,1,2)
	;;=K ^FH(118.2,"B",$E(X,1,30),DA)
	;;^DD(118.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(118.2,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(118.2,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(118.2,.01,21,1,0)
	;;=This is the name of the tubefeeding product as it will appear
	;;^DD(118.2,.01,21,2,0)
	;;=on all lists and displays.
	;;^DD(118.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(118.2,.01,"DT")
	;;=2920116
	;;^DD(118.2,1,0)
	;;=DISPENSING UNIT^RF^^0;2^K:$L(X)>10!($L(X)<1) X
	;;^DD(118.2,1,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(118.2,1,21,0)
	;;=^^2^2^2920814^^^
	;;^DD(118.2,1,21,1,0)
	;;=This field contains a title for the dispensing unit such
	;;^DD(118.2,1,21,2,0)
	;;=as bottle, can or package.
	;;^DD(118.2,2,0)
	;;=AMT/UNIT^RFX^^0;3^S FHX1=$P(X," ",1) S:$E(FHX1,$L(FHX1))'?1U FHX1=+FHX1_$P(X," ",2) S:"CG"[$E(FHX1,$L(+FHX1)+1) X=+FHX1_$E(FHX1,$L(+FHX1)+1) K FHX1 K:$L(X)>10!($L(X)<2)!(+X>9999)!(+X<0)!("CG"'[$E(X,$L(X))) X
	;;^DD(118.2,2,3)
	;;=Enter amount in CC's or in Grams.  Amount cannot exceed 9999.  The following are examples of valid entries 22CC, 40GRAMS, 20 G, or 100 C.
	;;^DD(118.2,2,21,0)
	;;=^^3^3^2931109^^^^
	;;^DD(118.2,2,21,1,0)
	;;=This is the number of cc's or grams of product contained in the
	;;^DD(118.2,2,21,2,0)
	;;=dispensing unit. For products which require reconstitution
	;;^DD(118.2,2,21,3,0)
	;;=with water, it is the number of cc's after reconstitution.
	;;^DD(118.2,2,"DT")
	;;=2920928
	;;^DD(118.2,3,0)
	;;=KCAL/CC^RNJ7,2^^0;4^K:+X'=X!(X>1000)!(X<.1)!(X?.E1"."3N.N) X
	;;^DD(118.2,3,3)
	;;=Type a Number between .1 and 1000, 2 Decimal Digits
	;;^DD(118.2,3,21,0)
	;;=^^2^2^2930416^^^^
	;;^DD(118.2,3,21,1,0)
	;;=This field contains the number of KiloCalories per cc of
	;;^DD(118.2,3,21,2,0)
	;;=product.
	;;^DD(118.2,3,"DT")
	;;=2880304
	;;^DD(118.2,5,0)
	;;=COST^CJ8,2^^ ; ^X ^DD(118.2,5,9.2) S X=$P(Y(118.2,5,101),U,13) S D0=Y(118.2,5,80) S X=$J(X,0,2)
	;;^DD(118.2,5,9)
	;;=^
	;;^DD(118.2,5,9.01)
	;;=114^101;118.2^11
	;;^DD(118.2,5,9.1)
	;;=CORRESPONDING RECIPE:COST/PORTION
	;;^DD(118.2,5,9.2)
	;;=S Y(118.2,5,80)=$S($D(D0):D0,1:""),Y(118.2,5,1)=$S($D(^FH(118.2,D0,0)):^(0),1:""),D0=$P(Y(118.2,5,1),U,7) S:'$D(^FH(114,+D0,0)) D0=-1 S Y(118.2,5,101)=$S($D(^FH(114,D0,0)):^(0),1:"")
	;;^DD(118.2,5,21,0)
	;;=^^3^3^2950613^^^^
	;;^DD(118.2,5,21,1,0)
	;;=This is the portion cost of the tubefeeding and is a
	;;^DD(118.2,5,21,2,0)
	;;=computed field which obtains the value from the recipe file based
	;;^DD(118.2,5,21,3,0)
	;;=upon the 'Corresponding Recipe' pointer.
	;;^DD(118.2,10,0)
	;;=SYNONYM^118.21^^1;0
	;;^DD(118.2,10,21,0)
	;;=^^3^3^2920818^^
	;;^DD(118.2,10,21,1,0)
	;;=This multiple contains alternate names or synonyms for the
	;;^DD(118.2,10,21,2,0)
	;;=product. These names should include any names commonly known
	;;^DD(118.2,10,21,3,0)
	;;=or used by ward/medical personnel.
	;;^DD(118.2,11,0)
	;;=CORRESPONDING RECIPE^P114'^FH(114,^0;7^Q
	;;^DD(118.2,11,21,0)
	;;=^^3^3^2910411^^^
	;;^DD(118.2,11,21,1,0)
	;;=This field is a pointer to the recipe in file 114 (the Recipe file)
	;;^DD(118.2,11,21,2,0)
	;;=which contains the ingredients for this feeding. Cost and other data
	;;^DD(118.2,11,21,3,0)
	;;=for this feeding will be retrieved from the recipe file.
	;;^DD(118.2,11,"DT")
	;;=2900929
	;;^DD(118.2,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(118.2,99,1,0)
	;;=^.1
	;;^DD(118.2,99,1,1,0)
	;;=118.2^AC^MUMPS
	;;^DD(118.2,99,1,1,1)
	;;=K:X'="Y" ^FH(118.2,DA,"I")
	;;^DD(118.2,99,1,1,2)
	;;=K ^FH(118.2,DA,"I")
