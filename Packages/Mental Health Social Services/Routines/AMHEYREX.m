AMHEYREX ; IHS/CMI/LAB - CMI ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
START ;Begin processing backload
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  BEHAVIORAL HEALTH RE-EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 W !,"ATTENTION:  This option should ONLY be run if you have had",!,"a special request from IHS to re-send a large amount of previously",!,"exported data."
 W !,"You should use the GEN and REDO options for all regularly scheduled exports.",!!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
CHKSITE ; CHECK SITE FILE
 I '$D(^AMHSITE(DUZ(2),0)) W !!,"*** Site file has not been setup! ***" S AMH("QFLG")=1 Q
 I '$D(^AMHSITE(DUZ(2))) W !!,"*** RUN LOCATION not in SITE file!" S AMH("QFLG")=2 Q
 I $D(^XTMP("AMHEXRL",$J)) W !!,"xtmp nodes around from previous run......" D XIT Q
 W !,"A file will be created and will be placed in the public directory where",!,"all other exports are placed.  It will be called AMHX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_$$NLOG,!
 I $D(^BHSXDATA) W !!,$C(7),$C(7),"BHSXDATA GLOBAL EXISTS FROM A PREVIOUS RUN - CANNOT CONTINUE" D XIT Q
GETDATES ;
 W !,"Please enter the date range for which the records should be generated.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date",DIR("?")="Enter the beginning date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S AMHBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<AMHBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHERR=0
 W !!,"Log entry ",$$NLOG," will be created and records generated for visit",!,"date range ",$$FMTE^XLFDT(AMHBD)," to ",$$FMTE^XLFDT(AMHED),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S AMHRUN="NEW",AMHERR=0
 D HOME^%ZIS S AMHBS=$S('$D(ZTQUEUED):IOBS,1:"")
 D GENLOG ;generate new log entry
 I $G(AMHERR) D XIT Q
 D QUEUE
 I $G(AMHERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(AMHQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 S AMHCNT=$S('$D(ZTQUEUED):"X AMHCNT1  X AMHCNT2",1:"S AMHTOTV=AMHTOTV+1"),AMHCNT1="F AMHCNTL=1:1:$L(AMHTOTV)+1 W @AMHBS",AMHCNT2="S AMHTOTV=AMHTOTV+1 W AMHTOTV,"")"""
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)"
 K ^BHSXDATA
 S AMHSD=AMHSD_".9999"
 ;set counters
 S (AMHTOTV,AMHTERR,AMHTOTR,AMHUSED,AMH("ENC"),AMH("COUNT"),AMH("ERROR COUNT"))=0 K AMHERRT
V ; Run by visit date
 F  S AMHSD=$O(^AMHREC("B",AMHSD)) Q:AMHSD=""!((AMHSD\1)>AMHED)  D V1
SF ;
 W:'$D(ZTQUEUED) !,"Generating suicide forms..."
 S AMHCNTR=0,AMH("CONTROL DATE")="",AMHSFC=0
 S AMHSD=AMHSD_".9999"
 F  S AMHSD=$O(^AMHPSUIC("AD",AMHSD)) Q:AMHSD=""!(AMHSD>AMHED)  D
 .S AMHSFIEN=0 F  S AMHSFIEN=$O(^AMHPSUIC("AD",AMHSD,AMHSFIEN)) Q:AMHSFIEN'=+AMHSFIEN  D
 ..I '$D(^AMHPSUIC(AMHSFIEN,0)) K ^AMHPSUIC("AD",AMHSD,AMHSFIEN) Q
 ..S AMHSREC=^AMHPSUIC(AMHSFIEN,0)
 ..S DFN=$P(AMHSREC,U,4)
 ..S AMHRIEN=$O(^AMHRECD("B","BH2",0))
 ..I 'AMHRIEN Q
 ..S AMHY=0,AMHTX="" F  S AMHY=$O(^AMHRECD(AMHRIEN,11,"B",AMHY)) Q:AMHY'=+AMHY  D
 ...S X=""
 ...S AMHZ=$O(^AMHRECD(AMHRIEN,11,"B",AMHY,0))
 ...Q:'$D(^AMHRECD(AMHRIEN,11,AMHZ,1))
 ...X ^AMHRECD(AMHRIEN,11,AMHZ,1)
 ...S $P(AMHTX,U,AMHY)=X
 ..S AMH("COUNT")=AMH("COUNT")+1,AMHSFC=AMHSFC+1
 ..S ^XTMP("AMHEXRL",$J,"SF",AMHSFIEN)=""
 ..S ^BHSXDATA(AMH("COUNT"))=AMHTX
 S DA=AMHLOG,DIE="^AMHEXRL(",DR=".05///"_AMHTOTR_";.06///"_AMH("ERROR COUNT")_";.07///"_AMH("COUNT")_";.08///P;.12////"_AMHSFC_";.13////"_AMH("ENC") D ^DIE K DIE,DA,DR ;no error check
 S ^AMHEXRL(AMHLOG,11,0)="^9001005.41A^0^0"
 S X="",C=0 F  S X=$O(AMHERRT(X)) Q:X=""  S C=C+1,^AMHEXRL(AMHLOG,11,C,0)=X_"^"_AMHERRT(X)
 S DA=AMHLOG,DIK="^AMHEXRL(" D IX1^DIK K DA,DIK
 D WRITEF
 D RESET
 D XIT
 Q
V1 ;go through each visit on this date
 S AMHR="" F  S AMHR=$O(^AMHREC("B",AMHSD,AMHR)) Q:AMHR'=+AMHR  I $D(^AMHREC(AMHR,0)) S AMHVREC=^(0) D PROC
 Q
PROC ;
GENREC ;generate record
 K AMHT,AMHV,AMHE
 D KILL^AUPNPAT
 X AMHCNT
 S AMHREC=^AMHREC(AMHR,0)
 S AMHV("R DATE")=+AMHREC\1
 S AMHTOTR=AMHTOTR+1
 K AMHE,AMHTX D RECORD^AMHEYD2
 D CNTBUILD
 D ^XBFMK
 Q
CNTBUILD ;count and build tx
 I AMHE]"" S AMH("ERROR COUNT")=AMH("ERROR COUNT")+1 D ERRLOG Q
 S ^XTMP("AMHEXRL",$J,"VISITS",AMHR)=""
 S AMH("COUNT")=AMH("COUNT")+1
 S ^BHSXDATA(AMH("COUNT"))=AMHTX
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I AMHRUN="NEW",$D(DIRUT) S AMHERR=1 S DA=AMHLOG,DIK="^AMHEXRL(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I AMHRUN="REDO",$D(DIRUT) S AMHERR=1 Q
 Q
QUEUE1 ;
 S ZTRTN="PROCESS^AMHEYREX"
 S ZTIO="",ZTDTH="",ZTDESC="BH EXPORT DATE RANGE" S ZTSAVE("AMH*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),AMHRUN="NEW" S AMHERR=1 S DA=AMHLOG,DIK="^AMHEXRL(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S AMHQUE=""
 S DIE="^AMHEXRL(",DA=AMHLOG,DR=".08///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
WRITEF ;EP - write out flat file
 I '$D(^BHSXDATA) W:'$D(ZTQUEUED) !!,"No transactions to send in that date range.",! Q
 S XBGL="BHSXDATA"
 S AMHTX="BH0"
 S $P(AMHTX,U,2)=$P($G(^AUTTSITE(1,1)),U,3)
 S $P(AMHTX,U,3)=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),1)),U,3)
 S $P(AMHTX,U,4)=$P(^DIC(4,$P(^AUTTSITE(1,0),U),0),U)
 S $P(AMHTX,U,5)=$$DATE^AMHUTIL(DT)
 S $P(AMHTX,U,6)=$$DATE^AMHUTIL($P(^AMHEXRL(AMHLOG,0),U,3))
 S $P(AMHTX,U,7)=$$DATE^AMHUTIL($P(^AMHEXRL(AMHLOG,0),U,4))
 S $P(AMHTX,U,8)="R"
 S $P(AMHTX,U,9)=$P(^AMHEXRL(AMHLOG,0),U,7)
 S $P(AMHTX,U,10)=$P(^AMHEXRL(AMHLOG,0),U,13)
 S $P(AMHTX,U,11)=$P(^AMHEXRL(AMHLOG,0),U,12)
 S ^BHSXDATA(0)=AMHTX
 S XBMED="F",XBFN="BHSX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_AMHLOG,XBTLE="SAVE OF BH BACKLOAD RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBF="",XBQ="N"
 D ^XBGSAVE
 ;check for error
 I XBFLG=-1 S AMHERR=1 W:'$D(ZTQUEUED) !,$C(7),$C(7),XBFLG(1) Q
 K ^BHSXDATA
 S DA=AMHLOG,DIE="^AMHEXRL(",DR=".08///S;.11////AMHX"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_AMHLOG D ^DIE K DA,DIE,DR
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT
 Q
