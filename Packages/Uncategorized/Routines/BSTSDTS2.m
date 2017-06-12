BSTSDTS2 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4**;Sep 10, 2014;Build 32
 ;
 Q
 ;
SEARCH(OUT,BSTSWS) ;EP - DTS4 Search Call
 ;
 N II,STS,SEARCH,STYPE,WORD,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,DUPLST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSSLST",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @SLIST,@DLIST,@OUT
 ;
 ;Determine maximum to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Loop through each word
 S BSTSWS("SEARCH")=SEARCH
 ;
 ;Perform DTS Search
 I STYPE="S" S STS=$$TRMSRCH^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Perform DTS concept search
 I STYPE="F" S STS=$$CONSRCH^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Loop through results and retrieve detail
 M @SLIST=@DLIST
 ;
 I $O(@SLIST@(""))]"" S II="",CNT=0 F  S II=$O(@SLIST@(II)) Q:II=""  D
 . NEW STATUS,CONC,ROUT,ERSLT,DSCID
 . ;
 . S DTSID=$P(@SLIST@(II),U) Q:DTSID=""
 . S DSCID=$P(@SLIST@(II),U,2) I STYPE="S",DSCID="" Q
 . ;
 . I $G(BSTSWS("DEBUG")) W !,"DTSID: ",DTSID
 . ;
 . ;Check for batch count
 . I $G(RCNT)'<BSCNT Q
 . ;
 . ;Check for maximum
 . I $G(RCNT)'<MAX Q
 . ;
 . ;Look for detail stored locally
 . ;
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 . I CONC]"" D  Q
 .. S CNT=CNT+1 I CNT<BSTRT Q  ;Check for starting point
 .. S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID_U_DSCID
 . ;
 . ;Not Found or in need of update
 . S BSTSWS("DTSID")=DTSID
 . ;
 . ;Clear result file
 . K @DLIST
 . ;
 . ;Get Detail for concept
 . S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 . ;
 . I $G(BSTSWS("DEBUG")) W !!,"DETAIL STATUS: ",STATUS
 . ;
 . ;File the Detail
 . S STATUS=$$UPDATE^BSTSDTS0(NMID)
 . ;
 . I $G(BSTSWS("DEBUG")) W !!,"UPDATE STATUS: ",STATUS
 . ;
 . ;Look again to see if concept now logged
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"CONC: ",CONC
 . I CONC]"" D  Q
 .. S CNT=CNT+1 I CNT<BSTRT Q  ;Check for start point
 .. S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID_U_DSCID
 K @DLIST,@SLIST
 ;
 Q STS
 ;
ICD2SMD(OUT,BSTSWS) ;EP - DTS4 ICD9 to SNOMED mapping retrieval
 ;
 N II,STS,SEARCH,STYPE,WORD,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,DUPLST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSPDET",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @SLIST,@DLIST,@OUT
 ;
 ;Determine maximum to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Loop through each word
 S BSTSWS("SEARCH")=SEARCH
 ;
 ;Perform DTS Call
 S STS=$$ICD2SMD^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Loop through results and retrieve detail
 M @SLIST=@DLIST
 I $O(@SLIST@(""))]"" S II="",CNT=0 F  S II=$O(@SLIST@(II)) Q:II=""  D
 . NEW STATUS,CONC,ROUT,ERSLT,DSCID
 . S DTSID=$P(@SLIST@(II),U) Q:DTSID=""
 . S DSCID=$P(@SLIST@(II),U,2) I STYPE="S",DSCID="" Q
 . ;
 . I $G(BSTSWS("DEBUG")) W !,"DTSID: ",DTSID
 . ;
 . ;Check for maximum
 . I $G(RCNT)'<MAX Q
 . ;
 . ;Look for detail stored locally
 . ;
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 . I CONC]"" D  Q
 .. S CNT=CNT+1 I CNT<BSTRT Q  ;Check for starting point
 .. S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID_U_DSCID
 . ;
 . ;Not Found or in need of update
 . S BSTSWS("DTSID")=DTSID
 . ;
 . ;Clear result file
 . K @DLIST
 . ;
 . ;Get Detail for concept
 . S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 . ;
 . I $G(BSTSWS("DEBUG")) W !!,"DETAIL STATUS: ",STATUS
 . ;
 . ;File the Detail
 . S STATUS=$$UPDATE^BSTSDTS0(NMID)
 . ;
 . I $G(BSTSWS("DEBUG")) W !!,"UPDATE STATUS: ",STATUS
 . ;
 . ;Look again to see if concept now logged
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"CONC: ",CONC
 . I CONC]"" D  Q
 .. S CNT=CNT+1 I CNT<BSTRT Q  ;Check for start point
 .. S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID_U_DSCID
 K @DLIST,@SLIST
 ;
 Q STS
 ;
