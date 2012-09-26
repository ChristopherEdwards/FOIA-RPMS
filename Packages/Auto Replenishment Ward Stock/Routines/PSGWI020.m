PSGWI020 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.29,.01,3)
 ;;=Enter the NAOU for this inventory group.
 ;;^DD(58.29,.01,12)
 ;;=Select only Controlled Substance locations.
 ;;^DD(58.29,.01,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"",2)'=""P"""
 ;;^DD(58.29,.01,21,0)
 ;;=^^5^5^2920309^^^^
 ;;^DD(58.29,.01,21,1,0)
 ;;=This contains the name of the NAOU that is to be inventoried when
 ;;^DD(58.29,.01,21,2,0)
 ;;=selecting this inventory group.  This points to file 58.8 - Drug
 ;;^DD(58.29,.01,21,3,0)
 ;;=Accountability Stats file.
 ;;^DD(58.29,.01,21,4,0)
 ;;=Screened pointer to file 58.8.  Screens out entries with type defined
 ;;^DD(58.29,.01,21,5,0)
 ;;=as 'P' for Primary.
 ;;^DD(58.29,.01,23,0)
 ;;=^^1^1^2920309^^^^
 ;;^DD(58.29,.01,23,1,0)
 ;;=Pointer to file 58.8.
 ;;^DD(58.29,.01,23,2,0)
 ;;='P' for Primary.
 ;;^DD(58.29,.01,"DT")
 ;;=2920309
 ;;^DD(58.29,1,0)
 ;;=INVENTORY TYPE^58.291PA^^1;0
 ;;^DD(58.29,1,21,0)
 ;;=^^2^2^2920718^
 ;;^DD(58.29,1,21,1,0)
 ;;=Inventory types are used to group related drugs in a Narcotic Area of
 ;;^DD(58.29,1,21,2,0)
 ;;=Use.
 ;;^DD(58.29,2,0)
 ;;=SORT KEY^NJ15,4^^0;2^K:+X'=X!(X>9999999999)!(X<0)!(X?.E1"."5N.N) X
 ;;^DD(58.29,2,1,0)
 ;;=^.1
 ;;^DD(58.29,2,1,1,0)
 ;;=58.29^D
 ;;^DD(58.29,2,1,1,1)
 ;;=S ^PSI(58.2,DA(1),3,"D",$E(X,1,30),DA)=""
 ;;^DD(58.29,2,1,1,2)
 ;;=K ^PSI(58.2,DA(1),3,"D",$E(X,1,30),DA)
 ;;^DD(58.29,2,1,1,"DT")
 ;;=2920213
 ;;^DD(58.29,2,3)
 ;;=Type a Number between 0 and 9999999999, 4 Decimal Digits
 ;;^DD(58.29,2,21,0)
 ;;=^^2^2^2920213^
 ;;^DD(58.29,2,21,1,0)
 ;;=The sort key is used to define the sort order of NAOUs within an
 ;;^DD(58.29,2,21,2,0)
 ;;=inventory group.
 ;;^DD(58.29,2,"DT")
 ;;=2920213
 ;;^DD(58.291,0)
 ;;=INVENTORY TYPE SUB-FIELD^^.01^1
 ;;^DD(58.291,0,"DT")
 ;;=2920213
 ;;^DD(58.291,0,"NM","INVENTORY TYPE")
 ;;=
 ;;^DD(58.291,0,"UP")
 ;;=58.29
 ;;^DD(58.291,.01,0)
 ;;=INVENTORY TYPE^MRP58.16'X^PSI(58.16,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.291,.01,1,0)
 ;;=^.1^^0
 ;;^DD(58.291,.01,3)
 ;;=Enter the inventory type(s) for this NAOU.
 ;;^DD(58.291,.01,21,0)
 ;;=^^3^3^2920213^
 ;;^DD(58.291,.01,21,1,0)
 ;;=This contains the inventory type that is to be inventoried within the
 ;;^DD(58.291,.01,21,2,0)
 ;;=NAOU.  More than one inventory type can be entered.  The inventory
 ;;^DD(58.291,.01,21,3,0)
 ;;=types must be defined in file 58.16 - AOU Inventory Type file.
 ;;^DD(58.291,.01,23,0)
 ;;=^^1^1^2920213^
 ;;^DD(58.291,.01,23,1,0)
 ;;=Pointer to file 58.16.
 ;;^DD(58.291,.01,"DT")
 ;;=2920213
