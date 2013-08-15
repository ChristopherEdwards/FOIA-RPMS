DG53591A ;ALB/GN - DG*5.3*591 CLEANUP FOR PURGED DEPENDENT INCOME; 3/17/04 12:26pm ; 7/26/04 10:51am
 ;;5.3;Registration;**591,1015**;Aug 13, 1993;Build 21
 Q
 ;
POST ;post install entry tag call.  processes entire file in live mode
 N ZTDTH,ZTDESC,ZTIO,ZTRTN,ZTSK,ZTQUEUED,ZTSAVE
 D MES^XPDUTL("")
 D MES^XPDUTL("=====================================================")
 D MES^XPDUTL("Queuing Cleanup Purged Dependent Income Relations....")
 I $$CHKSTAT(1) D  Q
 . D BMES^XPDUTL("ABORTING  Post Install Utility Queuing")
 . D MES^XPDUTL("=====================================================")
 S ZTRTN="QUE^DG53591A"
 S ZTDESC="Cleanup Purged Dependent Income Relations"
 ; delay start by 5 minutes to give 1st cleanup a head start
 S ZTIO=""
 S ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+300
 D ^%ZTLOAD
 L -^XTMP($$NAMSPC)
 D MES^XPDUTL("This request queued as Task # "_ZTSK)
 D MES^XPDUTL("=====================================================")
 D MES^XPDUTL("")
 Q
 ;
TEST ; Entry point for taskman (testing mode)
 S TESTING=1
