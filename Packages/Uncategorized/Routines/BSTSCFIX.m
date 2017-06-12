BSTSCFIX ;GDIT/HS/BEE-Utility to fix duplicate terms in files ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4,5**;Sep 10, 2014;Build 9
 ;
EN ;EP - Main entry point
 ;
 NEW DIR,X,Y,FIX,CT,BST
 ;
 W !!
 S BST(1)="This utility will loop through files that contain SNOMED description ids and"
 S BST(2)="will check to make sure a term can be found for that description id.  If a"
 S BST(3)="term cannot be found, it attempts to look in DTS for an exact match.  For each"
 S BST(4)="match that is found the entry gets replaced with the new entry."
 D EN^DDIOL(.BST)
 K BST
 ;
 S DIR(0)="S^C:Check for Missing Concept Detail;R:Run Background Process to Fix Bad Entries;Q:Quit"
 D ^DIR
 ;
 ;Handle Quits
 I Y'="C",Y'="R" G XEN
 ;
 ;Check call
 I Y="C" S FIX=$$CHECK() S Y=$S(FIX:"R",1:"")
 ;
 ;Fix call
 I Y="R" D FIX G XEN
 ;
XEN Q
 ;
CHECK() ;Look for bad entries
 ;
 L +^XTMP("BSTSCFIX"):0 E  D  Q 0  ;Already running
 . NEW RUN
 . W !!,"A background fix process is running. Please try again later"
 . S RUN=$G(^XTMP("BSTSCFIX","RUN")) Q:'+RUN
 . W !,"Current Status: ",$G(^XTMP("BSTSCFIX",RUN,"STS"))
 . H 3
 L -^XTMP("BSTSCFIX")
 ;
 NEW IEN,FIX,DIR,X,Y,STS,VAR
 ;
 W !!,"This option loops through the PROBLEM, PROVIDER NARRATIVE, FAMILY HISTORY"
 W !,"and V POV files and locates concepts with no detail associated with them.",!
 ;
 S DIR("A")="Are you sure you wish to proceed? "
 S DIR(0)="Y",DIR("B")="No"
 D ^DIR
 I Y'=1 Q 0
 ;
 ;Make sure DTS is working
 S STS=$$SEARCH^BSTSAPI("VAR","COMMON COLD^F")
 I +STS'=2 D  Q 0
 . W !!,"BSTS is set to local. It must be running properly in order to run this option"
 . W !,"Please run the STS option in the BSTSMENU to troubleshoot the BSTS connection"
 . H 3
 ;
 ;Reset flag
 S FIX=0
 ;
 ;First look in problem file
 W !!,"Reviewing PROBLEM file entries: "
 W !,"Problem IEN",?20,"Patient",?60,"Description Id"
 S IEN=0 F  S IEN=$O(^AUPNPROB(IEN)) Q:'IEN  D
 . NEW DSCID,DESC,DFN
 . ;
 . ;Ignore deleted problems
 . I $$GET1^DIQ(9000011,IEN_",",2.02,"I")]"" Q
 . ;
 . S DSCID=$P($G(^AUPNPROB(IEN,800)),U,2) Q:DSCID=""
 . D RESET^BSTSWSV1 ;Make sure the link is on
 . S DESC=$$DESC^BSTSAPI(DSCID)
 . ;
 . ;Skip if description found
 . I $TR(DESC,"^")]"" Q
 . ;
 . S FIX=1
 . S DFN=$P($G(^AUPNPROB(IEN,0)),U,2)
 . W !,IEN,?20,$P($G(^DPT(DFN,0)),U),?60,DSCID
 ;
 ;Check PROVIDER NARRATIVE file
 W !!,"Reviewing PROVIDER NARRATIVE entries: "
 W !,"IEN",?60,"Description Id"
 S IEN=0 F  S IEN=$O(^AUTNPOV(IEN)) Q:'IEN  D
 . NEW NARR,DSCID,DESC
 . ;
 . ;Get the Description ID from the Narrative - Quit if not converted to SNOMED
 . S NARR=$$GET1^DIQ(9999999.27,IEN_",",.01,"I")
 . S DSCID=$P(NARR,"|",2) I +DSCID=0 Q
 . D RESET^BSTSWSV1 ;Make sure the link is on
 . S DESC=$$DESC^BSTSAPI(DSCID)
 . ;
 . ;Skip if description found
 . I $TR(DESC,"^")]"" Q
 . ;
 . S FIX=1
 . W !,IEN,?60,DSCID
 ;
 ;Check V POV file
 W !!,"Reviewing V POV entries: "
 W !,"VPOV IEN",?15,"Patient",?42,"Visit",?60,"Description Id"
 S IEN=0 F  S IEN=$O(^AUPNVPOV(IEN)) Q:'IEN  D
 . NEW DSCID,DESCID,DFN
 . ;
 . ;Get the Description ID - Quit if not converted to SNOMED
 . S DSCID=$$GET1^DIQ(9000010.07,IEN_",",1102,"I") I +DSCID=0 Q
 . D RESET^BSTSWSV1 ;Make sure the link is on
 . S DESC=$$DESC^BSTSAPI(DSCID)
 . ;
 . ;Skip if description found
 . I $TR(DESC,"^")]"" Q
 . ;
 . S FIX=1
 . S DFN=$P($G(^AUPNVPOV(IEN,0)),U,2)
 . W !,IEN,?15,$E($P($G(^DPT(DFN,0)),U),1,23),?41,$E($$GET1^DIQ(9000010.07,IEN_",",".03","E"),1,17),?60,DSCID
 ;
 ;Check FAMILY HISTORY
 W !!,"Reviewing FAMILY HISTORY entries: "
 W !,"IEN",?15,"Patient",?60,"Description Id"
 S IEN=0 F  S IEN=$O(^AUPNFH(IEN)) Q:'IEN  D
 . NEW DSCID,DESC,DFN
 . ;
 . ;Get the Description ID - Quit if not converted to SNOMED
 . S DSCID=$$GET1^DIQ(9000014,IEN_",",.14,"I") I +DSCID=0 Q
 . D RESET^BSTSWSV1 ;Make sure the link is on
 . S DESC=$$DESC^BSTSAPI(DSCID)
 . ;
 . ;Skip if description found
 . I $TR(DESC,"^")]"" Q
 . ;
 . S FIX=1
 . S DFN=$P($G(^AUPNFH(IEN,0)),U,2)
 . W !,IEN,?15,$P($G(^DPT(DFN,0)),U),?60,DSCID
 ;
 ;If issues, check if they want to run the fix
 I FIX=0 D  Q 0
 . W !!,"No issues were encountered.  There is no need to run the fix option."
 . H 3
 ;
 W !!,"Concepts without detail were encountered",!
 S DIR("A")="Would you like to job off the fix option now? "
 S DIR(0)="Y",DIR("B")="No"
 D ^DIR
 I Y'=1 S FIX=0
 ;
 Q FIX
 ;
