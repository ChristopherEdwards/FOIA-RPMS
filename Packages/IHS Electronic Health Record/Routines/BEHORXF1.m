BEHORXF1 ;MSC/IND/PLS - Continuation of BEHORXFN ;22-Sep-2011 17:23;PLS
 ;;1.1;BEH COMPONENTS;**009007**;Sep 18, 2007
 ;=================================================================
 ; RPC: BEHORXF1 SFMTXML
 ; Save prescription xml format
 ;
SFMTXML(DATA,NAME,VAL,ENT) ;EP-
 S VAL=NAME
 S:$D(VAL)'=11 VAL(1,0)=""
 D EN^XPAR(ENT,"BEHORX PRINT FORMATS",NAME,.VAL,.DATA)
 Q
 ; Creates log entry for Order for Signature prints
 ; Input: ORIFN - IEN to Order File (100)
 ;
UPTLOG(DATA,ORIFN,ACTION,ARY) ;EP-
 N FDA,ERR,FN,IENS,USR
 S IENS="+1,"
 S USR=$S($G(ARY("USER")):ARY("USER"),1:DUZ)
 S DATA=0
 S FN=90460.08
 S:ACTION'=2 ARY("COM")="Order for signature printed on "_ARY("DEV")_"."
 S FDA(FN,IENS,.01)=$$NOW^XLFDT()
 S FDA(FN,IENS,.02)=ORIFN
 S FDA(FN,IENS,.03)=USR
 S FDA(FN,IENS,.04)=$S(ACTION=2:"R",1:"P")
 S FDA(FN,IENS,1)=$G(ARY("DEV"))
 S FDA(FN,IENS,2)=$G(ARY("COM"))
 D UPDATE^DIE(,"FDA",,"ERR")
 I '$D(ERR) S DATA=1
 E  S DATA="0^Unable to update log"
 Q
 ; Validate Queue List
VALQUE(DATA,ORLST) ;EP-
 ;CHECK SIGNATURE STATUS (<>2), oRDER STATUS ; EITHER PENDING or ACTIVE
 ; Package = OUTPATIENT PHARMACY
 ; Dialog = PSO OERR
 ; To = OUTPATIENT MEDICATIONS
 ; Status = Active = prescription must have AUTOFINISHED field set to YES.
 ;          Pending = OI must be CII
 ;    Who = Logged in user (DUZ)
 ;    CII = OI is CII
 ;   Type = Outpatient
 S DATA=$$TMPGBL
 N ID,LP,PKG,DLG,NOA,STS,WHO,TO,PSIFN,TYPE,ATF,CNT,ADD,OI
 S CNT=0
 S LP=0 F  S LP=$O(ORLST(LP)) Q:LP=""  D
 .S ADD=0,ID=ORLST(LP)
 .S PKG=$$GET1^DIQ(100,+ID,12)="OUTPATIENT PHARMACY"
 .S DLG=$$GET1^DIQ(100,+ID,2)="PSO OERR"
 .S TO=$$GET1^DIQ(100,+ID,23)="OUTPATIENT MEDICATIONS"
 .S TYPE=$P($G(^OR(100,+ID,0)),U,12)="O"
 .Q:'PKG!'DLG!'TO!'TYPE
 .S PSIFN=+$G(^OR(100,+ID,4))
 .Q:'PSIFN
 .S STS=$$GET1^DIQ(100,+ID,5)
 .I STS="ACTIVE" D
 ..S ATF=$P($G(^PSRX(PSIFN,999999921)),U,3)
 ..D:ATF ADDID(ID)
 .E  I STS="PENDING" D
 ..S OI=$$VALUE^ORCSAVE2(+ID,"ORDERABLE")
 ..Q:'$$ERXOI^APSPFNC6(OI,"2")
 ..D ADDID(ID)
 Q
ADDID(ID) ;EP-
 S CNT=CNT+1
 S @DATA@(CNT)=ID
 Q
 ; Return XML representation of Orders in array
ORDRSXML(DATA,ORDARY,DFN) ;EP-
 N CNT,LP
 S CNT=0
 S DATA=$$TMPGBL
 D XMLHDR
 D ORDSXML(.ORDARY)
 Q
 ; Return XML representation of Prescription
MEDXML(DATA,ORDERID,DFN,XTRA) ;EP-
 N CNT,PSIFN,LP
 S CNT=0
 S DATA=$$TMPGBL
 D XMLHDR
 D ADD($$TAG("Prescriptions",0))
 S PSIFN=$$GETPSIFN^BEHORXFN(ORDERID)
 I $D(XTRA) D
 .S LP="" F  S LP=$O(XTRA(LP)) Q:LP=""  D
 ..D ADD(XTRA(LP))
 D RXXML(PSIFN,+ORDERID,1)
 D ADD($$TAG("Prescriptions",1))
 Q
 ; Return XML representation of Prescriptions in array
