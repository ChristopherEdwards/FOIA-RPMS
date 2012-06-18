FHORD9 ; HISC/REL/NCA - Diet Order Census ;7/1/94  14:24 
 ;;5.0;Dietetics;**37**;Oct 11, 1995
 D NOW^%DTC S DT=%\1 K %
 S FHP=$O(^FH(119.71,0)) I FHP'<1,$O(^FH(119.71,FHP))<1 G F0
D0 R !!,"Select PRODUCTION FACILITY: ",X:DTIME G:'$T!("^"[X) KIL
 K DIC S DIC="^FH(119.71,",DIC(0)="EMQ" D ^DIC G:Y<1 D0 S FHP=+Y
F0 R !!,"Effective Date/Time: ",X:DTIME G:'$T!("^"[X) KIL S %DT="ETSX" D ^%DT G:Y<1 F0 S TIM=Y
 I (TIM\1)<DT W *7,"  Cannot be before TODAY!" G F0
 W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHORD9",FHLST="FHP^TIM" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Calculate census
 K ^TMP($J) S CT=0 D NOW^%DTC S NOW=% K %,D,P
 F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD<1  S X=^(WRD,0) D WRD
 G ^FHORD91
WRD ; Calculate census for ward
 K S S X1="" F D2=5,6 S N1=$P(X,"^",D2) Q:$G(^FH(119.72,+N1,"I"))="Y"  S N2=$P($G(^FH(119.72,+N1,0)),"^",3) I N2=FHP S S($E("TC",D2-4))=N1,D(N1)="",X1=X1_$E("TC",D2-4)
 Q:'$D(S)
 S:$L(X1)>1 X1=$E(X1,1) Q:'$D(S(X1))  S SP=S(X1)
 F DFN=0:0 S DFN=$O(^FHPT("AW",WRD,DFN)) Q:DFN<1  S ADM=^(DFN) I ADM>0 S K=SP D W3
 Q
W3 Q:'$D(^FHPT(DFN,"A",ADM,0))
 S X0=^FHPT(DFN,"A",ADM,0)
 S FHORD=$P(X0,"^",2),X1=$P(X0,"^",3),TF=$P(X0,"^",4),N1=$P(X0,"^",5) S:N1="" N1="T"
 I FHORD<1 S A1=$O(^FHPT(DFN,"A",ADM,"AC",0)) G:A1=""!(A1>TIM) W4 D U1 G:'FHORD W4 S X1=""
 I X1>1,X1'>TIM D U1 G:'FHORD W4
 I '$D(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) D U1 G:'FHORD W4
 S X=^FHPT(DFN,"A",ADM,"DI",FHORD,0),FHOR=$P(X,"^",2,6),FHLD=$P(X,"^",7),X1=$P(X,"^",8)
 S:X1="" X1=N1 S:X1="D" X1="T" Q:'$D(S(X1))  S K=S(X1) D CNT
 I FHLD="" S Z=$P(X,"^",13) S:Z="" FHLD="X" I Z S:'$D(P(Z,K)) P(Z,K)=0 S P(Z,K)=P(Z,K)+1 Q
 I FHLD="P" S:'$D(P(.8,K)) P(.8,K)=0 S P(.8,K)=P(.8,K)+1 Q
 I FHLD="N" D  Q
 .I TF="" S:'$D(P(.5,K)) P(.5,K)=0 S P(.5,K)=P(.5,K)+1 Q
 .S:'$D(P(.7,K)) P(.7,K)=0 S P(.7,K)=P(.7,K)+1 Q
 Q:'TF  S:'$D(P(.7,K)) P(.7,K)=0 S P(.7,K)=P(.7,K)+1 Q
W4 G:'TF CNT S:'$D(P(.7,K)) P(.7,K)=0 S P(.7,K)=P(.7,K)+1
CNT S:'$D(P(.6,K)) P(.6,K)=0 S P(.6,K)=P(.6,K)+1 Q
U1 S (A1,FHORD)=0 F K1=0:0 S K1=$O(^FHPT(DFN,"A",ADM,"AC",K1)) Q:K1<1!(K1>TIM)  S A1=K1
 Q:'A1  S X1=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2) G U2:X1<1,U2:'$D(^FHPT(DFN,"A",ADM,"DI",X1,0)) S FHORD=X1 Q
U2 S X1="",A1=0
U3 S A1=$O(^FHPT(DFN,"A",ADM,"AC",A1)) G:A1="" U1 S X2=$P(^(A1,0),"^",2)
 I X2<1 K ^FHPT(DFN,"A",ADM,"AC",A1) G U3
 I '$D(^FHPT(DFN,"A",ADM,"DI",X2,0)) K ^FHPT(DFN,"A",ADM,"AC",A1) G U3
 G U3
KIL K %,%H,%I,%T,%DT,%ZIS,A1,ADM,CHK,CT,D,D1,D2,DFN,DIC,DOW,DTP,FHLD,FHOR,FHP,FHPAR,K,K1,KK,L1,LP,N,N1,N2,N3,NOW,NXW,FHORD,P,P1,POP,S,SP,TF,TIM,TOT,TYP,WRD,WRDN,X,X0,X1,X2,Y,Z K ^TMP($J) Q