ICDMAP(CONCDA,GL) ;EP - Save ICD Mapping information
 ;
 NEW DA,DIK,II
 ;
 ;Clear existing entries
 S DA(1)=CONCDA
 S II=0 F  S II=$O(^BSTS(9002318.4,DA(1),2,II)) Q:'II  S DA=II,DIK="^BSTS(9002318.4,"_DA(1)_",2," D ^DIK
 ;
 ;Save ICD Mapping Information
 I $D(@GL@("ICDM"))>1 D
 . NEW IMCNT
 . S IMCNT="" F  S IMCNT=$O(@GL@("ICDM",IMCNT)) Q:IMCNT=""  D
 .. NEW DA,IENS,MATND,MAT,MATRIN,MATROUT,BSTSICD
 .. NEW MAND,MA,MARIN,MAROUT
 .. NEW MCVND,MCV,MCVRIN,MCVROUT
 .. NEW MGND,MG,MGRIN,MGROUT
 .. NEW MRND,MR,MRRIN,MRROUT
 .. NEW MTND,MT,MTRIN,MTROUT
 .. NEW MTNND,MTN,MTNRIN,MTNROUT
 .. NEW MPND,MP,MPRIN,MPROUT
 .. ;
 .. ;Get new entry
 .. S DA=$$NEWM(CONCDA) I 'DA Q
 .. S DA(1)=CONCDA
 .. S IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Map Group
 .. S MGND=$G(@GL@("ICDM",IMCNT,"mapGroup"))
 .. S MG=$P(MGND,U)
 .. S MGRIN=$P(MGND,U,2)
 .. S MGROUT=$P(MGND,U,3)
 .. I MG]"" D
 ... S BSTSICD(9002318.42,IENS,.02)=MG
 ... S BSTSICD(9002318.42,IENS,.03)=$$EP2FMDT^BSTSUTIL(MGRIN)
 ... S BSTSICD(9002318.42,IENS,.04)=$$EP2FMDT^BSTSUTIL(MGROUT)
 .. ;
 .. ;Map Priority
 .. S MPND=$G(@GL@("ICDM",IMCNT,"mapPriority"))
 .. S MP=$P(MPND,U)
 .. S MPRIN=$P(MPND,U,2)
 .. S MPROUT=$P(MPND,U,3)
 .. I MP]"" D
 ... S BSTSICD(9002318.42,IENS,.05)=MP
 ... S BSTSICD(9002318.42,IENS,.06)=$$EP2FMDT^BSTSUTIL(MPRIN)
 ... S BSTSICD(9002318.42,IENS,.07)=$$EP2FMDT^BSTSUTIL(MPROUT)
 .. ;
 .. ;Map Target
 .. S MTND=$G(@GL@("ICDM",IMCNT,"mapTarget"))
 .. S MT=$P(MTND,U)
 .. S MTRIN=$P(MTND,U,2)
 .. S MTROUT=$P(MTND,U,3)
 .. I MTND]"" D
 ... S BSTSICD(9002318.42,IENS,.08)=MT
 ... S BSTSICD(9002318.42,IENS,.09)=$$EP2FMDT^BSTSUTIL(MTRIN)
 ... S BSTSICD(9002318.42,IENS,.1)=$$EP2FMDT^BSTSUTIL(MTROUT)
 .. ;
 .. ;Map Advice
 .. S MAND=$G(@GL@("ICDM",IMCNT,"mapAdvice"))
 .. S MA=$P(MAND,U)
 .. S MATRIN=$P(MAND,U,2)
 .. S MATROUT=$P(MAND,U,3)
 .. I MA]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MA,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.42,IENS,1,"",VAR)
 ... S BSTSICD(9002318.42,IENS,5.01)=$$EP2FMDT^BSTSUTIL(MATRIN)
 ... S BSTSICD(9002318.42,IENS,5.02)=$$EP2FMDT^BSTSUTIL(MATROUT)
 .. ;
 .. ;Map Target Name
 .. S MTNND=$G(@GL@("ICDM",IMCNT,"mapTargetName"))
 .. S MTN=$P(MTNND,U)
 .. S MTNRIN=$P(MTND,U,2)
 .. S MTNROUT=$P(MTND,U,3)
 .. I MTN]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MTN,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.42,IENS,2,"",VAR)
 ... S BSTSICD(9002318.42,IENS,5.05)=$$EP2FMDT^BSTSUTIL(MTNRIN)
 ... S BSTSICD(9002318.42,IENS,5.06)=$$EP2FMDT^BSTSUTIL(MTNROUT)
 .. ;
 .. ;Map Rule
 .. S MRND=$G(@GL@("ICDM",IMCNT,"mapRule"))
 .. S MR=$P(MRND,U)
 .. S MRRIN=$P(MRND,U,2)
 .. S MRROUT=$P(MRND,U,3)
 .. I MR]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MR,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.42,IENS,3,"",VAR)
 ... S BSTSICD(9002318.42,IENS,5.03)=$$EP2FMDT^BSTSUTIL(MRRIN)
 ... S BSTSICD(9002318.42,IENS,5.04)=$$EP2FMDT^BSTSUTIL(MRROUT)
 .. ;
 .. ;Map Category Value
 .. S MCVND=$G(@GL@("ICDM",IMCNT,"mapCategoryValue"))
 .. S MCV=$P(MCVND,U)
 .. S MCVRIN=$P(MCVND,U,2)
 .. S MCVROUT=$P(MCVND,U,3)
 .. I MCV]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MCV,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.42,IENS,4,"",VAR)
 ... S BSTSICD(9002318.42,IENS,5.07)=$$EP2FMDT^BSTSUTIL(MCVRIN)
 ... S BSTSICD(9002318.42,IENS,5.08)=$$EP2FMDT^BSTSUTIL(MCVROUT)
 .. ;
 .. ;File information
 .. I $D(BSTSICD) D FILE^DIE("","BSTSICD","ERROR")
 ;
 Q 1
 ;
