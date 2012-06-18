APCPDRI2 ; IHS/TUCSON/LAB - OHPRD-TUCSON/EDE APCPDR SPECIFIC INITIALIZATION AUGUST 14, 1992 ; [ 03/29/04  7:53 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,6,7**;APR 03, 1998
 ;IHS/CMI/LAB - patch 1 XTMP
 ;
START ;
 D INFORM^APCPDRI3 ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:APCP("QFLG")
 D CHKOLD
 Q:APCP("QFLG")
 D CURRUN^APCPDRI3 ;      Compute run dates for current run.
 Q:APCP("QFLG")
 D ^APCPREG
 Q:APCP("QFLG")
 D CHKVISIT ;    Check VISIT xref for date range
 Q:APCP("QFLG")
 D CONFIRM ;     Get ok from operator.
 Q:APCP("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
 ;
CHKOLD ;EP - CHECK FOR DATA LEFT BY OLD RUN
 I $D(^BAPCDATA) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^BAPCDATA global exists from a previous GEN or REDO!!" S APCP("QFLG")=32
 I $D(^XTMP("APCPDR")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous GEN!!," S APCP("QFLG")=10
 I $D(^XTMP("APCPREDO")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous REDO!!" S APCP("QFLG")=11
 Q
 ;
 ;
 ;
GETLOG ; GET LAST LOG ENTRY
 S (X,APCP("LAST LOG"))=0 F  S X=$O(^APCPLOG(X)) Q:X'=+X  I '$P(^APCPLOG(X,0),U,27) S APCP("LAST LOG")=X
 ;S X=$S(APCP("LAST LOG")&($D(^APCPLOG(APCP("LAST LOG")))):APCP("LAST LOG"),1:0) F  S X=$O(^APCPLOG(X)) Q:X'=+X  S APCP("LAST LOG")=X
 Q:'APCP("LAST LOG")
 D DISPLOG
 Q:$P(^APCPLOG(APCP("LAST LOG"),0),U,15)="C"
 D ERROR
 Q
ERROR ;
 S APCP("QFLG")=12
 S APCP("PREV STATUS")=$P(^APCPLOG(APCP("LAST LOG"),0),U,15)
 I APCP("PREV STATUS")="" D EERR Q
 D @(APCP("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S APCP("QFLG")=13
 ;
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last PCC Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
PERR ;
 S APCP("QFLG")=14
 ;
 I '$D(ZTQUEUED) W !!,$C(7),$C(7),"*****ERROR ENCOUNTERED*****",!,"Whoa!  The Transaction global from the previous run was NEVER successfully",!,"written to an output device (unix uucppublic file, cartridge, diskette).",!
 W !,"You must execute the menu option called 'OUTP' before any further processing.",!,"You may also need to determine whether or not the transaction global for ",!,"LOG ENTRY ",APCP("LAST LOG")," was ever received by your Area Office.",!
 Q
RERR ;
 S APCP("QFLG")=15
 ;
 W $C(7),$C(7),!!,"PCC Data Transmission is currently running!!"
 Q
QERR ;
 S APCP("QFLG")=16
 ;
 W !!,$C(7),$C(7),"PCC Data Transmission is already queued to run!!"
 Q
FERR ;
 S APCP("QFLG")=17
 ;
 W !!,$C(7),$C(7),"The last PCC Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^APCPLOG(APCP("LAST LOG"),0),U) X ^DD("DD") S APCP("LAST BEGIN")=Y S Y=$P(^APCPLOG(APCP("LAST LOG"),0),U,2) X ^DD("DD") S APCP("LAST END")=Y
 Q:$D(ZTQUEUED)
 W !!,"Last run was for ",APCP("LAST BEGIN")," through ",APCP("LAST END"),"."
 Q
 ;
 ;
CHKVISIT ; CHECK VISIT "APCIS" XREF
 S APCPV("V DATE")=0
 S APCPV("V DATE")=$O(^AUPNVSIT("APCIS",APCPV("V DATE")))
 I $D(APCP("FIRST RUN")) D CHKCR Q:APCP("QFLG")
 S APCPV("V DATE")=$O(^AUPNVSIT("APCIS",0))
 I APCPV("V DATE"),APCPV("V DATE")<APCP("RUN BEGIN") W:'$D(ZTQUEUED) !!,"*** Cross-references exist prior to beginning of date range! ***" S APCP("QFLG")=21 Q
 ;
 S APCPV("V DATE")=APCP("RUN BEGIN")-1
 S APCPV("V DATE")=$O(^AUPNVSIT("APCIS",APCPV("V DATE")))
 I APCPV("V DATE")=""!(APCPV("V DATE")>APCP("RUN END")) W:'$D(ZTQUEUED) !!,"*** No VISITs within range! ***" S APCP("QFLG")=22 Q
 Q
 ;
CONFIRM ; SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The location for this run is ",$P(^DIC(4,DUZ(2),0),U),".",!
CFLP  ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I 'Y S APCP("QFLG")=99
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=APCP("RUN BEGIN") X ^DD("DD") S X=""""_Y_"""",DIC="^APCPLOG(",DIC(0)="L",DLAYGO=9001005,DIC("DR")=".02////"_APCP("RUN END")_";.09///`"_DUZ(2)
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 S APCP("QFLG")=23 Q
 S APCP("RUN LOG")=+Y
 K ^BAPCDATA ;KILLS OKAY PER CMB STANDARDS FOR TRANSMITTING DATA TO DATA CENTER, THESE ARE OFFICIAL SCRATCH GLOBALS
 Q
CHKCR ;
 S Y=APCP("RUN BEGIN") X ^DD("DD") S Z=Y
 I APCPV("V DATE"),APCPV("V DATE")<APCP("RUN BEGIN") D CHKCR1
 Q
CHKCR1 ;
 W !!,"There are cross references entries for visits prior to the date of ",Z,".",!
 W "These could be there because the MCH package was running prior to the start of"
 W !,"PCC Data Entry."
 S DIR(0)="Y",DIR("A")="Are you SURE that PCC Data Entry started on "_Z K DA D ^DIR K DIR
 I $D(DIRUT) S APCP("QFLG")=99 Q
 I 'Y W !,"BYE.." S APCP("QFLG")=99 Q
 D DELCR
 Q
DELCR ;
 W !!,"I will now clean up that cross reference.... Please be patient..."
 S APCP("DATE")=0,X=APCP("RUN BEGIN")-1 F  S APCP("DATE")=$O(^AUPNVSIT("APCIS",APCP("DATE"))) Q:APCP("DATE")=""!(APCP("DATE")>X)  W "." K ^AUPNVSIT("APCIS",APCP("DATE"))
 W !,"OK ALL DONE",!
 Q
