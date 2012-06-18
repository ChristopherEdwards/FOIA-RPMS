FHINI0H7	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(113)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(113,27,"DT")
	;;=2930331
	;;^DD(113,28,0)
	;;=WEIGHT OF RECIPE UNIT IN LBS.^NJ7,3^^0;22^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(113,28,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(113,28,21,0)
	;;=^^3^3^2911204^
	;;^DD(113,28,21,1,0)
	;;=This value represents the weight of the recipe unit in pounds and
	;;^DD(113,28,21,2,0)
	;;=is required in performing nutrient analyses of recipes containing
	;;^DD(113,28,21,3,0)
	;;=this ingredient.
	;;^DD(113,28,"DT")
	;;=2910821
	;;^DD(113,29,0)
	;;=DATE COST LAST UPDATED^D^^0;23^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(113,29,21,0)
	;;=^^1^1^2920813^^
	;;^DD(113,29,21,1,0)
	;;=This field contains the date the cost was last updated.
	;;^DD(113,29,"DT")
	;;=2920813
	;;^DD(113,30,0)
	;;=DATE QOH LAST UPDATED^D^^0;24^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(113,30,21,0)
	;;=^^1^1^2920813^^
	;;^DD(113,30,21,1,0)
	;;=This field contains the date the quantity on hand was last updated.
	;;^DD(113,30,"DT")
	;;=2920813
	;;^DD(113,31,0)
	;;=MASTER ITEM #^P441^PRC(441,^0;25^Q
	;;^DD(113,31,3)
	;;=
	;;^DD(113,31,21,0)
	;;=^^1^1^2930211^^^^
	;;^DD(113,31,21,1,0)
	;;=This field contains the Master Item number for the ingredient.
	;;^DD(113,31,"DT")
	;;=2930211
