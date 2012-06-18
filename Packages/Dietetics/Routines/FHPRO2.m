FHPRO2 ; HISC/REL/NCA - Forecast/Census Calculations ;1/23/98  16:10
 ;;5.0;Dietetics;**13,37**;Oct 11, 1995
 S X=D1 D DOW^%DTC S DOW=Y+1 D NOW^%DTC S NOW=%,PG=0
 I MEAL'="A" G Q2
 F MEAL="B","N","E" D Q2
 Q
Q2 S K3=$F("BNE",MEAL)-1,FHX1=$P(FHDA,"^",K3+1) Q:'FHX1  D CEN:FHP6["C",FOR:FHP6["F",LIS
 G ^FHPRO3
FOR ; Calculate for Forecast
 K ^TMP($J) F P0=0:0 S P0=$O(M2(P0)) Q:P0<1  S ^TMP($J,P0)=M2(P0)
 K D F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  S S1=^(P0) D PER S ^TMP($J,P0)=S0
 F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  I $D(^FH(119.72,P0,"B")) D F1
 F LL=0:0 S LL=$O(D(LL)) Q:LL<1  S ^TMP($J,0,LL)=D(LL)
 K D Q
F1 F LL=0:0 S LL=$O(^FH(119.72,P0,"B",LL)) Q:LL<1  S Y=$P(^(LL,0),"^",3*DOW-2+K3) I Y>0 S D(LL)=$G(D(LL))+Y,^TMP($J,P0)=^TMP($J,P0)+Y,^TMP($J,P0,LL)=$G(^TMP($J,P0,LL))+Y
 Q
PER S S0=0 F K=0:0 S K=$O(^FH(119.72,P0,"A",K)) Q:K<1  S Z=$P($G(^(K,0)),"^",DOW+1),Z=$J(Z*S1/100,0,0) I Z S ^TMP($J,P0,K)=Z,S0=S0+Z,D(K)=$G(D(K))+Z
 Q
