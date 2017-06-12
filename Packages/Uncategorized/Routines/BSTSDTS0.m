BSTSDTS0 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
CNCSR(OUT,BSTSWS) ;EP - DTS4 Search Call - Concept Lookup
 ;
 N II,STS,SEARCH,STYPE,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,ST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSPDET",$J)) ;Sort List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Ret List
 K @SLIST,@DLIST,@OUT
 ;
 ;Determine max to ret
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Perform Lookup on Conc Id
 S STS=$$CNCSR^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Sort results (should only be one)
 S DTSID="" F  S DTSID=$O(@DLIST@(DTSID)) Q:DTSID=""  S @SLIST@(@DLIST@(DTSID),DTSID)=""
 ;
 ;Loop through results and retrieve det
 S II="",RCNT=0 F  S II=$O(@SLIST@(II),-1) Q:II=""  D  Q:RCNT
 . S DTSID="" F  S DTSID=$O(@SLIST@(II,DTSID)) Q:DTSID=""  D  Q:RCNT
 .. ;
 .. N STATUS,CONC,ERSLT,SNAPDT
 .. ;
 .. ;Update entry
 .. S BSTSWS("DTSID")=DTSID
 .. ;
 .. ;Change snapshot date
 .. S SNAPDT=$$DTCHG^BSTSUTIL(DT,2)_".0001"
 .. S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 .. S BSTSWS("SNAPDT")=SNAPDT
 .. ;
 .. ;Clear result file
 .. K @DLIST
 .. ;
 .. ;Get Detail for concept
 .. S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 .. I $G(BSTSWS("DEBUG")) W !!,"Detail Call Status: ",STATUS
 .. ;
 .. ;File Detail
 .. S STATUS=$$UPDATE(NMID)
 .. I $G(BSTSWS("DEBUG")) W !!,"Update Call Status: ",STATUS
 .. ;
 .. ;Look again to see if concept logged
 .. S CONC=$$CONC(DTSID,.BSTSWS,1,1)
 .. I CONC]"" D  Q
 ... I CONC'=BSTSWS("SEARCH") Q
 ... S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID
 ;
 Q STS
 ;
