ABPAAGEQ ;QUEUE PVT INS AGED CLAIMS REPORT; [ 07/25/91  10:33 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"<<< SORRY, ACCESS DENIED!!! >>>",!! G ZTLEND
 ;--------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 S ABPAHD1="OUTSTANDING CLAIMS Reports" D HEADER^ABPAMAIN
 Q
 ;--------------------------------------------------------------------
TYPE K DIR,ABPA("RTYP")
 S DIR(0)="SO^1:Detailed Open Items;2:Aged Claim Summary;"
 S DIR("A")="Select REPORT TYPE" D ^DIR I Y S ABPA("RTYP")=+Y
 E  D
 .K ABPAMESS S ABPAMESS="NO REPORT TYPE SELECTED - JOB ABORTED" W *7
 .S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
 Q
 ;--------------------------------------------------------------------
INSURER ;PROCEDURE TO SELECT INSURERS TO INCLUDE
 S ABPA("INS")=0 F I=0:0 D  Q:+%>0
 .W !!,"Use ALL INSURERS" S %=1 D YN^DICN
 I +%=1 S ABPA("INS")="ALL" Q
 F J=0:0 D  Q:+Y<1
 .K DIC S DIC="^AUTNINS(",DIC(0)="AEMQ" W ! D ^DIC Q:+Y<1
 .S ABPA("INS")=ABPA("INS")+1,ABPA("INS",ABPA("INS"))=+Y
 Q
 ;--------------------------------------------------------------------
DEVICE ;PROCEDURE TO SELECT PRINTER DEVICE TO USE FOR THE REPORT
 S %IS="NP",IOP="Q" W !! D ^%ZIS
 I POP=1 D  H 2 S IOP=$I D ^%ZIS K IOP Q
 .K ABPAMESS S ABPAMESS="NO DEVICE SELECTED - JOB ABORTED" W *7
 .S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
 I $E(IOST,1)'="P" D  S IOP=$I D ^%ZIS K IOP G DEVICE
 .W *7,?5,"<<< MUST BE A PRINTER DEVICE >>>"
 S ABPA("IO")=+IO
 Q
 ;--------------------------------------------------------------------
ZTLOAD ;PROCEDURE TO LOAD BACKGROUND TASK MANAGER WITH JOB REQUEST
 I ABPA("RTYP")=1 S ZTRTN="MAIN^ABPAAGE1" D
 .S ZTDESC="COMPILE DETAILED OPEN ITEMS"
 I ABPA("RTYP")=2 S ZTRTN="MAIN^ABPAAGS1" D
 .S ZTDESC="COMPILE AGED CLAIMS SUMMARY"
 S ZTSAVE("BDT")="",ZTSAVE("EDT")="",ZTSAVE("ABPATLE")="",ZTIO=""
 S ZTSAVE("ABPA(")="",ZTSAVE("ABPAOPT(")="" D ^%ZTLOAD
 I $D(ZTSK)=1 W !!,"REQUEST QUEUED!!  Task number: ",ZTSK H 3
 Q
 ;--------------------------------------------------------------------
ZTLEND ;PROCEDURE TO KILL ALL LOCALLY USED TEMPORARY VARIABLES
 K %DT,%ZIS,%IS,ZTSK,X,Y,BDT,EDT,FAC,ZTRTN,ZTSAVE,ZTIO,ZTDESC,ABPA
 K DIC,%,IOP,I,DIR
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - THE STARTING POINT FOR ENTERING THIS PROGRAM
 D ZTLEND,HEAD,TYPE I $D(ABPA("RTYP"))'=1 D ZTLEND Q
 D ^ABPADATE I '$D(BDT)!'$D(EDT) D  D ZTLEND Q
 .K ABPAMESS S ABPAMESS="INVALID REPORT PERIOD - JOB ABORTED" W *7
 .S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
 D INSURER I ABPA("INS")'="ALL"&(+ABPA("INS")'>0) D  D ZTLEND Q
 .K ABPAMESS S ABPAMESS="NO INSURER(S) SELECTED - JOB ABORTED" W *7
 .S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
 D DEVICE I $D(ABPA("IO"))'=1 D ZTLEND Q
 D ZTLOAD,ZTLEND
 Q
