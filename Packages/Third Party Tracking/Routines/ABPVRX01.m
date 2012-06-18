ABPVRX01 ;QUEUE RX BILLING SUMMARY;[ 06/04/91  12:45 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
START D ZTLEND,INIT,TITLE
 D DATES I '$D(ABPV("BEG"))!'$D(ABPV("END")) D ZTLEND Q
 D DEVICE I $D(ABPV("IO"))'=1 D ZTLEND Q
 D ZTLOAD
 Q
 ;
INIT D DT^DICRW
 I '$D(DUZ(2))!(DUZ(2)<1) S DUZ(2)=$P(^AUTTSITE(1,0),"^")
 S ABPV("SITE")=DUZ(2)
 Q
 ;
TITLE K ABPV("HD")
 S ABPV("HD",1)="P R I V A T E   I S U R A N C E   E L I G I B L E"
 S ABPV("HD",2)="PHARMACY PRESCRIPTIONS BY FILL DATE" D ^ABPVHD
 W !!,"This Program will search the prescription file for all "
 W "prescriptions with",!,"fill dates within the range you specify "
 W "that were ordered for Private Insurance",!,"Eligible patients."
 Q
 ;
DATES D ^ABPVDATE
 S:$D(BDT)=1 ABPV("BEG")=BDT S:$D(EDT)=1 ABPV("END")=EDT K BDT,EDT
 Q
 ;
DEVICE S %IS="NP",IOP="Q" W !! D ^%ZIS
 I +IO=0 D  H 3 Q
 .W *7,!!?5,"<<< NO DEVICE SELECTED - JOB ABORTED >>>"
 S ABPV("IO")=+IO
 Q
 ;
ZTLOAD S ZTRTN="^ABPVRX02",ZTSAVE("ABPV(")="",ZTIO=""
 S ZTDESC="COMPILE PVT INS ELIGIBLE RX'S"
 D ^%ZTLOAD I $D(ZTSK)=1 W !!,"REQUEST QUEUED!!  Task number: ",ZTSK
 H 3
ZTLEND K ABPV,%ZIS,%IS,ZRTN,ZTDTH,ZTDESC,ZTSAVE,ZTSK,R,I
 S IOP=$I D ^%ZIS K IOP
 Q
