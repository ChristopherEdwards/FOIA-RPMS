AMHEYTAP ; IHS/CMI/LAB - GENERATE TAPE OF MHSS TRANSACTIONS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ; AMH("QFLG") values set by this routine:
 ;     Value           Meaning
 ;       0        All ok
 ;       1        Site file error (^AMHSCHK)
 ;       41       No MHSS transactions to send
 ;       30       Unable to lock transaction global
 ;       43       Device not ready or open error (^AMHOPEN)
 ;       44       Tape write error [DSM only]
 ;       45       Operator "^" or NULL out [DSM only] (^AMHOPEN)
 ;       46       Unable to determine Operating System
 ;
START ;
 S AMH("QFLG")=0
 D GETLOG
 I AMH("RUN LOG")="" K AMH("RUN LOG") Q
 D EN
 K AMH("RUN LOG"),AMHS,AMH
 Q
EN ;ENTRY POINT
 D BASICS ;        Do basic initialization
 I AMH("QFLG") D EOJ Q
 S XBGL="BHSXDATA",XBMED="F",XBNAR="BH FACILITY",XBTLE="BH DATA TRANSMISSION TO HQ"
 D ^XBGSAVE
 I XBFLG=-1,$G(XBFLG(1))["uucp" W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) G COMP
 I XBFLG=-1 S AMH("QUIT")="" W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) G EOJ
 ;update log file .15 with date
COMP K DR,DIE,DA S DIE="^AMHXLOG(",DR=".15///C",DA=AMH("RUN LOG") D CALLDIE^AMHLEIN
 D EOJ
 Q
 ;
GETLOG ;
 S AMH("RUN LOG")=""
 S DIC("S")="I $P(^AMHXLOG(Y,0),U,15)=""P""",DIC="^AMHXLOG(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y<0 Q
 S AMH("RUN LOG")=+Y
 Q
BASICS ; SET VARIABLES, LOCK GLOBAL, INSURE DATA
 K AMH("QUIT")
 D:'$D(DUZ(2))#2 ^XBKVAR
 S AMH("QFLG")=0,AMH("TAPE COUNT")=0
CHKSITE ; CHECK SITE FILE
 I '$D(^AMHSITE(DUZ(2),0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S AMH("QFLG")=1 Q
 I '$D(^AMHSITE(DUZ(2))) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S AMH("QFLG")=2 Q
 ;
 Q:AMH("QFLG")
  I '$D(^BHSXDATA) W:'$D(ZTQUEUED) !!,"*** No MHSS transactions to send! ***" S AMH("QFLG")=28 Q
 I '$D(^BHSXDATA(0)) W:'$D(ZTQUEUED) !!,"*** The Transaction process NEVER complete properly!!" S AMH("QFLG")=29 Q
 L +^BHSXDATA:15 E  W:'$D(ZTQUEUED) !!,"*** Unable to lock transaction global! ***" S AMH("QFLG")=30 Q
 I $P(^AMHXLOG(AMH("RUN LOG"),0),U,15)'="P" W:'$D(ZTQUEUED) !!,$C(7),$C(7),"The Transaction Generation process never successfully completed!!",!! S AMH("QFLG")=31 Q
 K AMH("QUIT")
 W:'$D(ZTQUEUED) !,"The transactions will be written to a FILE"
CONT Q:$D(ZTQUEUED)
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) W !,"Transactions are NOT being written to an output device",! S AMH("QUIT")="",AMH("QFLG")=99 Q
 Q
 ;
EOJ ;
 I 'AMH("QFLG"),'$D(AMH("QUIT")) K ^BHSXDATA ;UNSUBSCRIPTED GLOBALS ARE CMB STANDARD SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER - MUST BE KILLED
 K AMHV("TX"),AMH("XX"),XBFLG,XBGL,XBMED,XBNAR,XBTLE
 K DIC,D,D0,DQ,DIR,DO
 L -^BHSXDATA
 Q
