FHINI0MP	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.71)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.71,0,"GL")
	;;=^FH(119.71,
	;;^DIC("B","PRODUCTION FACILITY",119.71)
	;;=
	;;^DIC(119.71,"%D",0)
	;;=^^3^3^2911204^
	;;^DIC(119.71,"%D",1,0)
	;;=This file is a list of Production Facilities and associated
	;;^DIC(119.71,"%D",2,0)
	;;=parameters. A Production Facility is generally a main kitchen where
	;;^DIC(119.71,"%D",3,0)
	;;=bulk food is prepared for use by Service Points.
	;;^DD(119.71,0)
	;;=FIELD^^14^6
	;;^DD(119.71,0,"IX","B",119.71,.01)
	;;=
	;;^DD(119.71,0,"NM","PRODUCTION FACILITY")
	;;=
	;;^DD(119.71,0,"PT",119.72,2)
	;;=
	;;^DD(119.71,0,"PT",119.74,2)
	;;=
	;;^DD(119.71,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(119.71,.01,1,0)
	;;=^.1
	;;^DD(119.71,.01,1,1,0)
	;;=119.71^B
	;;^DD(119.71,.01,1,1,1)
	;;=S ^FH(119.71,"B",$E(X,1,30),DA)=""
	;;^DD(119.71,.01,1,1,2)
	;;=K ^FH(119.71,"B",$E(X,1,30),DA)
	;;^DD(119.71,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.71,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.71,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(119.71,.01,21,0)
	;;=^^3^3^2911204^
	;;^DD(119.71,.01,21,1,0)
	;;=This is the name of the Production Facility. It is generally a main
	;;^DD(119.71,.01,21,2,0)
	;;=kitchen used for the preparation of bulk food to be served by a 
	;;^DD(119.71,.01,21,3,0)
	;;=Service Point.
	;;^DD(119.71,10,0)
	;;=FULL NAMES ON DAILY MENU?^S^Y:YES;N:NO;^0;2^Q
	;;^DD(119.71,10,21,0)
	;;=^^4^4^2881203^
	;;^DD(119.71,10,21,1,0)
	;;=This field, when answered YES, will result in full names of
	;;^DD(119.71,10,21,2,0)
	;;=recipes being used for modified diets on the Daily Diet
	;;^DD(119.71,10,21,3,0)
	;;=Menus. An answer of NO will result in items on the Regular
	;;^DD(119.71,10,21,4,0)
	;;=Menu being referenced by number.
	;;^DD(119.71,10,"DT")
	;;=2881203
	;;^DD(119.71,11,0)
	;;=SEP. PRODUCTION SUMMARY PAGES?^S^Y:YES;N:NO;^0;7^Q
	;;^DD(119.71,11,21,0)
	;;=^^3^3^2881120^
	;;^DD(119.71,11,21,1,0)
	;;=This field, when answered YES, will result in the Production
	;;^DD(119.71,11,21,2,0)
	;;=Summary and the Meal Distribution Report being printed on
	;;^DD(119.71,11,21,3,0)
	;;=separate pages for each Recipe Preparation area.
	;;^DD(119.71,11,"DT")
	;;=2881120
	;;^DD(119.71,12,0)
	;;=SEP. RECIPE PREPARATION PAGES?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(119.71,12,21,0)
	;;=^^3^3^2881119^^
	;;^DD(119.71,12,21,1,0)
	;;=This field, when answered YES, means that the Recipe Preparation
	;;^DD(119.71,12,21,2,0)
	;;=pages produced by the Production Summary will be printed such
	;;^DD(119.71,12,21,3,0)
	;;=that each preparation area is on a separate page.
	;;^DD(119.71,12,"DT")
	;;=2871122
	;;^DD(119.71,13,0)
	;;=PRINT MEAL DISTRIBUTION?^S^Y:YES;N:NO;^0;5^Q
	;;^DD(119.71,13,21,0)
	;;=^^2^2^2881119^^
	;;^DD(119.71,13,21,1,0)
	;;=This field indicates whether a Meal Distribution Report
	;;^DD(119.71,13,21,2,0)
	;;=should be printed along with the Production Summary.
	;;^DD(119.71,13,"DT")
	;;=2881118
	;;^DD(119.71,14,0)
	;;=SEP. STOREROOM PAGES?^S^Y:YES;N:NO;^0;6^Q
	;;^DD(119.71,14,21,0)
	;;=^^3^3^2880716^
	;;^DD(119.71,14,21,1,0)
	;;=This field, when answered YES, means that the Storeroom
	;;^DD(119.71,14,21,2,0)
	;;=Requisition pages produced by the Production Summary will be
	;;^DD(119.71,14,21,3,0)
	;;=printed such that each storeroom is on a separate page.
	;;^DD(119.71,14,"DT")
	;;=2871122
