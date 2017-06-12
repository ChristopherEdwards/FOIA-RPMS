BSTSDTS1 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
DTSSR(OUT,BSTSWS) ;EP-DTS Id Lookup
 ;
 N STYPE,DLIST,NMID,DTSID,STATUS,STS,CONC,RSLT,ERSLT,SKIP
 ;
 S STYPE=$G(BSTSWS("STYPE"))
 ;
 S DLIST=$NA(^TMP("BSTSCMCL",$J))
 K @DLIST
 ;
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 S DTSID=$G(BSTSWS("SEARCH"))
 ;
 S BSTSWS("DTSID")=DTSID
 ;
 ;Get detail
 S STS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Skip Check
 S SKIP=0
 I $G(BSTSWS("ONLYLOAD"))]"" D
 . NEW SUB
 . S SKIP=1
 . S SUB="" F  S SUB=$O(@DLIST@(1,"SUB",SUB)) Q:SUB=""  I BSTSWS("ONLYLOAD")=$P($G(@DLIST@(1,"SUB",SUB)),U) S SKIP=0
 ;
 ;Update anyway if loaded (Skip partials)
 I $D(^BSTS(9002318.4,"D",36,DTSID)) D
 . NEW CIEN
 . S CIEN=$O(^BSTS(9002318.4,"D",36,DTSID,"")) Q:CIEN=""
 . I $$GET1^DIQ(9002318.4,CIEN_",",.03,"I")="P" Q
 . S SKIP=0
 ;
 ;File
 I 'SKIP S STATUS=$$UPDATE^BSTSDTS0(NMID)
 ;
 ;Look if now logged
 S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS)
 I CONC]"" S @OUT@(1)=CONC_U_DTSID
 ;
 Q STS
 ;
TSRCH(OUT,BSTSWS) ;EP-Test Search
 ;
 N II,STS,SEARCH,STYPE,WORD,MAX,DTSID,NMID,CSTS
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,TIME,ERR
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @DLIST
 ;
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S BSTSWS("SNAPDT")=$$FMTE^BSTSUTIL(DT_".2400")
 ;
 ;Search
 S TIME=0,ERR=0,STS=""
 ;
 S BSTSWS("SEARCH")=SEARCH
 ;
 ;FSN
 S CSTS=$$TRMSRCH^BSTSCMCL(.BSTSWS,.RES)
 ;
 I $P(CSTS,U,2)]"" S ERR=1
 S $P(STS,U)=$P(CSTS,U)
 S $P(STS,U,2)=$P(CSTS,U,2)
 S $P(STS,U,3)=$P(STS,U,3)+$P(CSTS,U,3)
 ;
 Q STS
 ;
