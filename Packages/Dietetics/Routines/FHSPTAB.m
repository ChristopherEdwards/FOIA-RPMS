FHSPTAB	; HISC/REL/NCA - Tabulate Standing Orders ;4/27/93  13:07 
	;;5.0;Dietetics;;Oct 11, 1995
	S FHP=$O(^FH(119.72,0)) I FHP'<1,$O(^FH(119.72,FHP))<1 S FHP=0 G R1
R0	R !!,"Select SERVICE POINT (or ALL): ",X:DTIME G:'$T!("^"[X) KIL D:X="all" TR^FH I X="ALL" S FHP=0
	E  K DIC S DIC="^FH(119.72,",DIC(0)="EMQ" D ^DIC G:Y<1 R0 S FHP=+Y
R1	R !!,"Select Meal (B,N,E or ALL): ",MEAL:DTIME G:'$T!("^"[MEAL) KIL S X=MEAL D TR^FH S MEAL=X S:$P("ALL",MEAL,1)="" MEAL="A"
	I "BNEA"'[MEAL!(MEAL'?1U) W *7,!,"Enter B for Breakfast, N for Noon , E for Evening or ALL for all meals" G R1
R3	W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="Q1^FHSPTAB",FHLST="FHP^MEAL" D EN2^FH G KIL
	U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1	; Print the Tabulated List of Standing Orders
	D NOW^%DTC S NOW=%,PG=0 I MEAL'="A" G Q2
	F MEAL="B","N","E" D Q2
	Q
Q2	S T0=(NOW\1)_$S(MEAL="B":".07",MEAL="N":".11",1:".17")
	K N F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  D DP I DP'="" F DFN=0:0 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN<1  S ADM=^(DFN) D ADD
	D HDR S NX="" F K1=0:0 S NX=$O(^FH(118.3,"B",NX)) Q:NX=""  F K=0:0 S K=$O(^FH(118.3,"B",NX,K)) Q:K<1  I $D(N(K)) D:$Y>56 HDR W !,$J(N(K),6),"       ",$P(^FH(118.3,K,0),"^",1)
	W ! Q
ADD	Q:ADM<1  D CHK I K2 F K2=0:0 S K2=$O(^FHPT("ASP",DFN,ADM,K2)) Q:K2<1  S X=^FHPT(DFN,"A",ADM,"SP",K2,0) D A1
	Q
A1	S FHORD=$P(X,"^",2),M1=$P(X,"^",3) I FHORD,M1[MEAL S:'$D(N(FHORD)) N(FHORD)=0 S Q=$P(X,"^",8),N(FHORD)=N(FHORD)+$S(Q:Q,1:1)
	Q
CHK	S K2=0,X1=$G(^FHPT(DFN,"A",ADM,0)),FHORD=$P(X1,"^",2),X1=$P(X1,"^",3) G:FHORD<1 C1
	I X1>1,X1'>T0 G C2
C0	I '$D(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) G C2
	S X1=$P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",8) I X1="" G C1
	S:X1="D" X1="T" S:DP[X1 K2=1
C1	K FHORD,A1,K,X1 Q
C2	S A1=0 F K=0:0 S K=$O(^FHPT(DFN,"A",ADM,"AC",K)) Q:K<1!(K>T0)  S A1=K
	G:'A1 C1 S FHORD=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2) G:FHORD'<1 C0 K ^FHPT(DFN,"A",ADM,"AC",A1) G C2
DP	S DP="" I 'FHP S DP="TC" Q
	S X=$P($G(^FH(119.6,W1,0)),"^",5,6) S:$P(X,"^",1)=FHP DP="T" S:$P(X,"^",2)=FHP DP=DP_"C" Q
HDR	W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1,DTP=NOW D DTP^FH W !,DTP,?25,"S T A N D I N G   O R D E R S",?74,"Page ",PG
	W !! W:FHP $P(^FH(119.72,FHP,0),"^",1) S Y=$S(MEAL="B":"BREAKFAST",MEAL="N":"NOON",1:"EVENING") W ?(80-$L(Y)\2),Y
	W !!,"Quantity     Order",! Q
KIL	G KILL^XUSCLEAN
