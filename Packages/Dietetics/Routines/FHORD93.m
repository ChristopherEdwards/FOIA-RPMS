FHORD93 ; HISC/NCA - Diet Census Percentage (Cont.) ;1/23/98  16:09
 ;;5.0;Dietetics;**13**;Oct 11, 1995
Q1 ; Calculate Census
 S X=D1 D DOW^%DTC S DOW=Y+1 D NOW^%DTC S NOW=% S PG=0
 G:FHAN'="Y" GET
 I MEAL'="A" G Q2
 F MEAL="B","N","E" D Q2
 Q
Q2 S K3=$F("BNE",MEAL)-1,FHX1=$P(FHDA,"^",K3+1) D CEN^FHPRO2:FHP1["C",FOR^FHPRO2:FHP1["F",LST
 Q
GET F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD<1  S X=^(WRD,0),TIM=D1 D WRD^FHORD9
 K D,NP F LP=0:0 S LP=$O(P(.5,LP)) Q:LP<1  S:'$D(NP(.5,LP)) NP(.5,LP)=0 S NP(.5,LP)=NP(.5,LP)+P(.5,LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+P(.5,LP)
 K P(.5) F LP=0:0 S LP=$O(P(.7,LP)) Q:LP<1  S:'$D(NP(.7,LP)) NP(.7,LP)=0 S NP(.7,LP)=NP(.7,LP)+P(.7,LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+P(.7,LP)
 K P(.7) F LP=0:0 S LP=$O(P(.6,LP)) Q:LP<1  S:'$D(NP(.6,LP)) NP(.6,LP)=0 S NP(.6,LP)=NP(.6,LP)+P(.6,LP)
 K P(.6) F LP=0:0 S LP=$O(P(.8,LP)) Q:LP<1  S:'$D(NP(.8,LP)) NP(.8,LP)=0 S NP(.8,LP)=NP(.8,LP)+P(.8,LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+P(.8,LP)
 K P(.8),^TMP($J) F LL=0:0 S LL=$O(P(LL)) Q:LL<1  S P(LL,0)=0 F P0=0:0 S P0=$O(P(LL,P0)) Q:P0<1  S ^TMP($J,P0,LL)=P(LL,P0) S:'$D(D(P0)) D(P0)="" S D(P0)=D(P0)+P(LL,P0),P(LL,0)=P(LL,0)+P(LL,P0)
 F LP=0:0 S LP=$O(NP(.6,LP)) Q:LP<1  S:$D(D(LP)) NP(.6,LP)=NP(.6,LP)-D(LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+NP(.6,LP)
 F P0=0:0 S P0=$O(D(P0)) Q:P0<1  S ^TMP($J,P0)=D(P0)
 F LL=0:0 S LL=$O(P(LL)) Q:LL<1  I $G(P(LL,0)) S ^TMP($J,0,LL)=P(LL,0)
 K P,D
LST K S S L1=30
 F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0=""  S X=^FH(119.72,P0,0),N1=$P(X,"^",1),N2=$P(X,"^",2),N3=$P(X,"^",4) S:N3="" N3=$E(N1,1,6) S S(N3,P0)=$J(N3,8)_"^"_N2,L1=L1+10
 S:L1<80 L1=80 W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1
 S Z=$S(FHP1["F":"F O R E C A S T E D",1:"A C T U A L")_"   D I E T   C E N S U S"
 S DTP=NOW D DTP^FH W !,DTP,?(L1-$L(Z)\2),Z,?(L1-7),"Page ",PG,!?(L1-21\2),"P E R C E N T A G E S"
 S Z=$P(^FH(119.71,FHP,0),"^",1),DTP=D1 D DTP^FH
 S X=D1\1 D DOW^%DTC S DOW=Y+1,X=$P("Sun^Mon^Tues^Wednes^Thurs^Fri^Satur","^",DOW)_"day  "_DTP I FHAN="Y" S X=X_"  "_$P("BREAKFAST^NOON^EVENING","^",K3)
 S DTP=D1\1 D DTP^FH W !!?(L1-$L(Z)\2),Z,!!?(L1-$L(X)\2),X
 W !!?(L1-31\2),"P R O D U C T I O N   D I E T S",!!?29
 S X="" F  S X=$O(S(X)) Q:X=""  F K=0:0 S K=$O(S(X,K)) Q:K=""  W $P(S(X,K),"^",1)_" %"
 W !
 F P1=0:0 S P1=$O(^FH(116.2,"AP",P1)) Q:P1<1  F K=0:0 S K=$O(^FH(116.2,"AP",P1,K)) Q:K<1  I $D(^TMP($J,0,K)) D PRO
 I FHP1'["F" W !?3,"N P O",?31 S K=.5 D P1 K NP(.5)
 I FHP1'["F" W !?3,"P A S S",?31 S K=.8 D P1 K NP(.8)
 I FHP1'["F" W !?3,"TF Only",?31 S K=.7 D P1 K NP(.7)
 I FHP1'["F" W !?3,"No Order",?31 S K=.6 D P1 K NP(.6)
 W !
 Q
PRO W !,$P($G(^FH(116.2,K,0)),"^",1),?31
P1 F  S X=$O(S(X)) Q:X=""  F K1=0:0 S K1=$O(S(X,K1)) Q:K1=""  S Z=$S(K>.9:$G(^TMP($J,K1,K)),1:$G(NP(K,K1))),Z=$S($G(^TMP($J,K1)):Z/$G(^TMP($J,K1))*100,1:"") W $J(Z,8,1),"  "
 Q
