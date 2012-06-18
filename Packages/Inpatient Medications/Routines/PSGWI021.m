PSGWI021 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.3,0,"GL")
 ;;=^PSI(58.3,
 ;;^DIC("B","PHARMACY BACKORDER",58.3)
 ;;=
 ;;^DIC(58.3,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(58.3,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.3,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.3,"%D",0)
 ;;=^^3^3^2900920^^^^
 ;;^DIC(58.3,"%D",1,0)
 ;;=This file contains information that pertains to backorders, such as the
 ;;^DIC(58.3,"%D",2,0)
 ;;=date/time of backorder, the AOU for which the item was backordered, 
 ;;^DIC(58.3,"%D",3,0)
 ;;=and the quantity backordered.
 ;;^DD(58.3,0)
 ;;=FIELD^^1^2
 ;;^DD(58.3,0,"IX","B",58.3,.01)
 ;;=
 ;;^DD(58.3,0,"IX","C",58.31,.01)
 ;;=
 ;;^DD(58.3,0,"IX","D",58.32,.01)
 ;;=
 ;;^DD(58.3,0,"NM","PHARMACY BACKORDER")
 ;;=
 ;;^DD(58.3,.01,0)
 ;;=ITEM^RP50'^PSDRUG(^0;1^Q
 ;;^DD(58.3,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(58.3,.01,1,1,0)
 ;;=58.3^B
 ;;^DD(58.3,.01,1,1,1)
 ;;=S ^PSI(58.3,"B",$E(X,1,30),DA)=""
 ;;^DD(58.3,.01,1,1,2)
 ;;=K ^PSI(58.3,"B",$E(X,1,30),DA)
 ;;^DD(58.3,.01,3)
 ;;=
 ;;^DD(58.3,.01,21,0)
 ;;=^^1^1^2890906^^^^
 ;;^DD(58.3,.01,21,1,0)
 ;;=This contains the name of the item being backordered.
 ;;^DD(58.3,.01,"DT")
 ;;=2850305
 ;;^DD(58.3,1,0)
 ;;=AOU^58.31PA^^1;0
 ;;^DD(58.3,1,21,0)
 ;;=^^1^1^2841220^^
 ;;^DD(58.3,1,21,1,0)
 ;;= Enter the name of the Area Of Use for which the item has been backordered
 ;;^DD(58.31,0)
 ;;=AOU SUB-FIELD^NL^1^2
 ;;^DD(58.31,0,"NM","AOU")
 ;;=
 ;;^DD(58.31,0,"UP")
 ;;=58.3
 ;;^DD(58.31,.01,0)
 ;;=AOU^MP58.1'X^PSI(58.1,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.31,.01,1,0)
 ;;=^.1
 ;;^DD(58.31,.01,1,1,0)
 ;;=58.3^C
 ;;^DD(58.31,.01,1,1,1)
 ;;=S ^PSI(58.3,"C",$E(X,1,30),DA(1),DA)=""
 ;;^DD(58.31,.01,1,1,2)
 ;;=K ^PSI(58.3,"C",$E(X,1,30),DA(1),DA)
 ;;^DD(58.31,.01,3)
 ;;=Enter Area of Use for item being backordered.
 ;;^DD(58.31,.01,21,0)
 ;;=^^2^2^2890906^^^^
 ;;^DD(58.31,.01,21,1,0)
 ;;=This contains the name of the Area of Use for which the item is being
 ;;^DD(58.31,.01,21,2,0)
 ;;=backordered.
 ;;^DD(58.31,.01,"DT")
 ;;=2900213
 ;;^DD(58.31,1,0)
 ;;=DATE/TIME FOR BACKORDER^58.32D^^1;0
 ;;^DD(58.31,1,21,0)
 ;;=^^1^1^2841220^^
 ;;^DD(58.31,1,21,1,0)
 ;;= Enter the inventory date/time for the item being backordered.
 ;;^DD(58.32,0)
 ;;=DATE/TIME FOR BACKORDER SUB-FIELD^NL^4^5
 ;;^DD(58.32,0,"NM","DATE/TIME FOR BACKORDER")
 ;;=
 ;;^DD(58.32,0,"UP")
 ;;=58.31
 ;;^DD(58.32,.01,0)
 ;;=DATE/TIME FOR BACKORDER^D^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.32,.01,1,0)
 ;;=^.1
 ;;^DD(58.32,.01,1,1,0)
 ;;=58.3^D
 ;;^DD(58.32,.01,1,1,1)
 ;;=S ^PSI(58.3,"D",$E(X,1,30),DA(2),DA(1),DA)=""
 ;;^DD(58.32,.01,1,1,2)
 ;;=K ^PSI(58.3,"D",$E(X,1,30),DA(2),DA(1),DA)
 ;;^DD(58.32,.01,3)
 ;;=Enter DATE/TIME for this backorder.
 ;;^DD(58.32,.01,21,0)
 ;;=^^1^1^2881129^^^^
 ;;^DD(58.32,.01,21,1,0)
 ;;=This contains the backorder date/time for the item being backordered.
 ;;^DD(58.32,.01,"DT")
 ;;=2881129
 ;;^DD(58.32,1,0)
 ;;=CURRENT BACKORDER^NJ6,0^^0;2^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.32,1,1,0)
 ;;=^.1
 ;;^DD(58.32,1,1,1,0)
 ;;=^^TRIGGER^58.32^2
 ;;^DD(58.32,1,1,1,1)
 ;;=X ^DD(58.32,1,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^PSI(58.3,D0,1,D1,1,D2,0)):^(0),1:"") S X=$P(Y(1),U,3) S DIU=X K Y S X=DIV S X=DIV X ^DD(58.32,1,1,1,1.4)
 ;;^DD(58.32,1,1,1,1.3)
 ;;=K DIV S DIV=X,D0=DA(2),DIV(0)=D0,D1=DA(1),DIV(1)=D1,D2=DA,DIV(2)=D2 S Y(0)=X S Y(1)=$S($D(^PSI(58.3,D0,1,D1,1,D2,0)):^(0),1:"") S X=$P(Y(1),U,3)=""
 ;;^DD(58.32,1,1,1,1.4)
 ;;=S DIH=$S($D(^PSI(58.3,DIV(0),1,DIV(1),1,DIV(2),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,2,99))  S DIH=DIH_U" S %=$P(DIH,U,4,999),DIU=$P(DIH,U,3),^(0)=$P(DIH,U,1,2)_U_DIV_$S(%]"":U_%,1:""),DIH=58.32,DIG=2 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.32,1,1,1,2)
 ;;=Q
 ;;^DD(58.32,1,1,1,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.32,1,1,1,"%D",1,0)
 ;;=This cross-reference sets the field ORIGINAL BACKORDER (58.32,2). This
 ;;^DD(58.32,1,1,1,"%D",2,0)
 ;;=trigger is only executed when a backorder is first entered.
 ;;^DD(58.32,1,1,1,"CREATE CONDITION")
 ;;=ORIGINAL BACKORDER=""
 ;;^DD(58.32,1,1,1,"CREATE VALUE")
 ;;=CURRENT BACKORDER
 ;;^DD(58.32,1,1,1,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.32,1,1,1,"FIELD")
 ;;=ORIGINAL
 ;;^DD(58.32,1,3)
 ;;=Type a whole number between 0 and 999999