FIX ;Kick off background fix process
 ;
 L +^XTMP("BSTSCFIX"):0 E  D  Q   ;Already running
 . NEW RUN
 . W !!,"A background fix process is running. Please try again later"
 . S RUN=$G(^XTMP("BSTSCFIX","RUN")) Q:'+RUN
 . W !,"Current Status: ",$G(^XTMP("BSTSCFIX",RUN,"STS"))
 . H 3
 L -^XTMP("BSTSCFIX")
 ;
 NEW DIR,X,Y,VAR,STS
 ;
 ;Make sure DTS is working
 D RESET^BSTSWSV1
 S STS=$$SEARCH^BSTSAPI("VAR","COMMON COLD^F")
 I +STS'=2 D  Q
 . W !!,"BSTS is set to local. It must be running properly in order to run this option"
 . W !,"Please run the STS option in the BSTSMENU to troubleshoot the BSTS connection"
 . H 3
 ;
 W !!,"This option kicks off a background process which will attempt to fix concepts"
 W !,"with no detail associated with them.",!
 ;
 S DIR("A")="Are you sure you wish to proceed? "
 S DIR(0)="Y",DIR("B")="No"
 D ^DIR
 I Y'=1 Q
 ;
FIX1 ;Kick off process to convert invalid description ids to valid description ids
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSK
 ;
 ;Queue the process off in the background
 K IO("Q")
 ;
 S ZTRTN="START^BSTSCFIX",ZTDESC="BSTS - Replace invalid description ids with valid ones"
 S ZTIO=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,2)
 D ^%ZTLOAD
 ;
 Q
 ;
