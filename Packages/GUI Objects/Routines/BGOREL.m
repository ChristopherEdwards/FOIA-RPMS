BGOREL ; IHS/MSC/MGH - New family history component ;05-Feb-2010 15:08;MGH
 ;;1.1;BGO COMPONENTS;**6**;Mar 20, 2007
 ;---------------------------------------------
 ;Add/edit a relationship and diagnoses for a patient
 ;DFN=Patient IEN [1]
 ;LIST(1)=REL^ Relationship ien [2] ^ Relationship [3] ^ Relationship Desc [4] ^ Status [5] ^ Age at Death [6]
 ;Cause of Death [7] ^ Multiple Birth [8] ^ Multiple Birth Type [9]
 ;LIST(n)=FHX^ Family HS ien [2]^ DX [3] ^ Narrative [4] ^ Age at Onset [5]
SET(RET,DFN,INP) ;
 N FDA,LP,NEW,IEN,REL,OLDRIEN,RET2,RELIEN,FIEN,RIEN,DESC,STAT,DAGE,DCAUSE,MB,MBT,RNAME,IENX,INP2,DATA
 S RET2=""
 I 'DFN S RET=$$ERR^BGOUTL(1001) Q
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 S LP="" F  S LP=$O(INP(LP)) Q:LP=""  D
 .S FAM=INP(LP)
 .I $E(FAM,1,3)="REL" D EREL
 .I $E(FAM,1,3)="FHX" D EFHX
 S RET=RET2
 Q
EREL ;Add/Edit a relationship
 S (RELIEN,OLDRIEN)=$P(FAM,U,2)  ;If blank its a new one
 S RNAME=$P(FAM,U,3)
 S RIEN="",RIEN=$O(^AUTTRLSH("B",RNAME,RIEN))
 I RIEN="" S RET=$$ERR^BGOUTL(1008) Q
 ;Q:RIEN=""
 S NEW=0,FIEN=""
 ;Store new relationship
 I RELIEN="" D
 .S RELIEN="+1",NEW=1
 S FDA=$NA(FDA(9000014.1,RELIEN_","))
 S @FDA@(.01)=RNAME
 S @FDA@(.02)="`"_DFN
 S @FDA@(.03)=$P(FAM,U,4)
 S @FDA@(.04)=$P(FAM,U,5)
 S @FDA@(.05)=$P(FAM,U,6)
 S @FDA@(.06)=$P(FAM,U,7)
 S @FDA@(.07)=$P(FAM,U,8)
 S @FDA@(.08)=$P(FAM,U,9)
 I NEW=1 S @FDA@(.11)="TODAY"
 S @FDA@(.09)="TODAY"
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IENX)
 S:$E(RELIEN)="+" RELIEN=$G(IENX(1))
 I +RELIEN D
 .S DATA=$G(^AUPNFHR(RELIEN,0))
 .S RET2=RELIEN_";R"
 E  S RET2=RET
 Q
EFHX ;Add/edit a family history
 I '$D(RELIEN) S RET="Relationship not defined" Q
 I RELIEN="" S RET="Unknown relationship" Q
 I OLDRIEN=""&($P(FAM,U,2)'="") S RET="Cannot add an existing FHX to a new relationship" Q
 I $P(FAM,U,3)'="" D
 .S INP2=DFN_"^"_RELIEN_"^"_$P(FAM,U,3)_"^"_$P(FAM,U,4)_"^"_$P(FAM,U,5)_"^"_$P(FAM,U,2)
 .S RET=""
 .D SET^BGOFHX(.RET,INP2)
 .S FIEN=RET
 .S RET2=RET2_"^"_FIEN_";F"
 .;Process event
 .D EVT^BGOFHX(RELIEN,FIEN,NEW,DATA)
 Q
EXTRA(ARRAY) ;Search relationships
 N FREL,IEN,RELDATA,REL,STAT,AGE,MB,MBTYPE,CAUSE
 S FREL="" F  S FREL=$O(^AUPNFHR("AA",DFN,FREL)) Q:FREL=""  D
 .S IEN="" F  S IEN=$O(^AUPNFHR("AA",DFN,FREL,IEN)) Q:IEN=""  D
 ..I $D(ARRAY(IEN)) Q                ;This relationship already exists
 ..I '$D(ARRAY(IEN)) D
 . . . S RELDATA=$G(^AUPNFHR(IEN,0))
 . . . S X=$P(RELDATA,U,1),REL=$$EXTERNAL^DILFD(9000014.1,.01,"",X)
 . . . S X=$P(RELDATA,U,4),STAT=$$EXTERNAL^DILFD(9000014.1,.04,"",X)
 . . . S X=$P(RELDATA,U,5),AGE=$$EXTERNAL^DILFD(9000014.1,.05,"",X)
 . . . S CAUSE=$P(RELDATA,U,6)
 . . . S X=$P(RELDATA,U,7),MB=$$EXTERNAL^DILFD(9000014.1,.07,"",X)
 . . . S X=$P(RELDATA,U,8),MBTYPE=$$EXTERNAL^DILFD(9000014.1,.08,"",X)
 . . . S X=$P(RELDATA,U,9),MOD=$$FMTDATE^BGOUTL(X)
 . . . S NAME=$P(RELDATA,U,3)
 . . . S CNT=CNT+1
 . . . S @RET@(CNT)=IEN_U_REL_U_STAT_U_AGE_U_CAUSE_U_MB_U_MBTYPE_"^^^^"_MOD_U_NAME_"^"
 Q
