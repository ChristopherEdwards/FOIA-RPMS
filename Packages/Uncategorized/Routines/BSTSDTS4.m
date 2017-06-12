BSTSDTS4 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
USEARCH(OUT,BSTSWS) ;EP - DTS4 UNIVERSE Search Call
 ;
 NEW STS,II,SEARCH,STYPE,SLIST,DLIST,OCNT,MAX,NMID,RES
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSSLST",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @SLIST,@DLIST,@OUT
 S OCNT=0
 ;
 ;Determine maximum to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
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
 I $O(@SLIST@(""))]"" S II="" F  S II=$O(@SLIST@(II)) Q:II=""  D
 . NEW DTSID,DSCID,CONC,STATUS,CONCID,FSNT,FSND,REL,SYN
 . NEW SUB,ERSLT,PRD,PRT,PRSY,ASSOC,MAPP
 . ;
 . S DTSID=$P(@SLIST@(II),U) Q:DTSID=""
 . S DSCID=$P(@SLIST@(II),U,2) I STYPE="S",DSCID="" Q
 . ;
 . I $G(BSTSWS("DEBUG")) W !,"DTSID: ",DTSID
 . ;
 . ;Check for maximum
 . I $G(OCNT)'<MAX Q
 . ;
 . ;Look for detail stored locally
 . S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 . ;
 . I $G(BSTSWS("DEBUG")) W !!,"DETAIL CONC: ",CONC
 . ;
 . ;Now get the detail
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
 . ;Concept ID
 . S CONCID=$P($G(@DLIST@(1,"CONCEPTID")),U)
 . ;
 . ;FSN
 . S FSNT=$P($G(@DLIST@(1,"FSN",1)),U)
 . S FSND=""
 . ;
 . ;ISA
 . S REL="" I $D(@DLIST@(1,"ISA")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"ISA",ICNT)) Q:ICNT=""  D
 ... NEW DTS,TRM
 ... S DTS=$P($G(@DLIST@(1,"ISA",ICNT,0)),"^")
 ... S TRM=$P($G(@DLIST@(1,"ISA",ICNT,1)),"^")
 ... S REL=REL_$S(REL]"":$C(28),1:"")_DTS_$C(29)_TRM_$C(29)_"ISA"
 . ;
 . ;Child
 . I $D(@DLIST@(1,"SUBC")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"SUBC",ICNT)) Q:ICNT=""  D
 ... NEW DTS,TRM
 ... S DTS=$P($G(@DLIST@(1,"SUBC",ICNT,0)),"^")
 ... S TRM=$P($G(@DLIST@(1,"SUBC",ICNT,1)),"^")
 ... S REL=REL_$S(REL]"":$C(28),1:"")_DTS_$C(29)_TRM_$C(29)_"CHD"
 . ;
 . ;Synonyms
 . S SYN="",(PRT,PRD)="",PRSY="S" I $D(@DLIST@(1,"SYN")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"SYN",ICNT)) Q:ICNT=""  D
 ... NEW TRM,DSC,PS
 ... S TRM=$P($G(@DLIST@(1,"SYN",ICNT,1)),"^")
 ... S PS=$P($G(@DLIST@(1,"SYN",ICNT,0)),"^",2)
 ... S DSC=$P($G(@DLIST@(1,"SYN",ICNT,0)),"^")
 ... ;
 ... ;Look for FSN
 ... I TRM]"",FSNT=TRM D  I $G(@DLIST@(1,"NAMESP"))=36 Q
 .... S FSND=DSC
 ... ;
 ... I DSCID]"",DSCID=DSC D
 .... S PRD=DSCID,PRT=TRM
 .... S:PS=1 PRSY="P"
 ... I DSCID="",PS=1 S PRD=DSC,PRT=TRM
 ... S SYN=SYN_$S(SYN]"":$C(28),1:"")_DSC_$C(29)_TRM_$C(29)_$S(PS=1:"Preferred",1:"Synonym")
 . ;
 . ;Subsets
 . S SUB="" I $D(@DLIST@(1,"SUB")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"SUB",ICNT)) Q:ICNT=""  D
 ... NEW SB
 ... S SB=$P($G(@DLIST@(1,"SUB",ICNT)),U)
 ... S SUB=SUB_$S(SUB]"":$C(28),1:"")_SB
 . ;
 . ;Associations
 . S ASSOC="" I $D(@DLIST@(1,"ASC")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"ASC",ICNT)) Q:ICNT=""  D
 ... NEW ANODE,ASC,ASN,AST,CDIEN
 ... S ANODE=$G(@DLIST@(1,"ASC",ICNT))
 ... S ASC=$P(ANODE,U)
 ... S ASN=$P(ANODE,U,2) Q:ASN=""
 ... S CDIEN=$O(^BSTS(9002318.1,"B",ASN,"")) Q:CDIEN=""
 ... S ASN=$$GET1^DIQ(9002318.1,CDIEN_",",.03,"I") Q:ASN=""
 ... S AST=$P(ANODE,U,4) S:AST["[" ASC=""
 ... S ASSOC=ASSOC_$S(ASSOC]"":$C(28),1:"")_ASN_": "_AST_$S(ASC="":"",1:" ["_ASC_"]")
 . ;
 . ;Mappings
 . S MAPP="" I $D(@DLIST@(1,"NDC")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"NDC",ICNT)) Q:ICNT=""  D
 ... NEW NDC
 ... S NDC=$P($G(@DLIST@(1,"NDC",ICNT)),U)
 ... S MAPP=MAPP_$S(MAPP]"":$C(28),1:"")_"NDC: "_NDC
 . ;
 . ;VUID
 . I $D(@DLIST@(1,"VUID")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@DLIST@(1,"VUID",ICNT)) Q:ICNT=""  D
 ... NEW VUID
 ... S VUID=$P($G(@DLIST@(1,"VUID",ICNT)),U)
 ... S MAPP=MAPP_$S(MAPP]"":$C(28),1:"")_"VUID: "_VUID
 . ;
 . ;Save the detail
 . S OCNT=OCNT+1
 . S @OUT@(OCNT)=CONCID_U_PRT_U_PRD_U_FSNT_U_FSND_U_SYN_U_REL_U_DTSID_U_SUB_U_PRSY_U_ASSOC_U_MAPP
 ;
 K @DLIST,@SLIST
 ;
 Q STS
 ;
