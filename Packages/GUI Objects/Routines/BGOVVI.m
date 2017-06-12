BGOVVI ; IHS/BAO/TMD - pull Visit files associated with problems  ;26-Oct-2015 14:11;DU
 ;;1.1;BGO COMPONENTS;**13,14,17**;Mar 20, 2007;Build 13
 ;P14 changed to return time when entered
 ;---------------------------------------------
 ;Get Data from V Visit Instructions file
 ;Inp parameters:
 ;    DFN
 ;    PROB Ien
 ;    Number to Return
 ;    CNT
 ;    SVIEN -visit ien
 ;    PRV
 ;Return is list of visit instructions
 ;Array(n)="I" [1] ^ Instr IEN[2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^ Visit IEN [9] ^V cat [10] ^ Locked [11] ^ Prov Name [12] ^ signed [12]
 ;          =~t [1] ^Text of the item [2]
GET(DATA,DFN,PROB,NUM,CNT,SVIEN,PRV) ;EP
 N X,REC,VCAT,VIN,VDT,LOC,FAC,FACNAM,EXNAME,PRVIEN,PRVNAME
 N FNUM,VDATE,VIEN,EDATE,STDT,COMM,CT,SIGN,TXTIEN,INVDT
 I $G(DATA)="" S DATA=$$TMPGBL
 S PRV=$G(PRV)
 ;Return the instructions for the last visit by default
 I $G(NUM)="" S NUM=1
 I $G(CNT)="" S CNT=0
 S SVIEN=$G(SVIEN)
 S CT=0
 ;Visit not selected get problems
 I SVIEN="" D
 .;if provider not selected, get all required number
 .I PRV="" D
 ..S INVDT="" F  S INVDT=$O(^AUPNVVI("AE",DFN,PROB,INVDT)) Q:INVDT=""!(CT+1>NUM)  D
 ...S VIN="" F  S VIN=$O(^AUPNVVI("AE",DFN,PROB,INVDT,VIN)) Q:'+VIN  D
 ....S REC=$G(^AUPNVVI(VIN,0))
 ....Q:REC=""
 ....D GETREC
 .;Else find entries for this provider
 .E  D
 ..S INVDT="" F  S INVDT=$O(^AUPNVVI("APRV",PROB,PRV,INVDT)) Q:'+INVDT!(CT+1>NUM)  D
 ...S VIN="" F  S VIN=$O(^AUPNVVI("APRV",PROB,PRV,INVDT,VIN)) Q:'+VIN  D
 ....S REC=$G(^AUPNVVI(VIN,0))
 ....Q:REC=""
 ....D GETREC
 ;Find entries for a specific visit
 I SVIEN'="" D
 .S VIN="" F  S VIN=$O(^AUPNVVI("AD",SVIEN,VIN)) Q:VIN=""  D
 ..S REC=$G(^AUPNVVI(VIN,0))
 ..Q:REC=""
 ..D GETREC
 Q
GETREC ;Get the record
 S FNUM=$$FNUM
 S PRVIEN=$P($G(^AUPNVVI(VIN,12)),U,4)
 S PRVNAME=$S('PRVIEN:"",1:$P($G(^VA(200,+PRVIEN,0)),U))
 S VIEN=$P(REC,U,3)
 Q:'VIEN
 Q:$$GET1^DIQ(9000010.58,VIN,.06,"I")=1
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 S FAC=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U,10),1:"")
 S FACNAM=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U),1:"")
 S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 S:$P($G(^AUPNVSIT(VIEN,21)),U)'="" FACNAM=$P(^(21),U)
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S VDT=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S EDATE=$$GET1^DIQ(9000010.58,VIN,1201,"I")
 S SIGN=$$GET1^DIQ(9000010.58,VIN,.05,"I")
 Q:(SIGN="")&(DUZ'=$$GET1^DIQ(9000010.58,VIN,1204,"I"))
 I EDATE="" S EDATE=VDT
 S VDATE=$$FMTDATE^BGOUTL(VDT,1)
 S EDATE=$$FMTDATE^BGOUTL(EDATE,1)
 S SIGN=$$FMTDATE^BGOUTL(SIGN)
 S CNT=CNT+1,CT=CT+1
 S @DATA@(CNT)="I"_U_VIN_U_PROB_U_VDATE_U_FACNAM_U_PRVIEN_U_LOC_U_EDATE_U_VIEN_U_VCAT_U_$$ISLOCKED^BEHOENCX(VIEN)_U_PRVNAME_U_SIGN
 S TXTIEN=0 F  S TXTIEN=$O(^AUPNVVI(VIN,11,TXTIEN)) Q:'+TXTIEN  D
 .S CNT=CNT+1
 .;IHS/MSC/MGH changed for carriage returns P17
 .S @DATA@(CNT)="~t"_U_$TR($G(^AUPNVVI(VIN,11,TXTIEN,0)),$C(13,10))
 Q
 ; Delete a V Visit Instruction entry
 ;INP=VFIEN ^ DELETE REASON ^ OTHER
DEL(RET,INP) ;EP
 N COMMENT,FDA,REASON,VFIEN
 S VFIEN=$P(INP,U)
 I $$GET1^DIQ(9000010.58,VFIEN,.05)="" D
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
 ;INP = VVI IEN [1] ^ Visit IEN [2] ^ Problem IEN [3] ^ Patient IEN [4] ^ Evnt Dt [5] ^ Provider [6]
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
 D WP^DIE(9000010.58,VFIEN_",",1100,,"VAL")
 S RET=VFIEN
 Q  ;RET
 ;Mark record when signed
SIGN(RET,VVII,BY) ;EP
 N FDA,AIEN,ERR
 S RET="",ERR=""
 I $$GET1^DIQ(9000010.58,VVII,.05)'="" S RET="-1^Already signed" Q RET
 S AIEN=VVII_","
 S FDA(9000010.58,AIEN,.04)=BY
 S FDA(9000010.58,AIEN,.05)=$$NOW^XLFDT
 D FILE^DIE("","FDA","ERR")
 I ERR S RET=-1_U_"Unable to sign Visit Instructions"
 Q RET
GETPRV(RET,IEN) ;Get providers associated with problems
 N X,PRV,PRVNAME
 S RET=$$TMPGBL
 ;Goal notes
 S PRV=""
 F  S PRV=$O(^AUPNCPL("APTP",IEN,"G",PRV)) Q:'+PRV  D
 .I $D(^AUPNCPL("APTP",IEN,"G",PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..S @RET@(PRV)=PRV_U_PRVNAME_U_"G"
 ;Care plans
 S PRV="" S PRV=$O(^AUPNCPL("APTP",IEN,"P",PRV)) Q:'+PRV  D
 .I $D(^AUPNCPL("APTP",IEN,"P",PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..I '$D(@RET@(PRV)) D
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_"C"
 ..E  D
 ...S X=$P($G(@RET@(PRV)),U,3)
 ...S X=X_"P"
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_X
 ;Visit Instructions
 S PRV="" F  S PRV=$O(^AUPNVVI("APRV",IEN,PRV)) Q:'+PRV  D
 .I $D(^AUPNVVI("APRV",IEN,PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..I '$D(@RET@(PRV)) S @RET@(PRV)=PRV_U_PRVNAME_U_"V"
 ..E  D
 ...S X=$P($G(@RET@(PRV)),U,3)
 ...S X=X_"V"
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_X
 ;Visit treatments
 S PRV="" F  S PRV=$O(^AUPNVTXR("APRV",IEN,PRV)) Q:'+PRV  D
 .I $D(^AUPNVTXR("APRV",IEN,PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..I '$D(@RET@(PRV)) S @RET@(PRV)=PRV_U_PRVNAME_U_"T"
 ..E  D
 ...S X=$P($G(@RET@(PRV)),U,3)
 ...S X=X_"T"
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_X
 ;Referrals
 S PRV="" F  S PRV=$O(^AUPNVREF("APRV",IEN,PRV)) Q:'+PRV  D
 .I $D(^AUPNVREF("APRV",IEN,PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..I '$D(@RET@(PRV)) S @RET@(PRV)=PRV_U_PRVNAME_U_"R"
 ..E  D
 ...S X=$P($G(@RET@(PRV)),U,3)
 ...S X=X_"R"
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_X
 Q
 ;Consults
 S PRV="" F  S PRV=$O(^GMR(123,"APRV",IEN,PRV)) Q:'+PRV  D
 .I $D(^GMR(123,"APRV",IEN,PRV))>0 D
 ..S PRVNAME=$$GET1^DIQ(200,PRV,.01)
 ..I '$D(@RET@(PRV)) S @RET@(PRV)=PRV_U_PRVNAME_U_"S"
 ..E  D
 ...S X=$P($G(@RET@(PRV)),U,3)
 ...S X=X_"C"
 ...S @RET@(PRV)=PRV_U_PRVNAME_U_X
 ;Education
 Q
 ;Input
 ;DFN of patient
 ;Problem IEN
 ;Provider IEN
 ;Number to return
PRVDATA(DATA,DFN,PROB,PRV,NUM) ;EP return data for a provider
 N CNT
 I $G(NUM)="" S NUM=1
 S CNT=0
 S DATA=$$TMPGBL
 D GET^BGOCPLAN(.DATA,PROB,DFN,"G",NUM,.CNT,PRV)
 D GET^BGOCPLAN(.DATA,PROB,DFN,"P",NUM,.CNT,PRV)
 D GET^BGOVVI(.DATA,DFN,PROB,NUM,.CNT,"",PRV)
 D GET^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"",PRV)
 D GETCON^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,PRV)
 D GETREF^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"",PRV)
 D GETEDU^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"",PRV)
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
 D GET^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GETCON^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"")
 D GETREF^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 D GETEDU^BGOVTR(.DATA,DFN,PROB,NUM,.CNT,"","")
 Q
 ;EIE can only be done by the author or the chief of MIS
 ;Input = IEN of the entry [1] ^ user deleting [2]
OKDEL(RET,IEN,USER) ;EP  Can this user delete
 N PRV,ENTRYDT,ERR
 S RET=0
 I $G(USER)="" S USER=DUZ
 S PRV=$$GET1^DIQ(9000010.58,IEN,1204,"I")
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
 S FNUM=9000010.58
 S IEN2=IENS_","
 S FDA=$NA(FDA(FNUM,IEN2))
 S @FDA@(.06)=1
 S @FDA@(.07)=DUZ
 S @FDA@(.08)=$$NOW^XLFDT()
 S @FDA@(.08)=REASON
 S @FDA@(.09)=CMMT
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOVIN",$J) Q $NA(^($J))
 ; Return file number
FNUM() Q 9000010.58
