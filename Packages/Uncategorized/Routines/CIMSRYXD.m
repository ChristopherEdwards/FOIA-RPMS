CIMSRYXD ;CMI [ 04/20/98  1:05 PM ]
 ;
 ;
 ;
START ;Begin processing backload
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  PHOENIX AREA ORYX BACKLOAD PROCESSING  *****" W !,$$CTR(X,80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 W !,"A file will be created and will be placed in the public directory where",!,"all other exports are placed.  It will be called OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_$$NLOG,!
 I $D(^CIMSORY1) W !!,$C(7),$C(7),"CIMSORY1 GLOBAL EXISTS FROM A PREVIOUS RUN - CANNOT CONTINUE" D XIT Q
GETDATES ;
 W !,"Please enter the date range for which the statistical (ORYX) records",!,"should be generated.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S CIMSBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<CIMSBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S CIMSED=Y
 S X1=CIMSBD,X2=-1 D C^%DTC S CIMSSD=X
 S CIMSERR=0
 D CHECK
 I $G(CIMSERR) W !!,"Goodbye",! D XIT Q
 W !!,"Log entry ",$$NLOG," will be created and records generated for visit",!,"date range ",$$FMTE^XLFDT(CIMSBD)," to ",$$FMTE^XLFDT(CIMSED),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S CIMSRUN="NEW",CIMSERR=0
 D HOME^%ZIS S CIMSBS=$S('$D(ZTQUEUED):IOBS,1:"")
 D GENLOG ;generate new log entry
 I $G(CIMSERR) D XIT Q
 D QUEUE
 I $G(CIMSERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(CIMSQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 S CIMSCNT=$S('$D(ZTQUEUED):"X CIMSCNT1  X CIMSCNT2",1:"S CIMSTOTV=CIMSTOTV+1"),CIMSCNT1="F CIMSCNTL=1:1:$L(CIMSTOTV)+1 W @CIMSBS",CIMSCNT2="S CIMSTOTV=CIMSTOTV+1 W CIMSTOTV,"")"""
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)"
 K ^CIMSORY1
 S CIMSSD=CIMSSD_".9999"
 ;set counters
 S (CIMSTOTV,CIMSTERR,CIMSTOTR,CIMSUSED)=0
V ; Run by visit date
 F  S CIMSSD=$O(^AUPNVSIT("B",CIMSSD)) Q:CIMSSD=""!((CIMSSD\1)>CIMSED)  D V1
 S DA=CIMSLOG,DIE="^CIMSORYX(",DR=".05///"_CIMSTOTV_";.06///"_CIMSUSED_";.07///"_CIMSTOTR_";.08///P" D ^DIE K DIE,DA,DR ;no error check
 S ^CIMSORYX(CIMSLOG,11,0)="^19250.0611^0^0"
 S X="",C=0 F  S X=$O(CIMSERRT(X)) Q:X=""  S C=C+1,^CIMSORYX(CIMSLOG,11,C,0)=X_"^"_CIMSERRT(X)
 S DA=CIMSLOG,DIK="^CIMSORYX(" D IX1^DIK K DA,DIK
 D WRITEF
 D XIT
 Q
V1 ;go through each visit on this date
 S CIMSVDFN="" F  S CIMSVDFN=$O(^AUPNVSIT("B",CIMSSD,CIMSVDFN)) Q:CIMSVDFN'=+CIMSVDFN  I $D(^AUPNVSIT(CIMSVDFN,0)) S CIMSVREC=^(0) D PROC
 Q
PROC ;
 X CIMSCNT
 I '$P(CIMSVREC,U,9) S CIMSERRT("ZERO DEP ENTRIES")=$G(CIMSERRT("ZERO DEP ENTRIES"))+1 Q  ;no dependent entries
 I $P(CIMSVREC,U,11) S CIMSERRT("DELETED VISIT")=$G(CIMSERRT("DELETED VISIT"))+1 Q
 I "E"[$P(CIMSVREC,U,7) S CIMSERRT("EVENT VISIT")=$G(CIMSERRT("EVENT VISIT"))+1 Q
 S DFN=$P(CIMSVREC,U,5)
 Q:'DFN
 I $P(^DPT(DFN,0),U)="DEMO,PATIENT" S CIMSERRT("DEMO PATIENT")=$G(CIMSERRT("DEMO PATIENT"))+1 Q
 I '$D(^AUPNVPOV("AD",CIMSVDFN)) S CIMSERRT("NO POV")=$G(CIMSERRT("NO POV"))+1 Q
 I $$PRIMPROV^APCLV(CIMSVDFN,"I")="" S CIMSERRT("NO PRIM PROV")=$G(CIMSERRT("NO PRIM PROV"))+1 Q  ;no primary provider
 S Z=$O(^AUPNVINP("AD",CIMSVDFN,0))
 I $P(CIMSVREC,U,7)="H",'Z S CIMSERRT("NO V HOSP")=$G(CIMSERRT("NO V HOSP"))+1 Q
 I $P(CIMSVREC,U,7)="H",$P($G(^AUPNVINP(Z,0)),U,15) S CIMSERRT("V HOSP NOT READY")=$G(CIMSERRT("V HOSP NOT READY"))+1 Q
 S CIMSX=$$VREC^APCLVDR(CIMSVDFN,"MEGA RECORD 1")
 I CIMSX=-1!(CIMSX="") S CIMSERRT("STAT RECORD ERROR")=$G(CIMSERRT("STAT RECORD ERROR"))+1 Q
 S CIMSX2=$$VREC^APCLVDR(CIMSVDFN,"MEGA RECORD 2")
 I CIMSX2=-1!(CIMSX2="") S CIMSERRT("STAT RECORD ERROR")=$G(CIMSERRT("STAT RECORD ERROR"))+1 Q
 S CIMSX3=$$VREC^APCLVDR(CIMSVDFN,"MEGA RECORD 3")
 I CIMSX3=-1!(CIMSX3="") S CIMSERRT("STAT RECORD ERROR")=$G(CIMSERRT("STAT RECORD ERROR"))+1 Q
 S CIMSUSED=CIMSUSED+1,CIMSTOTR=CIMSTOTR+1
 S ^CIMSORY1(CIMSTOTR)="AD1^"_CIMSX
 S CIMSTOTR=CIMSTOTR+1
 S ^CIMSORY1(CIMSTOTR)="AD2^"_CIMSX2
 S CIMSTOTR=CIMSTOTR+1
 S ^CIMSORY1(CIMSTOTR)="AD3^"_CIMSX3
 Q
CHECK ;
 I $O(^CIMSORYX("AD",CIMSBD,0)) W !!,"One or more of those visit dates has already been processed!  Log entry ",$O(^CIMSORYX("AD",CIMSBD,0)),! W $C(7),$C(7) H 3 S CIMSERR=1 Q
 I $O(^CIMSORYX("AD",CIMSED,0)) W !!,"One or more of those visit dates has already been processed!  Log entry ",$O(^CIMSORYX("AD",CIMSED,0)),! W $C(7),$C(7) H 3 S CIMSERR=1 Q
 S X=CIMSBD F  S X=$$FMADD^XLFDT(X,1) Q:X>CIMSED!(CIMSERR)  I $O(^CIMSORYX("AD",X,0)) W !!,"One or more of those visit dates has already been processed!  Log entry ",$O(^CIMSORYX("AD",X,0)),! W $C(7),$C(7) H 3 S CIMSERR=1 Q
 Q
RERUN ;EP - rerun old log entry
 W:$D(IOF) @IOF
 W !!,"Rerun ORYX Backload Visit Set",!
 ;GET LOG
 S DIC="^CIMSORYX(",DIC(0)="AEMQ" D ^DIC
 K DIC,DA,DD,DO,D0
 I Y=-1 D XIT Q
 S CIMSLOG=+Y
 S CIMSBD=$P(^CIMSORYX(CIMSLOG,0),U,3),CIMSED=$P(^(0),U,4),CIMSSD=$$FMADD^XLFDT(CIMSBD,-1),CIMSRUN="REDO"
 S CIMS0=^CIMSORYX(CIMSLOG,0)
 W !!,"Log entry ",CIMSLOG," will be reprocessed.  Visits in the date range ",!,$$FMTE^XLFDT(CIMSBD)," to ",$$FMTE^XLFDT(CIMSED)," will be processed.",!
 W !,"The output file created will be called OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_CIMSLOG
 W !,"The last time a total of ",$P(CIMS0,U,5)," visits were processed, of which, ",!,$P(CIMS0,U,6)," generated statistical records.",!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 D QUEUE
 I $G(CIMSERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(CIMSQUE) D XIT Q
 ;
RERUN1 ;
 ;reset log entry
 F X=5,6,7 S $P(^CIMSORYX(CIMSLOG,0),U,X)=""
 K ^CIMSORYX(CIMSLOG,11) ;kill error multiple
 S DA=CIMSLOG,DIE="^CIMSORYX(",DR=".02///"_DT D ^DIE K DIE,DR,DA
 S CIMSRUN="REDO",CIMSERR=0
 D HOME^%ZIS S CIMSBS=$S('$D(ZTQUEUED):IOBS,1:"")
 G PROCESS
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I CIMSRUN="NEW",$D(DIRUT) S CIMSERR=1 S DA=CIMSLOG,DIK="^CIMSORYX(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I CIMSRUN="REDO",$D(DIRUT) S CIMSERR=1 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(CIMSRUN="NEW":"PROCESS^CIMSRYXD",1:"RERUN1^CIMSRYXD")
 S ZTIO="",ZTDTH="",ZTDESC="ORYX BACKLOAD" S ZTSAVE("CIMS*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),CIMSRUN="NEW" S CIMSERR=1 S DA=CIMSLOG,DIK="^CIMSORYX" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S CIMSQUE=""
 S DIE="^CIMSORYX(",DA=CIMSLOG,DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
WRITEF ;EP - write out flat file
 I '$D(^CIMSORY1)!(CIMSTOTR=0) W:'$D(ZTQUEUED) !!,"No transactions to send in that date range.",! Q
 S XBGL="CIMSORY1"
 S XBMED="F",XBFN="OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_CIMSLOG,XBTLE="SAVE OF ORYX BACKLOAD RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBF=0,XBQ="N"
 D ^XBGSAVE
 ;check for error
 I XBFLG=-1 S CIMSERR=1 W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) Q
 K ^CIMSORY1
 S DA=CIMSLOG,DIE="^CIMSORYX(",DR=".08///S;.11////OX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_CIMSLOG D ^DIE K DA,DIE,DR
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT
 Q
GENLOG ;generate new log entry
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=$$NLOG S X=""""_Y_"""",DIC="^CIMSORYX(",DIC(0)="L",DLAYGO=19250.06,DIC("DR")=".02////"_DT_";.03////"_CIMSBD_";.04////"_CIMSED_";.09///`"_DUZ(2)
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 W !!,$C(7),$C(7),"Error creating log entry." S CIMSERR=1 Q
 S CIMSLOG=+Y
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("CIMS")
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
 ;
NLOG() ;get next log
 NEW X,L S (X,L)=0 F  S X=$O(^CIMSORYX(X)) Q:X'=+X  S L=X
 Q L+1
SETB ;
 NEW Z S Z=X S ^CIMSORYX("AD",Z,DA)="" F  S Z=$$FMADD^XLFDT(Z,1) Q:Z>$P(^CIMSORYX(DA,0),U,4)  S ^CIMSORYX("AD",Z,DA)=""
 Q
SETE ;
 NEW Z S Z=$P(^CIMSORYX(DA,0),U,3) S ^CIMSORYX("AD",Z,DA)="" F  S Z=$$FMADD^XLFDT(Z,1) Q:Z>X  S ^CIMSORYX("AD",Z,DA)=""
 Q
KILLB ;
 NEW Z S Z=X  K ^CIMSORYX("AD",Z,DA) F Z=$$FMADD^XLFDT(Z,1) Q:Z>$P(^CIMSORYX(DA,0),U,4)  K ^CIMSORYX("AD",Z,DA)
 Q
KILLE ;
 NEW Z S Z=$P(^CIMSORYX(DA,0),U,3) K ^CIMSORYX("AD",Z,DA) F  S Z=$$FMADD^XLFDT(Z,1) Q:Z>X  K ^CIMSORYX("AD",Z,DA)
 Q
INTRO ;introductory text
 ;;This program will generate statistical records (ORYX records) for a visit
 ;;date range that you enter.  A log entry will be created which will log
 ;;the number of visits processed and the number of statistical records
 ;;generated.  You can view this log by doing an Inquire into file 
 ;;ORYX BACKLOAD LOG.
 ;;
 ;;END
