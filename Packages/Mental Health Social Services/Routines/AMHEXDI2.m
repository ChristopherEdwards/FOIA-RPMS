AMHEXDI2 ; IHS/CMI/LAB - OHPRD-TUCSON/EDE AMHDR SPECIFIC INITIALIZATION AUGUST 14, 1992 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 D INFORM^AMHEXDI3 ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:AMH("QFLG")
 D CHKOLD
 Q:AMH("QFLG")
 D CURRUN^AMHEXDI3 ;      Compute run dates for current run.
 Q:AMH("QFLG")
 D CHKMHSS ;    Check MHSS RECORD xref for date range
 Q:AMH("QFLG")
 D CONFIRM ;     Get ok from operator.
 Q:AMH("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
 ;
CHKOLD ;EP - CHECK FOR DATA LEFT BY OLD RUN
 I $D(^AMHSDATA) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^AMHSDATA global exists from a previous GEN or REDO!!" S AMH("QFLG")=32
 I $D(^XTMP("AMHDR")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous GEN!!," S AMH("QFLG")=10
 I $D(^XTMP("AMHREDO")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous REDO!!" S AMH("QFLG")=11
 Q
 ;
 ;
 ;
 ;
GETLOG ;EP GET LAST LOG ENTRY
 S (X,AMH("LAST LOG"))=$P(^AMHXLOG(0),U,3) F  S X=$O(^AMHXLOG(X)) Q:X'=+X  S AMH("LAST LOG")=X
 S X=$S(AMH("LAST LOG")&($D(^AMHXLOG(AMH("LAST LOG")))):AMH("LAST LOG"),1:0) F  S X=$O(^AMHXLOG(X)) Q:X'=+X  S AMH("LAST LOG")=X
 Q:'AMH("LAST LOG")
 D DISPLOG
 Q:$P(^AMHXLOG(AMH("LAST LOG"),0),U,15)="C"
 D ERROR
 Q
ERROR ;
 S AMH("QFLG")=12
 S AMH("PREV STATUS")=$P(^AMHXLOG(AMH("LAST LOG"),0),U,15)
 I AMH("PREV STATUS")="" D EERR Q
 D @(AMH("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S AMH("QFLG")=13
 ;
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last PCC Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
PERR ;
 S AMH("QFLG")=14
 ;
 W !!,$C(7),$C(7),"*****ERROR ENCOUNTERED*****",!,"Whoa!  The Transaction global from the previous run was NEVER successfully",!,"written to an output device (unix uucppublic file, cartridge, diskette).",!
 W !,"You must execute the menu option called 'OUTP (OUTPUT)' before any further",!,"processing."
 W !,"You may also need to determine whether or not the transaction global for ",!,"LOG ENTRY ",AMH("LAST LOG")," was ever received by your Area Office.",!
 Q
RERR ;
 S AMH("QFLG")=15
 ;
 W $C(7),$C(7),!!,"PCC Data Transmission is currently running!!"
 Q
QERR ;
 S AMH("QFLG")=16
 ;
 W !!,$C(7),$C(7),"PCC Data Transmission is already queued to run!!"
 Q
FERR ;
 S AMH("QFLG")=17
 ;
 W !!,$C(7),$C(7),"The last PCC Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^AMHXLOG(AMH("LAST LOG"),0),U) X ^DD("DD") S AMH("LAST BEGIN")=Y S Y=$P(^AMHXLOG(AMH("LAST LOG"),0),U,2) X ^DD("DD") S AMH("LAST END")=Y
 Q:$D(ZTQUEUED)
 W !!,"Last run was for ",AMH("LAST BEGIN")," through ",AMH("LAST END"),"."
 Q
 ;
 ;
CHKMHSS ; CHECK MHSS RECORD "AEX" XREF
 S AMHV("R DATE")=0
 S AMHV("R DATE")=$O(^AMHREC("AEX",AMHV("R DATE")))
 S AMHV("R DATE")=$O(^AMHREC("AEX",0))
 I AMHV("R DATE"),AMHV("R DATE")<AMH("RUN BEGIN") W:'$D(ZTQUEUED) !!,"*** Cross-references exist prior to beginning of date range! ***" S AMH("QFLG")=21 Q
 ;
 S AMHV("R DATE")=AMH("RUN BEGIN")-1
 S AMHV("R DATE")=$O(^AMHREC("AEX",AMHV("R DATE")))
 I AMHV("R DATE")=""!(AMHV("R DATE")>AMH("RUN END")) W:'$D(ZTQUEUED) !!,"*** No MHSS RECORDs within range! ***" S AMH("QFLG")=22 Q
 Q
 ;
CONFIRM ; SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The location for this run is ",$P(^DIC(4,DUZ(2),0),U),"."
CFLP ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) S AMH("QFLG")=99 Q
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 K DIC,DA,DR,DLAYGO,DINUM,DD,X
 S Y=AMH("RUN BEGIN") X ^DD("DD") S X=""""_Y_"""",DIC="^AMHXLOG(",DIC(0)="L",DLAYGO=9002014,DIC("DR")=".02////"_AMH("RUN END")_";.09///`"_DUZ(2)
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 S AMH("QFLG")=23 Q
 S AMH("RUN LOG")=+Y
 K ^AMHSDATA ;TO DATA CENTER, THESE ARE OFFICIAL SCRATCH GLOBALS
 Q
