PSGWI008 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.11,30,1,5,"FIELD")
 ;;=INACTIVATION REASON (OTHER)
 ;;^DD(58.11,30,3)
 ;;=Enter date when this item is no longer considered a ward stock item.
 ;;^DD(58.11,30,21,0)
 ;;=^^3^3^2890120^^
 ;;^DD(58.11,30,21,1,0)
 ;;=This contains the date on which the drug/item in the Area of Use
 ;;^DD(58.11,30,21,2,0)
 ;;=was inactivated, and thus is no longer considered part of the
 ;;^DD(58.11,30,21,3,0)
 ;;=standard stock for that Area of Use.
 ;;^DD(58.11,30,"DT")
 ;;=2930519
 ;;^DD(58.11,31,0)
 ;;=INACTIVATION REASON^S^N:NOT USED;O:OTHER;DF:DELETED FROM FORMULARY;^0;4^Q
 ;;^DD(58.11,31,3)
 ;;=
 ;;^DD(58.11,31,5,1,0)
 ;;=58.11^30^4
 ;;^DD(58.11,31,21,0)
 ;;=^^2^2^2871008^^^^
 ;;^DD(58.11,31,21,1,0)
 ;;=This contains the reason that the item has been inactivated from the list 
 ;;^DD(58.11,31,21,2,0)
 ;;=of items normally stocked in this Area of Use.
 ;;^DD(58.11,31,"DT")
 ;;=2910415
 ;;^DD(58.11,33,0)
 ;;=INACTIVATION REASON (OTHER)^F^^0;9^K:$L(X)>40!($L(X)<3) X
 ;;^DD(58.11,33,3)
 ;;=Answer must be 3-40 characters in length
 ;;^DD(58.11,33,5,1,0)
 ;;=58.11^30^5
 ;;^DD(58.11,33,21,0)
 ;;=^^3^3^2871008^^
 ;;^DD(58.11,33,21,1,0)
 ;;=This contains the custom reason for inactivating the item from the 
 ;;^DD(58.11,33,21,2,0)
 ;;=AOU stock list. An inactivation reason of 'other' should have been 
 ;;^DD(58.11,33,21,3,0)
 ;;=entered if a custom reason is to be listed.
 ;;^DD(58.11,33,"DT")
 ;;=2840614
 ;;^DD(58.11,34,0)
 ;;=INACTIVE DATE FLAG^F^^0;10^K:$L(X)>3!($L(X)<1) X
 ;;^DD(58.11,34,3)
 ;;=Answer must be 1-3 characters in length
 ;;^DD(58.11,34,5,1,0)
 ;;=58.11^30^2
 ;;^DD(58.11,34,9)
 ;;=^
 ;;^DD(58.11,34,21,0)
 ;;=^^3^3^2871008^
 ;;^DD(58.11,34,21,1,0)
 ;;=This flag will be set to "YES" if there is an inactivation date
 ;;^DD(58.11,34,21,2,0)
 ;;=for the item in the AOU.  If there is no inactivation date for
 ;;^DD(58.11,34,21,3,0)
 ;;=the item, then the flag will be set to "NO".
 ;;^DD(58.11,34,"DT")
 ;;=2841219
 ;;^DD(58.11,35,0)
 ;;=EXPIRATION DATE^D^^EXP;1^S %DT="E" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.11,35,.1)
 ;;=    EXPIRATION DATE
 ;;^DD(58.11,35,1,0)
 ;;=^.1
 ;;^DD(58.11,35,1,1,0)
 ;;=58.1^AEXP^MUMPS
 ;;^DD(58.11,35,1,1,1)
 ;;=S PSGWDRUG=+^PSI(58.1,DA(1),1,DA,0),^PSI(58.1,"AEXP",$E(X,1,30),PSGWDRUG,DA(1))="" K PSGWDRUG
 ;;^DD(58.11,35,1,1,2)
 ;;=S PSGWDRUG=+^PSI(58.1,DA(1),1,DA,0) K ^PSI(58.1,"AEXP",$E(X,1,30),PSGWDRUG,DA(1)),PSGWDRUG
 ;;^DD(58.11,35,1,1,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.11,35,1,1,"%D",1,0)
 ;;=This cross-reference is used to sort the expiration dates for stock items
 ;;^DD(58.11,35,1,1,"%D",2,0)
 ;;=for the option "Expiration Date Report".
 ;;^DD(58.11,35,3)
 ;;=Enter the Expiration Date for this Item.
 ;;^DD(58.11,35,21,0)
 ;;=^^1^1^2900706^^^
 ;;^DD(58.11,35,21,1,0)
 ;;=This field contains the expiration date for this item.
 ;;^DD(58.11,35,"DT")
 ;;=2900627
 ;;^DD(58.12,0)
 ;;=INVENTORY SUB-FIELD^NL^5^6
 ;;^DD(58.12,0,"IX","AMIS",58.12,4)
 ;;=
 ;;^DD(58.12,0,"IX","AMISERR",58.12,4)
 ;;=
 ;;^DD(58.12,0,"IX","C",58.12,.01)
 ;;=
 ;;^DD(58.12,0,"NM","INVENTORY")
 ;;=
 ;;^DD(58.12,0,"UP")
 ;;=58.11
 ;;^DD(58.12,.01,0)
 ;;=DATE/TIME FOR INVENTORY^P58.19'X^PSI(58.19,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.12,.01,.1)
 ;;=
 ;;^DD(58.12,.01,1,0)
 ;;=^.1
 ;;^DD(58.12,.01,1,1,0)
 ;;=58.12^C^MUMPS
 ;;^DD(58.12,.01,1,1,1)
 ;;=S $P(^(1,DA,0),"^",2)=$P(^PSI(58.1,DA(2),1,DA(1),0),"^",2)
 ;;^DD(58.12,.01,1,1,2)
 ;;=S $P(^PSI(58.1,DA(2),1,DA(1),1,DA,0),"^",2)=""
 ;;^DD(58.12,.01,1,1,"%D",0)
 ;;=^^2^2^2930811^
 ;;^DD(58.12,.01,1,1,"%D",1,0)
 ;;=This cross-reference automatically sets the field LEVEL (58.12,1) equal
 ;;^DD(58.12,.01,1,1,"%D",2,0)
 ;;=to whatever is in the field STOCK LEVEL (58.11,1).
 ;;^DD(58.12,.01,3)
 ;;=
 ;;^DD(58.12,.01,21,0)
 ;;=^^1^1^2871008^^
 ;;^DD(58.12,.01,21,1,0)
 ;;=This contains the DATE/TIME of the inventory.
 ;;^DD(58.12,.01,"DT")
 ;;=2900213
 ;;^DD(58.12,1,0)
 ;;=LEVEL^RNJ4,0^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.12,1,3)
 ;;=Type a whole number between 0 and 9999
 ;;^DD(58.12,1,9)
 ;;=^
 ;;^DD(58.12,1,21,0)
 ;;=^^1^1^2871008^^
 ;;^DD(58.12,1,21,1,0)
 ;;=This contains the stock level of the item for the inventory DATE/TIME.
