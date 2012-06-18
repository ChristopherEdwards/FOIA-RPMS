FHORX1 ; HISC/REL - Diet Activity Report ;9/10/98  15:31
 ;;5.0;Dietetics;**19,21,39**;Oct 11, 1995
 D NOW^%DTC S NOW=%,FHP=$O(^FH(119.73,0)) I FHP'<1,$O(^FH(119.73,FHP))<1 G R1
R0 R !!,"Select COMMUNICATION OFFICE: ",X:DTIME G:'$T!("^"[X) KIL
 K DIC S DIC="^FH(119.73,",DIC(0)="EMQ" D ^DIC G:Y<1 R0 S FHP=+Y
R1 R !!,"Do you want labels? N// ",X:DTIME G:'$T!(X["^") KIL S:X="" X="N" D TR^FH I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7,"  Enter YES or NO" G R1
 S LAB=X?1"Y".E,TIM=$P($G(^FH(119.73,FHP,0)),"^",$S(LAB:3,1:2)) I 'TIM S TIM=NOW
 S FHLBFLG=1 I LAB D  I FHLBFLG=0 Q
 .W ! K DIR,LABSTART S DIR(0)="NA^1:10",DIR("A")="If using laser label sheets, what row do you want to begin printing at? ",DIR("B")=1 D ^DIR
 .I $D(DIRUT) S FHLBFLG=0 Q
 .S LABSTART=Y Q
 S DTP=TIM D DTP^FH
R3 W !!,"Changes since Date/Time: ",DTP," // " R X:DTIME G:'$T!(X["^") KIL I X'="" S %DT="EXTS" D ^%DT K %DT G:Y<1 R3 S TIM=Y
 W ! K IOP,%ZIS S %ZIS("A")="Select "_$S(LAB:"LABEL",1:"LIST")_" Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHORX1",FHLST="TIM^LAB^FHP^LABSTART" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Print the Diet Activity Report
 K ^TMP($J) D NOW^%DTC S NOW=%,DTP=TIM,TIM=TIM-.000001 D DTP^FH S H1=DTP_" - " S DTP=NOW D DTP^FH S H1=H1_DTP D ^FHDEV
 F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  D WRD
 I LAB S LAB=$P($G(^FH(119.9,1,"D",IOS,0)),"^",2) S:'LAB LAB=1
 F LLL=TIM:0 S LLL=$O(^FH(119.8,"AD",LLL)) Q:LLL<1  F DA=0:0 S DA=$O(^FH(119.8,"AD",LLL,DA)) Q:DA<1  D Q3
 G ^FHORX1A:'LAB,^FHORX1B
WRD S P0=$G(^FH(119.6,W1,0)),WRDN=$P(P0,"^",1),D2=$P(P0,"^",8),P0=$P(P0,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
 I D2=FHP S ^TMP($J,"W",W1)=P0_"~"_WRDN
 Q
Q3 S Z=$G(^FH(119.8,DA,0)) Q:Z=""  S TM1=($P(Z,"^",2)\1),DFN=$P(Z,"^",3),ADM=$P(Z,"^",4) Q:'$D(^FHPT(DFN,"A",ADM,0))
 S WARD=$G(^DPT(DFN,.1)) G:WARD="" Q5 ; Not an inpatient
 I $G(^DPT("CN",WARD,DFN))'=ADM Q  ; Not current admission
 S X0=^FHPT(DFN,"A",ADM,0),W1=+$P(X0,"^",8) I '$D(^TMP($J,"W",W1)) Q  ; Not in this Comm Office
 S R1=$G(^DPT(DFN,.101))
 S RI=$G(^DPT(DFN,.108)) S RE=$S(RI:$O(^FH(119.6,"AR",+RI,W1,0)),1:"")
 S R0=$S(RE:$P($G(^FH(119.6,W1,"R",+RE,0)),"^",2),1:"")
 S R0=$S(R0<1:99,R0<10:"0"_R0,1:R0)
 S ^TMP($J,"P",^TMP($J,"W",W1)_"~"_R0_"~"_R1_"~"_DFN,DA)=$P(Z,"^",4,9) Q
Q5 ; process discharges
 S W1=+$P(Z,"^",8) Q:'W1  Q:'$D(^TMP($J,"W",W1))
 S ^TMP($J,"P",^TMP($J,"W",W1)_"~~***~"_DFN,DA)=$P(Z,"^",4,9)
 Q
KIL K ^TMP($J) G KILL^XUSCLEAN
