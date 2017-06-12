BGOFHX ; IHS/MSC/MGH - New family history component ;06-Nov-2014 10:21;DU
 ;;1.1;BGO COMPONENTS;**6,13,14**;Mar 20, 2007;Build 16
 ;---------------------------------------------
 ;
 ; Note: The BGOHFX SET RPC now points to SET^BGOREL, which in turn calls SET^BGOFHX
 ;
 ; Add/edit entry family/personal history corresponding to problem entry
 ; INP=Patient IEN [1] ^ Relationship IEN [2] ^ DX [3] ^ Text [4] ^ DX Age [5] ^DX Age Approximate [6]
 ;^FHX IEN [7] ^ CONCEPT CT [8] ^ DESC CT [9] ^ MULT ICD [10]
SET(RET,INP) ;
 N FDA,RIEN,DFN,DMOD,REL,SNODATA,FNUM,EDIT,ICD,ICDX,ICDIEN,FIEN,FNEW,IENX,NEW,DXAGE,DXAGEAPX,CONCT,NARR,IN,OUT,X
 S DFN=$P(INP,U,1),RIEN=$P(INP,U,2),ICD=$P(INP,U,3),FIEN=$P(INP,U,7)
 Q:DFN=""
 Q:RIEN=""
 S CONCT=$P(INP,U,8),DESCT=$P(INP,U,9)
 S (ICD,ICDIEN)=""
 ;IHS/MSC/MGH Changed to use new API
 ;S SNODATA=$$CONC^BSTSAPI(CONCT_"^^^1")
 S SNODATA=$$CONC^AUPNSICD(CONCT_"^^^1")
 S ICD=$P($P(SNODATA,U,5),";",1)
 I ICD="" D
 .;Patch 14 check for which undefined code to use
 .I $$AICD^BGOUTL2 D
 ..S IMP=$$IMP^ICDEX("10D",DT)
 ..I IMP<$$NOW^XLFDT!(IMP=$$NOW^XLFDT) S ICD="ZZZ.999"
 ..I IMP>$$NOW^XLFDT S ICD=".9999"
 .E  S ICD=".9999"
 I $$AICD^BGOUTL2 S ICDIEN=$P($$ICDDX^ICDEX(ICD,DT,"","E"),U,1)
 E   S ICDIEN=$P($$ICDDX^ICDCODE(ICD),U,1)
 I ICDIEN="" S RET=$$ERR^BGOUTL(1092) Q
 S EDIT=0
 S NEW=0
 I FIEN="" D
 .S FNEW=1
 .S FIEN="+1",NEW=1
 S FDA=$NA(FDA(9000014,FIEN_","))
 S @FDA@(.01)=ICD
 I NEW=1 S @FDA@(.02)="`"_DFN
 S @FDA@(.08)="`"_DUZ
 ;S @FDA@(.09)="`"_$P(INP,U,2)
 S @FDA@(.11)="" ; Clear out AGE AT ONSET field
 S @FDA@(.05)=$P(INP,U,5)
 S @FDA@(.15)=$P(INP,U,6)
 I NEW=1 S @FDA@(.03)="TODAY"
 S @FDA@(.12)="TODAY"
 S @FDA@(.13)=$P(INP,U,8)
 S NARR=$P(INP,U,4)
 S @FDA@(.14)=DESCT
 S NARR=NARR_"|"_DESCT
 S RET=$$FNDNARR^BGOUTL2(NARR)
 Q:RET<0
 S NARR=$S(RET:"`"_RET,1:""),RET=""
 S @FDA@(.04)=NARR
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IENX)
 S:$E(FIEN)="+" FIEN=$G(IENX(1))
 I RET="" D
 .N DIE,DA,DR,POP
 .S DIE="^AUPNFH(",DA=FIEN,DR=".09////"_$P(INP,U,2) D ^DIE
 .I $D(POP) S RET=$$ERR^BGOUTL(1026)
 .S DATA=$G(^AUPNFH(FIEN,0))
 S RET=FIEN
 I FIEN="" S RET="-1^Unable to store selected code" Q
 ;Remove current multiple ICD codes and then add them back in
 N DA,DIK,IEN,ERR,MULT,SUB,AIEN,ERR,FDA,SUBIEN
 S ERR=""
 S IEN=0 F  S IEN=$O(^AUPNFH(FIEN,11,IEN)) Q:'+IEN  D
 .S ERR=""
 .S DA(1)=FIEN,DA=IEN
 .S DIK="^AUPNFH(DA(1),11,"
 .S:DA ERR=$$DELETE^BGOUTL(DIK,.DA)
 I ERR'="" Q RET_" "_ERR
 S MULT=$P(SNODATA,U,5)
 F Y=2:1:$L(MULT,";") D
 .K IEN2,ERR
 .S ERR=""
 .S SUB=$P(MULT,";",Y)
 .;S SUB=$$ACTIVE(SUB)
 .I $$AICD^BGOUTL2 S SUBIEN=$P($$ICDDX^ICDEX(SUB,DT,"","E"),U,1)
 .E   S SUBIEN=$P($$ICDDX^ICDCODE(SUB),U,1)
 .S AIEN="+1,"_FIEN_","
 .S FDA(9000014.11,AIEN,.01)=SUBIEN
 .D UPDATE^DIE(,"FDA","IEN2","ERR")
 I ERR S RET=RET_U_"Unable to update qualifiers"
 Q
 ;------------------------------------------------------------
 ;Get the family history for a patient
 ;INP=Patient IEN
 ;.RET returned as a list of records in the format
 ;  Relationship IEN [1] Relationship [2] ^ Status [3] ^ Age at Death [4] ^ Cause of Death [5] ^
 ;  Multiple Birth [6] ^ Multiple Birth Type [7] ^ Condition [8] ^ Narrative [9] ^ [10] ^
 ;  Date Modified [11] ^Description [12]  ^Family hx IEN [13]^ Age at DX [14] ^
 ;  Age at DX Approximate [15] ^ Snomed CT [16] ^ Snomed Desc ID [17] ^
 ;  List of Additional ICD codes - ";" delimited [18]
