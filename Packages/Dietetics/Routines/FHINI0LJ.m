FHINI0LJ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(117.2,0,"GL")
	;;=^FH(117.2,
	;;^DIC("B","DIETETIC COST OF MEALS",117.2)
	;;=
	;;^DIC(117.2,"%D",0)
	;;=^^4^4^2920623^^^^
	;;^DIC(117.2,"%D",1,0)
	;;=This file is used to store the monthly costs of the various
	;;^DIC(117.2,"%D",2,0)
	;;=food groups. Data is used to calculate the cost of meals
	;;^DIC(117.2,"%D",3,0)
	;;=served as well as ensure an adequate distribution of
	;;^DIC(117.2,"%D",4,0)
	;;=food across the food groups.
	;;^DD(117.2,0)
	;;=FIELD^^24^25
	;;^DD(117.2,0,"DDA")
	;;=N
	;;^DD(117.2,0,"DT")
	;;=2930618
	;;^DD(117.2,0,"IX","B",117.2,.01)
	;;=
	;;^DD(117.2,0,"NM","DIETETIC COST OF MEALS")
	;;=
	;;^DD(117.2,.01,0)
	;;=MONTH/YEAR^RDX^^0;1^S %DT="E" D ^%DT S X=$E(Y,1,5)_"00" K:Y<1 X I $D(X) S DINUM=X
	;;^DD(117.2,.01,1,0)
	;;=^.1
	;;^DD(117.2,.01,1,1,0)
	;;=117.2^B
	;;^DD(117.2,.01,1,1,1)
	;;=S ^FH(117.2,"B",$E(X,1,30),DA)=""
	;;^DD(117.2,.01,1,1,2)
	;;=K ^FH(117.2,"B",$E(X,1,30),DA)
	;;^DD(117.2,.01,1,1,"%D",0)
	;;=^^1^1^2931221^^
	;;^DD(117.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the MONTH/YEAR field.
	;;^DD(117.2,.01,3)
	;;=ENTER A MONTH AND A YEAR, ej. 1 92, 11-92, 3/92.
	;;^DD(117.2,.01,21,0)
	;;=^^1^1^2930621^^^^
	;;^DD(117.2,.01,21,1,0)
	;;=Enter Month and Year.
	;;^DD(117.2,.01,"DT")
	;;=2931027
	;;^DD(117.2,1,0)
	;;=BEG INV GRP 1^NJ6,0^^0;2^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,1,3)
	;;=Enter an Amount between 0 and 999999 for the Beg Inv Cost for Food Group I
	;;^DD(117.2,1,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,1,21,1,0)
	;;=Enter Beginning Inventory Cost for Food Group I.
	;;^DD(117.2,1,"DT")
	;;=2910517
	;;^DD(117.2,2,0)
	;;=BEG INV GRP 2^NJ6,0^^0;3^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,2,3)
	;;=Enter an Amount between 0 and 999999 for Beg Inv Cost of Food Group II
	;;^DD(117.2,2,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,2,21,1,0)
	;;=Enter Beginning Inventory Cost For Food Group II.
	;;^DD(117.2,2,"DT")
	;;=2910506
	;;^DD(117.2,3,0)
	;;=BEG INV GRP 3^NJ6,0^^0;4^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,3,3)
	;;=Enter an Amount between 0 and 999999 for the Beg Inv Cost of Food Group III
	;;^DD(117.2,3,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,3,21,1,0)
	;;=Enter the Beginning Inventory Cost of Food Group III.
	;;^DD(117.2,3,"DT")
	;;=2910506
	;;^DD(117.2,4,0)
	;;=BEG INV GRP 4^NJ6,0^^0;5^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,4,3)
	;;=Enter an Amount between 0 and 999999 for the Beg Inv Cost of Food Group IV
	;;^DD(117.2,4,21,0)
	;;=^^1^1^2920501^^^
	;;^DD(117.2,4,21,1,0)
	;;=Enter the Beginning Inventory Cost for Food Group IV.
	;;^DD(117.2,4,"DT")
	;;=2910506
	;;^DD(117.2,5,0)
	;;=BEG INV GRP 5^NJ6,0^^0;6^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,5,3)
	;;=Enter an Amount between 0 and 999999 for Beg Inv Cost of Food Group V
	;;^DD(117.2,5,21,0)
	;;=^^1^1^2911113^^
	;;^DD(117.2,5,21,1,0)
	;;=Enter the Beginning Inventory Cost for Food Group V.
	;;^DD(117.2,5,"DT")
	;;=2910506
	;;^DD(117.2,6,0)
	;;=BEG INV GRP 6^NJ6,0^^0;7^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,6,3)
	;;=Enter an Amount between 0 and 999999 for Beg Inv Cost of Food Group VI
	;;^DD(117.2,6,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,6,21,1,0)
	;;=Enter the Beginning Inventory Cost for Food Group VI.
	;;^DD(117.2,6,"DT")
	;;=2910506
	;;^DD(117.2,7,0)
	;;=ISSUE COST GRP 1^NJ7,0^^0;8^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,7,3)
	;;=Enter an Amount between 0 and 9999999 for the Issue Cost of Food Group I
	;;^DD(117.2,7,21,0)
	;;=^^1^1^2911113^^
	;;^DD(117.2,7,21,1,0)
	;;=Enter the Issue Cost For Food Group I.
	;;^DD(117.2,7,"DT")
	;;=2910517
	;;^DD(117.2,8,0)
	;;=ISSUE COST GRP 2^NJ7,0^^0;9^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,8,3)
	;;=Enter an Amount between 0 and 9999999 for Issue Cost of Food Group II
	;;^DD(117.2,8,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,8,21,1,0)
	;;=Enter The Issue Cost for Food Group II.
	;;^DD(117.2,8,"DT")
	;;=2910506
	;;^DD(117.2,9,0)
	;;=ISSUE COST GRP 3^NJ7,0^^0;10^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,9,3)
	;;=Enter an Amount between 0 and 9999999 for Issue Cost of Food Group III
	;;^DD(117.2,9,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,9,21,1,0)
	;;=Enter the Issue Cost for Food Group III.
	;;^DD(117.2,9,"DT")
	;;=2910506
	;;^DD(117.2,10,0)
	;;=ISSUE COST GRP 4^NJ7,0^^0;11^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,10,3)
	;;=Enter an Amount between 0 and 9999999 for Issue Cost of Food Group IV
	;;^DD(117.2,10,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,10,21,1,0)
	;;=Enter the Issue Cost for food Group IV.
	;;^DD(117.2,10,"DT")
	;;=2910506
