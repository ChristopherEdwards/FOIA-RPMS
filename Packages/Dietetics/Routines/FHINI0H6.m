FHINI0H6	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(113)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(113,7,21,3,0)
	;;=contains 6 #10-cans and the Dietetic Issue unit is
	;;^DD(113,7,21,4,0)
	;;=a #10-can then the value is 6.
	;;^DD(113,8,0)
	;;=PRICE/UNIT OF PURCHASE^NJ8,3^^0;9^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(113,8,1,0)
	;;=^.1^^0
	;;^DD(113,8,3)
	;;=Type a Number between 0 and 9999, 3 Decimal Digits
	;;^DD(113,8,21,0)
	;;=^^2^2^2920717^^^^
	;;^DD(113,8,21,1,0)
	;;=This field contains the most recent price of the unit
	;;^DD(113,8,21,2,0)
	;;=of purchase from the vendor.
	;;^DD(113,8,"AUDIT")
	;;=n
	;;^DD(113,8,"DT")
	;;=2920717
	;;^DD(113,9,0)
	;;=REORDER LEVEL (IN U/P)^NJ5,0^^0;10^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(113,9,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 99999
	;;^DD(113,9,21,0)
	;;=^^3^3^2880710^
	;;^DD(113,9,21,1,0)
	;;=This field indicates that when the on-hand quantity drops
	;;^DD(113,9,21,2,0)
	;;=below this value (the re-order level), then additional
	;;^DD(113,9,21,3,0)
	;;=quantities should be ordered.
	;;^DD(113,9,"DT")
	;;=2930413
	;;^DD(113,10,0)
	;;=ON HAND (IN U/P)^NJ8,2^^0;11^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(113,10,3)
	;;=Type a Number between 0 and 99999, 2 Decimal Digits
	;;^DD(113,10,21,0)
	;;=^^1^1^2920720^^^^
	;;^DD(113,10,21,1,0)
	;;=This field contains the number of issue units that are on hand.
	;;^DD(113,10,"DT")
	;;=2930413
	;;^DD(113,11,0)
	;;=STORAGE LOCATION^P113.1'^FH(113.1,^0;12^Q
	;;^DD(113,11,21,0)
	;;=^^3^3^2880710^
	;;^DD(113,11,21,1,0)
	;;=This field indicates the storage location (File 113.1) where
	;;^DD(113,11,21,2,0)
	;;=dietetics normally stores the item and where the stockroom
	;;^DD(113,11,21,3,0)
	;;=requisition clerk will normally obtain it.
	;;^DD(113,20,0)
	;;=FOOD GROUP^RNJ1,0^^0;13^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(113,20,3)
	;;=Type a Number between 1 and 6, 0 Decimal Digits
	;;^DD(113,20,21,0)
	;;=^^2^2^2941214^^^
	;;^DD(113,20,21,1,0)
	;;=This field contains the food group designated by the VA
	;;^DD(113,20,21,2,0)
	;;=for this ingredient item.
	;;^DD(113,20,"DT")
	;;=2890712
	;;^DD(113,23,0)
	;;=RECIPE UNIT^RSX^LB:LB;GAL:GAL;EACH:EACH;^0;16^W *7,*7,!!,"BEWARE! a change in the RECIPE UNIT has considerable impact on the RECIPE data!" Q
	;;^DD(113,23,12)
	;;=Only Units valid as Recipe Units may be chosen
	;;^DD(113,23,12.1)
	;;=S DIC("S")="I Y<7"
	;;^DD(113,23,21,0)
	;;=^^9^9^2880710^
	;;^DD(113,23,21,1,0)
	;;=This field contains LB, GAL, or EACH and is used to indicate
	;;^DD(113,23,21,2,0)
	;;=whether weight (LB), volumetric (GAL) or each (EACH) units
	;;^DD(113,23,21,3,0)
	;;=are to be used in recipes to indicate the quantity required
	;;^DD(113,23,21,4,0)
	;;=of this item. Amounts are stored in that file in these units.
	;;^DD(113,23,21,5,0)
	;;= 
	;;^DD(113,23,21,6,0)
	;;=It is extremely important that this field NOT be changed unless
	;;^DD(113,23,21,7,0)
	;;=it is certain that no recipes use this ingredient. Changing
	;;^DD(113,23,21,8,0)
	;;=the field will invalidate the quantities shown in any recipe
	;;^DD(113,23,21,9,0)
	;;=using the item.
	;;^DD(113,23,"DT")
	;;=2871115
	;;^DD(113,24,0)
	;;=# OF REC UNITS/ISSUE UNIT^RNJ9,4^^0;17^K:+X'=X!(X>9999)!(X<.0001)!(X?.E1"."5N.N) X
	;;^DD(113,24,3)
	;;=TYPE A NUMBER BETWEEN .0001 AND 9999
	;;^DD(113,24,21,0)
	;;=^^2^2^2880710^
	;;^DD(113,24,21,1,0)
	;;=This field indicates the number of recipe units contained in
	;;^DD(113,24,21,2,0)
	;;=a Dietetic Issue unit.
	;;^DD(113,25,0)
	;;=INVENTORY?^S^Y:YES;N:NO;^0;19^Q
	;;^DD(113,25,21,0)
	;;=^^4^4^2920428^^
	;;^DD(113,25,21,1,0)
	;;=This field, when answered YES, will indicate that inventorying
	;;^DD(113,25,21,2,0)
	;;=of this item is desired. It is often NO for such items as
	;;^DD(113,25,21,3,0)
	;;=condiment packs in cases of 2000 which are replenished as
	;;^DD(113,25,21,4,0)
	;;=needed.
	;;^DD(113,25,"DT")
	;;=2871018
	;;^DD(113,26,0)
	;;=THAW DAYS^NJ1,0^^0;20^K:+X'=X!(X>3)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(113,26,3)
	;;=Type a Number between 0 and 3, 0 Decimal Digits
	;;^DD(113,26,21,0)
	;;=^^2^2^2880710^
	;;^DD(113,26,21,1,0)
	;;=If this is a frozen item requiring thawing before use, then
	;;^DD(113,26,21,2,0)
	;;=the number of thaw days should be indicated.
	;;^DD(113,26,"DT")
	;;=2871018
	;;^DD(113,27,0)
	;;=NUTRIENT DATA REFERENCE^P112'^FHNU(^0;21^Q
	;;^DD(113,27,21,0)
	;;=^^4^4^2930331^^
	;;^DD(113,27,21,1,0)
	;;=This is a pointer to the nutrient in File 112 which most closely
	;;^DD(113,27,21,2,0)
	;;=approximates the cooked ingredient. It will be used as a default
	;;^DD(113,27,21,3,0)
	;;=nutrient when performing a nutrient analysis of a recipe containing
	;;^DD(113,27,21,4,0)
	;;=this ingredient.
