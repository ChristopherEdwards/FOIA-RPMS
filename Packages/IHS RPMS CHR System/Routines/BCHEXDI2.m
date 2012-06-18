BCHEXDI2 ; IHS/TUCSON/LAB - Export initialization ;  [ 11/18/02  9:21 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 ;
 ;IHS/TUCSON/LAB - modified this to not error out if this is the
 ;first export and old data exists patch 1 06/03/97
 ;
 ;
START ;
 D INFORM^BCHEXDI3 ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:BCH("QFLG")
 D CHKOLD
 Q:BCH("QFLG")
 D CURRUN^BCHEXDI3 ;      Compute run dates for current run.
 Q:BCH("QFLG")
 D CHKCHR ;    Check CHR RECORD xref for date range
 Q:BCH("QFLG")
 D CONFIRM ;     Get ok from operator.
 Q:BCH("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
 ;
CHKOLD ;EP - CHECK FOR DATA LEFT BY OLD RUN
 I $D(^BCHRDATA) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^BCHRDATA global exists from a previous GEN or REDO!!" S BCH("QFLG")=32
 I $D(^TMP("BCHDR")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^TMP nodes exist from previous GEN!!," S BCH("QFLG")=10
 I $D(^TMP("BCHREDO")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^TMP nodes exist from previous REDO!!" S BCH("QFLG")=11
 Q
 ;
 ;
 ;
 ;
GETLOG ;EP GET LAST LOG ENTRY
 S (X,BCH("LAST LOG"))=$P(^BCHXLOG(0),U,3) F  S X=$O(^BCHXLOG(X)) Q:X'=+X  S BCH("LAST LOG")=X
 S X=$S(BCH("LAST LOG")&($D(^BCHXLOG(BCH("LAST LOG")))):BCH("LAST LOG"),1:0) F  S X=$O(^BCHXLOG(X)) Q:X'=+X  S BCH("LAST LOG")=X
 Q:'BCH("LAST LOG")
 D DISPLOG
 Q:$P(^BCHXLOG(BCH("LAST LOG"),0),U,15)="C"
 D ERROR
 Q
ERROR ;
 S BCH("QFLG")=12
 S BCH("PREV STATUS")=$P(^BCHXLOG(BCH("LAST LOG"),0),U,15)
 I BCH("PREV STATUS")="" D EERR Q
 D @(BCH("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S BCH("QFLG")=13
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last PCC Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
PERR ;
 S BCH("QFLG")=14
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"*****ERROR ENCOUNTERED*****",!,"Whoa!  The Transaction global from the previous run was NEVER successfully",!,"written to an output device (unix uucppublic file, cartridge, diskette).",!
 W !,"You must execute the menu option called 'OUTP' before any further processing.",!,"You may also need to determine whether or not the transaction global for ",!,"LOG ENTRY ",BCH("LAST LOG")," was ever received by your Area Office.",!
 Q
RERR ;
 S BCH("QFLG")=15
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"PCC Data Transmission is currently running!!"
 Q
QERR ;
 S BCH("QFLG")=16
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"PCC Data Transmission is already queued to run!!"
 Q
FERR ;
 S BCH("QFLG")=17
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"The last PCC Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^BCHXLOG(BCH("LAST LOG"),0),U) X ^DD("DD") S BCH("LAST BEGIN")=Y S Y=$P(^BCHXLOG(BCH("LAST LOG"),0),U,2) X ^DD("DD") S BCH("LAST END")=Y
 Q:$D(ZTQUEUED)
 W !!,"Last run was for ",BCH("LAST BEGIN")," through ",BCH("LAST END"),"."
 Q
 ;
 ;
CHKCHR ; CHECK CHR RECORD "AEX" XREF
 S BCHR("R DATE")=0
 S BCHR("R DATE")=$O(^BCHR("AEX",BCHR("R DATE")))
 I $D(BCH("FIRST RUN")) D CHKCR Q:BCH("QFLG")  ;IHS/TUCSON/LAB - patch 2 - 06/03/97 - added this line
 S BCHR("R DATE")=$O(^BCHR("AEX",0))
 I BCHR("R DATE"),BCHR("R DATE")<BCH("RUN BEGIN") W:'$D(ZTQUEUED) !!,"*** Cross-references exist prior to beginning of date range! ***" S BCH("QFLG")=21 Q
 ;
 S BCHR("R DATE")=BCH("RUN BEGIN")-1
 S BCHR("R DATE")=$O(^BCHR("AEX",BCHR("R DATE")))
 I BCHR("R DATE")=""!(BCHR("R DATE")>BCH("RUN END")) W:'$D(ZTQUEUED) !!,"*** No CHR RECORDs within range! ***" S BCH("QFLG")=22 Q
 Q
 ;
CONFIRM ; SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The location for this run is ",$P(^DIC(4,DUZ(2),0),U),"."
CFLP ;
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) S BCH("QFLG")=99
 I 'Y S BCH("QFLG")=99
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S BCH("BATCH")=$P(^BCHSITE(DUZ(2),0),U,11)+1
 S Y=BCH("RUN BEGIN") X ^DD("DD") S X=""""_Y_"""",DIC="^BCHXLOG(",DIC(0)="L",DLAYGO=90002.91,DIC("DR")=".02////"_BCH("RUN END")_";.09///`"_DUZ(2)_";.11///"_BCH("BATCH")
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 S BCH("QFLG")=23 Q
 S BCH("RUN LOG")=+Y
 K ^BCHRDATA ;TO DATA CENTER, THESE ARE OFFICIAL SCRATCH GLOBALS
 ;UNSUBSCRIPTED VARIABLES KILLED - THESE ARE CMB STANDARD DEFINED SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER
 Q
CHKCR ;
 ;IHS/TUCSON/LAB - patch 2 - 06/03/97 - added this sub-routine
 S Y=BCH("RUN BEGIN") X ^DD("DD") S Z=Y
 I BCHR("R DATE"),BCHR("R DATE")<BCH("RUN BEGIN") D CHKCR1
 Q
CHKCR1 ;
 W !!,"There are cross references entries for visits prior to the date of ",Z,".",!
 S DIR(0)="Y",DIR("A")="Are you SURE that the CHR data should export as of "_Z K DA D ^DIR K DIR
 I $D(DIRUT) S BCH("QFLG")=99 Q
 I 'Y W !,"BYE.." S BCH("QFLG")=99 Q
 D DELCR
 Q
DELCR ;
 W !!,"I will now clean up that cross reference.... Please be patient..."
 S BCH("DATE")=0,X=BCH("RUN BEGIN")-1 F  S BCH("DATE")=$O(^BCHR("AEX",BCH("DATE"))) Q:BCH("DATE")=""!(BCH("DATE")>X)  W "." K ^BCHR("AEX",BCH("DATE"))
 W !,"OK ALL DONE",!
 Q
