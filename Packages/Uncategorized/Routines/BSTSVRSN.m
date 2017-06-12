BSTSVRSN ;GDIT/HS/BEE-Standard Terminology - Local File Handling ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**3,4,5,6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
CHECK ;EP - Check for new codeset versions and '36' subsets/custom codeset refreshes
 ;
 NEW SITE,BSTS,ERROR,ZTRTN,ZTDESC,ZTIO,ZTDTH
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) I 'SITE G XCHECK
 ;
 ;Quit if all checks have been completed for the day
 I $$GET1^DIQ(9002318,SITE_",",".03","I")=DT G XCHECK
 ;
 ;Do not perform check if another process is already checking
 L +^BSTS("VERSION CHECK"):0 E  G XCHECK
 ;
 ;Do not perform check if background process is running
 L +^BSTS(9002318.1,0):0 E  G XCHECK
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 L +^TMP("BSTSICD2SMD"):0 E  G XCHECK
 L -^TMP("BSTSICD2SMD")
 ;
 ;Job off daily checks
 S ZTRTN="DAYCHK^BSTSVOF1"
 S ZTDESC="BSTS - Performing daily update checks"
 S ZTIO=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,2)
 D ^%ZTLOAD
 ;
 ;Schedule job to run in 3 days to guarantee that checks are occurring
 S ZTRTN="CHECK^BSTSVRSN"
 S ZTDESC="BSTS - Schedule check to run"
 S ZTIO=""
 S ZTDTH=$$FMADD^XLFDT(DT_".1030",,72)
 D ^%ZTLOAD
 ;
 ;Completed checks for day - mark parameter
 S BSTS(9002318,SITE_",",.03)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
XCHECK L -^BSTS("VERSION CHECK")
 ;
 Q
 ;
VCHK(NMID) ;EP - Daily check for new version
 ;
 NEW NMIEN,LVCKDT,STS,BSTS,ERROR,VAR,CVLCL,NVLCL,NVIEN,TRY,TR
 S NMID=$G(NMID,"") S:NMID="" NMID=36 S:NMID=30 NMID=36
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) I NMIEN="" Q 0
 ;
 ;Pull last version check date
 S LVCKDT=$$GET1^DIQ(9002318.1,NMIEN_",",.05,"I")
 I LVCKDT'<DT Q 0
 ;
 ;Pull the current version on file
 S CVLCL=$$GET1^DIQ(9002318.1,NMIEN_",",".04","I")
 ;
 ;Perform version check
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VAR",NMID)
 . I +STS'=2 H TR
 ;
 ;Check for successful remote call - If failure, don't check again today
 I +STS'=2 D  Q 2
 . NEW BSTS,ERROR,SITE
 . S SITE=$O(^BSTS(9002318,0)) Q:SITE=""
 . S BSTS(9002318,SITE_",",.03)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Get the current version from the codeset multiple
 S NVIEN=$O(^BSTS(9002318.1,NMIEN,1,"A"),-1)
 S NVLCL="" I +NVIEN>0 D
 . NEW DA,IENS
 . S DA(1)=NMIEN,DA=+NVIEN,IENS=$$IENS^DILF(.DA)
 . S NVLCL=$$GET1^DIQ(9002318.11,IENS,".01","I")
 ;
 ;If the current version value isn't equal to the latest in the multiple need to process
 I NVLCL]"",CVLCL'=NVLCL D  Q 1
 . ;
 . ;For codesets 36, 5180, 1552
 . I (NMID=36)!(NMID=5180)!(NMID=1552) D QUEUE^BSTSVOFL(NMID) Q
 . ;
 . ;For '36' ICD-10 autocodables
 . I NMID=32777 D QUEUE^BSTSVOFL(NMID) Q
 . ;
 . ;For '36' ICD-9 autocodables
 . I NMID=32778 D QUEUE^BSTSVOFL(NMID) Q
 . ;
 . ;For '36' ICD-10 conditionals
 . I NMID=32779 D QUEUE^BSTSVOFL(NMID) Q
 . ;
 . ;For '36' ICD-10 conditionals
 . I NMID=32780 D QUEUE^BSTSVOFL(NMID) Q
 . ;
 . ;For remaining custom codesets
 . I NMID'=32777,NMID'=32778,NMID'=32779,NMID'=36,NMID'=5180,NMID'=1552 D QUEUE^BSTSVOFL(NMID) Q
 ;
 ;Update LAST VERSION CHECK
 S BSTS(9002318.1,NMIEN_",",.05)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
 Q 1
 ;
