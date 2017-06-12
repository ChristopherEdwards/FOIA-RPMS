BSTSVRXN ;GDIT/HS/BEE-Standard Terminology - RxNorm Subset Updates ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
SCHK(NMID,BKGND) ;EP - Check for periodic RxNorm subset updates
 ;
 NEW LMDT,STS,BSTS,ERROR,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,NMIEN
 NEW VAR,SITE,SDAYS,ZTIO,SUBLST,X1,X2,X,%H,TR
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSVRXN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Only one SNOMED background process can be running at a time
 I '$G(BKGND)  L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 I '$G(BKGND) L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 S NMID=$G(NMID,"") S:NMID="" NMID=1552
 ;
 ;Only run it for codeset 1552
 I NMID'=1552 Q
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) Q:'SITE
 ;
 ;Get subset update days
 S SDAYS=$$GET1^DIQ(9002318,SITE_",",.02,"I") S:SDAYS="" SDAYS=60
 ;
 ;Make sure we have a codeset (namespace)
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Update LAST SUBSET CHECK as completed today
 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.06)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Check if refresh needs run
 S LMDT=$$GET1^DIQ(9002318.1,NMIEN,".1","I")
 I LMDT>0 S X1=LMDT,X2=SDAYS D C^%DTC S LMDT=X
 I LMDT>DT Q
 ;
 ;Only run if server set up
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VAR") ;Try a quick call to see if call works
 . I +STS'=2 H TR
 I +STS'=2 G XSCHK
 ;
 ;Queue the process off in the background
 I +$G(BKGND) D QUEUE^BSTSVOFL("S1552") Q  ;Daily check - queue
 D CDJOB^BSTSUTIL(NMIEN,"S1552","")  ;Manual - run now
 ;
XSCHK Q
 ;
SUB ;EP - Update IHS Standard Terminology RxNorm Subsets
 ;
 ;Perform lock so only one process is allowed
 L +^BSTS(9002318.1,0):1 E  Q
 ;
 NEW NMID,SDAYS,SITE
 ;
 ;Retrieve passed in variable
 S NMIEN=$G(NMIEN) I NMIEN="" Q
 ;
 ;Get NMID
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" Q
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) Q:'SITE
 ;
 ;Get subset update days
 S SDAYS=$$GET1^DIQ(9002318,SITE_",",.02,"I") S:SDAYS="" SDAYS=60
 ;
 NEW BSTS,ERROR,CIEN,BSTSSB,STS,CNC,SUBLST,SSCIEN,ICONC,X,X1,X2,ITEM,%H
 NEW MFAIL,FWAIT,FCNT,ABORT,RUNSTRT,TR
 ;
 ;Note the run date
 S RUNSTRT=DT
 ;
 ;Only run if server up
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset DTS to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try quick call
 . I +STS'=2 H TR
 I +STS'=2 G XSUB
 ;
 ;Reset Monitoring Global
 K ^XTMP("BSTSLCMP")
 ;
 ;Get a later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Update SUBSET TASK NUMBER
 I +$G(ZTSK)>0 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.08)=ZTSK
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Set up Monitoring Global
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"RxNorm Cache subset refresh running for "_NMID
 ;
 ;Loop through concepts and clear out modified date for codes in codeset
 S ^XTMP("BSTSLCMP","STS")="Marking entries as out of date"
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,CIEN)) Q:CIEN=""  D
 .. NEW CDSET,BSTS,ERR,LMOD
 .. ;
 .. ;Skip partial entries
 .. I $$GET1^DIQ(9002318.4,CIEN_",",.03,"I")="P" Q
 .. ;
 .. ;Check last modified - skip if today
 .. S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") I LMOD'<RUNSTRT Q
 .. ;
 .. ;Mark as out of date
 .. S BSTS(9002318.4,CIEN_",",".12")="@"
 .. D FILE^DIE("","BSTS","ERR")
 ;
 ;Make the call to update the subset entries
 S STS=$$SCODE^BSTSWSV1(1552)
 ;
 ;Quit on failure
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XSUB
 I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 ;
 ;Need to loop through list again to catch any deletes
 S ^XTMP("BSTSLCMP","STS")="Looking for entries removed from subsets"
 S ABORT=0,ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  Q:$D(^XTMP("BSTSLCMP","QUIT"))  S SSCIEN="" F  S SSCIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,SSCIEN)) Q:SSCIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . ;
 . NEW LMOD,DTSID,SBVAR,CDSET,X1,X2,X,%H,FCNT,TRY
 . ;
 . ;Skip partial entries
 . I $$GET1^DIQ(9002318.4,SSCIEN_",",.03,"I")="P" Q
 . ;
 . ;Get last modified date for concept
 . S LMOD=$$GET1^DIQ(9002318.4,SSCIEN_",",".12","I")
 . ;
 . ;Skip if not out of date
 . I LMOD'<RUNSTRT Q
 . ;
 . ;Get DTSId
 . S DTSID=$$GET1^DIQ(9002318.4,SSCIEN_",",".08","I") Q:DTSID=""
 . S ^XTMP("BSTSLCMP","STS")="Refreshing removed entry: "_SSCIEN_" DTSID: "_DTSID
 . ;
 . ;If Out of Date, retrieve detail from server - Hang max of 12 times
 . S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1 ;Make sure the link is on
 .. S STS=$$DTSLKP^BSTSAPI("SBVAR",DTSID_"^1552") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUB^BSTSVRSN - Refreshing entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON DETAIL ENTRY: "_DTSID)
 ... S FCNT=0
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 ;
 ;Process VUID and NDC
 ;S STS=$$NVLKP^BSTSVOFL(MFAIL,FWAIT)
 ;
 ;Update LAST SUBSET RUN as completed today
 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.1)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
XSUB NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 ;Unlock entry
 L -^BSTS(9002318.1,0)
 ;
 Q
 ;
SBRSET ;EP - BSTS REFRESH SUBSETS option
 ;
 ;Moved to overflow routine because of size issues
 D SBRSET^BSTSVOFL Q
 ;
ERR ;
 D ^%ZTER
 Q