START ;Called by background job
 ;
 ;Lock so only one process can run at a time
 L +^XTMP("BSTSCFIX"):0 E  Q   ;Already running
 ;
 NEW BSTSSRV,PRI,STS,II,DEBUG,X1,X2,X,RUN,%,%H,%I
 ;
 ;Get date
 I $G(DT)="" D DT^DICRW
 ;
 ;Define DEBUG
 S DEBUG=""
 ;
 ;Get a later date
 D NOW^%DTC
 S X1=DT,X2=120 D C^%DTC
 ;
 ;Initialize ^XTMP entry
 K ^XTMP("BSTSCFIX","QUIT")
 S $P(^XTMP("BSTSCFIX",0),U)=X  ;Set date in the future
 S $P(^XTMP("BSTSCFIX",0),U,2)=DT  ;Set current date
 S $P(^XTMP("BSTSCFIX",0),U,3)="Results of BSTSCFIX conversion"
 S (RUN,^XTMP("BSTSCFIX","RUN"))=$G(^XTMP("BSTSCFIX","RUN"))+1  ;Increment Run counter
 S ^XTMP("BSTSCFIX",RUN,0)=%_U_$G(DUZ)
 K ^XTMP("BSTSCFIX","MAP")  ;Reset mappings
 K ^XTMP("BSTSCFIX","QUIT")
 ;
 ;Get a list of the servers available
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through server list and perform conversion on the first active one
 ;
 ;Check for active server
 I $D(BSTSSRV)<10 D STS(RUN,"STS","No Active Server Found") Q
 ;
 ;Loop through each until a good one is found
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . NEW BSTSWS,TYPE,TIME,CSTS,SRV
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . S SRV="SRV"_(II-1)
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS D STS(RUN,SRV,$G(BSTSWS("URLROOT"))_": Set to Local") Q
 . ;
 . ;Perform conversion using specified server
 . D STS(RUN,SRV,$G(BSTSWS("URLROOT")))
 . I TYPE="D" S STS=$$DSC(.BSTSWS,RUN)
 ;
 ;Mark as completed
 I +STS D STS(RUN,"STS","Process Completed")
 L -^XTMP("BSTSCFIX")
 Q
 ;