RES ;EP - Mark Local Codeset Entries As Out of Date
 ;
 ;Perform lock so only one process is allowed
 L +^BSTS(9002318.1,0):0 E  Q
 ;
 NEW NMID,VDTS,STS,NVIEN,NVLCL,CIEN,BSTS,ERROR,VAR,X1,X2,X,TR
 ;
 ;Passed in variable
 S NMIEN=$G(NMIEN) Q:NMIEN=""
 ;
 ;Get NMID
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" G XRES
 ;
 ;Perform version check
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1 ;Make sure link is turned on
 . S STS=$$VERSIONS^BSTSAPI("VAR",NMID)
 . I +STS'=2 H TR
 ;
 ;Check for successful remote call - If offline quit
 I +STS'=2 G XRES
 ;
 ;Reset Monitoring Global
 K ^XTMP("BSTSLCMP")
 ;
 ;Get a later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up Monitoring Global
 S ^XTMP("BSTSLCMP","STS")=X_U_DT_U_"Cache Codeset refresh running for "_NMID
 ;
 ;Loop through each concept in the codeset and make it Out of Date
 S VDTS="" F  S VDTS=$O(^BSTS(9002318.4,"D",NMID,VDTS)) Q:VDTS=""  S CIEN=0 F  S CIEN=$O(^BSTS(9002318.4,"D",NMID,VDTS,CIEN)) Q:'CIEN  D
 . ;
 . ;Update status
 . S ^XTMP("BSTSLCMP","STS")="Marking entry "_CIEN_" as out of date"
 . ;
 . NEW BSTSUPD,ERR,TIEN
 . ;
 . ;Mark Entry as Out of Date
 . S BSTSUPD(9002318.4,CIEN_",",".11")="Y"
 . ;
 . ;Process the Associated Terms
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CIEN,TIEN)) Q:TIEN=""  D
 .. ;
 .. NEW BSTSTUPD,ERR
 .. ;
 .. ;Mark Entry as Out of Date
 .. S BSTSTUPD(9002318.3,TIEN_",",".11")="Y"
 .. D FILE^DIE("","BSTSTUPD","ERR")
 . ;
 . ;File entry
 . I $D(BSTSUPD) D FILE^DIE("","BSTSUPD","ERR")
 ;
 ;Update the current version
 ;
 ;Get the current version from the codeset multiple
 S NVIEN=$O(^BSTS(9002318.1,NMIEN,1,"A"),-1)
 S NVLCL="" I +NVIEN>0 D
 . NEW DA,IENS
 . S DA(1)=NMIEN,DA=+NVIEN,IENS=$$IENS^DILF(.DA)
 . S NVLCL=$$GET1^DIQ(9002318.11,IENS,".01","I")
 ;
 ;Now save it in the CURRENT VERSION field
 I NVLCL]"" D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.04)=NVLCL
 . D FILE^DIE("","BSTS","ERROR")
 ;
 I NMID=36 S BSTS(9002318.1,NMIEN_",",.1)="@"
 E  S BSTS(9002318.1,NMIEN_",",.05)="@"
 D FILE^DIE("","BSTS","ERR")
 ;
 K ^XTMP("BSTSLCMP")
 ;
 ;Queue subset refresh
 I NMID=36 D QENTRY^BSTSVOFL("SUB^BSTSVRSN",NMIEN,"S36")
 ;
 ;Unlock entry
XRES L -^BSTS(9002318.1,0)
 ;
 Q
 ;
SCHK(NMID,BKGND) ;EP - Check for periodic subset updates
 ;
 NEW LMDT,STS,BSTS,ERROR,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,NMIEN
 NEW VAR,SITE,SDAYS,ZTIO,SUBLST,X1,X2,X,%H,TR
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSVRSN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Only one SNOMED background process can be running at a time
 I '$G(BKGND)  L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 I '$G(BKGND) L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 S NMID=$G(NMID,"") S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Only run it for codeset 36
 I NMID'=36 Q
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
 I +$G(BKGND) D QUEUE^BSTSVOFL("S36") Q  ;Daily check - queue
 D CDJOB^BSTSUTIL(NMIEN,"S","")  ;Manual - run now
 ;
XSCHK Q
 ;
SUB ;EP - Update IHS Standard Terminology Subsets
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
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"Cache subset refresh running for "_NMID
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
 .. ;Check last modified - skip if toda
 .. S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") I LMOD'<RUNSTRT Q
 .. ;
 .. ;Mark as out of date
 .. S BSTS(9002318.4,CIEN_",",".12")="@"
 .. D FILE^DIE("","BSTS","ERR")
 ;
 ;
 ;Make the call to update the subset entries
 S STS=$$SCODE^BSTSWSV1()
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
 .. S STS=$$DTSLKP^BSTSAPI("SBVAR",DTSID) I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUB^BSTSVRSN - Refreshing entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON DETAIL ENTRY: "_DTSID)
 ... S FCNT=0
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 ;
 ;Process VUID and NDC
 S STS=$$NVLKP^BSTSVOFL(MFAIL,FWAIT)
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
