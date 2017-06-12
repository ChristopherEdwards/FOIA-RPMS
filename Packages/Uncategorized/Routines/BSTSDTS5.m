BSTSDTS5 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
CDST ;EP - Update IHS Standard Terminology Codeset
 ;
 ;Tasked by BSTSVRSC, tab CCHK.  Var NMIEN should be set
 ;
 S NMIEN=$G(NMIEN) I NMIEN="" Q
 ;
 ;Lock
 L +^BSTS(9002318.1,0):0 E  Q
 ;
 NEW BSTSWS,RESULT,NMID,STS,VRSN,BSTS,ICONC,CIEN,X1,X2,X,NVIEN,NVLCL,MFAIL,FWAIT,TRY,FCNT,ABORT,TRY
 ;
 ;Get ext codeset Id
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" G XCDST
 ;
 ;Update LAST VERSION CHECK so proc won't keep getting called
 S BSTS(9002318.1,NMIEN_",",.05)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
 ;Online?
 S STS="" F TRY=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try
 . I +STS'=2 H TRY
 I +STS'=2 G XCDST
 ;
 ;Reset Monitoring GBL
 K ^XTMP("BSTSLCMP")
 ;
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set Monitoring GBL
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"Cache refresh running for "_NMID
 ;
 ;Mark as OOD
 S ^XTMP("BSTSLCMP","STS")="Marking entries as out of date"
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,CIEN)) Q:CIEN=""  D
 . NEW BSTS,ERR,LMOD
 . ;
 . ;Mark OOD
 . S BSTS(9002318.4,CIEN_",",".12")=""
 . D FILE^DIE("","BSTS","ERR")
 ;
 ;Make call to proc
 S ^XTMP("BSTSLCMP","STS")="Performing Refresh from DTS"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("REVIN")=$$FMTE^XLFDT(DT,"7")
 S STS=$$CSTMCDST^BSTSWSV1("RESULT",.BSTSWS)
 I +STS=0 G XCDST  ;Quit if update failed
 I $D(^XTMP("BSTSLCMP","QUIT")) G XCDST
 ;
 ;Now refresh entries for codeset that have not been updated (to handle deletes)
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,CIEN)) Q:CIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW BSTS,ERR,TIEN,DA,DIK
 .. ;
 .. ;Quit if updated
 .. I $$GET1^DIQ(9002318.4,CIEN_",",".12","I")]"" Q
 .. ;
 .. ;Update monitor
 .. S ^XTMP("BSTSLCMP","STS")="Removing retired mapping "_CIEN
 .. ;
 .. ;First remove terms
 .. S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CIEN,TIEN)) Q:TIEN=""  D
 ... NEW DA,DIK
 ... S DA=TIEN,DIK="^BSTS(9002318.3," D ^DIK
 .. ;
 .. ;Remove concept
 .. S DA=CIEN,DIK="^BSTS(9002318.4," D ^DIK
 ;
 ;Retrieve Failover Vars
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Loop through, grab concept that mappings linked to
 S ABORT=0,ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW IEN
 . S IEN="" F  S IEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,IEN)) Q:IEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW AS
 .. S AS=0 F  S AS=$O(^BSTS(9002318.4,IEN,9,AS)) Q:'AS  D
 ... NEW NODE,NM,DTS,VAR,FCNT,TRY
 ... S NODE=$G(^BSTS(9002318.4,IEN,9,AS,0))
 ... S ^XTMP("BSTSLCMP","STS")="Getting Association details for entry: "_ICONC
 ... S NM=$P(NODE,U,2) Q:NM=""
 ... S DTS=$P(NODE,U,3) Q:DTS=""
 ... ;
 ... ;Update entry-Hang max of 12 times
 ... S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .... D RESET^BSTSWSV1  ;Reset the DTS link to on
 .... S STS=$$DTSLKP^BSTSAPI("VAR",DTS_"^"_NM) I +STS=2!(STS="0^") Q
 .... S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ..... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CDST^BSTSVRSC - Getting Assoc for entry: "_DTS)
 ..... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CUSTOM CODESET REFRESH FAILED ON DETAIL ENTRY: "_DTS)
 ..... S FCNT=0
 ;
 ;Check for failure
 I +STS=0 G XCDST
 I $D(^XTMP("BSTSLCMP","QUIT")) G XCDST
 ;
 ;Get current version from mult
 S NVIEN=$O(^BSTS(9002318.1,NMIEN,1,"A"),-1)
 S NVLCL="" I +NVIEN>0 D
 . NEW DA,IENS
 . S DA(1)=NMIEN,DA=+NVIEN,IENS=$$IENS^DILF(.DA)
 . S NVLCL=$$GET1^DIQ(9002318.11,IENS,".01","I")
 ;
 ;Save CURRENT VERSION
 I NVLCL]"" D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.04)=NVLCL
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Reset Monitoring GBL
XCDST NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 ;Unlock
 L -^BSTS(9002318.1,0)
 ;
 Q
 ;