UPDATE(NMID,ROUT) ;EP - Add/Update Concept and Term(s)
 ;
 ;Update UNII
 I $G(NMID)=5180 Q $$UUPDATE^BSTSDTS1(NMID,$G(ROUT))
 ;
 ;Update RxNorm
 I $G(NMID)=1552 Q $$RUPDATE^BSTSDTS1(NMID,$G(ROUT))
 ;
 ;This update section only applies to SNOMED
 I $G(NMID)'=36 Q $$SUPDATE^BSTSDTS3(NMID,$G(ROUT))
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR,SVOUT
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Look for Conc Id
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Look for existing entry
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull the current ver
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;BSTS*1.0*8;Save Replacement
 D REPL^BSTSRPT(CONCDA,GL)
 ;
 ;Handle retired concepts
 I CONCDA]"",'$$RET^BSTSDTS3(CONCDA,CVRSN,GL) Q 0
 ;
 ;None found - create new entry
 I CONCDA="" S CONCDA=$$NEWC()
 ;
 ;Verify entry found/created
 I +CONCDA<0 Q 0
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull current version
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;Get Rev Out
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 S SVOUT=NROUT S SVOUT=$S(SVOUT]"":$$DTS2FMDT^BSTSUTIL(NROUT,1),1:"@")
 ;
 ;Set up top level concept fields
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Concept ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTS ID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$DTS2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=SVOUT
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.13)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 ;BSTS*1.0*8;Reset new field
 S BSTSC(9002318.4,CONCDA_",",.15)="@"
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 ;Save ISA
 I $D(@GL@("ISA"))>1 D
 . ;
 . N ISACT
 . S ISACT="" F  S ISACT=$O(@GL@("ISA",ISACT)) Q:ISACT=""  D
 .. ;
 .. ;Save/update each ISA entry
 .. ;
 .. ;First see if IsA code saved
 .. N DAISA,DA,IENS,DTSID,ISACD,NEWISA,DIC,Y,X,DLAYGO
 .. S ISACD=$P($G(@GL@("ISA",ISACT,0)),U) Q:ISACD=""
 .. S (NEWISA,DAISA)=$O(^BSTS(9002318.4,"D",NMID,ISACD,""))
 .. ;
 .. ;Not found - add partial entry to concept file
 .. I DAISA="" S DAISA=$$NEWC()
 .. S BSTSC(9002318.4,DAISA_",",.08)=$G(ISACD)
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.03)="P"
 .. S BSTSC(9002318.4,DAISA_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DAISA_",",.04)=CVRSN ;Version
 .. S BSTSC(9002318.4,DAISA_",",.11)="N" ;Up to Date
 .. S BSTSC(9002318.4,DAISA_",",.12)=DT ;Update date
 .. S BSTSC(9002318.4,DAISA_",",1)=$G(@GL@("ISA",ISACT,1))
 .. ;
 .. ;Now add IsA pointer in current conc entry
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",5,",X=DAISA
 .. S DLAYGO=9002318.45 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save additional IsA fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.45,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ISA",ISACT,1,0)),U,2))
 ;
 ;Save Children (subconcepts)
 I $D(@GL@("SUBC"))>1 D
 . ;
 . N SUBCCT
 . S SUBCCT="" F  S SUBCCT=$O(@GL@("SUBC",SUBCCT)) Q:SUBCCT=""  D
 .. ;
 .. ;Save/update each SubConcept entry
 .. ;
 .. ;First see if Subconcept code saved
 .. N DASUBC,DA,IENS,DTSID,SUBCCD,NEWSUBC,DIC,Y,X,DLAYGO
 .. S SUBCCD=$P($G(@GL@("SUBC",SUBCCT,0)),U) Q:SUBCCD=""
 .. S (NEWSUBC,DASUBC)=$O(^BSTS(9002318.4,"D",NMID,SUBCCD,""))
 .. ;
 .. ;Not found - add partial entry to conc file
 .. I DASUBC="" S DASUBC=$$NEWC()
 .. S BSTSC(9002318.4,DASUBC_",",.08)=$G(SUBCCD)
 .. I NEWSUBC="" S BSTSC(9002318.4,DASUBC_",",.03)="P"
 .. S BSTSC(9002318.4,DASUBC_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DASUBC_",",.04)=CVRSN ;Version
 .. S BSTSC(9002318.4,DASUBC_",",.11)="N" ;Up to Date
 .. S BSTSC(9002318.4,DASUBC_",",.12)=DT ;Update Date 
 .. S BSTSC(9002318.4,DASUBC_",",1)=$G(@GL@("SUBC",SUBCCT,1))
 .. ;
 .. ;Now add SUBC pointer in current conc entry
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",6,",X=DASUBC
 .. S DLAYGO=9002318.46 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save additional SUBC fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.46,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SUBCCT,1,0)),U,2))
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
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",4,"
 .. S X=$P($G(@GL@("SUB",SB)),U) Q:X=""
 .. ;BSTS*1.0*8;Log ALL SNOMED
 .. I X="IHS PROBLEM ALL SNOMED" S BSTSC(9002318.4,CONCDA_",",.15)="Y"
 .. S DLAYGO=9002318.44 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.44,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SB)),U,2))
 ;
 ;Save ICD Mapping
 ;
 ;Clear out existing
 D
 . NEW IC
 . S IC=0 F  S IC=$O(^BSTS(9002318.4,CONCDA,3,IC)) Q:'IC  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=IC
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",3," D ^DIK
 ;
 ;Save ICD9 first
 I $D(@GL@("ICD9"))>1 D
 . N ICD
 . S ICD="" F  S ICD=$O(@GL@("ICD9",ICD)) Q:ICD=""  D
 .. N DA,IENS,ICDCD
 .. ;
 .. ;Look up entry
 .. S DA(1)=CONCDA
 .. S ICDCD=$P($G(@GL@("ICD9",ICD)),U) Q:ICDCD=""
 .. S DA=$O(^BSTS(9002318.4,DA(1),3,"C",ICDCD,""))
 .. ;
 .. ;Create new
 .. I DA="" S DA=$$NEWI(CONCDA)
 .. Q:DA<0
 .. ;
 .. ;Add in additional fields
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.43,IENS,".02")=ICDCD
 .. S BSTSC(9002318.43,IENS,".03")="IC9"
 .. S BSTSC(9002318.43,IENS,".04")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ICD9",ICD)),U,2))
 .. S BSTSC(9002318.43,IENS,".05")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ICD9",ICD)),U,3))
 ;
 ;Save ICD10 Mapping Next
 I $D(@GL@("A10"))>1 D
 . N ICD
 . S ICD="" F  S ICD=$O(@GL@("A10",ICD)) Q:ICD=""  D
 .. N DA,IENS,ICDCD
 .. ;
 .. ;Look up
 .. S DA(1)=CONCDA
 .. S ICDCD=$P($G(@GL@("A10",ICD)),U) Q:ICDCD=""
 .. S DA=$O(^BSTS(9002318.4,DA(1),3,"C",ICDCD,""))
 .. ;
 .. ;Create new
 .. I DA="" S DA=$$NEWI(CONCDA)
 .. Q:DA<0
 .. ;
 .. ;Add in additional fields
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.43,IENS,".02")=ICDCD
 .. S BSTSC(9002318.43,IENS,".03")="10D"
 .. S BSTSC(9002318.43,IENS,".04")=$$DTS2FMDT^BSTSUTIL($P($P($G(@GL@("A10",ICD)),U,5)," "))
 .. S BSTSC(9002318.43,IENS,".05")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("A10",ICD)),U,6))
 ;
 ;Save ICD9 to SNOMED Mapping
 ;
 ;Clear out existing entries
 D
 . NEW SB
 . S SB=0 F  S SB=$O(^BSTS(9002318.4,CONCDA,13,SB)) Q:'SB  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=SB
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",13," D ^DIK
 ;
 ;Now save mappings
 I $D(@GL@("RICD9"))>1 D
 . ;
 . NEW SB
 . S SB="" F  S SB=$O(@GL@("RICD9",SB)) Q:SB=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",13,"
 .. S X=$P($G(@GL@("RICD9",SB)),U) Q:X=""
 .. S DLAYGO=9002318.413 D ^DIC
 ;
 ;BSTS*1.0*6;Update Condition mappings
 ;Save Conditional Mappings
 D SAVEMAP^BSTSMAP1(CONCDA,.BSTSC,GL)
 ;
 ;BSTS*1.0*7;Update Equivalency Concepts
 D EQLAT^BSTSDTS4(CONCDA,.BSTSC,GL)
 ;
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Now save Terminology entries
 ;
 ;Synonyms/Preferred/FSN
 ;
 S STYPE="" F  S STYPE=$O(@GL@("SYN",STYPE)) Q:STYPE=""  S TCNT="" F  S TCNT=$O(@GL@("SYN",STYPE,TCNT)) Q:TCNT=""  D
 . ;
 . N TERM,TYPE,DESC,BSTST,ERROR,TMIEN,AIN,AOUT
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
 . S AIN=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,3))
 . S AOUT=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,4))
 . S:AOUT="" AOUT="@"
 . ;
 . ;Look up entry
 . S TMIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,""))
 . ;
 . ;Entry not found - create new
 . I TMIEN="" S TMIEN=$$NEWT()
 . I TMIEN<0 Q
 . ;
 . ;Save/update other fields
 . S BSTST(9002318.3,TMIEN_",",.02)=DESC
 . S BSTST(9002318.3,TMIEN_",",.09)=TYPE
 . S BSTST(9002318.3,TMIEN_",",.04)="N"
 . S BSTST(9002318.3,TMIEN_",",.05)=CVRSN
 . S BSTST(9002318.3,TMIEN_",",.08)=INMID
 . S BSTST(9002318.3,TMIEN_",",.03)=CONCDA
 . S BSTST(9002318.3,TMIEN_",",.06)=AIN
 . S BSTST(9002318.3,TMIEN_",",.07)=AOUT
 . S BSTST(9002318.3,TMIEN_",",.1)=DT
 . S BSTST(9002318.3,TMIEN_",",.11)="N"
 . S BSTST(9002318.3,TMIEN_",",1)=TERM
 . D FILE^DIE("","BSTST","ERROR")
 . ;
 . ;Reindex - needed for custom indices
 . D
 .. NEW DIK,DA
 .. S DIK="^BSTS(9002318.3,",DA=TMIEN
 .. D IX^DIK
 ;
 ;Save ICD Mapping information
 I '$D(ERROR) S STS=$$ICDMAP^BSTSDTS2(CONCDA,GL)
 ;
 ;Need to check for retired concepts again since it may have just been added
 S RTR=$$RET^BSTSDTS3(CONCDA,CVRSN,GL)
 ;
 Q $S($D(ERROR):"0^Update Failed",1:1)
 ;
