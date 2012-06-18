SROUTRN ;B'HAM ISC/MAM - UNTRANSCRIBE DICTATION ; [ 09/22/98  11:36 AM ]
 ;;3.0; Surgery ;**77,50**;24 Jun 93
PRINT ; print untranscribed cases
 I $Y+6>IOSL D PG Q:SRQ  D HDR Q:SRQ
 W !,K S DFN=$P(^SRF(K,0),"^") D DEM^VADPT S SRNM=VADM(1) W ?8,SRNM S Y=$S($D(^SRF(K,31)):$P(^(31),"^",6),1:"") S:Y="" SRDDATE="NOT ENTERED" I Y D D^DIQ S SRDDATE=Y
 S SR(.1)=$G(^SRF(K,.1)) I SRT>1 S SRSUR=$S($P(SR(.1),"^",4)]"":$P(^VA(200,$P(SR(.1),"^",4),0),"^"),1:"NOT ENTERED") W ?45,SRSUR
 I SRT=1 S SRSS=$P(^SRF(K,0),"^",4) S:SRSS="" SRSS="NOT ENTERED" I SRSS S SRSS=$P(^SRO(137.45,SRSS,0),"^"),SRSS=$P(SRSS,"(") W ?45,SRSS
 K A S Y=$P(^SRF(K,0),"^",9) D D^DIQ S SRSDATE=$P(Y,"@")_" "_$P(Y,"@",2)
OPS S SROPER=$P(^SRF(K,"OP"),"^"),OPER=0 F MM=0:0 S OPER=$O(^SRF(K,13,OPER)) Q:OPER=""  S SROPER=SROPER_", "_$P(^SRF(K,13,OPER,0),"^")
 K SROPS,MM,MMM S:$L(SROPER)<70 SROPS(1)=SROPER I $L(SROPER)>69 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W !,?8,VA("PID"),?45,SRDDATE,!,?8,SRSDATE,!,?8,SROPS(1) I $D(SROPS(2)) W !,?8,SROPS(2) I $D(SROPS(3)) W !,?8,SROPS(3) I $D(SROPS(4)) W !,?8,SROPS(4)
 W !
 Q
HDR ; print heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRQ=1 Q
 S SRZ=1 W:$Y @IOF W !,?8,"UNTRANSCRIBED CASES" W:SRHD'="" " FOR "_SRHD W !!,"CASE #",?8,"PATIENT" W:SRT=1 ?45,"SURGICAL SPECIALTY" W:SRT>1 ?45,"SURGEON"
 W !,?8,"ID #",?45,"DATE/TIME OF DICTATION",!,?8,"DATE OF OPERATION",! F LINE=1:1:80 W "="
 Q
S1 ;
 S NON=$P($G(^SRF(I,"NON")),"^") I NON="Y" Q
 S SR(.1)=$G(^SRF(I,.1)),SURG=$P(SR(.1),"^",4) I SRT=1,SURG="" Q
 S SRSER(1)=$S($P(^SRF(I,0),"^",4)'="":$P(^SRO(137.45,$P(^SRF(I,0),"^",4),0),"^"),1:"UNKNOWN")
 S ^TMP("SR",$J,$S(SRT=1:$P(^VA(200,$P(SR(.1),"^",4),0),"^"),SRT=3:SRD,1:SRSER(1)),I)="",CNT=CNT+1
 Q
SET ; set up ^TMP("SR",$J
 S (CNT,I)=0
 I SRT'=3 F  S I=$O(^SRF("ADIC",I)) Q:'I  I $$DIV^SROUTL0(I) S SRD=$E($P(^SRF(I,0),"^",9),1,7) I SRD'<SRSD,(SRD'>SRED) D:SRA="A" S1 I SRA'="A" S SRP=$S(SRT=1:$P(^SRF(I,.1),"^",4),1:$P(^SRF(I,0),"^",4)) I SRP=SRS D S1
 I SRT=3 F  S I=$O(^SRF("ADIC",I)) Q:'I  I $$DIV^SROUTL0(I) S SRD=$E($P(^SRF(I,0),"^",9),1,7) I SRD'<SRSD,(SRD'>SRED) D S1
 Q
PG Q:'SRZ  I $E(IOST)'="P" W !!,"Press RETURN to continue, '^' to quit   " R Z:DTIME S:'$T Z="^" I Z["^" S SRQ=1
 Q
OTHER ; other operations
 S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,OPER,0),"^"))>250 S SRLONG=0,OPER=999,SROPERS=" ..."
 I SRLONG S SROPERS=$P(^SRF(SRTN,13,OPER,0),"^")
 S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
 Q
LOOP ; break procedure if greater than 70 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<70  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
SRHD S Y=SRI D D^DIQ S SRHD=Y
 Q
ASK S SRS="" I $E(SRT)'=3 W !!,"List Cases for which ",$S(SRT=1:"Surgeon",1:"Service")," ?  ALL//  " R X:DTIME G:'$T!(X["^") END S:X="" X="A" S SRA=X
 I $E(SRT)'=3,X'="A" S DIC=$S(SRT=1:200,1:137.45),DIC(0)="EMQZ" D ^DIC G:Y'>0 ASK S SRU=$P(Y(0),"^"),SRS=$P(Y,"^")
DATE D DATE^SROUTL(.SRSD,.SRED,.SRQ) G:SRQ END
 S:'$D(SRA) SRA="A"
 W ! K %ZIS,IOP,POP S %ZIS("A")="Print the Report on which Device: ",%ZIS="Q" D ^%ZIS G:POP END
 I $D(IO("Q")) K IO("Q") S ZTDESC="UNTRANSCRIBED SURGEON'S DICTATIONS",ZTRTN="EN1^SROUTRN",(ZTSAVE("SRSD"),ZTSAVE("SRED"),ZTSAVE("SRA"),ZTSAVE("SRS"),ZTSAVE("SRT"),ZTSAVE("SRSITE*"))="" D ^%ZTLOAD G END
EN1 ; entry for queuing
 U IO K ^TMP("SR",$J) D SET S (SRI,SRQ,SRZ)=0
 F  S SRI=$O(^TMP("SR",$J,SRI)) Q:SRI=""!SRQ  D PG Q:SRQ  S:'SRI SRHD=SRI D:SRI SRHD D HDR Q:SRI=""!SRQ  S K=0 F  S K=$O(^TMP("SR",$J,SRI,K)) Q:K=""!SRQ  D PRINT
 I '$D(^TMP("SR",$J)) S SRHD=$S(SRT=1&(SRA'="A"):$P(^VA(200,SRS,0),"^"),SRT=2&(SRA'="A"):$P(^SRO(137.45,SRS,0),"^"),1:"") D HDR W $$NODATA^SROUTL0()
 I 'SRQ,$E(IOST)'="P" W !!,"Press RETURN to continue " R X:DTIME
 W:$E(IOST)="P" @IOF I $D(ZTQUEUED) K ^TMP("SR",$J) Q:$G(ZTSTOP)  S ZTREQ="@" Q
END D ^SRSKILL K SRTN D ^%ZISC W @IOF
 Q