MEDSXML(DATA,ORDARY,DFN) ;EP-
 N CNT,LP,ID
 S CNT=0
 S DATA=$$TMPGBL
 D XMLHDR
 D ADD($$TAG("Prescriptions",0))
 S LP=0 F  S LP=$O(ORDARY(LP)) Q:LP=""  D
 .S ID=+ORDARY(LP)
 .S PSIFN=$$GETPSIFN^BEHORXFN(ID)
 .Q:PSIFN'=+PSIFN
 .D RXXML(PSIFN,ID,1)
 D ADD($$TAG("Prescriptions",1))
 Q
 ; Return XML representation for Order, Prescription and/or Receipt
BATCHXML(DATA,ORDARY,DFN) ;EP-
 N CNT,LP,PSIFN
 S CNT=0
 S DATA=$$TMPGBL
 D XMLHDR
 D ADD($$TAG("Batch",0))
 D RXSXML(.ORDARY)
 D ORDSXML(.ORDARY)
 D RECSXML(.ORDARY)
 D ADD($$TAG("Batch",1))
 Q
RXSXML(ORDARY) ;EP-Build Prescription xml
 N ID
 D ADD($$TAG("Prescriptions",0))
 S LP=0 F  S LP=$O(ORDARY(LP)) Q:LP=""  D
 .S ID=+ORDARY(LP)
 .S PSIFN=$$GETPSIFN^BEHORXFN(ID)
 .I $$ISA("RX",PSIFN) D
 ..D RXXML(PSIFN,ID,1)
 D ADD($$TAG("Prescriptions",1))
 Q
ORDSXML(ORDARY) ;EP-Build Order XML
 N ID
 D ADD($$TAG("Orders",0))
 S LP=0 F  S LP=$O(ORDARY(LP)) Q:LP=""  D
 .S ID=+ORDARY(LP)
 .I $$ISA("OR",ID) D
 ..D ORDXML(ID)
 D ADD($$TAG("Orders",1))
 Q
RECSXML(ORDARY) ;EP-Build Receipt XML
 N PNM
 S PNM=$$GET1^DIQ(2,DFN,.01)
 S PNM=$P(PNM,",",2)_" "_$P(PNM,",")
 D ADD($$TAG("Transactions",0))
 D ADD($$TAG("PatientName",2,PNM))
 S LP=0 F  S LP=$O(ORDARY(LP)) Q:LP=""  D
 .S PSIFN=$$GETPSIFN^BEHORXFN(+ORDARY(LP))
 .I $$ISA("RC",PSIFN) D
 ..D ADDXML^BEHORXRT(PSIFN)
 D ADD($$TAG("Transactions",1))
 Q
ISA(TYPE,ID) ;EP-
 N RET,PKUP,ORDID
 S RET=0
 I TYPE="RX" D
 .;ID=RX IEN
 .;ATF,PHM,ACTIVE AND NOT PSTATE="E" - PHM not required if PICKUP is a 'P'
 .S ORDID=+$$GET1^DIQ(52,ID,39.3,"I")
 .S PKUP=$$VALUE^ORCSAVE2(ORDID,"PICKUP")
 .S RET=''$$GET1^DIQ(52,ID,9999999.23,"I")&($S(PKUP="P":1,1:''$$GET1^DIQ(52,ID,9999999.24,"I")))&('$$GET1^DIQ(52,ID,100,"I"))&($$PSTATE^BEHORXFN(ID)'="E")
 E  I TYPE="OR" D
 .;ID=ORDER IEN
 .S RET=$$GET1^DIQ(100,+ID,5)="PENDING"
 E  I TYPE="RC" D
 .;ID=RX IEN
 .S RET=$$PSTATE^BEHORXFN(ID)="E"
 Q RET
 ; Add XML record for a prescription