CONC(DTSID,BSTSWS,SKPOD,SKPDT) ;EP - Determine if Code on File (and up to date)
 ;
 NEW CONC,CIEN,CONC,SNAPDT,NMID,BEGDT,ENDDT
 ;
 S SKPOD=$G(SKPOD) ;Set to 1 to skip out of date checking
 S SKPDT=$G(SKPDT) ;Set to 1 to skip date checking
 ;
 ;Get namespace
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Pull the conc IEN
 S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTSID,"")) Q:CIEN="" ""
 ;
 ;Quit if out of date
 I 'SKPOD,$$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y" Q ""
 ;
 ;Look in date range
 S SNAPDT=$G(BSTSWS("SNAPDT")) S:SNAPDT]"" SNAPDT=$$DATE^BSTSUTIL(SNAPDT)
 S:SNAPDT="" SNAPDT=DT
 ;
 I 'SKPDT S BEGDT=$$GET1^DIQ(9002318.4,CIEN_",",".05","I") I BEGDT]"",SNAPDT<BEGDT Q ""
 I 'SKPDT S ENDDT=$$GET1^DIQ(9002318.4,CIEN_",",".06","I") I ENDDT]"",SNAPDT>ENDDT Q ""
 ;
 S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","E")
 ;
 Q CONC
 ;