UUPDATE(NMID,ROUT) ;EP-Add/Update UNII
 ;
 ;UNII Only
 I $G(NMID)'=5180 Q 1
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Find Concept
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Existing?
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;Retired?
 I CONCDA]"",'$$RET^BSTSDTS3(CONCDA,CVRSN,GL) Q 0
 ;
 ;None found - create new
 I CONCDA="" S CONCDA=$$NEWC^BSTSDTS0()
 ;
 I +CONCDA<0 Q 0
 ;
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 ;
 ;Set up top level
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Conc ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTSID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$EP2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=$$EP2FMDT^BSTSUTIL(NROUT,1)
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 ;Save ISA
 I $D(@GL@("ISA"))>1 D
 . ;
 . N ISACT
 . S ISACT="" F  S ISACT=$O(@GL@("ISA",ISACT)) Q:ISACT=""  D
 .. ;
 .. ;Save/update each ISA
 .. ;
 .. ;Already there?
 .. N DAISA,DA,IENS,DTSID,ISACD,NEWISA,DIC,Y,X,DLAYGO
 .. S ISACD=$P($G(@GL@("ISA",ISACT,0)),U) Q:ISACD=""
 .. S (NEWISA,DAISA)=$O(^BSTS(9002318.4,"D",NMID,ISACD,""))
 .. ;
 .. ;Not found - add partial entry
 .. I DAISA="" S DAISA=$$NEWC^BSTSDTS0()
 .. S BSTSC(9002318.4,DAISA_",",.08)=$G(ISACD)
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.03)="P"
 .. S BSTSC(9002318.4,DAISA_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DAISA_",",.04)=CVRSN ;Version
 .. S BSTSC(9002318.4,DAISA_",",.11)="N" ;Up to Date
 .. S BSTSC(9002318.4,DAISA_",",.12)=DT ;Update Date
 .. S BSTSC(9002318.4,DAISA_",",1)=$G(@GL@("ISA",ISACT,1))
 .. ;
 .. ;Now add IsA pointer
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",5,",X=DAISA
 .. S DLAYGO=9002318.45 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save IsA fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.45,IENS,".02")=$$EP2FMDT^BSTSUTIL($P($G(@GL@("ISA",ISACT,1,0)),U,2))
 ;
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Save Terminology entries
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
 . ;Quit if found
 . I $D(TLIST(TERM)) Q
 . S TLIST(TERM)=""
 . ;
 . S TYPE=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,2)
 . S TYPE=$S(TYPE=1:"P",1:"S")
 . I TERM=$G(@GL@("FSN",1)) S TYPE="F"
 . S DESC=$P($G(@GL@("SYN",STYPE,TCNT,0)),U) Q:DESC=""
 . S AIN=$$EP2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,3))
 . ;
 . ;Look up
 . S TMIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,""))
 . ;
 . ;No entry - create new
 . I TMIEN="" S TMIEN=$$NEWT^BSTSDTS0()
 . I TMIEN<0 Q
 . ;
 . ;Save/update fields
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
RUPDATE(NMID,ROUT) ;EP-Add/Update RXNORM
 ;
 ;RXNORM Only
 I $G(NMID)'=1552 Q 1
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Look for Concept Id
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Look for existing
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull the current version
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;Retired?
 I CONCDA]"",'$$RET^BSTSDTS3(CONCDA,CVRSN,GL) Q 0
 ;
 ;None found - create new
 I CONCDA="" S CONCDA=$$NEWC^BSTSDTS0()
 ;
 ;Verify entry found/created
 I +CONCDA<0 Q 0
 ;
 ;Get Revision Out
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 ;
 ;Set up top level
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Conc ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTSID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$EP2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=$$EP2FMDT^BSTSUTIL(NROUT,1)
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 ;Save ISA
 I $D(@GL@("ISA"))>1 D
 . ;
 . N ISACT
 . S ISACT="" F  S ISACT=$O(@GL@("ISA",ISACT)) Q:ISACT=""  D
 .. ;
 .. ;Save/update each ISA
 .. ;
 .. ;First see if IsA code saved
 .. N DAISA,DA,IENS,DTSID,ISACD,NEWISA,DIC,Y,X,DLAYGO
 .. S ISACD=$P($G(@GL@("ISA",ISACT,0)),U) Q:ISACD=""
 .. S (NEWISA,DAISA)=$O(^BSTS(9002318.4,"D",NMID,ISACD,""))
 .. ;
 .. ;Not found - add partial entry
 .. I DAISA="" S DAISA=$$NEWC^BSTSDTS0()
 .. S BSTSC(9002318.4,DAISA_",",.08)=$G(ISACD)
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.03)="P"
 .. S BSTSC(9002318.4,DAISA_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DAISA_",",.04)=CVRSN ;Version
 .. S BSTSC(9002318.4,DAISA_",",.11)="N" ;Up to Date
 .. S BSTSC(9002318.4,DAISA_",",.12)=DT ;Update Date
 .. S BSTSC(9002318.4,DAISA_",",1)=$G(@GL@("ISA",ISACT,1))
 .. ;
 .. ;Now add IsA pointer in current concept entry
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",5,",X=DAISA
 .. S DLAYGO=9002318.45 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save additional IsA fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.45,IENS,".02")=$$EP2FMDT^BSTSUTIL($P($G(@GL@("ISA",ISACT,1,0)),U,2))
 ;
 ;Save Inverse Associations
 ;
 ;Clear out existing entries
 D
 . NEW AS
 . S AS=0 F  S AS=$O(^BSTS(9002318.4,CONCDA,11,AS)) Q:'AS  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=AS
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",11," D ^DIK
 I $D(@GL@("IAS"))>1 D
 . ;
 . ;
 . NEW AS
 . S AS="" F  S AS=$O(@GL@("IAS",AS)) Q:AS=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",11,"
 .. S X=$P($G(@GL@("IAS",AS)),U) Q:X=""
 .. S DLAYGO=9002318.411 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.411,IENS,".02")=$P($G(@GL@("IAS",AS)),U,2)
 .. S BSTSC(9002318.411,IENS,".03")=$P($G(@GL@("IAS",AS)),U,3)
 .. S BSTSC(9002318.411,IENS,".04")=$P($G(@GL@("IAS",AS)),U,4)
 ;
 ;Update additional RxNorm fields
 D UPRSUB^BSTSDTS5(GL,CONCDA,.BSTSC)
 ;
 ;Save the entry
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Reindex - needed for custom indices
 D
 . NEW DIK,DA
 . S DIK="^BSTS(9002318.4,",DA=CONCDA
 . D IX^DIK
 ;
 ;Save Terminology entries
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
 . ;Limit to 244
 . S TERM=$E(TERM,1,244)
 . ;
 . ;Quit if found
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
 . ;Entry not found - create new
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
DILKP(OUT,BSTSWS) ;EP - DTS4 Search Call - Drug Ingredient Lookup
 ;
 N II,STS,SEARCH,STYPE,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,ST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSDET",$J)) ;Sorted List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 K @SLIST,@DLIST,@OUT
 ;
 ;Determine max to return
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID"))
 ;
 ;Perform Lookup on Concept Id
 S STS=$$PTYDTS4^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Sort results (though there should only be one)
 S DTSID="" F  S DTSID=$O(@DLIST@(DTSID)) Q:DTSID=""  S @SLIST@(@DLIST@(DTSID),DTSID)=""
 ;
 ;Loop through results and retrieve detail
 S II="",RCNT=0 F  S II=$O(@SLIST@(II),-1) Q:II=""  D  Q:RCNT
 . S DTSID="" F  S DTSID=$O(@SLIST@(II,DTSID)) Q:DTSID=""  D  Q:RCNT
 .. ;
 .. N STATUS,CONC,ERSLT
 .. ;
 .. ;Update entry
 .. S BSTSWS("DTSID")=DTSID
 .. ;
 .. ;Clear result file
 .. K @DLIST
 .. ;
 .. ;Get Detail for concept
 .. S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 .. I $G(BSTSWS("DEBUG")) W !!,"Detail Call Status: ",STATUS
 .. ;
 .. ;File Detail
 .. S STATUS=$$UPDATE^BSTSDTS0(NMID)
 .. I $G(BSTSWS("DEBUG")) W !!,"Update Call Status: ",STATUS
 .. ;
 .. ;Look to see if concept logged
 .. S CONC=$$CONC^BSTSDTS0(DTSID,.BSTSWS,1,1)
 .. I CONC]"" D  Q
 ... S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID
 ;
 Q STS
