PSGWI015 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.17)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.17,0,"GL")
 ;;=^PSI(58.17,
 ;;^DIC("B","AOU ITEM LOCATION",58.17)
 ;;=
 ;;^DIC(58.17,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(58.17,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.17,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.17,"%D",0)
 ;;=^^2^2^2900213^^^^
 ;;^DIC(58.17,"%D",1,0)
 ;;=Expansions of the codes used to indicate storage location of item
 ;;^DIC(58.17,"%D",2,0)
 ;;=in the area of use.
 ;;^DD(58.17,0)
 ;;=FIELD^^.5^2
 ;;^DD(58.17,0,"ID",.5)
 ;;=W:$D(^("0")) "   ",$P(^("0"),U,3)
 ;;^DD(58.17,0,"IX","B",58.17,.01)
 ;;=
 ;;^DD(58.17,0,"NM","AOU ITEM LOCATION")
 ;;=
 ;;^DD(58.17,.01,0)
 ;;=ITEM ADDRESS CODE^RF^^0;1^K:$L(X)>3!($L(X)<1)!'(X?1AN.AN) X
 ;;^DD(58.17,.01,1,0)
 ;;=^.1
 ;;^DD(58.17,.01,1,1,0)
 ;;=58.17^B
 ;;^DD(58.17,.01,1,1,1)
 ;;=S ^PSI(58.17,"B",$E(X,1,30),DA)=""
 ;;^DD(58.17,.01,1,1,2)
 ;;=K ^PSI(58.17,"B",$E(X,1,30),DA)
 ;;^DD(58.17,.01,3)
 ;;=Answer must be 1-3 characters in length
 ;;^DD(58.17,.01,21,0)
 ;;=^^3^3^2871008^^^^
 ;;^DD(58.17,.01,21,1,0)
 ;;=This contains a code that represents a portion of an item's location 
 ;;^DD(58.17,.01,21,2,0)
 ;;=address in an Area of Use.  This code is associated with an expansion 
 ;;^DD(58.17,.01,21,3,0)
 ;;=for clarity.
 ;;^DD(58.17,.01,"DT")
 ;;=2840614
 ;;^DD(58.17,.5,0)
 ;;=CODE EXPANSION^F^^0;3^K:$L(X)>30!($L(X)<1) X
 ;;^DD(58.17,.5,3)
 ;;=Enter 1-30 characters
 ;;^DD(58.17,.5,21,0)
 ;;=^^2^2^2871008^^
 ;;^DD(58.17,.5,21,1,0)
 ;;=This text is used to clarify the meaning of the associated code.  Its
 ;;^DD(58.17,.5,21,2,0)
 ;;=primary purpose is for report information.
 ;;^DD(58.17,.5,"DT")
 ;;=2840614
