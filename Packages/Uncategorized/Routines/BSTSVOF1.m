BSTSVOF1 ;GDIT/HS/BEE-Standard Terminology - Versioning handling overflow 2 ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4,5,6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
ASKSB() ;Ask Individual Subset
 ;
 NEW DIR,X,Y,SUBSET,DIRUT,DUOUT,SLIST,STS,I
 ;
 ;Get subsets
 S STS=$$SUBSET^BSTSAPI("SLIST","^2")
 ;
 S SLIST="" F  S SLIST=$O(SLIST(SLIST)) Q:'SLIST  I SLIST(SLIST)]"" S SLIST("B",SLIST(SLIST))=""  ;Sort
 S SLIST="" F I=1:1 S SLIST=$O(SLIST("B",SLIST)) Q:SLIST=""  S DIR("?",I)=SLIST
 ;
 S SUBSET=""
 ;
ASKSB1 W !! S DIR("?")="Select a subset from the following list or type ALL for all subsets"
 S DIR("A")="Enter the exact name of the subset to refresh or ALL: "
 S DIR("B")="ALL"
 S DIR(0)="F^3:50"
 D ^DIR I $G(DIRUT)!$G(DUOUT)!(Y="") Q "-1"
 ;
 ;BSTS*1.0*4;Filter out IHS PROBLEM ALL SNOMED
 I Y="IHS PROBLEM ALL SNOMED" W !!,"CANNOT DOWNLOAD IHS PROBLEM ALL SNOMED" H 3 G ASKSB1
 I Y]"",Y'="ALL",'$D(SLIST("B",Y)) W !!,"INVALID SUBSET" H 3 G ASKSB1
 ;
 S SUBSET=Y
 ;
 Q SUBSET
 ;
ISCHK(SUBSET) ;EP - Recompile one subset
 ;
 NEW STS,VAR,ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BSTSUPD,ERROR,FIELD,ZTSK,TR
 ;
 ;Only one SNOMED background process can be running at a time
 L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 ;Only run if server set up
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VAR") ;Try a quick call to see if call works
 . I +STS'=2 H TR
 I +STS'=2 W !!,"The DTS server link is down. Aborting..." G XISCHK
 ;
 ;Queue the process off in the background
 S ZTRTN="ISUB^BSTSVOF1",ZTDESC="BSTS - Refresh BSTS subset "_SUBSET
 S ZTSAVE("SUBSET")=""
 ;
 S ZTIO=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,2)
 D ^%ZTLOAD
 I $G(ZTSK)]"" W !!,"Task: ",ZTSK," scheduled to start in two minutes"
 ;
XISCHK Q
 ;
ISUB ;Recompile one subset
 ;
 ;Perform lock so only one process is allowed
 L +^BSTS(9002318.1,0):1 E  Q
 ;
 NEW BSTSBPRC,MFAIL,FWAIT,TRY,STS,ABORT,NMIEN,CIEN
 ;
 I $G(SUBSET)="" G XISUB
 ;
 ;Save current entries
 K ^TMP("BSTSISUB",$J)
 S NMIEN=$O(^BSTS(9002318.1,"B",36,"")) I NMIEN="" G XISUB
 S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"E",NMIEN,SUBSET,CIEN)) Q:CIEN=""  S ^TMP("BSTSISUB",$J,CIEN)=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I")
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Make the call until success - Hang max of 12 times
 S ABORT=0 F TRY=1:1:(12*MFAIL) D  Q:$D(^XTMP("BSTSLCMP","QUIT"))  I +STS=2!(STS="0^") Q
 . NEW IN,OUT
 . S IN=SUBSET_"^^2",FCNT=0
 . S OUT=$NA(^TMP("BSTSSUPD",$J)) K @OUT
 . S BSTSBPRC=1  ;Set variable showing background call
 . D RESET^BSTSWSV1 ;Make sure the link is on
 . S STS=$$SUBLST^BSTSAPI(OUT,IN) I +STS=2 Q  ;Quit if success
 . Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .. S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUB^BSTSVOD1 - Processing subset: "_SUBSET)
 . I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON SUBSET: "_SUBSET)
 . S FCNT=0
 ;
 ;Look for removed entries
 I ABORT=0 S CIEN="" F  S CIEN=$O(^TMP("BSTSISUB",$J,CIEN)) Q:CIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW LMOD,DTSID,ABORT,FCNT,TRY
 . S DTSID=$G(^TMP("BSTSISUB",$J,CIEN)) Q:DTSID=""
 . ;
 . ;Check last modified - skip if today
 . S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") I LMOD'<DT Q
 . ;
 . ;Pull detail from DTS - Hang max of 12 times
 . S (ABORT,FCNT)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^36^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"ISUB^BSTSVRSN - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL(SUBSET_" SUBSET REFRESH FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 ;
XISUB L -^BSTS(9002318.1,0)
 K ^TMP("BSTSISUB",$J)
 Q
 ;
