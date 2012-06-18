FHNO6	; HISC/REL/NCA - Supplemental Feeding Costs ;2/13/95  13:32 
	;;5.0;Dietetics;;Oct 11, 1995
	W @IOF,!!?27,"SUPPLEMENTAL FEEDING COSTS",!!
D0	R !!,"Select by S=SUPPLEMENTAL FEEDING SITE or W=WARD: ",XX:DTIME G:'$T!("^"[XX) KIL
	I XX'?1U!("SW"'[XX) W *7," Enter S or W" G D0
	I XX="S" S WRD=$O(^FH(119.74,0)) I WRD'<1,$O(^FH(119.74,WRD))<1 G S0
	I XX="W" S WRD=$O(^FH(119.6,0)) I WRD'<1,$O(^FH(119.6,WRD))<1 G S0
	I XX="S" G D2
F1	R !!,"Select WARD (or ALL): ",X:DTIME G:'$T!("^"[X) KIL I X="ALL" S WRD=0
	E  K DIC S DIC="^FH(119.6,",DIC(0)="EQM" D ^DIC G:Y<1 F1 S WRD=+Y
	G S0
D2	R !!,"Select SUPPLEMENTAL FEEDING SITE (or ALL): ",X:DTIME G:'$T!("^"[X) KIL I X="ALL" S WRD=0
	I X'="ALL" K DIC S DIC="^FH(119.74,",DIC(0)="EMQ" D ^DIC G:Y<1 D2 S WRD=+Y
S0	S X="N" I 'WRD R !!,"SUMMARY only? Y// ",X:DTIME G:'$T!(X="^") KIL S:X="" X="Y" I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7,"  Answer YES or NO" G S0
	S SUM=X?1"Y".E
L0	W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="Q1^FHNO6",FHLST="XX^WRD^SUM" D EN2^FH G KIL
	U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1	; Print Supplemental Feeding Cost Report
	D NOW^%DTC S DTP=% D DTP^FH S PTIM=DTP,PG=0 K ^TMP($J)
	F KK=0:0 S KK=$O(^FH(119.6,KK)) Q:KK<1  S X0=$G(^(KK,0)) D
	.I XX="W",WRD,WRD'=KK Q
	.I XX="S",WRD,$P(X0,"^",9)'=WRD Q
	.S P0=$P(X0,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0),TNOD=$S(SUM:"0",XX="S":"99~"_$P($G(^FH(119.74,+$P(X0,"^",9),0)),"^",1),1:P0_"~"_$P(X0,"^",1))
	.F DFN=0:0 S DFN=$O(^FHPT("AW",KK,DFN)) Q:DFN<1  S ADM=^(DFN) I ADM>0 D
	..S $P(^TMP($J,"T",TNOD,0),"^",1)=$P($G(^TMP($J,"T",TNOD,0)),"^",1)+1
	..S (NO,Y)="" I $D(^FHPT(DFN,"A",ADM,0)) S NO=$P(^(0),"^",7)
	..Q:'NO  S Y=$G(^FHPT(DFN,"A",ADM,"SF",NO,0))
	..S PD=$P(Y,"^",29) S:PD="" PD="D"
	..S $P(^TMP($J,"T",TNOD,0),"^",PD'="D"+2)=$P(^TMP($J,"T",TNOD,0),"^",PD'="D"+2)+1
	..F L=5:2:28 S Z=$P(Y,"^",L),Q=$P(Y,"^",L+1) I Z'="" S:'Q Q=1 S:'$D(^TMP($J,"T",TNOD,Z,PD)) ^TMP($J,"T",TNOD,Z,PD)=0 S ^(PD)=^(PD)+Q
	..Q
	.Q
	S NAM="" F  S NAM=$O(^FH(118,"B",NAM)) Q:NAM=""  F Z=0:0 S Z=$O(^FH(118,"B",NAM,Z)) Q:Z<1  I $O(^(Z,0))="" S REC=$P($G(^FH(118,Z,0)),"^",7),CU=$P($G(^FH(114,+REC,0)),"^",13),^TMP($J,"P",NAM_"~"_Z)=CU
	S TNOD="" F  S TNOD=$O(^TMP($J,"T",TNOD)) Q:TNOD=""  D
	.Q:$O(^TMP($J,"T",TNOD,0))=""  D HDR S (T1,T2)=0
	.S NAM="" F  S NAM=$O(^TMP($J,"P",NAM)) Q:NAM=""  S CU=^(NAM) D
	..S Z=$P(NAM,"~",2) I '$D(^TMP($J,"T",TNOD,Z)) Q
	..S A1=$G(^TMP($J,"T",TNOD,Z,"D")),A2=$G(^("T")),T1=A1*CU+T1,T2=A2*CU+T2 D:$Y>(IOSL-8) HDR
	..W !,$E($P(NAM,"~",1),1,24),?25,$J(CU,7,3),$J(A1,7),$J(A1*CU,8,2),$J(A2,8),$J(A2*CU,8,2),$J(A1+A2,8),$J(A1+A2*CU,8,2) Q
	.D:$Y>(IOSL-13) HDR W !!,"Total",?39,$J(T1,8,2),$J(T2,16,2),$J(T1+T2,16,2)
	.S CTR=$G(^TMP($J,"T",TNOD,0)),WP=$P(CTR,"^",1),WPD=$P(CTR,"^",2),WPT=$P(CTR,"^",3)
	.W !!,"Cost/Patient:",?32,$J(WP,7),?39,$J(T1/WP,8,2),?47,$J(WP,8),?55,$J(T2/WP,8,2),?63,$J(WP,8),?71,$J(T1+T2/WP,8,2)
	.W !,"Cost/Recipient:" W:WPD ?32,$J(WPD,7),?39,$J(T1/WPD,8,2) W:WPT ?47,$J(WPT,8),?55,$J(T2/WPT,8,2) W:(WPD+WPT) ?63,$J(WPD+WPT,8),?71,$J(T1+T2/(WPD+WPT),8,2)
	.W !!,"Recipient %:" W:WPD ?39,$J(WPD/WP*100,8,0) W:WPT ?55,$J(WPT/WP*100,8,0) W:(WPD+WPT) ?71,$J(WPD+WPT/WP*100,8,0) W ! Q
	Q
HDR	; Print Header
	W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1
	W !,PTIM,!!?11,"S U P P L E M E N T A L   F E E D I N G   C O S T S",?73,"Page ",PG
	S Y=$S(SUM:"CONSOLIDATED",1:$P(TNOD,"~",2)) W !!?(80-$L(Y)\2),Y
	W !!?38,"DIETARY",?52,"THERAPEUTIC",?71,"TOTAL",!,"Supplemental Feeding",?28,"Cost    Qty   Total     Qty   Total     Qty   Total",! Q
KIL	K ^TMP($J) G KILL^XUSCLEAN
