BDWCVAR ; IHS/CMI/LAB - visit audit report ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 ;
 ;
START ;
 I $D(^BDWDATA) W !!,"Audit already running or not completed successfully, cannot continue." Q
 W !!,"This option is used to create a visit audit report to accompany a data",!,"warehouse export.",!!
 S BDW("QFLG")=""
 D BASICS
 Q:BDW("QFLG")
 S BDW("QFLG")=""
 D GETLOG^BDWRDRI2 ;      Get last log entry and display data.
 I BDW("QFLG") D EXIT Q
 D CHKOLD^BDWRDRI2
 I BDW("QFLG") D EXIT Q
 D CURRUN^BDWRDRI2 ;      Compute run dates for current run.
 I BDW("QFLG") D EXIT Q
 D CHKVISIT^BDWRDRI2 ;    Check VISIT xref for date range
 I BDW("QFLG") D EXIT Q
 D CONFIRM^BDWRDRI2 ;     Get ok from operator.
 I BDW("QFLG") D EXIT Q
 D PROCESS
 S X=$$WRITE
 I '$D(ZTQUEUED) S DIR(0)="EO",DIR("A")="DONE -- Press ENTER to Continue" K DA D ^DIR K DIR
 D EXIT
 Q
PROCESS ;
 W:'$D(ZTQUEUED) !!,"Generating visit audit report..Please wait."
 S BDWCNTR=0,BDW("CONTROL DATE")=BDW("RUN BEGIN")-1
 F  S BDW("CONTROL DATE")=$O(^AUPNVSIT("ADWO",BDW("CONTROL DATE"))) Q:BDW("CONTROL DATE")=""!(BDW("CONTROL DATE")>BDW("RUN END"))  D PROCESS2 Q:BDW("QFLG")
 Q
PROCESS2 ;
 S BDW("V DFN")="" F  S BDW("V DFN")=$O(^AUPNVSIT("ADWO",BDW("CONTROL DATE"),BDW("V DFN"))) Q:BDW("V DFN")=""  D PROCESS3 Q:BDW("QFLG")
 Q
PROCESS3 ;
 K BDWT,BDWV,BDWE
 D KILL^AUPNPAT
 I '$D(^AUPNVSIT(BDW("V DFN"),0)) K ^AUPNVSIT("ADWO",BDW("CONTROL DATE"),BDW("V DFN")) Q
 D GENREC
 S BDWCNTR=BDWCNTR+1 W:'(BDWCNTR#100) "."
 Q
BASICS ;EP - BASIC INITS
 K ^BDWDATA ;export global
 S BDWVA("COUNT")=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K BDW,BDWS,BDWV,BDWT,BDWE,BDWERRC
 S BDW("RUN LOCATION")=$P($G(^BDWSITE(1,0)),U),BDW("QFLG")=0
 I DUZ(2)'=BDW("RUN LOCATION") W !,"You need to be logged in as ",$P(^DIC(4,BDW("RUN LOCATION"),0),U)," in order to do this audit report.",! S BDW("QFLG")=1 Q
 S APCDOVRR=1 ; Allow VISIT lookup with 0 'dependent entry count'.
 S (BDW("SKIP"),BDW("TXS"),BDW("VPROC"),BDW("COUNT"),BDW("VISITS"),BDWERRC,BDW("REG"),BDW("DEMO"),BDW("ZERO"),BDW("DEL"),BDW("NO PAT"),BDW("NO LOC"),BDW("NO TYPE"),BDW("NO CAT"),BDW("MFI"),BDWVA("COUNT"))=0
 S (BDW("MODS"),BDW("ADDS"),BDW("DELS"))=0
 I $P(^BDWSITE(1,0),U,7) S BDWVA=1
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1 IE",0))
 Q
 ;
EXIT ;
 D EN^XBVK("BDW")
 Q
GENREC ;
 S BDWV("V REC")=^AUPNVSIT(BDW("V DFN"),0)
 K BDWE
 D VISIT
 I '$D(BDWE) Q
 D PROCTX
 K BDWE,BDWT,BDWH
 Q
 ;
VISIT ;EP
 K BDWE
 I $P(BDWV("V REC"),U,23)=.5 Q
 I '$P(BDWV("V REC"),U,9),'$P(BDWV("V REC"),U,11) Q
 I $P(BDWV("V REC"),U,11),$P($G(^AUPNVSIT(BDW("V DFN"),11)),U,6)="" Q
 S BDWV("TYPE")=$P(BDWV("V REC"),U,3)
 I BDWV("TYPE")="" Q
 S BDWV("SRV CAT")=$P(BDWV("V REC"),U,7)
 I BDWV("SRV CAT")="" Q
 S BDWV("LOC DFN")=$P(BDWV("V REC"),U,6)
 I BDWV("LOC DFN")="" Q
 S BDWV("IHS LOCATION CODE")=$P(^AUTTLOC(BDWV("LOC DFN"),0),U,10) I BDWV("IHS LOCATION CODE")="" Q
 S BDWV("PATIENT DFN")=$P(BDWV("V REC"),U,5) I BDWV("PATIENT DFN")="" Q
 I '$D(^DPT(BDWV("PATIENT DFN"))) Q
 S Y=BDWV("PATIENT DFN") D ^AUPNPAT
 S BDWV("PATIENT NAME")=$P(^DPT(BDWV("PATIENT DFN"),0),U)
 I BDWV("PATIENT NAME")["DEMO,PATIENT" Q
 S BDWE=1
 Q
 ;
PROCTX ; process and generate appropriate hl7 message
 D VA^BDW1VBL2
 Q
 ;
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
 S BDWASU=$P($G(^AUTTLOC(DUZ(2),0)),U,10)  ;asufac for file name
 S XBFN="BDWDWVX"_BDWASU_"."_BDWJUL
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