NEWM(CIEN) ;Create new ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=CIEN
 S DIC="^BSTS(9002318.4,"_DA(1)_",2,"
 L +^BSTS(9002318.4,CIEN,2,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.4,CIEN,2,0)),U,3)+1
 S DLAYGO=9002318.42 D ^DIC
 L -^BSTS(9002318.4,CIEN,2,0)
 Q +Y
 ;
 ;
SUBLST(DLIST,BSTSWS) ;EP - Perform a Web Service Subset Listing
 ;
 N II,STS,SEARCH,STYPE,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,ST,ABORT
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 ;
 ;Determine maximum to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Perform Lookup on Subset
 ;
 ;Foreground call
 I $G(BSTSWS("BSTSBPRC"))="" D
 . S STS=$$SUBLST^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Background call try until completed - Hang max of 12 times
 I $G(BSTSWS("BSTSBPRC"))=1 D
 . NEW FCNT,MFAIL,FWAIT,TRY
 . ;
 . ;Retrieve Failover Variables
 . S MFAIL=$$FPARMS^BSTSVOFL()
 . S FWAIT=$P(MFAIL,U,2)
 . S MFAIL=$P(MFAIL,U)
 . ;
 . S FCNT=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1 ;Make sure the link is on
 .. S STS=$$SUBLST^BSTSCMCL(.BSTSWS,.RES) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUBLST^BSTSDTS2 - Retrieving subset: "_$G(BSTSWS("SUBSET")))
 ... I ABORT=1 S STS="0^" D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON SUBSET LOOKUP: "_$G(BSTSWS("SUBSET")))
 ... S FCNT=0
 ;
 Q STS
 ;
DSCSRCH(OUT,BSTSWS) ;EP - DTS4 Search Call - Description Id Lookup
 ;
 N II,STS,SEARCH,STYPE,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,ST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSPDET",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @DLIST,@OUT
 ;
 ;Determine maximum to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Perform Lookup on Concept Id
 S STS=$$DSCSRCH^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 S DTSID=$P($G(@DLIST@(1)),U) I DTSID D
 . ;
 . ;Loop through results and retrieve detail
 . ;
 . N STATUS,CONC,ERSLT
 . ;
 . ;Update entry
 . S BSTSWS("DTSID")=DTSID
 . ;
 . ;Clear result file
 . K @DLIST
 . ;
 . ;Get Detail for concept
 . S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 . I $G(BSTSWS("DEBUG")) W !!,"Detail Call Status: ",STATUS
 . ;
 . ;File the Detail
 . S STATUS=$$UPDATE^BSTSDTS0(NMID)
 . I $G(BSTSWS("DEBUG")) W !!,"Update Call Status: ",STATUS
 . ;
 . ;Look to see if concept now logged
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS,1,1)
 . I CONC]"" D  Q
 .. S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID_U_SEARCH
 ;
 Q STS
 ;
SUBSET(OUT,BSTSWS) ;EP - DTS4 Get subset list
 ;
 NEW PRESULT,STS,II,SLIST
 ;
 ;Set up scratch global
 S SLIST=$NA(^TMP("BSTSCMCL",$J)) K @SLIST
 ;
 ;Call DTS
 S STS=$$SUBSET^BSTSCMCL(.BSTSWS,.PRESULT)
 ;
 S II="" F  S II=$O(@SLIST@(II)) Q:II=""  S @OUT@(II)=@SLIST@(II)
 K @SLIST
 ;
 Q STS
