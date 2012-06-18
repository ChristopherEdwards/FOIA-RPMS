FHNO2 ; HISC/REL/NCA - Supplemental Feeding Labels ;8/26/94  12:01 
 ;;5.0;Dietetics;**38,39**;Oct 11, 1995
D0 R !!,"Select by S=SUPPLEMENTAL FEEDING SITE or W=WARD: ",XX:DTIME G:'$T!("^"[XX) KIL I "sw"[XX S X=XX D TR^FH S XX=X
 I XX'?1U!("SW"'[XX) W *7," Enter S or W" G D0
 I XX="S" S D1=$O(^FH(119.74,0)) I D1'<1,$O(^FH(119.74,D1))<1 G D3
 I XX="W" S WRD=$O(^FH(119.6,0)) I WRD'<1,$O(^FH(119.6,WRD))<1 G D3
 I XX="S" G D2
D1 R !!,"Select WARD: ",X:DTIME G:'$T!("^"[X) KIL
 K DIC S DIC="^FH(119.6,",DIC(0)="EMQ" D ^DIC G:Y<1 D1 S W1=+Y
 S D1=$P($G(^FH(119.6,W1,0)),"^",9) G D3
D2 R !!,"Select SUPPLEMENTAL FEEDING SITE: ",X:DTIME G:'$T!("^"[X) KIL
 K DIC S DIC="^FH(119.74,",DIC(0)="EMQ" D ^DIC G:Y<1 D2 S D1=+Y,W1=0
D3 R !!,"Select Supplemental Feeding Time (10,2,8,ALL): ",TIM:DTIME G KIL:'$T!(U[TIM) I TIM="all" S X=TIM D TR^FH S TIM=X
 I TIM'=2,TIM'=8,TIM'=10,TIM'="ALL" W *7," Enter a time, 10,2,8, or ALL" G D3
 W ! K DIR,LABSTART S DIR(0)="NA^1:10",DIR("A")="If using laser label sheets, what row do you want to begin printing at? ",DIR("B")=1 D ^DIR
 Q:$D(DIRUT)  S LABSTART=Y
D4 R !!,"Do you want Ingredient list only? N// ",D3:DTIME G:'$T!(D3="^") KIL S:D3="" D3="N" S X=D3 D TR^FH S D3=X I $P("YES",D3,1)'="",$P("NO",D3,1)'="" W *7,"  Answer YES or NO" G D4
 S D3=$E(D3,1),D3=D3="Y" G:'D3 D6
D5 R !!,"Consolidated List only? Y// ",X:DTIME G:'$T!(X="^") KIL S:X="" X="Y" D TR^FH I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7,"  Answer YES or NO" G D5
 S X=$E(X,1) S:X="Y" D3=D3+1
D6 I 'D3,'D1,XX="W" W !!,"No Supplemental Feeding Site associated with this ward." G KIL
 W:'D3 !!,"Place Labels in Printer"
