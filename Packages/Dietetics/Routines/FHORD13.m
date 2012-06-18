FHORD13 ; HISC/REL/NCA - Reprint Diet Label ;2/26/96  11:57
 ;;5.0;Dietetics;**2,38,39**;Mar 25, 1996
 W @IOF,!!?21,"R E P R I N T   D I E T   L A B E L S"
F0 R !!,"Reprint by COMMUNICATION OFFICE, PATIENT, or WARD? PATIENT// ",X:DTIME G:'$T!(X["^") KIL S:X="" X="P" D TR^FH I $P("COMMUNICATION OFFICE",X,1)'="",$P("PATIENT",X,1)'="",$P("WARD",X,1)'="" W *7,!!,"  Answer with C, W, or P" G F0
 S FHPR=$E(X,1),ALL=0,(FHX1,FHX2)="" G P0:FHPR?1"P",D2:FHPR?1"C"
W0 K DIC S DIC("A")="Select WARD: ",DIC="^FH(119.6,",DIC(0)="AEQM" W ! D ^DIC K DIC G KIL:"^"[X!$D(DTOUT),W0:Y<1 S FHX1=-Y G P1
D2 K DIC S DIC("A")="Select COMMUNICATION OFFICE: ",DIC="^FH(119.73,",DIC(0)="AEMQ" W ! D ^DIC G KIL:"^"[X!$D(DTOUT),D2:Y<1 S FHX1=-Y G P1
P0 D ^FHDPA I DFN S FHX1=$G(FHX1)_DFN_"^",FHX2=$G(FHX2)_ADM_"^" I $L(FHX1)<231,$L(FHX2)<231 G P0
 G:FHX1="" KIL
P1 ;
 W ! K DIR,LABSTART S DIR(0)="NA^1:10",DIR("A")="If using laser label sheets, what row do you want to begin printing at? ",DIR("B")=1 D ^DIR
 Q:$D(DIRUT)  S LABSTART=Y
 W ! K IOP,%ZIS S %ZIS("A")="Select LABEL Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHORD13",FHLST="FHX1^FHX2^FHPR^LABSTART" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Reprint the Diet Labels
 S LAB=$P($G(^FH(119.9,1,"D",IOS,0)),"^",2) S:'LAB LAB=1 S S2=LAB=2*5+36 D NOW^%DTC S NOW=%
 S COUNT=0,LINE=1
 S DTP=NOW D DTP^FH,^FHDEV G:FHX1>0 Q2
 S WRD=-FHX1 K ^TMP($J)
 F K1=0:0 S K1=$O(^FH(119.6,K1)) Q:K1<1  S X=^(K1,0) D F1
 S RM="" F  S RM=$O(^TMP($J,"DL",RM)) Q:RM=""  F DFN=0:0 S DFN=$O(^TMP($J,"DL",RM,DFN)) Q:DFN<1  S ADM=^(DFN) D:ADM LST
 I LAB>2 D DPLL^FHLABEL K ^TMP($J) Q
 K ^TMP($J) G Q3
F1 I FHPR="C" S KK=$P(X,"^",8) I WRD,KK'=WRD Q
 I FHPR="W" S KK=$P(X,"^",1) I WRD,K1'=WRD Q
 S P0=$P(X,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
 F DFN=0:0 S DFN=$O(^FHPT("AW",K1,DFN)) Q:DFN<1  D
 .S ADM=^(DFN),RM=$G(^DPT(DFN,.101))
 .S:RM="" RM="***"
 .S RI=$G(^DPT(DFN,.108)) S RE=$S(RI:$O(^FH(119.6,"AR",+RI,K1,0)),1:"")
 .S R0=$S(RE:$P($G(^FH(119.6,K1,"R",+RE,0)),"^",2),1:"")
 .S R0=$S(R0<1:99,R0<10:"0"_R0,1:R0)
 .S ^TMP($J,"DL",P0_"~"_R0_"~"_RM,DFN)=ADM Q
 Q
Q2 F K7=1:1 S DFN=$P(FHX1,"^",K7) Q:DFN<1  S ADM=$P(FHX2,"^",K7) D LST
 I LAB>2 D DPLL^FHLABEL K ^TMP($J) Q
Q3 I LAB<3 F K7=1:1:18 W !
 Q
LST Q:'$D(^FHPT(DFN,"A",ADM,0))  S X0=^(0)
 S FHORD=$P(X0,"^",2),X1=$P(X0,"^",5) Q:FHORD<1
 S W1=$P(X0,"^",8),W1=$P($G(^FH(119.6,+W1,0)),"^",1),R1=$G(^DPT(DFN,.101))
 Q:'$D(^DPT(DFN,0))  S Y0=^(0) D PID^FHDPA
 S W1=$E(W1,1,15),N1=$E($P(Y0,"^",1),1,22)
 S X=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0))
 S (Y,X1)="" G:X="" L1 S FHOR=$P(X,"^",2,6),FHLD=$P(X,"^",7)
 I FHLD'="" S FHDU=";"_$P(^DD(115.02,6,0),"^",3),%=$F(FHDU,";"_FHLD_":") G:%<1 L1 S Y=$P($E(FHDU,%,999),";",1) G L1
 F A1=1:1:5 S D3=$P(FHOR,"^",A1) I D3 S:Y'="" Y=Y_", " S Y=Y_$P(^FH(111,D3,0),"^",7)
 S IS=$P(X0,"^",10),X1=$P(X,"^",8) I IS S IS=^FH(119.4,IS,0),X1=X1_"-"_$P(IS,"^",2)_$P(IS,"^",3)
L1 I LAB>2 D LL Q
 W !,$E(N1,1,S2-5-$L(W1)),?(S2-3-$L(W1)),W1,!,BID W @FHIO("EON") W ?(S2-3\2),X1 W @FHIO("EOF") W ?(S2-3-$L(R1)),R1 W @FHIO("EON") I $L(Y)<S2 W:LAB=2 ! W !!,Y,!!
 E  S L=$S($L($P(Y,",",1,3))<S2:3,1:2) W !!,$P(Y,",",1,L) W:LAB=2 ! W !,$E($P(Y,",",L+1,5),2,99),!
 W @FHIO("EOF") W:LAB=2 ?(S2-20),DTP,!! Q
KIL K ^TMP($J) G KILL^XUSCLEAN
 Q
LL D LAB^FHLABEL Q
