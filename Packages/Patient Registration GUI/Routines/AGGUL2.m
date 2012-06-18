AGGUL2 ;VNGT/HS/ALA-Utility Program ; 26 May 2010  12:12 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
RHI(DFN) ; EP - Restricted Health Information Status
 NEW IEN,RESULT,STAT,DATE,OFFICL,TEXT
 S RESULT=""
 S IEN=$O(^AUPNRHI("B",DFN,""))
 I IEN'="" D
 . S STAT=$P(^AUPNRHI(IEN,0),U,3)
 . S FLD=$S(STAT="P":.11,STAT="A":.21,STAT="R":.41,STAT="N":.31,STAT="E":.52,1:"")
 . I FLD="" S DATE=""
 . I FLD'="" S DATE=$$FMTE^AGGUL1($$GET1^DIQ(9000039,IEN_",",FLD,"I"))
 . S FLD=$S(STAT="A":.22,STAT="R":.42,STAT="N":.32,1:"")
 . I FLD="" S OFFICL=""
 . I FLD'="" S OFFICL=$$GET1^DIQ(9000039,IEN_",",FLD,"E")
 . S TEXT=$$GET1^DIQ(9000039,IEN_",",.02,"E")
 . S RESULT=STAT_$C(28)_$$GET1^DIQ(9000039,IEN_",",.03,"E")_U_DATE_U_OFFICL_U_TEXT
 Q RESULT
 ;
ISREQ(FILE,FIELD) ; EP - Is the field required
 NEW RETURN,FLDNAM,RGN,RGFN,VAL
 I FIELD?.N D FIELD^DID(FILE,FIELD,,"LABEL","RETURN","ERROR") S FLDNAM=RETURN("LABEL")
 E  S FLDNM=FIELD
 S RGN=$O(^AGFAC(DUZ(2),11,"B",FILE,"")) I RGN="" Q
 S RGFN=$O(^AGFAC(DUZ(2),11,RGN,1,"B",FLDNM,"")) I RGFN="" Q
 S VAL=$P(^AGFAC(DUZ(2),11,RGN,1,RGFN,0),U,2)
 Q VAL
 ;
HRNL(DFN) ;EP - List of HRNs for a patient
 NEW HRN,LOC,HDATA,ABR,VAL,ULOC,DVAL
 S LOC=0,VAL=""
 S DVAL=$$HLK(DUZ(2)),DVAL=$$TKO^AGGUL1(DVAL,"-")
 I DVAL'="" S VAL=VAL_DVAL_";"
 F  S LOC=$O(^AUPNPAT(DFN,41,LOC)) Q:'LOC  D
 . Q:LOC=DUZ(2)
 . S DVAL=$$HLK(LOC),DVAL=$$TKO^AGGUL1(DVAL,"-")
 . I DVAL'="" S VAL=VAL_DVAL_";"
 Q $$TKO^AGGUL1(VAL,";")
 ;
HLK(ULOC) ; EP - Get HRN data for a location
 NEW HDATA,IACT
 S HDATA=$G(^AUPNPAT(DFN,41,ULOC,0))
 S HRN=$P(HDATA,U,2),IACT=$P(HDATA,U,3)
 I HRN="" Q ""
 ;S ABR=$P($G(^AUTTLOC(ULOC,1)),U,2)
 S ABR=$P(^AUTTLOC(ULOC,0),U,7)
 I IACT'="" S HRN="*"_HRN
 Q HRN_"-"_ABR
 ;
COUN(DFN) ;EP - Get the county of the patient's current community
 NEW COMM
 S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I") I COMM="" Q ""
 Q $$GET1^DIQ(9999999.05,COMM_",",.02,"E")
 ;
RHH(DFN) ; EP - Header RHI display
 NEW VAL
 S VAL=$P($$RHI(DFN),U,1)
 S VAL=$P(VAL,$C(28),2)
 I VAL="APPROVED" S VAL="YES" Q VAL
 I VAL="REVOKED" Q VAL
 Q ""
 ;
