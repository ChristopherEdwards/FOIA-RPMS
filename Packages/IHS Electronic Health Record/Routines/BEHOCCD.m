BEHOCCD ;IHS/MSC/MGH - CCD calls ;31-Mar-2014 17:45;PLS
 ;;1.1;BEH COMPONENTS;**067001**;March 12, 2008;Build 1
 ;=================================================================
PHR(RET,DFN) ;Returns if pt has an active PHR
 N PHN,PHNDT
 S RET=0
 S PHNDT="" S PHNDT=$O(^AUPNPAT(DFN,88,"ACT",$C(0)),-1) Q:PHNDT=""  D
 .S PHN=""  S PHN=$O(^AUPNPAT(DFN,88,"ACT",PHNDT,PHN)) Q:PHN=""  D
 ..S RET=PHN_U_$$FMTDATE^BGOUTL(PHNDT)
 Q
 ;========================================
 ;Input
 ;DFN= IEN of patient
 ;VIEN=Array of visit IENs
 ;TYPE  P=PHR,F=Fax,E=E-mail,N=Print,R=Refusal
 ;CCDT  T=Transition of care,C=Clinical Summary
 ;RRIEN Referral IEN if its a TOC doc
 ;DOCID Document ID
STORESN(RET,DFN,VIEN,TYPE,CCDT,RRIEN,DOCID) ;Store SNOMED medication
 N EDU,SUB,SUBTYP,TOPIEN,X,VST,LIST
 S RET=0
 I '+DFN  Q "-1^Patient not defined"
 S TYPE=$G(TYPE),CCDT=$G(CCDT),DOCID=$G(DOCID),RRIEN=$G(RRIEN)
 I CCDT="T" D TOC(.RET,DFN,.VIEN,TYPE,RRIEN,DOCID) Q
 I TYPE="R" D REFUSAL(.RET,DFN) Q
 I TYPE="P" D
 .;Store education
 .S I="" F  S I=$O(VIEN(I)) Q:I=""  D
 ..S VST=$G(VIEN(I))
 ..S EDU=422735006,SUB="HOME MANAGEMENT"
 ..D EDU(.RET,EDU,SUB,VST)
 I TYPE="N" D
 .;Store education
 .S I="" F  S I=$O(VIEN(I)) Q:I=""  D
 ..S VST=$G(VIEN(I))
 ..S LIST(I+1)=VIEN(I)_U_DOCID
 ..S EDU=422735006,SUB="LITERATURE"
 ..D EDU(.RET,EDU,SUB,VST)
 .S X=$$DL^APCCUTL(.LIST,$$NOW^XLFDT(),DUZ,1,"P")
 .S RET=RET_U_X
 Q
EDU(RET,TOP,SUB,VST) ;Store education
 N DATA,INP
 S DATA=""
 S SUBTYP=$O(^APCDEDCV("B",SUB,""))
 D SETDXTOP^BGOVPED(.TOPIEN,EDU_U_SUBTYP,2)
 Q:TOPIEN=""
 S INP=U_$P(TOPIEN,U,1)_U_DFN_U_VST_U_DUZ
 D SET^BGOVPED(.DATA,INP)
 I DATA="" S RET=1
 E  S RET=DATA
 Q
REFUSAL(RET,DFN) ;Enter the refusal item
 ;  INP = Refusal IEN [1] ^ Refusal Type [2] ^ Item IEN [3] ^ Patient IEN [4] ^
 ;        Refusal Date [5] ^ Comment [6] ^ Provider IEN [7] ^ Reason [8]
 N TYPE,DTDONE
 S TYPE="SNOMED"
 S EDU=422735006
 S DTDONE="TODAY",DTDONE=$$DT^CIAU(DTDONE)
 S INP=U_TYPE_U_EDU_U_DFN_U_DTDONE_U_U_DUZ_U_23
 D SET^BGOREF(.RET,INP)
 I RET="" S RET=1
 Q