GENLOG ;generate new log entry
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S Y=$$NLOG S X=""""_Y_"""",DIC="^AMHEXRL(",DIC(0)="L",DLAYGO=9002014.6,DIC("DR")=".02////"_DT_";.03////"_AMHBD_";.04////"_AMHED_";.09///`"_DUZ(2)
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 W !!,$C(7),$C(7),"Error creating log entry." S AMHERR=1 Q
 S AMHLOG=+Y
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("AMH")
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
 NEW X,L S (X,L)=0 F  S X=$O(^AMHEXRL(X)) Q:X'=+X  S L=X
 Q L+1
INTRO ;introductory text
 ;;This program will generate Behavioral Health export records for a visit
 ;;date range that you enter.  Suicide forms entered in the date range
 ;;will also be exported.  A log entry will be created which will log
 ;;the number of visits processed and the number of records
 ;;generated.  
 ;;
 ;;END
RESET ; PURGE 'AEX' XREF FOR MHSS RECORDS JUST DONE
 W:'$D(ZTQUEUED) !,"RE-setting export date. (1)"
 S AMHCNTR=0,AMHR=""
 F  S AMHR=$O(^XTMP("AMHEXRL",$J,"VISITS",AMHR)) Q:AMHR'=+AMHR  D RESET1
 D PURGESF
 K ^XTMP("AMHEXRL",$J)
 Q
 ;
RESET1 ; kill MHSS xref and set flag if tx 23 or 24 generated
 S DIE="^AMHREC(",DA=AMHR,DR=".24///"_DT D CALLDIE^AMHLEIN
 X AMHCNT
 Q
 ;
PURGESF ; PURGE 'AEX' XREF FOR MHSS RECORDS JUST DONE
 S AMHCNTR=0,AMHR=0
 F  S AMHR=$O(^XTMP("AMHEXRL",$J,"SF",AMHR)) Q:AMHR'=+AMHR  D RESETSF
 Q
RESETSF ; kill MHSS xref and set flag if tx 23 or 24 generated
 S DA=AMHR,DIE="^AMHPSUIC(",DR=".23////"_DT D CALLDIE^AMHLEIN
 X AMHCNT
 Q
ERRLOG ;
 S AMHERRTX=$O(^AMHERR("B",AMHE,0)) I AMHERRTX="" S AMHERRT("UNKNOWN ERROR")=$G(AMHERRT("UNKNOWN ERROR"))+1
 S AMHERRTX=$P(^AMHERR(AMHERRTX,0),U,2) I AMHERRTX="" S AMHERRT("UNKNOWN ERROR")=$G(AMHERRT("UNKNOWN ERROR"))+1
 S AMHERRT(AMHERRTX)=$G(AMHERRT(AMHERRTX))+1
 Q
