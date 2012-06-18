FHINI0LK	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.2,11,0)
	;;=ISSUE COST GRP 5^NJ7,0^^0;12^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,11,3)
	;;=Enter an Amount between 0 and 9999999 for Issue Cost of Food Group V
	;;^DD(117.2,11,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,11,21,1,0)
	;;=Enter the Issue Cost of Food Group V.
	;;^DD(117.2,11,"DT")
	;;=2910506
	;;^DD(117.2,12,0)
	;;=ISSUE COST GRP 6^NJ7,0^^0;13^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,12,3)
	;;=Enter an Amount between 0 and 9999999 for the Issue Cost of Food Group VI
	;;^DD(117.2,12,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,12,21,1,0)
	;;=Enter the Issue Cost of Food Group VI.
	;;^DD(117.2,12,"DT")
	;;=2910506
	;;^DD(117.2,13,0)
	;;=CLOS INV GRP 1^NJ6,0^^0;14^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,13,3)
	;;=Enter an Amount between 0 and 999999 for the Closing Inventory of Food Group I
	;;^DD(117.2,13,21,0)
	;;=^^1^1^2920501^^
	;;^DD(117.2,13,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group I.
	;;^DD(117.2,13,"DT")
	;;=2910506
	;;^DD(117.2,14,0)
	;;=CLOS INV GRP 2^NJ6,0^^0;15^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,14,3)
	;;=Enter an Amount between 0 and 999999 for Closing Inv Cost for Food Group II
	;;^DD(117.2,14,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,14,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group II.
	;;^DD(117.2,14,"DT")
	;;=2910506
	;;^DD(117.2,15,0)
	;;=CLOS INV GRP 3^NJ6,0^^0;16^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,15,3)
	;;=Enter an Amount between 0 and 999999 for the Closing Inv Cost of Food Group III
	;;^DD(117.2,15,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,15,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group III.
	;;^DD(117.2,15,"DT")
	;;=2910506
	;;^DD(117.2,16,0)
	;;=CLOS INV GRP 4^NJ6,0^^0;17^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,16,3)
	;;=Enter an Amount between 0 and 999999 for the Closing Inv Cost of Food Group IV
	;;^DD(117.2,16,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,16,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group IV.
	;;^DD(117.2,16,"DT")
	;;=2910506
	;;^DD(117.2,17,0)
	;;=CLOS INV GRP 5^NJ6,0^^0;18^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,17,3)
	;;=Enter an Amount between 0 and 999999 for Closing Inv Cost for Food Group V
	;;^DD(117.2,17,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,17,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group V.
	;;^DD(117.2,17,"DT")
	;;=2910506
	;;^DD(117.2,18,0)
	;;=CLOS INV GRP 6^NJ6,0^^0;19^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.2,18,3)
	;;=Enter an Amount between 0 and 999999 for the Closing Inv Cost of Food Group VI
	;;^DD(117.2,18,21,0)
	;;=^^1^1^2911113^
	;;^DD(117.2,18,21,1,0)
	;;=Enter the Closing Inventory Cost for Food Group VI.
	;;^DD(117.2,18,"DT")
	;;=2910506
	;;^DD(117.2,19,0)
	;;=% COST GRP 1^NJ2,0^^0;20^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,19,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended
	;;^DD(117.2,19,21,0)
	;;=^^1^1^2950217^^^^
	;;^DD(117.2,19,21,1,0)
	;;=The Percent Cost Recommended for Food Group I.
	;;^DD(117.2,19,"DT")
	;;=2910506
	;;^DD(117.2,20,0)
	;;=% COST GRP 2^NJ2,0^^0;21^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,20,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended of Food Group II
	;;^DD(117.2,20,21,0)
	;;=^^1^1^2950217^^^^
	;;^DD(117.2,20,21,1,0)
	;;=The Percent Cost Recommended for Food Group II.
	;;^DD(117.2,20,"DT")
	;;=2910506
	;;^DD(117.2,21,0)
	;;=% COST GRP 3^NJ2,0^^0;22^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,21,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended of Food Group III
	;;^DD(117.2,21,21,0)
	;;=^^1^1^2950217^^^^
	;;^DD(117.2,21,21,1,0)
	;;=The Percent Cost Recommended for Food Group III.
	;;^DD(117.2,21,"DT")
	;;=2910506
	;;^DD(117.2,22,0)
	;;=% COST GRP 4^NJ2,0^^0;23^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,22,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended of Food Group IV.
	;;^DD(117.2,22,21,0)
	;;=^^1^1^2950217^^^^
	;;^DD(117.2,22,21,1,0)
	;;=The Percent Cost Recommended for Food Group IV.
	;;^DD(117.2,22,"DT")
	;;=2910506
	;;^DD(117.2,23,0)
	;;=% COST GRP 5^NJ2,0^^0;24^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,23,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended of Food Group V
	;;^DD(117.2,23,21,0)
	;;=^^1^1^2950217^^^
	;;^DD(117.2,23,21,1,0)
	;;=The % Cost Recommended for Food Group V.
	;;^DD(117.2,23,"DT")
	;;=2910506
	;;^DD(117.2,24,0)
	;;=% COST GRP 6^NJ2,0^^0;25^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.2,24,3)
	;;=Enter a Number between 1 and 99 for % Cost Recommended of Food Group VI
