ABPVTX0 ;EXPORT FACILITY PVT-INS CLAIM DATA;[ 08/07/91  3:50 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 G A0
 ;--------------------------------------------------------------------
INSCHK ;PROCEDURE TO INSPECT FOR COMPLETE INSURANCE RECORD
 S ZINSERR=0,ZNODE=""
NXTNODE S ZNODE=$O(^AUTNINS(ZINSCO,ZNODE)) G:(ZNODE="")!(+ZNODE>1) INSCHKC
 S ZY=^AUTNINS(ZINSCO,ZNODE)
 I ZNODE=1 I $P(ZY,"^")']"" I $P(ZY,"^",5)']"" G NXTNODE
 I $L($P(ZY,"^",2))<2 S ZINSERR=ZINSERR_1 G NXTNODE
 I $L($P(ZY,"^",3))<2 S ZINSERR=ZINSERR_1 G NXTNODE
 I +$P(ZY,"^",4)<1!('$D(^DIC(5,+$P(ZY,"^",4),0))) D  G NXTNODE
 .S ZINSERR=ZINSERR_1
 I $L($P(ZY,"^",5))<5!($P(ZY,"^",5)'?5N.E) D  G NXTNODE
 .S ZINSERR=ZINSERR_1
 S ZINSERR=ZINSERR_0 G NXTNODE
INSCHKC I ZINSERR="01"!(ZINSERR="010") D
 .S ^UTILITY("ABPVTXE","INS-ERR",ZINSCO)=""
 I ZINSERR="001"!(ZINSERR="011") D
 .S ^UTILITY("ABPVTXE","INS-ERR",ZINSCO)="*"
 Q
 ;--------------------------------------------------------------------
A0 ;PROCEDURE TO DRAW SCREEN HEADING
 D ^ABPVVAR W @IOF,! S PGNO=0 F I=1:1:79 W "*"
 W !,"*",?17,"PRIVATE INSURANCE BILLING CLAIM EXPORT PROGRAM",?78,"*",!
 S X="FOR "_$P(^DIC(4,DUZ(2),0),"^",1) W "*",?80-$L(X)/2,X,?78,"*",!
 S Y=DT X ^DD("DD") W "*",?80-$L(Y)/2,Y,?78,"*",! F I=1:1:79 W "*"
 ;--------------------------------------------------------------------
A0A ;PROCEDURE TO GET THE LAST DATE DATA WAS EXPORTED
 S LEXDATE=9999999-($O(^ABPVTXST("AC",DUZ(2),"")))
 L (^ABPVFAC,^AUTNINS):1
 I '$T D  H 4 G JOBEND^ABPVTX1
 .W *7,!!,?18,"PRIVATE INSURANCE AUDIT or INSURER File in Use.",!,?22
 .W "Cannot Do Export at this time.",!!,?25
 .W "THIS JOB HAS BEEN CANCELLED"
 W !! D A1 I +IO=0 D PAUSE^ABPVZMM G ZEND^ABPVTX2
 G A2
 ;--------------------------------------------------------------------
A1 ;PROCEDURE TO GET PRINTER OUTPUT DEVICE
 S %IS="P",%ZIS("A")="Print Export Report on Device: " D ^%ZIS Q:POP
 I $E(IOST)'="P" W ?4,"<<< MUST BE A PRINTER TYPE DEVICE >>>",*7 G A1
 Q
 ;--------------------------------------------------------------------
A2 ;PROCEDURE TO DETERMINE THE BEGINNING RECORD NUMBER FOR THIS RUN
 S ABPV("SITE")=DUZ(2),BRECNO=0,R=0,ZCLCT=0,ZCLAMT=0
 I '$D(^ABPVTXST(ABPV("SITE"))) G A2A
 S X=+$P(^ABPVTXST(ABPV("SITE"),1,0),"^",4) I X<1 G A2A
 S BRECNO=+$P(^ABPVTXST(ABPV("SITE"),1,X,0),"^",4)
 I BRECNO'<+$P(^ABPVFAC(0),"^",3) D  G ZENDA^ABPVTX2
 .X ^%ZIS("C") S IOP=$I D ^%ZIS K IOP
 .W !,*7,?10,"NO RECORDS AVAILABLE FOR EXPORT --  JOB CANCELLED" H 2
 ;--------------------------------------------------------------------
A2A ;PROCEDURE TO CONTROL REMAINING TASKS OF THIS ROUTINE
 W ! D WAIT^DICD,A3,A4 G S3START^ABPVTX1
 ;--------------------------------------------------------------------
A3 ;PROCEDURE TO BUILD SORTED UTILITY GLOBAL INDEX
 K ^UTILITY("ABPVTX") S Y=DT X ^DD("DD") S ^UTILITY("ABPVTX",0)=Y
 S RR=+BRECNO F ABPVI=0:0 D  Q:+RR=0
 .S RR=$O(^ABPVFAC(RR)) Q:+RR=0
 .S ZX=^ABPVFAC(RR,0),PDFN=$P(ZX,"^",2),PNAME=$P(^DPT(PDFN,0),"^")
 .S ^UTILITY("ABPVTX",PNAME,$P(ZX,"^",3),RR)=""
 .K ZX,PDFN,PNAME
 Q
 ;--------------------------------------------------------------------
A4 ;PROCEDURE TO PRINT SORTED EXPORT TRANSMITTAL LOG
 K ^UTILITY("ABPVTXE") D ^ABPVPRT,HEADER^ABPVTX1
 S R=0 F ABPVI=0:0 D  Q:R=""
 .S R=$O(^UTILITY("ABPVTX",R)) Q:R=""
 .S RR=0 F ABPVI=0:0 D  Q:+RR=0
 ..S RR=$O(^UTILITY("ABPVTX",R,RR)) Q:+RR=0
 ..S RRR=0 F ABPVI=0:0 D  Q:+RRR=0
 ...S RRR=$O(^UTILITY("ABPVTX",R,RR,RRR)) Q:+RRR=0
 ...S ZX=^ABPVFAC(RRR,0)
 ...S X=$P(ZX,"^",11)
 ...W ?1,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 ...W ?11,$J($P(ZX,"^",1),7)
 ...S PDFN=$P(ZX,"^",2) W ?20,$E($P(^DPT(PDFN,0),"^",1),1,30)
 ...W ?52,$J($P(ZX,"^",5),6)
 ...S X=$P(ZX,"^",3)
 ...W ?61,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 ...S ZINSCO=$P(ZX,"^",8) D INSCHK
 ...W ?71,$P(^AUTNINS($P(ZX,"^",8),0),"^",1)
 ...W ?103,$J($P(ZX,"^",9),8,2)
 ...W ?113,$P(ZX,"^",6)
 ...W ?117,$J($P(ZX,"^",7),2),!
 ...S ZCLCT=ZCLCT+1,ZCLAMT=ZCLAMT+$P(ZX,"^",9)
 ...I $Y>50 D HEADER^ABPVTX1
 W ?5 F I=1:1:110 W "-"
 W !,?5,"TOTAL CLAIMS = ",ZCLCT,?45,"TOTAL CLAIM AMT = ",?64
 W $J(ZCLAMT,8,2),!! D PRESET H 5 
 Q
 ;--------------------------------------------------------------------
PRESET ;PROCEDURE TO RESET THE PRINTER TO 10 CPI
 I $D(IO),$D(A("PRINT",10)) U IO W @A("PRINT",10)
 Q
 ;--------------------------------------------------------------------
REPRT ;PROCEDURE TO RE-PRINT THE MOST RECENT EXPORT LOG
 K ABPV("HD") S ABPV("HD",1)=ABPVTLE
 S ABPV("HD",2)="Re-print the MOST RECENT EXPORT LOG" D ^ABPVHD
 I $D(^UTILITY("ABPVTX",0))'=1 D  Q
 . K ABPVMESS S ABPVMESS="PREVIOUS EXPORT NOT FOUND"
 . S ABPVMESS(2)="...Press any key to continue..." D PAUSE^ABPVZMM
 W ! S ABPVMESS="Re-print the export log for "_^UTILITY("ABPVTX",0)
 S ABPVMESS=ABPVMESS_" (Y/N)" K DIR D YN^ABPVZMM K ABPVMESS
 I 'Y D PAUSE^ABPVZMM G ZENDA^ABPVTX2
 S PGNO=0,ZCLCT=0,ZCLAMT=0 
 W ! D A1 I +IO=0 D PAUSE^ABPVZMM G ZENDA^ABPVTX2
 W ! D WAIT^DICD,A4,PRESET U IO W @IOF X ^%ZIS("C") D PAUSE^ABPVZMM
 Q
