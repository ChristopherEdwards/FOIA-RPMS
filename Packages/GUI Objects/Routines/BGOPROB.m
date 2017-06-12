BGOPROB ; IHS/BAO/TMD - pull patient PROBLEMS ;24-Jun-2016 13:00;du
 ;;1.1;BGO COMPONENTS;**1,3,6,7,8,10,11,13,14,15,19,20,21**;Mar 20, 2007;Build 3
 ;---------------------------------------------
 ; Check for existence of problem id
 ;  INP = Patient IEN ^ Problem ID ^ Site IEN ^ Problem IEN (optional)
 ; Patch 6 removed references to family history since they are in separate components
 ; Patch 6 also added ability to view and add classification for ashtma dx
 ; Patch 8 changes - problems are now logically deleted
 ; Patch 12 changes for AICD
 ; Patch 13 - changes were made now for SNOMED and Integrated problem list
 ;            most sections have been radically changed
 ; Patch 20 - laterality added,routine status added
 ; Patch 21 - V OB note added
CKID(RET,INP) ;EP
 D CKID^BGOPROB1(.RET,INP)
 Q
 ; Return next problem id
 ;  DFN = Patient IEN
 ; .RET = Problem ID
NEXTID(RET,DFN) ;EP
 D NEXTID^BGOPROB1(.RET,DFN)
 Q
 ; Set priority
 ;  INP = Problem IEN ^ Problem Priority
