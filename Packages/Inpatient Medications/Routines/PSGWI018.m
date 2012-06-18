PSGWI018 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.2,0,"GL")
 ;;=^PSI(58.2,
 ;;^DIC("B","AOU INVENTORY GROUP",58.2)
 ;;=
 ;;^DIC(58.2,"%",0)
 ;;=^1.005^2^2
 ;;^DIC(58.2,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.2,"%",2,0)
 ;;=PSD
 ;;^DIC(58.2,"%","B","PSD",2)
 ;;=
 ;;^DIC(58.2,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.2,"%D",0)
 ;;=^^10^10^2920213^^^^
 ;;^DIC(58.2,"%D",1,0)
 ;;=Entries in this file define standard inventories by defining the areas
 ;;^DIC(58.2,"%D",2,0)
 ;;=of use and type of inventory items inventoried.  This saves the user
 ;;^DIC(58.2,"%D",3,0)
 ;;=from having to re-define the inventory boundaries every time a particular
 ;;^DIC(58.2,"%D",4,0)
 ;;=inventory is scheduled.  Instead, the user can name inventory groups and
 ;;^DIC(58.2,"%D",5,0)
 ;;=the computer then knows what will be inventoried by accessing this file.
 ;;^DIC(58.2,"%D",6,0)
 ;;= 
 ;;^DIC(58.2,"%D",7,0)
 ;;=This file is designed to be used by both the Automatic Replenishment/
 ;;^DIC(58.2,"%D",8,0)
 ;;=Ward Stock module and the Controlled Substance module.  Areas of use
 ;;^DIC(58.2,"%D",9,0)
 ;;=intended for AR/WS are defined in field #1 - AREA OF USE (AOU).  Areas of
 ;;^DIC(58.2,"%D",10,0)
 ;;=use intended for CS are defined in field #3 - NARCOTIC AREA OF USE (NAOU).
 ;;^DD(58.2,0)
 ;;=FIELD^^3^4
 ;;^DD(58.2,0,"DT")
 ;;=2920309
 ;;^DD(58.2,0,"IX","B",58.2,.01)
 ;;=
 ;;^DD(58.2,0,"IX","CS",58.29,.01)
 ;;=
 ;;^DD(58.2,0,"IX","WS",58.21,.01)
 ;;=
 ;;^DD(58.2,0,"NM","AOU INVENTORY GROUP")
 ;;=
 ;;^DD(58.2,.01,0)
 ;;=NAME^RFX^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP)!(X[",") X
 ;;^DD(58.2,.01,1,0)
 ;;=^.1
 ;;^DD(58.2,.01,1,1,0)
 ;;=58.2^B
 ;;^DD(58.2,.01,1,1,1)
 ;;=S ^PSI(58.2,"B",$E(X,1,30),DA)=""
 ;;^DD(58.2,.01,1,1,2)
 ;;=K ^PSI(58.2,"B",$E(X,1,30),DA)
 ;;^DD(58.2,.01,3)
 ;;=Name must be 3-30 characters, not numeric or starting with punctuation
 ;;^DD(58.2,.01,21,0)
 ;;=^^7^7^2890906^^^
 ;;^DD(58.2,.01,21,1,0)
 ;;=This group name represents the Areas of Use which are inventoried
 ;;^DD(58.2,.01,21,2,0)
 ;;=together as a "batch" or "cluster".  This grouping establishes
 ;;^DD(58.2,.01,21,3,0)
 ;;=the elements of the inventory so that they do not have to be
 ;;^DD(58.2,.01,21,4,0)
 ;;=redefined every time the inventory is scheduled.
 ;;^DD(58.2,.01,21,5,0)
 ;;=Inventory groups may be established by (1) location, (2) time,
 ;;^DD(58.2,.01,21,6,0)
 ;;=(3) category or "type" of item to be inventoried, or any combination
 ;;^DD(58.2,.01,21,7,0)
 ;;=of these three.
 ;;^DD(58.2,.01,"DT")
 ;;=2850410
 ;;^DD(58.2,1,0)
 ;;=AREA OF USE (AOU)^58.21P^^1;0
 ;;^DD(58.2,1,21,0)
 ;;=^^3^3^2931014^^^^
 ;;^DD(58.2,1,21,1,0)
 ;;=Enter name of AOU that is to be inventoried when specifying this inventory
 ;;^DD(58.2,1,21,2,0)
 ;;=group at the time of creating an inventory date.  This is a way to 'group'
 ;;^DD(58.2,1,21,3,0)
 ;;=commonly inventoried AOUs under an easy to remember inventory group name.
 ;;^DD(58.2,2,0)
 ;;=GROUP DESCRIPTION^58.23^^2;0
 ;;^DD(58.2,2,21,0)
 ;;=^^3^3^2910304^^^
 ;;^DD(58.2,2,21,1,0)
 ;;=This text describes the inventory group and its use, and perhaps
 ;;^DD(58.2,2,21,2,0)
 ;;=the times when normally processed.  This is purely for documentation
 ;;^DD(58.2,2,21,3,0)
 ;;=of your site specific information.
 ;;^DD(58.2,3,0)
 ;;=NARCOTIC AREA OF USE (NAOU)^58.29P^^3;0
 ;;^DD(58.2,3,21,0)
 ;;=^^4^4^2920309^^
 ;;^DD(58.2,3,21,1,0)
 ;;=Enter name of NAOU that is to be inventoried when specifying this
 ;;^DD(58.2,3,21,2,0)
 ;;=inventory group at the time of creating an inventory date.  This is
 ;;^DD(58.2,3,21,3,0)
 ;;=a way to 'group' commonly inventoried NAOUs under an easy to remember
 ;;^DD(58.2,3,21,4,0)
 ;;=inventory group name.
 ;;^DD(58.21,0)
 ;;=AREA OF USE (AOU) SUB-FIELD^NL^2^3
 ;;^DD(58.21,0,"DT")
 ;;=2920213
 ;;^DD(58.21,0,"IX","B",58.21,.01)
 ;;=
 ;;^DD(58.21,0,"IX","D",58.21,2)
 ;;=
 ;;^DD(58.21,0,"NM","AREA OF USE (AOU)")
 ;;=
 ;;^DD(58.21,0,"UP")
 ;;=58.2
 ;;^DD(58.21,.01,0)
 ;;=AREA OF USE (AOU)^MRP58.1'X^PSI(58.1,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.21,.01,1,0)
 ;;=^.1
 ;;^DD(58.21,.01,1,1,0)
 ;;=58.21^B
 ;;^DD(58.21,.01,1,1,1)
 ;;=S ^PSI(58.2,DA(1),1,"B",$E(X,1,30),DA)=""
