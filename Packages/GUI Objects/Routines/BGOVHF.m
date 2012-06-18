BGOVHF ; IHS/BAO/TMD - Manage V HEALTH FACTORS ;18-Nov-2009 10:44;PLS
 ;;1.1;BGO COMPONENTS;**1,3,4,6**;Mar 20, 2007
 ; Get health factors by patient
 ;  INP = Patient IEN ^ Learn Only Flag ^ V HF IEN (optional)
 ; .RET returned as a list of records in the format:
 ;   Category [1] ^ HF Name [2] ^ Visit Date [3] ^ Severity [4] ^ Quantity [5] ^ Visit IEN [6] ^
 ;   V File IEN [7] ^ Health Factor Type [8] ^ Comment [9] ^ Visit Locked [10]
GET(RET,INP) ;EP
 N DFN,LRN,VFIEN,TYPE,CNT,VDT,IEN,VIEN,SEV,QTY,CAT,HFNAME,VDATE
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP
 S LRN=$P(INP,U,2)
 S VFIEN=$P(INP,U,3)
 S (TYPE,CNT)=0
 F  S TYPE=$O(^AUPNVHF("AA",DFN,TYPE)) Q:'TYPE  D
 .I LRN,'$$ISLEARN(TYPE,1) Q
 .S VDT=0
 .F  S VDT=$O(^AUPNVHF("AA",DFN,TYPE,VDT)) Q:'VDT  D
 ..S VDATE=$$FMTDATE^BGOUTL(9999999-VDT)
 ..S IEN=0
 ..F  S IEN=$O(^AUPNVHF("AA",DFN,TYPE,VDT,IEN)) Q:'IEN  D
 ...I VFIEN,VFIEN'=IEN Q
 ...S REC=$G(^AUPNVHF(IEN,0))
 ...Q:REC=""
 ...S VIEN=$P(REC,U,3)
 ...S SEV=$$EXTERNAL^DILFD($$FNUM,.04,,$P(REC,U,4))
 ...S QTY=$P(REC,U,6)
 ...S COMMENT=$P($G(^AUPNVHF(IEN,811)),U)
 ...S HFNAME=$P($G(^AUTTHF(TYPE,0)),U),CAT=$P($G(^(0)),U,3)
 ...S:CAT CAT=$P($G(^AUTTHF(CAT,0)),U)
 ...S CNT=CNT+1
 ...S @RET@(CNT)=CAT_U_HFNAME_U_VDATE_U_SEV_U_QTY_U_VIEN_U_IEN_U_TYPE_U_COMMENT_U_$$ISLOCKED^BEHOENCX(VIEN)
 Q
 ; Return IEN for pap smear/mammogram/ekg
REFLIST(RET,INP) ;EP
 I INP="PAP SMEAR" S RET=$O(^LAB(60,"B","PAP SMEAR",0))
 E  I INP="MAMMOGRAM" S RET=$O(^RAMIS(71,"D",76090,0))
 E  I INP="EKG" S RET=$O(^AUTTDXPR("B","ECG SUMMARY",0))
 E  S RET=$$ERR^BGOUTL(1026,INP)
 Q
 ; Add/edit health factor
 ;  INP = HF Type IEN [1] ^ V File IEN [2] ^ Visit IEN [3] ^ Severity [4] ^ Provider IEN [5] ^ Quantity [6] ^ Comment [7]
