ABPALBII ;PRINT INSURER MAILING LABELS (IND.); [ 04/16/91  3:17 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
A0 G ABORT
 ;
A1 D DT^DICRW K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="PRINT Claim Mailing LABELS (individual)" D ^ABPAHD
 ;
A2 K DIC,DIE,DA,DR S DIC="^AUTNINS(",DIC(0)="AEQZ" W !!! D ^DIC
 G:+Y<0 END S ABPADFN=+Y,NAME=Y(0,0)
 ;
A3 S %ZIS("A")="Select LABEL PRINTER DEVICE: ",%IS="P" W ! D ^%ZIS
 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 K %ZIS("A"),%IS G:+IO=0 A2
 U IO(0) W !!,"Please make sure labels have been put into the printer."
 U IO(0) W !,"Press [RETURN] when you are ready... " R X:DTIME
 G:'$T A5 U IO(0) W !!
 ;
A4 S FLBL="" D
 .K ADDR,CITY,STATE,ZIP,DATA
 .S R=ABPADFN
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
 ..U IO W NAME
 ..U IO W !,ADDR,!,CITY,", ",STATE,"  ",ZIP
 ..U IO W !!!!
 ;
A5 H 2 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 X ^%ZIS("C") K IOP,IO("S") U IO(0) W !!
 ;
END K X,Y,DIC,DIE,DA,DR,NAME,ADDR,CITY,STATE,ZIP,FLBL,ABPADFN,LOCCD,DATA
 K ABPAMLDT,I,J,K
 Q
 ;
ABORT W !!,"ACCESS DENIED!!!" Q
