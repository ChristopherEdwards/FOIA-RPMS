BSTSDTS3 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4,5,6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
ACODE(RET,BSTSWS) ;Get list of '36' entries having auto-codable ICD-10s
 ;
 NEW SLIST,DLIST,CNT,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,TR
 ;
 S SLIST=$NA(^XTMP("BSTSLCMP")) ;Returned List
 S DLIST=$NA(^TMP("BSTSCMCL",$J))
 K @DLIST
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;BSTS*1.0*8;Extra error handling
 F TR=1:1:60 D  I +STS Q
 . ;Get List of ICD10 Autocodeables - 32777
 . S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$ACODE^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"ACODE^BSTSDTS3 - Call to $$ACODE^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED TO ICD10 MAPPING LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Move results to second scratch global
 S CNT=0 F  S CNT=$O(@DLIST@(CNT)) Q:'CNT  S @SLIST@(CNT)=@DLIST@(CNT)
 M @SLIST@("DTS")=@DLIST@("DTS")
 ;
 ;Get List of ICD10 Autocodeable Predicates - 32779
 K @DLIST
 ;BSTS*1.0*8;Extra error handling
 F TR=1:1:60 D  I +STS Q
 .S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$ACODEP^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"ACODEP^BSTSDTS3 - Call to $$ACODEP^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED TO ICD10 PREDICATE MAPPING LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Merge results to second scratch global
 S CNT=0 F  S CNT=$O(@DLIST@(CNT)) Q:'CNT  D
 . NEW DTSID,LAST
 . S DTSID=$P(@DLIST@(CNT),U) Q:DTSID=""
 . I $D(@SLIST@("DTS",DTSID)) Q
 . S LAST=$O(@SLIST@("A"),-1)+1
 . S @SLIST@(LAST)=@DLIST@(CNT)
 . S @SLIST@("DTS",DTSID)=LAST
 ;
 ;Get list of equivalency concepts
 S STS=$$EQLST^BSTSDTS4(DLIST,ABORT,FCNT,STS,TRY,MFAIL,.BSTSWS,.ERSLT,CNT,SLIST,FWAIT)
 ;
 ;Get the list of concepts in subsets
 S STS=$$SCODE^BSTSDTS4(.BSTSWS,1)
 ;
 ;Get last entry
 S LENTRY=$O(@SLIST@("A"),-1)
 ;
 ;Now process each entry
 S (ABORT,CNT)=0 F  S CNT=$O(@SLIST@(CNT)) Q:'CNT  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW DTSID,VAR,TRY,FCNT,CIEN,LMOD
 . ;
 . ;Get DTSId
 . S DTSID=$P(@SLIST@(CNT),U) Q:DTSID=""
 . ;
 . ;Check last modified - skip if today
 . S CIEN=$O(^BSTS(9002318.4,"D",36,DTSID,""))
 . ;BSTS*1.0*4;Do not do date check
 . I CIEN]"" S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") ;I LMOD'<DT Q
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Getting mapping details for DTSID: "_DTSID_" (Entry "_CNT_" of "_LENTRY_")"
 . ;Pull detail from DTS - Hang max of 12 times
 . S (ABORT,FCNT)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^36^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"ACODE^BSTSDTS3 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED TO ICD10 MAPPING FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Remove entry
 . K @SLIST@(CNT)
 ;
 Q STS
 ;
A9CODE(RET,BSTSWS) ;Get list of '36' entries having auto-codable ICD-9s
 ;
 NEW SLIST,DLIST,CNT,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,TR
 ;
 S SLIST=$NA(^XTMP("BSTSLCMP")) ;Returned List
 S DLIST=$NA(^TMP("BSTSCMCL",$J))
 K @DLIST
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 F TR=1:1:60 D  I +STS Q
 . S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$A9CODE^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"A9CODE^BSTSDTS3 - Call to A9CODE^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED TO ICD9 MAPPING LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Get last entry
 S LENTRY=$O(@DLIST@(""),-1)
 ;
 ;Move results to second scratch global
 S CNT=0 F  S CNT=$O(@DLIST@(CNT)) Q:'CNT  S @SLIST@(CNT)=@DLIST@(CNT)
 ;
 ;Now loop through and process each entry
 S (ABORT,CNT)=0 F  S CNT=$O(@SLIST@(CNT)) Q:'CNT  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW DTSID,VAR,TRY,FCNT,CIEN,LMOD
 . ;
 . ;Get DTSId
 . S DTSID=$P(@SLIST@(CNT),U) Q:DTSID=""
 . ;
 . ;Check last modified - skip if today
 . S CIEN=$O(^BSTS(9002318.4,"D",36,DTSID,""))
 . ;BSTS*1.0*4;Do not do date check
 . I CIEN]"" S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") ;I LMOD'<DT Q
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Getting mapping details for DTSID: "_DTSID_" (Entry "_CNT_" of "_LENTRY_")"
 . ;Pull detail from DTS - Hang max of 12 times
 . S FCNT=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^36^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"A9CODE^BSTSDTS3 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED TO ICD9 MAPPING FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Remove entry
 . K @SLIST@(CNT)
 ;
 ;Remove override
 K BSTSWS("ONLYLOAD")
 ;
 Q STS
 ;
