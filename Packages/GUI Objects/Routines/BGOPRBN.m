BGOPRBN ; IHS/BAO/TMD - Manage problem note ;20-Mar-2007 13:52;DKM
 ;;1.1;BGO COMPONENTS;**1,3**;Mar 20, 2007
 ; Retrieve notes associated with a problem entry
 ;  PRIEN = Problem IEN
 ;  Returns a list of records in the format:
 ;   Location IEN [1] ^ Note IEN [2] ^ Note # [3] ^ Narrative [4] ^
 ;   Status [5] ^ Date Added [6] ^ Author Name [7]
GET(RET,PRIEN) ;EP
 D NOTES(.RET,PRIEN,1)
 Q
 ; Add/edit Problem Note
 ;  INP = Problem IEN [1] ^ Note IEN [2] ^ Location IEN [3] ^ Note # [4] ^ Narrative [5] ^ Status [6]
 ; .RET = Problem IEN [1] ^ Note IEN [2] ^ Location IEN [3] ^ Note # [4] ^ Narrative [5] ^ Status [6] ^
 ;        Date Entered [7] ^ Author Name [8] ^ Note ID [9]
 ;    or -n^error text
SET(RET,INP) ;EP
 N PRIEN,LIEN,NIEN,NOTN,NARR,STAT,DENT,FDA,NNEW,NOTID,AUTH,X
 S PRIEN=+INP,NIEN=$P(INP,U,2),LIEN=$P(INP,U,3),NOTN=$P(INP,U,4),NARR=$P(INP,U,5),STAT=$P(INP,U,6)
 S NARR=$TR(NARR,$C(13,10))
 S DENT=$S(NIEN:"",1:DT)
 S NNEW='NOTN
 S:'NIEN NIEN=$$GETNIEN(PRIEN,LIEN)
 I 'NIEN S RET=$$ERR^BGOUTL(1045) Q
 S:'NOTN NOTN=1+$O(^AUPNPROB(PRIEN,11,NIEN,11,"B",""),-1)
 S FDA=$NA(FDA(9000011.1111,$S(NNEW:"+1,",1:NOTN_",")_NIEN_","_PRIEN_","))
 S:NNEW @FDA@(.01)=NOTN
 S @FDA@(.03)=NARR
 S @FDA@(.04)=STAT
 S:NNEW @FDA@(.05)=DENT
 S:NNEW @FDA@(.06)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 Q:RET
 S X=^AUPNPROB(PRIEN,0),NOTID=$P(^AUTTLOC($P(X,U,6),0),U,7)_$P(X,U,7)_":"_NOTN
 S X=+$O(^AUPNPROB(PRIEN,11,NIEN,11,"B",NOTN,0))
 S X=$G(^AUPNPROB(PRIEN,11,NIEN,11,X,0)),AUTH=$P($G(^VA(200,+$P(X,U,6),0)),U),DENT=$P(X,U,5)
 D EVT^BGOPROB(PRIEN,1)
 S RET=PRIEN_U_NIEN_U_LIEN_U_NOTN_U_NARR_U_STAT_U_DENT_U_AUTH_U_NOTID
 Q
 ; Delete a problem note
 ;  INP = Problem IEN [1] ^ Location IEN [2] ^ Note IEN [3]
DEL(RET,INP) ;EP
 N PRIEN,LIEN,NIEN,DA
 S RET=""
 S PRIEN=+INP,LIEN=+$P(INP,U,2),NIEN=$P(INP,U,3)
 S LIEN=$O(^AUPNPROB(PRIEN,11,"B",LIEN,0))
 I 'LIEN S RET=$$ERR^BGOUTL(1046) Q
 S DA=NIEN
 S DA(1)=LIEN
 S DA(2)=PRIEN
 S RET=$$DELETE^BGOUTL("^AUPNPROB("_DA(2)_",11,"_DA(1)_",11,",.DA)
 D:'RET EVT^BGOPROB(PRIEN,0)
 Q
 ; Retrieve/create subfile IEN for note/facility
GETNIEN(PRIEN,LIEN) ;
 N NIEN,FDA,IEN,IENS
 S NIEN=$O(^AUPNPROB(PRIEN,11,"B",LIEN,0))
 Q:NIEN NIEN
 S IENS="+1,"_PRIEN_","
 S FDA(9000011.11,IENS,.01)=LIEN
 S:'$$UPDATE^BGOUTL(.FDA,,.IEN) NIEN=IEN(1)
 Q NIEN
 ; Return all notes for a problem entry
 ;  PRIEN  = Problem IEN
 ;  FORMAT = Return format (0=single string, 1=list)
NOTES(RET,PRIEN,FORMAT) ;EP
 N NOT,IEN,NARR,FAC,REC,NMBR,STAT,DATE,AUTH,CNT
 K RET
 S RET="",(CNT,IEN)=0
 F  S IEN=$O(^AUPNPROB(PRIEN,11,IEN)) Q:'IEN  D
 .S FAC=$P($G(^AUPNPROB(PRIEN,11,IEN,0)),U)
 .S NOT=0
 .F  S NOT=$O(^AUPNPROB(PRIEN,11,IEN,11,NOT)) Q:'NOT  D
 ..S REC=$G(^AUPNPROB(PRIEN,11,IEN,11,NOT,0))
 ..S NARR=$TR($P(REC,U,3),$C(13,10))
 ..Q:NARR=""
 ..I 'FORMAT S RET=RET_$S($L(RET):"; ",1:"")_NARR
 ..E  D
 ...S NMBR=$P(REC,U)
 ...S STAT=$P(REC,U,4)
 ...S DATE=$P(REC,U,5)
 ...S AUTH=$P(REC,U,6)
 ...S:AUTH AUTH=$P($G(^VA(200,AUTH,0)),U)
 ...S CNT=CNT+1
 ...S RET(CNT)=FAC_U_NOT_U_NMBR_U_NARR_U_STAT_U_DATE_U_AUTH
 Q
