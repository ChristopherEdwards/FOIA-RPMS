SRSTR ;B'HAM ISC/MAM - BATCH TRANSCRIPTION ROUTINE; 4 Jan 1989  7:36 AM
 ;;3.0; Surgery ;**48**;24 Jun 93
PRER ; print error log
 S SRSDUZ=DUZ D USER
 K IOP,%ZIS,IO("Q"),POP S %ZIS="Q",%ZIS("A")="Print to device: " D ^%ZIS G:POP END
 I $D(IO("Q")) S ZTDESC="PRINT DICTATION ERROR LOG",ZTRTN="ERRLOG^SRSTR",ZTSAVE("SRTDFN")=SRTDFN D ^%ZTLOAD G END
ERRLOG ;
 U IO S SRSOUT=0 W:$Y @IOF W !,?24,"List of Unmerged Operation Notes",!!,"Case #",?9,"Patient (ID #)",?58,"Date of Operation",!,?9,"Procedure",! F LINE=1:1:80 W "="
 I $O(^SRT(SRTDFN,"ER",0))="" W !,"The error log is empty. " G END
 S T=0 F  S T=$O(^SRT(SRTDFN,"ER",T)) Q:T=""  D CASE
 G END
CASE ;
 S DFN=$P($G(^SRF(T,0)),"^") I DFN D DEM^VADPT S SRNM=VADM(1)
 W !,T,?9,$S(DFN:SRNM_" ("_VA("PID")_")",1:">> CASE DOES NOT EXIST <<")
 I DFN S Y=$E($P(^SRF(T,0),"^",9),1,7) D D^DIQ W ?58,Y S SRSOP=$P(^SRF(T,"OP"),"^") D OPS
 W ! F LINE=1:1:80 W "-"
 Q
OPS K SROPS,MM,MMM S:$L(SRSOP)<65 SROPS(1)=SRSOP I $L(SRSOP)>64 S SRSOP=SRSOP_"  " F M=1:1 D LOOP Q:MMM=""
 W !,?9,SROPS(1) I $D(SROPS(2)) W !,?9,SROPS(2) I $D(SROPS(3)) W !,?9,SROPS(3)
 Q
END I $E(IOST)'="P" W !!,"Press RETURN to continue  " R X:DTIME
 W:$E(IOST)="P" @IOF I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 D ^%ZISC W @IOF D:'$D(SRQ) ^SRSKILL
 Q
PRQU ; list op reports in queue
 S SRSDUZ=DUZ D USER I '$O(^SRT(SRTDFN,"Q",0)) W !!,"The print queue is empty.",! G END
 W !! K IOP,%ZIS,POP,IO("Q") S %ZIS="Q",%ZIS("A")="Print queue information to which Device ? " D ^%ZIS G:POP END
 I $D(IO("Q")) S ZTDESC="LIST OF OP REPORTS IN QUEUE",ZTRTN="QUE^SRSTR",ZTSAVE("SRTDFN")=SRTDFN D ^%ZTLOAD G END
QUE ; entry when queued
 U IO S SRSOUT=0 W:$Y @IOF W !,?26,"Transcribed Operation Notes",!!,"Case #",?9,"Patient (ID #)",?49,"Number",?59,"Date of",?70,"Last Date",!,?48,"of Lines",?58,"Procedure",?71,"Printed"
 W ! F X=1:1:80 W "-"
 F T=0:0 S T=$O(^SRT(SRTDFN,"Q",T)) Q:'T  W !,T S DFN=$P(^SRF(T,0),"^") D PAT W ?9,SRNM_" ("_VA("PID")_")",?50,$J(+$P(^SRT(SRTDFN,"Q",T,0),"^",3),3) D MORE
 D END
 Q
PAT ; get patient name and ID
 D DEM^VADPT S SRNM=VADM(1) I $L(SRNM)>24 S SRNM=$P(VADM(1),",")_","_$E($P(VADM(1),",",2))_"."
 Q
LOOP ; break procedure if greater than 65 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SRSOP," "),MMM=$P(SRSOP," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<65  S SROPS(M)=SROPS(M)_MM_" ",SRSOP=MMM
 Q
USER ; check for user in SURGERY TRANSCRIPTION file (136)
 S SRUSER=$O(^SRT("B",SRSDUZ,0)) I 'SRUSER K DA,DIC,DD,DO,DINUM S X=SRSDUZ,DIC="^SRT(",DIC(0)="L",DLAYGO=136 D FILE^DICN K DIC,DLAYGO S SRUSER=DA
 S SRTDFN=SRUSER
 Q
MORE ;
 S SRSDT=$P(^SRF(T,0),"^",9),SRSDT1=$P(^SRT(SRTDFN,"Q",T,0),"^",2),SRSDT=$E(SRSDT,4,5)_"/"_$E(SRSDT,6,7)_"/"_$E(SRSDT,2,3) I SRSDT1 S SRSDT1=$E(SRSDT1,4,5)_"/"_$E(SRSDT1,6,7)_"/"_$E(SRSDT1,2,3)
 W ?59,SRSDT,?71,SRSDT1
 Q
