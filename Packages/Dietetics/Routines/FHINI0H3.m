FHINI0H3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(112.6,0,"GL")
	;;=^FHUM(
	;;^DIC("B","USER MENU",112.6)
	;;=
	;;^DIC(112.6,"%D",0)
	;;=^^2^2^2871124^
	;;^DIC(112.6,"%D",1,0)
	;;=This file contains menus of food items, classified by day and meal,
	;;^DIC(112.6,"%D",2,0)
	;;=which are saved for nutrient analysis.
	;;^DD(112.6,0)
	;;=FIELD^^2^6
	;;^DD(112.6,0,"DT")
	;;=2931124
	;;^DD(112.6,0,"ID",.7)
	;;=W:$D(^("0")) "   ",$E($P(^("0"),U,3),4,5)_"-"_$E($P(^("0"),U,3),6,7)_"-"_$E($P(^("0"),U,3),2,3)
	;;^DD(112.6,0,"IX","B",112.6,.01)
	;;=
	;;^DD(112.6,0,"NM","USER MENU")
	;;=
	;;^DD(112.6,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(112.6,.01,1,0)
	;;=^.1
	;;^DD(112.6,.01,1,1,0)
	;;=112.6^B
	;;^DD(112.6,.01,1,1,1)
	;;=S ^FHUM("B",$E(X,1,30),DA)=""
	;;^DD(112.6,.01,1,1,2)
	;;=K ^FHUM("B",$E(X,1,30),DA)
	;;^DD(112.6,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(112.6,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(112.6,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(112.6,.01,21,0)
	;;=^^3^3^2880717^
	;;^DD(112.6,.01,21,1,0)
	;;=This field contains the name of a user menu. This is a list of
	;;^DD(112.6,.01,21,2,0)
	;;=food items, and amounts, that a user wishes to have analyzed
	;;^DD(112.6,.01,21,3,0)
	;;=for nutrient content.
	;;^DD(112.6,.01,"DT")
	;;=2850517
	;;^DD(112.6,.6,0)
	;;=UNITS^RS^C:COMMON;G:GRAMS;^0;2^Q
	;;^DD(112.6,.6,21,0)
	;;=^^2^2^2940616^^
	;;^DD(112.6,.6,21,1,0)
	;;=This field indicates whether common units are used in specifying
	;;^DD(112.6,.6,21,2,0)
	;;=quantities or whether grams are used throughout.
	;;^DD(112.6,.6,"DT")
	;;=2841102
	;;^DD(112.6,.7,0)
	;;=DATE ENTERED^D^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(112.6,.7,21,0)
	;;=^^2^2^2880717^
	;;^DD(112.6,.7,21,1,0)
	;;=This field indicates the date on which this user menu was first
	;;^DD(112.6,.7,21,2,0)
	;;=created.
	;;^DD(112.6,.7,"DT")
	;;=2841102
	;;^DD(112.6,.8,0)
	;;=USER^P200'^VA(200,^0;4^Q
	;;^DD(112.6,.8,21,0)
	;;=^^1^1^2880717^
	;;^DD(112.6,.8,21,1,0)
	;;=This field indicates the person who first created the user menu.
	;;^DD(112.6,.8,"DT")
	;;=2841102
	;;^DD(112.6,1,0)
	;;=DAY NUMBER^112.61^^1;0
	;;^DD(112.6,1,21,0)
	;;=^^3^3^2931116^^^^
	;;^DD(112.6,1,21,1,0)
	;;=This field contains the sequence number, or day number, of the
	;;^DD(112.6,1,21,2,0)
	;;=days represented by this menu. It is normally 1 to the maximum
	;;^DD(112.6,1,21,3,0)
	;;=number of used entered.
	;;^DD(112.6,2,0)
	;;=RECIPE MENU?^S^1:YES;0:NO;^0;5^Q
	;;^DD(112.6,2,21,0)
	;;=^^2^2^2950221^^^^
	;;^DD(112.6,2,21,1,0)
	;;=This field, if answered yes, means this user menu is a recipe
	;;^DD(112.6,2,21,2,0)
	;;=menu else, if answered no, means it is not.
	;;^DD(112.6,2,"DT")
	;;=2931116
	;;^DD(112.61,0)
	;;=DAY NUMBER SUB-FIELD^NL^1^2
	;;^DD(112.61,0,"DT")
	;;=2931124
	;;^DD(112.61,0,"NM","DAY NUMBER")
	;;=
	;;^DD(112.61,0,"UP")
	;;=112.6
	;;^DD(112.61,.01,0)
	;;=DAY NUMBER^MRNJ2,0X^^0;1^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(112.61,.01,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 7
	;;^DD(112.61,.01,21,0)
	;;=^^1^1^2931117^^
	;;^DD(112.61,.01,21,1,0)
	;;=This is the day number for which meals will be entered.
	;;^DD(112.61,.01,"DT")
	;;=2931117
	;;^DD(112.61,1,0)
	;;=MEAL NUMBER^112.62^^1;0
	;;^DD(112.61,1,21,0)
	;;=^^4^4^2931117^^
	;;^DD(112.61,1,21,1,0)
	;;=This is the meal number for which food items will be entered.
	;;^DD(112.61,1,21,2,0)
	;;=It is merely a sequence number and individual meals, such as
	;;^DD(112.61,1,21,3,0)
	;;=breakfast, noon, and evening are not referenced as such since
	;;^DD(112.61,1,21,4,0)
	;;=meals may be snack times, or other eating times.
	;;^DD(112.62,0)
	;;=MEAL NUMBER SUB-FIELD^NL^4^5
	;;^DD(112.62,0,"DT")
	;;=2931124
	;;^DD(112.62,0,"NM","MEAL NUMBER")
	;;=
	;;^DD(112.62,0,"UP")
	;;=112.61
	;;^DD(112.62,.01,0)
	;;=MEAL NUMBER^MRNJ1,0X^^0;1^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(112.62,.01,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 6
	;;^DD(112.62,.01,21,0)
	;;=^^1^1^2931116^^
	;;^DD(112.62,.01,21,1,0)
	;;=This is the meal number for which food items will be entered.
	;;^DD(112.62,.01,"DT")
	;;=2931116
	;;^DD(112.62,1,0)
	;;=FOOD ITEM^112.63P^^1;0
	;;^DD(112.62,1,21,0)
	;;=^^2^2^2931117^^^
	;;^DD(112.62,1,21,1,0)
	;;=This multiple represents the food items, selected from the
	;;^DD(112.62,1,21,2,0)
	;;=Food Nutrient file, which are represented in the meal.
	;;^DD(112.62,2,0)
	;;=MEAL^P116.1'^FH(116.1,^0;2^Q
	;;^DD(112.62,2,21,0)
	;;=^^1^1^2931220^^^^
	;;^DD(112.62,2,21,1,0)
	;;=This field represents the meal file.