PR K IOP S %ZIS="MQ",%ZIS("A")="Select "_$S('D3:"LABEL",1:"LIST")_" Printer: " W ! D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHNO2",FHLST="XX^TIM^W1^D1^D3^LABSTART" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Process Printing Supplemental Feeding Labels
 D NOW^%DTC S NOW=%,DT=%\1 G:D3=2 SUM
 I 'D3 Q:'D1  S FHPAR=$G(^FH(119.74,D1,0)),LAB=$P($G(^FH(119.9,1,"D",IOS,0)),"^",2) S:'LAB LAB=1
 S COUNT=0,LINE=1 I TIM="ALL" S TIM=10 D Q2 S TIM=2 D Q2 S TIM=8
 D Q2
 I $G(LAB)>2 D DPLL^FHLABEL,KIL Q
 I 'D3 F L=1:1:18 W !
KIL K ^TMP($J) G KILL^XUSCLEAN
Q2 K ^TMP($J,"L"),^TMP($J,"I"),^TMP($J,"SF"),C S P1=$S(TIM=10:5,TIM=2:13,1:21),T0=$P(DT,".",1)_"."_$S(TIM=10:1,TIM=2:14,1:2),P3=7,N1=0
 I XX="W" S P0=$P($G(^FH(119.6,W1,0)),"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0) D F0
 I XX="S" F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  S X=^(W1,0),D2=$P(X,"^",9) I D1=D2 S P0=$P(X,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0) D F0
 G ^FHNO21:'D3,PRT
F0 S WRDN=$P(^FH(119.6,W1,0),"^",1),DFN=0
F1 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN=""  S ADM=^(DFN) G:ADM<1 F1
 G:'$D(^FHPT(DFN,"A",ADM,0)) F1 S X1=^(0),NO=$P(X1,"^",7) G:'NO F1
 I 'D3 S IS=$P(X1,"^",10) I IS S IS=$P($G(^FH(119.4,IS,0)),"^",3) S:IS'="N" IS=""
 D CHK G:'NO F1
 S Y=$G(^FHPT(DFN,"A",ADM,"SF",NO,0))
 S Y=$P(Y,"^",P1,P1+7) G:Y?."^" F1 D:D3 CALC
 I 'D3 D
 .S $P(Y,"^",9)=IS
 .S LNOD=$S(XX="S":D2_"~"_$P($G(^FH(119.74,D2,0)),"^",1),1:P0_"~"_WRDN)
 .S RI=$G(^DPT(DFN,.108)) S RE=$S(RI:$O(^FH(119.6,"AR",+RI,W1,0)),1:"")
 .S R0=$S(RE:$P($G(^FH(119.6,W1,"R",+RE,0)),"^",2),1:"")
 .S R0=$S(R0<1:99,R0<10:"0"_R0,1:R0)
 .S RM=$G(^DPT(DFN,.101)),PNOD=P0_"~"_R0_RM_"~"_DFN,WRD=P0_$E(WRDN,1,27-$L(RM))_"/"_RM
 .S ^TMP($J,"L",LNOD,PNOD)=Y_"^"_WRD Q
 G F1
CHK S FHORD=$P(X1,"^",2),X1=$P(X1,"^",3) G:FHORD<1 C1
 I X1>1,X1'>T0 G C2
C0 I '$D(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) G C2
 S X1=$P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",7) I X1'="",X1'="X" S NO=""
C1 K FHORD,A1,K,X1 Q
C2 S A1=0 F K=0:0 S K=$O(^FHPT(DFN,"A",ADM,"AC",K)) Q:K<1!(K>T0)  S A1=K
 G:'A1 C1 S FHORD=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2) G:FHORD'<1 C0 K ^FHPT(DFN,"A",ADM,"AC",A1) G C2
SUM K C,^TMP($J,"SF") S P0=$S(TIM=2:13,TIM=8:21,1:5),P3=$S(TIM="ALL":23,1:7),N1=0
 I XX="W" S X=$G(^FH(119.6,W1,0)) D S0
 I XX="S" F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  S X=^(W1,0),D2=$P(X,"^",9) I D1=D2 D S0
 G PRT
S0 S WRDN=$P(^FH(119.6,W1,0),"^",1),DFN=0
S1 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN=""  S ADM=^(DFN) G:ADM<1 S1
 G:'$D(^FHPT(DFN,"A",ADM,0)) S1 S X1=^(0),NO=$P(X1,"^",7) G:'NO S1
 S Y=$P(^FHPT(DFN,"A",ADM,"SF",NO,0),"^",P0,P0+P3) G:Y?."^" S1 D CALC
 G S1
PRT S DTP=DT D DTP^FH S DTE=DTP_" "_$S(TIM="ALL":"ALL",TIM=10:TIM_" AM",1:TIM_" PM")
 S Y=$S(XX="S":$P($G(^FH(119.74,D1,0)),"^",1),1:WRDN)
 W @IOF W:D3=2 !?5,"**** CONSOLIDATED ****" W !?3,"**** INGREDIENTS LIST ****",! W:D3=1 ! W ?(33-$L(Y)\2),Y,!?9,DTE,!!
 F L=0:0 S L=$O(^FH(118,L)) Q:L<1  S:$D(C(L)) ^TMP($J,"SF",$P($G(^FH(118,L,0)),"^",1),L)=""
 S A1="" F  S A1=$O(^TMP($J,"SF",A1)) Q:A1=""  F L=0:0 S L=$O(^TMP($J,"SF",A1,L)) Q:L<1  W !,$E(A1,1,26),?28,$J(C(L),5,0)
 W !!?4,"**** PATIENTS = ",N1," ****",! Q
CALC S N1=N1+1
 F L=1:2:P3 S Z=$P(Y,"^",L) I Z'="" S Q=$P(Y,"^",L+1) S:'Q Q=1 S:'$D(C(Z)) C(Z)=0 S C(Z)=C(Z)+Q
 Q
