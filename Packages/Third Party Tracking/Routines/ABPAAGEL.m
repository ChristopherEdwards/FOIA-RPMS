ABPAAGEL ;PRINT MAILING LABELS FOR OUTSTANDING BILLS; [ 07/25/91  11:10 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"<<< SORRY, ACCESS DENIED!!! >>>",!! G ZTLEND
 ;--------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="Print MAILING LABELS for outstanding bills" D ^ABPAHD
 Q
 ;--------------------------------------------------------------------
TASK K DIR S DIR(0)="NO",DIR("A")="Select REPORT TASK NUMBER" W !! D ^DIR
 K ZTSK I Y S ZTSK=+Y
 E  D  Q
 .K ABPAMESS S ABPAMESS="NO TASK SELECTED - JOB ABORTED"
 .S ABPAMESS(2)="... Press any key to continue ..." D PAUSE^ABPAMAIN
 I $D(^%ZTSK(ZTSK,0))'=11 W *7,!?5,"<<< TASK NOT FOUND >>>" G TASK
 S ZTRTN=$P(^%ZTSK(ZTSK,0),"^",1,2) I ZTRTN'="MAIN^ABPAAGE2" D  G TASK
 .W *7,!?5,"<<< INVALID TASK NUMBER >>>"
 I $D(^%ZTSK(ZTSK,0,"ZTN"))'=1 D  G TASK
 .W *7,!?5,"<<< MISSING NODE FROM THE TASK FILE >>>"
 S ZTSK=+^%ZTSK(ZTSK,0,"ZTN") I $D(^%ZTSK(ZTSK,"INSURER"))'=10 D  G TASK
 .W *7,!?5,"<<< MISSING NODE FROM THE TASK FILE >>>"
 Q
 ;--------------------------------------------------------------------
DEVICE S %ZIS("A")="Select LABEL PRINTER DEVICE: ",%IS="P" W ! D ^%ZIS
 Q:POP  I $E(IOST)'="P" D  G DEVICE
 .W *7,!?5,"<<< PLEASE SELECT A PRINTING DEVICE OR ""^"" TO EXIT >>>"
 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 U IO(0) W !!,"Please make sure labels have been put into the printer."
 U IO(0) W !,"Press [RETURN] when you are ready... " R X:DTIME
 S ABPA("IO")=IO K %ZIS("A"),%IS U IO(0) W !!
 Q
 ;--------------------------------------------------------------------
PRINT S FLBL="",NAME=0 F ABPAI=0:0 D  Q:NAME=""
 .S NAME=$O(^%ZTSK(ZTSK,"INSURER",NAME)) Q:NAME=""
 .S ABPADFN=0 F ABPAJ=0:0 D  Q:+ABPADFN=0
 ..S ABPADFN=$O(^%ZTSK(ZTSK,"INSURER",NAME,ABPADFN)) Q:+ABPADFN=0
 ..K ADDR,CITY,STATE,ZIP,DATA
 ..S R=ABPADFN S DATA=^AUTNINS(R,0)
 ..S ADDR=$P(DATA,"^",2),CITY=$P(DATA,"^",3),STATE="",PTR=$P(DATA,"^",4)
 ..I +PTR>0 I $D(^DIC(5,PTR,0))=1 S STATE=$P(^DIC(5,PTR,0),"^",2)
 ..S ZIP=$P(DATA,"^",5) I $D(FLBL)=1 D
 ...F J=0:0 D  Q:$D(FLBL)'=1
 ....I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),10) H 2
 ....F K=1:1:2 U IO W NAME,!,ADDR,!,CITY,", ",STATE,"  ",ZIP,!!!!
 ....H 2 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11) H 2
 ....U IO(0) W !!,"ARE YOUR LABELS LINED UP" S %=2 D YN^DICN
 ....U IO(0) W !!
 ....I +%'=1 D
 .....U IO(0) W "Please adjust...press [RETURN] when ready"
 .....U IO(0) R X:DTIME U IO(0) W !!
 ....I +%=1 U IO(0) D WAIT^DICD D
 .....K FLBL I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),10) H 2
 ..F J=1:1:2 U IO W NAME,!,ADDR,!,CITY,", ",STATE,"  ",ZIP,!!!!
 ..H 1
 Q
 ;--------------------------------------------------------------------
CLOSE H 2 I $D(IO("S"))=1 X ^%ZIS(2,IO("S"),11)
 X ^%ZIS("C") K IOP,IO("S") U IO(0) W !!
 Q
 ;--------------------------------------------------------------------
ZTLEND ;PROCEDURE TO KILL ALL LOCALLY USED TEMPORARY VARIABLES
 K %DT,%ZIS,%IS,ZTSK,X,Y,BDT,EDT,FAC,ZTRTN,ZTSAVE,ZTIO,ZTDESC,ABPA
 K DIC,%,IOP,I,DIR
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - THE STARTING POINT FOR ENTERING THIS PROGRAM
 D ZTLEND,HEAD,TASK I $D(ZTSK)'=1 D ZTLEND Q
 D DEVICE I $D(ABPA("IO"))'=1 D ZTLEND Q
 D PRINT,CLOSE,ZTLEND
 Q
