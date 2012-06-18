BGOPROB ; IHS/BAO/TMD - pull patient PROBLEMS ;22-Apr-2011 09:10;MGH
 ;;1.1;BGO COMPONENTS;**1,3,6,7,8**;Mar 20, 2007
 ;---------------------------------------------
 ; Check for existence of problem id
 ;  INP = Patient IEN ^ Problem ID ^ Site IEN ^ Problem IEN (optional)
 ; Patch 6 removed references to family history since they are in separate components
 ; Patch 6 also added ability to view and add classification for ashtma dx
 ; Patch 8 changes - problems are now logically deleted
CKID(RET,INP) ;EP
 N DFN,SITE,PIEN,IEN,X1,X2
 S DFN=+INP
 S X1=$P(INP,U,2),X2=$P(X1,".",2),X1=$P(X1,".")
 S SITE=+$P(INP,U,3)
 S PIEN=$P(INP,U,4)
 S IEN=$O(^AUPNPROB("AA",DFN,SITE," "_$E("000",1,4-$L(X1)-1)_X1_"."_X2_$E("00",1,3-$L(X2)-1),0))
 I IEN,IEN'=PIEN S RET=$$ERR^BGOUTL(1047)
 E  S RET=$S(PIEN:IEN=PIEN,1:"")
 Q
 ; Return next problem id
 ;  DFN = Patient IEN
 ; .RET = Problem ID
NEXTID(RET,DFN) ;EP
 N ABBRV
 S ABBRV=$P($G(^AUTTLOC(DUZ(2),0)),U,7),RET=""
 I $L(ABBRV) D
 .S RET=$E($O(^AUPNPROB("AA",DFN,DUZ(2),""),-1),2,999)\1+1
 .S RET=ABBRV_"-"_$S(RET<1000:RET,1:"")
 Q
 ; Set priority
 ;  INP = Problem IEN ^ Problem Priority
SETPRI(RET,INP) ;EP
 N PRIEN,PRI,FDA,IEN,ADD
 S PRIEN=+INP
 S PRI=$P(INP,U,2)
 I 'PRIEN S RET=$$ERR^BGOUTL(1008) Q
 S IEN=$O(^BGOPROB("B",PRIEN,0))
 S FDA=$NA(FDA(90362.22,$S(IEN:IEN_",",1:"+1,")))
 S @FDA@(.01)="`"_PRIEN
 S @FDA@(.02)=PRI
 S RET=$$UPDATE^BGOUTL(.FDA,"E",.ADD)
 I 'RET,'IEN S IEN=ADD(1)
 S:'RET RET=IEN
 Q
 ; Get problem entries for a patient
 ;  DFN = Patient IEN
 ;  Returns a list of records in the format:
 ;   Number Code [1] ^ Patient IEN [2] ^ ICD Code [3] ^ Modify Date [4] ^ Class [5] ^ Provider Narrative [6] ^
 ;   Date Entered [7] ^ Status [8] ^ Date Onset [9] ^ Problem IEN [10] ^ Notes [11] ^ ICD9 IEN [12] ^
 ;   ICD9 Short Name [13] ^ Provider [14] ^ Facility IEN [15] ^ Priority [16] ^ Classification [17]
