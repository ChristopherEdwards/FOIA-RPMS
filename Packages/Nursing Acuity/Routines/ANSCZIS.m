ANSCZIS ;IHS/OIRM/DSD/CSC - DEVICE CALLS AND QUEUING;  [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ROUTINE USED AS CENTRAL POINT FOR ALL DEVICE HANDLING AND QUEUING
ZIS ;EP;TO CALL DEVICE
 K DN
 D FS
 I $D(ANSCOND) D
 .W !!,*7,*7,"The report you are about to print requires either a wide carriage printer or",!,"a printer set for condensed mode with a width of 132 characters."
 .W !,"Check with your system manager if you are uncertain which device to select."
 K ANSCOND
 S %ZIS="NPQ",ZIBH=$TR($H,",","")_$R(1000)
 W !
 S:$D(ANSREV) IOP="HOME"
 D ^%ZIS
 I POP>0 D CLOSE Q
 S:$G(IOPAR)]"" %ZIS("IOPAR")=IOPAR
 S ZTSAVE("%ZIS*")="",ZTSAVE("ZIBH")=""
 S ZTRTN="OPEN^ANSCZIS"
 I $D(IO("Q")),IO=IO(0)!$D(IO("S")) W !!,*7,"CANNOT QUEUE TO HOME OR SLAVE DEVICE." G ZIS
 I $E(IOST,1,2)="P-",'$D(ANSREV) D  I $D(ANSQUIT)!$D(ANSOUT) D CLOSE Q
 .S DIR(0)="NO^1:99",DIR("A")="Number of Copies",DIR("B")=1
 .D DIR^ANSDIC
 .I $D(ANSQUIT)!$D(ANSOUT)!'+Y S ANSQUIT="" Q
 .S ANSCOPY=+Y
 .S ANSPRT=IO  ;;CSC 7-97
 I '$D(IO("Q")) D  D CLOSE Q
 .I $E(IOST,1,2)="P-" W !!,"...One moment please, while I complete your print request...",!
 .D:$D(ANSRTN) @ZTRTN
 E  D ZTLOAD
 Q
CLOSE ;EP;TO CLOSE DEVICE
 D ^%ZISC   ;S IO=ANSPRT D ^%ZISC  ;;CSC 7-97
 K IOP,IOPAR,%ZIS,ZTSK,ANSPRT
 Q
ZTLOAD ;EP;TO CALL %ZTLOAD
 K ANSDR
 S ZTIO=ION,ZTSAVE("ANS*")=""
 D ^%ZTLOAD
 W !!,$S($G(ZTSK)]"":"Request queued!",1:"Request cancelled.")
 D CLOSE
 H 2
 Q
OPEN ;EP;TO OPEN DEVICE AND PRINT SELECTED REPORT
 I '$D(ZTQUEUED)!(ION["HOST") S IOP=ION D ^%ZIS I POP S ANSQUIT="" Q
 S ANSPRT=IO  ;;CSC 7-97
 D @ANSRTN
 S:$D(ZTQUEUED) ZTREQ="@"
 D:'$D(ZTQUEUED) CLOSE
 Q
HOST ;EP;TO OPEN HOST FILE
 ;%FN - FILE NAME REQUIRED
 ;ANSOP - 'R' FOR READ, 'W' FOR WRITE REQUIRED, 'M' FOR READ/WRITE
 Q:'$D(%FN)!'$D(ANSOP)
 F ANSI=1:1:4 S (IOP,ION)="HOST FILE SERVER #"_ANSI,%ZIS("IOPAR")="("""_%FN_""":"""_ANSOP_""")" D ^%ZIS Q:'POP
 I POP G HOST
 K IOP
 Q
FS ;EP;TO CHECK IF WIDE CARRIAGE/CONDENSED PRINTER NEEDED
 I $G(ANSDOCDA),$D(^ANSDOC(ANSDOCDA,3)) N X S X=^(3) D
 .I $P(X,U,13),'$P(X,U,17) D
 ..I $P($G(^ANSPO(+$P($G(^ANSDOC(ANSDOCDA,0)),U,8),"DT")),U,10) S X=$P(^("DT"),U,10),(ION,%ZIS("B"))=$P(^%ZIS(1,X,0),U)
 ..E  S ANSCOND=""
 .S:$P(X,U,17)=1 ANS3542=""
 Q