GET(RET,INP) ;
 N X,DFN,NAME,FHIEN,FHX,CNT,REL,RELDATA,STAT,AGE,CAUSE,MB,MBTYPE,DX,NAR,MOD,ARRAY,DXAGE,DXAGEAPX
 N SNOMEDCT,SNODESC,ICD2,ICD2CODE,ICD2LIST,ICD2IEN,SNOTXT,EVNDT
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP
 I 'DFN S RET=$$ERR^BGOUTL(1001) Q
 S CNT=0,FHIEN=""
 F  S FHIEN=$O(^AUPNFH("AC",DFN,FHIEN)) Q:FHIEN=""  D
 . S FHX=$G(^AUPNFH(FHIEN,0))
 . Q:FHX=""
 . S (REL,STAT,AGE,CAUSE,MB,MBTYPE,DX,NAR,MOD,DXAGE,DXAGEAPX)=""
 . N RELIEN,DXIEN,NARIEN
 . S DXIEN=$P(FHX,U,1),NARIEN=$P(FHX,U,4),RELIEN=$P(FHX,U,9),EVNDT=$P(FHX,U,3)
 . S (NAR,SNOTXT)=""
 . I RELIEN'="" D
 . . S RELDATA=$G(^AUPNFHR(RELIEN,0))
 . . S X=$P(RELDATA,U,1),REL=$$EXTERNAL^DILFD(9000014.1,.01,"",X)
 . . S X=$P(RELDATA,U,4),STAT=$$EXTERNAL^DILFD(9000014.1,.04,"",X)
 . . S X=$P(RELDATA,U,5),AGE=$$EXTERNAL^DILFD(9000014.1,.05,"",X)
 . . S CAUSE=$P(RELDATA,U,6)
 . . S X=$P(RELDATA,U,7),MB=$$EXTERNAL^DILFD(9000014.1,.07,"",X)
 . . S X=$P(RELDATA,U,8),MBTYPE=$$EXTERNAL^DILFD(9000014.1,.08,"",X)
 . . S NAME=$P(RELDATA,U,3)
 . . ;IHS/MSC/MGH changed patch 14 to use correct calls
 . . ;S DX=$P($G(^ICD9(DXIEN,0)),U,1)
 . . I $$AICD^BGOUTL2 D
 . . . S DX=$P($$ICDDX^ICDEX(DXIEN,EVNDT,"","I"),U,2)
 . . E  D
 .. . S DX=$P($$ICDDX^ICDCODE(DXIEN,EVNDT),U,2)
 . . I +NARIEN S NAR=$$GET1^DIQ(9000014,FHIEN,.04)
 . . S X=$P(FHX,U,12),MOD=$$FMTDATE^BGOUTL(X)
 . . S DXAGE=$P(FHX,U,5)
 . . S DXAGEAPX=$P(FHX,U,15)
 . . S SNOMEDCT=$P(FHX,U,13)
 . . S SNODESC=$P(FHX,U,14)
 . . I SNODESC>0 S SNOTXT=$P($$DESC^BSTSAPI(SNODESC_"^^1"),U,2) ; DKA
 . . S ICD2IEN=0,(ICD2LIST,ICD2CODE)=""
 . . F  S ICD2IEN=$O(^AUPNFH(FHIEN,11,ICD2IEN))  Q:'+ICD2IEN  D
 . . . S ICD2=$P($G(^AUPNFH(FHIEN,11,ICD2IEN,0)),U,1)
 . . . ;IHS/MSC/MGH Changed to use correct code
 . . . ;I +ICD2 S ICD2CODE=$P($G(^ICD9(ICD2,0)),U,1)
 . . .I $$AICD^BGOUTL2 D
 . . . .S ICD2CODE=$P($$ICDDX^ICDEX(ICD2,EVNDT,"","I"),U,2)
 . . .E  D
 . . . .S ICD2CODE=$P($$ICDDX^ICDCODE(ICD2,EVNDT),U,2)
 . . .I ICD2CODE'="" D
 . . . .I ICD2LIST="" S ICD2LIST=ICD2CODE
 . . .E  S ICD2LIST=ICD2LIST_";"_ICD2CODE
 . . S CNT=CNT+1
 . . S ARRAY(RELIEN)=""
 . . S @RET@(CNT)=RELIEN_U_REL_U_STAT_U_AGE_U_CAUSE_U_MB_U_MBTYPE_U_DX_U_NAR_U_U_MOD_U_NAME_U_FHIEN_U_DXAGE_U_DXAGEAPX_U_SNOMEDCT_U_SNODESC_U_ICD2LIST_U_SNOTXT
 ;Check for relationships without any DX attached
 D EXTRA^BGOREL(.ARRAY)
 I CNT=0 S @RET@(1)="No family hx"
 Q
 ;------------------------------------------------------------
 ;Delete a family history problem
 ;INP= Relationship IEN [1] ^ Family HX ien [2]
