BARWRVR ; IHS/SD/LSL - ROLLOVER DETAIL REPORT ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
SUM ; EP
 ; summary
 S BARSUM=1
 ;
DET ; EP
 ; detail
 S:'$G(BARSUM) BARSUM=2
 K BARQUIT
 D GETDOS^BARPUTL
 S %ZIS="NQ"
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D  Q
 .S ZTRTN="LOOP^BARWRVR"
 .F I="BARSTART","BAREND","BARSUM" S ZTSAVE(I)=""
 .K ZTSK
 .D ^%ZTLOAD
 .W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 .D HOME^%ZIS
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ; -------------------------------
 ;
LOOP ;
 ; loop through "AE" x-ref
 S $P(BAREQ,"=",80)=""
 S BARPG=0
 N I F I=1:1:4 S BARTOT(I)=0
 D HDR
 S BARDATE=BARSTART-.1
 S $P(BAREND,".",2)=9999
 S BAROLD=0
 F  S BARDATE=$O(^BARBL(DUZ(2),"AE",BARDATE)) Q:'BARDATE!(BARDATE>BAREND)!($G(BARQUIT))  D
 .S:BAROLD=0 BAROLD=$P(BARDATE,".",1)
 .I $P(BARDATE,".",1)'=BAROLD,BARSUM=1 D SUMPR
 .S DA=0
 .F  S DA=$O(^BARBL(DUZ(2),"AE",BARDATE,DA)) Q:'DA  D ONE
 I '$G(BARQUIT) D
 .D:BARSUM=1 SUMPR
 .D:$Y+5>IOSL HDR
 .W !!," TOTAL:    ",$J($FN(BARTOT(2),",",2),12)
 .W ?27,"TOTAL BILLS: ",$J(BARTOT(1),5)
 .W !!,"E N D   O F   R E P O R T",!!
 .D EOP^BARUTL(1)
 I $D(IO("S")) D ^%ZISC
 K BARSTART,BAREND,BARDATE,BAR5,BARTOT,BARQUIT,BARSUM,BAROLD
 Q
 ; *********************************************************************
 ;
SUMPR ;
 ; print out one day
 W !,$$SDT^BARDUTL(BAROLD)
 W ?11,$J($FN(BARTOT(4),",",2),12)
 W ?40,$J(BARTOT(3),5)
 S BARTOT(3)=0,BARTOT(4)=0
 S BAROLD=$P(BARDATE,".",1)
 Q
 ; *********************************************************************
 ;
ONE ;
 ; one bill
 S Y=1
 I $Y+5>IOSL D
 .D EOP^BARUTL(0)
 .I '+Y S BARQUIT=1 Q
 .D HDR
 Q:$G(BARQUIT)
 K BAR5
 F K=0,2 S BAR5(K)=^BARBL(DUZ(2),DA,K)
 D DIQ
 S BARTOT(1)=BARTOT(1)+1
 S BARTOT(2)=BARTOT(2)+$P(BAR5(2),"^",9)
 S BARTOT(3)=BARTOT(3)+1
 S BARTOT(4)=BARTOT(4)+$P(BAR5(2),"^",9)
 Q:BARSUM=1
 W !,$$SDT^BARDUTL($P(BAR5(2),"^",10))
 W ?13,$J($FN($P(BAR5(2),"^",9),",",2),10)
 W ?27,$P(BAR5(0),"^",1)
 W ?50,$G(BAR5(90050.01,DA,17.2))
 W ?65,$G(BAR5(90050.01,DA,17.4))
 Q
 ; *********************************************************************
 ;
DIQ ;
 ; get computed fields
 K DIQ
 S DIC="^BARBL(DUZ(2),"
 S DIQ="BAR5("
 S DR="17.2;17.4"
 D EN^DIQ1
 Q
 ; *********************************************************************
 ;
HDR ;
 ; report header
 S BARPG=BARPG+1
 W $$EN^BARVDF("IOF")
 D:BARSUM=1 HDR1
 D:BARSUM=2 HDR2
 W !,BAREQ,!
 Q
 ; *********************************************************************
 ;
HDR1 ;
 ; header for summary report
 W !,$$MDT2^BARDUTL(DT),?30,"ROLLOVER SUMMARY REPORT"
 W ?70,"Page: ",BARPG
 W !,?15,"ROLLOVER"
 W !,"DATE",?17,"AMOUNT",?39,"BILL COUNT"
 Q
 ; *********************************************************************
 ;
HDR2 ;
 ; header for detail report
 W !,$$MDT2^BARDUTL(DT),?30,"ROLLOVER DETAIL REPORT"
 W ?70,"Page: ",BARPG
 W !,?15,"ROLLOVER",?50,"3P BILL",?65,"3P CLAIM"
 W !,"DATE",?17,"AMOUNT",?27,"A/R BILL",?50,"STATUS",?65,"STATUS"
 Q