DSC(BSTSWS,RUN) ;Loop through files and replace bad entries
 ;
 NEW SNAPDT,IEN,DSCID,REMAPTO,STS
 ;
 ;Set up remaining array entries needed by DTS call
 S SNAPDT=$$DTCHG^BSTSUTIL(DT,2)_".0001"
 S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 S BSTSWS("STYPE")="F"
 S BSTSWS("NAMESPACEID")=36
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("MAXRECS")=100
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("TBYPASS")=""
 ;
 ;Check PROBLEM file
 S STS=1,IEN=0 F  S IEN=$O(^AUPNPROB(IEN)) Q:'IEN  D  I $D(^XTMP("BSTSCFIX","QUIT")) D STS(RUN,"STS","Process Aborted") S STS=0 Q
 . D STS(RUN,"STS","Checking PROBLEM file entry: "_IEN)
 . NEW DSCID,MAPTO,BSTSUPD,ERROR
 . ;
 . ;Ignore deleted problems
 . I $$GET1^DIQ(9000011,IEN_",",2.02,"I")]"" Q
 . ;
 . ;Get the Description ID - Quit if not converted to SNOMED
 . S DSCID=$$GET1^DIQ(9000011,IEN_",",80002,"I") Q:DSCID=""
 . ;
 . ;Look for replacement
 . S MAPTO=$$REPLACE(DSCID,.BSTSWS) Q:MAPTO=""
 . ;
 . ;Replace
 . S BSTSUPD(9000011,IEN_",",80002)=MAPTO
 . D FILE^DIE("","BSTSUPD","ERROR")
 . D ESTS(RUN,9000011,80002,IEN,DSCID,MAPTO)
 I STS=0 Q 0
 ;
 ;Check PROVIDER NARRATIVE file
 S IEN=0 F  S IEN=$O(^AUTNPOV(IEN)) Q:'IEN  D  I $D(^XTMP("BSTSCFIX","QUIT")) D STS(RUN,"STS","Process Aborted") S STS=0 Q
 . D STS(RUN,"STS","Checking PROVIDER NARRATIVE file entry: "_IEN)
 . NEW DSCID,MAPTO,BSTSUPD,ERROR,NARR,ONARR
 . ;
 . ;Get the Description ID from the Narrative - Quit if not converted to SNOMED
 . S (NARR,ONARR)=$$GET1^DIQ(9999999.27,IEN_",",.01,"I")
 . S DSCID=$P(NARR,"|",2) I +DSCID=0 Q
 . ;
 . ;Look for replacement
 . S MAPTO=$$REPLACE(DSCID,.BSTSWS) Q:MAPTO=""
 . ;
 . ;Replace
 . S $P(NARR,"|",2)=MAPTO
 . S BSTSUPD(9999999.27,IEN_",",".01")=NARR
 . D FILE^DIE("","BSTSUPD","ERROR")
 . D ESTS(RUN,9999999.27,.01,IEN,ONARR,NARR)
 I STS=0 Q 0
 ;
 ;Check V POV file
 S IEN=0 F  S IEN=$O(^AUPNVPOV(IEN)) Q:'IEN  D  I $D(^XTMP("BSTSCFIX","QUIT")) D STS(RUN,"STS","Process Aborted") S STS=0 Q
 . D STS(RUN,"STS","Checking V POV file entry: "_IEN)
 . NEW DSCID,MAPTO,BSTSUPD,ERROR
 . ;
 . ;Get the Description ID - Quit if not converted to SNOMED
 . S DSCID=$$GET1^DIQ(9000010.07,IEN_",",1102,"I") I +DSCID=0 Q
 . ;
 . ;Look for replacement
 . S MAPTO=$$REPLACE(DSCID,.BSTSWS) Q:MAPTO=""
 . ;
 . ;Replace
 . S BSTSUPD(9000010.07,IEN_",","1102")=MAPTO
 . D FILE^DIE("","BSTSUPD","ERROR")
 . D ESTS(RUN,9000010.07,1102,IEN,DSCID,MAPTO)
 I STS=0 Q 0
 ;
 ;Check FAMILY HISTORY
 S IEN=0 F  S IEN=$O(^AUPNFH(IEN)) Q:'IEN  D  I $D(^XTMP("BSTSCFIX","QUIT")) D STS(RUN,"STS","Process Aborted") S STS=0 Q
 . D STS(RUN,"STS","Checking FAMILY HISTORY file entry: "_IEN)
 . NEW DSCID,MAPTO,BSTSUPD,ERROR
 . ;
 . ;Get the Description ID - Quit if not converted to SNOMED
 . S DSCID=$$GET1^DIQ(9000014,IEN_",",.14,"I") I +DSCID=0 Q
 . ;
 . ;Look for replacement
 . S MAPTO=$$REPLACE(DSCID,.BSTSWS) Q:MAPTO=""
 . ;
 . ;Replace
 . S BSTSUPD(9000014,IEN_",",".14")=MAPTO
 . D FILE^DIE("","BSTSUPD","ERROR")
 . D ESTS(RUN,9000014,".14",IEN,DSCID,MAPTO)
 I STS=0 Q 0
 ;
 Q 1
 ;
REPLACE(DSCID,BSTSWS) ;Look for replacement description id
 ;
 NEW DESC,STS,REMAPTO,MFAIL,FWAIT,TRY,FCNT,ABORT
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;See if already mapped (may not have found one)
 ;Use that value to make things quicker
 I $D(^XTMP("BSTSCFIX","MAP",DSCID)) S REMAPTO=^XTMP("BSTSCFIX","MAP",DSCID) Q $S(DSCID'=REMAPTO:REMAPTO,1:"")
 ;
 ;Attempt to pull the value locally
 ;If found, set map and quit
 S DESC=$$DESC^BSTSAPI(DSCID)
 I $P(DESC,U)]"",$P(DESC,U,2)]"" S ^XTMP("BSTSCFIX","MAP",DSCID)=DSCID Q ""
 ;
 ;Next try remote search - Clear out offline mode flag to ensure call gets made
 ;If found, set map and quit
 S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$DSCLKP^BSTSAPI("VAR",DSCID_"^^2")
 . I +STS=2 S ^XTMP("BSTSCFIX","MAP",DSCID)=DSCID Q
 . I STS="0^" Q
 . S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .. S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"REPLACE^BSTSCFIX - Looking up DSC ID: "_DSCID)
 .. I ABORT=1 S ^XTMP("BSTSCFIX","QUIT")=1 D ELOG^BSTSVOFL("DSCID LOOKUP UTILITY FAILED ON DSC ID: "_DSCID)
 .. S FCNT=0
 ;
 ;If not found, current term most likely has duplicate term in the concept
 ;try to locate the duplicate term
 ;
 S BSTSWS("SEARCH")=DSCID
 S REMAPTO=$$DSCLKP(.BSTSWS,MFAIL,FWAIT)
 ;
 ;Set up mapped entry
 S ^XTMP("BSTSCFIX","MAP",DSCID)=REMAPTO
 ;
 Q REMAPTO
 ;