LIS S DTP=D1\1 D DTP^FH S TIM=$P("SUN^MON^TUES^WEDNES^THURS^FRI^SATUR","^",DOW)_"DAY  "_DTP_"  "_$P("BREAKFAST^NOON^EVENING","^",K3),DTP=NOW D DTP^FH
 K S,D,N S L1=38
 F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0=""  S X=^FH(119.72,P0,0),N1=$P(X,"^",1),N2=$P(X,"^",2),N3=$P(X,"^",4) S:N3="" N3=$E(N1,1,6) S S(N3,P0)=$J(N3,8)_"^"_N2,L1=L1+14
 S:L1<80 L1=80
 S Z=$S(FHP6["F":"F O R E C A S T E D",1:"A C T U A L")_"   D I E T   C E N S U S"
 W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1
 S DTP=NOW D DTP^FH W !,DTP,?(L1-$L(Z)\2),Z,?(L1-7),"Page ",PG
 S Z=$P(^FH(119.71,FHP,0),"^",1)
 W !!?(L1-$L(Z)\2),Z,!!?(L1-$L(TIM)\2),TIM
 W !!?(L1-31\2),"P R O D U C T I O N   D I E T S",!!?29
 S X="" F  S X=$O(S(X)) Q:X=""  F K=0:0 S K=$O(S(X,K)) Q:K=""  W $P(S(X,K),"^",1)
 W "    Total" S LN="",$P(LN,"-",L1+1)="" W !,LN,! K LN
 F P1=0:0 S P1=$O(^FH(116.2,"AP",P1)) Q:P1<1  F K=0:0 S K=$O(^FH(116.2,"AP",P1,K)) Q:K<1  I $D(^TMP($J,0,K)) D PRO
 I FHP6["C" W !?3,"N P O",?31 S K=.5 D P1 K NP(.5)
 I FHP6["C" W !?3,"P A S S",?31 S K=.8 D P1 K NP(.8)
 I FHP6["C" W !?3,"TF Only",?31 S K=.7 D P1 K NP(.7)
 I FHP6["C" W !?3,"No Order",?31 S K=.6 D P1 K NP(.6)
 W !!,"TOTAL MEALS",?31 S TOT=""
 S X="" F  S X=$O(S(X)) Q:X=""  F K1=0:0 S K1=$O(S(X,K1)) Q:K1=""  S Z=$G(^TMP($J,K1)) S:Z TOT=TOT+Z W $J(Z,6),"  "
 W $J(TOT,7) Q
 W !!!,"*** Includes other gratuitous/paid meals.",! K S,D,N,P Q
PRO W !,$P($G(^FH(116.2,K,0)),"^",1),?31
P1 S (TOT,X)="" F  S X=$O(S(X)) Q:X=""  F K1=0:0 S K1=$O(S(X,K1)) Q:K1=""  S Z=$S(K>.9:$G(^TMP($J,K1,K)),1:$G(NP(K,K1))) S:Z TOT=TOT+Z W $J(Z,6),"  "
 W $J(TOT,7) Q
CEN ; Calculate for Census
 S X=D1_"@"_$S(MEAL="B":"7AM",MEAL="N":"11AM",1:"4PM"),%DT="TX" D ^%DT S TIM=Y
 K D,P F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD<1  S X=^(WRD,0) D WRD^FHORD9
 K D,NP,T F LP=0:0 S LP=$O(P(.5,LP)) Q:LP<1  S:'$D(NP(.5,LP)) NP(.5,LP)=0 S NP(.5,LP)=NP(.5,LP)+P(.5,LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+P(.5,LP)
 K P(.5) F LP=0:0 S LP=$O(P(.7,LP)) Q:LP<1  S:'$D(NP(.7,LP)) NP(.7,LP)=0 S NP(.7,LP)=NP(.7,LP)+P(.7,LP) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+P(.7,LP)
 K P(.7) F LL=0:0 S LL=$O(P(.6,LL)) Q:LL<1  S:'$D(NP(.6,LL)) NP(.6,LL)=0 S NP(.6,LL)=NP(.6,LL)+P(.6,LL)
 K P(.6) F LL=0:0 S LL=$O(P(.8,LL)) Q:LL<1  S:'$D(NP(.8,LL)) NP(.8,LL)=0 S NP(.8,LL)=NP(.8,LL)+P(.8,LL) S:'$D(D(LL)) D(LL)=0 S D(LL)=D(LL)+P(.8,LL)
 K P(.8) F LL=0:0 S LL=$O(P(LL)) Q:LL<1  F P0=0:0 S P0=$O(P(LL,P0)) Q:P0<1  S:'$D(T(P0)) T(P0)=0 S T(P0)=T(P0)+P(LL,P0)
 F LP=0:0 S LP=$O(NP(.6,LP)) Q:LP<1  S:$D(T(LP)) NP(.6,LP)=NP(.6,LP)-T(LP)-$G(D(LP)) S:'$D(D(LP)) D(LP)=0 S D(LP)=D(LP)+NP(.6,LP)
 F P0=0:0 S P0=$O(^FH(119.72,P0)) Q:P0<1  I $P(^(P0,0),"^",3)=FHP I $D(^FH(119.72,P0,"B")) D D0
 K ^TMP($J) F LL=0:0 S LL=$O(P(LL)) Q:LL<1  S P(LL,0)=0 F P0=0:0 S P0=$O(P(LL,P0)) Q:P0<1  S ^TMP($J,P0,LL)=P(LL,P0) S:'$D(D(P0)) D(P0)="" S D(P0)=D(P0)+P(LL,P0),P(LL,0)=P(LL,0)+P(LL,P0)
 F P0=0:0 S P0=$O(D(P0)) Q:P0<1  S ^TMP($J,P0)=D(P0)
 F LL=0:0 S LL=$O(P(LL)) Q:LL<1  I $G(P(LL,0)) S ^TMP($J,0,LL)=P(LL,0)
 K P,D Q
D0 ;
 I $G(^FH(119.72,P0,"I"))="Y" Q
 F LL=0:0 S LL=$O(^FH(119.72,P0,"B",LL)) Q:LL<1  S Y=$P(^(LL,0),"^",3*DOW-2+K3) I Y>0 S:'$D(P(LL,P0)) P(LL,P0)=0 S P(LL,P0)=P(LL,P0)+Y
 Q
