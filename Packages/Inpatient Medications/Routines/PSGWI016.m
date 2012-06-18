PSGWI016 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.19)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.19,0,"GL")
 ;;=^PSI(58.19,
 ;;^DIC("B","PHARMACY AOU INVENTORY",58.19)
 ;;=
 ;;^DIC(58.19,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(58.19,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.19,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.19,"%D",0)
 ;;=^^8^8^2930816^^^^
 ;;^DIC(58.19,"%D",1,0)
 ;;=This file contains information that pertains to each individual inventory 
 ;;^DIC(58.19,"%D",2,0)
 ;;=such as date/time of inventory, responsible employee, ID number, and
 ;;^DIC(58.19,"%D",3,0)
 ;;=inventory group.
 ;;^DIC(58.19,"%D",4,0)
 ;;= 
 ;;^DIC(58.19,"%D",5,0)
 ;;=*** NOTE *** There is a cross-reference called "AINV" that is not
 ;;^DIC(58.19,"%D",6,0)
 ;;=VA FileMan compatible and has SACC exemption which allows its use.
 ;;^DIC(58.19,"%D",7,0)
 ;;=If you create any local cross-references for this file DO NOT use the
 ;;^DIC(58.19,"%D",8,0)
 ;;=name "AINV" as this will overwrite the existing cross-reference.
 ;;^DD(58.19,0)
 ;;=FIELD^^3^6
 ;;^DD(58.19,0,"DDA")
 ;;=N
 ;;^DD(58.19,0,"DT")
 ;;=2930714
 ;;^DD(58.19,0,"ID",1)
 ;;=W:$D(^("0")) "   ",$S($D(^VA(200,+$P(^("0"),U,3),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
 ;;^DD(58.19,0,"ID",2)
 ;;=W:$D(^("0")) "   ",$P(^("0"),U,2)
 ;;^DD(58.19,0,"ID","WRITE")
 ;;=S GRP=$P(^PSI(58.19,Y,0),U,4) W !,?6 F LP=2:1:($L(GRP,",")-1) S PC=$P(GRP,",",LP) W $S($D(^PSI(58.2,PC,0)):$P(^(0),U),1:"") W:LP<($L(GRP,",")-1) ", "
 ;;^DD(58.19,0,"IX","B",58.19,.01)
 ;;=
 ;;^DD(58.19,0,"NM","PHARMACY AOU INVENTORY")
 ;;=
 ;;^DD(58.19,0,"PT",58.12,.01)
 ;;=
 ;;^DD(58.19,.001,0)
 ;;=ID^NJ6,0^^ ^K:+X'=X!(X>999999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(58.19,.001,3)
 ;;=Number that uniquely identifies this inventory.
 ;;^DD(58.19,.001,21,0)
 ;;=^^1^1^2871009^
 ;;^DD(58.19,.001,21,1,0)
 ;;=This contains a number that uniquely identifies this inventory.
 ;;^DD(58.19,.01,0)
 ;;=DATE/TIME FOR INVENTORY^RD^^0;1^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.19,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(58.19,.01,1,2,0)
 ;;=^^TRIGGER^58.19^2
 ;;^DD(58.19,.01,1,2,1)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(2)=$C(59)_$S($D(^DD(58.19,2,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^PSI(58.19,D0,0)):^(0),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,2)_":",2),$C(59),1) S DIU=X K Y X ^DD(58.19,.01,1,2,1.1) X ^DD(58.19,.01,1,2,1.4)
 ;;^DD(58.19,.01,1,2,1.1)
 ;;=S X=DIV S X=DIV D DW^%DTC S X=X,Y(1)=X S X=1,Y(2)=X S X=3,X=$E(Y(1),Y(2),X)
 ;;^DD(58.19,.01,1,2,1.4)
 ;;=S DIH=$S($D(^PSI(58.19,DIV(0),0)):^(0),1:""),DIV=X S %=$P(DIH,U,3,999),^(0)=$P(DIH,U,1,1)_U_DIV_$S(%]"":U_%,1:""),DIH=58.19,DIG=2 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.19,.01,1,2,2)
 ;;=Q
 ;;^DD(58.19,.01,1,2,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.19,.01,1,2,"%D",1,0)
 ;;=This cross-reference sets the DAY OF THE WEEK (58.19,2) from the date
 ;;^DD(58.19,.01,1,2,"%D",2,0)
 ;;=selected.
 ;;^DD(58.19,.01,1,2,"CREATE VALUE")
 ;;=$E(DAYOFWEEK(#.01),1,3)
 ;;^DD(58.19,.01,1,2,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.19,.01,1,2,"FIELD")
 ;;=DAY
 ;;^DD(58.19,.01,1,3,0)
 ;;=^^TRIGGER^58.19^1
 ;;^DD(58.19,.01,1,3,1)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^PSI(58.19,D0,0)):^(0),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,3),0)):"",1:$P(^(0),U,1)) S DIU=X K Y X ^DD(58.19,.01,1,3,1.1) X ^DD(58.19,.01,1,3,1.4)
 ;;^DD(58.19,.01,1,3,1.1)
 ;;=S X=DIV S X=$S($D(DUZ):DUZ,1:0) S X=X
 ;;^DD(58.19,.01,1,3,1.4)
 ;;=S DIH=$S($D(^PSI(58.19,DIV(0),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,2,99))  S DIH=DIH_U" S %=$P(DIH,U,4,999),^(0)=$P(DIH,U,1,2)_U_DIV_$S(%]"":U_%,1:""),DIH=58.19,DIG=1 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.19,.01,1,3,2)
 ;;=Q
 ;;^DD(58.19,.01,1,3,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.19,.01,1,3,"%D",1,0)
 ;;=This cross-reference sets the field PERSON DOING INVENTORY (58.19,1)
 ;;^DD(58.19,.01,1,3,"%D",2,0)
 ;;=using the variable DUZ.
 ;;^DD(58.19,.01,1,3,"CREATE VALUE")
 ;;=USER#
 ;;^DD(58.19,.01,1,3,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.19,.01,1,3,"FIELD")
 ;;=PERSON
 ;;^DD(58.19,.01,1,4,0)
 ;;=58.19^B
 ;;^DD(58.19,.01,1,4,1)
 ;;=S ^PSI(58.19,"B",$E(X,1,30),DA)=""
 ;;^DD(58.19,.01,1,4,2)
 ;;=K ^PSI(58.19,"B",$E(X,1,30),DA)
 ;;^DD(58.19,.01,3)
 ;;=Enter date/time when inventory of ward(s) was taken.
