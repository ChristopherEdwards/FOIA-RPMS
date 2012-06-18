BCHEXTAP ; IHS/TUCSON/LAB - GENERATE TAPE OF CHR TRANSACTIONS ;  [ 06/27/00  2:20 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**10**;OCT 28, 1996
 ;
 ;
 ;
START ;EP
 S BCH("QFLG")=0
 D GETLOG
 I BCH("RUN LOG")="" K BCH("RUN LOG") Q
 D EN
 K BCH("RUN LOG"),BCHS,BCH
 Q
EN ;ENTRY POINT
 D BASICS ;        Do basic initialization
 I BCH("QFLG") D EOJ Q
 D TAPE
 D EOJ
 Q
 ;
GETLOG ;
 S BCH("RUN LOG")=""
 S DIC("S")="I $P(^BCHXLOG(Y,0),U,15)=""P""",DIC="^BCHXLOG(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y<0 Q
 S BCH("RUN LOG")=+Y
 Q
BASICS ; SET VARIABLES, LOCK GLOBAL, INSURE DATA
 K BCH("QUIT")
 D:'$D(DUZ(2))#2 ^XBKVAR
 S BCH("QFLG")=0,BCH("TAPE COUNT")=0
CHKSITE ; CHECK SITE FILE
 I '$D(^BCHSITE(DUZ(2),0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BCH("QFLG")=1 Q
 I '$D(^BCHSITE(DUZ(2))) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BCH("QFLG")=2 Q
 I $P(^BCHSITE(DUZ(2),0),U,8)="" W:'$D(ZTQUEUED) !!,"**NO METHOD OF EXPORT TO HEADQUARTERS DEFINED" S BCH("QFLG")=5 Q
 I $P(^BCHSITE(DUZ(2),0),U,8)="A",$P(^BCHSITE(DUZ(2),0),U,7)="" W:'$D(ZTQUEUED) !!,"***No DEFAULT DEVICE value in Site file! ***" S BCH("QFLG")=4 Q
 ;
 Q:BCH("QFLG")
 I '$D(^BCHRDATA) W:'$D(ZTQUEUED) !!,"*** No CHR transactions to send! ***" S BCH("QFLG")=28 Q
 I '$D(^BCHRDATA(0)) W:'$D(ZTQUEUED) !!,"*** The Transaction process NEVER complete properly!!" S BCH("QFLG")=29 Q
 L +^BCHRDATA:15 E  W:'$D(ZTQUEUED) !!,"*** Unable to lock transaction global! ***" S BCH("QFLG")=30 Q
 I $P(^BCHXLOG(BCH("RUN LOG"),0),U,15)'="P" W:'$D(ZTQUEUED) !!,$C(7),$C(7),"The Transaction Generation process never successfully completed!!",!! S BCH("QFLG")=31 Q
 K BCH("QUIT")
 S BCH("DEF DEVICE")=$P(^BCHSITE(DUZ(2),0),U,7)
CONT Q:$D(ZTQUEUED)
 Q
 Q:$P(^BCHSITE(DUZ(2),0),U,8)="Y"
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BCH("QFLG")=99,BCH("QUIT")="" Q
 I 'Y W !,"Transactions are NOT being written to an output device",! S BCH("QUIT")="",BCH("QFLG")=99 Q
 Q
 ;
N ;network mail transmission
 ;strip off 1st ^ piece
 S X=0 F  S X=$O(^BCHRDATA(X)) Q:X'=+X  S ^BCHRDATA(X)=$P(^BCHRDATA(X),U,2)
 S XMSUB="CHRIS II DATA FROM "_$E($P(^DIC(4,DUZ(2),0),U),1,40)
 S XMY("FILERMASTER@DOMAIN.NAME")="" ;******************this must be set appropriately
 S XMTEXT="^BCHRDATA(",ZTQUEUED=1
 D ENT^XMPG
 Q
A ;AIB SAVE
 S XBGL="BCHRDATA",XBMED=BCH("DEF DEVICE"),XBNAR="CHR FACILITY",XBTLE="CHR DATA TRANSMISSION TO HQ",XBFLT=1 ;IHS/CMI/LAB - new format
 D ^XBGSAVE
 I XBFLG=-1 S BCH("QUIT")="" W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) G EOJ
 Q
UPDLOG ;
 ;update log file .15 with date
 K DR,DIE,DA S DIE="^BCHXLOG(",DR=".15///C",DA=BCH("RUN LOG") D CALLDIE^BCHUTIL
 D EOJ
 Q
 ;
EOJ ;
 I 'BCH("QFLG"),'$D(BCH("QUIT")) K ^BCHRDATA ;UNSUBSCRIPTED GLOBALS ARE CMB STANDARD SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER - MUST BE KILLED
 K BCHV("TX"),BCH("XX"),XBFLG,XBGL,XBMED,XBNAR,XBTLE,XBFLT
 K DIC,D,D0,DQ,DIR,DO
 Q
TAPE ;EP COPY TRANSACTIONS TO TAPE
 K BCH("QUIT")
 D BASICS
 S BCH("MODE")=$P(^BCHSITE(DUZ(2),0),U,8)
 D @(BCH("MODE"))
 I BCH("QFLG") D EOJ Q
 D UPDLOG
 Q