QUE ; Entry point for taskman (live mode)
 N NAMSPC S NAMSPC=$$NAMSPC^DG53591A
 L +^XTMP(NAMSPC):10 I '$T D  Q   ;quit if can't get a lock
 . S $P(^XTMP(NAMSPC,0,0),U,5)="NO LOCK GAINED"
 N QQ,ZTSTOP,XREC,MTIEN,DIK,DA,IVMTOT,IVMPTR,IVMDPTR,BEGTIME,PURGDT
 N DFN,TMP,ICDT,MTST,IVMDUPE,COUNT,PRI,TYPE,TYPNAM,IVMIEN,PRIM
 N DG22,MTDT,R21,R22,R12,BADDT,BADYR,NEWYR,PMT,SSN,DGDFN
 S TESTING=+$G(TESTING)
 ;
 ;get last run info if exists
 S XREC=$G(^XTMP(NAMSPC,0,0))
 S DFN=$P(XREC,U,1)                           ;last REC processed
 S IVMTOT=+$P(XREC,U,2)                       ;total records processed
 S IVMPTR=+$P(XREC,U,3)                       ;total repointed recs
 S DGDFN=+$P(XREC,U,7)                        ;last DFN of 2nd cleanup
 S IVMDPTR=+$P(XREC,U,8)                      ;total del 408.1275 recs
 ;
 ;setup XTMP according to stds.
 D SETUPX(60)
 ;
 ;init status field and start date & time if null
 S $P(^XTMP(NAMSPC,0,0),U,5,6)="RUNNING^"
 S:$P(^XTMP(NAMSPC,0,0),U,4)="" $P(^XTMP(NAMSPC,0,0),U,4)=$$NOW^XLFDT
 ;
 ;drive through 408.22 and create a DFN ordered xref
 K ^TMP(NAMSPC)
 ;
 ; build TMP xref from AMT xref in 408.22
 ;  fmt of TMP(Namspc,MT ien,DFN,408.21 ien,408.22 ien)
 S GL=$NA(^DGMT(408.22,"AMT"))
 F  S GL=$Q(@GL) Q:$QS(GL,2)'="AMT"  D
 . Q:$QS(GL,3)'?.N                             ;insure 3rd sub=numeric
 . Q:+$G(^DPT($QS(GL,4),.35))                  ;skip vets w/DOD
 . S ^TMP(NAMSPC,$QS(GL,4),$QS(GL,3),$QS(GL,5))=$QS(GL,6)
 ;
 ;drive through TMP XREF looking for bad 408.22 refs with no 408.31
 S ZTSTOP=0
 F QQ=1:1 S DFN=$O(^TMP(NAMSPC,DFN)) Q:'DFN  D  Q:ZTSTOP
 . S MTIEN=0
 . F  S MTIEN=$O(^TMP(NAMSPC,DFN,MTIEN)) Q:'MTIEN  D  Q:ZTSTOP
 . . S R21=0
 . . F  S R21=$O(^TMP(NAMSPC,DFN,MTIEN,R21)) Q:'R21  D  Q:ZTSTOP
 . . . S IVMTOT=IVMTOT+1                            ;tot ien's read
 . . . ;
 . . . ;only process recs that are pointing to nonexistent 408.31 recs
 . . . S R22=$P(^TMP(NAMSPC,DFN,MTIEN,R21),"^",1)
 . . . Q:$D(^DGMT(408.31,MTIEN,0))
 . . . ;
 . . . ;quit, if 408.22 xref's below ref. bad 408.21 recs
 . . . Q:'$D(^DGMT(408.21,R21,0))
 . . . ;
 . . . ;determine Income year for bad ptr from the 408.21 file
 . . . S BADDT=(+^DGMT(408.21,R21,0))+11231,BADYR=$E(BADDT,1,3)
 . . . S BADDT=$S(BADDT>DT:DT,1:BADDT)
 . . . ;
 . . . ;get previous Primary MT (PMT) based on the bad ptr's MT year
 . . . ;and quit if PMT Not found
 . . . S PMT=$$LST^DGMTU(DFN,BADDT)
 . . . Q:'PMT
 . . . ;
 . . . ;quit, if the PMT income year does not match the bad ptr year
 . . . S MTDT=$P(PMT,"^",2),NEWYR=$E(MTDT,1,3)
 . . . Q:BADYR'=NEWYR
 . . . ;
 . . . ;quit, if (Cat C & < Oct 1999)or(if Not Cat C & > 2 years old)
 . . . ;      or if MT is No Longer Required
 . . . N CATC,NOREQ
 . . . S CATC=$P(PMT,"^",4)="C"
 . . . S NOREQ=$P(PMT,"^",3)["NO LONGER REQUIRED"
 . . . Q:(CATC)&(MTDT<2991001)
 . . . Q:('CATC)&(MTDT<(DT-20000))
 . . . Q:$E(MTDT,1,3)<303
 . . . Q:NOREQ
 . . . ;
 . . . ;quit, if PMT was already pointed to by another 408.22 rec
 . . . S NEWIEN=+PMT
 . . . Q:$D(^TMP(NAMSPC,DFN,NEWIEN))
 . . . ;
 . . . ;quit, if MT to point to is from Other VAMC
 . . . Q:$P(PMT,"^",5)=4
 . . . ;
 . . . ;fall thru to re-point this bad 408.22 xref to new PMT ien
 . . . S IVMPTR=IVMPTR+1
 . . . D PT40822(DFN,R22,NEWIEN,MTIEN)          ;repoint bad 408.22
 . . . D XMIT(DFN,MTDT)                         ;re-xmit PMT to HEC
 . . . S $P(^TMP(NAMSPC,DFN,MTIEN),"^",2)=NEWIEN
 . ;
 . ;update last processed info
 . S $P(^XTMP(NAMSPC,0,0),U,1,3)=DFN_U_IVMTOT_U_IVMPTR
 . M ^XTMP(NAMSPC,DFN)=^TMP(NAMSPC,DFN)
 . ;
 . ;check for stop request after every 20 processed DFN recs
 . I QQ#20=0 D
 . . S:$$S^%ZTLOAD ZTSTOP=1
 . . I $D(^XTMP(NAMSPC,0,"STOP")) S ZTSTOP=1 K ^XTMP(NAMSPC,0,"STOP")
 . K TMP
 ;
 ;set status and if complete, call 2nd pass cleanup
 I ZTSTOP D
 . S $P(^XTMP(NAMSPC,0,0),U,5,6)="STOPPED"_U_$$NOW^XLFDT
 E  D                                   ;2nd pass will mark complete
 . D EN^DG53591B                        ;second pass dependent cleanup
 ;
 ;mail stats
 D MAIL^DG53591A
 K TESTING,^TMP(NAMSPC)
 L -^XTMP($$NAMSPC)
 Q
 ;
PT40822(DFN,R22,NEWIEN,MTIEN) ; Repoint this bad 408.22 xref to a new MT
 N DATA,MTDAT
 S DATA(31)=NEWIEN
 I '$G(TESTING),$$UPD^DGENDBS(408.22,R22,.DATA)
 S SSN=$E(^DPT(DFN,0),1)_$E($P(^DPT(DFN,0),"^",9),6,9)
 S MTDAT=+$G(^DGMT(408.31,NEWIEN,0))
 S TEXT=" SSN="_SSN_"  Point 408.22 ien "_R22_" From MT "_MTIEN
 S TEXT=TEXT_" to "_NEWIEN_"  "_$$FMTE^XLFDT(MTDAT,2)
 W:'$D(ZTQUEUED) !,TEXT
 S ^XTMP(NAMSPC,"DET",DFN,R22)=TEXT
 Q
 ;
XMIT(DFN,MTDT) ; Re-transmit this Income Year per this MT date
 N YRIEN,DATA,YEAR
 S YEAR=$$LYR^DGMTSCU1(MTDT)
 S YRIEN=$O(^IVM(301.5,"AYR",YEAR,DFN,0))
 S DATA(.03)=0
 I '$G(TESTING),$$UPD^DGENDBS(301.5,YRIEN,.DATA)
 W:'$D(ZTQUEUED) !,"Transmit Income Year ",YEAR," IVM file ien: ",YRIEN
 Q
 ;
CHKSTAT(POST) ;check if job is running, stopped, or completed
 N Y,DUOUT,DTOUT,QUIT,STAT,STIME,NAMSPC
 S QUIT=0
 S NAMSPC=$$NAMSPC
 L +^XTMP(NAMSPC):1
 I '$T D BMES^XPDUTL("*** ALREADY RUNNING ***") Q 1
 ;
 ; get job status
 S STAT=$P($G(^XTMP(NAMSPC,0,0)),U,5)
 S STIME=$P($G(^XTMP(NAMSPC,0,0)),U,6)
 ;
 I POST D KILIT Q 0
 ;
 ;if job Completed and run from menu opt, ask to Re-Run
 I STAT="COMPLETED" D
 . W " was Completed on "_$$FMTE^XLFDT(STIME)
 . W !,"  Do you want to Re-Run again?"
 . K DIR
 . S DIR("?",1)="  Entering Y, will delete the XTMP global where the previous cleanup"
 . S DIR("?")="  information was stored and begin a new job, or N to cancel request"
 . S DIR(0)="Y" D ^DIR
 . I 'Y S QUIT=1 Q
 . W !," ARE YOU SURE?"
 . K DIR
 . S DIR("?")="Enter Y to begin a new Job or N to cancel request"
 . S DIR(0)="Y" D ^DIR
 . I 'Y S QUIT=1 Q
 . ;fall thru to re-run mode, kill ^XTMPs
 . D KILIT
 Q QUIT
 ;
KILIT ; kill Xtmp work files for a re-run
 S:'$D(NAMSPC) NAMSPC=$$NAMSPC^DG53591A
 K ^XTMP(NAMSPC)
 Q
 ;
STOP ; alternate stop method
 S ^XTMP($$NAMSPC,0,"STOP")=""
 Q
 ;
SETUPX(EXPDAY) ;Setup XTMP according to standards and set expiration days
 N BEGTIME,PURGDT,NAMSPC
 S NAMSPC=$$NAMSPC^DG53591A
 S BEGTIME=$$NOW^XLFDT()
 S PURGDT=$$FMADD^XLFDT(BEGTIME,EXPDAY)
 S ^XTMP(NAMSPC,0)=PURGDT_U_BEGTIME
 S $P(^XTMP(NAMSPC,0),U,3)="Cleanup Purged Dependent Income Relations"
 Q
 ;
NAMSPC() ; Return a consistent name space variable
 Q $T(+0)
 ;
MAIL ; mail stats
 N ACT,LACT,DFN,BTIME,HTEXT,TEXT,NAMSPC,LIN,MSGNO,IVMBAD,IVMPTR,IVMTOT
 N LSSN,R40831,STS,STSNAM
 S MSGNO=0
 S NAMSPC=$$NAMSPC^DG53591A
 S IVMTOT=$P($G(^XTMP(NAMSPC,0,0)),U,2)
 S IVMPTR=$P($G(^XTMP(NAMSPC,0,0)),U,3)
 S BTIME=$P($G(^XTMP(NAMSPC,0,0)),U,4)
 S STAT=$P($G(^XTMP(NAMSPC,0,0)),U,5)
 S STIME=$P($G(^XTMP(NAMSPC,0,0)),U,6)
 S IVMDPTR=$P($G(^XTMP(NAMSPC,0,0)),U,8)
 ;
 D HDNG(.HTEXT,.MSGNO,.LIN)
 D SUMRY(.LIN)
 D MAILIT(HTEXT)
 ;
 D SNDDET
 Q
 ;
HDNG(HTEXT,MSGNO,LIN) ;build heading lines for mail message
 K ^TMP(NAMSPC,$J,"MSG")
 S LIN=0
 S HTEXT="Cleanup Purged Dependent Income Relations completed:"
 S HTEXT=HTEXT_$$FMTE^XLFDT(STIME,2)
 D BLDLINE(HTEXT,.LIN)
 D BLDLINE("",.LIN)
 I TESTING S TEXT="** TESTING **" D BLDLINE(TEXT,.LIN)
 I MSGNO S TEXT="Message number: "_MSGNO D BLDLINE(TEXT,.LIN)
 D BLDLINE("",.LIN)
 S MSGNO=MSGNO+1
 Q
 ;
SUMRY(LIN) ;build summary lines for mail message
 S TEXT="     Total Records Processed: "_$J($FN(IVMTOT,","),11)
 D BLDLINE(TEXT,.LIN)
 S TEXT="      408.22 recs re-pointed: "_$J($FN(IVMPTR,","),11)
 D BLDLINE(TEXT,.LIN)
 S TEXT="      408.1275 recs deleted : "_$J($FN(IVMDPTR,","),11)
 D BLDLINE(TEXT,.LIN)
 D BLDLINE("",.LIN)
 D BLDLINE("",.LIN)
 D BLDLINE("",.LIN)
 ;
 I IVMPTR D
 . D BLDLINE("Detail changes to follow in subsequent mail messages.",.LIN)
 Q
 ;
SNDDET ;build and send detail messages limit under 2000 lines each
 N TEXT,GL,MAXLIN,MORE
 S MAXLIN=1995,MORE=0
 D HDNG(.HTEXT,.MSGNO,.LIN)
 ;
 S GL=$NA(^XTMP(NAMSPC,"DET"))
 F  S GL=$Q(@GL) Q:GL=""  Q:$QS(GL,1)'=NAMSPC  D
 . S TEXT=$G(@GL)
 . S MORE=1                             ;at least 1 more line to send
 . D BLDLINE(TEXT,.LIN)
 . ;max lines reached, print a msg
 . I LIN>MAXLIN D  S MORE=0
 . . D MAILIT(HTEXT),HDNG(.HTEXT,.MSGNO,.LIN)
 ;
 ;print final message if any to print
 D MAILIT(HTEXT):MORE
 Q
 ;
BLDLINE(TEXT,LIN) ;build a single line into TMP message global
 S LIN=LIN+1
 S ^TMP(NAMSPC,$J,"MSG",LIN)=TEXT
 Q
MAILIT(HTEXT) ; send the mail message
 N XMY,XMDUZ,XMSUB,XMTEXT
 S XMY(DUZ)="",XMDUZ=.5
 S XMSUB=HTEXT
 S XMTEXT="^TMP(NAMSPC,$J,""MSG"","
 D ^XMD
 Q