UPCNC ;Refresh any outdated concepts
 ;
 NEW DTSID,ABORT,CIEN,STS,MFAIL,FWAIT,X1,X2,X
 ;
 ;
 ;Perform lock
 L +^BSTS(9002318.1,0):0 E  Q
 ;
 ;Reset Monitoring Global
 K ^XTMP("BSTSLCMP")
 ;
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up Monitoring Global
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"Updating concepts found to be out of date"
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Look for removed entries
 S ABORT=0,STS="" S CIEN="" F  S CIEN=$O(^XTMP("BSTSPROCQ","C",CIEN)) Q:CIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW LMOD,DTSID,FCNT,TRY,DTSID,NMID,OOD
 . ;
 . ;Get DTSId
 . S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",".08","I") I DTSID="" K ^XTMP("BSTSPROCQ","C",CIEN) Q
 . ;
 . ;Get NMID
 . S NMID=$$GET1^DIQ(9002318.4,CIEN_",",.07,"E") I NMID="" K ^XTMP("BSTSPROCQ","C",CIEN) Q
 . ;
 . ;Check last modified - skip if today
 . S OOD=$$GET1^DIQ(9002318.4,CIEN_",",".11","I")
 . S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") I OOD'="Y",LMOD'<DT K ^XTMP("BSTSPROCQ","C",CIEN) Q
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Updating out of date entry with DTSID: "_DTSID
 . ;Pull detail from DTS - Hang max of 12 times
 . S (ABORT,FCNT)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^"_NMID_"^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"UPCNC^BSTSVOF1 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("UPCNC^BSTSVOF1 Refresh failed on entry: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Clear entry
 . I +STS=2!(STS="0^") K ^XTMP("BSTSPROCQ","C",CIEN)
 ;
XUPCNC ;
 ;
 ;Unlock entry
 L -^BSTS(9002318.1,0)
 ;
 ;Reset Monitoring Global
 K ^XTMP("BSTSLCMP")
 ;
 Q
 ;
CLLMDT(NMID) ;Mark CODESET concepts last modified date to null
 ;
 I $G(NMID)="" Q
 ;
 NEW ICONC,CIEN
 ;
 ;Loop through concepts and clear out modified date for codes in codeset
 S ^XTMP("BSTSLCMP","STS")="Marking entries as out of date"
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,CIEN)) Q:CIEN=""  D
 .. NEW CDSET,BSTS,ERR,LMD,OOD
 .. ;
 .. ;Skip partial entries
 .. I $$GET1^DIQ(9002318.4,CIEN_",",.03,"I")="P" Q
 .. ;
 .. ;Don't clear if updated today (or later as process could run across days)
 .. S OOD=$$GET1^DIQ(9002318.4,CIEN_",",.11,"I")
 .. S LMD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I")
 .. I OOD'="Y",LMD'<DT Q
 .. ;
 .. ;Mark as out of date
 .. S ^XTMP("BSTSLCMP","STS")="Marking entry "_CIEN_" as out of date"
 .. S BSTS(9002318.4,CIEN_",",".12")="@"
 .. D FILE^DIE("","BSTS","ERR")
 ;
 Q
 ;
DAYCHK ;Perform daily update checks - jobbed off by CHECK^BSTSVRSN
 ;
 NEW BSTS,STS,NMIEN,ZTSK,SITE,ERROR
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) I 'SITE G XDAYCHK
 ;
 ;Check for new SNOMED CT US Extension '36' version - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(36)
 ;
 ;Check for new RxNorm R '1552' version - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(1552)
 ;
 ;Check for new UNII '5180' version - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(5180)
 ;
 ;Check for new IHS VANDF '32771' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32771)
 ;
 ;Check for new GMRA Signs Symptoms '32772' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32772)
 ;
 ;Check for new GMRA Allergies with Maps '32773' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32773)
 ;
 ;Check for new IHS Med Route '32774' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32774)
 ;
 ;Check for new CPT Meds with Maps '32775' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32775)
 ;
 ;Check for new SNOMED CT to ICD-10-CM Auto-Codeables '32777' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32777)
 ;
 ;Check for new SNOMED CT to ICD-10-CM Auto-Codeables '32779' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32779)
 ;
 ;BSTS*1.0*7;Added 32780 check
 ;Check for new SNOMED CT to ICD-10-CM Auto-Codeables '32780' - Quit if check performed or DTS timed out
 S STS=$$VCHK^BSTSVRSN(32780)
 ;
 ;Check for new SNOMED CT to ICD-9-CM Auto-Codeables '32778' - Quit if check performed or DTS timed out
 ;BSTS*1.0*6;No longer look for ICD9 updates
 ;S STS=$$VCHK(32778) I STS G XCHECK
 ;
 ;Check for needed subset refresh - Also refresh VUID/NDC entries
 S NMIEN=$O(^BSTS(9002318.1,"B",36,"")) I NMIEN="" G XDAYCHK
 I $$GET1^DIQ(9002318.1,NMIEN_",",.06,"I")'=DT D SCHK^BSTSVRSN(36,1)
 ;
 ;Check for needed RxNorm subset refresh
 S NMIEN=$O(^BSTS(9002318.1,"B",1552,"")) I NMIEN="" G XDAYCHK
 I $$GET1^DIQ(9002318.1,NMIEN_",",.06,"I")'=DT D SCHK^BSTSVRXN(1552,1)
 ;
 ;BSTS*1.0*8;Process no longer works
 ;Check to see if ICD9 to SMD process needs run - Only run once
 ;I $$GET1^DIQ(9002318.1,NMIEN_",",".09","I")="" D QUEUE^BSTSVOFL("ICD")
 ;
 ;Schedule daily error purge
 D QUEUE^BSTSVOFL("PRG")
 ;
 ;Completed checks for day - mark parameter
 S BSTS(9002318,SITE_",",.03)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
 ;Schedule the process to run at 6:02
 S ZTSK=$$JOB^BSTSVOFL()
 ;
XDAYCHK Q
