BGOCPTPR ; IHS/BAO/TMD - CPT PREFERENCES MANAGER ;05-Feb-2008 11:28;DKM
 ;;1.1;BGO COMPONENTS;**1,3,5**;Mar 20, 2007
 ; Validates a CPT code
VALIDATE(RET,IEN,CODE) ;EP
 I 'IEN,$G(CODE)'="" D
 .N X
 .S IEN=-1,RET=""
 .F X=0:0 S X=$O(^ICPT("B",CODE,X)) Q:'X  D  Q:RET'<0
 ..S IEN=X
 ..S RET=$$CHKCPT^BGOVCPT(IEN)
 .S:IEN<0 RET=$$ERR^BGOUTL(1020,CODE)
 E  I 'IEN S RET=$$ERR^BGOUTL(1021)
 E  S RET=$$CHKCPT^BGOVCPT(IEN)
 S:RET'<0 RET=""
 Q
 ; Return long name of CPT
 ;  IEN = CPT IEN
GETLNAME(RET,IEN) ;EP
 N I,X
 I 'IEN S RET=$$ERR^BGOUTL(1021) Q
 S X=0,RET=""
 F I=1:1 S X=$O(^ICPT(IEN,"D",X)) Q:'X  S RET=RET_$S($L(RET):" ",1:"")_$G(^(X,0))
 Q
 ; Return categories matching specified criteria
 ;  INP = Category IEN [1] ^ Location IEN [2] ^ Provider IEN [3] ^ Manager IEN [4] ^ Show All [5] ^ Historical Flag [6]
 ;    where Historical Flag is (0=Non-historical only, 1=Historical only, 2=Both)
GETCATS(RET,INP) ;EP
 D GETCATS^BGOPFUTL(.RET,INP,90362.31)
 Q
 ; Returns list of CPTs for specified category
 ;  INP = Category IEN [1] ^ Group [2] ^ Visit IEN [3] ^ Display Freq Order [4]
 ;  Returned as a list of records in the format
 ;   CPT IEN [1] ^ CPT Code [2] ^ CPT Text [3] ^ Short Text [4] ^ Freq [5] ^
 ;   VCPT IEN [6] ^ Fee [7] ^ Rank [8] ^ Pref IEN [9] ^ Association [10] ^
 ;   Long Text [11]
GETITEMS(RET,INP) ;EP
 N PX,I,J,FREQ,VIEN,LONG,GRP,CAT,VPX,FREQ,CNT,RANK,IEN,SCHED
 S RET=$$TMPGBL^BGOUTL
 S CAT=+INP
 I 'CAT S @RET@(1)=$$ERR^BGOUTL(1018) Q
 I '$D(^BGOCPTPR(CAT,0)) S @RET@(1)=$$ERR^BGOUTL(1019) Q
 S GRP=$P(INP,U,2)
 S VIEN=$P(INP,U,3)
 S FREQ=$P(INP,U,4)
 S:$P(^BGOCPTPR(CAT,0),U,6) GRP=""
 I VIEN D
 .S VPX=0
 .F  S VPX=$O(^AUPNVCPT("AD",VIEN,VPX)) Q:'VPX  D
 ..S I=$G(^AUPNVCPT(VPX,0))
 ..S:$L(I) VPX(+I,+$P(I,U,4))=VPX
 S (CNT,RANK)=0
 S I=$P($G(^AUPNVSIT(+VIEN,0)),U,6)
 S:'I I=+$G(DUZ(2))
 S SCHED=+$P($G(^ABMDPARM(DUZ(2),I,0)),U,9)
 I FREQ D
 .S J=""
 .F  S J=$O(^BGOCPTPR(CAT,1,"AC",J),-1) Q:J=""  D
 ..S IEN=0
 ..F  S IEN=$O(^BGOCPTPR(CAT,1,"AC",J,IEN)) Q:'IEN  D GP1
 E  D
 .S IEN=0
 .F  S IEN=$O(^BGOCPTPR(CAT,1,IEN)) Q:'IEN  D GP1
 Q
