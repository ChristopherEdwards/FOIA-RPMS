BGOVOB ; IHS/BAO/TMD - pull Visit files associated with problems  ;31-May-2016 14:36;du
 ;;1.1;BGO COMPONENTS;**21**;Mar 20, 2007;Build 1
 ;---------------------------------------------
 ;Get Data from V OB file
 ;Inp parameters:
 ;    DFN
 ;    PROB Ien
 ;    Number to Return
 ;    CNT
 ;    SVIEN -visit ien
 ;Return is list of OB notes
 ;Array(n)="I" [1] ^ Instr IEN[2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^ Visit IEN [9] ^V cat [10] ^ Locked [11] ^ Prov Name [12] ^ signed [12]
 ;          =~t [1] ^Text of the item [2]
GET(DATA,DFN,PROB,NUM,CNT,SVIEN,PRV) ;EP
 N X,REC,VCAT,VIN,VDT,LOC,FAC,FACNAM,EXNAME,PRVIEN,PRVNAME
 N FNUM,VDATE,VIEN,EDATE,STDT,COMM,CT,SIGN,TXTIEN,INVDT
 I $G(DATA)="" S DATA=$$TMPGBL
 S PRV=$G(PRV)
 ;Return the OB data for the last visit by default
 I $G(NUM)="" S NUM=1
 I $G(CNT)="" S CNT=0
 S SVIEN=$G(SVIEN)
 S CT=0
 ;Visit not selected get problems
 I SVIEN="" D
 .S INVDT="" F  S INVDT=$O(^AUPNVOB("AE",DFN,PROB,INVDT)) Q:INVDT=""!(CT+1>NUM)  D
 ..S VIN="" F  S VIN=$O(^AUPNVOB("AE",DFN,PROB,INVDT,VIN)) Q:'+VIN  D
 ...S REC=$G(^AUPNVOB(VIN,0))
 ...Q:REC=""
 ...D GETREC
 ;Find entries for a specific visit
 I SVIEN'="" D
 .S VIN="" F  S VIN=$O(^AUPNVOB("AD",SVIEN,VIN)) Q:VIN=""  D
 ..S REC=$G(^AUPNVOB(VIN,0))
 ..Q:REC=""
 ..D GETREC
 Q
GETREC ;Get the record
 S FNUM=$$FNUM
 S PRVIEN=$P($G(^AUPNVOB(VIN,12)),U,4)
 S PRVNAME=$S('PRVIEN:"",1:$P($G(^VA(200,+PRVIEN,0)),U))
 S VIEN=$P(REC,U,3)
 Q:'VIEN
 Q:$$GET1^DIQ(9000010.43,VIN,.06,"I")=1
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 S FAC=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U,10),1:"")
 S FACNAM=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U),1:"")
 S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 S:$P($G(^AUPNVSIT(VIEN,21)),U)'="" FACNAM=$P(^(21),U)
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S VDT=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S EDATE=$$GET1^DIQ(9000010.43,VIN,1201,"I")
 S SIGN=$$GET1^DIQ(9000010.43,VIN,.05,"I")
 Q:(SIGN="")&(DUZ'=$$GET1^DIQ(9000010.43,VIN,1204,"I"))
 I EDATE="" S EDATE=VDT
 S VDATE=$$FMTDATE^BGOUTL(VDT,1)
 S EDATE=$$FMTDATE^BGOUTL(EDATE,1)
 S SIGN=$$FMTDATE^BGOUTL(SIGN)
 S CNT=CNT+1,CT=CT+1
 S @DATA@(CNT)="O"_U_VIN_U_PROB_U_VDATE_U_FACNAM_U_PRVIEN_U_LOC_U_EDATE_U_VIEN_U_VCAT_U_$$ISLOCKED^BEHOENCX(VIEN)_U_PRVNAME_U_SIGN
 S TXTIEN=0 F  S TXTIEN=$O(^AUPNVOB(VIN,11,TXTIEN)) Q:'+TXTIEN  D
 .S CNT=CNT+1
 .S @DATA@(CNT)="~t"_U_$TR($G(^AUPNVOB(VIN,11,TXTIEN,0)),$C(13,10))
 Q
 ; Delete a V OB entry
 ;INP=VFIEN ^ DELETE REASON ^ OTHER
DEL(RET,INP) ;EP
 N COMMENT,FDA,REASON,VFIEN
 S VFIEN=$P(INP,U)
 I $$GET1^DIQ(9000010.43,VFIEN,.05)="" D
 .D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 E  D
 .S REASON=$P(INP,U,2)
 .S COMMENT=$P(INP,U,3)
 .I VFIEN="" S RET=$$ERR^BGOUTL(1008) Q  ; Missing input data
 .I '$D(^AUPNVVI(VFIEN)) S RET=$$ERR^BGOUTL(1035) Q  ; Item not found
 .S FDA=$NA(FDA($$FNUM,VFIEN_","))
 .S @FDA@(.06)=1
 .S @FDA@(.07)=DUZ
 .S @FDA@(1218)=$$NOW^XLFDT()
 .S @FDA@(1219)=DUZ
 .S @FDA@(.08)=REASON
 .S @FDA@(.09)=COMMENT
 .S RET=$$UPDATE^BGOUTL(.FDA,,VFIEN)
 .S:RET="" RET=1
 Q
 ;Set data into this file
 ;INP = VOB IEN [1] ^ Visit IEN [2] ^ Problem IEN [3] ^ Patient IEN [4] ^ Evnt Dt [5] ^ Provider [6]
 ;INSTR(N)= Array of instructions
SET(RET,INP,INSTR) ;EP
 N VFIEN,NEW,VIEN,PROB,EVDT,DFN,PRV,FDA,IEN,FNUM,VFNEW
 S FNUM=$$FNUM
 S VFIEN=+INP
 I VFIEN="" S NEW=1
 S VFNEW='VFIEN
 S VIEN=$P(INP,U,2)
 S PROB=$P(INP,U,3)
 I 'PROB S RET="-1^No problem in input string" Q
 I 'VIEN S RET=$$ERR^BGOUTL(1008) Q
 S DFN=$P(INP,U,4)
 S EVDT=$P(INP,U,5)
 I EVDT="" S EVDT=$$NOW^XLFDT
 S PRV=$P(INP,U,6) I PRV="" S PRV=DUZ
 S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,PROB,VIEN)
 .S:RET>0 VFIEN=RET ;,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(1201)=EVDT
 S @FDA@(1204)="`"_PRV
 I VFNEW D
 .S @FDA@(1216)="N"
 .S @FDA@(1217)="`"_DUZ
 S @FDA@(1218)="N"
 S @FDA@(1219)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E@")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 Q:RET
 ;Add in the text of the item
 N VAL,ICNT,I
 S ICNT=0
 S I="" F  S I=$O(INSTR(I)) Q:I=""  D
 .S ICNT=ICNT+1
 .S VAL(ICNT,0)=$G(INSTR(I))
 D WP^DIE(9000010.43,VFIEN_",",1100,,"VAL")
 S RET=VFIEN
 Q  ;RET
 ;Mark record when signed