SETPRI(RET,INP) ;EP
 D SETPRI^BGOPROB1(.RET,INP)
 Q
 ; Get problem entries for a patient
 ;  DFN = Patient IEN
 ;  TYP=  A(chronic),S(sub-acute),E(episodic),O(social/environmental),I(Inactive)
 ;        If not sent, all active codes will be returned
 ;  CPTYP= A  All
 ;         C  Active
 ;         L  Last date
 ;  NUM = Number of entries in V files to return
 ;  ACT = Flag to indicate if care planning activities should be included
 ;-------------------------------------------------------------------------
 ;Array(n)="P" [1] ^ Problem Ien [2] ^ SNOMED CONCEPT ID [3] ^ SNOMED DESC ID[4] ^Number code [5] ^ Status [6]^ Onset [7] ^ Prov Narrative [8] ^ ICD [9] ^ Priority [10] ^ Class [11] ^ PIP [12] ^ Additional ICD [13]
 ;                 ^ inpt DX [14] ^ Outpt DX [15] ^ Ever used as POV [16] ^ Asthma DX [17] ^ Needs norm/abn [18] ^ Laterality flag [19] ^ Laterality [20]
 ;Array(n)="P1" [1] ^ Frequency [2] ^ Eye dx [3] ^last used as INPT [4]
 ;Array(n)="A" [1] ^ Classification [2] ^ Control [3] ^ V asthma IEN [4]
 ;Array(n)="N" [1] ^ Facility [2] ^ Note IEN [3] ^ Note Nmbr [4] ^ Text [5] ^ Status [6] ^ Date [7] ^ Author [8]
 ;Array(n)= "Q" [1] ^ TYPE [2] ^ IEN [3] ^ SNOMED [4] ^ Text [5]
 ;The problems are followed by the goals, pt.instructions, visit instructions and activities
 ;Array(n)=Type (G OR C) [1] ^ C Plan IEN [2] ^ Prob IEN [4] ^ Who entered [4] ^ Date Entered [5] ^ Status [6] ^ SIGN FLAG [7]
 ;          =~t [1] ^ Text of the item [2]
 ;Array(n)="I" [1] ^ Instr IEN[2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^ Visit IEN [9] ^V cat [10] ^ Locked [11] ^ Prov Name [12] ^ signed [13]
 ;          =~t [1] ^Text of the item [2]
 ;Array(n)="O" [1] ^ OB IEN [2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^Visit IEN [9] ^ V Cat [10] ^ ^ Locked [11] ^ Prov Name [12] ^ signed [13]
 ;        =~t [1] ^Text of the item [2]
 ;Array(n)="T" [1] ^ TR IEN[2] ^ SNOMED term [3] ^ Prob IEN  [4] ^ Vst Date [5] ^ Facility [6] ^ Prv IEN [7] ^ Location [8] ^ Entered Dt [9] ^ Visit IEN [10] ^ V Cat [11] ^Locked [12] ^ Prov name [13]
 ;Array(n)="S" [1] ^ SERVICE [2] ^Consult Date [3] ^ STAT [4]
 ;Array(n)="R" [1] ^ REFERRAL [2] ^ Referral Date [3] ^ Status [4]
 ;Array(n)="E" [1] ^ Topic [2] ^ Date [3]
GET(RET,DFN,TYP,CPTYP,NUM,ACT) ;EP
 N PRIEN,CNT,PER
 S PER=""
 ; Default values if not passed in
 I $G(TYP)="" S TYP="ASEOR"
 I $G(CPTYP)="" S CPTYP="L"
 ;For Visit instructions and treatments, the default is the latest visit
 I $G(NUM)="" S NUM=1
 S ACT=$G(ACT)
 S RET=$$TMPGBL^BGOUTL
 S (PRIEN,CNT)=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .D GET2(.RET,PRIEN,DFN,TYP,CPTYP,NUM,ACT,PER)
 Q
GET2(RET,PRIEN,DFN,TYP,CPTYP,NUM,ACT,PER,ONE) ;Get information for one problem
 N REC,NOTES,POVIEN,ICD,ICDNAME,MODDT,CLS,FAC,FACIEN,FACAB,PIP,INPT,INPTDX,OUTPT,OUTPTDX
 N PNAR,DENT,NMBCOD,STAT,ONSET,PRI,CLASS,PRV,ARRAY,PHXCNT,SNOMED,I,EVNDT,NORMAL,FLTR
 N CONCT,DESCT,CT,CT2,PTEXT,REC8,IN,OUT,ARR,STAT2,XICD,POVEVER,ASM,VIEN,INJSTR,DEFST
 I '$D(CNT) S CNT=0
 S PER=$G(PER),ONE=$G(ONE)
 S (INPTDX,OUTPTDX)="",POVEVER=0
 S REC=$G(^AUPNPROB(PRIEN,0))
 S REC8=$G(^AUPNPROB(PRIEN,800))
 Q:$P(REC,U,2)'=DFN
 S POVIEN=$P(REC,U)
 Q:POVIEN=""
 ;IHS/MSC/MGH Patch 12 changes
 S EVNDT=$$FMTDATE^BGOUTL($P($G(^AUPNPROB(PRIEN,0)),U,8))
 S ICD=$P($$ICDDX^ICDEX(POVIEN,EVNDT,"","I"),U,2)
 Q:ICD=""
 ;Check for which statuses to return
 S STAT=$P(REC,U,12)
 Q:STAT="D"
 ;Q:TYP'[STAT
 I STAT="" S STAT="I"
 I STAT'="I",TYP'[STAT Q  ;P20 Inactive/Phx Handled Below
 S STAT2=$$GET1^DIQ(9000011,PRIEN,.12)
 S CONCT=$P(REC8,U,1)
 S DESCT=$P(REC8,U,2)
 ;MSC/MGH Patch 20
 S DEFST=""
 I ONE=1 D
 .S SNODATA=$$CONC^AUPNSICD(CONCT_"^^^1")
 .S DEFST=$P(SNODATA,U,9)
 .I STAT="I"&(DEFST="") S DEFST="Episodic"
 S CLS=$P(REC,U,4)
 S:CLS="" CLS="U"
 ;Q:'+ONE&(STAT="I")&(((CLS'="P")&(PER="P"))!((CLS="P")&(PER'="P")))   ;P20
 S FLTR=0 D  Q:FLTR
 . I +ONE Q  ;Requested specific problem
 . I STAT'="I" Q  ;Not inactive or PHx
 . I CLS'="P",TYP'["I" S FLTR=1 Q  ;Inactive, but don't want
 . I CLS="P",TYP'["P" S FLTR=1 Q  ;PHx, but don't want
 I CLS="P" S ARRAY(ICD)=""
 S PNAR=$$GET1^DIQ(9000011,PRIEN,.05)
 Q:PNAR=""
 S FACIEN=+$P(REC,U,6)
 S FACAB=$P($G(^AUTTLOC(FACIEN,0)),U,7),FAC=$P($G(^(0)),U,10)
 I $G(DUZ("AG"))'="I" S:'$L(FAC) FAC=999999   ;P6
 Q:FAC'?6N
 S NMBCOD=$P(REC,U,7)
 Q:'NMBCOD
 I FACAB="" S FACAB="ZZZZ"
 S:$L(FACAB) NMBCOD=FACAB_"-"_NMBCOD
 S PRV=$P($G(^AUPNPROB(PRIEN,1)),U,4)
 S:PRV PRV=$P($G(^VA(200,+PRV,0)),U)
 S ONSET=$$FMTDATE^BGOUTL($P(REC,U,13))
 S PIP=$P($G(^AUPNPROB(PRIEN,0)),U,19)
 S PRI=$O(^BGOPROB("B",PRIEN,0))
 S:PRI PRI=$P($G(^BGOPROB(PRI,0)),U,2)
 S XICD=$$ADDICD^BGOPROB1(PRIEN)
 N X,VAR
 S POVEVER=$$USED^BGOPROB1(PRIEN)   ;P14
 S VAR=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 S VIEN=""
 I VAR'="" D
 .S VIEN=$$VSTR2VIS^BEHOENCX(DFN,VAR)
 .Q:VIEN<1
 .I $P($G(^AUPNVSIT(VIEN,0)),U,7)="H"!($P($G(^AUPNVSIT(VIEN,0)),U,7)="O") D
 ..S INPT="" S INPT=$O(^AUPNPROB(PRIEN,15,"B",VIEN,INPT))
 ..I +INPT S INPTDX=1
 .E  D
 ..S OUTPT="" S OUTPT=$O(^AUPNPROB(PRIEN,14,"B",VIEN,OUTPT))
 ..I +OUTPT D
 ...N VPOV,FOUND
 ...S FOUND=0
 ...S VPOV=0 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:VPOV=""!(FOUND=1)  D
 ....I $P($G(^AUPNVPOV(VPOV,0)),U,16)=PRIEN D
 .....S OUTPTDX=VPOV
 .....S FOUND=1
 S NORMAL=""
 I DESCT'="" D QUALLK^BGOVPOV1(.NORMAL,DESCT,"N")
 S ASM=""
 D CHKASM^BGOASLK(.ASM,ICD,DESCT)
 S LAT=$$LAT^BGOPROB1(PRIEN)  ;IHS/MSC/MGH Patch 20 for laterality
 S CNT=CNT+1
 ;S @RET@(CNT)=NMBCOD_U_DFN_U_ICD_U_MODDT_U_CLS_U_PNAR_U_DENT_U_STAT_U_ONSET_U_PRIEN_U_NOTES_U_POVIEN_U_ICDNAME_U_PRV_U_FACIEN_U_PRI_U_CLASS
 S @RET@(CNT)="P"_U_PRIEN_U_CONCT_U_DESCT_U_NMBCOD_U_STAT2_U_ONSET_U_PNAR_U_ICD_U_PRI_U_CLS_U_PIP_U_XICD_U_INPTDX_U_OUTPTDX_U_POVEVER_U_ASM_U_NORMAL_U_LAT_U_DEFST
 ;Patch 20 added for sorting
 D P1^BGOPROB2(.RET,.CNT,DFN,PRIEN,DESCT)
 ;Return qualifiers for this problem
 N QUAL,QNODE,SNO,TXT,X,QPRV
 S TXT=""
 N YQ,Z
 F YQ=13,17,18 D
 .S QUAL=1 F  S QUAL=$O(^AUPNPROB(PRIEN,YQ,QUAL)) Q:'+QUAL  D
 ..S CNT=CNT+1
 ..S QNODE=$G(^AUPNPROB(PRIEN,YQ,QUAL,0))
 ..S SNO=$P(QNODE,U,1)
 ..S X=$$CONC^BSTSAPI(SNO_"^^^1")
 ..I $P(X,U,1)'="" S TXT=$P(X,U,4)
 ..S Z=$S(YQ=13:"S",YQ=17:"F",YQ=18:"C")
 ..S QPRV=$P(QNODE,U,2)
 ..I QPRV'="" S QPRV=$P($G(^VA(200,QPRV,0)),U)
 ..;S @RET@(CNT)="Q"_U_Z_U_QUAL_U_SNO_U_TXT_U_$P(QNODE,U,2)_U_$P(QNODE,U,3)
 ..S @RET@(CNT)="Q"_U_Z_U_QUAL_U_SNO_U_TXT_U_QPRV_U_$$FMTDATE^BGOUTL($P(QNODE,U,3))
 ;IHS/MSC/MGH Patch 15 moved to new routine
 ;Get the asthm control information
 S CONTROL=$$CLASS^BGOPROB2(REC,DFN,ASM)
 I CONTROL'="" D
 .S CNT=CNT+1
 .S @RET@(CNT)=CONTROL
 ;Return notes for this problem
 S NOTES=""
 D NOTES^BGOPRBN(.NOTES,PRIEN,1)
 S I="" F  S I=$O(NOTES(I)) Q:I=""  D
 .S CNT=CNT+1
 .S @RET@(CNT)="N"_U_$G(NOTES(I))
 S INJSTR=$$INJCHK^BGOPROB2(PRIEN,VIEN)
 I INJSTR'="" D
 .S CNT=CNT+1
 .S @RET@(CNT)=INJSTR
 ;Return goals, care plans, visit instructions and treatments, consults, referrals and education topics
 I +ACT>0 D
 .D GET^BGOCPLAN(.RET,PRIEN,DFN,"G",CPTYP,.CNT)
 .D GET^BGOCPLAN(.RET,PRIEN,DFN,"P",CPTYP,.CNT)
 .D GET^BGOVVI(.RET,DFN,PRIEN,NUM,.CNT)
 .D GET^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 .I ACT=2 D GET^BGOVOB(.RET,DFN,PRIEN,NUM,.CNT)
 .D GETCON^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 .D GETREF^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 .D GETEDU^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 Q
 ; Delete a problem entry
 ;  PRIEN = Problem IEN ^ TYPE ^ DELETE REASON ^ OTHER^PROB ID
DEL(RET,PRIEN) ;EP
 D DEL^BGOPROB3(.RET,PRIEN)
 Q
 ; Add a problem entry
 ;  DFN   = Patient IEN
 ;  PRIEN = IEN of problem, null if new
 ;  VIEN  = Needed if asthma DX
 ;  List(n)
 ;        "P"[1] ^ SNOMED CT [2] ^ Descriptive CT [3] ^ Provider text [4] ^ Mapped ICD [5]
 ;        ^ Location [6] ^ Date of Onset [7] ^ Status [8] ^ Class [9] ^ Problem # [10] ^ Priority [11]
 ;        ^ INP DX [12] ^ Laterality codes [13]
 ;        "A"[1] ^ Classification [2] ^ Control [3] ^ V asthma IEN [4]
 ;        "Q"[1] ^ TYPE [2] ^ Qualifier IEN [3] ^ Qual SNOMED [4] ^ By [5] ^ When [6] ^ Delete [7]
 ; SPEC  = Special conditions
 ; PIP   = Prenatal Problem sent from PIP
SET(RET,DFN,PRIEN,VIEN,ARRAY,SPEC,PIP) ;EP
 N CLASS,DIEN,ONSET,NARR,LIEN,PRNUM,LOCN,DMOD,DENT,VAPR,INP,INPT,SNODATA
 N FDA,IEN,FPNUM,FPIEN,FNUM,IENS,PRNEW,PRIOR,SNOCT,DESCT,XIEN,ERR,IMP,INDIEN
 S SPEC=$G(SPEC),PIP=$G(PIP)
 S FNUM=$$FNUM,RET="",ERR=0
 S (DIEN,SNOCT)=""
 S PRIEN=$G(PRIEN),VIEN=$G(VIEN)
 S XIEN="" F  S XIEN=$O(ARRAY(XIEN)) Q:XIEN=""!(ERR=1)  D
 .S INP=$G(ARRAY(XIEN))
 .I $P(ARRAY(XIEN),U,1)="P" D PROB(.RET,INP,SPEC,PIP)
 .I $P(ARRAY(XIEN),U,1)="A" D ASTHMA(.RET,VIEN,INP,DIEN,DESCT)
 .I $P(ARRAY(XIEN),U,1)="Q" D QUAL(.RET,INP)
 Q
PROB(RET,INP,SPEC,PIP) ;PROBLEM DATA
 N X,INDIEN,LAT,LATEXT
 S INDIEN=$P($P(INP,U,5),"|",1)
 S NARR=$P(INP,U,4)
 S NARR=$TR(NARR,"^|","")
 S LIEN=$P(INP,U,6)
 S ONSET=$$CVTDATE^BGOUTL($P(INP,U,7))
 S CLASS=$P(INP,U,9)
 S SNOCT=$P(INP,U,2)
 ; IHS/MSC/MGH changed to new API-P14
 ;S SNODATA=$$CONC^BSTSAPI(SNOCT_"^^^1")
 S SNODATA=$$CONC^AUPNSICD(SNOCT_"^^^1")
 ;IHS/MSC/MGH changed to handle special cases p14
 I +SPEC S DIEN=INDIEN
 E  S DIEN=$P($P(SNODATA,U,5),";",1)
 ;I ((DIEN="")!(DIEN=".9999")!(DIEN="ZZZ.999"))&(INDIEN'="") S DIEN=INDIEN
 I DIEN="" D
 .;Patch 14 check for which undefined code to use
 .S IMP=$$IMP^ICDEX("10D",DT)
 .I IMP'>$$NOW^XLFDT S DIEN="ZZZ.999"
 .I IMP>$$NOW^XLFDT S DIEN=".9999"
 I DIEN'["." S DIEN=DIEN_"."
 S DESCT=$P(INP,U,3)
 ;I CLASS="P"&(DUZ("AG")'="I") S CLASS="I"
 S STAT=$P(INP,U,8)
 ;MSC/MGH Store default status from lookup patch 20
 I STAT="" S STAT=$P(SNODATA,U,9)
 I STAT="" S STAT="Episodic"
 S STAT=$S(STAT="Chronic":"A",STAT="Inactive":"I",STAT="Sub-acute":"S",STAT="Episodic":"E",STAT="Social/Environmental":"O",STAT="Routine/Admin":"R",STAT="Admin":"R",1:"E")
 S VAPR=$S(STAT="A":"C",STAT="S":"C",STAT="O":"C",STAT="E":"A",STAT="R":"C",1:"")
 I '$D(^DPT(DFN,0)) S ERR=1,RET=$$ERR^BGOUTL(1001) Q
 S PRNUM=$P(INP,U,10)
 S PRNEW='PRIEN
 S PRIOR=$P(INP,U,11)
 S DIEN=$P($$ICDDX^ICDEX(DIEN,"","","E"),U,1)
 I 'DIEN S ERR=1,RET=$$ERR^BGOUTL(1048) Q
 ;IHS/MSC/MGH update date modified to include time
 S DMOD=$$NOW^XLFDT,DENT=$S(PRIEN:"",1:DT)
 I 'LIEN S ERR=1,RET=$$ERR^BGOUTL(1049) Q
 ;Provider narrative is now provider text | descriptive SNOMED CT
 ;Patch 20 provider narrative is now provider text | descriptive SNOMED CT | laterality
 S LAT=$P(INP,U,13)
 ;Do not store unspecified laterality
 I LAT="272741003|261665006"!(LAT="272741003|") S LAT=""
 I LAT'="" D
 .S LATEXT=$$CVPARM^BSTSMAP1("LAT",$P(LAT,"|",2))
 .S NARR=NARR_"|"_DESCT_"|"_LATEXT
 E  S NARR=NARR_"|"_DESCT
 I $L(NARR) D  Q:RET
 .S RET=$$FNDNARR^BGOUTL2(NARR)
 .S:RET>0 NARR=RET,RET=""
 S FPIEN=""
 I PRIEN D
 .S IENS=PRIEN_","
 E  D
 .S:'PRNUM PRNUM=1+$E($O(^AUPNPROB("AA",DFN,LIEN,""),-1),2,99)
 .S (FPIEN,FPNUM)=""
 .S IENS="+1,"
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.01)=DIEN
 S:PRNEW @FDA@(.02)=DFN
 S @FDA@(.03)=DMOD
 S @FDA@(.14)=DUZ
 I CLASS="P" S STAT="I"
 S @FDA@(.04)=$S($L(CLASS):CLASS,1:"@")
 S @FDA@(.05)=$S(NARR:NARR,1:"@")
 S:PRNEW @FDA@(.06)=LIEN
 S:PRNUM @FDA@(.07)=PRNUM
 S:PRNEW @FDA@(.08)=DENT
 S @FDA@(1.03)=DUZ
 S @FDA@(.12)=STAT
 S @FDA@(.13)=ONSET
 S:PRNEW @FDA@(1.04)=DUZ
 S @FDA@(1.14)=VAPR
 S @FDA@(80001)=SNOCT
 S @FDA@(80002)=DESCT
 I $P(LAT,"|",2)'="" S @FDA@(.22)=LAT         ;Patch 20
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q:RET
 S:'PRIEN PRIEN=IEN(1)
 D SETPRI(,PRIEN_U_PRIOR)
 ;IHS/MSC/MGH Set prenatal PIP if called from CVG Patch 20
 I +PIP D
 .I $$TEST^CIAUOS("SET^BJPNAPIS") S RET=$$SET^BJPNAPIS(PRIEN)  Q:RET  ;Set Prenatal PIP entry
 S:'RET RET=PRIEN
 D:RET>0 EVT(PRIEN,'PRNEW)
 N RES
 ;Set any extra ICD codes
 D SETICD^BGOPROB1(.RES,PRIEN,$P(SNODATA,U,5),";")
 ;Set inpt DX
 N RES1
 S INPT=$P(INP,U,12)
 I INPT=1 S RES1="" D HOSP^BGOHOS(.RES1,PRIEN,VIEN)
 ;S:FPIEN RET=$$DELETE^BGOUTL(FPNUM,FPIEN)
 ;S:'RET&(DUZ("AG")="I") RET=$$SETFP(PRIEN)
 Q
ASTHMA(RET,VIEN,INP,DIEN,SNOCT) ;ASTHMA DATA
 N ACL,ASTHMA,RET2,AIEN,CONTROL,RET3,INP2,IENS,CODE
 K FDA
 S FNUM=$$FNUM,RET2=""
 S IENS=PRIEN_","
 S FDA=$NA(FDA(FNUM,IENS))
 Q:'DFN
 Q:'PRIEN
 S ACL=$P(INP,U,2)
 Q:ACL=""
 I DUZ("AG")="I" D
 . S CODE=$$CODEC^ICDEX(80,DIEN)
 . S ASTHMA=$$CHECK^BGOASLK(CODE,DESCT)
 . I ASTHMA=0 S @FDA@(.15)="@"
 . I ASTHMA=1 D
 ..S ACL=$S(ACL="INTERMITTENT":1,ACL="MILD PERSISTENT":2,ACL="MODERATE PERSISTENT":3,ACL="SEVERE PERSISTENT":4,1:"")
 ..S @FDA@(.15)=ACL
 ..S RET2=$$UPDATE^BGOUTL(.FDA,,.IENS)
 ..I RET2 S ERR=1,RET=RET_U_"Error on Asthma Update"
 ..;Patch 6 check to see if its an asthma diagnosis
 ..I ASTHMA=1&(ACL="") S RET=RET_U_ASTHMA
 ..S CONTROL=$P(INP,U,3)
 ..S AIEN=$P(INP,U,4)
 ..I VIEN="" S ERR=1,RET=RET_U_"Visit not defined. Cannot store asthma data"
 ..I CONTROL="NONE RECORDED" S CONTROL=""
 ..I CONTROL'="" D
 ...S INP2=AIEN_U_VIEN_U_CONTROL
 ...D SET^BGOVAST(.RET3,INP2)
 ...I RET3 S RET=RET_U_RET3
 ...E  S RET=RET_U_"Unable to store V asthma data"
 Q
QUAL(RET,INP) ;QUALIFIERS
 D QUAL^BGOPROB1(.RET,INP)
 Q
 ; Broadcast a problem event
EVT(PRIEN,OPR,X) ;EP
 N DFN,DATA
 S:'$D(X) X=$G(^AUPNPROB(PRIEN,0))
 S DFN=$P(X,U,2),DATA=PRIEN_U_$G(CIA("UID"))_U_OPR
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_".PRB",DATA)
 Q
 ; Return file number
FNUM() Q 9000011