CSTMCDST(RET,BSTSWS) ;Get list of custom codeset entries
 ;
 NEW SLIST,DLIST,CNT,NMID,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,TR
 ;
 S NMID=$G(BSTSWS("NAMESPACEID")) Q:NMID="" 0
 ;
 S SLIST=$NA(^XTMP("BSTSLCMP")) ;Returned List
 S DLIST=$NA(^TMP("BSTSCMCL",$J))
 K @DLIST
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 F TR=1:1:60 D  I +STS Q
 . S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$CSTMCDST^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CSTMCDST^BSTSDTS3 - Calling CSTMCDST^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CUSTOM CODESET "_NMID_" MAPPING LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Get last entry
 S LENTRY=$O(@DLIST@(""),-1)
 ;
 ;Move results to second scratch global
 S CNT=0 F  S CNT=$O(@DLIST@(CNT)) Q:'CNT  S @SLIST@(CNT)=@DLIST@(CNT)
 ;
 ;Now loop through and process each entry
 S (ABORT,CNT)=0 F  S CNT=$O(@SLIST@(CNT)) Q:'CNT  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW DTSID,VAR,TRY,FCNT
 . ;
 . ;Get the DTSId
 . S DTSID=$P(@SLIST@(CNT),U) Q:DTSID=""
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Getting mapping details for DTSID: "_DTSID_" (Entry "_CNT_" of "_LENTRY_")"
 . ;
 . ;Pull detail from DTS - Hang max of 12 times
 . S FCNT=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^"_NMID_"^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CSTMCDST^BSTSDTS3 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CUSTOM CODESET "_NMID_" MAPPING FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Remove entry
 . K @SLIST@(CNT)
 ;
 Q STS
 ;
SUPDATE(NMID,ROUT) ;EP-Add/Update Special Codeset Entries
 ;
 ;Special Codesets Only
 I ($G(NMID)=5180)!($G(NMID)=1552)!($G(NMID)=36) Q 1
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Look for Concept Id
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Look for existing entry
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull the current version
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;Handle retired concepts
 I CONCDA]"",'$$RET(CONCDA,CVRSN,GL) Q 0
 ;
 ;None found - create new entry
 I CONCDA="" S CONCDA=$$NEWC^BSTSDTS0()
 ;
 ;Verify entry found/created
 I +CONCDA<0 Q 0
 ;
 ;Get Revision Out
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 ;
 ;Set up top level concept fields
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Concept ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTS ID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$EP2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=$$EP2FMDT^BSTSUTIL(NROUT,1)
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 ;Need to interim save because subsets look at .07
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Save Subsets
 ;
 ;Clear out existing entries
 D
 . NEW SB
 . S SB=0 F  S SB=$O(^BSTS(9002318.4,CONCDA,4,SB)) Q:'SB  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=SB
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",4," D ^DIK
 I $D(@GL@("SUB"))>1 D
 . ;
 . NEW SB
 . S SB="" F  S SB=$O(@GL@("SUB",SB)) Q:SB=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",4,"
 .. S X=$P($G(@GL@("SUB",SB)),U) Q:X=""
 .. S DLAYGO=9002318.44 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.44,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SB)),U,2))
 ;
 ;Save Associations
 ;
 ;Clear out existing entries
 D
 . NEW AS
 . S AS=0 F  S AS=$O(^BSTS(9002318.4,CONCDA,9,AS)) Q:'AS  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=AS
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",9," D ^DIK
 I $D(@GL@("ASC"))>1 D
 . ;
 . ;
 . NEW AS
 . S AS="" F  S AS=$O(@GL@("ASC",AS)) Q:AS=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",9,"
 .. S X=$P($G(@GL@("ASC",AS)),U) Q:X=""
 .. S DLAYGO=9002318.49 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.49,IENS,".02")=$P($G(@GL@("ASC",AS)),U,2)
 .. S BSTSC(9002318.49,IENS,".03")=$P($G(@GL@("ASC",AS)),U,3)
 ;
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Now save Terminology entries
 ;
 ;Synonyms/Preferred/FSN
 ;
 S STYPE="" F  S STYPE=$O(@GL@("SYN",STYPE)) Q:STYPE=""  S TCNT="" F  S TCNT=$O(@GL@("SYN",STYPE,TCNT)) Q:TCNT=""  D
 . ;
 . N TERM,TYPE,DESC,BSTST,ERROR,TMIEN,AIN
 . ;
 . ;Pull values
 . S TERM=$G(@GL@("SYN",STYPE,TCNT,1)) Q:TERM=""
 . ;
 . ;Quit if already found
 . I $D(TLIST(TERM)) Q
 . S TLIST(TERM)=""
 . ;
 . S TYPE=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,2)
 . S TYPE=$S(TYPE=1:"P",1:"S")
 . I TERM=$G(@GL@("FSN",1)) S TYPE="F"
 . S DESC=$P($G(@GL@("SYN",STYPE,TCNT,0)),U) Q:DESC=""
 . S AIN=$$EP2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,3))
 . ;
 . ;Look up entry
 . S TMIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,""))
 . ;
 . ;Entry not found - create new one
 . I TMIEN="" S TMIEN=$$NEWT^BSTSDTS0()
 . I TMIEN<0 Q
 . ;
 . ;Save/update other fields
 . S BSTST(9002318.3,TMIEN_",",.02)=DESC
 . S BSTST(9002318.3,TMIEN_",",.09)=TYPE
 . S BSTST(9002318.3,TMIEN_",",1)=TERM
 . S BSTST(9002318.3,TMIEN_",",.04)="N"
 . S BSTST(9002318.3,TMIEN_",",.05)=CVRSN
 . S BSTST(9002318.3,TMIEN_",",.08)=INMID
 . S BSTST(9002318.3,TMIEN_",",.03)=CONCDA
 . S BSTST(9002318.3,TMIEN_",",.06)=AIN
 . S BSTST(9002318.3,TMIEN_",",.1)=DT
 . S BSTST(9002318.3,TMIEN_",",.11)="N"
 . D FILE^DIE("","BSTST","ERROR")
 . ;
 . ;Reindex - needed for custom indices
 . D
 .. NEW DIK,DA
 .. S DIK="^BSTS(9002318.3,",DA=TMIEN
 .. D IX^DIK
 ;
 ;Need to check for retired concepts again since it may have just been added
 S RTR=$$RET^BSTSDTS3(CONCDA,CVRSN,GL)
 ;
 Q $S($D(ERROR):"0^Update Failed",1:1)
 ;
