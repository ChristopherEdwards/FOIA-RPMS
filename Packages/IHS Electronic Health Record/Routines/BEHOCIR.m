BEHOCIR ;MSC/IND/MGH - CCD calls ;03-Dec-2013 13:37;du
 ;;1.1;BEH COMPONENTS;**066001**;March 12, 2008;Build 1
 ;=================================================================
 ;Set entry into the CCD
 ;The date/time and user will be associated with all the items in the list
 ;Input DATA=IEN of reconciliation entry [1]^ DFN [2] ^ BY [3] ^ IMAGE [4] ^ Source [5]^ Allergy date/time [6] ^ Problem dt/time [7] ^ Medication dt/time [8]
 ;      List(n)=Type [1] ^ Item [2]
SET(RET,DATA,LIST) ;EP
 N BY,NEW,IEN,IENS,FDA,FNUM,BY,SRC,AREC,PREC,MREC,CNT,WHEN
 S RET="",NEW=""
 S IEN=""
 D TOP(.RET,DATA)
 Q:+RET=-1
 S CNT="" F  S CNT=$O(LIST(CNT)) Q:CNT=""  D
 .D ITEM(IEN,BY)
 ;Update the dates of the pieces
 S FNUM=90461.63
 S IENS=IEN_","
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.07)=AREC
 S @FDA@(.08)=PREC
 S @FDA@(.09)=MREC
 D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
 I (AREC'="")&(PREC'="")&(MREC'="") D FINISH(IEN)
 S RET=IEN
 Q
TOP(RET,DATA) ;Get the top entry data and store it
 N FNUM,FDA,IENS,ERR,IEN2,DFN,IMG
 S IEN=$P(DATA,U,1)
 I IEN="" S NEW=1
 S DFN=$P(DATA,U,2)
 I DFN="" S RET="-1^No patient identified" Q
 S BY=$P(DATA,U,3)
 I BY="" S BY=$$GET1^DIQ(200,DUZ,.01)
 S IMG=$P(DATA,U,4)
 ;I IMG="" S RET="-1^No CCDA identified" Q
 S SRC=$P(DATA,U,5)
 S AREC=$P(DATA,U,6)
 S PREC=$P(DATA,U,7)
 S MREC=$P(DATA,U,8)
 S FNUM=90461.63
 S IENS=$S('NEW:IEN_",",1:"+1,")
 S FDA=$NA(FDA(FNUM,IENS))
 S:NEW @FDA@(.01)=$$NOW^XLFDT
 S:NEW @FDA@(.02)=DFN
 S @FDA@(.03)=SRC
 S @FDA@(.05)=BY
 S @FDA@(1.1)=IMG
 I NEW D
 .D UPDATE^DIE("","FDA","IEN2","ERR")
 .I $D(ERR) S RET="-1^Unable to add reconcillation data"
 .E  S IEN=IEN2(1)
 E  D
 .D FILE^DIE("E","FDA","ERR")
 .I $D(ERR("DIERR")) S RET=ERR("DIERR")
 Q
ITEM(IEN,BY) ;Store each item
 N FDA,DIERR,TYPE,AIEN,IENS,ERR,TIEN
 Q:IEN=""
 S TYPE=$P(LIST(CNT),U,1)
 S TIEN=$P(LIST(CNT),U,2)
 S AIEN="+1,"_IEN_","
 S FDA=$NA(FDA(90461.632,AIEN))
 S @FDA@(.01)=$S(TYPE="A":AREC,TYPE="CA":AREC,TYPE="P":PREC,TYPE="CP":PREC,1:MREC)
 S @FDA@(.02)=DUZ
 S @FDA@(.03)=TYPE
 I TYPE["C" S @FDA@(.05)=TIEN
 E  S @FDA@(.04)=+TIEN
 I AREC'="" S @FDA@(.07)=AREC
 I PREC'="" S @FDA@(.08)=PREC
 I MREC'="" S @FDA@(.09)=MREC
 D UPDATE^DIE("","FDA","IENS","ERR")
 S:$G(DIERR) RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1)
 Q
FINISH(IEN) ;Mark it reconciled
 N FDA,ERR
 S FDA=$NA(FDA(90461.63,IEN))
 S @FDA@(.04)=1
 D UPDATE^DIE("","FDA","","ERR")
 Q
 ;Get latest reconcilations for a CCDA
 ;Input=Image IEN
 ;Ouput=Alg date[1] ^ Prob date [2] ^ med date[3] ^ NEW ien [4]
GETCIR(RET,IMAGE) ;Get the reconciliations for a CCDS
 N INVA,IEN,FIELD,IDATE,ADATE,PDATE,MDATE,NEW,I
 S (ADATE,PDATE,MDATE,NEW)=""
 S RET=""
 F I="AE","AF","AG" D
 .S INVA="" S INVA=$O(^BEHOCIR(I,IMAGE,INVA)) Q:INVA=""  D
 ..S IEN="" S IEN=$O(^BEHOCIR(I,IMAGE,INVA,IEN)) Q:IEN=""  D
 ...S FIELD=$S(I="AE":.07,I="AF":.08,I="AG":.09)
 ...S IDATE=$$GET1^DIQ(90461.63,IEN,FIELD)
 ...I I="AE" S ADATE=IDATE
 ...I I="AF" S PDATE=IDATE
 ...I I="AG" S MDATE=IDATE
 I ADATE=""&(PDATE="")&(MDATE="") D
 .S NEW="" S NEW=$O(^BEHOCIR("D",IMAGE,NEW))
 S RET=ADATE_U_PDATE_U_MDATE_U_NEW
 Q
GETTXT(RET,SNOMED) ;Return text of SNOMED CT
 N IN,X,TXT,CODE,DESC
 S RET=""
 S IN=SNOMED_"^^^1"
 S X=$$CONC^BSTSAPI(IN)
 S TXT=$P(X,U,4)
 S DESC=$P(X,U,3)
 S RET=TXT_U_DESC
 Q
GETNUM(RET,DFN) ;Return number of CCDAs for a pt
 N INVDT,IEN,IMAGE,AREC,PREC,MREC,DCNT,NCNT,ARRAY,DATA,ITYPE
 S DCNT=0,NCNT=0
 S INVDT=""
 F  S INVDT=$O(^BEHOCIR("AA",DFN,INVDT)) Q:INVDT=""  D
 .S IEN="" F  S IEN=$O(^BEHOCIR("AA",DFN,INVDT,IEN)) Q:IEN=""  D
 ..S IMAGE=$P($G(^BEHOCIR(IEN,1)),U,1)
 ..Q:IMAGE=""
 ..Q:$P($G(^MAG(2005,IMAGE,100)),U,5)'=""
 ..S ARRAY(IMAGE)=""
 S IMG="" F  S IMG=$O(ARRAY(IMG)) Q:IMG=""  D
 .S DATA=""
 .S DCNT=DCNT+1
 .D GETCIR(.DATA,IMG)
 .I $P(DATA,U,1)'=""&($P(DATA,U,2)'="")&($P(DATA,U,3)'="") S NCNT=NCNT+1
 S RET=DCNT_U_NCNT
 Q
TMPGBL() ;EP
 K ^TMP("BEHCIR",$J) Q $NA(^($J))
