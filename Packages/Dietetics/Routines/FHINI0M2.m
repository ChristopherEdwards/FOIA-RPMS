FHINI0M2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(118,0,"GL")
	;;=^FH(118,
	;;^DIC("B","SUPPLEMENTAL FEEDINGS",118)
	;;=
	;;^DIC(118,"%D",0)
	;;=^^4^4^2871124^
	;;^DIC(118,"%D",1,0)
	;;=This file contains all items served as supplemental feedings.
	;;^DIC(118,"%D",2,0)
	;;=When appropriate, it may include combinations such as ice cream
	;;^DIC(118,"%D",3,0)
	;;=with spoon. Items designed for bulk delivery to the wards are
	;;^DIC(118,"%D",4,0)
	;;=also contained in this file.
	;;^DD(118,0)
	;;=FIELD^^99^8
	;;^DD(118,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(118,0,"IX","AD",118,99)
	;;=
	;;^DD(118,0,"IX","B",118,.01)
	;;=
	;;^DD(118,0,"IX","B",118.01,.01)
	;;=
	;;^DD(118,0,"NM","SUPPLEMENTAL FEEDINGS")
	;;=
	;;^DD(118,0,"PT",115.07,10)
	;;=
	;;^DD(118,0,"PT",115.07,12)
	;;=
	;;^DD(118,0,"PT",115.07,14)
	;;=
	;;^DD(118,0,"PT",115.07,16)
	;;=
	;;^DD(118,0,"PT",115.07,18)
	;;=
	;;^DD(118,0,"PT",115.07,20)
	;;=
	;;^DD(118,0,"PT",115.07,22)
	;;=
	;;^DD(118,0,"PT",115.07,24)
	;;=
	;;^DD(118,0,"PT",115.07,26)
	;;=
	;;^DD(118,0,"PT",115.07,28)
	;;=
	;;^DD(118,0,"PT",115.07,30)
	;;=
	;;^DD(118,0,"PT",115.07,32)
	;;=
	;;^DD(118,0,"PT",118.1,10)
	;;=
	;;^DD(118,0,"PT",118.1,11)
	;;=
	;;^DD(118,0,"PT",118.1,12)
	;;=
	;;^DD(118,0,"PT",118.1,13)
	;;=
	;;^DD(118,0,"PT",118.1,14)
	;;=
	;;^DD(118,0,"PT",118.1,15)
	;;=
	;;^DD(118,0,"PT",118.1,16)
	;;=
	;;^DD(118,0,"PT",118.1,17)
	;;=
	;;^DD(118,0,"PT",118.1,18)
	;;=
	;;^DD(118,0,"PT",118.1,19)
	;;=
	;;^DD(118,0,"PT",118.1,20)
	;;=
	;;^DD(118,0,"PT",118.1,21)
	;;=
	;;^DD(118,0,"PT",119.61,.01)
	;;=
	;;^DD(118,0,"SCR")
	;;=I '$D(^FH(118,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(118,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>20!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(118,.01,1,0)
	;;=^.1
	;;^DD(118,.01,1,1,0)
	;;=118^B
	;;^DD(118,.01,1,1,1)
	;;=S ^FH(118,"B",$E(X,1,30),DA)=""
	;;^DD(118,.01,1,1,2)
	;;=K ^FH(118,"B",$E(X,1,30),DA)
	;;^DD(118,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(118,.01,3)
	;;=ANSWER MUST BE 3-20 CHARACTERS IN LENGTH
	;;^DD(118,.01,21,0)
	;;=^^1^1^2880717^
	;;^DD(118,.01,21,1,0)
	;;=This field contains the name of the Supplemental Feeding.
	;;^DD(118,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(118,.01,"DT")
	;;=2840812
	;;^DD(118,1,0)
	;;=SYNONYM^118.01^^S;0
	;;^DD(118,1,21,0)
	;;=^^2^2^2901217^
	;;^DD(118,1,21,1,0)
	;;=This field allows for a number of synonyms for the supplemental
	;;^DD(118,1,21,2,0)
	;;=feeding to be entered.
	;;^DD(118,5,0)
	;;=LABEL?^S^Y:YES;N:NO;^0;2^Q
	;;^DD(118,5,3)
	;;=Enter N if you do not want a separate label for this item
	;;^DD(118,5,21,0)
	;;=^^4^4^2930203^^
	;;^DD(118,5,21,1,0)
	;;=This field, when answered NO, means that a label will not
	;;^DD(118,5,21,2,0)
	;;=be produced for this item when separate supplemental feeding
	;;^DD(118,5,21,3,0)
	;;=labels for each item have been specified in the site
	;;^DD(118,5,21,4,0)
	;;=parameters.
	;;^DD(118,5,"DT")
	;;=2850320
	;;^DD(118,7,0)
	;;=VEHICLE FOR MEDS?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(118,7,21,0)
	;;=^^2^2^2880717^
	;;^DD(118,7,21,1,0)
	;;=This field, when answered YES, means that the supplemental
	;;^DD(118,7,21,2,0)
	;;=feeding is typically used as a vehicle for meds.
	;;^DD(118,7,"DT")
	;;=2850606
	;;^DD(118,10,0)
	;;=BULK ONLY?^S^Y:YES;N:NO;^0;3^Q
	;;^DD(118,10,21,0)
	;;=^^3^3^2880717^
	;;^DD(118,10,21,1,0)
	;;=This field, when answered YES, means that this supplemental
	;;^DD(118,10,21,2,0)
	;;=feeding item can ONLY be selected as a bulk feeding for ward
	;;^DD(118,10,21,3,0)
	;;=delivery and may not be selected as an individual feeding item.
	;;^DD(118,10,"DT")
	;;=2850604
	;;^DD(118,11,0)
	;;=CORRESPONDING RECIPE^P114'^FH(114,^0;7^Q
	;;^DD(118,11,21,0)
	;;=^^3^3^2901217^
	;;^DD(118,11,21,1,0)
	;;=This field is a pointer to the recipe in file 114 (the Recipe file)
	;;^DD(118,11,21,2,0)
	;;=which contains the ingredients for this feeding. Cost and other data
	;;^DD(118,11,21,3,0)
	;;=for this feeding will be retrieved from the recipe file.
	;;^DD(118,11,"DT")
	;;=2900929
	;;^DD(118,20,0)
	;;=COST^CJ8,2^^ ; ^X ^DD(118,20,9.2) S X=$P(Y(118,20,101),U,13) S D0=Y(118,20,80) S X=$J(X,0,2)
	;;^DD(118,20,9)
	;;=^
	;;^DD(118,20,9.01)
	;;=114^101;118^11
	;;^DD(118,20,9.1)
	;;=CORRESPONDING RECIPE:COST/PORTION
	;;^DD(118,20,9.2)
	;;=S Y(118,20,80)=$S($D(D0):D0,1:""),Y(118,20,1)=$S($D(^FH(118,D0,0)):^(0),1:""),D0=$P(Y(118,20,1),U,7) S:'$D(^FH(114,+D0,0)) D0=-1 S Y(118,20,101)=$S($D(^FH(114,D0,0)):^(0),1:"")
	;;^DD(118,20,21,0)
	;;=^^3^3^2950613^^^^
	;;^DD(118,20,21,1,0)
	;;=This is the portion cost of the supplemental feeding and is a
