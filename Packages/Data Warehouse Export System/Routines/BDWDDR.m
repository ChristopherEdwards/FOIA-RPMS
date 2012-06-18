BDWDDR ;IHS/CMI/LAB - Main Driver EXPORT DATE RANGE;
 ;;1.0;IHS DATA WAREHOUSE;**2**;JAN 23, 2006
 ;
 ;
 ;
START ;Begin processing backload
 D EN^XBVK("BDW"),^XBFMK K DIADD,DLAYGO
 S BDW("QFLG")=0
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  IHS DATA WAREHOUSE VISIT RE-EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 S BDWERR=0
 D CHECK
 D CHKSITE^BDWRDRI
 I BDW("QFLG") D XIT Q
 I BDWERR D XIT Q
GETDATES ;
 W !,"Please enter the date range for which the Data Warehouse HL7 messages",!,"should be generated.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S BDWBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<BDWBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDWED=Y
 S X1=BDWBD,X2=-1 D C^%DTC S BDWSD=X
 S BDWERR=0
 W !!,"Log entry ",$$NLOG," will be created and messages generated for visit",!,"date range ",$$FMTE^XLFDT(BDWBD)," to ",$$FMTE^XLFDT(BDWED),".",!
VAUDIT ;
 S BDWVA=""
 S DIR(0)="Y",DIR("A")="Do you want to create a VISIT AUDIT report for this batch of visits",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 I Y S BDWVA=1
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S BDWRUN="NEW",BDWERR=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 D GENLOG ;generate new log entry
 I $G(BDWERR) D XIT Q
 D QUEUE
 I $G(BDWERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(BDWQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 D GIS^BDW1VBLI
 S BDWDDR=1
 S BDWTOTV=0
 K ^TMP($J,"BDW")
 K BDW,BDWERRC,BDWE
 D BASICS^BDWRDRI
 S BDW("RUN LOG")=BDWLOG
 D NOW^%DTC S BDW("RUN START")=%,BDW("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BDW("BT")=$H
 S BDWMSGH=$$DW1HDR^BHLEVENT(90213,BDWLOG)
 S ^BDWTMP(BDWIEDST,BDWMSGH)=""
 S DIE="^BDWXLOG(",DA=BDWLOG,DR=".15///R;.03////"_BDW("RUN START")_";.12////"_BDWMSGH D ^DIE K DA,DIE,DR
 S BDWCNT=$S('$D(ZTQUEUED):"X BDWCNT1  X BDWCNT2",1:"S BDWTOTV=BDWTOTV+1"),BDWCNT1="F BDWCNTL=1:1:$L(BDWTOTV)+1 W @BDWBS",BDWCNT2="S BDWTOTV=BDWTOTV+1 W BDWTOTV,"")"""
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)"
 S BDWSD=BDWSD_".9999"
 ;set counters
V ; Run by visit date
 F  S BDWSD=$O(^AUPNVSIT("B",BDWSD)) Q:BDWSD=""!((BDWSD\1)>BDWED)  D V1
 ;update log
 D ^XBFMK
 D RUNTIME^BDWRDR
 D LOG
 S X=$$WRITE
SETV ;set 1106
 S BDWTOTV=0
 I '$D(ZTQUEUED) W !,"Updating visit entries with export date....("
 S BDW("V DFN")=0 F  S BDW("V DFN")=$O(^TMP($J,"BDW",BDW("V DFN"))) Q:BDW("V DFN")'=+BDW("V DFN")  D ^XBFMK S DA=BDW("V DFN"),DIE="^AUPNVSIT(",DR="1106////"_BDW("MAIN TX DATE") D ^DIE,^XBFMK X BDWCNT
 D XIT
 Q
V1 ;go through each visit on this date
 S BDW("V DFN")="" F  S BDW("V DFN")=$O(^AUPNVSIT("B",BDWSD,BDW("V DFN"))) Q:BDW("V DFN")'=+BDW("V DFN")  I $D(^AUPNVSIT(BDW("V DFN"),0)) S BDWVREC=^(0) D PROC
 Q
PROC ;
 Q:$P(^AUPNVSIT(BDW("V DFN"),0),U,23)=.5
 ;if no unique ID, stuff it
 I $P($G(^AUPNVSIT(BDW("V DFN"),11)),U,4)="" D ^XBFMK S DIE="^AUPNVSIT(",DA=BDW("V DFN"),DR="1104////"_$$UID^AUPNVSIT(BDW("V DFN")) D ^DIE,^XBFMK
 I $P($G(^AUPNVSIT(BDW("V DFN"),11)),U,4)="" D ^XBFMK S DIE="^AUPNVSIT(",DA=BDW("V DFN"),DR="1114////"_$$UIDV^BDWAID(BDW("V DFN")) D ^DIE,^XBFMK  ;cmi/anch/maw 9/6/2007 patch 2
 S BDWV("TX GENERATED")=0,^TMP($J,"BDW",BDW("V DFN"))=""
 S BDW("VPROC")=$G(BDW("VPROC"))+1
 X BDWCNT
 S BDWV("V REC")=^AUPNVSIT(BDW("V DFN"),0)
 I $P(BDWV("V REC"),U,11),$P($G(^AUPNVSIT(BDW("V DFN"),11)),U,6)="" D  G SET
 .S BDWE("ERROR")=100 D ^BDWRERR
 S BDWV("V DATE")=+BDWV("V REC")\1
 K BDWVMSG D ^BDWRDR2
SET S:'$D(^BDWXLOG(BDW("RUN LOG"),21,0)) ^BDWXLOG(BDW("RUN LOG"),21,0)="^90213.2101PA^^"
 S ^BDWXLOG(BDW("RUN LOG"),21,BDW("V DFN"),0)=BDW("V DFN")_U_BDWV("TX GENERATED")_U_$G(BDWVMSG)
 S $P(^BDWXLOG(BDW("RUN LOG"),21,0),U,3)=BDW("V DFN"),$P(^(0),U,4)=$P(^(0),U,4)+1
 K DIE,DR,DIC
 I BDWVA,'$D(BDWE) D VA^BDW1VBL2
 Q
 ;
LOG ;
 S BDW("COUNT")=BDW("VISITS") W:'$D(ZTQUEUED) !!,BDW("COUNT")," HL7 Messages were generated."
 W:'$D(ZTQUEUED) !,"Updating log entry."
 D NOW^%DTC S BDW("RUN STOP")=%
 S DA=BDW("RUN LOG"),DIE="^BDWXLOG(",DR=".04////"_BDW("RUN STOP")_";.05////"_BDW("SKIP")_";.06////"_BDW("COUNT")_";.08///"_BDW("VPROC") D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 K DIE,DA,DR
 S DA=BDW("RUN LOG"),DIE="^BDWXLOG(",DR=".11////"_BDW("REG")_";.12////"_BDWMSGH_";.18////"_$G(BDW("VISITS")) D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 K DR,DIE,DA,DIV,DIU
 S DIE="^BDWXLOG(",DA=BDW("RUN LOG"),DR="3101////"_BDW("DEMO")_";3102////"_BDW("ZERO")_";3103////"_BDW("DEL")_";3104////"_BDW("NO PAT")_";3105////"_BDW("NO LOC")_";3106////"_BDW("NO TYPE")_";3107////"_BDW("NO CAT")_";3111////"_BDW("MFI")
 D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 S DA=BDW("RUN LOG"),DIK="^BDWXLOG(" D IX1^DIK K DA,DIK
 D ^XBFMK
 ;
TR ;trailer report
 S BDWLOC=0,BDWLOCC=0,BDWTYPE="",BDWMODE="",BDWDATE="",BDWLC=0
 S X="EXPORT SITE: "_$$VAL^XBDIQ1(90213,BDW("RUN LOG"),.09) D S
 S X="DATE OF EXPORT: "_$$FMTE^XLFDT($P($P(^BDWXLOG(BDW("RUN LOG"),0),U,3),".")) D S
 S X="TOTAL NUMBER OF VISITS EXPORTED: "_$P(^BDWXLOG(BDW("RUN LOG"),0),U,18) D S
 S X="TOTAL NUMBER OF ADDS: "_$$VAL^XBDIQ1(90213,BDW("RUN LOG"),3108) D S
 S X="TOTAL NUMBER OF MODS: "_$$VAL^XBDIQ1(90213,BDW("RUN LOG"),3109) D S
 S X="TOTAL NUMBER OF DELETES: "_$$VAL^XBDIQ1(90213,BDW("RUN LOG"),3110) D S
 S X="" D S
 S X="" D S
 F  S BDWLOC=$O(^TMP($J,"BDWTRAILER",BDWLOC)) Q:BDWLOC'=+BDWLOC  D
 .S BDWLC=BDWLC+1,BDWLOCC=BDWLOCC+1
 .S X=BDWLOCC_".  Location of Encounter "_$P(^AUTTLOC(BDWLOC,0),U,10) D S
 .S X="" D S
 .S X="Type/Cat",$E(X,30)="TOTAL COUNT",$E(X,49)="ADDS",$E(X,58)="DELETES",$E(X,70)="CHANGES" D S
 .S X="---------------------------------------------------------------------------" D S
 .S BDWTYPE="" F  S BDWTYPE=$O(^TMP($J,"BDWTRAILER",BDWLOC,"TYPE",BDWTYPE)) Q:BDWTYPE=""  D
 ..S X=BDWTYPE,$E(X,33)=$$C($G(^TMP($J,"BDWTRAILER",BDWLOC,"TYPE",BDWTYPE,"TOT")),0,9),$E(X,46)=$$C($G(^TMP($J,"BDWTRAILER",BDWLOC,"TYPE",BDWTYPE,"A")),0,9)
 ..S $E(X,58)=$$C($G(^TMP($J,"BDWTRAILER",BDWLOC,"TYPE",BDWTYPE,"D")),0,9),$E(X,70)=$$C($G(^TMP($J,"BDWTRAILER",BDWLOC,"TYPE",BDWTYPE,"M")),0,9)
 ..D S
 .S X="" D S
 .S X="" D S
 .S X="COUNT BY DATE OF VISITS" D S
 .S X="TYPE/CAT",$E(X,33)="MONTH/YR",$E(X,49)="TOTAL" D S
 .S X="---------------------------------------------------------------------------" D S
 .S BDWTYPE="" F  S BDWTYPE=$O(^TMP($J,"BDWTRAILER",BDWLOC,"DATE",BDWTYPE)) Q:BDWTYPE=""  D
 ..S BDWDATE=0 F  S BDWDATE=$O(^TMP($J,"BDWTRAILER",BDWLOC,"DATE",BDWTYPE,BDWDATE)) Q:BDWDATE=""  D
 ...S X=BDWTYPE,$E(X,33)=$$FMTE^XLFDT(BDWDATE),$E(X,46)=$$C(^TMP($J,"BDWTRAILER",BDWLOC,"DATE",BDWTYPE,BDWDATE),0,9) D S
 ...Q
 ..Q
 .S X="" D S
 .S X="" D S
 .Q
 S ^BDWXLOG(BDW("RUN LOG"),99,0)="^^"_BDWLC_"^"_BDWLC_"^"_DT
 S DA=BDW("RUN LOG"),DIK="^BDWXLOG(" D IX1^DIK K DA,DIK
 D ^XBFMK
 S BDWMSGT=$$DW1TRLR^BHLEVENT(90213,BDW("RUN LOG"))
 S ^BDWTMP(BDWIEDST,BDWMSGT)=""
 S DA=BDW("RUN LOG"),DIE="^BDWXLOG(",DR=".13////"_BDWRUN_";.14////"_BDWMSGT_";.15////C" D ^DIE
 ;
 Q
C(X,X2,X3) ;
 I X="" Q ""
 D COMMA^%DTC
 Q X
S ;
 S BDWLC=BDWLC+1
 S ^BDWXLOG(BDW("RUN LOG"),99,BDWLC,0)=X
 K X
 Q
 Q
CHECK ;
 I '$P($G(^AUTTSITE(1,0)),U) W !!,"RPMS Site file not SET UP" S BDWERR=1 Q
 I $P(^BDWSITE(1,0),U,6)="" W:'$D(ZTQUEUED) !!,"VISIT backloading has not been completed.  Must be finished first." S BDWERR=2 Q
 ;D TAXCHK^BDWRDRI
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWRUN="NEW",$D(DIRUT) S BDWERR=1 S DA=BDWLOG,DIK="^BDWXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 Q
QUEUE1 ;
 S ZTRTN="PROCESS^BDWDDR"
 S ZTIO="",ZTDTH="",ZTDESC="DATA WAREHOUSE DATE RANGE" S ZTSAVE("BDW*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWRUN="NEW" S BDWERR=1 S DA=BDWLOG,DIK="^BDWXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWQUE=""
 S DIE="^BDWXLOG(",DA=BDWLOG,DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
GENLOG ;generate new log entry
 D ^XBFMK K DIADD,DLAYGO
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 S X=$$FMTE^XLFDT(BDWBD),DIC="^BDWXLOG(",DIC(0)="L",DLAYGO=90213,DIC("DR")=".02////"_BDWED_";.07////D;.09////"_$P(^AUTTSITE(1,0),U)_";8801////"_DUZ_";.23///DRE" S DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 W !!,$C(7),$C(7),"Error creating log entry." S BDWERR=1 D ^XBFMK Q
 S (BDWLOG,BDW("RUN LOG"))=+Y
 D ^XBFMK
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("BDW")
 D KILL^AUPNPAT
 K AUPNCPT
 Q
WRITE() ; use XBGSAVE to save the temp global (BDWDATA) to a delimited
 ; file that is exported to the DW system at 127.0.0.1
 ;
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 N BDWASU,BDWJUL,DT,X2,X1,X
 S BDWVA("COUNT")=BDWVA("COUNT")+1,^BDWDATA(BDWVA("COUNT"))="T0^"_$P($$DATE^INHUT($$NOW^XLFDT,1),"-")
 S XBGL="BDWDATA",XBMED="F",XBQ="N",XBFLT=1
 S XBNAR="DW Visit Audit"
 I '$D(DT) D DT^DICRW     ;get julian date for file name
 S X2=$E(DT,1,3)_"0101",X1=DT
 D ^%DTC
 S BDWJUL=X+1
 S BDWASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="BDWDWVX"_BDWASU_"."_BDW("RUN LOG")
 NEW DA,DIE,DR
 S DA=BDW("RUN LOG"),DIE="^BDWXLOG(",DR=".21///"_XBFN D ^DIE K DA,DIE,DR
 ;S XBUF="/usr3/dsd/ljara/"  ;used in testing to make it fail
 ;S XBQTO="-l dwxfer:regpcc 127.0.0.1"
 S XBS1="DATA WAREHOUSE SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG=0 D
 . W:'$D(ZTQUEUED) !,"VISIT audit file successfully created and transferred.",!!
 . K ^BDWDATA
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT audit file successfully created",!! K ^BDWDATA
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT audit file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to the data warehouse",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 ;
 Q XBFLG
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
 NEW X,L S (X,L)=0 F  S X=$O(^BDWXLOG(X)) Q:X'=+X  S L=X
 Q L+1
INTRO ;introductory text
 ;;
 ;;ATTENTION:
 ;;
 ;;Please do not run this export without checking with NPIRS first.
 ;;DRE exports cannot be loaded into the NDW without first making
 ;;special arrangements.  You can contact the
 ;;Help Desk.
 ;;
 ;;You should use the GDW and RERX options for all regularly scheduled 
 ;;exports.
 ;;
 ;;This program will generate Data Warehouse records for a visit
 ;;date range that you enter.  A log entry will be created which will log
 ;;the number of visits processed and the number of Data Warehouse records
 ;;generated.  
 ;;
 ;;END