TOC(RET,DFN,VIEN,TYPE,RRIEN,DOCID) ;Transition of care document
 N X,RR,I,DOCTYP,LIST,LTYPE
 S LTYPE=$S(TYPE="N":"P",1:TYPE)
 ;S DOCTYP=$S(TYPE="N":"CP",TYPE="F":"CF",1:"CT")
 S DOCTYP=$S(TYPE="E":"CT",1:"CP")
 S I="" F  S I=$O(VIEN(I)) Q:I=""  D
 .S LIST(I+1)=VIEN(I)_U_DOCID
 I +RRIEN=0 D
 .S X=$$DL^APCCUTL(.LIST,$$NOW^XLFDT(),DUZ,2,LTYPE)
 E  D
 .S X=$$DL^APCCUTL(.LIST,$$NOW^XLFDT(),DUZ,2,LTYPE)
 .;S RR="" S RR=$O(^BMCREF("C",RRIEN,RR))
 .;Q:'+RR
 .D CRENTOCD^BMCAPIS(.RET,RRIEN,$$NOW^XLFDT(),DUZ,DOCTYP,DOCID)
 .S RET=RET_U_X
 Q
GETREF(RSLT,VISITS) ;EP get referrals for visits
 ;Input parameter is array as per following format
 ;S VISITS(1)="3707743"
 ;S VISITS(2)="3601325"
 ;Output array
 ;"VISIT^RCIS REFERRAL IEN^PATIENT IEN^RCIS REFERRAL PURPOSE^RCIS REFERRAL STATUS^RCIS REFERRAL#^VENDOR FAX^VENDOR EMAIL PARTICIPANT YES NO^VENDOR EMAIL ADDRESS"
 N CNT,ARRAY
 S CNT="" F  S CNT=$O(VISITS(CNT)) Q:CNT=""  D
 .S ARRAY(CNT+1)=$G(VISITS(CNT))
 D GETREFFV^BMCAPIS(.RSLT,.ARRAY)
 Q
 ;
 ;Return access/verify codes for a user
 ; Input: IEN - DUZ of user
 ;        OPT - 0: default
 ;              1: returns encrypted (ENCRYP^XUSRB1) form of access_$C(9)_verify code string cached in BEHOCCD A_V CODES parameter
ACCESS(RET,IEN,OPT) ;EP
 N ACCESS,VERIFY
 S RET=""
 S OPT=$G(OPT,0)
 I 'OPT D
 .Q:IEN=""
 .I +IEN'=IEN S IEN=$O(^VA(200,"B",IEN,""))
 .Q:'IEN
 .S ACCESS=$$GET1^DIQ(200,IEN,2,"I")
 .S VERIFY=$$GET1^DIQ(200,IEN,11,"I")
 .S RET=ACCESS_$C(9)_VERIFY
 E  D
 .S RET=$$GET^XPAR("SYS","BEHOCCD MAG A_V CODES")
 Q
 ;Input
 ;Path and name of image
 ;IMAGES(1)=?\\image server\image share\filename.ext^image description?
 ;if image descrption is not sent in it will default to CCDS document
IMPORT(RET,DFN,IMAGE,VSTR,CRDT) ;Import an image to VI
 Q
 N MAGRY,IMAGES,MAGIX
 K RET
 S RET(0)=""
 I $P(IMAGE,U,2)="" S $P(IMAGE,U,2)="CCDS Document"
 S VIEN=$P(VSTR,";",4)
 I VIEN="" S RET="Error: Visit not sent"
 S IMAGES(1)=IMAGE
 S MAGIX("ACQD")="NETWORK COMPUTER"
 S MAGIX("ACQL")=$P(VSTR,";",1)
 S MAGIX("IDFN")=DFN
 S MAGIX("IXTYPE")="CCD-SUMMARY"
 S MAGIX("ITYPE")="XML"
 S MAGIX("ACQS")=DUZ(2)
 S MAGIX("STSCB")="CALLBK^BEHOCCD"
 S MAGIX("TRKID")="CCD;"_DFN_VIEN_CRDT
 D IMPORT^MAGGSIUI(.MAGRY,.IMAGES,.MAGIX)
 I +MAGRY(0) D
 .S RET(0)=$G(MAGRY(0))_U_MAGIX("TRKID")
 E  D
 .S X="" F  S X=$O(MAGRY(X)) Q:X=""  D
 ..S RET(X)=$G(MAGRY(X))
 Q
CALLBK(RESULT) ;call back for storage
 Q
 ;N X,STAT,TRACK,QUEUE
 ;S STAT=$P($G(RESULT(0)),U,1)
 ;Q:STAT=1  ;success
 ;I STAT=0!(STAT=2) D
 ;.S TRACK=$G(RESULT(1))
 ;.S QUEUE=$G(RESULT(2))
 ;.S X=$$STATUS^MAGQBUT3(QUEUE)
 ;.S XQA(DUZ)=""
 ;.S XQAMSG=X
 ;.S XQAID="BEHOCD"_","_DFN_","_99005
 ;.S XQADATA=
 ;.D SETUP^XQALERT
 ;Q
 ;Input parameters
 ;DFN=patient
 ;VENDOR=who the document is to go to
 ;FAX=Fax number of vendor
