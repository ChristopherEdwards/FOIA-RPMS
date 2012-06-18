FHINI006	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(111.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(111.116,1,21,1,0)
	;;=This is the selected quantity for the Recipe Category.  This quantity
	;;^DD(111.116,1,21,2,0)
	;;=determines the amount of the recipe on the Tray Ticket.  If a zero
	;;^DD(111.116,1,21,3,0)
	;;=is entered, the recipe is omitted.
	;;^DD(111.116,1,"DT")
	;;=2940706
	;;^DD(111.117,0)
	;;=EVENING MODIFICATIONS SUB-FIELD^^1^2
	;;^DD(111.117,0,"DT")
	;;=2940706
	;;^DD(111.117,0,"IX","B",111.117,.01)
	;;=
	;;^DD(111.117,0,"NM","EVENING MODIFICATIONS")
	;;=
	;;^DD(111.117,0,"UP")
	;;=111.1
	;;^DD(111.117,.01,0)
	;;=EVENING MODIFICATIONS^MP114.1'^FH(114.1,^0;1^Q
	;;^DD(111.117,.01,1,0)
	;;=^.1
	;;^DD(111.117,.01,1,1,0)
	;;=111.117^B
	;;^DD(111.117,.01,1,1,1)
	;;=S ^FH(111.1,DA(1),"E","B",$E(X,1,30),DA)=""
	;;^DD(111.117,.01,1,1,2)
	;;=K ^FH(111.1,DA(1),"E","B",$E(X,1,30),DA)
	;;^DD(111.117,.01,21,0)
	;;=^^5^5^2940526^^^
	;;^DD(111.117,.01,21,1,0)
	;;=This is the Recipe Category selected from the file (114.1) for the
	;;^DD(111.117,.01,21,2,0)
	;;=evening meal for the selected diet modifications.  It determines
	;;^DD(111.117,.01,21,3,0)
	;;=which recipes each patient under the diet modifications will
	;;^DD(111.117,.01,21,4,0)
	;;=receive on the Tray Ticket.  This Recipe Category is also used
	;;^DD(111.117,.01,21,5,0)
	;;=in producing the Diet Cards.
	;;^DD(111.117,.01,"DT")
	;;=2940103
	;;^DD(111.117,1,0)
	;;=QUANTITY^RNJ4,2^^0;2^K:+X'=X!(X>9.99)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(111.117,1,3)
	;;=Type a Number between 0 and 9.99, 2 Decimal Digits
	;;^DD(111.117,1,21,0)
	;;=^^3^3^2940526^
	;;^DD(111.117,1,21,1,0)
	;;=This is the selected quantity for the Recipe Category.  This quantity
	;;^DD(111.117,1,21,2,0)
	;;=determines the amount of the recipe on the Tray Ticket.  If a zero
	;;^DD(111.117,1,21,3,0)
	;;=is entered, the recipe is omitted.
	;;^DD(111.117,1,"DT")
	;;=2940706
	;;^DD(111.119,0)
	;;=DIET RESTRICTION SUB-FIELD^^1^2
	;;^DD(111.119,0,"DT")
	;;=2950418
	;;^DD(111.119,0,"IX","B",111.119,.01)
	;;=
	;;^DD(111.119,0,"NM","DIET RESTRICTION")
	;;=
	;;^DD(111.119,0,"UP")
	;;=111.1
	;;^DD(111.119,.01,0)
	;;=DIET RESTRICTION^M*P115.2'^FH(115.2,^0;1^S DIC("S")="I $P(^(0),U,2)=""D""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(111.119,.01,1,0)
	;;=^.1
	;;^DD(111.119,.01,1,1,0)
	;;=111.119^B
	;;^DD(111.119,.01,1,1,1)
	;;=S ^FH(111.1,DA(1),"RES","B",$E(X,1,30),DA)=""
	;;^DD(111.119,.01,1,1,2)
	;;=K ^FH(111.1,DA(1),"RES","B",$E(X,1,30),DA)
	;;^DD(111.119,.01,12)
	;;=This screen allows the user to only select the dislikes from the Food Preference file.
	;;^DD(111.119,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""D"""
	;;^DD(111.119,.01,21,0)
	;;=^^1^1^2950403^^^^
	;;^DD(111.119,.01,21,1,0)
	;;=This is the dislike food preference from the file (115.2).
	;;^DD(111.119,.01,"DT")
	;;=2950403
	;;^DD(111.119,1,0)
	;;=MEALS^RFX^^0;2^S:$P("ALL",X,1)="" X="BNE" S %=X,X="" S:%["B" X="B" S:%["N" X=X_"N" S:%["E" X=X_"E" K:$L(%)'=$L(X) X K %
	;;^DD(111.119,1,3)
	;;=Answer should be a string of meals (e.g., B or BN or BNE) or A for all meals.
	;;^DD(111.119,1,21,0)
	;;=^^2^2^2950418^^^
	;;^DD(111.119,1,21,1,0)
	;;=This field contains the meals (B N and E) for which this diet
	;;^DD(111.119,1,21,2,0)
	;;=restriction is applicable.
	;;^DD(111.119,1,"DT")
	;;=2950418
	;;^DD(111.12,0)
	;;=ASSOCIATED STANDING ORDERS (N) SUB-FIELD^^1^2
	;;^DD(111.12,0,"DT")
	;;=2940722
	;;^DD(111.12,0,"IX","B",111.12,.01)
	;;=
	;;^DD(111.12,0,"NM","ASSOCIATED STANDING ORDERS (N)")
	;;=
	;;^DD(111.12,0,"UP")
	;;=111.1
	;;^DD(111.12,.01,0)
	;;=ASSOCIATED STANDING ORDERS (N)^MP118.3'^FH(118.3,^0;1^Q
	;;^DD(111.12,.01,1,0)
	;;=^.1
	;;^DD(111.12,.01,1,1,0)
	;;=111.12^B
	;;^DD(111.12,.01,1,1,1)
	;;=S ^FH(111.1,DA(1),"NS","B",$E(X,1,30),DA)=""
	;;^DD(111.12,.01,1,1,2)
	;;=K ^FH(111.1,DA(1),"NS","B",$E(X,1,30),DA)
	;;^DD(111.12,.01,21,0)
	;;=^^3^3^2950717^^
	;;^DD(111.12,.01,21,1,0)
	;;=The Standing Orders on this multiple will all be added to the patient's
	;;^DD(111.12,.01,21,2,0)
	;;=Standing Order entries for the meal noon when this diet or diet
	;;^DD(111.12,.01,21,3,0)
	;;=modification is ordered for the patient.
	;;^DD(111.12,.01,"DT")
	;;=2940721
	;;^DD(111.12,1,0)
	;;=QUANTITY^NJ1,0^^0;2^K:+X'=X!(X>9)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(111.12,1,3)
	;;=Type a Number between 1 and 9, 0 Decimal Digits
	;;^DD(111.12,1,21,0)
	;;=^^1^1^2940722^
	;;^DD(111.12,1,21,1,0)
	;;=This is the quantity of the Standing Order.
	;;^DD(111.12,1,"DT")
	;;=2940722
	;;^DD(111.13,0)
	;;=ASSOCIATED STANDING ORDERS (E) SUB-FIELD^^1^2
	;;^DD(111.13,0,"DT")
	;;=2940722
	;;^DD(111.13,0,"IX","B",111.13,.01)
	;;=
	;;^DD(111.13,0,"NM","ASSOCIATED STANDING ORDERS (E)")
	;;=