GCDSDTS4(BSTSWS) ;EP - DTS4 update codeset
 ;
 N RESULT,STS,II,BSTSUP,ERROR
 ;
 S STS=$$GCDSDTS4^BSTSCMCL(.BSTSWS,.RESULT)
 ;
 ;Update Local BSTS CODESET file (9002318.1)
 S II="" F  S II=$O(RESULT(II),-1) Q:II=""  D
 . ;
 . N DIC,X,Y,DLAYGO,DIC
 . S X=$G(RESULT(II,"NAMESPACE","ID")) Q:'X
 . S DIC(0)="XL",DIC="^BSTS(9002318.1,",DLAYGO=9002318.1 D ^DIC
 . I +Y<0 Q
 . S BSTSUP(9002318.1,+Y_",",.02)=$G(RESULT(II,"NAMESPACE","CODE"))
 . S BSTSUP(9002318.1,+Y_",",.03)=$G(RESULT(II,"NAMESPACE","NAME"))
 I $D(BSTSUP) D FILE^DIE("","BSTSUP","ERROR")
 ;
 Q STS
 ;
GVRDTS4(BSTSWS) ;EP - DTS4 update versions
 ;
 NEW RESULT,STS
 ;
 ;Reset Scratch global and make call to DTS
 S RESULT=$NA(^TMP("BSTSCMCL",$J))
 K @RESULT
 S STS=$$GVRDTS4^BSTSCMCL(.BSTSWS)
 ;
 ;Update file with results
 I STS D
 . NEW NMID,NMIEN,VDT,CNT,VRID,CVID,BSTS,ERR
 . S NMID=$G(BSTSWS("NAMESPACEID"))
 . S NMIEN=$O(^BSTS(9002318.1,"B",NMID,""),-1) Q:NMIEN=""
 . S (VRID,CNT)="" F  S CNT=$O(@RESULT@(CNT),-1) Q:'CNT  D
 .. S VDT="" F  S VDT=$O(@RESULT@(CNT,"VERSION",VDT)) Q:VDT=""  D
 ... NEW RDT,NAME,DA,IENS,BSTSUP,ERROR
 ... S RDT=$G(@RESULT@(CNT,"VERSION",VDT,"RELEASEDATE"))
 ... S NAME=$G(@RESULT@(CNT,"VERSION",VDT,"NAME"))
 ... ;
 ... ;Look for existing entry
 ... S DA=$O(^BSTS(9002318.1,NMIEN,1,"B",VDT,""))
 ... ;
 ... ;Create new record
 ... S:DA="" DA=$$NEWV(NMIEN,VDT)
 ... I +DA<0 Q
 ... S VRID=VDT
 ... S DA(1)=NMIEN,IENS=$$IENS^DILF(.DA)
 ... ;
 ... ;Add/Update remaining fields
 ... S BSTSUP(9002318.11,IENS,".02")=NAME
 ... ;BSTS*1.0*6;Fixed date issue
 ... ;S BSTSUP(9002318.11,IENS,".03")=RDT
 ... S BSTSUP(9002318.11,IENS,".03")=$$DTS2FMDT^BSTSUTIL($P(RDT,"."))
 ... D FILE^DIE("","BSTSUP","ERROR")
 . ;
 Q STS
 ;
NEWV(NMIEN,VDT) ;Create new ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=NMIEN
 S DLAYGO=9002318.11,DIC="^BSTS(9002318.1,"_DA(1)_",1,"
 S X=VDT
 D ^DIC
 Q +Y
 ;
 ;
NEWC() ;Create new concept entry
 N DIC,X,Y,DLAYGO
 S DIC(0)="L",DIC=9002318.4
 L +^BSTS(9002318.4,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.4,0)),U,3)+1
 S DLAYGO=9002318.4 D ^DIC
 L -^BSTS(9002318.4,0)
 Q +Y
 ;
NEWT() ;Create new terminology entry
 N DIC,X,Y,DLAYGO
 S DIC(0)="L",DIC=9002318.3
 L +^BSTS(9002318.3,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.3,0)),U,3)+1
 S DLAYGO=9002318.3 D ^DIC
 L -^BSTS(9002318.3,0)
 Q +Y
 ;
NEWI(CIEN) ;Create new ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=CIEN
 S DIC="^BSTS(9002318.4,"_DA(1)_",3,"
 L +^BSTS(9002318.4,CIEN,3,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.4,CIEN,3,0)),U,3)+1
 S DLAYGO=9002318.43 D ^DIC
 L -^BSTS(9002318.4,CIEN,3,0)
 Q +Y
