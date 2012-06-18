SROABCH ;B'HAM ISC/MAM - BATCH PRINT ASSESSMENTS ; [ 01/08/98   9:54 AM ]
 ;;3.0; Surgery ;**77**;24 Jun 93
DATE ; get dates
 S SRSOUT=0 W @IOF,!!,"This report will print all completed or transmitted assessments that have a",!,"'date completed' within the date range selected.",!
 D DATE^SROUTL(.SRASTDT,.SRAENDT,.SRSOUT) G:SRSOUT END
 W !!,"Depending on the date range entered, this report may be very long.  You should",!,"QUEUE this report to the selected printer.",!
 K %ZIS,IOP,POP,IO("Q") S %ZIS="Q",%ZIS("A")="Print on which Device: " D ^%ZIS S:POP SRSOUT=1 G:POP END
 I $D(IO("Q")) K IO("Q") S ZTRTN="EN^SROABCH",(ZTSAVE("SRSITE*"),ZTSAVE("SRASTDT"),ZTSAVE("SRAENDT"))="",ZTDESC="Batch Print Risk Assessments" D ^%ZTLOAD S SRSOUT=1 G END
EN ; entry when queued
 S SRSOUT=0,SRABATCH=1
 U IO S SRAENDT=SRAENDT+.9999,SDATE=SRASTDT-.0001 F  S SDATE=$O(^SRF("AC",SDATE)) Q:'SDATE!(SDATE>SRAENDT)!SRSOUT  S SRTN=0 F  S SRTN=$O(^SRF("AC",SDATE,SRTN)) Q:'SRTN!SRSOUT  D STUFF
END I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 I $E(IOST)'="P",'SRSOUT W !!,"Press RETURN to continue  " R X:DTIME
 D ^%ZISC K SRTN W @IOF D ^SRSKILL
 Q
STUFF S DATE=$P(^SRF(SRTN,0),"^",9)
 S SR("RA")=$G(^SRF(SRTN,"RA")),X=$P(SR("RA"),"^") I X'="T",X'="C" Q
 I $P(SR("RA"),"^",6)'="Y" Q
 K SRA D ^SROAPAS
 Q