CSTMCDST(RET,BSTSWS) ;Get list of custom codeset entries
 ;
 NEW SLIST,DLIST,CNT,NMID,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,TR,NMIEN
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
RCODE(BSTSWS,ACODE) ;Retrieve list of concepts in RxNorm subsets and refresh
 ;
 ;Input
 ;BSTSWS - Array of connection settings
 ;ACODE - If 1 do no process items here
 ;
 NEW SLIST,DLIST,SBCNT,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,REVIN,X1,X2,X,RUNSTRT,TR
 ;
 S ACODE=$G(ACODE)
 ;
 ;Get the current date
 S RUNSTRT=DT
 ;
 ;Get future date and set up revision in
 S X1=DT,X2=2 D C^%DTC
 S BSTSWS("REVIN")=$$FMTE^XLFDT(X,"7")
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
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up Monitoring Global
 I 'ACODE D
 . S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"RxNorm subset refresh update running - Getting list"
 . K ^XTMP("BSTSLCMP","STS")
 ;
 ;Get list of concepts in subsets
 S ^XTMP("BSTSLCMP","STS")="Generating a list of concepts in subsets"
 ;
 ;BSTS*1.0*8;Extra error handling
 F TR=1:1:60 D  I +STS Q
 .S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$RCODE^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"RCODE^BSTSDTS5 - Call to $$RCODE^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("RXNORM SUBSET REFRESH LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Merge results to second scratch global
 S SBCNT=0 F  S SBCNT=$O(@DLIST@(SBCNT)) Q:'SBCNT  D
 . NEW DTSID,LAST
 . S DTSID=$P(@DLIST@(SBCNT),U) Q:DTSID=""
 . I $D(@SLIST@("DTS",DTSID)) Q
 . S LAST=$O(@SLIST@("A"),-1)+1
 . S @SLIST@(LAST)=@DLIST@(SBCNT)
 . S @SLIST@("DTS",DTSID)=LAST
 ;
 ;Do not process if part of main update
 I ACODE Q 1
 ;
 ;Get last entry
 S LENTRY=$O(@SLIST@("A"),-1)
 ;
 ;Now process each entry
 S (ABORT,SBCNT)=0 F  S SBCNT=$O(@SLIST@(SBCNT)) Q:'SBCNT  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW DTSID,VAR,TRY,FCNT,CIEN,SKIP
 . ;
 . ;Get DTSId
 . S DTSID=$P(@SLIST@(SBCNT),U) Q:DTSID=""
 . ;
 . ;Check last modified - skip if today
 . S CIEN=$O(^BSTS(9002318.4,"D",36,DTSID,""))
 . S SKIP=0 I CIEN]"" D
 .. NEW OOD,LMOD
 .. ;
 .. ;Force update of out of date concepts
 .. S OOD=$$GET1^DIQ(9002318.4,CIEN_",",.11,"I") I OOD="Y" Q
 .. S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",.12,"I") I LMOD'<RUNSTRT S SKIP=1
 .. I SKIP=1 S $P(@SLIST@(SBCNT),U,2)="Skipped"
 . I SKIP Q
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Getting concept details for DTSID: "_DTSID_" (Entry "_SBCNT_" of "_LENTRY_")"
 . ;
 . ;Pull detail from DTS - Hang max of 12 times
 . S (ABORT,FCNT)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") K @SLIST@(SBCNT) Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^1552^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"RCODE^BSTSDTS5 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("RXNORM SUBSET REFRESH FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 ;
 ;Clear status
 K ^XTMP("BSTSLCMP","STS")
 ;
 I 'STS Q 0
 Q 1
 ;
 ;BSTS*1.0*8;Update RxNorm Subsets
UPRSUB(GL,CONCDA,BSTSC) ;Update RxNorm subsets
 ;
 ;Save Subsets
 ;
 ;Clear out existing entries
 NEW SB
 S SB=0 F  S SB=$O(^BSTS(9002318.4,CONCDA,4,SB)) Q:'SB  D
 . NEW DA,DIK
 . S DA(1)=CONCDA,DA=SB
 . S DIK="^BSTS(9002318.4,"_DA(1)_",4," D ^DIK
 ;
 I $D(@GL@("SUB"))>1 D
 . ;
 . NEW SB
 . S SB="" F  S SB=$O(@GL@("SUB",SB)) Q:SB=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",4,"
 .. S X=$P($G(@GL@("SUB",SB)),U) Q:X=""
 .. ;BSTS*1.0*8;Log ALL SNOMED
 .. ;I X="IHS PROBLEM ALL SNOMED" S BSTSC(9002318.4,CONCDA_",",.15)="Y"
 .. S DLAYGO=9002318.44 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.44,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SB)),U,2))
 ;
 ;Save NDC
 ;
 ;Clear out existing entries
 D
 . NEW NDC
 . S NDC=0 F  S NDC=$O(^BSTS(9002318.4,CONCDA,7,NDC)) Q:'NDC  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=NDC
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",7," D ^DIK
 I $D(@GL@("NDC"))>1 D
 . ;
 . NEW NDC
 . S NDC="" F  S NDC=$O(@GL@("NDC",NDC)) Q:NDC=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",7,"
 .. S X=$P($G(@GL@("NDC",NDC)),U) Q:X=""
 .. S DLAYGO=9002318.47 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.47,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("NDC",NDC)),U,2))
 .. S BSTSC(9002318.47,IENS,".03")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("NDC",NDC)),U,3))
 ;
 ;Save VUID
 ;
 ;Clear out existing entries
 D
 . NEW VD
 . S VD=0 F  S VD=$O(^BSTS(9002318.4,CONCDA,8,VD)) Q:'VD  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=VD
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",8," D ^DIK
 I $D(@GL@("VUID"))>1 D
 . ;
 . NEW VD
 . S VD="" F  S VD=$O(@GL@("VUID",VD)) Q:VD=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",8,"
 .. S X=$P($G(@GL@("VUID",VD)),U) Q:X=""
 .. S DLAYGO=9002318.48 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.48,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("VUID",VD)),U,2))
 .. S BSTSC(9002318.48,IENS,".03")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("VUID",VD)),U,3))
 ;
 ;Save TTY
 ;
 ;Clear out existing entries
 D
 . NEW TTY
 . S TTY=0 F  S NDC=$O(^BSTS(9002318.4,CONCDA,12,TTY)) Q:'TTY  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=TTY
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",12," D ^DIK
 I $D(@GL@("TTY"))>1 D
 . ;
 . NEW TTY
 . S TTY="" F  S TTY=$O(@GL@("TTY",TTY)) Q:TTY=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",12,"
 .. S X=$P($G(@GL@("TTY",TTY)),U) Q:X=""
 .. S DLAYGO=9002318.412 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.412,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("TTY",TTY)),U,2))
 .. S BSTSC(9002318.412,IENS,".03")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("TTY",TTY)),U,3))
 ;
 Q