EQLAT(CONCDA,BSTSC,GL) ;Update Equivalent Concepts
 ;
 ;Called by UPDATE^BSTSDTS0
 ;
 Q:CONCDA=""
 Q:GL=""
 ;
 NEW PC,LTNODE
 ;
 ;Clear out existing entries
 D
 . NEW EQLCNT
 . S EQLCNT=0 F  S EQLCNT=$O(^BSTS(9002318.4,CONCDA,15,EQLCNT)) Q:'EQLCNT  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=EQLCNT
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",15," D ^DIK
 ;
 ;Now save Equivalent Concepts
 I $D(@GL@("AEQ"))>1 D
 . ;
 . NEW EQLCNT
 . S EQLCNT="" F  S EQLCNT=$O(@GL@("AEQ",EQLCNT)) Q:EQLCNT=""  D
 .. ;
 .. NEW DIC,DA,X,Y,IENS,DLAYGO,NODE,DTSID,LCONC,LATV,IREV,OREV
 .. S NODE=$G(@GL@("AEQ",EQLCNT))
 .. ;
 .. ;Get laterality
 .. S LATV=$P(NODE,U)
 .. S LATV=$S(LATV="LeftVariant":"Left",LATV="RightVariant":"Right",LATV="RightAndLeftVariant":"Bilateral",LATV="BilateralVariant":"Bilateral",1:"")
 .. Q:LATV=""
 .. ;
 .. S DTSID=$P(NODE,U,2) Q:DTSID=""  ;Get DTSID of equivalent
 .. S LCONC=$P(NODE,U,3) Q:LCONC=""  ;Get CONC ID of equivalent
 .. S IREV=$P(NODE,U,4)
 .. S OREV=$P(NODE,U,5)
 .. ;
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",15,"
 .. S X=LATV
 .. S DLAYGO=9002318.415 D ^DIC
 .. ;
 .. ;Quit on fail
 .. I +Y<0 Q
 .. ;
 .. ;Save remaining fields
 .. S (DA)=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.415,IENS,".02")=LCONC
 .. S BSTSC(9002318.415,IENS,".03")=DTSID
 .. S BSTSC(9002318.415,IENS,".04")=$$DTS2FMDT^BSTSUTIL(IREV,1)
 .. S BSTSC(9002318.415,IENS,".05")=$$DTS2FMDT^BSTSUTIL(OREV,1)
 ;
 ;Save equivalent information for lateralized concepts
 ;
 ;Clear out existing entries
 S LTNODE=$G(^BSTS(9002318.4,CONCDA,16))
 F PC=1:1:5 S $P(LTNODE,U,PC)=""
 S ^BSTS(9002318.4,CONCDA,16)=LTNODE
 ;
 ;Set new values
 I $D(@GL@("AIEQ"))>1 D
 . NEW AIEQ,LATV
 . S AIEQ=$G(@GL@("AIEQ",1))
 . S LATV=$P(AIEQ,U)
 . S BSTSC(9002318.4,CONCDA_",",16.01)=$S(LATV="LeftVariant":"Left",LATV="RightVariant":"Right",LATV="RightAndLeftVariant":"Bilateral",LATV="BilateralVariant":"Bilateral",1:"")
 . S BSTSC(9002318.4,CONCDA_",",16.02)=$P(AIEQ,U,2)
 . S BSTSC(9002318.4,CONCDA_",",16.03)=$P(AIEQ,U,3)
 . S BSTSC(9002318.4,CONCDA_",",16.04)=$$DTS2FMDT^BSTSUTIL($P(AIEQ,U,4),1)
 . S BSTSC(9002318.4,CONCDA_",",16.05)=$$DTS2FMDT^BSTSUTIL($P(AIEQ,U,5),1)
 ;
 Q
 ;
 ;BSTS*1.0*7;Added equivalency retrieval call