RHD(DFN) ;EP - Header RHI date
 NEW VAL,STAT
 S VAL=$$RHI(DFN)
 S STAT=$P(VAL,U,1),STAT=$P(STAT,$C(28),2)
 ;I $P(VAL,U,1)["APPROVED"!($P(VAL,U,1)["REVOKED") S VAL=$P(VAL,U,2) Q VAL
 I STAT="APPROVED" S VAL=$P(VAL,U,2) Q VAL
 I STAT="REVOKED" S VAL=$P(VAL,U,2) Q VAL
 Q ""
 ;
PVID(IENS,FLD) ;EP - Get effective or expiration date for a policy holder
 I $G(IENS)="" Q ""
 NEW POLIEN
 S POLIEN=$$GET1^DIQ(9000006.11,IENS,.08,"I")
 I POLIEN="" Q ""
 I FLD=.18,$$GET1^DIQ(9000003.1,POLIEN_",",FLD,"I")>DT Q ""
 Q $$FMTE^AGGUL1($$GET1^DIQ(9000003.1,POLIEN_",",FLD,"I"))
 ;
INS(IENS,COL) ;EP - Get insurance data for column
 I $G(IENS)="" Q ""
 NEW DATA,INS,II,INN,STATUS,TYP,ST
 S INN=$$GET1^DIQ(9000006.11,IENS,.01,"I")
 I INN="" Q ""
 S II=0,DATA="XX"
 D RET^AGGINSUR(INN)
 I $G(INS)="" Q ""
 I $G(COL)=1 Q $P(INS,U,2)
 I $G(COL)=3 Q $P(INS,U,6)
 S ST=$P(INS,U,4) I ST'="" S ST=$P(^DIC(5,ST,0),U,2)
 Q $P(INS,U,3)_", "_ST_" "_$P(INS,U,5)
 ;
OTQT(DFN,OTHQTM,MIEN) ;EP - Other Tribe Quantum Total
 ; DFN - PATIENT IEN
 ; MIEN - IEN of Other Tribe multiple (if existing record is being updated)
 ; OTHQTM -  other tribe quantum
 ;
 S MIEN=$G(MIEN)
 N I,TOT,F1,F2,IBQTM,DAT,TQTM
 S TOT=0,I=0
 S IBQTM=$$GET1^DIQ(9000001,DFN_",",1110,"E")
 S TQTM=$$GET1^DIQ(9000001,DFN_",",1109,"E")
 ; Pull main tribe quantum value
 I TQTM="FULL" S TOT=TOT+1
 I TQTM["/" D  Q:$G(RESULT)=-1
 . S F1=$P(TQTM,"/"),F2=$P(TQTM,"/",2)
 . I +F2=0 S RESULT=-1,MSG="Division by zero" Q
 . S TOT=TOT+(F1/F2)
 ;
 F  S I=$O(^AUPNPAT(DFN,43,I)) Q:I=""  D
 . I MIEN=I Q  ; Don't count information from existing record if it is being updated
 . S DAT=$P($G(^AUPNPAT(DFN,43,I,0)),U,2)
 . I DAT="FULL" S TOT=TOT+1 Q
 . I DAT["/" D  Q:$G(RESULT)=-1
 .. S F1=$P(DAT,"/"),F2=$P(DAT,"/",2)
 .. I +F2=0 S RESULT=-1,MSG="Division by zero" Q
 .. S TOT=TOT+(F1/F2)
 ; add calculation for new quantum
 I OTHQTM="FULL" S TOT=TOT+1
 I OTHQTM["/" D  Q:$G(RESULT)=-1
 . S F1=$P(OTHQTM,"/"),F2=$P(OTHQTM,"/",2)
 . I +F2=0 S RESULT=-1,MSG="Division by zero" Q
 . S TOT=TOT+(F1/F2)
 I TOT>1 S RESULT=-1,MSG="Quantum over 100%" Q
 I IBQTM["/" D  Q:$G(RESULT)=-1
 . S F1=$P(IBQTM,"/"),F2=$P(IBQTM,"/",2)
 . I +F2=0 S RESULT=-1,MSG="Division by zero" Q
 . I TOT>(F1/F2) S RESULT=-1,MSG="Quantum total too large, greater than Indian blood quantum" Q
 S RESULT=1
 Q
 ;
QNT ;EP - Check Blood Quantum
 ; Expects
 ;   DFN - Patient IEN
 ;   IBQ - Indian Blood Quantum
 ;   TBQ - Tribal Blood Quantum
 ;   OTQ - Other Tribe Blood Quantum
 ;
 NEW N1,N2,TOT,TRB,T1,T2,OTOT,OTT,OTQ,O1,O2
 ; 
 D
 . I IBQ="" S TOT=0 Q
 . I IBQ="FULL"!(IBQ="F") S TOT=1 Q
 . I IBQ="NONE"!(IBQ="UNKNOWN")!(IBQ="UNSPECIFIED") S TOT=0 Q
 . S N1=$P(IBQ,"/",1),N2=$P(IBQ,"/",2)
 . S TOT=N1/N2
 ;
 D
 . I TBQ="" S TRB=0 Q
 . I TBQ="FULL"!(TBQ="F") S TRB=1 Q
 . I TBQ="NONE"!(TBQ="UNKNOWN")!(TBQ="UNSPECIFIED") S TRB=0 Q
 . S T1=$P(TBQ,"/",1),T2=$P(TBQ,"/",2)
 . S TRB=T1/T2
 ;
 S OTOT=0
 I $G(OTQ)'="" D
 . I OTQ="FULL"!(OTQ="F") S OTOT=1 Q
 . I OTQ="NONE"!(OTQ="UNKNOWN")!(OTQ="UNSPECIFIED") S OTOT=0 Q
 . S O1=$P(OTQ,"/",1),O2=$P(OTQ,"/",2)
 . S OTOT=OTOT+(O1/O2)
 ;
 I $O(^AUPNPAT(DFN,43,0))'="" D
 . S OTT=0
 . F  S OTT=$O(^AUPNPAT(DFN,43,OTT)) Q:'OTT  D
 .. S OTQ=$P($G(^AUPNPAT(DFN,43,OTT,0)),U,2)
 .. I OTQ="" S OTOT=0 Q
 .. I OTQ="FULL"!(OTQ="F") S OTOT=1 Q
 .. I OTQ="NONE"!(OTQ="UNKNOWN")!(OTQ="UNSPECIFIED") S OTOT=0 Q
 .. S O1=$P(OTQ,"/",1),O2=$P(OTQ,"/",2)
 .. S OTOT=OTOT+(O1/O2)
 I (OTOT+TRB)>TOT S RESULT=-1,MSG="Tribe and Other Tribe Quantums do not add up to Indian Blood Quantum"
 S RESULT=1
 Q
 ;
QUANT(AGGPTBLQ,AGGPTTRQ,OTHTOT) ;EP - New Quantum Blood Checks
 ;
 ;Input
 ; AGGPTBLQ - Indian Blood Quantum
 ; AGGPTTRQ - Tribal Blood Quantum
 ; OTHTOT - Other Tribe Blood Quantum (Totals including new entry)
 ; 
 ;Output
 ; RESULT - PIECE 1 - 1 for success, -1 for failure
 ;          PIECE 2 - ERROR MESSAGE ON FAILURE
 ;
 NEW N1,N2,TOT,TRB,T1,T2,RESULT
 ; 
 D
 . I AGGPTBLQ="" S TOT=0 Q
 . I AGGPTBLQ="FULL"!(AGGPTBLQ="F") S TOT=1 Q
 . I AGGPTBLQ="NONE"!(AGGPTBLQ="UNKNOWN")!(AGGPTBLQ="UNSPECIFIED") S TOT=0 Q
 . I AGGPTBLQ'["/" S TOT=0 Q
 . S N1=$P(AGGPTBLQ,"/",1),N2=$P(AGGPTBLQ,"/",2) I +N2=0 S TOT=0 Q
 . S TOT=N1/N2
 ;
 D
 . I AGGPTTRQ="" S TRB=0 Q
 . I AGGPTTRQ="FULL"!(AGGPTTRQ="F") S TRB=1 Q
 . I AGGPTTRQ="NONE"!(AGGPTTRQ="UNKNOWN")!(AGGPTTRQ="UNSPECIFIED") S TRB=0 Q
 . I AGGPTTRQ'["/" S TRB=0 Q
 . S T1=$P(AGGPTTRQ,"/",1),T2=$P(AGGPTTRQ,"/",2) I +T2=0 S TRB=0 Q
 . S TRB=T1/T2
 ;
 I (OTHTOT+TRB)>TOT S RESULT="-1^Sum of Tribe and Other Tribe Quantums is greater than the Indian Blood Quantum" Q RESULT
 S RESULT="1^"
 Q RESULT
 ;
ECZP(AGGECZIP) ;EP - Update emergency contact zip code
 NEW FIELD,OFLD
 S AGGECZIP=$$STRIP^XLFSTR($G(AGGECZIP),"-")
 S FIELD=$S($L(AGGECZIP)>5:.2204,1:.338)
 S AGGDATAI(2,DFN_",",FIELD)=AGGECZIP
 S OFLD=$S(FIELD=.2204:.338,1:.2204)
 S AGGDATA(2,DFN_",",OFLD)="@"
 Q
 ;
NKZP(AGGNKZIP) ; EP - Update next of kin zip code
 NEW FLD,OFLD
 S AGGNKZIP=$$STRIP^XLFSTR($G(AGGNKZIP),"-")
 S FLD=$S($L(AGGNKZIP)>5:.2207,1:.218)
 S AGGDATAI(2,DFN_",",FLD)=AGGNKZIP
 S OFLD=$S(FLD=.2207:.218,1:.2207)
 S AGGDATA(2,DFN_",",OFLD)="@"
 Q
 ;
PTZP(AGGPTZIP) ; EP - Update patient zip code
 NEW FLD,OFLD
 S AGGPTZIP=$$STRIP^XLFSTR($G(AGGPTZIP),"-")
 S FLD=$S($L(AGGPTZIP)>5:.1112,1:.116)
 S AGGDATAI(2,DFN_",",FLD)=AGGPTZIP
 S OFLD=$S(FLD=.1112:.116,1:.1112)
 S AGGDATA(2,DFN_",",OFLD)="@"
 Q
