FHORD91 ; HISC/REL/NCA - Diet Census Cont. ;1/23/98  16:08
 ;;5.0;Dietetics;**13**;Oct 11, 1995
 K S S L1=50
 F K=0:0 S K=$O(D(K)) Q:K=""  S P(0,K)="",X=^FH(119.72,K,0),N1=$P(X,"^",1),N2=$P(X,"^",2),N3=$P(X,"^",4) S:N3="" N3=$E(N1,1,6) S S(N3,K)=$J(N3,8)_"^"_N2,L1=L1+8
 S:L1<80 L1=80
LST S DTP=NOW D DTP^FH W:$E(IOST,1,2)="C-" @IOF W !,DTP,?(L1-35\2),"A C T U A L   D I E T   C E N S U S"
 S Z=$P(^FH(119.71,FHP,0),"^",1),DTP=TIM D DTP^FH
 S X=TIM D DOW^%DTC S DOW=Y+1,X=$P("Sun^Mon^Tues^Wednes^Thurs^Fri^Satur","^",DOW)_"day  "_DTP
 S DTP=TIM D DTP^FH W !!?(L1-$L(Z)\2),Z,!!?(L1-$L(X)\2),X
 W !!?(L1-31\2),"P R O D U C T I O N   D I E T S",!!?29
 S X="" F  S X=$O(S(X)) Q:X=""  F K=0:0 S K=$O(S(X,K)) Q:K=""  W $P(S(X,K),"^",1)
 W "    Tray  Cafe  Total",!
 F P1=0:0 S P1=$O(^FH(116.2,"AP",P1)) Q:P1<1  F K=0:0 S K=$O(^FH(116.2,"AP",P1,K)) Q:K<1  I $D(P(K)) D PRO
 W !?3,"N P O",?31 S K=.5 D P1 K P(.5)
 W !?3,"P A S S",?31 S K=.8 D P1 K P(.8)
 W !?3,"TF Only",?31 S K=.7 D P1 K P(.7)
 F X=0:0 S X=$O(P(.6,X)) Q:X<1  I $D(P(0,X)) S P(.6,X)=P(.6,X)-P(0,X)
 W !?3,"No Order",?31 S K=.6 D P1 K P(.6)
 W !!,"TOTAL MEALS",?31 S K=0 D P1 W ! K P(0) Q
PRO W !,$P($G(^FH(116.2,K,0)),"^",1),?31
P1 S (N("T"),N("C"),N("D"))=""
 S X="" F  S X=$O(S(X)) Q:X=""  F K1=0:0 S K1=$O(S(X,K1)) Q:K1=""  S Z=$G(P(K,K1)),TYP=$P(S(X,K1),"^",2) S:Z N(TYP)=N(TYP)+Z W $S(Z:$J(Z,6),1:$J("",6)),"  " I K>.4,Z S P(0,K1)=P(0,K1)+Z
 S:N("D") N("T")=N("T")+N("D") W $J(N("T"),6),$J(N("C"),6),$J(N("T")+N("C"),7) Q