EQLST(DLIST,ABORT,FCNT,STS,TRY,MFAIL,BSTSWS,ERSLT,CNT,SLIST,FWAIT) ;Get List Equivalency Concepts - 32780
 NEW TR
 K @DLIST
 S ^XTMP("BSTSLCMP","STS")="Generating a list of equivalency concepts"
 ;
 F TR=1:1:60 D  I +STS Q
 .S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$ACODEQ^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"EQLST^BSTSDTS4 - Call to $$ACODEQ^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED EQUIVALENCY LOOKUP FAILED")
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
 Q +STS
 ;
SCODE(BSTSWS,ACODE) ;Retrieve list of concepts in subsets and refresh
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
 . S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"SNOMED subset refresh update running - Getting list"
 . K ^XTMP("BSTSLCMP","STS")
 ;
 ;Get list of concepts in subsets
 S ^XTMP("BSTSLCMP","STS")="Generating a list of concepts in subsets"
 ;
 ;BSTS*1.0*8;Extra error handling
 F TR=1:1:60 D  I +STS Q
 .S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$SCODE^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SCODE^BSTSDTS4 - Call to $$SCODE^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH LOOKUP FAILED")
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
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^36^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SCODE^BSTSDTS4 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SNOMED SUBSET REFRESH FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 ;
 ;Clear status
 K ^XTMP("BSTSLCMP","STS")
 ;
 I 'STS Q 0
 Q 1
