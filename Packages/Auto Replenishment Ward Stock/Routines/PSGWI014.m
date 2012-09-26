PSGWI014 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.16)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.16,0,"GL")
 ;;=^PSI(58.16,
 ;;^DIC("B","AOU INVENTORY TYPE",58.16)
 ;;=
 ;;^DIC(58.16,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(58.16,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.16,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.16,"%D",0)
 ;;=^^4^4^2900213^^^^
 ;;^DIC(58.16,"%D",1,0)
 ;;=Defines the inventory types which are used to group related items in
 ;;^DIC(58.16,"%D",2,0)
 ;;=or across areas of use.  This file is defined by the user to allow
 ;;^DIC(58.16,"%D",3,0)
 ;;=maximum flexibility in adapting to the system of inventory in each
 ;;^DIC(58.16,"%D",4,0)
 ;;=hospital.
 ;;^DD(58.16,0)
 ;;=FIELD^^1^2
 ;;^DD(58.16,0,"IX","B",58.16,.01)
 ;;=
 ;;^DD(58.16,0,"NM","AOU INVENTORY TYPE")
 ;;=
 ;;^DD(58.16,0,"PT",58.13,.01)
 ;;=
 ;;^DD(58.16,0,"PT",58.22,.01)
 ;;=
 ;;^DD(58.16,0,"PT",58.25,.01)
 ;;=
 ;;^DD(58.16,0,"PT",58.291,.01)
 ;;=
 ;;^DD(58.16,0,"PT",58.800116,.01)
 ;;=
 ;;^DD(58.16,.01,0)
 ;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
 ;;^DD(58.16,.01,1,0)
 ;;=^.1
 ;;^DD(58.16,.01,1,1,0)
 ;;=58.16^B
 ;;^DD(58.16,.01,1,1,1)
 ;;=S ^PSI(58.16,"B",$E(X,1,30),DA)=""
 ;;^DD(58.16,.01,1,1,2)
 ;;=K ^PSI(58.16,"B",$E(X,1,30),DA)
 ;;^DD(58.16,.01,3)
 ;;=Answer must be 3-30 characters in length
 ;;^DD(58.16,.01,21,0)
 ;;=^^3^3^2931014^^^
 ;;^DD(58.16,.01,21,1,0)
 ;;=This contains the name of an inventory type, i.e. injections,
 ;;^DD(58.16,.01,21,2,0)
 ;;=external, internal, oral liquid, or oral solid.  This will be
 ;;^DD(58.16,.01,21,3,0)
 ;;=used to group items in each Area of Use.
 ;;^DD(58.16,.01,"DEL",1,0)
 ;;=I $P(^PSI(58.16,DA,0),"^",1)="ON-DEMAND" W !,"This entry cannot be deleted, it is a requirement of the software."
 ;;^DD(58.16,1,0)
 ;;=TYPE DESCRIPTION^58.18^^1;0
 ;;^DD(58.16,1,21,0)
 ;;=^^3^3^2910304^^^
 ;;^DD(58.16,1,21,1,0)
 ;;=This contains information that describes this inventory type.  
 ;;^DD(58.16,1,21,2,0)
 ;;=This is purely for documentation of the scheme you have adopted at 
 ;;^DD(58.16,1,21,3,0)
 ;;=your site.
 ;;^DD(58.18,0)
 ;;=TYPE DESCRIPTION SUB-FIELD^NL^.01^1
 ;;^DD(58.18,0,"NM","TYPE DESCRIPTION")
 ;;=
 ;;^DD(58.18,0,"UP")
 ;;=58.16
 ;;^DD(58.18,.01,0)
 ;;=TYPE DESCRIPTION^W^^0;1^Q
 ;;^DD(58.18,.01,21,0)
 ;;=^^3^3^2910304^
 ;;^DD(58.18,.01,21,1,0)
 ;;=This contains information that describes this inventory type.
 ;;^DD(58.18,.01,21,2,0)
 ;;=This is purely for documentation of the scheme you have adopted at
 ;;^DD(58.18,.01,21,3,0)
 ;;=your site.
 ;;^DD(58.18,.01,"DT")
 ;;=2840619