DEL(RET,INP) ;EP
 N RIEN,DFN,FHIEN,ZN,ZP,REL,FIEN
 S RIEN=$P(INP,U,1),FHIEN=$P(INP,U,2)
 ;If no family history IEN is included, the entire relationship will be deleted
 ;else just delete the family history dx
 I FHIEN="" D
 .D DELREL(.RET,RIEN)
 .D EVT(RIEN,"",2,ZN)
 E  D
 .D DELFH(.RET,FHIEN)
 .D EVT(RIEN,FHIEN,2,ZN)
 Q
 ;
DELFH(RET,FHIEN) ;Delete one family history item
 S ZN=$G(^AUPNFH(FHIEN,0)),RET=""
 S DFN=$P(ZN,U,2)
 S RET=$$DELETE^BGOUTL("^AUPNFH(",FHIEN)
 Q
DELREL(RET,RIEN) ;Delete entire relation
 S ZN=$G(^AUPNFHR(RIEN,0)),RET=""
 Q:ZN=""
 S DFN=$P(ZN,U,2)
 ;Find the family history DX's for this patient and this relationship
 S FIEN="" F  S FIEN=$O(^AUPNFH("AC",DFN,FIEN)) Q:FIEN=""  D
 .S ZP=$G(^AUPNFH(FIEN,0))
 .I $P(ZP,U,9)=RIEN D DELFH(.RET,FIEN)
 S RET=$$DELETE^BGOUTL("^AUPNFHR(",RIEN)
 Q
 ; Broadcast a family history event
EVT(RIEN,FHIEN,OPR,X) ;EP
 N DFN,DATA
 S:'$D(X) X=$G(^AUPNFHR(RIEN,0))
 S DFN=$P(X,U,2),DATA=RIEN_U_FHIEN_$G(CIA("UID"))_U_OPR
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_".FHH",DATA)
 Q
ACTIVE(TYPE) ;Check to make sure the code is active
 N CDATA
 I $$AICD^BGOUTL2 S CDATA=$$ICDDX^ICDEX(TYPE,$$NOW^XLFDT)
 E  S CDATA=$$ICDDX^ICDCODE(TYPE,$$NOW^XLFDT)
 I $P(CDATA,U,10)'=1 S TYPE=".9999"
 Q TYPE
