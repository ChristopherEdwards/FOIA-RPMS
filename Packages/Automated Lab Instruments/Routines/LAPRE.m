LAPRE ; IHS/DIR/FJE - AUTO INSTRUMENTS PRE INIT 11:15 ; [ 5/10/90 ]
 ;;5.2;LA;;NOV 01, 1997
 ;;5.1;LAB;;04/11/91 11:06
EN ;
 S U="^" I $S('$D(DUZ):1,'$D(^DIC(3,+DUZ)):1,'$D(IO):1,1:0) G DUZ
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) G DUZ0
 I DUZ(0)'="@" G DUZ0
BEGIN D ASK
END K DA,I,% G SET
 Q
ASK F I=0:0 W !,"Do you wish to clear out and replace inactive auto instrument entries" S %=1 D YN^DICN Q:%  D INFO
 Q:%'=1
K S DIK="^LAB(62.4," F DA=99:0 S DA=$O(^LAB(62.4,DA)) Q:DA'>99  D ^DIK
 Q
INFO W !!,"Answering YES will remove all auto instrument entries >99.",!,"This will not effect entries 1-99 (entries for on-line instruments).",!
 Q
SET S:'$D(DTIME) DTIME=300 S U="^",%DT="T",X="NOW" D ^%DT S DT=$P(Y,".") D HOME^%ZIS
 W !,"THIS PRE INIT WILL REMOVE THE AUTOINSTRUMENT DD NODES AND REBUILD THEM.",!,"WE WILL ALSO BE REMOVING THE MICRO AUTOINSTRUMENT ORGANISM CROSS REFERENCES.",!
 W !!,"DO YOU WANT TO CONTINUE " S %=2 D YN^DICN I %'=1 K DIFQ Q
1 ;
 W !!!,"I WILL NOW REMOVE THE FILE 62.4 (AUTOINSTRUMENT) DD ENTRIES.  THEY WILL BE",!,"REBUILT WHEN THE INIT RUNS.",!!
 S DIU=62.4,DIU(0)="" D EN^DIU2
2 W !!!,"WE WILL NOW REMOVE THE MICRO INSTRUMENT ORGANISM CROSS REFERENCES.  THEY",!,"WILL BE REBUILT IN THE POST INIT.",!!
 S II=0 F JJ=0:0 S II=$O(^LAB(62.4,II)) Q:II<1  I $D(^LAB(62.4,II,7)) S KK=0 F JJ=0:0 S KK=$O(^LAB(62.4,II,7,KK)) Q:KK<1  K ^LAB(62.4,II,7,KK,1,"B"),^("C"),^("D")
 K ^LAB(69.91) S ^LAB(69.91,0)="LR ROUTINE INTEGRITY CHECKER^69.91I^0^0"
 W !,"PRE INIT CONCLUDED.  MOVING TO INITS.",!!
 Q
DUZ W !!?10,"Please log in using access and verify codes",!!,*7 K DIFQ Q
DUZ0 W !!?10,"You do not have programmer access in your fileman access code",!!,*7 K DIFQ Q
 Q
