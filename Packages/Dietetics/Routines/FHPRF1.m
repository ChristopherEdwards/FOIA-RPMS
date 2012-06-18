FHPRF1 ; HISC/REL - Calculate Total Forecast ;1/23/98  16:10
 ;;5.0;Dietetics;**13,37**;Oct 11, 1995
 S %DT="X",X="T" D ^%DT S DT=+Y
D1 R !!,"Forecast Date: ",X:DTIME G:'$T!("^"[X) KIL S %DT="EX" D ^%DT G KIL:"^"[X,D1:Y<1 S D1=+Y
 S FHP=$O(^FH(119.71,0)) I FHP'<1,$O(^FH(119.71,FHP))<1 G R1
R0 R !!,"Select PRODUCTION FACILITY: ",X:DTIME G:'$T!("^"[X) KIL
 K DIC S DIC="^FH(119.71,",DIC(0)="EMQ" D ^DIC G:Y<1 R0 S FHP=+Y
R1 W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHPRF1",FHLST="D1^FHP" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Process Census Forecast
 D Q2,Q3 G ^FHPRF1A
Q2 ; Calculate Service Point census forecast
 S X="T",%DT="X" D ^%DT S DT=+Y
 K ^TMP($J) S X=D1 D DOW^%DTC S DOW=Y+1 D BLD,DAT
 F W1=0:0 S W1=$O(^TMP($J,"W",W1)) Q:W1<1  D WRD S ^TMP($J,"W",W1)=S1
 K D,DC S X1=DT,X2=-1 D C^%DTC S D2=X
 F P0=0:0 S P0=$O(^TMP($J,"S",P0)) Q:P0<1  D ADD S ^TMP($J,P0)=S1
 Q
Q3 F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  S S1=^(P0) D PER S ^TMP($J,P0)=S0
 F K=0:0 S K=$O(D(K)) Q:K<1  S ^TMP($J,0,K)=D(K)
 K D,^TMP($J,"W"),^TMP($J,"S") Q
WRD S (A,B,CT,S1,S2,S3,S4)=0 F K=1:1:9 S Y=$P($G(^DG(41.9,W1,"C",D(K),0)),"^",2) I Y S CT=CT+1,S0=10-K,S1=S1+S0,S2=S0*S0+S2,S3=S3+Y,S4=S0*Y+S4
 G:'CT W1 I CT=1 S S1=S3 G W1
 S S0=S1*S1/CT-S2,A=S1*S3/CT-S4/S0,B=S3/CT-(A*S1/CT)
 S A=$J(A,0,3),B=$J(B,0,2),S1=10*A+B
W1 S (N1,C2,C3)=0 F K=1:1:7 S Y0=$P($G(^DG(41.9,W1,"C",DC(K),0)),"^",2) I Y0 S N1=N1+1,C2=Y0-S1*(4-N1)+C2,C3=4-N1+C3 Q:N1=3
 I N1 S C2=C2/C3,S1=S1+C2
 S S1=$J(S1,0,0) Q
ADD S (S1,CT)=0 F W1=0:0 S W1=$O(^TMP($J,"S",P0,W1)) Q:W1<1  S Z=^(W1),T0=$G(^TMP($J,"W",W1)),CT=CT+T0,S1=Z*T0/100+S1
 S S1=$J(S1,0,0)
 I '$D(^FH(119.72,P0,"C",D1,0)) S ^(0)=D1 I '$D(^FH(119.72,P0,"C",0)) S ^(0)="^119.722DA^^"
 I D1'<DT S C2=$P(^FH(119.72,P0,"C",D1,0),"^",3),$P(^(0),"^",2,5)=CT_"^"_C2_"^"_S1_"^"_DT
 Q:'$D(^FH(119.72,P0,"C",DT,0))  S C2=0
 F W1=0:0 S W1=$O(^TMP($J,"S",P0,W1)) Q:W1<1  S C2=C2+$P($G(^DG(41.9,W1,"C",D2,0)),"^",2)
 S:C2 $P(^FH(119.72,P0,"C",DT,0),"^",3)=C2 Q
PER S S0=0 F K=0:0 S K=$O(^FH(119.72,P0,"A",K)) Q:K<1  S Z=$P($G(^(K,0)),"^",DOW+1),Z=$J(Z*S1/100,0,0) I Z S ^TMP($J,P0,K)=Z,S0=S0+Z,D(K)=$G(D(K))+Z
 Q
DAT ; Build list of dates
 K D,DC S X1=D1,X2=-1 D C^%DTC S D2=X
 F K=1:1:9 S X1=D2,X2=-7 D C^%DTC S D(K)=X,D2=X
 S D2=D1 F K=1:1:7 S X1=D2,X2=-1 D C^%DTC S DC(K)=X,D2=X
 Q
BLD ; Build list of MAS wards and %'s for each Service Point
 K ^TMP($J,"S"),^TMP($J,"W")
 F P0=0:0 S P0=$O(^FH(119.72,P0)) Q:P0<1  S X=$G(^(P0,0)) I $P(X,"^",3)=FHP,$G(^FH(119.72,P0,"I"))'="Y" S ^TMP($J,"S",P0)=""
 F K1=0:0 S K1=$O(^FH(119.6,K1)) Q:K1<1  S X=$G(^(K1,0)) D B1
 Q
B1 S Z=$P(X,"^",5) I Z,$D(^TMP($J,"S",Z)) S Z1=$P(X,"^",17) S:$P(X,"^",7) Z1=Z1+$P(X,"^",19) S:'Z1 Z1=100 D B2
 S Z=$P(X,"^",6) I Z,$D(^TMP($J,"S",Z)) S Z1=$P(X,"^",18) S:Z1="" Z1=100 D B2
 Q
B2 F L2=0:0 S L2=$O(^FH(119.6,K1,"W",L2)) Q:L2<1  S ZW=+$G(^(L2,0)) I ZW S ^TMP($J,"W",ZW)="",^TMP($J,"S",Z,ZW)=Z1
 Q
KIL K ^TMP($J) G KILL^XUSCLEAN
