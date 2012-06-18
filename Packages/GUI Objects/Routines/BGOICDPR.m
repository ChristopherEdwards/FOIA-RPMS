BGOICDPR ; IHS/BAO/TMD - ICD PREFERENCES MANAGER ;20-Apr-2011 09:01;DU
 ;;1.1;BGO COMPONENTS;**1,3,5,8**;Mar 20, 2007
 ; Validate an ICD9 code
VALIDATE(RET,IEN,CODE) ;EP
 I 'IEN,$G(CODE)'="" D
 .N X,LP
 .S IEN=-1,RET=-1
 .F LP=0,1 D  Q:RET'<0
 ..F X=0:0 S X=$O(^ICD9("AB",CODE_$S(LP:" ",1:""),X)) Q:'X  D  Q:RET'<0
 ...S IEN=X
 ...S RET=$$CHKICD^BGOVPOV(IEN)
 .S:IEN<0 RET=$$ERR^BGOUTL(1029,CODE)
 E  I 'IEN S RET=$$ERR^BGOUTL(1030)
 E  S RET=$$CHKICD^BGOVPOV(IEN)
 S:RET'<0 RET=""
 Q
 ; Return long name for an ICD9 code
GETLNAME(RET,IEN) ;EP
 I 'IEN S RET=$$ERR^BGOUTL(1030)
 E  S RET=$P($G(^ICD9(+IEN,1)),U)
 Q
 ; Return categories matching specified criteria
 ;  INP = Category IEN [1] ^ Hospital Location IEN [2] ^ Provider IEN [3] ^ Manager IEN [4] ^ Show All [5]
GETCATS(RET,INP) ;EP
 D GETCATS^BGOPFUTL(.RET,INP,90362.35)
 Q
 ; Returns list of ICD9s for specified category
 ;  INP = Category IEN [1] ^ Group [2] ^ Visit IEN [3] ^ Display Freq Order [4]
 ;  Returns list of records in the format
 ;   ICD9 IEN [1] ^ ICD9 Code [2] ^ ICD9 Text [3] ^ Short Text [4] ^ Freq [5] ^
 ;   VPOV IEN [6] ^ Rank [7] ^ Pref IEN [8] ^ Long Text [9]
GETITEMS(RET,INP) ;EP
 N PX,I,J,FREQ,VIEN,GRP,CAT,LONG,VPX,FREQ,CNT,RANK,IEN
 S RET=$$TMPGBL^BGOUTL
 S CAT=+INP
 I 'CAT S @RET@(1)=$$ERR^BGOUTL(1018) Q
 I '$D(^BGOICDPR(CAT,0)) S @RET@(1)=$$ERR^BGOUTL(1019) Q
 S GRP=$P(INP,U,2)
 S VIEN=$P(INP,U,3)
 S FREQ=$P(INP,U,4)
 S:$P(^BGOICDPR(CAT,0),U,6) GRP=""
 I VIEN D
 .S VPX=0
 .F  S VPX=$O(^AUPNVPOV("AD",VIEN,VPX)) Q:'VPX  D
 ..S I=$G(^AUPNVPOV(VPX,0))
 ..S:$L(I) VPX(+I,+$P(I,U,4))=VPX
 S (CNT,RANK)=0
 I FREQ D
 .S J=""
 .F  S J=$O(^BGOICDPR(CAT,1,"AC",J),-1) Q:J=""  D
 ..S IEN=0
 ..F  S IEN=$O(^BGOICDPR(CAT,1,"AC",J,IEN)) Q:'IEN  D GD1
 E  D
 .S IEN=0
 .F  S IEN=$O(^BGOICDPR(CAT,1,IEN)) Q:'IEN  D GD1
 Q
GD1 N N0,ICDIEN,TXT,DX,FREQVAL,CODE
 S N0=$G(^BGOICDPR(CAT,1,IEN,0))
 S ICDIEN=+N0
 Q:'ICDIEN
 Q:'$D(^ICD9(ICDIEN,0))
 S DX=$P(^ICD9(ICDIEN,0),U,3),CODE=$P(^(0),U)
 S TXT=$P(N0,U,2),TXT(0)=+$$FNDNARR^BGOUTL2(TXT,0)
 S LONG=$P($G(^ICD9(ICDIEN,1)),U)
 S FREQVAL=$P(N0,U,3)
 I FREQ D
 .S RANK=RANK+1
 .S RANK=$S(RANK<10:"00",RANK<100:"0",1:"")_RANK
 S CNT=CNT+1
 S @RET@(CNT)=ICDIEN_U_CODE_U_DX_U_TXT_U_FREQVAL_U_$G(VPX(ICDIEN,TXT(0)))_U_RANK_U_IEN_U_LONG
 Q
 ; Return list of managers associated with a specified category
GETMGRS(RET,CAT) ;EP
 D GETMGRS^BGOPFUTL(.RET,CAT,90362.35)
 Q
 ; Set category fields
 ;  INP = Name [1] ^ Hosp Loc [2] ^ Clinic [3] ^ Provider [4] ^ User [5] ^ Category IEN [6] ^ Delete [7] ^ Discipline [8]
SETCAT(RET,INP) ;EP
 D SETCAT^BGOPFUTL(.RET,INP,90362.35)
 Q
 ; Set field values for a ICD preference entry
 ;  INP = Category IEN [1] ^ ICD IEN [2] ^ Display Text [3] ^ Delete [4] ^ ICD Code [5] ^ Frequency [6] ^
 ;        Allow Dups [7] ^ Item IEN [8]
SETITEM(RET,INP) ;EP
 D SETITEM^BGOPFUTL(.RET,INP,90362.35)
 Q
 ; Add or remove a manager from a category
 ;  INP = Category IEN [1] ^ Manager IEN [2] ^ Add [3]
SETMGR(RET,INP) ;EP
 D SETMGR^BGOPFUTL(.RET,INP,90362.352)
 Q
 ; Set display name for an item
 ;  INP = Category IEN [1] ^ Item IEN [2] ^ Display Name [3]
SETNAME(RET,INP) ;EP
 D SETNAME^BGOPFUTL(.RET,INP,90362.351)
 Q
 ; Set frequency for an item
 ;  INP = Category IEN [1] ^ ICD IEN [2] ^ Increment [3] ^ Frequency [4]
SETFREQ(RET,INP) ;EP
 D SETFREQ^BGOPFUTL(.RET,INP,90362.351)
 Q
