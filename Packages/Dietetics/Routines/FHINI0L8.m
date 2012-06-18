FHINI0L8	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(116.1,0,"GL")
	;;=^FH(116.1,
	;;^DIC("B","MEAL",116.1)
	;;=
	;;^DIC(116.1,"%D",0)
	;;=^^6^6^2880515^
	;;^DIC(116.1,"%D",1,0)
	;;=This file contains the various meals served by the institution. A
	;;^DIC(116.1,"%D",2,0)
	;;=meal consists of all recipes prepared for a breakfast, noon, or
	;;^DIC(116.1,"%D",3,0)
	;;=evening meal as well as the production diets associated with
	;;^DIC(116.1,"%D",4,0)
	;;=each recipe. In turn, the production diet entry may indicate the
	;;^DIC(116.1,"%D",5,0)
	;;=percentage of that recipe that is to be served in a cafeteria
	;;^DIC(116.1,"%D",6,0)
	;;=or by tray.
	;;^DD(116.1,0)
	;;=FIELD^^1^2
	;;^DD(116.1,0,"DT")
	;;=2950329
	;;^DD(116.1,0,"IX","B",116.1,.01)
	;;=
	;;^DD(116.1,0,"NM","MEAL")
	;;=
	;;^DD(116.1,0,"PT",112.62,2)
	;;=
	;;^DD(116.1,0,"PT",116.01,1)
	;;=
	;;^DD(116.1,0,"PT",116.01,2)
	;;=
	;;^DD(116.1,0,"PT",116.01,3)
	;;=
	;;^DD(116.1,0,"PT",116.3,2)
	;;=
	;;^DD(116.1,0,"PT",116.3,3)
	;;=
	;;^DD(116.1,0,"PT",116.3,4)
	;;=
	;;^DD(116.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(116.1,.01,1,0)
	;;=^.1
	;;^DD(116.1,.01,1,1,0)
	;;=116.1^B
	;;^DD(116.1,.01,1,1,1)
	;;=S ^FH(116.1,"B",$E(X,1,30),DA)=""
	;;^DD(116.1,.01,1,1,2)
	;;=K ^FH(116.1,"B",$E(X,1,30),DA)
	;;^DD(116.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(116.1,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(116.1,.01,21,0)
	;;=^^3^3^2880710^
	;;^DD(116.1,.01,21,1,0)
	;;=This is the name of a meal which is a collection of all
	;;^DD(116.1,.01,21,2,0)
	;;=recipes which will be served at a given breakfast, noon
	;;^DD(116.1,.01,21,3,0)
	;;=or evening meal.
	;;^DD(116.1,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(116.1,.01,"DT")
	;;=2930224
	;;^DD(116.1,1,0)
	;;=RECIPE^116.11P^^RE;0
	;;^DD(116.1,1,21,0)
	;;=^^2^2^2931220^^^^
	;;^DD(116.1,1,21,1,0)
	;;=This multiple contains the various recipes which will be
	;;^DD(116.1,1,21,2,0)
	;;=served for the meal.
	;;^DD(116.11,0)
	;;=RECIPE SUB-FIELD^NL^10^5
	;;^DD(116.11,0,"DT")
	;;=2950329
	;;^DD(116.11,0,"IX","B",116.11,.01)
	;;=
	;;^DD(116.11,0,"NM","RECIPE")
	;;=
	;;^DD(116.11,0,"UP")
	;;=116.1
	;;^DD(116.11,.01,0)
	;;=RECIPE^MP114'^FH(114,^0;1^Q
	;;^DD(116.11,.01,1,0)
	;;=^.1
	;;^DD(116.11,.01,1,1,0)
	;;=116.11^B
	;;^DD(116.11,.01,1,1,1)
	;;=S ^FH(116.1,DA(1),"RE","B",$E(X,1,30),DA)=""
	;;^DD(116.11,.01,1,1,2)
	;;=K ^FH(116.1,DA(1),"RE","B",$E(X,1,30),DA)
	;;^DD(116.11,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.11,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the RECIPE field.
	;;^DD(116.11,.01,21,0)
	;;=^^1^1^2880710^
	;;^DD(116.11,.01,21,1,0)
	;;=This is the recipe (File 114) which will be served.
	;;^DD(116.11,.01,"DT")
	;;=2880919
	;;^DD(116.11,1,0)
	;;=PRODUCTION DIETS^RFX^^0;2^K:$L(X)>200!($L(X)<2) X I $D(X) D EN2^FHPRC1
	;;^DD(116.11,1,3)
	;;=
	;;^DD(116.11,1,4)
	;;=D EN3^FHPRC1
	;;^DD(116.11,1,21,0)
	;;=^^4^4^2931222^^^^
	;;^DD(116.11,1,21,1,0)
	;;=This is a list of the production diets which will receive the
	;;^DD(116.11,1,21,2,0)
	;;=recipe. It is a syntactically complex field containing the
	;;^DD(116.11,1,21,3,0)
	;;=production diet code and any specialized tray and cafeteria %'s
	;;^DD(116.11,1,21,4,0)
	;;=associated with that production diet.
	;;^DD(116.11,1,"DT")
	;;=2851217
	;;^DD(116.11,2,0)
	;;=POPULARITY^116.112P^^D;0
	;;^DD(116.11,2,21,0)
	;;=^^2^2^2911212^^^
	;;^DD(116.11,2,21,1,0)
	;;=This mutiple contains popularity (or selection percentages) for
	;;^DD(116.11,2,21,2,0)
	;;=tray and cafeteria for each Service Point.
	;;^DD(116.11,3,0)
	;;=CATEGORY^RP114.1'^FH(114.1,^0;3^Q
	;;^DD(116.11,3,21,0)
	;;=^^1^1^2940412^^
	;;^DD(116.11,3,21,1,0)
	;;=This is the Recipe Category (File 114.1) for this recipe in this meal.
	;;^DD(116.11,3,"DT")
	;;=2940120
	;;^DD(116.11,10,0)
	;;=RECIPE CATEGORY^116.12PA^^R;0
	;;^DD(116.11,10,21,0)
	;;=^^3^3^2950605^^
	;;^DD(116.11,10,21,1,0)
	;;=This is a list of different recipe categories which may
	;;^DD(116.11,10,21,2,0)
	;;=characterize this recipe.  The multiple also contains the
	;;^DD(116.11,10,21,3,0)
	;;=production diets to which this category applies.
	;;^DD(116.112,0)
	;;=POPULARITY SUB-FIELD^^1^2
	;;^DD(116.112,0,"DT")
	;;=2911203
	;;^DD(116.112,0,"IX","B",116.112,.01)
	;;=
	;;^DD(116.112,0,"NM","POPULARITY")
	;;=
	;;^DD(116.112,0,"UP")
	;;=116.11
	;;^DD(116.112,.01,0)
	;;=SERVICE POINT^MP119.72'X^FH(119.72,^0;1^I $D(X) S DINUM=X
	;;^DD(116.112,.01,1,0)
	;;=^.1
	;;^DD(116.112,.01,1,1,0)
	;;=116.112^B
	;;^DD(116.112,.01,1,1,1)
	;;=S ^FH(116.1,DA(2),"RE",DA(1),"D","B",$E(X,1,30),DA)=""
