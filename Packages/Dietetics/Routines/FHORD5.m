FHORD5	; HISC/REL/NCA - Withhold Lists ;3/16/95  14:21
	;;5.0;Dietetics;;Oct 11, 1995
	W @IOF,!!?27,"N P O / P A S S   L I S T",!!
	S FHP=$O(^FH(119.73,0)) I FHP'<1,$O(^FH(119.73,FHP))<1 S FHP=0 G R1
R0	R !!,"Select COMMUNICATION OFFICE (or ALL): ",X:DTIME G:'$T!("^"[X) KIL D:X="all" TR^FH I X="ALL" S FHP=0
	E  K DIC S DIC="^FH(119.73,",DIC(0)="EMQ" D ^DIC G:Y<1 R0 S FHP=+Y
R1	R !!,"Sort by WARD or DATE/TIME? WARD// ",SRT:DTIME G:'$T!(SRT["^") KIL S:SRT="" SRT="W" S X=SRT D TR^FH S SRT=X
	I $P("WARD",SRT,1)'="",$P("DATE/TIME",SRT,1)'="" W *7,"  Enter W or D" G R1
	S SRT=$E(SRT,1)
R2	W !!,"The list requires a 132 column printer.",!
	W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="F1^FHORD5",FHLST="FHP^SRT" D EN2^FH G KIL
	U IO D F1 D ^%ZISC K %ZIS,IOP G KIL
KIL	K ^TMP($J) G KILL^XUSCLEAN
F1	; List Withholds
	D NOW^%DTC S NOW=%,DT=NOW\1 S X1=NOW,X2=-3 D C^%DTC S OLD=+X,PG=0 D HDR K ^TMP($J)
	F W1=0:0 S W1=$O(^FHPT("AW",W1)) Q:W1'>0  D DP I 'FHP!(D1=FHP) F DFN=0:0 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN<1  S ADM=^(DFN) I ADM>0 D F2
	S WRDN="" F A3=0:0 S WRDN=$O(^TMP($J,WRDN)) Q:WRDN=""  F DFN=0:0 S DFN=$O(^TMP($J,WRDN,DFN)) Q:DFN<1  S X=^(DFN) D F3
	W ! Q
F2	S Y(0)=^DPT(DFN,0) Q:'$D(^FHPT(DFN,"A",ADM,0))  Q:$P(^(0),"^",4)  D CUR^FHORD7 Q:FHLD=""
	S A1=0 F K=0:0 S K=$O(^FHPT(DFN,"A",ADM,"AC",K)) Q:K<1!(K>NOW)  I $P(^(K,0),"^",2)=FHORD S A1=K
	S D2=$P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",10) D PID^FHDPA
	S RM=$E(WRDN,1,14) I $D(^DPT(DFN,.101)) S RM=RM_"/"_^(.101)
	S ^TMP($J,$S(SRT="W":WRDN,1:A1),DFN)=$E(RM,1,21)_"^"_$P(Y(0),"^",1)_"^"_BID_"^"_A1_"^"_D2_"^"_Y Q
F3	D:$Y>58 HDR W !,$P(X,"^",1),?24,$P(X,"^",2),?55,$P(X,"^",3)
	S D1=$P(X,"^",4),D2=$P(X,"^",5)
	S DTP=D1 D DTP^FH W ?64,DTP I D2 S DTP=D2 D DTP^FH W ?83,DTP
	W:D1<OLD ?102,"*" W ?106,$P(X,"^",6) Q
DP	S WRDN=$P(^FH(119.6,W1,0),"^",1),D1=$P(^(0),"^",8) Q
HDR	W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1 W !?44,"N P O  /  P A S S   L I S T",?107,"Page ",PG
	W !! W:FHP $P(^FH(119.73,FHP,0),"^",1) S DTP=NOW D DTP^FH W ?48,DTP
	W !!,"WARD/ROOM",?24,"PATIENT",?56,"ID#",?65,"EFFECTIVE DATE",?84,"EXPIRATION DATE",?102,">3",?106,"REASON",! Q
