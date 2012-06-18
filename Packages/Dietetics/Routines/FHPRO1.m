FHPRO1	; HISC/REL - Production Processing ;3/6/95  15:45
	;;5.0;Dietetics;;Oct 11, 1995
	S FHP=$O(^FH(119.71,0)) I FHP'<1,$O(^FH(119.71,FHP))<1 G F1
F0	R !!,"Select PRODUCTION FACILITY: ",X:DTIME G:'$T!("^"[X) KIL
	K DIC S DIC="^FH(119.71,",DIC(0)="EMQ" D ^DIC G:Y<1 F0 S FHP=+Y
F1	S %DT("A")="Select Date: ",%DT="AEX" W ! D ^%DT G KIL:"^"[X!$D(DTOUT),F1:Y<1 S (X1,D1)=+Y
	D E1^FHPRC1 I FHCY<1 W *7,!!,"No MENU CYCLE Defined for that Date!" G F1
	I '$D(^FH(116,FHCY,"DA",FHDA,0)) W *7,!!,"MENU CYCLE DAY Not Defined for that Date!" G F1
R1	R !!,"Select MEAL (B,N,E or ALL): ",MEAL:DTIME G:'$T!("^"[MEAL) KIL S X=MEAL D TR^FH S MEAL=X S:$P("ALL",MEAL,1)="" MEAL="A"
	I "BNEA"'[MEAL!(MEAL'?1U) W *7,!,"Select B for Breakfast, N for Noon, or E for Evening or ALL for all meals" G R1
	S FHDA=^FH(116,FHCY,"DA",FHDA,0)
	I $D(^FH(116.3,D1,0)) S X=^(0) F LL=2:1:4 I $P(X,"^",LL) S $P(FHDA,"^",LL)=$P(X,"^",LL)
	I MEAL'="A" S FHX1=$P(FHDA,"^",$F("BNE",MEAL)) I 'FHX1 W *7,!!,"*** NO MENU DEFINED FOR THIS MEAL ***" G KIL
R2	R !!,"Do you want PRODUCTION Summary? (Y/N): ",FHP1:DTIME G:'$T!("^"[FHP1) KIL S X=FHP1 D TR^FH S FHP1=X I $P("YES",FHP1,1)'="",$P("NO",FHP1,1)'="" W *7,"  Enter YES or NO" G R2
	S FHP1=$E(FHP1,1)
R3	R !!,"Do you want MEAL SERVICE Summary? (Y/N): ",FHP2:DTIME G:'$T!("^"[FHP2) KIL S X=FHP2 D TR^FH S FHP2=X I $P("YES",FHP2,1)'="",$P("NO",FHP2,1)'="" W *7,"  Enter YES or NO" G R3
	S FHP2=$E(FHP2,1)
R4	R !!,"Do you want RECIPE PREPARATION Sheet? (Y/N): ",FHP3:DTIME G:'$T!("^"[FHP3) KIL S X=FHP3 D TR^FH S FHP3=X I $P("YES",FHP3,1)'="",$P("NO",FHP3,1)'="" W *7,"  Enter YES or NO" G R4
	S FHP3=$E(FHP3,1)
R5	R !!,"Do you want STOREROOM REQUISITION Sheet? (Y/N): ",FHP4:DTIME G:'$T!("^"[FHP4) KIL S X=FHP4 D TR^FH S FHP4=X I $P("YES",FHP4,1)'="",$P("NO",FHP4,1)'="" W *7,"  Enter YES or NO" G R5
	S FHP4=$E(FHP4,1)
R7	R !!,"Do you want PRINTED RECIPES? (Y/N) N// ",FHP5:DTIME G:'$T!(FHP5["^") KIL S:FHP5="" FHP5="N" S X=FHP5 D TR^FH S FHP5=X I $P("YES",FHP5,1)'="",$P("NO",FHP5,1)'="" W *7,"  Enter YES or NO" G R7
	S FHP5=$E(FHP5,1)
R8	R !!,"Use CENSUS or FORECAST? (C OR F): ",FHP6:DTIME G:'$T!("^"[FHP6) KIL S X=FHP6 D TR^FH S FHP6=X I $P("CENSUS",FHP6,1)'="",$P("FORECAST",FHP6,1)'="" W *7," Enter C or F" G R8
	K M2 S FHP6=$E(FHP6,1),FHP6=$S(FHP6="C":"Census",1:"Forecast") G:FHP6["C" L0
	W !!,"Forecasting ..." D Q2^FHPRF1
	F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  D C0 G:X="^" KIL
L0	W !!,"The report requires a 132 column printer.",!
	W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="^FHPRO2",FHLST="D1^MEAL^FHDA^FHP^FHP1^FHP2^FHP3^FHP4^FHP5^FHP6^M2(" D EN2^FH G KIL
	U IO D ^FHPRO2 D ^%ZISC K %ZIS,IOP G KIL
C0	S S1=^TMP($J,P0)
	W !!?5,"Service Point: ",$P(^FH(119.72,P0,0),"^",1)
C1	W !?5,"Forecast Census: ",S1," // " R X:DTIME I '$T!(X["^") S X="^" Q
	S:X="" X=S1 I X'?1N.N!(X>9999) W *7,"  Must be a number less than 9999" G C1
	S M2(P0)=X Q
KIL	K ^TMP($J) G KILL^XUSCLEAN