GET(RET,DFN) ;EP
 N REC,CNT,PRIEN,NOTES,POVIEN,ICD,ICDNAME,MODDT,CLS,FAC,FACIEN,FACAB
 N PNAR,DENT,NMBCOD,STAT,ONSET,PRI,CLASS,PRV,ARRAY,PHXCNT
 S RET=$$TMPGBL^BGOUTL
 S (CNT,PRIEN)=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .S REC=$G(^AUPNPROB(PRIEN,0))
 .Q:$P(REC,U,2)'=DFN
 .D NOTES^BGOPRBN(.NOTES,PRIEN,0)
 .S POVIEN=$P(REC,U)
 .Q:POVIEN=""
 .S ICD=$P($G(^ICD9(POVIEN,0)),U)
 .S ICDNAME=$P($G(^ICD9(POVIEN,0)),U,3)
 .Q:ICD=""
 .S MODDT=$$FMTDATE^BGOUTL($P(REC,U,3))
 .S CLS=$P(REC,U,4)
 .S:CLS="" CLS="U"
 .I CLS="P" S ARRAY(ICD)=""
 .S PNAR=+$P(REC,U,5)
 .Q:'PNAR
 .S PNAR=$TR($P($G(^AUTNPOV(PNAR,0)),U),$C(13,10))
 .Q:PNAR=""
 .S FACIEN=+$P(REC,U,6)
 .S FACAB=$P($G(^AUTTLOC(FACIEN,0)),U,7),FAC=$P($G(^(0)),U,10)
 .I $G(DUZ("AG"))'="I" S:'$L(FAC) FAC=999999   ;P6
 .Q:FAC'?6N
 .S NMBCOD=$P(REC,U,7)
 .Q:'NMBCOD
 .S:$L(FACAB) NMBCOD=FACAB_"-"_NMBCOD
 .S PRV=$P($G(^AUPNPROB(PRIEN,1)),U,4)
 .S:PRV PRV=$P($G(^VA(200,+PRV,0)),U)
 .S DENT=$$FMTDATE^BGOUTL($P(REC,U,8))
 .S STAT=$P(REC,U,12)
 .;MSC/IHS/MSC No longer display deleted problems
 .Q:STAT="D"
 .S CLASS=$P(REC,U,15)
 .I CLASS'="" D
 .S CLASS=$S(CLASS=1:"INTERMITTENT",CLASS=2:"MILD PERSISTENT",CLASS=3:"MODERATE PERSISTENT",CLASS=4:"SEVERE PERSISTENT",1:"")
 .S ONSET=$$FMTDATE^BGOUTL($P(REC,U,13))
 .S PRI=$O(^BGOPROB("B",PRIEN,0))
 .S:PRI PRI=$P($G(^BGOPROB(PRI,0)),U,2)
 .S CNT=CNT+1
 .S @RET@(CNT)=NMBCOD_U_DFN_U_ICD_U_MODDT_U_CLS_U_PNAR_U_DENT_U_STAT_U_ONSET_U_PRIEN_U_NOTES_U_POVIEN_U_ICDNAME_U_PRV_U_FACIEN_U_PRI_U_CLASS
 ;Find the personal history items from the personal history file
 S FNUM=9000013
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:'$L(GBL) RET  ;P8
 S IEN=0,PHXCNT=9000
 F  S IEN=$O(@GBL@("AC",DFN,IEN)) Q:'IEN  D  Q:RET
 .S X=$G(@GBL@(IEN,0)),POVIEN=$P(X,U,1)
 .S ICD=$P($G(^ICD9(POVIEN,0)),U)
 .Q:$D(ARRAY(ICD))
 .S ICDNAME=$P($G(^ICD9(POVIEN,0)),U,3)
 .S DMOD=$$FMTDATE^BGOUTL($P(X,U,3))
 .S DFN=$P(X,U,2),PNAR=$P(X,U,4),ONSET=$$FMTDATE^BGOUTL($P(X,U,5))
 .S PNAR=$TR($P($G(^AUTNPOV(PNAR,0)),U),$C(13,10))
 .S CNT=CNT+1,PHXCNT=PHXCNT+1
 .S @RET@(CNT)=PHXCNT_U_DFN_U_ICD_U_DMOD_U_"P"_U_PNAR_U_DMOD_U_""_U_ONSET_U_IEN
 Q RET
 ; Delete a problem entry
 ;  PRIEN = Problem IEN ^ TYPE ^ DELETE REASON ^ OTHER^PROB ID