RET(CONCDA,CVRSN,GL) ;Handle retired concepts
 ;
 ;Input
 ; CONCDA - Pointer to concept file, if populated
 ; CVRSN - Current codeset version
 ; GL - Name of scratch global
 ;
 ;Output - 1 - Retired Concept
 ;         0 - Active Concept
 ;
 NEW CURRENT,STATUS
 ;
 S CURRENT=$G(@GL@("CURRENT"))
 S STATUS=$G(@GL@("STS"))
 ;
 I STATUS'="A" D  Q 0
 . ;
 . ;Skip if not already defined
 . I CONCDA="" Q
 . ;
 . ;Entry is defined - Mark as out of date
 . NEW NROUT,BSTSC,ERR,NRIN,TIEN
 . S NRIN=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("CONCEPTID")),U,2))
 . S NROUT=$$DTS2FMDT^BSTSUTIL($P(CURRENT,U))
 . ;
 . ;Update the concept
 . S BSTSC(9002318.4,CONCDA_",",.05)=NRIN
 . S BSTSC(9002318.4,CONCDA_",",.06)=NROUT
 . S BSTSC(9002318.4,CONCDA_",",.11)="N"
 . S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 . S BSTSC(9002318.4,CONCDA_",",.12)=DT
 . D FILE^DIE("","BSTSC","ERR")
 . ;
 . ;Clear out existing subset entries
 . D
 .. NEW SB
 .. S SB=0 F  S SB=$O(^BSTS(9002318.4,CONCDA,4,SB)) Q:'SB  D
 ... NEW DA,DIK
 ... S DA(1)=CONCDA,DA=SB
 ... S DIK="^BSTS(9002318.4,"_DA(1)_",4," D ^DIK
 . ;
 . ;Now mark the terms as out of date
 . ;
 . ;Set up FSN, Synonyms, Preferred
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CONCDA,TIEN),-1) Q:TIEN=""  D
 .. ;
 .. ;Skip if not the same Concept Id
 .. I CONCDA'=$$GET1^DIQ(9002318.3,TIEN_",",".03","I") Q
 .. ;
 .. NEW BSTST,ERR
 .. ;
 .. ;Save/update other fields
 .. S BSTST(9002318.3,TIEN_",",.05)=CVRSN
 .. S BSTST(9002318.3,TIEN_",",.06)=NRIN
 .. S BSTST(9002318.3,TIEN_",",.07)=NROUT
 .. S BSTST(9002318.3,TIEN_",",.1)=DT
 .. S BSTST(9002318.3,TIEN_",",.11)="N"
 .. D FILE^DIE("","BSTST","ERROR")
 .. ;
 .. ;Reindex - needed for custom indices
 .. D
 ... NEW DIK,DA
 ... S DIK="^BSTS(9002318.3,",DA=TIEN
 ... D IX^DIK
 ;
 Q 1
