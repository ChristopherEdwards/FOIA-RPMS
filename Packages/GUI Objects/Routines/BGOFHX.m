BGOFHX ; IHS/MSC/MGH - New family history component ;24-Feb-2010 12:24;DU
 ;;1.1;BGO COMPONENTS;**6**;Mar 20, 2007
 ;---------------------------------------------
 ; Add/edit entry family/personal history corresponding to problem entry
 ;INP=Patient IEN [1] ^ Relationship IEN [2] ^ DX [3] ^ Narrative [4] ^Age at Onset [5] ^FHX IEN [6]
SET(RET,INP) ;
 N FDA,RIEN,DFN,DMOD,REL,FNUM,EDIT,ICD,ICDX,ICDIEN,FIEN,FNEW,IENX,NEW
 S DFN=$P(INP,U,1),RIEN=$P(INP,U,2),ICD=$P(INP,U,3),FIEN=$P(INP,U,6)
 Q:DFN=""
 Q:RIEN=""
 S ICDIEN=$P($$ICDDX^ICDCODE(ICD),U,1)
 I ICDIEN="" S RET=$$ERR^BGOUTL(1092) Q
 S EDIT=0
 S NEW=0
 I FIEN="" D
 .S FNEW=1
 .S FIEN="+1",NEW=1
 S FDA=$NA(FDA(9000014,FIEN_","))
 S @FDA@(.01)=$P(INP,U,3)
 I NEW=1 S @FDA@(.02)="`"_DFN
 S RET=$$FNDNARR^BGOUTL2($P(INP,U,4))
 Q:RET<0
 S NARR=$S(RET:"`"_RET,1:""),RET=""
 S @FDA@(.04)=NARR
 S @FDA@(.08)="`"_DUZ
 ;S @FDA@(.09)="`"_$P(INP,U,2)
 S @FDA@(.11)=$P(INP,U,5)
 I NEW=1 S @FDA@(.03)="TODAY"
 S @FDA@(.12)="TODAY"
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IENX)
 S:$E(FIEN)="+" FIEN=$G(IENX(1))
 I RET="" D
 .N DIE,DA,DR
 .S DIE="^AUPNFH(",DA=FIEN,DR=".09////"_$P(INP,U,2) D ^DIE
 .I POP S RET=$$ERR^BGOUTL(1026)
 .S DATA=$G(^AUPNFH(FIEN,0))
 S RET=FIEN
 Q:RET
 ;------------------------------------------------------------
 ;Get the family history for a patient
 ;INP=Patient IEN
 ;.RET returned as a list of records in the format
 ;Relationship IEN [1] Relationship [2] ^ Status [3] ^ Age at Death [4] ^ Cause of Death [5] ^ Multiple Birth [6] ^ Multiple Birth Type [7] ^
 ;Condition [8] ^ Narrative [9] ^ Age at DX [10] ^ Date Modified [11] ^Description [12]  ^Family hx IEN [13]
GET(RET,INP) ;
 N X,DFN,NAME,FHIEN,FHX,CNT,REL,RELDATA,STAT,AGE,CAUSE,MB,MBTYPE,DX,NAR,AGEDX,MOD,ARRAY
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP
 I 'DFN S RET=$$ERR^BGOUTL(1001) Q
 S CNT=0,FHIEN=""
 F  S FHIEN=$O(^AUPNFH("AC",DFN,FHIEN)) Q:FHIEN=""  D
 . S FHX=$G(^AUPNFH(FHIEN,0))
 . Q:FHX=""
 . S (REL,STAT,AGE,CAUSE,MB,MBTYPE,DX,NAR,AGEDX,MOD)=""
 . N RELIEN,DXIEN,NARIEN
 . S DXIEN=$P(FHX,U,1),NARIEN=$P(FHX,U,4),RELIEN=$P(FHX,U,9)
 . I RELIEN'="" D
 . . S RELDATA=$G(^AUPNFHR(RELIEN,0))
 . . S X=$P(RELDATA,U,1),REL=$$EXTERNAL^DILFD(9000014.1,.01,"",X)
 . . S X=$P(RELDATA,U,4),STAT=$$EXTERNAL^DILFD(9000014.1,.04,"",X)
 . . S X=$P(RELDATA,U,5),AGE=$$EXTERNAL^DILFD(9000014.1,.05,"",X)
 . . S CAUSE=$P(RELDATA,U,6)
 . . S X=$P(RELDATA,U,7),MB=$$EXTERNAL^DILFD(9000014.1,.07,"",X)
 . . S X=$P(RELDATA,U,8),MBTYPE=$$EXTERNAL^DILFD(9000014.1,.08,"",X)
 . . S NAME=$P(RELDATA,U,3)
 . . S DX=$P($G(^ICD9(DXIEN,0)),U,1)
 . . I +NARIEN S NAR=$P($G(^AUTNPOV(NARIEN,0)),U,1)
 . . S X=$P(FHX,U,11),AGEDX=$$EXTERNAL^DILFD(9000014,.11,"",X)
 . . S X=$P(FHX,U,12),MOD=$$FMTDATE^BGOUTL(X)
 . . S CNT=CNT+1
 . . S ARRAY(RELIEN)=""
 . . S @RET@(CNT)=RELIEN_U_REL_U_STAT_U_AGE_U_CAUSE_U_MB_U_MBTYPE_U_DX_U_NAR_U_AGEDX_U_MOD_U_NAME_U_FHIEN
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