GP1 N N0,CPTIEN,TXT,CPT,PX,FEE,ADA,FREQVAL,ASSOC
 S N0=$G(^BGOCPTPR(CAT,1,IEN,0))
 S CPTIEN=+N0
 Q:'CPTIEN
 Q:'$D(^ICPT(CPTIEN,0))
 S CPT=$P(^ICPT(CPTIEN,0),U),PX=$P(^(0),U,2)
 S (FEE,TXT,LONG)=""
 D GETLNAME(.LONG,CPTIEN)
 I CPT>9999,CPT<70000 S FEE=$P($G(^ABMDFEE(SCHED,11,CPTIEN,0)),U,2)
 I CPT?1A4N S FEE=$P($G(^ABMDFEE(SCHED,11,CPTIEN,0)),U,2)
 I CPT>69999,CPT<80000 S FEE=$P($G(^ABMDFEE(SCHED,15,CPTIEN,0)),U,2)
 I CPT>79999,CPT<90000 S FEE=$P($G(^ABMDFEE(SCHED,17,CPTIEN,0)),U,2)
 I CPT>89999,CPT<100000 S FEE=$P($G(^ABMDFEE(SCHED,19,CPTIEN,0)),U,2)
 I $E(CPT)="D" S ADA=$O(^AUTTADA("B",$E(CPT,2,5),0)) Q:'ADA  D
 .S FEE=$O(^ABMDFEE(SCHED,21,"B",ADA,0))
 .S FEE=$P($G(^ABMDFEE(SCHED,21,+FEE,0)),U,2)
 .S PX=$P($G(^AUTTADA(ADA,0)),U,2)
 S TXT=$P(N0,U,2),TXT(0)=+$$FNDNARR^BGOUTL2(TXT,0)
 S FREQVAL=$P(N0,U,3)
 S ASSOC=''$O(^BGOCPTPR(CAT,1,IEN,1,1))
 S:FREQ RANK=RANK+1
 S CNT=CNT+1
 S @RET@(CNT)=CPTIEN_U_CPT_U_PX_U_TXT_U_FREQVAL_U_$G(VPX(CPTIEN,TXT(0)))_U_FEE_U_$TR($J(RANK,4,0)," ",0)_U_IEN_U_ASSOC_U_LONG
 Q
 ; Return list of managers associated with a specified category
GETMGRS(RET,CAT) ;EP
 D GETMGRS^BGOPFUTL(.RET,CAT,90362.31)
 Q
 ; Set category fields
 ;  INP = Name [1] ^ Hosp Loc [2] ^ Clinic [3] ^ Provider [4] ^ User [5] ^ Category IEN [6] ^ Delete [7] ^ Discipline [8]
SETCAT(RET,INP) ;EP
 D SETCAT^BGOPFUTL(.RET,INP,90362.31)
 Q
 ; Set field values for a CPT preference entry
 ;  INP = Category IEN [1] ^ CPT IEN [2] ^ Display Text [3] ^ Delete [4] ^ CPT Code [5] ^ Frequency [6] ^
 ;        Allow Dups [7] ^ Item IEN [8]
SETITEM(RET,INP) ;EP
 D SETITEM^BGOPFUTL(.RET,INP,90362.31)
 Q
 ; Add or remove a manager from a category
 ;  INP = Category IEN [1] ^ Manager IEN [2] ^ Add [3]
SETMGR(RET,INP) ;EP
 D SETMGR^BGOPFUTL(.RET,INP,90362.313)
 Q
 ; Set display name for a preference
 ;  INP = Category IEN [1] ^ Item IEN [2] ^ Display Name [3]
SETNAME(RET,INP) ;EP
 D SETNAME^BGOPFUTL(.RET,INP,90362.312)
 Q
 ; Set frequency for a CPT code
 ;  INP = Category IEN [1] ^ CPT IEN [2] ^ Increment [3] ^ Frequency [4]
SETFREQ(RET,INP) ;EP
 D SETFREQ^BGOPFUTL(.RET,INP,90362.312)
 Q
