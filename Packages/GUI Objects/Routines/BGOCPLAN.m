BGOCPLAN ; IHS/BAO/TMD - pull V Care Plan data ;27-Jan-2016 09:53;DU
 ;;1.1;BGO COMPONENTS;**13,14,17,19**;Mar 20, 2007;Build 5
 ;P14 changed to return time when entered
 ;---------------------------------------------
GET(DATA,IEN,DFN,TYPE,RETI,CNT,PRV) ;EP
 ;Find the latest number of entries for each section using the
 ;parameter and return them to the calling program
 ;Input is IEN = Problem
 ;         DFN = Patient
 ;        TYPE = G(oal) or C(are Plan)
 ;        RETI = Return types (A(active),C(complete),L(latest)
 ;         CNT = Count
 ;         PRV = Provider to look for data on
 ;Ouput: Array in the format
 ;Array(n)=Type (G OR C) [1] ^ C Plan IEN [2] ^ Prob IEN [4] ^ Who entered [4] ^ Date Entered [5] ^ Status [6] ^ SIGN FLAG [7]
 ;          =~t [1] ^ Text of the item [2]
 N GCNT,INVDT,NODE,FNUM,CODE,DONE,STA,STAT,SDATE,CPIEN,SIEN,SORT
 S DONE=0,SDATE=0
 I $G(RETI)="" S RETI="L"
 I $G(DATA)="" S DATA=$$TMPGBL
 I $G(CNT)="" S CNT=1
 S PRV=$G(PRV)
 I RETI="" S RETI="L"
 S INVDT=""
 S TYPE=$S(TYPE="C":"P",1:TYPE)
 I PRV'="" D
 .F  S INVDT=$O(^AUPNCPL("APTP",IEN,TYPE,PRV,INVDT)) Q:INVDT=""!(DONE=1)  D
 ..S CPIEN="" F  S CPIEN=$O(^AUPNCPL("APTP",IEN,TYPE,PRV,INVDT,CPIEN)) Q:CPIEN=""  D
 ...S SIEN=$C(0) S SIEN=$O(^AUPNCPL(CPIEN,11,SIEN),-1)
 ...S STATUS=$P($G(^AUPNCPL(CPIEN,11,SIEN,0)),U,1)
 ...Q:STATUS="E"
 ...Q:(STATUS="R")&(RETI'="C")
 ...S SORT(INVDT,CPIEN,SIEN)=""
 ...;D DATA(.DATA,CPIEN,SIEN)
 .D DATA(.DATA,.SORT)
 I PRV="" D
 .S CPIEN="" F  S CPIEN=$O(^AUPNCPL("APT",IEN,TYPE,CPIEN)) Q:CPIEN=""!(DONE=1)  D
 ..S SIEN=$C(0) S SIEN=$O(^AUPNCPL(CPIEN,11,SIEN),-1)
 ..S STATUS=$P($G(^AUPNCPL(CPIEN,11,SIEN,0)),U,1)
 ..Q:STATUS="E"
 ..Q:(STATUS="R")&(RETI'="C")
 ..;D DATA(.DATA,CPIEN,SIEN)
 ..S INVDT=9999999-$P($G(^AUPNCPL(CPIEN,0)),U,5)
 ..S SORT(INVDT,CPIEN,SIEN)=""
 .D DATA(.DATA,.SORT)
 Q
IEN(DATA) ;FIND IEN
 Q:STATUS="E"
 I RETI="C"!(STATUS="A"&((RETI="A")!(RETI="L"))) D
 .S CPIEN="" S CPIEN=$O(^AUPNCPL("ASDT",IEN,TYPE,INVDT,STATUS,CPIEN)) Q:CPIEN=""  D
 ..S SIEN="" F  S SIEN=$O(^AUPNCPL("ASDT",IEN,TYPE,INVDT,STATUS,CPIEN,SIEN),-1) Q:SIEN=""  D
 ..S SORT(INVDT,CPIEN,SIEN)=""
 .D DATA(.DATA,.SORT)
 Q
DATA(DATA,SORT) ;Get data for this item
 N INVDT,CPIEN,SIEN
 S INVDT="" F  S INVDT=$O(SORT(INVDT)) Q:INVDT=""  D
 .S CPIEN="" F  S CPIEN=$O(SORT(INVDT,CPIEN)) Q:CPIEN=""  D
 ..S SIEN="" F  S SIEN=$O(SORT(INVDT,CPIEN,SIEN)) Q:SIEN=""  D
 ...D DATA1(.DATA,CPIEN,SIEN)
 Q
DATA1(DATA,CPIEN,SIEN) ;Get data for one plan
 N BY,WHEN,LIEN,TXT,TXTIEN,PTYPE,SIGNED,PROB,SIG
 S FNUM=9000092.11
 S SIGNED=0
 S SIGNED=$P($G(^AUPNCPL(CPIEN,0)),U,7)
 ;Q:(SIGNED="")&(DUZ'=$$GET1^DIQ(9000092,CPIEN,.03,"I")) ;DKA 9/9/13 Don't filter out
 S NODE=$G(^AUPNCPL(CPIEN,11,SIEN,0))
 I SDATE=0 S SDATE=$P(INVDT,".",1)
 I RETI="L"&(SDATE'=$P(INVDT,".",1)) S DONE=1
 Q:+DONE
 S CNT=CNT+1
 S LIEN=SIEN_","_CPIEN
 S WHEN=$$GET1^DIQ(FNUM,LIEN,.03,"I")
 S WHEN=$$FMTDATE^BGOUTL(WHEN,1)
 S BY=$$GET1^DIQ(FNUM,LIEN,.02,"E")
 S STAT=$$GET1^DIQ(FNUM,LIEN,.01,"I")
 S PTYPE=$S(TYPE="P":"C",1:"G")
 S SIG=$$GET1^DIQ(9000092,CPIEN,.08,"I")
 I SIG'="" S SIG=$$FMTDATE^BGOUTL(SIG)
 ;S @DATA@(CNT)=PTYPE_U_CPIEN_U_IEN_U_BY_U_WHEN_U_STAT_U_SIGNED
 S @DATA@(CNT)=PTYPE_U_CPIEN_U_IEN_U_BY_U_WHEN_U_STAT_U_SIG
 S TXTIEN=0 F  S TXTIEN=$O(^AUPNCPL(CPIEN,12,TXTIEN)) Q:'+TXTIEN  D
 .S CNT=CNT+1
 .;IHS/MSC/MGH changed for carriage returns P17
 .S @DATA@(CNT)="~t"_U_$TR($G(^AUPNCPL(CPIEN,12,TXTIEN,0)),$C(13,10))
 Q
 Q
 ; Input Variables
 ;   DFN     =   Patient
 ;   PRIEN   =   problem this plan belongs to
 ;   INP     =   G(goal) or P(Care plan)[1] ^ IEN [2] (blank if new) ^ EDT(event dt/time) [3] ^ Provider [4]
 ;   STATUS  =   SIEN [1] ^ STATUS [2] ^ WHO ENTERED [3] ^ WHEN [4] ^ Old Item if replaced [5] ^ REASON EIE [6]^ REASON IF OTHER [7] ^ Comment [8]
 ;   TEXT(n) =   Text of the item
SET(RET,DFN,PRIEN,INP,STATUS,TEXT) ;EP
 N FDA,IEN,FPNUM,CIEN,FNUM,IENS,PRNEW,PRIOR,SNOCT,DESCT,X,PIEN
 N TYP,IEN,EDT,PRV,OLD,SIEN,WHO,WHEN,STAT,OLDIEN,NEWIEN,STAT2,X2
 S FNUM=$$FNUM,RET="",ERR=0,OLD=""
 I $G(PRIEN)="" S RET="1^No Problem was input and care planning cannot be saved" Q
 S TYP=$S($P(INP,U,1)="C":"P",1:$P(INP,U,1))
 S IEN=$P(INP,U,2),EDT=$P(INP,U,3),PRV=$P(INP,U,4)
 ;IHS/MSC/MGH Fix for sending in a zero
 I IEN=0 S IEN=""
 I TYP="" S RET="1^A Care Planning type was not entered. Cannot save item" Q
 S STAT=$P(STATUS,U,2)
 I STAT="" S RET="1^No status was entered and care planning cannot be saved" Q
 I IEN="" S CIEN="+1,"
 E  S CIEN=IEN_","
 I EDT="" S EDT=$$NOW^XLFDT
 I PRV="" S PRV=DUZ
 I $P(STATUS,U,4)'="" S OLD=$P(STATUS,U,5)
 S FDA=$NA(FDA(FNUM,CIEN))
 S @FDA@(.01)=PRIEN
 S @FDA@(.02)=DFN
 S @FDA@(.03)=PRV
 S @FDA@(.04)=TYP
 S @FDA@(.05)=EDT
 S @FDA@(.06)=$$NOW^XLFDT
 I OLD'="" S @FDA@(.09)=OLD
 S RET=$$UPDATE^BGOUTL(.FDA,,.PIEN)
 Q:RET
 S:'IEN IEN=PIEN(1)
 S:'RET RET=IEN
 ;Add in the status multiple if it hasn't changed
 S SIEN=$P(STATUS,U,1)
 S X2=$C(0)
 ;Find the latest status
 S X2=$O(^AUPNCPL(IEN,11,X2),-1)
 I X2'="" D
 .S STAT2=$P($G(^AUPNCPL(IEN,11,X2,0)),U,1)
 .I STAT'=STAT2 S SIEN=""     ;Add new entry if status changed
 .E  S SIEN=X2
 S WHO=$P(STATUS,U,3)
 S WHEN=$P(STATUS,U,4)
 I WHO="" S WHO=DUZ
 I WHEN="" S WHEN=$$NOW^XLFDT
 I SIEN="" S SIEN="+1,"_IEN_","
 E  S SIEN=SIEN_","_IEN_","
 N FDA,ERR,IEN2
 S FDA(9000092.11,SIEN,.01)=STAT
 S FDA(9000092.11,SIEN,.02)=WHO
 S FDA(9000092.11,SIEN,.03)=WHEN
 S FDA(9000092.11,SIEN,1)=$P(STATUS,U,8)
 I STAT="E"!(STAT="ENTERED IN ERROR") D
 .S FDA(9000092.11,SIEN,.04)=$P(STATUS,U,6)
 .S FDA(9000091.11,SIEN,.05)=$P(STATUS,U,7)
 D UPDATE^DIE(,"FDA","IEN2","ERR")
 I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1) Q
 ;Add in the text of the item if its not signed
 I $$GET1^DIQ(9000092,IEN,.07)="" D
 .N TXT,TCNT,I
 .S TCNT=0
 .S I="" F  S I=$O(TEXT(I)) Q:I=""  D
 ..S TCNT=TCNT+1
 ..S TXT(TCNT,0)=$G(TEXT(I))
 .D WP^DIE(9000092,IEN_",",1200,,"TXT")
 ;if replaced update original
 I +OLD D UPDATE(OLD)
 Q
UPDATE(OLD) ;Update data
 N OLDIEN,FDA,ERR,IEN2
 S OLDIEN="+1,"_OLD_","
 S FDA=$NA(FDA(FNUM,OLDIEN))
 S FDA(9000092.11,OLDIEN,.01)="R"
 S FDA(9000092.11,OLDIEN,.02)=WHO
 S FDA(9000092.11,OLDIEN,.03)=WHEN
 S FDA(9000092.11,OLDIEN,.06)=IEN
 D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
LOOK(SNOMED) ;Lookup snomed term
 N RET
 S RET=$P($$DESC^BSTSAPI(SNOMED_"^^1"),U,2)
 Q RET
 ;Sign the plan
 ;Input=IEN of the entry
 ;Provider who is signing
SIGN(RET,IEN,PRV) ;Sign the entry
 N FNUM,FDA,IEN2,ERR,AIEN
 S RET="",ERR=""
 S AIEN=IEN_","
 S FDA(9000092,AIEN,.07)=PRV
 S FDA(9000092,AIEN,.08)=$$NOW^XLFDT
 D FILE^DIE("","FDA","ERR")
 I ERR S RET=-1_U_"Unable to sign Care Plan"
 Q
 ; Delete a Care Plan entry
DEL(RET,PLAN) ;EP
 N GBL
 I $G(PLAN)="" S RET="-1^Care Plan number not entered" Q
 I $$GET1^DIQ(9000092,PLAN,.07)'="" S RET="-1^Already signed" Q
 S GBL=$$ROOT^DILFD($$FNUM,,1),RET=""
 S FNUM=$$FNUM^BGOCPLAN
 Q:'PLAN
 I '$L(GBL) S RET=$$ERR^BGOUTL(1069) Q
 S RET=$$DELETE^BGOUTL(FNUM,PLAN)
 D:'RET VFEVT^BGOUTL2(FNUM,PLAN,2,X)
 Q
UPSTAT(RET,IEN,PROB,STAT,COMM) ;Change the status of a care plan or goal
 N AIEN,FDA,ERR,SIEN,IEN2
 S RET=""
 S SIEN="+1,"_IEN_","
 S FDA(9000092.11,SIEN,.01)=STAT
 S FDA(9000092.11,SIEN,.02)=DUZ
 S FDA(9000092.11,SIEN,.03)=$$NOW^XLFDT
 ;S FDA(9000092.11,SIEN,1)=COMM
 S:$G(COMM)'="" FDA(9000092.11,SIEN,1)=COMM  ;2013-09-10 DKA P13 Allow blank comment
 D UPDATE^DIE(,"FDA","IEN2","ERR")
 I $D(ERR)>0 S RET="-1^Unable to update status"
 Q
 ;Input parameter
 ;INP= Problem ien [1] ^ Reason for eie [2] ^ comment if other [3]
EIE(RET,INP) ;Mark an entry entered in error
 N FNUM,IEN2,FDA,IEN,REASON,CMMT,IENS,RET
 S RET=""
 S IENS=$P(INP,U,1)
 S REASON=$P(INP,U,2)
 S CMMT=$P(INP,U,3)
 S FNUM=9000092.11
 S IEN2="+1,"_IENS_","
 S FDA=$NA(FDA(FNUM,IEN2))
 S @FDA@(.01)="E"
 S @FDA@(.02)=DUZ
 S @FDA@(.03)=$$NOW^XLFDT()
 S @FDA@(.04)=REASON
 S @FDA@(.04)=CMMT
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q
 ;EIE can only be done by the author or the chief of MIS
 ;Input = IEN of the entry [1] ^ user deleting [2]
OKDEL(RET,IEN,USER) ;EP  Can this user delete
 N PRV,ENTRYDT,ERR
 S RET=0
 I $G(USER)="" S USER=DUZ
 S PRV=$$GET1^DIQ(9000092,IEN,.03,"I")
 I PRV=USER S RET=1 Q
 S ENTRYDT=$$NOW^XLFDT
 S ERR=""
 S RET=$$ISA^TIUPS139(USER,"CHIEF, MIS",ERR)
 Q
PAR(INP) Q $S($$GET^XPAR("SYS","BEH PARAMETER",INP)>0:$$GET^XPAR("SYS","BEH PARAMETER",INP),1:1)
TMPGBL(X) ;EP
 K ^TMP("BGOPLAN"_$G(X),$J) Q $NA(^($J))
 ; Return file number
FNUM() Q 9000092
 ; Use parameters to get and load TIU templates into the care plan
 ; Nodes Returned by GETITEMS
 ;
 ; Piece  Data
 ; -----  ---------------------
 ;   1    IEN
 ;   2    TYPE
 ;   3    STATUS
 ;   4    NAME
 ;   5    EXCLUDE FROM GROUP BOILERPLATE
 ;   6    BLANK LINES
 ;   7    PERSONAL OWNER
 ;   8    HAS CHILDREN FLAG (0=NONE, 1=ACTIVE, 2=INACTIVE, 3=BOTH)
 ;   9    DIALOG
 ;  10    DISPLAY ONLY
 ;  11    FIRST LINE
 ;  12    ONE ITEM ONLY
 ;  13    HIDE DIALOG ITEMS
 ;  14    HIDE TREE ITEMS
 ;  15    INDENT ITEMS
 ;  16    REMINDER DIALOG IEN
 ;  17    REMINDER DIALOG NAME
 ;  18    LOCKED
 ;  19    COM OBJECT POINTER
 ;  20    COM OBJECT PARAMETER
 ;  21    LINK POINTER
GETROOTS(TIUY,USER,PARAM) ;Get template root info
 N IDX,TIUDA,TYPE,PARAM,ENT,ARY,ERR,LP
 S ENT=$$ENT^CIAVMRPC(PARAM,.ENT)
 D GETLST^XPAR(.ARY,ENT,PARAM,"N",.ERR)
 I $G(ERR) K ARY S DATA=ERR
 S LP=0 F  S LP=$O(ARY(LP)) Q:LP<1  D
 .S TIUDA=$P(ARY(LP),U,1)
 .D ADDNODE(.IDX,TIUDA,1)
 Q
ADDNODE(IDX,TIUDA,INTIUY) ;Adds template node info
 N DATA
 S DATA=$$NODEDATA^TIUSRVT(TIUDA)
 I DATA'="" D
 .S IDX=$G(IDX)+1
 .I $G(INTIUY) S TIUY(IDX)=DATA
 .E  S ^TMP("TIU TEMPLATE",$J,IDX)=DATA
 Q
CPACT(RET,DFN,PRIEN,CPTYP,NUM) ;EP
 ;  DFN  = The patient this problem belongs to
 ;  PRIEN= The problem to return care planning data on
 ;  CPTYP= A  All
 ;         C  Active
 ;         L  Last date
 ;  NUM = Number of entries in V files to return
 ;  RET = Array of care planning items for a problem
 N CNT
 I CPTYP="" S CPTYP="L"
 ;For Visit instructions and treatments, the default is the latest visit
 I $G(NUM)="" S NUM=1
 S RET=$$TMPGBL^BGOUTL
 S CNT=0
 D GET^BGOCPLAN(.RET,PRIEN,DFN,"G",CPTYP,.CNT)
 D GET^BGOCPLAN(.RET,PRIEN,DFN,"P",CPTYP,.CNT)
 D GET^BGOVVI(.RET,DFN,PRIEN,NUM,.CNT)
 D GET^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 D GETCON^BGOVTR(.RET,DFN,PRIEN,NUM,.CNT)
 Q
SCRN(Y,ENT) ;Return only items in shared templates
 N ITM,SEQ,ITEM,ITEMNODE,RET,PROV
 S RET=0
 S ITM=$O(^TIU(8927,"B","Shared Templates",""))
 D LOOP
 I $P(ENT,";",2)="VA(200," D
 . S PROV=$P(ENT,";",1)
 . S ITM=$O(^TIU(8927,"AROOT",PROV,""))
 . D LOOP
 Q RET
LOOP N TYPE
 I $P($G(^TIU(8927,ITM,0)),U,3)'="T" D
 .S (IDX,SEQ)=0
 .F  S SEQ=$O(^TIU(8927,ITM,10,"B",SEQ)) Q:'SEQ  D
 ..S ITEM=0
 ..F  S ITEM=$O(^TIU(8927,ITM,10,"B",SEQ,ITEM)) Q:'ITEM  D
 ...S ITEMNODE=$G(^TIU(8927,ITM,10,ITEM,0))
 ...I $P(ITEMNODE,U,2)=Y D
 ....S TYPE=$P($G(^TIU(8927,$P(ITEMNODE,U,2),0)),U,3)
 ....S RET=$S(TYPE="T":1,TYPE="G":1,1:0)
 Q
