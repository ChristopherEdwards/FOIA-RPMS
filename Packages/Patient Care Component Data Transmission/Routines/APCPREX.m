APCPREX ; IHS/TUCSON/LAB - CMI ; [ 08/18/2003   7:44 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**3,6**;APR 03, 1998
 ;
 ;
 ;
START ;Begin processing backload
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  PCC DATA TRANSMISSION RE-EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 W !,"ATTENTION:  This option should ONLY be run if you have had",!,"a special request from ORYX or NPIRS to re-send a large amount of previously",!,"exported data."
 W !,"You should use the GEN and REDO options for all regularly scheduled exports.",!!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 W !,"A file will be created and will be placed in the public directory where",!,"all other exports are placed.  It will be called OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_$$NLOG,!
 I $D(^APCPDATA) W !!,$C(7),$C(7),"APCPDATA GLOBAL EXISTS FROM A PREVIOUS RUN - CANNOT CONTINUE" D XIT Q
GETDATES ;
 W !,"Please enter the date range for which the statistical (ORYX) records",!,"should be generated.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCPBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCPBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCPED=Y
 S X1=APCPBD,X2=-1 D C^%DTC S APCPSD=X
 S APCPERR=0
 D CHECK
 I $G(APCPERR) W !!,"Goodbye",! D XIT Q
 W !!,"Log entry ",$$NLOG," will be created and records generated for visit",!,"date range ",$$FMTE^XLFDT(APCPBD)," to ",$$FMTE^XLFDT(APCPED),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S APCPRUN="NEW",APCPERR=0
 D HOME^%ZIS S APCPBS=$S('$D(ZTQUEUED):IOBS,1:"")
 D GENLOG ;generate new log entry
 I $G(APCPERR) D XIT Q
 D QUEUE
 I $G(APCPERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(APCPQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 S APCPCNT=$S('$D(ZTQUEUED):"X APCPCNT1  X APCPCNT2",1:"S APCPTOTV=APCPTOTV+1"),APCPCNT1="F APCPCNTL=1:1:$L(APCPTOTV)+1 W @APCPBS",APCPCNT2="S APCPTOTV=APCPTOTV+1 W APCPTOTV,"")"""
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)"
 K ^APCPDATA
 S APCPSD=APCPSD_".9999"
 ;set counters
 S (APCPTOTV,APCPTERR,APCPTOTR,APCPUSED)=0
V ; Run by visit date
 F  S APCPSD=$O(^AUPNVSIT("B",APCPSD)) Q:APCPSD=""!((APCPSD\1)>APCPED)  D V1
 S DA=APCPLOG,DIE="^APCPREX(",DR=".05///"_APCPTOTV_";.06///"_APCPUSED_";.07///"_APCPTOTR_";.08///P" D ^DIE K DIE,DA,DR ;no error check
 S ^APCPREX(APCPLOG,11,0)="^9001005.41A^0^0"
 S X="",C=0 F  S X=$O(APCPERRT(X)) Q:X=""  S C=C+1,^APCPREX(APCPLOG,11,C,0)=X_"^"_APCPERRT(X)
 S DA=APCPLOG,DIK="^APCPREX(" D IX1^DIK K DA,DIK
 D WRITEF
 D XIT
 Q
V1 ;go through each visit on this date
 S APCP("V DFN")="" F  S APCP("V DFN")=$O(^AUPNVSIT("B",APCPSD,APCP("V DFN"))) Q:APCP("V DFN")'=+APCP("V DFN")  I $D(^AUPNVSIT(APCP("V DFN"),0)) S APCPVREC=^(0) D PROC
 Q
PROC ;
 X APCPCNT
 I '$P(APCPVREC,U,9) S APCPERRT("ZERO DEP ENTRIES")=$G(APCPERRT("ZERO DEP ENTRIES"))+1 Q  ;no dependent entries
 I $P(APCPVREC,U,11) S APCPERRT("DELETED VISIT")=$G(APCPERRT("DELETED VISIT"))+1 Q
 I $P(APCPVREC,U,23)=.5 Q  ;MFI CREATED VISIT
 S APCPV("SRV CAT")=$P(APCPVREC,U,7),APCPV("TYPE")=$P(APCPVREC,U,3)
 S DFN=$P(APCPVREC,U,5)
 I 'DFN S APCPERRT("NO PATIENT")=$G(APCPERRT("NO PATIENT"))+1 Q
 I $P(^DPT(DFN,0),U)["DEMO,PATIENT" S APCPERRT("DEMO PATIENT")=$G(APCPERRT("DEMO PATIENT"))+1 Q
 I '$D(^AUPNVPOV("AD",APCP("V DFN"))),"EI"'[APCPV("SRV CAT") S APCPERRT("NO POV")=$G(APCPERRT("NO POV"))+1 Q
 I $$PRIMPROV^APCLV(APCP("V DFN"),"I")="","EI"'[APCPV("SRV CAT") S APCPERRT("NO PRIM PROV")=$G(APCPERRT("NO PRIM PROV"))+1 Q  ;no primary provider
 I APCPV("SRV CAT")="H","CVO"'[APCPV("TYPE") D  Q:'Y
 .S Y=0 S Z=$O(^AUPNVINP("AD",APCP("V DFN"),0))
 .I 'Z S APCPERRT("NO V HOSP")=$G(APCPERRT("NO V HOSP"))+1 Q
 .I $P($G(^AUPNVINP(Z,0)),U,15) S APCPERRT("HOSP VISIT NOT CODED")=$G(APCPERRT("HOSP VISIT NOT CODED"))+1 Q
 .S Y=1
 .Q
GENREC ;generate record
 D GENREC^APCPREX2
 Q
CHECK ;
 Q
RERUN ;EP - rerun old log entry
 W:$D(IOF) @IOF
 W !!,"Rerun DATA TRANSMISSION Backload Visit Set",!
 ;GET LOG
 S DIC="^APCPREX(",DIC(0)="AEMQ" D ^DIC
 K DIC,DA,DD,DO,D0
 I Y=-1 D XIT Q
 S APCPLOG=+Y
 S APCPBD=$P(^APCPREX(APCPLOG,0),U,3),APCPED=$P(^(0),U,4),APCPSD=$$FMADD^XLFDT(APCPBD,-1),APCPRUN="REDO"
 S APCP0=^APCPREX(APCPLOG,0)
 W !!,"Log entry ",APCPLOG," will be reprocessed.  Visits in the date range ",!,$$FMTE^XLFDT(APCPBD)," to ",$$FMTE^XLFDT(APCPED)," will be processed.",!
 W !,"The output file created will be called OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_APCPLOG
 W !,"The last time a total of ",$P(APCP0,U,5)," visits were processed, of which, ",!,$P(APCP0,U,6)," generated statistical records.",!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 D QUEUE
 I $G(APCPERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(APCPQUE) D XIT Q
 ;
RERUN1 ;
 ;reset log entry
 F X=5,6,7 S $P(^APCPREX(APCPLOG,0),U,X)=""
 K ^APCPREX(APCPLOG,11) ;kill error multiple
 S DA=APCPLOG,DIE="^APCPREX(",DR=".02///"_DT D ^DIE K DIE,DR,DA
 S APCPRUN="REDO",APCPERR=0
 D HOME^%ZIS S APCPBS=$S('$D(ZTQUEUED):IOBS,1:"")
 G PROCESS
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I APCPRUN="NEW",$D(DIRUT) S APCPERR=1 S DA=APCPLOG,DIK="^APCPREX(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I APCPRUN="REDO",$D(DIRUT) S APCPERR=1 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(APCPRUN="NEW":"PROCESS^APCPREX",1:"RERUN1^APCPREX")
 S ZTIO="",ZTDTH="",ZTDESC="ORYX BACKLOAD" S ZTSAVE("APCP*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),APCPRUN="NEW" S APCPERR=1 S DA=APCPLOG,DIK="^APCPREX(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S APCPQUE=""
 S DIE="^APCPREX(",DA=APCPLOG,DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
WRITEF ;EP - write out flat file
 I '$D(^APCPDATA)!(APCPTOTR=0) W:'$D(ZTQUEUED) !!,"No transactions to send in that date range.",! Q
 S XBGL="APCPDATA"
 S ^APCPDATA(0)=$P(^AUTTLOC(DUZ(2),0),U,10)_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$$DATE($E(DT,1,7))_"^"_$$DATE(APCPBD)_"^"_$$DATE(APCPED)_"^^"_APCPTOTR_"^^" ;IHS/CMI/LAB - new date format
 S XBMED="F",XBFN="OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_APCPLOG,XBTLE="SAVE OF SDB BACKLOAD RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBF="",XBQ="N"
 D ^XBGSAVE
 ;check for error
 I XBFLG=-1 S APCPERR=1 W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) Q
 K ^APCPDATA
 S DA=APCPLOG,DIE="^APCPREX(",DR=".08///S;.11////OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_APCPLOG D ^DIE K DA,DIE,DR
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT
 Q
GENLOG ;generate new log entry
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=$$NLOG S X=""""_Y_"""",DIC="^APCPREX(",DIC(0)="L",DLAYGO=9001005.4,DIC("DR")=".02////"_DT_";.03////"_APCPBD_";.04////"_APCPED_";.09///`"_DUZ(2)
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 W !!,$C(7),$C(7),"Error creating log entry." S APCPERR=1 Q
 S APCPLOG=+Y
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("APCP")
 D KILL^AUPNPAT
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
NLOG() ;get next log
 NEW X,L S (X,L)=0 F  S X=$O(^APCPREX(X)) Q:X'=+X  S L=X
 Q L+1
INTRO ;introductory text
 ;;This program will generate statistical records (ORYX records) for a visit
 ;;date range that you enter.  A log entry will be created which will log
 ;;the number of visits processed and the number of statistical records
 ;;generated.  
 ;;
 ;;END
