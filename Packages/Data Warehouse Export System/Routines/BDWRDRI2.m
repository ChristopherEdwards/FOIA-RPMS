BDWRDRI2 ; IHS/CMI/LAB - INIT FOR DW EXPORT ;
 ;;1.0;IHS DATA WAREHOUSE;**1,2**;JAN 23, 2006
 ;IHS/CMI/LAB - patch 1 XTMP
 ;
START ;
 D INFORM ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:BDW("QFLG")
 D CHKOLD
 Q:BDW("QFLG")
 D CURRUN ;      Compute run dates for current run.
 Q:BDW("QFLG")
 D CHKVISIT ;    Check VISIT xref for date range
 Q:BDW("QFLG")
 D CONFIRM ;     Get ok from operator.
 Q:BDW("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
 ;
CHKOLD ;EP - CHECK FOR DATA LEFT BY OLD RUN
 I $D(^XTMP("BDWDR")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous GEN!!," S BDW("QFLG")=10
 I $D(^XTMP("BDWREDO")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous REDO!!" S BDW("QFLG")=11
 Q
 ;
 ;
 ;
GETLOG ;EP GET LAST LOG ENTRY
 S (X,BDW("LAST LOG"))=0 F  S X=$O(^BDWXLOG(X)) Q:X'=+X  I $P(^BDWXLOG(X,0),U,7)="R" S BDW("LAST LOG")=X
 Q:'BDW("LAST LOG")
 D DISPLOG
 Q:$P(^BDWXLOG(BDW("LAST LOG"),0),U,15)="C"
 D ERROR
 Q
ERROR ;
 S BDW("QFLG")=12
 S BDW("PREV STATUS")=$P(^BDWXLOG(BDW("LAST LOG"),0),U,15)
 I BDW("PREV STATUS")="" D EERR Q
 D @(BDW("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S BDW("QFLG")=13
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
RERR ;
 S BDW("QFLG")=15
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"Data Warehouse Transmission is currently running!!"
 Q
QERR ;
 S BDW("QFLG")=16
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"Data Warehouse Transmission is already queued to run!!"
 Q
FERR ;
 S BDW("QFLG")=17
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"The last DATA WAREHOUSE Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^BDWXLOG(BDW("LAST LOG"),0),U) X ^DD("DD") S BDW("LAST BEGIN")=Y S Y=$P(^BDWXLOG(BDW("LAST LOG"),0),U,2) X ^DD("DD") S BDW("LAST END")=Y
 Q:$D(ZTQUEUED)
 W !!,"Last run was for ",BDW("LAST BEGIN")," through ",BDW("LAST END"),"."
 Q
 ;
 ;
CHKVISIT ;EP CHECK VISIT "ADWO" XREF
 S BDWV("V DATE")=0
 S BDWV("V DATE")=$O(^AUPNVSIT("ADWO",BDWV("V DATE")))
 S BDWV("V DATE")=$O(^AUPNVSIT("ADWO",0))
 I BDWV("V DATE"),BDWV("V DATE")<BDW("RUN BEGIN") W:'$D(ZTQUEUED) !!,"*** Cross-references exist prior to beginning of date range! ***" S BDW("QFLG")=21 Q
 ;
 S BDWV("V DATE")=BDW("RUN BEGIN")-1
 S BDWV("V DATE")=$O(^AUPNVSIT("ADWO",BDWV("V DATE")))
 ;I BDWV("V DATE")=""!(BDWV("V DATE")>BDW("RUN END")) W:'$D(ZTQUEUED) !!,"*** No VISITs within range! ***" S BDW("QFLG")=22 Q
 Q
 ;
CONFIRM ;EP SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The location for this run is ",$P(^DIC(4,DUZ(2),0),U),".",!
CFLP  ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I 'Y S BDW("QFLG")=99
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 D ^XBFMK K DIADD
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=BDW("RUN BEGIN") X ^DD("DD") S X=""""_Y_"""",DIC="^BDWXLOG(",DIC(0)="L",DLAYGO=90213,DIC("DR")=".02////"_BDW("RUN END")_";.07////R;.09///`"_DUZ(2)_";8801////"_DUZ,DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 S BDW("QFLG")=23 D ^XBFMK Q
 S BDW("RUN LOG")=+Y
 D ^XBFMK
 Q
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This routine will generate IHS Data Warehouse HL7 messages"
 W !,"for visits posted between a specified range of dates.  You may ""^"" out at any",!,"prompt and will be ask to confirm your entries prior to generating transactions."
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BDW("RUN BEGIN")=""
 I BDW("LAST LOG") S X1=$P(^BDWXLOG(BDW("LAST LOG"),0),U,2),X2=1 D C^%DTC S BDW("RUN BEGIN")=X,Y=X D DD^%DT
 I BDW("RUN BEGIN")="" D FIRSTRUN
 Q:BDW("QFLG")
 S Y=$$FMADD^XLFDT(DT,-1)
 I Y<BDW("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!  There is no new date to send.",$C(7) S BDW("QFLG")=18 Q
 S BDW("RUN END")=Y
 S Y=BDW("RUN BEGIN") X ^DD("DD") S BDW("X")=Y
 S Y=BDW("RUN END") X ^DD("DD") S BDW("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",BDW("X")," through ",BDW("Y"),"."
 K %,%H,%I,BDW("RDFN"),BDW("X"),BDW("Y"),BDW("LAST LOG"),BDW("LAST BEGIN"),BDW("Z"),BDW("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(BDWO("SCHEDULED")) S BDW("QFLG")=12 Q
 W !!,"No log entry.  First run ever assumed (excluding date range re-exports).",!
 S BDW("RUN BEGIN")=$O(^AUPNVSIT("ADWO",0))
 I BDW("RUN BEGIN")="" S BDW("RUN BEGIN")=$$FMADD^XLFDT($P(^BDWSITE(1,0),U,4),1)
 S BDW("FIRST RUN")=1
 Q
 ;
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 S BDW("QFLG1")=$O(^BDWERRC("B",BDW("QFLG"),"")),BDW("QFLG DES")=$P(^BDWERRC(BDW("QFLG1"),0),U,2)
 S XMB(2)=BDW("QFLG"),XMB(3)=BDW("QFLG DES")
 S XMB(4)=$S($D(BDW("RUN LOG")):BDW("RUN LOG"),1:"< NONE >")
 I '$D(BDW("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=BDW("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="BDW DW TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,BDW("QFLG1"),BDW("QFLG DES"),XMDUZ
 Q