DEL(RET,PRIEN) ;EP
 N FPIEN,FPNUM,ZN,REASON,CMMT,IENS,IEN2
 I $P(PRIEN,U,2)="P"&(+$P(PRIEN,U,5)>8999) D
 .S PRIEN=$P(PRIEN,U,1)
 .S FPNUM=9000013
 .S RET=$$DELETE^BGOUTL(FPNUM,PRIEN)
 E  D
 .S IENS=$P(PRIEN,U,1)
 .S REASON=$P(PRIEN,U,3),CMMT=$P(PRIEN,U,4)
 .S ZN=$G(^AUPNPROB(IENS,0)),RET=""
 .Q:ZN=""
 .S FPIEN=$$FNDFP(IENS,.FPNUM)
 .S FNUM=$$FNUM
 .S IEN2=IENS_","
 .S FDA=$NA(FDA(FNUM,IEN2))
 .S @FDA@(.12)="D"
 .S @FDA@(2.01)=DUZ
 .S @FDA@(2.02)=$$NOW^XLFDT()
 .S @FDA@(2.03)=REASON
 .S @FDA@(2.04)=CMMT
 .S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 .;S RET=$$DELETE^BGOUTL("^AUPNPROB(",PRIEN)
 .I 'RET D EVT(IENS,2,ZN)
 .I 'RET,FPIEN S RET=$$DELETE^BGOUTL(FPNUM,FPIEN)
 Q
 ; Add/edit a problem entry
 ;  INP = ICD IEN or Code [1] ^ Narrative [2] ^ Location IEN [3] ^ Date of Onset [4] ^ Class [5] ^
 ;        Status [6] ^ Patient IEN [7] ^ Problem IEN [8] ^ Problem # [9] ^ Priority [10] ^ Classification [11]
