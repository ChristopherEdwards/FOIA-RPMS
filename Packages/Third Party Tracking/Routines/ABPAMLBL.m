ABPAMLBL ;PRINT INSURER MAILING LABELS (BATCH); [ 07/03/91  7:50 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
A0 G ABORT
 ;
A1 D DT^DICRW K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="PRINT Claim Mailing LABELS (batch)" D ^ABPAHD
 ;
A2 K DIC,DIE,DA,DR S DIC="^ABPAMLBL(",DIC(0)="AEQZ"
 S DIC("A")="Select MAILING LABEL POSTING PERIOD // " W !!! D ^DIC
 G:+Y<0 END S ABPADFN=+Y,ABPAMLDT=Y(0,0)
 ;
A3 K DIC,DIE,DA,DR S DIC="^DIC(4,",DIC(0)="AEQZ"
 S DIC("A")="Select MAILING LABEL FACILITY // " W ! D ^DIC
 G:+Y<0 A2 S LOCCD=+Y
 I $D(^ABPAMLBL(ABPADFN,"L",LOCCD,0))'=1 D  G A3
 .W !,*7,!?3,"<<< NO LABELS FOUND FOR '",Y(0,0)
 .W "' DURING ",ABPAMLDT," >>>"
 ;
A4 S %ZIS("A")="Select LABEL PRINTER DEVICE: ",%IS="P" W ! D ^%ZIS
 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 K %ZIS("A"),%IS G:+IO=0 A3
 U IO(0) W !!,"Please make sure labels have been put into the printer."
 U IO(0) W !,"Press [RETURN] when you are ready... " R X:DTIME
 G:'$T A6 U IO(0) W !!
 ;
A5 S FLBL="" S RR=0 F I=1:1 D  Q:RR=""
 .K NAME,ADDR,CITY,STATE,ZIP,DATA
 .S RR=$O(^ABPAMLBL(ABPADFN,"L",LOCCD,"I","AC",RR)) Q:RR=""  S R=0
 .S R=$O(^ABPAMLBL(ABPADFN,"L",LOCCD,"I","AC",RR,R)) Q:+R=0
 .Q:$D(^ABPAMLBL(ABPADFN,"L",LOCCD,"I",R,0))'=1
 .Q:$D(^AUTNINS(R,0))'=1
 .S NAME=$P(^AUTNINS(R,0),"^")
 .I $D(^AUTNINS(R,1))=1 I $L($P(^AUTNINS(R,1),"^"))>3 D
 ..S DATA=^AUTNINS(R,1)
 .I $D(^AUTNINS(R,1))=1 I $L($P(^AUTNINS(R,1),"^"))'>3 D
 ..S DATA=^AUTNINS(R,0)
 .I $D(^AUTNINS(R,1))'=1 S DATA=^AUTNINS(R,0)
 .S NAME(1)=$P(DATA,"^"),ADDR=$P(DATA,"^",2),CITY=$P(DATA,"^",3)
 .S STATE="",PTR=$P(DATA,"^",4)
 .I +PTR>0 I $D(^DIC(5,PTR,0))=1 D
 ..S STATE=$P(^DIC(5,PTR,0),"^",2)
 .S ZIP=$P(DATA,"^",5)
 .S:NAME(1)'=NAME NAME=NAME(1) K NAME(1)
 .I $D(FLBL)=1 D
 ..F J=0:0 D  Q:$D(FLBL)'=1
 ...I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),10) H 2
 ...F K=1:1:2 D
 ....U IO W NAME
 ....U IO W !,ADDR,!,CITY,", ",STATE,"  ",ZIP
 ....U IO W !!!!
 ...H 2 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11) H 2
 ...U IO(0) W !!,"ARE YOUR LABELS LINED UP" S %=2 D YN^DICN
 ...U IO(0) W !!
 ...I +%'=1 D
 ....U IO(0) W "Please adjust...press [RETURN] when ready"
 ....U IO(0) R X:DTIME U IO(0) W !!
 ...I +%=1 D
 ....K FLBL I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),10) H 2
 .F J=1:1:2 D
 ..U IO W NAME,!,ADDR,!,CITY,", ",STATE,"  ",ZIP,!!!!
 .H 1
 ;
A6 H 2 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 X ^%ZIS("C") K IOP,IO("S") U IO(0) W !!
 ;
END K X,Y,DIC,DIE,DA,DR,NAME,ADDR,CITY,STATE,ZIP,FLBL,ABPADFN,LOCCD,DATA
 K ABPAMLDT,I,J,K
 Q
 ;
ABORT W !!,"ACCESS DENIED!!!" Q