RXXML(RX,ORDID,ADDHDR) ;EP-
 N RXINFO,PRVIEN
 K ^TMP("PS",$J)
 D OEL^PSOORRL(DFN,RX)
 S RXINFO=$G(^TMP("PS",$J,0)),$P(RXINFO,U,2)=$P($G(^("RXN",0)),U)
 S $P(RXINFO,U,9)=$TR($G(^TMP("PS",$J,"P",0)),U,"~")
 S PRVIEN=+$P(RXINFO,U,9)
 S $P(RXINFO,U,10)=RX_"R;O"
 S $P(RXINFO,U,13)=$$GET1^DIQ(59,+$$LOC^APSPFNC2(+ORDID),.01)
 S $P(RXINFO,U,14)=$$NDCVAL^APSPFUNC(RX)
 D:$G(ADDHDR) ADD($$TAG("Prescription"))
 D ADD($$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01)))
 D ADD($$TAG("PatientHRN",2,$$HRN^AUPNPAT3(DFN,$$GET1^DIQ(59,$$GET1^DIQ(52,RX,20,"I"),100,"I"))))
 D ADD($$TAG("PatientDOB",2,$$FMTE^XLFDT($$GET1^DIQ(2,DFN,.03,"I"),9)))
 D ADD($$TAG("PatientGender",2,$$GET1^DIQ(2,DFN,.02)))
 D ADD($$TAG("PatientPhone",2,$$GET1^DIQ(2,DFN,.131)))
 D BLDPTADD(DFN)
 D ADD($$TAG("Chronic",2,$$GET1^DIQ(2,DFN,9999999.02)))
 D ADD($$TAG("DAW",2,$S($$GETDAW^BEHORXFN(ORDID):"Yes",1:"No")))
 D ADD($$TAG("DaysSupply",2,$P(RXINFO,U,7)))
 D ADD($$TAG("DrugName",2,$P(RXINFO,U)))
 D ADD($$TAG("IndCode",2,$P($$GETIND^BEHORXFN(ORDID),"~")))
 D ADD($$TAG("IndText",2,$P($$GETIND^BEHORXFN(ORDID),"~",2)))
 D ADD($$TAG("DEA",2,$$GET1^DIQ(50,$$GET1^DIQ(52,RX,6,"I"),3)))
 D ADD($$TAG("Instruct",2,$$RXINSTR()))
 D ADD($$TAG("Comment",2,$$ORDCOM(ORDID)))
 D ADD($$TAG("IssueDate",2,$$FMTE^XLFDT($P(RXINFO,U,5),9)))
 D ADD($$TAG("LastFill",2,$$FMTE^XLFDT($P(RXINFO,U,12),9)))
 D ADD($$TAG("NDC",2,$P(RXINFO,U,14)))
 ;MakeTag('OrderAction',OrderAction);
 D ADD($$TAG("OrderID",2,ORDID))
 D ADD($$TAG("PharmID",2,$P(RXINFO,U,10)))
 D ADD($$TAG("PharmSite",2,$P(RXINFO,U,13)))  ;name
 D ADD($$TAG("Provider",2,$P($P(RXINFO,U,9),"~",2)))
 D ADD($$TAG("ProviderDEA",2,$$DEAVAUS^APSPFUNC(PRVIEN)))
 D ADD($$TAG("ProvIEN",2,PRVIEN))
 D ADD($$TAG("ProviderPhone",2,$$PRVINFO(PRVIEN,.132)))
 D ADD($$TAG("ProviderFax",2,$$PRVINFO(PRVIEN,.136)))
 D ADD($$TAG("ProviderESig",2,$S($L($$PRVINFO(PRVIEN,20.4)):"Electronic Signature on File",1:"")))
 D ADD($$TAG("Quantity",2,$P(RXINFO,U,8)))
 D ADD($$TAG("Refills",2,$P(RXINFO,U,4)))
 D ADD($$TAG("RxNum",2,$P(RXINFO,U,2)))
 D ADD($$TAG("RXNorm",2,$$GETRXNRM^BEHORXFN(ORDID,RX)))
 D ADD($$TAG("Status",2,$P(RXINFO,U,6)))
 D ADD($$TAG("StopDate",2,$$FMTE^XLFDT($P(RXINFO,U,3),9)))
 D ADD($$TAG("ProcessState",2,$$PSTATE^BEHORXFN(RX)))
 D ADD($$TAG("NeedsReason",2,$$GETNDRSN($$PSTATE^BEHORXFN(RX))))
 D:$G(ADDHDR) ADD($$TAG("Prescription",1))
 Q
 ; Add XML record for an order