SNDALRT(RET,DFN,VENDOR,FAX) ;EP
 N MSG,XQAMSG,XQADATA,XQAID,XQATEXT,XQA,PRV,PT
 S RET=""
 S XQAMSG="CCDA ready for Fax"
 S XQAID="BEHOCD"_","_DFN_","_99005
 S XQADATA="DFN="_DFN
 S PT=$$GET1^DIQ(2,DFN,.01)
 S PRV=$$GET1^DIQ(200,DUZ,.01)
 S MSG="A CCDA has been stored today in Vista Imaging by "_PRV_" for "_PT_" to be sent to "_VENDOR_" at "_FAX
 S XQATEXT=MSG
 S XQA("G.BEHOCCD HIMS TOC")=""
 S RET=$$SETUP1^XQALERT
 Q
 ;
 ;
MAGAV ;support for capture and storage of a/v codes
 N AC,VC,USR,AE,VE,AH,VH,AEVE
 ;Select user for comparison
 S USR=$$GETIEN1(200,"Select CCDA VistA Imaging user: ",-1,"B")
 Q:USR<0
 ;Prompt for access/verify codes
 S AC=$$PROMPT("Access Code: ")
 Q:AC[U
 S AH=$$EN^XUSHSH($$UP^XLFSTR(AC))
 I AH'=$P($G(^VA(200,USR,0)),U,3) D  Q
 .W !,"Entered access code does not match selected user."
 S VC=$$PROMPT("Verify Code: ")
 Q:VC[U
 ; Compare a/v codes to selected user
 S VH=$$EN^XUSHSH($$UP^XLFSTR(VC))
 I VH'=$P($G(^VA(200,USR,.1)),U,2) D  Q
 .W !,"Entered verified code does not match selected user."
 S AEVE=$$ENCRYP^XUSRB1(AC)_$C(9)_$$ENCRYP^XUSRB1(VC)
 ;Store string in parameter
 W !,"Storing value..."
 D PUT^XPAR("SYS","BEHOCCD MAG A_V CODES",,AEVE,.ERR)
 Q
 ;
PROMPT(LABEL) ;
 N VAL
 X ^%ZOSF("EOFF")
 W !,LABEL S VAL=$$ACCEPT^XUS()
 X ^%ZOSF("EON")
 Q VAL
 ;
 ; Prompt for entry from file
 ; BEHOFILE = File #
 ; BEHOPMPT = Prompt
 ; BEHODFLD = Field whose value is to be used for default value
 ;          Set to -1 for no default value
 ; D - x-ref (C^D)
 ; BEHOSCRN = DIC("S") SCREEN LOGIC
 ; BEHODFLT = Default value set in DIC("B") - not used if BEHODFLD is >0
GETIEN1(BEHOFILE,BEHOPMPT,BEHODFLD,D,BEHOSCRN,BEHODFLT) ; EP
 N DIC,BEHOD,Y
 S D=$G(D,"B")
 S:'$L(D) D="B"
 S BEHODFLD=$G(BEHODFLD,.01)
 S BEHOD=""
 S DIC("S")=$G(BEHOSCRN)
 S:BEHODFLD>0 BEHOD=$$GET1^DIQ(BEHOFILE,$$FIND1^DIC(BEHOFILE,,," ",.D,DIC("S")),BEHODFLD)
 I BEHODFLD<0,$L($G(BEHODFLT)) S BEHOD=BEHODFLT
 S DIC=BEHOFILE,DIC(0)="AE",DIC("A")=$G(BEHOPMPT),DIC("B")=BEHOD
 I $L(D,U)>1,DIC(0)'["M" S DIC(0)=DIC(0)_"M"
 D MIX^DIC1
 I $D(DUOUT)!($D(DTOUT)) S BEHOPOP=-1
 E  I Y'>0 S BEHOPOP=1,$P(BEHOPOP,U,2)=X="@"
 Q +Y
 ;
 ;Set prohibit editing field of parameter
LOCK(PARAM,VAL) ;EP-
 N IEN
 S IEN=$O(^XTV(8989.51,"B",PARAM,0))
 Q:'IEN
 S $P(^XTV(8989.51,IEN,0),U,6)=VAL
 Q
