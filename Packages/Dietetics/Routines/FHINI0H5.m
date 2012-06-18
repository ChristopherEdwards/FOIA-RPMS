FHINI0H5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(113)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(113,0,"GL")
	;;=^FHING(
	;;^DIC("B","INGREDIENT",113)
	;;=
	;;^DIC(113,"%D",0)
	;;=^^6^6^2950221^^
	;;^DIC(113,"%D",1,0)
	;;=This file is the master list of ingredients used in preparing
	;;^DIC(113,"%D",2,0)
	;;=recipes. It contains purchasing information, such as stock number
	;;^DIC(113,"%D",3,0)
	;;=and vendor, issuance data such as the issuing unit, and various
	;;^DIC(113,"%D",4,0)
	;;=conversion factors. Nutritive data such as food group, poundage
	;;^DIC(113,"%D",5,0)
	;;=factors, and a pointer to the analogous food nutrient item in
	;;^DIC(113,"%D",6,0)
	;;=File 112 are also included.
	;;^DD(113,0)
	;;=FIELD^^31^22
	;;^DD(113,0,"DT")
	;;=2930211
	;;^DD(113,0,"IX","B",113,.01)
	;;=
	;;^DD(113,0,"IX","C",113,2)
	;;=
	;;^DD(113,0,"NM","INGREDIENT")
	;;=
	;;^DD(113,0,"PT",114.01,.01)
	;;=
	;;^DD(113,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>50!($L(X)<3)!'(X'?1P.E) X
	;;^DD(113,.01,1,0)
	;;=^.1
	;;^DD(113,.01,1,1,0)
	;;=113^B
	;;^DD(113,.01,1,1,1)
	;;=S ^FHING("B",$E(X,1,30),DA)=""
	;;^DD(113,.01,1,1,2)
	;;=K ^FHING("B",$E(X,1,30),DA)
	;;^DD(113,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(113,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(113,.01,3)
	;;=ANSWER MUST BE 3-50 CHARACTERS IN LENGTH
	;;^DD(113,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(113,.01,21,1,0)
	;;=This is the name of the ingredient which is an ordered item
	;;^DD(113,.01,21,2,0)
	;;=generally and which is used in the preparation of recipes.
	;;^DD(113,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(113,1,0)
	;;=SUPPLY DESCRIPTION^RF^^0;2^K:$L(X)>21!($L(X)<3) X
	;;^DD(113,1,3)
	;;=ANSWER MUST BE 3-21 CHARACTERS IN LENGTH
	;;^DD(113,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(113,1,21,1,0)
	;;=This is a short description which will be used on purchase
	;;^DD(113,1,21,2,0)
	;;=orders.
	;;^DD(113,1,"DT")
	;;=2880227
	;;^DD(113,2,0)
	;;=STOCK NUMBER^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>16!($L(X)<1) X
	;;^DD(113,2,1,0)
	;;=^.1
	;;^DD(113,2,1,1,0)
	;;=113^C^MUMPS
	;;^DD(113,2,1,1,1)
	;;=S ^FHING("C",$E(X,$L(X)-3,$L(X)),DA)=""
	;;^DD(113,2,1,1,2)
	;;=K ^FHING("C",$E(X,$L(X)-3,$L(X)),DA)
	;;^DD(113,2,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(113,2,1,1,"%D",1,0)
	;;=This cross-reference consists of the last 4 characters of the
	;;^DD(113,2,1,1,"%D",2,0)
	;;=Stock Number which has been entered.
	;;^DD(113,2,3)
	;;=ANSWER MUST BE 1-16 CHARACTERS IN LENGTH
	;;^DD(113,2,21,0)
	;;=^^3^3^2880710^
	;;^DD(113,2,21,1,0)
	;;=This is the Federal Stock Number (with hyphens) for items
	;;^DD(113,2,21,2,0)
	;;=obtained from VA Depots or DLA. It may be the local vendor's
	;;^DD(113,2,21,3,0)
	;;=number for other items.
	;;^DD(113,2,"DT")
	;;=2880227
	;;^DD(113,3,0)
	;;=VENDOR^P113.2^FH(113.2,^0;4^Q
	;;^DD(113,3,21,0)
	;;=^^2^2^2880710^
	;;^DD(113,3,21,1,0)
	;;=This field indicates the current vendor from whom the item
	;;^DD(113,3,21,2,0)
	;;=is procured.
	;;^DD(113,3,"DT")
	;;=2861023
	;;^DD(113,4,0)
	;;=UNIT OF PURCHASE (U/P)^RF^^0;5^K:$L(X)>2!($L(X)<2) X
	;;^DD(113,4,3)
	;;=ANSWER MUST BE 2 CHARACTERS IN LENGTH
	;;^DD(113,4,21,0)
	;;=^^3^3^2890208^^
	;;^DD(113,4,21,1,0)
	;;=This is a two-character abbreviation indicating the unit
	;;^DD(113,4,21,2,0)
	;;=of purchase and is such things as CN for can, PK for
	;;^DD(113,4,21,3,0)
	;;=package, CS for case, etc.
	;;^DD(113,4,"DT")
	;;=2890208
	;;^DD(113,5,0)
	;;=DIETETIC UNIT OF ISSUE^RP119.1X^FH(119.1,^0;6^I $D(X) S X=$P(^FH(119.1,+X,0),"^",1)
	;;^DD(113,5,21,0)
	;;=^^3^3^2920522^^^
	;;^DD(113,5,21,1,0)
	;;=This is the unit of issue that dietetic personnel or supply
	;;^DD(113,5,21,2,0)
	;;=personnel use for dispensing the item to ingredient control.
	;;^DD(113,5,21,3,0)
	;;=It is generally a #10-can or similar description.
	;;^DD(113,6,0)
	;;=ORDERING MULTIPLE (OF U/P)^NJ4,0^^0;7^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(113,6,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(113,6,21,0)
	;;=^^4^4^2880710^
	;;^DD(113,6,21,1,0)
	;;=If the vendor requires that the unit of purchase be bought
	;;^DD(113,6,21,2,0)
	;;=in some multiple, like 6 or 12 or 24, then that multiple
	;;^DD(113,6,21,3,0)
	;;=is indicated here. VA Depot is the most common vendor
	;;^DD(113,6,21,4,0)
	;;=requiring such multiples.
	;;^DD(113,6,"DT")
	;;=2880227
	;;^DD(113,7,0)
	;;=NO. OF ISSUE UNITS IN A U/P^RNJ9,4^^0;8^K:+X'=X!(X>9999)!(X<.0001)!(X?.E1"."5N.N) X
	;;^DD(113,7,3)
	;;=TYPE A NUMBER BETWEEN .0001 AND 9999
	;;^DD(113,7,21,0)
	;;=^^4^4^2880710^
	;;^DD(113,7,21,1,0)
	;;=This is the number of Dietetic issue units in a unit of
	;;^DD(113,7,21,2,0)
	;;=purchase. If the U/P (unit of Purchase) is a CS that