ORDXML(ORD) ;EP-
 N POF,DEA,PRVIEN
 D ADD($$TAG("Order"))
 D ADD($$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01)))
 D ADD($$TAG("PatientHRN",2,$$HRN^AUPNPAT3(DFN,DUZ(2))))
 D ADD($$TAG("PatientDOB",2,$$FMTE^XLFDT($$GET1^DIQ(2,DFN,.03,"I"),9)))
 D ADD($$TAG("PatientGender",2,$$GET1^DIQ(2,DFN,.02)))
 D ADD($$TAG("PatientPhone",2,$$GET1^DIQ(2,DFN,.131)))
 D BLDPTADD(DFN)
 D ADD($$TAG("Chronic",2,$S($$VALUE^ORCSAVE2(ORD,"CMF")["Y":"True",1:"False")))
 D ADD($$TAG("DAW",2,$S($$VALUE^ORCSAVE2(ORD,"DAW"):"Yes",1:"No")))
 D ADD($$TAG("DaysSupply",2,$$VALUE^ORCSAVE2(ORD,"SUPPLY")))
 D ADD($$TAG("DrugName",2,$$GET1^DIQ(50,$$VALUE^ORCSAVE2(ORD,"DRUG"),.01)))
 D ADD($$TAG("IndCode",2,$P($$GETIND^BEHORXFN(ORD),"~")))
 D ADD($$TAG("IndText",2,$P($$GETIND^BEHORXFN(ORD),"~",2)))
 D DEACLS^APSPFNC2(.DEA,ORD,"2")
 D ADD($$TAG("DEA",2,$S(DEA:"2",1:"")))
 D ADD($$TAG("OrderableItem",2,$$GET1^DIQ(101.43,$$VALUE^ORCSAVE2(ORD,"ORDERABLE"),.01)))
 D ADD($$TAG("Comment",2,$$ORDCOM(ORD)))
 S POF=$$POFIEN(ORD)
 I POF D
 .D ADD($$TAG("Instruct",2,$$ORDINSTR(POF)))
 .D ADD($$TAG("IssueDate",2,$$FMTE^XLFDT($$GET1^DIQ(52.41,POF,6,"I"))))
 .;D ADD($$TAG("LastFill",2,$$FMTE^XLFDT($P(RXINFO,U,12),9)))
 .;D ADD($$TAG("NDC",2,$P(RXINFO,U,14)))
 .;MakeTag('OrderAction',OrderAction);
 .D ADD($$TAG("OrderID",2,ORD))
 .;D ADD($$TAG("PharmID",2,$P(RXINFO,U,10)))
 .;D ADD($$TAG("PharmSite",2,$P(RXINFO,U,13)))  ;ien
 .S PRVIEN=$$GET1^DIQ(52.41,POF,5,"I")
 .D ADD($$TAG("Provider",2,$$GET1^DIQ(52.41,POF,5)))
 .D ADD($$TAG("ProviderDEA",2,$$DEAVAUS^APSPFUNC(PRVIEN)))
 .D ADD($$TAG("ProvIEN",2,PRVIEN))
 .D ADD($$TAG("ProviderPhone",2,$$PRVINFO(PRVIEN,.132)))
 .D ADD($$TAG("ProviderFax",2,$$PRVINFO(PRVIEN,.136)))
 .D ADD($$TAG("ProviderESig",2,$S($L($$PRVINFO(PRVIEN,20.4)):"Electronic Signature on File",1:"")))
 .D ADD($$TAG("Quantity",2,$$GET1^DIQ(52.41,POF,12)))
 .D ADD($$TAG("Refills",2,$$GET1^DIQ(52.41,POF,13)))
 .;D ADD($$TAG("RxNum",2,$P(RXINFO,U,2)))
 .;D ADD($$TAG("RXNorm",2,$$GETRXNRM^BEHORXFN(ORD,RX)))
 .;D ADD($$TAG("Status",2,$P(RXINFO,U,6)))
 .;D ADD($$TAG("StopDate",2,$$FMTE^XLFDT($P(RXINFO,U,3),9)))
 .;D ADD($$TAG("ProcessState",2,$$PSTATE^BEHORXFN(RX)))
 D ADD($$TAG("Order",1))
 Q
 ; Returns instruction array
RXINSTR() ;EP-
 N Y,INST,RET
 S RET="",Y=0
 ;S INST(1)=" "_$P(RXINFO,U),Y=1
 ;S:$L($P(RXINFO,U,8)) INST(1)=INST(1)_"  Qty: "_$P(RXINFO,U,8)
 ;S:$L($P(RXINFO,U,7)) INST(1)=INST(1)_" for "_$P(RXINFO,U,7)_" days"
 S I=0
 F  S I=$O(^TMP("PS",$J,"SIG",I)) Q:'I  D
 .S Y=Y+1,INST(Y)=^TMP("PS",$J,"SIG",I,0)
 ;S INST(2)=" Sig: "_$G(INST(2))
 ;F I=3:1:Y S INST(I)=" "_INST(I)
 F I=1:1:Y S RET=RET_INST(I)
 Q RET
ORDINSTR(POF) ;EP-
 N RET,LP,SIG
 S RET=""
 S LP=0 F  S LP=$O(^PS(52.41,POF,"SIG",LP)) Q:'LP  D
 .S SIG=^PS(52.41,POF,"SIG",LP,0)
 .S RET=$S($L(RET):RET_" "_SIG,1:SIG)
 Q RET
 ; Return Order Comments
ORDCOM(ORD) ;EP-
 N RET,LP,VAL,ID
 S RET=""
 S ID=$O(^OR(100,ORD,4.5,"ID","COMMENT",0))
 I ID D
 .S LP=0 F  S LP=$O(^OR(100,ORD,4.5,ID,2,LP)) Q:'LP  D
 ..S VAL=$G(^OR(100,ORD,4.5,ID,2,LP,0))
 ..S RET=$S($L(RET):RET_" "_VAL,1:VAL)
 Q RET
 ; Add data to array
ADD(VAL) ;EP-
 S CNT=CNT+1
 S @DATA@(CNT)=VAL
 Q
 ; Add XML Header to return array
XMLHDR ;
 D ADD("<?xml version=""1.0"" ?>")
 Q
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP -
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
 ; Return IEN to Pending Order File (52.41)
POFIEN(ORD) ;EP-
 N PKGID
 S PKGID=$G(^OR(100,ORD,4))
 Q:PKGID'["S" 0
 S PKGID=+PKGID
 Q:'PKGID!('$D(^PS(52.41,PKGID,0))) 0
 Q PKGID
 ; Return temp global reference