SIGN(RET,VVOB,BY) ;EP
 N FDA,AIEN,ERR
 S RET="",ERR=""
 I $$GET1^DIQ(9000010.43,VVOB,.05)'="" S RET="-1^Already signed" Q RET
 S AIEN=VVOB_","
 S FDA(9000010.43,AIEN,.04)=BY
 S FDA(9000010.43,AIEN,.05)=$$NOW^XLFDT
 D FILE^DIE("","FDA","ERR")
 I ERR S RET=-1_U_"Unable to sign OB note"
 Q RET
 ;EIE can only be done by the author or the chief of MIS
 ;Input = IEN of the entry [1] ^ user deleting [2]
OKDEL(RET,IEN,USER) ;EP  Can this user delete
 N PRV,ENTRYDT,ERR
 S RET=0
 I $G(USER)="" S USER=DUZ
 S PRV=$$GET1^DIQ(9000010.43,IEN,1204,"I")
 I PRV=USER S RET=1 Q
 S ENTRYDT=$$NOW^XLFDT
 S ERR=""
 S RET=$$ISA^TIUPS139(USER,"CHIEF, MIS",ERR)
 Q
 ;Input parameter
 ;INP= Visit instruction ien [1] ^ Reason for eie [2] ^ comment if other [3]
EIE(RET,INP) ;Mark an entry entered in error
 N FNUM,IEN2,FDA,IEN,REASON,CMMT,IENS,RET
 S RET=""
 S IENS=$P(INP,U,1)
 S REASON=$P(INP,U,2)
 S CMMT=$P(INP,U,3)
 S FNUM=9000010.43
 S IEN2=IENS_","
 S FDA=$NA(FDA(FNUM,IEN2))
 S @FDA@(.06)=1
 S @FDA@(.07)=DUZ
 S @FDA@(.08)=$$NOW^XLFDT()
 S @FDA@(.08)=REASON
 S @FDA@(.09)=CMMT
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q
GETONE(RET,PRIEN) ;Get ALl the data for one problem
 N TYP,NUM,ACT,CPTYP,DFN,CNT,PER,CONCT
 S RET=$$TMPGBL^BGOUTL
 S DFN=$$GET1^DIQ(9000011,PRIEN,.02,"I")
 S TYP="ASEOIR",CPTYP="A",PER="P"
 S NUM=9999999,ACT=1
 S CNT=0
 D GET2^BGOPROB(.RET,PRIEN,DFN,TYP,CPTYP,NUM,ACT,PER,2)
 Q
PROBDATA(DATA,PROB,NUM) ;Get data for one problem
 N CNT,DFN,RETI
 S DATA=$$TMPGBL
 I $G(PROB)="" S @DATA@(1)="-1^Undefined problem" Q
 S DFN=$$GET1^DIQ(9000011,PROB,.02,"I")
 I '+DFN S @DATA@(1)="-1^Unknown patient for this problem" Q
 I $G(NUM)="" S NUM=9999999
 S CNT=0
 S RETI="C"
 D GET^BGOCPLAN(.DATA,PROB,DFN,"G",RETI,.CNT,"")
 D GET^BGOCPLAN(.DATA,PROB,DFN,"P",RETI,.CNT,"")
 D GET^BGOVVI(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GET^BGOVOB(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GET^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GETCON^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"")
 D GETREF^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GETEDU^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOVOB",$J) Q $NA(^($J))
 ; Return file number
FNUM() Q 9000010.43
