FHSEL2	; HISC/REL/NCA - Tabulate Patient Preferences ;11/23/94  09:45
	;;5.0;Dietetics;;Oct 11, 1995
	S X="T",%DT="X" D ^%DT S DT=+Y
	S FHP=$O(^FH(119.72,0)) I FHP'<1,$O(^FH(119.72,FHP))<1 S FHP=0 G D1
D0	R !!,"Select SERVICE POINT (or ALL): ",X:DTIME G:'$T!("^"[X) KIL D:X="all" TR^FH I X="ALL" S FHP=0
	E  K DIC S DIC="^FH(119.72,",DIC(0)="EMQ" D ^DIC G:Y<1 D0 S FHP=+Y
D1	R !!,"Tabulate By Menu Specific? N// ",D3:DTIME G:'$T!(D3="^") KIL S:D3="" D3="N" D TR^FH I $P("YES",D3,1)'="",$P("NO",D3,1)'="" W *7,"  Answer YES or NO" G D1
	S D3=$E(D3,1) S:D3="Y" D3=D3="Y" I 'D3 S (D1,FHCY,FHDA)="" G R1
F1	S %DT("A")="Select Date: ",%DT="AEX" W ! D ^%DT G KIL:"^"[X!$D(DTOUT),F1:Y<1 S (X1,D1)=+Y
	I D1<DT W *7,"  [ Must NOT be before TODAY ]" G F1
	D E1^FHPRC1 I FHCY<1 W *7,!!,"No MENU CYCLE Defined for that Date!" G F1
	I '$D(^FH(116,FHCY,"DA",FHDA,0)) W *7,!!,"MENU CYCLE DAY Not Defined for that Date!" G F1
R1	R !!,"Select MEAL (B,N,E or ALL): ",MEAL:DTIME G:'$T!("^"[MEAL) KIL S X=MEAL D TR^FH S MEAL=X S:$P("ALL",MEAL,1)="" MEAL="A"
	I "BNEA"'[MEAL!(MEAL'?1U) W *7,!,"Select B for Breakfast, N for Noon, E for Evening or ALL for all meals" G R1
R2	R !!,"Break Down By Production Diets? N// ",SRT:DTIME G:'$T!(SRT="^") KIL S:SRT="" SRT="N" S X=SRT D TR^FH S SRT=X I $P("YES",SRT,1)'="",$P("NO",SRT,1)'="" W *7,"  Answer YES or NO" G R2
	S SRT=$E(SRT,1),SRT=SRT="Y"
	W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="Q1^FHSEL2",FHLST="D1^D3^FHP^FHCY^FHDA^MEAL^SRT" D EN2^FH G KIL
	U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1	; Printing Tabulated Patient Preference
	D NOW^%DTC S NOW=%,PG=0
	I MEAL'="A" G Q2
	F MEAL="B","N","E" D Q2
	Q
Q2	K ^TMP($J),D G:'D3 Q3
	S FHX1=^FH(116,FHCY,"DA",FHDA,0)
	I $D(^FH(116.3,D1,0)) S X=^(0) F LL=2:1:4 I $P(X,"^",LL) S $P(FHX1,"^",LL)=$P(X,"^",LL)
	S FHX1=$P(FHX1,"^",$F("BNE",MEAL)) I 'FHX1 Q
Q3	S:D1="" D1=NOW\1
	S TIM=D1\1_$S(MEAL="B":".07",MEAL="N":".11",1:".17")
	F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD<1  S X=^(WRD,0) D D2 I D2'="" S WRDN=$P(X,"^",1) D W2
	G ^FHSEL3
KIL	K ^TMP($J) G KILL^XUSCLEAN
W2	I $O(^FHPT("AW",WRD,0))<1 Q
	F DFN=0:0 S DFN=$O(^FHPT("AW",WRD,DFN)) Q:DFN<1  S ADM=^(DFN) I ADM>0 D W3
	Q
W3	S K2=0 Q:'$D(^FHPT(DFN,"A",ADM,0))  S X0=^(0)
	S FHORD=$P(X0,"^",2),X1=$P(X0,"^",3) I FHORD<1 S A1=$O(^FHPT(DFN,"A",ADM,"AC",0)) Q:A1=""!(A1>NOW)  D U1 Q:'FHORD  G W4
	I X1>1,X1'>TIM D U1 Q:'FHORD
	I '$D(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) D U1 Q:'FHORD
W4	S X=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0))
	S TC=$P(X,"^",8) Q:TC=""  S PD=$P(X,"^",13) Q:PD=""  S:TC="D" TC="T" Q:'$D(S(TC))  S:D2[TC K2=1 S:K2 SP=S(TC)
	S PD=$S('PD:"",$D(^FH(116.2,+PD,0)):$P(^(0),"^",2),1:"") Q:PD=""
	I K2 F K=0:0 S K=$O(^FHPT(DFN,"P",K)) Q:K<1  S Z=^(K,0) I $P(Z,"^",2)[MEAL S QTY=$P(Z,"^",3),Z=+Z I Z S:'$D(^TMP($J,"P",Z,PD,SP)) ^TMP($J,"P",Z,PD,SP)=0 S ^(SP)=^(SP)+$S(QTY:QTY,1:1)
	Q
D2	K S S D2=""
	F L=5,6 S XX=$P(X,"^",L) I XX=FHP!('FHP) S:XX S($E("TC",L-4))=XX,D(XX)="",D2=D2_$E("TC",L-4)
	Q
U1	S (A1,FHORD)=0 F K=0:0 S K=$O(^FHPT(DFN,"A",ADM,"AC",K)) Q:K<1!(K>TIM)  S A1=K
	Q:'A1  S X1=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2) G U2:X1<1,U2:'$D(^FHPT(DFN,"A",ADM,"DI",X1,0)) S FHORD=X1 Q
U2	S X1="",A1=0
U3	S A1=$O(^FHPT(DFN,"A",ADM,"AC",A1)) G:A1="" U1 S X2=$P(^(A1,0),"^",2)
	I X2<1 K ^FHPT(DFN,"A",ADM,"AC",A1) G U3
	I '$D(^FHPT(DFN,"A",ADM,"DI",X2,0)) K ^FHPT(DFN,"A",ADM,"AC",A1) G U3
	G U3
