ABPAUPCK ;PRINT UNPROCESSED CHECKS REPORT; [ 03/23/91  12:21 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"<<< NOT AN ACCESS POINT - JOB ABORTED >>>",!! Q
 ;--------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL TEMPORARY LOCAL VARIABLES
 K L,DIC,BY,FROM,TO,X,Y,J,ABPA,R,RR,%IS,ABPAPG,AMT,CHKNO,CNT,DATA,DIR
 K FLDS,INSNAME,INSPTR,K,NEWINS,RAMT,RDT,RRR,TAMT,TRAMT,ZTDESC,ZTDTH
 K ZTIO,ZTRTN,IO("Q"),MTH,MT1,MT2,MT3,RT1,RT2,RT3
 Q
 ;--------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="Print UNPROCESSED CHECKS REPORT" D ^ABPAHD W !!
 Q
 ;--------------------------------------------------------------------
SUBHD ;PROCEDURE TO PRINT REPORT SUBHEADINGS
 W !?60,"ORIGINAL",?70,"REMAINING"
 W !,"PAYOR",?32,"RECEIVED",?48,"CHECK NO.",?62,"AMOUNT",?72,"BALANCE"
 W !,"------------------------------",?32,"--------"
 W ?42,"---------------",?59,"---------",?70,"---------",!
 Q
 ;--------------------------------------------------------------------
DEVICE ;PROCEDURE TO SELECT PRINTER DEVICE
 F J=0:0 K %IS,IOP D  Q:$D(ABPA("IO"))=1!(POP)
 .S %IS="NPQ",%IS("A")="Select DEVICE or [Q]ueue: "
 .D ^%ZIS Q:POP  I $E(IOST,1)'="P" D  Q
 ..W *7,?5,"<<< NOT A PRINTER DEVICE >>>"
 .S ABPA("IO")=+IO_";80;60"
 Q
 ;--------------------------------------------------------------------
ZTLOAD ;PROCEDURE TO LOAD THE BACKGROUND TASK MANAGER
 S ZTRTN="SETUP^ABPAUPCK",ZTIO=ABPA("IO")
 S ZTDESC="UNPROCESSED CHECKS REPORT",ZTDTH=$H
 S ZTSAVE("ABPATLE")="",ZTSAVE("XQO")="",ZTSAVE("ABPA(""IO"")")=""
 D ^%ZTLOAD I $D(ZTSK)=1 W !!,"REQUEST QUEUED!!  Task number: ",ZTSK 
 D PAUSE^ABPAMAIN
 Q
 ;--------------------------------------------------------------------
SETUP ;PROCEDURE TO SETUP FILEMAN PRINT REQUEST
 K ABPA("HD") S ABPA("HD",1)=ABPATLE,ABPA("HD",2)=$P(XQO,"^",2)
 S ABPAPG=0 D ^ABPARPTH,SUBHD K ^TMP("ABPAUPCK")
 S R=0 F J=0:0 D  Q:+R=0
 .S R=$O(^ABPACHKS("RB",1,R)) Q:+R=0
 .S INSPTR=^ABPACHKS(1,"I",R,0),INSNAME=$P(^AUTNINS(INSPTR,0),"^")
 .S RR=0 F K=0:0 D  Q:+RR=0
 ..S RR=$O(^ABPACHKS("RB",1,R,RR)) Q:+RR=0
 ..S DATA=^ABPACHKS(1,"I",R,"C",RR,0)
 ..S RDT=$P($P(DATA,"^",2),".")
 ..S RDT=$E(RDT,4,5)_"/"_$E(RDT,6,7)_"/"_$E(RDT,2,3)
 ..S CHKNO=$P(DATA,"^",1)
 ..S AMT=$P(DATA,"^",4),RAMT=$P(DATA,"^",9)
 ..S ^TMP("ABPAUPCK",RDT,INSNAME,CHKNO)=AMT_"^"_RAMT
 S (R,CNT,TAMT,TRAMT,MTH,MT1,MT2,MT3)=0 F J=0:0 D  Q:R=""
 .S R=$O(^TMP("ABPAUPCK",R)) Q:R=""  I $E(R,1,2)'=MTH&(MTH'=0) D
 ..W !?42,"---------------",?59,"---------",?70,"---------"
 ..W !?23,"Monthly Sub-total"
 ..W ?42,$J(MT1,15),?59,$J(MT2,9,2),?70,$J(MT3,9,2)
 ..S (MT1,MT2,MT3)=0 I $Y>(IOSL-4) D ^ABPARPTH,SUBHD
 .W ! S (RR,RT1,RT2,RT3)=0,MTH=$E(R,1,2) F K=0:0 D  Q:RR=""
 ..S RR=$O(^TMP("ABPAUPCK",R,RR)) I RR="" D  Q
 ...W !?42,"---------------",?59,"---------",?70,"---------"
 ...W !?25,"Daily Sub-total"
 ...W ?42,$J(RT1,15),?59,$J(RT2,9,2),?70,$J(RT3,9,2)
 ...I $Y>(IOSL-4) D ^ABPARPTH,SUBHD
 ..W !,RR S NEWINS=1,RRR=0 F L=0:0 D  Q:RRR=""
 ...S RRR=$O(^TMP("ABPAUPCK",R,RR,RRR)) Q:RRR=""
 ...S DATA=^(RRR),AMT=+DATA,RAMT=$P(DATA,"^",2)
 ...S TAMT=TAMT+AMT,TRAMT=TRAMT+RAMT,CNT=CNT+1,RT1=RT1+1
 ...S RT2=RT2+AMT,RT3=RT3+RAMT,MT1=MT1+1,MT2=MT2+AMT,MT3=MT3+RAMT
 ...I 'NEWINS W !
 ...W ?32,R,?42,$J(RRR,15),?59,$J(AMT,9,2),?70,$J(RAMT,9,2)
 ...S NEWINS=0 I $Y>(IOSL-4) D ^ABPARPTH,SUBHD
 W !?42,"---------------",?59,"---------",?70,"---------"
 W !?23,"Monthly Sub-total"
 W ?42,$J(MT1,15),?59,$J(MT2,9,2),?70,$J(MT3,9,2)
 W !?42,"---------------",?59,"---------",?70,"---------",!?35,"Total"
 W ?42,$J(CNT,15),?59,$J(TAMT,9,2),?70,$J(TRAMT,9,2)
 D ^%AUCLS X ^%ZIS("C")
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - OVERALL ROUTINE DRIVER
 D CLEAR,HEAD,DEVICE I $D(ABPA("IO"))'=1 D  Q
 .D CLEAR S IOP=$I D ^%ZIS K IOP
 I $D(IO("Q"))=1 D ZTLOAD,CLEAR S IOP=$I D ^%ZIS K IOP Q
 W !! D WAIT^DICD S IOP=ABPA("IO") D ^%ZIS K IOP U IO D SETUP
 D CLEAR S IOP=$I D ^%ZIS K IOP U IO(0)
 Q
 ;--------------------------------------------------------------------
AUTO ;PROCEDURE TO AUTO PRINT THIS REPORT - CALLED BY TASKMAN
 S IOP=+IO_";80;60",ABPA("IO")=IOP D ^%ZIS K IOP
 S ABPATLE="AO PRIVATE INSURANCE SYSTEM "
 S ABPAVER=$O(^DIC(9.4,"C","ABPA",""))
 I ABPAVER]"",$D(^DIC(9.4,ABPAVER,"VERSION")) D
 .S ABPAVER="V."_^DIC(9.4,ABPAVER,"VERSION")
 S ABPATLE=ABPATLE_ABPAVER,DUZ(2)=+^AUTTSITE(1,0)
 S XQO="^UNPROCESSED CHECKS REPORT" D SETUP
 Q