SET(RET,INP) ;EP
 N CLASS,DFN,DIEN,ONSET,NARR,LIEN,STAT,PRNUM,PRIEN,LOCN,DMOD,DENT
 N FDA,IEN,FPNUM,FPIEN,FNUM,IENS,PRNEW,PRIOR,ACL,ASTHMA
 S FNUM=$$FNUM,RET=""
 S DIEN=$P(INP,U)
 S NARR=$P(INP,U,2)
 S LIEN=$P(INP,U,3)
 S ONSET=$$CVTDATE^BGOUTL($P(INP,U,4))
 S CLASS=$P(INP,U,5)
 I CLASS="P"&(DUZ("AG")'="I") S CLASS="I"
 S STAT=$P(INP,U,6)
 S DFN=$P(INP,U,7)
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 S PRIEN=$P(INP,U,8)
 S PRNUM=$P(INP,U,9)
 S PRNEW='PRIEN
 S PRIOR=$P(INP,U,10)
 S ACL=$P(INP,U,11)
 S:DIEN="" DIEN=".9999"
 S:DIEN["." DIEN=+$O(^ICD9("AB",DIEN_$S($$CSVACT^BGOUTL2():" ",1:""),0))
 I 'DIEN S RET=$$ERR^BGOUTL(1048) Q
 S DMOD=DT,DENT=$S(PRIEN:"",1:DT)
 I 'LIEN S RET=$$ERR^BGOUTL(1049) Q
 S NARR=$TR(NARR,$C(13,10)_U)
 I $L(NARR) D  Q:RET
 .S RET=$$FNDNARR^BGOUTL2(NARR)
 .S:RET>0 NARR=RET,RET=""
 I PRNUM>8999&(DUZ("AG")="I") S RET=$$EDITFP(PRIEN,DIEN,DFN,NARR,ONSET) Q RET
 S FPIEN=""
 I PRIEN D
 .I DUZ("AG")="I" S FPIEN=$$FNDFP(PRIEN,.FPNUM)
 .S IENS=PRIEN_","
 E  D
 .S:'PRNUM PRNUM=1+$E($O(^AUPNPROB("AA",DFN,LIEN,""),-1),2,99)
 .S (FPIEN,FPNUM)=""
 .S IENS="+1,"
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.01)=DIEN
 S:PRNEW @FDA@(.02)=DFN
 S @FDA@(.03)=DMOD
 S @FDA@(.04)=$S($L(CLASS):CLASS,1:"@")
 S @FDA@(.05)=$S(NARR:NARR,1:"@")
 S:PRNEW @FDA@(.06)=LIEN
 S:PRNUM @FDA@(.07)=PRNUM
 S:PRNEW @FDA@(.08)=DENT
 S @FDA@(.12)=STAT
 S @FDA@(.13)=ONSET
 S @FDA@(1.04)=DUZ
 I DUZ("AG")="I" D
 . S ASTHMA=$$CHECK^BGOASLK(DIEN)
 . I ASTHMA=0 S @FDA@(.15)="@"
 . I ASTHMA=1 D
 ..S ACL=$S(ACL="INTERMITTENT":1,ACL="MILD PERSISTENT":2,ACL="MODERATE PERSISTENT":3,ACL="SEVERE PERSISTENT":4,1:"")
 ..S @FDA@(.15)=ACL
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q:RET
 S:'PRIEN PRIEN=IEN(1)
 D SETPRI(,PRIEN_U_PRIOR)
 S:FPIEN RET=$$DELETE^BGOUTL(FPNUM,FPIEN)
 S:'RET&(DUZ("AG")="I") RET=$$SETFP(PRIEN)
 S:'RET RET=PRIEN
 ;Patch 6 check to see if its an asthma diagnosis
 I DUZ("AG")="I" D
 . I ASTHMA=1&(ACL="") S RET=RET_U_ASTHMA
 D:RET>0 EVT(PRIEN,'PRNEW)
 Q
 ; Broadcast a problem event
EVT(PRIEN,OPR,X) ;EP
 N DFN,DATA
 S:'$D(X) X=$G(^AUPNPROB(PRIEN,0))
 S DFN=$P(X,U,2),DATA=PRIEN_U_$G(CIA("UID"))_U_OPR
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_".PRB",DATA)
 Q
 ; Add/edit entry family/personal history corresponding to problem entry
 ;MSC/IHS/MGH Patch 6 family history has been removed from problem entry
SETFP(PRIEN) ;
 N FDA,DIEN,DFN,DMOD,NIEN,ONSET,FNUM,X
 S X=$G(^AUPNPROB(PRIEN,0)),DIEN=+X,DFN=$P(X,U,2),DMOD=$P(X,U,3),CLASS=$P(X,U,4),NIEN=$P(X,U,5),ONSET=$P(X,U,13)
 S FNUM=$S(CLASS="P":9000013,1:0)
 Q:'FNUM ""
 S FDA=$NA(FDA(FNUM,"+1,"))
 S @FDA@(.01)=DIEN
 S @FDA@(.02)=DFN
 S @FDA@(.03)=DMOD
 S @FDA@(.04)=NIEN
 S:CLASS="P" @FDA@(.05)=ONSET
 Q $$UPDATE^BGOUTL(.FDA)
 ; Find family/personal history entry associated with problem
 ;MSC/IHS/MGH Family history removedin patch 6
FNDFP(PRIEN,FNUM) ;
 N DFN,CLASS,DIEN,NIEN,DMOD,GBL,IEN,RET,X
 S X=$G(^AUPNPROB(PRIEN,0)),DIEN=+X,DFN=$P(X,U,2),DMOD=$P(X,U,3),CLASS=$P(X,U,4),NIEN=$P(X,U,5)
 S FNUM=$S(CLASS="P":9000013,1:0)
 Q:'FNUM ""
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:'$L(GBL) ""  ;P8
 S IEN=0,RET=""
 F  S IEN=$O(@GBL@("AC",DFN,IEN)) Q:'IEN  D  Q:RET
 .S X=$G(@GBL@(IEN,0))
 .I +X=DIEN,$P(X,U,2)=DFN,$P(X,U,3)\1=DMOD,$P(X,U,4)=NIEN S RET=IEN
 Q RET
EDITFP(PRIEN,DIEN,DFN,NIEN,ONSET) ;EP
 S FNUM=9000013
 Q:'FNUM ""
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:'$L(GBL) ""  ;P8 IHS/MSC/MGH
 S FDA=$NA(FDA(FNUM,PRIEN_","))
 S:DIEN="" DIEN=".9999"
 S @FDA@(.01)=DIEN
 S @FDA@(.02)=DFN
 S @FDA@(.04)=NIEN
 S @FDA@(.05)=ONSET
 S RET=$$UPDATE^BGOUTL(.FDA)
 I RET="" S RET=PRIEN
 Q RET
 ; Return file number
FNUM() Q 9000011