TMPGBL() N GBL
 S GBL=$NA(^TMP("BEHORXF1",$J))
 K @GBL
 Q GBL
 ; Returns NEEDREASON value
GETNDRSN(PROCESS) ;EP-
 Q $S(PROCESS="P":"True",PROCESS="E":"True",1:"False")
 ; Returns Provider information
PRVINFO(USR,FLD,FLG) ;EP-
 S FLG=$G(FLG,"E")
 Q $$GET1^DIQ(200,USR,FLD,FLG)
 ; RPC: Return a set of hospital locations
HOSPLOC(DATA,FROM,DIR,MAX,TYPE,START,END) ;EP
 N IEN,CNT,APT
 S FROM=$G(FROM),DIR=$G(DIR,1),MAX=$G(MAX,44),TYPE=$G(TYPE),CNT=0
 S START=$G(START)\1,END=$G(END)\1
 S:'END END=START
 F  S FROM=$O(^SC("B",FROM),DIR),IEN="" Q:FROM=""  D  Q:CNT'<MAX
 .F  S IEN=$O(^SC("B",FROM,IEN),DIR) Q:'IEN  D
 ..I $$ACTLOC(IEN) D
 ...I $L(TYPE) Q:$P(^SC(IEN,0),U,3)'[TYPE
 ...;I START S APT=$O(^SC(IEN,"S",START-.1))\1 Q:'APT!(APT>END)
 ...S CNT=CNT+1,DATA(CNT)=IEN_U_$P(^SC(IEN,0),U)
 Q
 ; Returns true if active hospital location
 ; LOC = IEN of hospital location
 ; DAT = optional date to check (defaults to today)
ACTLOC(LOC,DAT) ;PEP - Is active location?
 N D0,X
 S DAT=$G(DAT,DT)\1
 S X=$G(^SC(LOC,0))
 Q:'$L(X) 0                                                            ; Screen nonexistent entries
 S X=$G(^SC(LOC,"I"))
 Q:'X 1                                                                ; No inactivate date
 Q:DAT'<$P(X,U)&($P(X,U,2)=""!(DAT<$P(X,U,2))) 0                       ; Check reactivate date
 Q 1                                                                   ; Must still be active
 ; Build nodes for patient address
BLDPTADD(DFN) ;
 D ADD($$TAG("PatientAddress1",2,$$GET1^DIQ(2,DFN,.111)))
 D ADD($$TAG("PatientAddress2",2,$$GET1^DIQ(2,DFN,.112)))
 D ADD($$TAG("PatientAddress3",2,$$GET1^DIQ(2,DFN,.113)))
 D ADD($$TAG("PatientCity",2,$$GET1^DIQ(2,DFN,.114)))
 D ADD($$TAG("PatientState",2,$$GET1^DIQ(2,DFN,.115)))
 D ADD($$TAG("PatientZipCode",2,$$GET1^DIQ(2,DFN,.116)))
 Q
