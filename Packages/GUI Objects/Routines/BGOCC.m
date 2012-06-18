BGOCC ; IHS/BAO/TMD - Manage Chief Complaints ;18-Sep-2007 14:42;DKM
 ;;1.1;BGO COMPONENTS;**1,3,4**;Mar 20, 2007
 ; Returns chief complaint for current vuecentric visit context for
 ; use by TIU object.  Assumes DFN is defined.
TIUML(TARGET) ;
 N X
 S X=$$GETVAR^CIANBUTL("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 Q:X="" " "
 S X=$$VSTR2VIS^BEHOENCX(DFN,X)
 Q:X<1 " "
 D GET(.X,X)
 S X=$P(X,U,3),X=$S($L(X):"Chief Complaint: "_X,1:"No Chief Complaint.")
 K @TARGET
 S @TARGET@(1,0)=X
 Q "~@"_$NA(@TARGET)
 ; Returns chief complaint history.  If there is a V Narrative of type CHIEF COMPLAINT,
 ; this is returned preferentially.  Otherwise, the value of the CHIEF COMPLAINT field
 ; of the VISIT file entry is returned.
 ;  INP = Visit IEN
 ; .RET = List in format:
 ;    IEN [1] ^ Author [2] ^ Line Count [3]
 ;    Text Lines
GET(RET,INP) ;EP
 N VIEN,VNT,I,N,CCTYPE,CNT,AUTH
 S VIEN=+INP,RET=$$TMPGBL^BGOUTL
 I 'VIEN S @RET@(0)=$$ERR^BGOUTL(1002) Q
 I '$D(^AUPNVSIT(VIEN,0)) S @RET@(0)=$$ERR^BGOUTL(1003) Q
 S CCTYPE=$$CCTYPE
 S (CNT,VNT)=0
 F  S VNT=$O(^AUPNVNT("AD",VIEN,VNT)) Q:'VNT  D
 .Q:$P($G(^AUPNVNT(VNT,0)),U)'=CCTYPE
 .S AUTH=$P($G(^AUPNVNT(VNT,12)),U,4)
 .S:AUTH AUTH=AUTH_"~"_$P($G(^VA(200,AUTH,0)),U)
 .S (I,N)=0,CNT=CNT+1
 .F  S N=$O(^AUPNVNT(VNT,11,N)) Q:'N  S I=I+1,@RET@(CNT,I)=$G(^(N,0))
 .S @RET@(CNT)=VNT_U_AUTH_U_I
 S I=$P($G(^AUPNVSIT(VIEN,14)),U)
 S:$L(I) CNT=CNT+1,@RET@(CNT)="0^^1",@RET@(CNT,1)=I
 Q
 ; Return IEN for Chief Complaint.  Optionally create it if not found.
CCTYPE(CREATE) ;
 N TYPE,FDA,IEN
 S TYPE=$O(^AUTTNTYP("B","CHIEF COMPLAINT",0))
 I 'TYPE,$G(CREATE) D
 .S FDA(9999999.89,"+1,",.01)="CHIEF COMPLAINT"
 .S:'$$UPDATE^BGOUTL(.FDA,,.IEN) TYPE=$G(IEN(1))
 Q TYPE
 ; Delete chief complaint
DEL(RET,VNT) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VNT)
 Q
 ; Add/edit chief complaint
 ;  INP = Visit IEN ^ V Narrative IEN ^ Chief Complaint
 ; .RET = V Narrative IEN or -n^error text
SET(RET,INP) ;EP
 N VIEN,VFIEN,CC,TYPE,VFNEW,FNUM,FDA
 S FNUM=$$FNUM
 S VIEN=+INP
 S RET=$$CHKVISIT^BGOUTL(VIEN,,"AIT")
 Q:RET
 S VFIEN=+$P(INP,U,2)
 S CC=$P(INP,U,3)
 S CC=$$TOWP^BGOUTL("CC")
 S TYPE=$$CCTYPE(1)
 I 'TYPE S RET=$$ERR^BGOUTL(1004) Q
 I CC="" D:VFIEN DEL(.RET,VFIEN) Q
 I VFIEN D  Q:RET
 .N X
 .S X=$P($G(^AUPNVNT(VFIEN,12)),U,4)
 .I X,X'=DUZ S RET=$$ERR^BGOUTL(1005,$P($G(^VA(200,X,0)),U))
 S VFNEW='VFIEN
 I 'VFIEN D  Q:RET
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(1100)=CC
 S @FDA@(1201)="N"
 S @FDA@(1204)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E@")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Return pick list entries for chief complaint
 ;  TYP = 1: Symptom, 2: Disease, 3: Request
 ; .RET is list of records in format:
 ;   IEN ^ Display Text ^ Body Location Related
GETPL(RET,TYP) ;EP
 N IEN,NAME,BODY,CNT
 S RET=$$TMPGBL^BGOUTL
 I '$G(TYP) S @RET@(1)=$$ERR^BGOUTL(1006) Q
 S (IEN,CNT)=0
 F  S IEN=$O(^BGOCCPL("AC",TYP,IEN)) Q:'IEN  D
 .N NAME,BODY,X
 .S X=$G(^BGOCCPL(IEN,0))
 .S NAME=$P(X,U),BODY=$P(X,U,3)
 .S CNT=CNT+1,@RET@(CNT)=IEN_U_NAME_U_BODY
 Q
 ; Add a pick list entry
 ;  INP = Name ^ Type ^ Body Related
SETPL(RET,INP) ;EP
 N NAME,TYPE,BODY,FDA,IENS,IEN
 S NAME=$P(INP,U)
 I NAME="" S RET=$$ERR^BGOUTL(1007) Q
 S TYPE=+$P(INP,U,2)
 S BODY=$P(INP,U,3)
 S IENS=$O(^BGOCCPL("B",NAME,0))
 S IENS=$S(IENS:IENS_",",1:"+1,")
 S FDA=$NA(FDA(90362.2,IENS))
 S @FDA@(.01)=NAME
 S @FDA@(.02)=TYPE
 S @FDA@(.03)=BODY
 S RET=$$UPDATE^BGOUTL(.FDA,"E",.IEN)
 S:'RET RET=$G(IEN(1),+IENS)
 Q
 ; Delete pick list name
 ;  IEN = Pick List IEN
 ;  .RET = -1^error text if error
DELPL(RET,IEN) ;EP
 S:IEN RET=$$DELETE^BGOUTL("^BGOCCPL(",IEN)
 Q
 ; Return V File #
FNUM() Q 9000010.34
