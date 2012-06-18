APCPTAPE ; IHS/TUCSON/LAB - OHPRD-TUCSON/EDE GENERATE TAPE OF TRANSACTIONS XBGUST 14, 1992 ; [ 02/11/03  10:32 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**6**;APR 03, 1998
 ;
 ;
 ; APCP("QFLG") values set by this routine:
 ;     Value           Meaning
 ;       0        All ok
 ;       1        Site file error (^APCPSCHK)
 ;       41       No transactions to send
 ;       30       Unable to lock transaction global
 ;       43       Device not ready or open error (^APCPOPEN)
 ;       44       Tape write error [DSM only]
 ;       45       Operator "^" or NULL out [DSM only] (^APCPOPEN)
 ;       46       Unable to determine Operating System
 ;
START ;
 S APCP("QFLG")=0
 D GETLOG
 I APCP("RUN LOG")="" K APCP("RUN LOG") Q
 D EN
 K APCP("RUN LOG"),APCPS,APCP
 Q
EN ;ENTRY POINT
 D BASICS ;        Do basic initialization
 I APCP("QFLG") D EOJ Q
 S XBGL="BAPCDATA",XBMED=APCP("DEF DEVICE"),XBNAR="PCC FACILITY",XBTLE="PCC DATA TRANSMISSION TO APC,INPT,CHA,STATISTICAL DB"
 S XBFN=$P(^APCPLOG(APCP("RUN LOG"),0),U,24)
 D ^XBGSAVE
 I XBFLG=-1 S APCP("QUIT")="" W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) G EOJ
 ;update log file .15 with date
 K DR,DIE,DA S DIE="^APCPLOG(",DR=".15///C",DA=APCP("RUN LOG") D ^DIE K DIE,DR,DA
 D EOJ
 Q
 ;
GETLOG ;
 S APCP("RUN LOG")=""
 S DIC("S")="I $P(^APCPLOG(Y,0),U,15)=""P""",DIC="^APCPLOG(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y<0 Q
 S APCP("RUN LOG")=+Y
 Q
BASICS ; SET VARIABLES, LOCK GLOBAL, INSURE DATA
 K APCP("QUIT")
 S APCP("QFLG")=0,APCP("TAPE COUNT")=0
 D CHKSITE^APCPDRI ;     Make sure Site file has correct fields
 Q:APCP("QFLG")
 I '$D(^BAPCDATA) W:'$D(ZTQUEUED) !!,"*** No APC, INPATIENT OR CHA transactions to send! ***" S APCP("QFLG")=28 Q
 I '$D(^BAPCDATA(0)) W:'$D(ZTQUEUED) !!,"*** The Transaction process NEVER complete properly!!" S APCP("QFLG")=29 Q
 I $P(^APCPLOG(APCP("RUN LOG"),0),U,15)'="P" W:'$D(ZTQUEUED) !!,$C(7),$C(7),"The Transaction Generation process never successfully completed!!",!! S APCP("QFLG")=31 Q
 L +^BAPCDATA:15 E  W:'$D(ZTQUEUED) !!,"*** Unable to lock transaction global! ***" S APCP("QFLG")=30 Q
 K APCP("QUIT")
 S APCP("DEF DEVICE")=$P(^APCPSITE(1,0),U,2)
 I APCP("DEF DEVICE")="" W:'$D(ZTQUEUED) !,"No Default Device in SITE File",!," NOTIFY YOUR SUPERVISOR, I cannot continue until there is a default device ",!," in the Site File",$C(7),$C(7) S APCP("QFLG")=4 Q
 I ^%ZOSF("OS")["DSM","TC"'[APCP("DEF DEVICE") W:'$D(ZTQUEUED) !,"NOTIFY YOUR SUPERVISOR - The default device in the Site file is not",!,"compatible with a DSM system.",!,$C(7),$C(7) S APCP("QFLG")=4 Q
 W:'$D(ZTQUEUED) !,"The transactions will be written to ",$S(APCP("DEF DEVICE")="C":"a CARTRIDGE TAPE",APCP("DEF DEVICE")="F":"a HOST FILE",APCP("DEF DEVICE")="T":"a 9 TRACK TAPE",APCP("DEF DEVICE")="D":"a FLOPPY DISKETTE",1:"ERROR")
CONT Q:$D(ZTQUEUED)
 Q:$P(^APCPSITE(1,0),U,11)="Y"
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) W !,"Transactions are NOT being written to an output device",! S APCP("QUIT")="",APCP("QFLG")=99 Q
 Q
 ;
EOJ ;
 I 'APCP("QFLG"),'$D(APCP("QUIT")) K ^BAPCDATA ;UNSUBSCRIPTED GLOBALS ARE CMB STANDARD SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER - MUST BE KILLED
 K APCPV("TX"),APCP("XX"),XBFLG
 L -^BAPCDATA:15
 Q
