APCPSRE ; IHS/TUCSON/LAB - CMI ; [ 12/16/03  8:07 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**6,7**;APR 03, 1998
 ;
 ;
 ;
START ;Begin processing backload
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  PCC DATA TRANSMISSION SPECIAL RE-EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 W !,"ATTENTION:  This option should ONLY be run if you have had",!,"a special request from ORYX or NPIRS to re-send a large amount of previously",!,"exported data."
 W !,"You should use the GEN and REDO options for all regularly scheduled exports.",!!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S APCPJD=X+1
 S APCP("FILENAME")=""
 I $P(^AUTTSITE(1,0),U,21)=1 S APCP("FILENAME")="BAPC"_$P(^AUTTSITE(1,1),U,3)_"."_APCPJD
 I $P(^AUTTSITE(1,0),U,21)'=1 D
 .I ^%ZOSF("OS")["NT" S APCP("FILENAME")="BAPC"_$P(^AUTTSITE(1,1),U,3)_"."_APCPJD Q
 .S APCP("FILENAME")="BAPC"_$E($P(^AUTTSITE(1,1),U,3),3,6)_"."_APCPJD
 ;S APCP("FILENAME")="BAPC"_$P(^AUTTSITE(1,1),U,3)_"."_APCPJD
 W !,"A file will be created and will be placed in the public directory where",!,"all other exports are placed.  It will be called ",APCP("FILENAME"),!
 I $D(^BAPCDATA) W !!,$C(7),$C(7),"BAPCDATA GLOBAL EXISTS FROM A PREVIOUS RUN - CANNOT CONTINUE" D XIT Q
 I $D(^XTMP("APCPDR")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous GEN!!  Cannot continue." D XIT Q
 I $D(^XTMP("APCPREDO")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous REDO!!  Cannot continue." D XIT Q
 I $D(^XTMP("APCPSRE")) W:'$D(ZTQUEUED) !!,"*** WARNING *** ^XTMP nodes exist from previous DATE RANGE EXPORT!!  Cannot continue." D XIT Q
GETDATES ;
 W !,"Please enter the visit date range for which the export should be done.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCP("RUN BEGIN")=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCP("RUN BEGIN") W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCP("RUN END")=Y
 S X1=APCP("RUN BEGIN"),X2=-1 D C^%DTC S APCPSD=X
 S APCPERR=0
 D CHECK
 I $G(APCPERR) W !!,"Goodbye",! D XIT Q
 W !!,"A Log entry will be created and records generated for visit",!,"date range ",$$FMTE^XLFDT(APCP("RUN BEGIN"))," to ",$$FMTE^XLFDT(APCP("RUN END")),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S APCPO("RUN")="DATE",APCPERR=0
 D HOME^%ZIS S APCPBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K APCPS,APCPV,APCPT,APCPE
 S APCP("RUN LOCATION")=$P(^AUTTLOC(DUZ(2),0),U,10),APCP("QFLG")=0
 S APCDOVRR=1 ; Allow VISIT lookup with 0 'dependent entry count'.
 S (APCP("INPT"),APCP("CHA"),APCP("APC"),APCP("ERROR COUNT"),APCP("COUNT"),APCP("STAT"),APCP("DEL NEVER SENT"),APCP("DEMO PAT"),APCP("IN NO PP"))=0
 D CHKSITE^APCPDRI
 I $G(APCP("QFLG")) W !!,"Exiting.." D XIT Q
 D GENLOG ;generate new log entry
 I 'APCP("RUN LOG") Q
 D QUEUE
 I $G(APCPERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(APCP("QUEUE")) D XIT Q
 ;
PROCESS ;EP - process new run
 S APCPCNT=$S('$D(ZTQUEUED):"X APCPCNT1  X APCPCNT2",1:"S APCPCNTR=APCPCNTR+1"),APCPCNT1="F APCPCNTL=1:1:$L(APCPCNTR)+1 W @APCPBS",APCPCNT2="S APCPCNTR=APCPCNTR+1 W APCPCNTR,"")"""
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)"
 S APCPSD=APCPSD_".9999"
 ;set counters
 S (APCPCNTR,APCPTERR,APCPTOTR,APCPUSED)=0
 D NOW^%DTC S APCP("RUN START")=%,APCP("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S DIE="^APCPLOG(",DA=APCP("RUN LOG"),DR=".24///"_APCP("FILENAME")_";.15///R"_";.03////"_APCP("RUN START") D ^DIE K DA,DIE,DR
V ; Run by visit date
 F  S APCPSD=$O(^AUPNVSIT("B",APCPSD)) Q:APCPSD=""!((APCPSD\1)>APCP("RUN END"))  D V1
 D ^APCPLOG
 D PURGE
 D EN^APCPTAPE
 D XIT
 Q
V1 ;go through each visit on this date
 S APCP("V DFN")="" F  S APCP("V DFN")=$O(^AUPNVSIT("B",APCPSD,APCP("V DFN"))) Q:APCP("V DFN")'=+APCP("V DFN")  I $D(^AUPNVSIT(APCP("V DFN"),0)) S APCP("V REC")=^(0) D PROC
 Q
PROC ;
 K APCPT,APCPV,APCPE
 D KILL^AUPNPAT
 Q:$D(^APCPLOG(APCP("RUN LOG"),21,APCP("V DFN")))
 S APCPV("TX GENERATED")=0,APCPV("STAT TX GEN")=0
 X APCPCNT
 I $P($G(^AUPNVSIT(APCP("V DFN"),11)),U,4)="" S $P(^AUPNVSIT(APCP("V DFN"),11),U,4)=$$UID^AUPNVSIT(APCP("V DFN"))
 S APCPV("V REC")=^AUPNVSIT(APCP("V DFN"),0)
 S APCPV("V DATE")=+APCPV("V REC")\1
 D ^APCPDR2
 S:'$D(^APCPLOG(APCP("RUN LOG"),21,0)) ^APCPLOG(APCP("RUN LOG"),21,0)="^9001005.2101PA^^"
 S ^APCPLOG(APCP("RUN LOG"),21,APCP("V DFN"),0)=APCP("V DFN")_U_APCPV("TX GENERATED")_U_APCPV("DEP COUNT")_U_APCPV("TYPE")_U_APCPV("TX GENERATED")_U_U_APCPV("STAT TX GEN")
 S $P(^APCPLOG(APCP("RUN LOG"),21,0),U,3)=APCP("V DFN"),$P(^(0),U,4)=$P(^(0),U,4)+1
 K DIE,DR,DIC
 Q
PURGE ; PURGE SET .14 FIELD
 W:'$D(ZTQUEUED) !,"Deleting cross-reference entries. (1)"
 S APCPCNTR=0,APCPV("V DFN")=0 ;IHS/CMI/LAB patch 2 set to 0
 F  S APCPV("V DFN")=$O(^XTMP("APCPSRE","MAIN TX",APCPV("V DFN"))) Q:APCPV("V DFN")'=+APCPV("V DFN")  D PURGE2
 K ^XTMP("APCPSRE")
 Q
PURGE2 ;
 S DIE="^AUPNVSIT(",DA=APCPV("V DFN"),DR=".14///"_^XTMP("APCPSRE","MAIN TX",APCPV("V DFN")) D ^DIE K DA,DIE,DR
 X APCPCNT
 Q
 ;
CHECK ;
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I APCPO("RUN")="NEW",$D(DIRUT) S APCPERR=1 S DA=APCPLOG,DIK="^APCPLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I APCPO("RUN")="REDO",$D(DIRUT) S APCPERR=1 Q
 Q
QUEUE1 ;
 S ZTRTN="PROCESS^APCPSRE"
 S ZTIO="",ZTDTH="",ZTDESC="DATA TRANS BACKLOAD" S ZTSAVE("APCP*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),APCPO("RUN")="NEW" S APCPERR=1 S DA=APCP("RUN LOG"),DIK="^APCPLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S APCP("QUEUE")=""
 S DIE="^APCPLOG(",DA=APCP("RUN LOG"),DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
GENLOG ; GENERATE NEW LOG ENTRY
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=APCP("RUN BEGIN") X ^DD("DD") S X=""""_Y_"""",DIC="^APCPLOG(",DIC(0)="L",DLAYGO=9001005,DIC("DR")=".02////"_APCP("RUN END")_";.09///`"_DUZ(2)_";.27///1"
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 W !!,"Error generating log entry" D XIT Q
 S APCP("RUN LOG")=+Y
 K ^BAPCDATA ;KILLS OKAY PER CMB STANDARDS FOR TRANSMITTING DATA TO DATA CENTER, THESE ARE OFFICIAL SCRATCH GLOBALS
 W "Log entry is ",APCP("RUN LOG")
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("APCP")
 D KILL^AUPNPAT
 K APCDOVRR
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Job.  Press Return.",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
DATE(D) ;EP ;IHS/CMI/LAB - new date format - format date in YYYYMMDD format
 I $G(D)="" Q ""
 Q $E(D,1,3)+1700_$E(D,4,7)
 ;
 ;
INTRO ;introductory text
 ;;This program will generate statistical records for a visit
 ;;date range that you enter.  A log entry will be created which will log
 ;;the number of visits processed and the number of statistical records
 ;;generated.  
 ;;
 ;;END
