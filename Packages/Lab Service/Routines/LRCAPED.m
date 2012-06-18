LRCAPED ;SLC/DCM- MANUAL EDIT OF CAP AND WORKLOAD FILES ;8/28/89  12:07 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
EN ;
 W @IOF F I=0:0 S LRSTOP=0,LRSTOP=0,LRURG="",LRIN="" D NEW Q:LRSTOP
 K LRTDT,LRC,LRH1,LRC1,LRI,LRIN,LRTS,LRTSA,LRSB,LRM,LRCAP,LRX,LRA,LRSTOP,LRCAP,LRSTOP
 Q
NEW K DIC W ! S DIC="^LAM(",DIC(0)="AEQM" D ^DIC I Y<1 S LRSTOP=1 Q
 S (LRCAP,DA)=+Y,LRM=$P(^LAM(+Y,0),"^",8),LRSB=$P(^LAM(+Y,0),"^",9)
N W !,"Edit (S)PECIMEN COUNT, (R)EPEAT, (Q)C COUNT (X)REFERENCE OR (O)THER",!
 R ?15,"(S/R/Q/O/X): Q// ",X:DTIME S:'$T!(X="^") LRSTOP=1 Q:LRSTOP  S LRX=$S(X="":"Q",1:$E(X))
 I X="?" W !!,"Choose the type of count to be edited.",!,"SPECIMEN COUNT- the count of actual patient specimens.",!,"REPEAT COUNT- repeats done for this procedure.",!,"QC COUNT- quality control count.",!,"OTHER - referral",! G N
 I "XOQRS"'[LRX!(LRSTOP) S LRSTOP=1 W:LRX'="^" !!?10,*7," ( ",LRX," ) IS NOT A VALID RESPONSE ",! Q
TST K DIC S DIC="^LAB(60,",DIC(0)="ZAQEM" D ^DIC S:+Y<1 LRSTOP=1 Q:LRSTOP  S LRTST=$S($L($P(^(.1),U)):$P(^(.1),U),1:$E($P(Y(0),U),1,20))
 S %DT="AERT",%DT("A")="Select LAB ARRIVAL DATE/TIME: " D ^%DT I Y<1 S LRSTOP=1 Q
 S LRTIM=+Y
NUM R !,"Enter a positive or negative amount: 1// ",LRA:DTIME I '$T!(LRA="^") S LRSTOP=1 Q
 S:LRA="" LRA=1 I LRA'=+LRA!(LRA?.E1"."1N.N) W *7,"  ??",!?5,"Enter the amount to add or subtract from this CAP code.",!?5,"Entry must be a whole number." G NUM
 D S Q:LRSTOP  D ENT^LRCAPED2 K DR,DIE,DIC Q:LRSTOP  D ^LRCAPED1 K LRIN,LRURG,LRLOCAB,LRLOCTY,LRTSA,LRTS,DIC
 Q
S I "XQ"[LRX S (LRTS,LRTSA)="LAB",LRIN=0,LRURG=9,LRLOCAB="LAB" Q
 K DIC S DIC="^SC(",DIC(0)="AQEMOZ" D ^DIC I Y<1 S (LRTS,LRTSA)="LAB",LRIN=0,LRLOCTY="Z" G S1
 S LRLOC=Y(0),LRLOCAB=$S($L($P(LRLOC,"^",2)):$P(LRLOC,"^",2),1:$P(LRLOC,"^")),LRLOCTY=$P(LRLOC,U,3),LRTS=$P(LRLOC,U,20) S:LRTS LRTS=$S($L($P(^DIC(45.7,LRTS,0),U,3)):$P(^(0),U,3),1:$P(LRLOC,"^",7))
 K DIC S DIC=45.7,DIC(0)="MAQEZ",DIC("B")=LRTS D ^DIC S:Y>0 LRTS=+Y,LRTSA=$S($L($P(Y(0),U,3)):$P(Y(0),U,3),1:$E($P(Y(0),U),1,5))
S1 K DIC S LRURG=9 S:LRLOCTY="" LRLOCTY="Z" S LRIN=$S("WO"[LRLOCTY:1,1:0) I "SO"[LRX S DIC="^LAB(62.05,",DIC(0)="AEMQ" D ^DIC S LRURG=$S(Y>0:+Y,1:9) K DIC
 Q
