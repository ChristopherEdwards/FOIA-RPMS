PSGWI017 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.19)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.19,.01,4)
 ;;=
 ;;^DD(58.19,.01,21,0)
 ;;=^^4^4^2931206^^^^
 ;;^DD(58.19,.01,21,1,0)
 ;;=This contains the date that the AOU inventory takes place for Automatic 
 ;;^DD(58.19,.01,21,2,0)
 ;;=Replenishment.  Primary inventory information is stored here.
 ;;^DD(58.19,.01,21,3,0)
 ;;=Inventory entries in File 58.1 - the Pharmacy AOU Stock File point to 
 ;;^DD(58.19,.01,21,4,0)
 ;;=this value when processing an inventory.
 ;;^DD(58.19,.01,"DEL",.01,0)
 ;;=I 1 W !,"INVENTORIES MAY NOT BE DELETED!"
 ;;^DD(58.19,.01,"DT")
 ;;=2930714
 ;;^DD(58.19,.5,0)
 ;;=AREA OF USE^58.24PA^^1;0
 ;;^DD(58.19,1,0)
 ;;=PERSON DOING INVENTORY^RP200'^VA(200,^0;3^Q
 ;;^DD(58.19,1,3)
 ;;=Enter name of person primarily responsible for this inventory.
 ;;^DD(58.19,1,5,1,0)
 ;;=58.19^.01^3
 ;;^DD(58.19,1,21,0)
 ;;=^^2^2^2900712^^
 ;;^DD(58.19,1,21,1,0)
 ;;=This points to File 200 - the New Person File, identifying the person who
 ;;^DD(58.19,1,21,2,0)
 ;;=creates the inventory.
 ;;^DD(58.19,1,"DT")
 ;;=2900712
 ;;^DD(58.19,2,0)
 ;;=DAY OF WEEK^S^MON:MONDAY;TUE:TUESDAY;WED:WEDNESDAY;THU:THURSDAY;FRI:FRIDAY;SAT:SATURDAY;SUN:SUNDAY;^0;2^Q
 ;;^DD(58.19,2,3)
 ;;=Enter day of the week on which the inventory was done.
 ;;^DD(58.19,2,5,1,0)
 ;;=58.19^.01^2
 ;;^DD(58.19,2,9)
 ;;=^
 ;;^DD(58.19,2,21,0)
 ;;=^^1^1^2930816^^^
 ;;^DD(58.19,2,21,1,0)
 ;;=This contains the day of the week when the inventory was done.
 ;;^DD(58.19,3,0)
 ;;=INVENTORY GROUP^F^^0;4^K:$L(X)>25!($L(X)<1) X
 ;;^DD(58.19,3,1,0)
 ;;=^.1^^0
 ;;^DD(58.19,3,3)
 ;;=Answer must be 1-25 characters in length
 ;;^DD(58.19,3,21,0)
 ;;=^^2^2^2871009^
 ;;^DD(58.19,3,21,1,0)
 ;;=This points to File 58.2 - AOU Inventory Group File.  It contains
 ;;^DD(58.19,3,21,2,0)
 ;;=the inventory group - cluster of AOUs which are inventoried together.
 ;;^DD(58.19,3,"DT")
 ;;=2900228
 ;;^DD(58.24,0)
 ;;=AREA OF USE SUB-FIELD^NL^2^3
 ;;^DD(58.24,0,"IX","B",58.24,.01)
 ;;=
 ;;^DD(58.24,0,"IX","C",58.24,2)
 ;;=
 ;;^DD(58.24,0,"NM","AREA OF USE")
 ;;=
 ;;^DD(58.24,0,"UP")
 ;;=58.19
 ;;^DD(58.24,.01,0)
 ;;=AREA OF USE (AOU)^MRP58.1'X^PSI(58.1,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.24,.01,1,0)
 ;;=^.1
 ;;^DD(58.24,.01,1,1,0)
 ;;=58.24^B
 ;;^DD(58.24,.01,1,1,1)
 ;;=S ^PSI(58.19,DA(1),1,"B",$E(X,1,30),DA)=""
 ;;^DD(58.24,.01,1,1,2)
 ;;=K ^PSI(58.19,DA(1),1,"B",$E(X,1,30),DA)
 ;;^DD(58.24,.01,21,0)
 ;;=^^2^2^2900129^^^^
 ;;^DD(58.24,.01,21,1,0)
 ;;=This contains the name of the Area of Use as defined in File 58.1 -
 ;;^DD(58.24,.01,21,2,0)
 ;;=Pharmacy AOU Stock File.
 ;;^DD(58.24,.01,"DT")
 ;;=2900213
 ;;^DD(58.24,1,0)
 ;;=INVENTORY TYPE^58.25PA^^1;0
 ;;^DD(58.24,2,0)
 ;;=SORT KEY^NJ9,0^^0;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.24,2,1,0)
 ;;=^.1
 ;;^DD(58.24,2,1,1,0)
 ;;=58.24^C
 ;;^DD(58.24,2,1,1,1)
 ;;=S ^PSI(58.19,DA(1),1,"C",$E(X,1,30),DA)=""
 ;;^DD(58.24,2,1,1,2)
 ;;=K ^PSI(58.19,DA(1),1,"C",$E(X,1,30),DA)
 ;;^DD(58.24,2,3)
 ;;=Type a Number between 0 and 999999999, 0 Decimal Digits
 ;;^DD(58.24,2,21,0)
 ;;=^^3^3^2871009^
 ;;^DD(58.24,2,21,1,0)
 ;;=The sort key is used to place the AOUs within an Inventory Group
 ;;^DD(58.24,2,21,2,0)
 ;;=in the order in which they are inventoried.  This sort order is
 ;;^DD(58.24,2,21,3,0)
 ;;=reflected in the inventory sheet.
 ;;^DD(58.24,2,"DT")
 ;;=2891031
 ;;^DD(58.25,0)
 ;;=INVENTORY TYPE SUB-FIELD^NL^.01^1
 ;;^DD(58.25,0,"NM","INVENTORY TYPE")
 ;;=
 ;;^DD(58.25,0,"UP")
 ;;=58.24
 ;;^DD(58.25,.01,0)
 ;;=INVENTORY TYPE^MRP58.16'X^PSI(58.16,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.25,.01,1,0)
 ;;=^.1^^0
 ;;^DD(58.25,.01,21,0)
 ;;=^^2^2^2871009^^
 ;;^DD(58.25,.01,21,1,0)
 ;;=This defines the Inventory Type which will be used to select the appropriate
 ;;^DD(58.25,.01,21,2,0)
 ;;=items from this AOU for inventory.
 ;;^DD(58.25,.01,"DT")
 ;;=2900213