DSCLKP(BSTSWS,MFAIL,FWAIT) ;
 ;
 NEW SEARCH,STYPE,SLIST,DLIST,NMID,STS,RES,DTSID,REMAPTO,TRY,FCNT,ABORT
 ;
 ;Initialize Return Value
 S REMAPTO=""
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSPDET",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @DLIST,@SLIST
 ;
 ;Perform Lookup on Concept Id
 S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$DSCSRCH^BSTSCMCL(.BSTSWS,.RES) I +STS Q
 . S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .. S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"DSCLKP^BSTSCFIX - Looking up: "_SEARCH)
 .. I ABORT=1 S ^XTMP("BSTSCFIX","QUIT")=1 D ELOG^BSTSVOFL("DSCID LOOKUP UTILITY FAILED ON LOOKUP: "_SEARCH)
 .. S FCNT=0
 ;
 S DTSID=$P($G(@DLIST@(1)),U) I DTSID D
 . ;
 . ;Loop through results and retrieve detail
 . ;
 . N STS,ERSLT,TLIST,STYPE,TCNT
 . ;
 . ;Update entry
 . S BSTSWS("DTSID")=DTSID
 . ;
 . ;Clear result file
 . K @DLIST
 . ;
 . ;Get Detail for concept
 . S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT) I +STS Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"DSCLKP^BSTSCFIX - Looking up DTSID: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSCFIX","QUIT")=1 D ELOG^BSTSVOFL("DSCID LOOKUP UTILITY FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Now loop through synonyms and try to find replacement
 . S STYPE="" F  S STYPE=$O(@DLIST@(1,"SYN",STYPE)) Q:STYPE=""  S TCNT="" F  S TCNT=$O(@DLIST@(1,"SYN",STYPE,TCNT)) Q:TCNT=""  D
 .. ;
 .. N TERM,DSC
 .. ;
 .. ;Pull values
 .. S TERM=$G(@DLIST@(1,"SYN",STYPE,TCNT,1)) Q:TERM=""
 .. S DSC=$P($G(@DLIST@(1,"SYN",STYPE,TCNT,0)),U) Q:DSC=""
 .. ;
 .. ;Remap if already found
 .. I $D(TLIST(TERM)) D  Q
 ... ;
 ... ;Only look at the one we passed in
 ... I DSC'=SEARCH Q
 ... S REMAPTO=$G(TLIST(TERM))
 .. ;
 .. ;Set up entry in array
 .. S TLIST(TERM)=DSC
 ;
 Q REMAPTO
 ;
STS(RUN,NODE,MSG) ;Enter RUN status entry
 ;
 I $G(RUN)="" Q
 I $G(NODE)="" Q
 ;
 ;Enter the status
 S ^XTMP("BSTSCFIX",RUN,NODE)=$G(MSG)
 Q
 ;
ESTS(RUN,FILE,FIELD,IEN,FROM,TO) ;Log changed entry
 ;
 I $G(RUN)="" Q
 I $G(FILE)="" Q
 I $G(FIELD)="" Q
 ;
 NEW %,%H,%I,X
 ;
 ;Get the time
 D NOW^%DTC
 ;
 ;Log the entry
 S ^XTMP("BSTSCFIX",RUN,FILE,FIELD,IEN)=%_U_$G(DUZ)_U_FROM_U_TO
 Q
