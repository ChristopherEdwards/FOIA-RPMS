PSGWI005 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.1,4,21,2,0)
 ;;=credit for the AMIS statistics for this AOU.
 ;;^DD(58.1,4,"DT")
 ;;=2890627
 ;;^DD(58.1,5,0)
 ;;=ASK EXPIRATION DATE?^S^0:NO;1:YES;^0;4^Q
 ;;^DD(58.1,5,3)
 ;;=Enter '1' or 'Y' if you wish to be prompted for Expiration Dates for items in this Area of Use when entering on-demands or quantities dispensed.
 ;;^DD(58.1,5,21,0)
 ;;=^^5^5^2900705^
 ;;^DD(58.1,5,21,1,0)
 ;;=If this field is set to '1' or 'Yes' for the Area of Use, the user will
 ;;^DD(58.1,5,21,2,0)
 ;;=be prompted for Expiration Dates when on-demands or quantities dispensed
 ;;^DD(58.1,5,21,3,0)
 ;;=(for inventories) are entered.  If this field is set to '0' or 'No',
 ;;^DD(58.1,5,21,4,0)
 ;;=Expiration Dates can only be entered through the supervisor option
 ;;^DD(58.1,5,21,5,0)
 ;;='Expiration Date Enter/Edit'.
 ;;^DD(58.1,5,"DT")
 ;;=2900705
 ;;^DD(58.1,6,0)
 ;;=CRASH CART FLAG^S^0:NO;1:YES;^0;5^Q
 ;;^DD(58.1,6,1,0)
 ;;=^.1
 ;;^DD(58.1,6,1,1,0)
 ;;=^^TRIGGER^58.1^7
 ;;^DD(58.1,6,1,1,1)
 ;;=Q
 ;;^DD(58.1,6,1,1,2)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^PSI(58.1,D0,0)):^(0),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X="" S DIH=$S($D(^PSI(58.1,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,6)=DIV,DIH=58.1,DIG=7 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.1,6,1,1,"%D",0)
 ;;=^^2^2^2930830^
 ;;^DD(58.1,6,1,1,"%D",1,0)
 ;;=This cross-reference deletes any data in the CRASH CART LOCATION field
 ;;^DD(58.1,6,1,1,"%D",2,0)
 ;;=(58.1,7) if the CRASH CART FLAG is set to "NO".
 ;;^DD(58.1,6,1,1,"CREATE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.1,6,1,1,"DELETE VALUE")
 ;;=@
 ;;^DD(58.1,6,1,1,"FIELD")
 ;;=CRASH CART LOCATION
 ;;^DD(58.1,6,3)
 ;;=Enter '1' or 'Y' if this Area of Use is a Crash Cart.
 ;;^DD(58.1,6,20,0)
 ;;=^.3LA^1^1
 ;;^DD(58.1,6,20,1,0)
 ;;=PSGW
 ;;^DD(58.1,6,21,0)
 ;;=^^3^3^2910503^^
 ;;^DD(58.1,6,21,1,0)
 ;;=This field will be set to '1' (for 'yes') if this area of use is a
 ;;^DD(58.1,6,21,2,0)
 ;;=crash cart.  This flag will be used as a screen to list only crash
 ;;^DD(58.1,6,21,3,0)
 ;;=carts for the option 'Update Crash Cart Locations'.
 ;;^DD(58.1,6,"DT")
 ;;=2910503
 ;;^DD(58.1,7,0)
 ;;=CRASH CART LOCATION^P44'^SC(^0;6^Q
 ;;^DD(58.1,7,3)
 ;;=Enter the Location of this AOU.  This field should only be used to enter locations for CRASH CARTS.
 ;;^DD(58.1,7,5,1,0)
 ;;=58.1^6^1
 ;;^DD(58.1,7,21,0)
 ;;=^^5^5^2910528^^
 ;;^DD(58.1,7,21,1,0)
 ;;=This field is meant to be used to record the location of an area of use
 ;;^DD(58.1,7,21,2,0)
 ;;=that is a crash cart.  This field will be printed on the Expiration Date
 ;;^DD(58.1,7,21,3,0)
 ;;=report and will be updated in the option 'Update Crash Cart Locations'. 
 ;;^DD(58.1,7,21,4,0)
 ;;=Only areas of use that have the field CRASH CART FLAG set to '1' (for 
 ;;^DD(58.1,7,21,5,0)
 ;;='yes') will be selectable in the update option.
 ;;^DD(58.1,7,"DT")
 ;;=2910503
 ;;^DD(58.11,0)
 ;;=ITEM SUB-FIELD^NL^35^17
 ;;^DD(58.11,0,"DT")
 ;;=2930308
 ;;^DD(58.11,0,"ID",1)
 ;;=W ""
 ;;^DD(58.11,0,"ID",10)
 ;;=W:$D(^("0")) "   ",$P(^("0"),U,8)
 ;;^DD(58.11,0,"IX","AC",58.11,30)
 ;;=
 ;;^DD(58.11,0,"IX","B",58.11,.01)
 ;;=
 ;;^DD(58.11,0,"NM","ITEM")
 ;;=
 ;;^DD(58.11,0,"UP")
 ;;=58.1
 ;;^DD(58.11,.01,0)
 ;;=ITEM^MR*P50'X^PSDRUG(^0;1^S DIC("S")="D DRGSCRN^PSGWUTL" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X I $D(X) D EDCHK^PSGWUTL
 ;;^DD(58.11,.01,1,0)
 ;;=^.1
 ;;^DD(58.11,.01,1,1,0)
 ;;=58.11^B
 ;;^DD(58.11,.01,1,1,1)
 ;;=S ^PSI(58.1,DA(1),1,"B",$E(X,1,30),DA)=""
 ;;^DD(58.11,.01,1,1,2)
 ;;=K ^PSI(58.1,DA(1),1,"B",$E(X,1,30),DA)
 ;;^DD(58.11,.01,3)
 ;;=
 ;;^DD(58.11,.01,4)
 ;;=
 ;;^DD(58.11,.01,12)
 ;;=Do not select INACTIVE or NON-PHARMACY items.                             NOTE: Items containing significant data can not be modified.
 ;;^DD(58.11,.01,12.1)
 ;;=S DIC("S")="D DRGSCRN^PSGWUTL"
 ;;^DD(58.11,.01,21,0)
 ;;=^^1^1^2930513^^^^
 ;;^DD(58.11,.01,21,1,0)
 ;;=ITEM defines the name of the drug stocked in this Area of Use.
 ;;^DD(58.11,.01,"DEL",13000,0)
 ;;=I 1 W !,"ITEMS CANNOT BE DELETED,MUST BE INACTIVATED!"
 ;;^DD(58.11,.01,"DT")
 ;;=2930603
 ;;^DD(58.11,1,0)
 ;;=STOCK LEVEL^RNJ4,0^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
