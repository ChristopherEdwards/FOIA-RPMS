XBGL ;IHS/ITSC/DMJ - GLOBAL LISTER [ 03/17/2005  10:46 AM ]
 ;;3.0;IHS/VA UTILITIES;**10**;
START ;START HERE
 K XB,DIR W ! S $Y=1
 S DIR(0)="FAO^1:80",DIR("A")="Global: ^" D ^DIR K DIR
 I Y=""!(Y="^") W ! K DIR Q
 I Y[",,"!(Y["(,") W *7,!!,"Use '*' for wildcard.",! G START
 I $E(Y,1)'="^" S Y="^"_Y
 I $L(Y,"(")=2,$P(Y,"(",2)']"" S Y=$P(Y,"(",1)
 S (XB("Y"),XB("IN"))=Y
 S XB("RB")=$P(XB("IN"),"(",1)
I1 ;SET UP INPUT FOR COMPARISON
 I XB("IN")["(" D
 .S (XB("LP"),XB("RP"))=0 F I=1:1:$L(XB("IN")) S:$E(XB("IN"),I)="(" XB("LP")=XB("LP")+1 S:$E(XB("IN"),I)=")" XB("RP")=XB("RP")+1
 .S XB("X")="",XB("Z")=""
 .S XB("IS")=$P(XB("IN"),"(",2,999)
 .I $E(XB("IS"),$L(XB("IS")))=")",XB("LP")=XB("RP") S XB("IS")=$E(XB("IS"),1,$L(XB("IS"))-1)
 .F I=1:1:$L(XB("IS"),",") D
 ..S XB("I"_I)=$P(XB("IS"),",",I) Q:XB("I"_I)=""
 ..S X="ER2",@^%ZOSF("TRAP") I 'XB("I"_I),XB("I"_I)'=0,XB("I"_I)'="*",$E(XB("I"_I),1)'=$C(34) D
 ...I $E(XB("I"_I),$L(XB("I"_I)))=":" S XB("I"_I)=$E(XB("I"_I),1,$L(XB("I"_I))-1),XB("F3")=1
 ...S XB("I"_I)=@XB("I"_I)
 ...I $G(XB("F3")) S XB("I"_I)=XB("I"_I)_":",XB("F3")=0
 ..S $P(XB("X"),",",I)=XB("I"_I),$P(XB("Z"),",",I)=XB("I"_I)
 ..I XB("I"_I)="*" S $P(XB("X"),",",I)="0"
 ..I $E(XB("I"_I),$L(XB("I"_I)))=":" S $P(XB("Z"),",",I)="*",$P(XB("X"),",",I)=$E(XB("I"_I),1,$L(XB("I"_I))-1),XB("I"_I)="*"
 .S XB("IN")=XB("RB")_"("_XB("Z")_$S($E(Y,$L(Y))=")"&(XB("RP")=XB("LP")):")",1:""),XB("I")=$L(XB("Z"),",")
 .S XB("Y")=XB("RB")_"("_XB("X")_")"
FIRST ;INITIAL ENTRY
 S X="ER1",@^%ZOSF("TRAP")
 I XB("IN")[")",XB("IN")'["*" S XB("F1")=1
 I $D(@XB("Y"))#2 D DISP I $G(XB("OUT")) G START
LOOP ;LOOP HERE
 S X="ER2",@^%ZOSF("TRAP")
 F  S XB("Y")=$Q(@(XB("Y"))) D MATCH Q:$G(XB("F1"))  D DISP I $G(XB("OUT")) G START
 G START
ER1 ;FIRST ERROR CONDITION
 G LOOP
ER2 ;SECOND ERROR CONDITION
 W *7,!!,"??",! G START
MATCH ;DECIPHER INPUT
 I XB("Y")="" S XB("F1")=1 Q
 I $P(XB("IN"),"(",2)']"" Q
 S XB("F2")=0
 S XB("SB")=$P(XB("Y"),"(",2),XB("SB")=$E(XB("SB"),1,$L(XB("SB"))-1),XB("S")=$L(XB("SB"),",")
 I $E(XB("IN"),$L(XB("IN")))=")",XB("S")'=XB("I") S XB("F2")=1 Q
 S XB("*")=0 F I=1:1:XB("I") D
 .I XB("I"_I)="*" S XB("*")=XB("*")+1 Q
 .S XB("S"_I)=$P(XB("SB"),",",I)
 .I XB("I"_I)'=XB("S"_I) D
 ..S XB("F2")=1
 ..I 'XB("*") S XB("F1")=1
 ..I XB("IN")'["*" S XB("F1")=1
 Q
DISP ;OUTPUT
 Q:$G(XB("F2"))
 S XB("=")=@(XB("Y"))
 W !,XB("Y")," = ",XB("=")
 I $Y>20 D
 .S DIR(0)="E" D ^DIR K DIR
 .I 'Y S XB("OUT")=1 Q
 .W @IOF
 Q
