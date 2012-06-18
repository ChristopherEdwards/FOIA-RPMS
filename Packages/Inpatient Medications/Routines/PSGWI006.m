PSGWI006 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.11,1,1,0)
 ;;=^.1
 ;;^DD(58.11,1,1,1,0)
 ;;=^^TRIGGER^58.11^11
 ;;^DD(58.11,1,1,1,1)
 ;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,0)):^(0),1:"") S X=$P(Y(1),U,5) S DIU=X K Y S X=DIV S X="Y" X ^DD(58.11,1,1,1,1.4)
 ;;^DD(58.11,1,1,1,1.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,4,99))  S DIH=DIH_U" S %=$P(DIH,U,6,999),DIU=$P(DIH,U,5),^(0)=$P(DIH,U,1,4)_U_DIV_$S(%]"":U_%,1:""),DIH=58.11,DIG=11 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.11,1,1,1,2)
 ;;=Q
 ;;^DD(58.11,1,1,1,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.11,1,1,1,"%D",1,0)
 ;;=This cross-reference sets a flag in the LEVEL CHG field (58.11,11) if 
 ;;^DD(58.11,1,1,1,"%D",2,0)
 ;;=there has been any change to the stock level for an item.
 ;;^DD(58.11,1,1,1,"CREATE VALUE")
 ;;="Y"
 ;;^DD(58.11,1,1,1,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.11,1,1,1,"FIELD")
 ;;=LEVEL CHG
 ;;^DD(58.11,1,3)
 ;;=Type a whole number between 0 and 9999
 ;;^DD(58.11,1,21,0)
 ;;=^^2^2^2871008^^^^
 ;;^DD(58.11,1,21,1,0)
 ;;=This contains the quantity that is the required stock level for the item
 ;;^DD(58.11,1,21,2,0)
 ;;=in the Area of Use.
 ;;^DD(58.11,1,"DT")
 ;;=2850227
 ;;^DD(58.11,2,0)
 ;;=INVENTORY^58.12P^^1;0
 ;;^DD(58.11,2,21,0)
 ;;=^^2^2^2871008^^^^
 ;;^DD(58.11,2,21,1,0)
 ;;=This allows selection of inventory by entering a unique key of 
 ;;^DD(58.11,2,21,2,0)
 ;;=DATE AND TIME.
 ;;^DD(58.11,3,0)
 ;;=TYPE OF INVENTORY^58.13PA^^2;0
 ;;^DD(58.11,3,12)
 ;;=Enter type for item
 ;;^DD(58.11,3,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"",1)'=""ALL"""
 ;;^DD(58.11,5,0)
 ;;=WARD (FOR ITEM)^58.26PA^^4;0
 ;;^DD(58.11,10,0)
 ;;=LOCATION^F^^0;8^K:$L(X)>12!($L(X)<1) X
 ;;^DD(58.11,10,3)
 ;;=ANSWER MUST BE 1-12 CHARACTERS IN LENGTH
 ;;^DD(58.11,10,21,0)
 ;;=^^5^5^2871008^^^
 ;;^DD(58.11,10,21,1,0)
 ;;=This is the location address of the item in the Area of Use.  
 ;;^DD(58.11,10,21,2,0)
 ;;=It can consist of up to 3 levels, each separated by a comma.  
 ;;^DD(58.11,10,21,3,0)
 ;;=For example, "MR,CA,S3" or "CUR,CB,D1".
 ;;^DD(58.11,10,21,4,0)
 ;;=This information is used to sort items on inventory sheets and other
 ;;^DD(58.11,10,21,5,0)
 ;;=printouts.
 ;;^DD(58.11,10,"DT")
 ;;=2840619
 ;;^DD(58.11,11,0)
 ;;=LEVEL CHG^F^^0;5^K:$L(X)>10!($L(X)<1) X
 ;;^DD(58.11,11,3)
 ;;=Answer must be 1-10 characters in length
 ;;^DD(58.11,11,5,1,0)
 ;;=58.11^1^1
 ;;^DD(58.11,11,21,0)
 ;;=^^1^1^2871008^^
 ;;^DD(58.11,11,21,1,0)
 ;;=This contains the change in stock level for the item.
 ;;^DD(58.11,11,"DT")
 ;;=2841218
 ;;^DD(58.11,12,0)
 ;;=NON-STANDARD ITEM^S^1:YES;0:NO;^0;6^Q
 ;;^DD(58.11,12,21,0)
 ;;=^^4^4^2900209^^^
 ;;^DD(58.11,12,21,1,0)
 ;;=This identifies if an item is a standard stocked item in the Area
 ;;^DD(58.11,12,21,2,0)
 ;;=of Use or not.  Enter 1 if the item is not a standard stocked item,
 ;;^DD(58.11,12,21,3,0)
 ;;=but is being added as an on-demand request.  Enter 0 if the item is
 ;;^DD(58.11,12,21,4,0)
 ;;=a standard stocked item in the AOU.
 ;;^DD(58.11,12,"DT")
 ;;=2850208
 ;;^DD(58.11,13,0)
 ;;=REORDER LEVEL^NJ4,0^^0;11^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.11,13,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits
 ;;^DD(58.11,13,21,0)
 ;;=^^2^2^2881101^
 ;;^DD(58.11,13,21,1,0)
 ;;=This field contains the on-hand level that must be reached before an item
 ;;^DD(58.11,13,21,2,0)
 ;;=will have replacements dispensed.
 ;;^DD(58.11,13,"DT")
 ;;=2881101
 ;;^DD(58.11,14,0)
 ;;=MINIMUM QUANTITY TO DISPENSE^NJ4,0^^0;12^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(58.11,14,3)
 ;;=Type a Number between 1 and 9999, 0 Decimal Digits.
 ;;^DD(58.11,14,21,0)
 ;;=^^1^1^2910117^^^
 ;;^DD(58.11,14,21,1,0)
 ;;=This field contains the minimum quantity that will be dispensed of an item.
 ;;^DD(58.11,14,"DT")
 ;;=2910117
 ;;^DD(58.11,15,0)
 ;;=RETURNS^58.15D^^3;0
 ;;^DD(58.11,16,0)
 ;;=ON-DEMAND REQUEST DATE/TIME^58.28DA^^5;0
 ;;^DD(58.11,30,0)
 ;;=INACTIVATION DATE^D^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.11,30,1,0)
 ;;=^.1
 ;;^DD(58.11,30,1,1,0)
 ;;=58.11^AC^MUMPS
 ;;^DD(58.11,30,1,1,1)
 ;;=S ^PSI(58.1,DA(1),1,DA,"I",X)=""