SET(RET,INP) ;EP
 N VIEN,TYPE,PRV,QTY,SEV,VFIEN,VFNEW,COMMENT,FNUM,FDA
 S FNUM=$$FNUM
 S TYPE=+INP
 I 'TYPE S RET=$$ERR^BGOUTL(1008) Q
 S VFIEN=$P(INP,U,2)
 S VFNEW='VFIEN
 S VIEN=+$P(INP,U,3)
 S SEV=$P(INP,U,4)
 S PRV=$P(INP,U,5)
 S QTY=$P(INP,U,6)
 S COMMENT=$P(INP,U,7)
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN,"Health factor")
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.01)="`"_TYPE
 S @FDA@(.04)=SEV
 S @FDA@(.05)=$S(PRV:"`"_PRV,1:"")
 S @FDA@(.06)=QTY
 S @FDA@(1201)="N"
 S @FDA@(1204)="`"_DUZ
 S:'VFNEW!$L(COMMENT) @FDA@(81101)=COMMENT
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Set refusal
 ;  INP = Refusal Type [1] ^ Item IEN [2] ^ Patient IEN [3] ^ Refusal Date [4] ^ Comment [5] ^ Provider IEN [6]
SETREF(RET,INP) ;EP
 N DFN,REFTYP,ITEMIEN,REFDATE,COMMENT,REFTIEN,FILENUM,PRV
 S RET=""
 S REFTYP=$P(INP,U)
 S ITEMIEN=+$P(INP,U,2)
 I 'ITEMIEN S RET=$$ERR^BGOUTL(1078) Q
 S DFN=+$P(INP,U,3)
 I '$D(^AUPNPAT(DFN)) S RET=$$ERR^BGOUTL(1001) Q
 S REFDATE=$$CVTDATE^BGOUTL($P(INP,U,4))
 S COMMENT=$P(INP,U,5)
 S PRV=$P(INP,U,6)
 S RET=$$REFSET2^BGOUTL2(DFN,REFDATE,ITEMIEN,REFTYP,"R",COMMENT,PRV)
 Q
 ; Delete a refusal
DELREF(RET,REF) ;EP
 S RET=$$REFDEL^BGOUTL2(+REF)
 Q
 ; Delete a health factor
DEL(RET,VFIEN) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ;
 ; Return health factor types
 ;  INP = 1: all (default), 2: learning only
 ;  Returns a list of records in the format:
 ;   Name [1] ^ Category Name [2] ^ Gender [3] ^ Type [4] ^ HF Type IEN [5] ^ Quantity Phrase [6] ^ Level Phrase [7]
GETTYPES(RET,INP) ;EP
 N ALL,NAME,CATP,CATNAME,TYPE,SEX,HF,CNT,REC,X,QTYPHR,LVLPHR
 S RET=$$TMPGBL^BGOUTL
 S ALL=INP'=2
 S (HF,CNT)=0
 F  S HF=$O(^AUTTHF(HF)) Q:'HF  D  ;!(HF>99999)  D
 .S REC=$G(^AUTTHF(HF,0))
 .Q:$P(REC,U,$S($G(DUZ("AG"))="I":13,1:11))  ;P6                                   ;inactive
 .I 'ALL,'$$ISLEARN(+$P(REC,U,3)) Q
 .S NAME=$P(REC,U)
 .S CATP=$P(REC,U,3)
 .S CATNAME=$S(CATP:$P($G(^AUTTHF(CATP,0)),U),1:"")
 .S SEX=$P(REC,U,5)
 .S TYPE=$P(REC,U,10)
 .S QTYPHR=$P(REC,U,11)
 .S LVLPHR=$P(REC,U,12)
 .S CNT=CNT+1,@RET@(CNT)=NAME_U_CATNAME_U_SEX_U_TYPE_U_HF_U_QTYPHR_U_LVLPHR
 Q
 ; Returns true if health factor is a learning category
ISLEARN(TYPE,CHKPAR) ;
 N X
 S TYPE=+TYPE
 Q:'TYPE!$D(TYPE(TYPE)) 0
 S X=$G(^AUTTHF(TYPE,0))
 Q:$P(X,U)["LEARN"&($P(X,U,10)="C") 1
 Q:'$G(CHKPAR) 0
 S TYPE(TYPE)="",TYPE=$P(X,U,3)
 Q $$ISLEARN(.TYPE,1)
 ; Return V File #
FNUM() Q 9000010.23
