BEHORXFN ;MSC/IND/DKM/PLS - Supporting calls for EHR ;25-May-2011 10:11;DKM
 ;;1.1;BEH COMPONENTS;**009005,009006,009007**;Sep 18, 2007
 ;=================================================================
 ; RPC: BEHORXFN FINISH
 ; Finish a pending script
 ;    DFN = Patient IEN
 ;  ORIFN = Order IEN
 ;  DATA returned as:
 ;    Drug[1] ^ Rx #[2] ^ ExpDate[3] ^ RefRem[4] ^ Issue Date[5] ^ Status[6] ^
 ;    Days Supply[7] ^ Quantity[8] ^ Provider IEN~Name[9] ^ PharmID[10] ^ OrderID[11] ^
 ;    LastFill[12] ^ PharmSite[13] ^ NDC[14] ^ RXNORM[15] ^ Process State[16] ^ External Pharmacy[17]
 ;   <"\" or " "><Instruction Text>  where "\" indicates a new line
 ;
FINISH(DATA,DFN,ORIFN) ;
 N PSIFN,X,RXINFO,I,ILST,INST
 D CREATE^APSPFNC2(ORIFN,1)
 S PSIFN=$$GETPSIFN(ORIFN)
 S DATA=$$TMPGBL^CIAVMRPC
 K @DATA
 Q:'PSIFN
 K ^TMP("PS",$J)
 D OEL^PSOORRL(DFN,PSIFN)
 S ILST=0
 S RXINFO=$G(^TMP("PS",$J,0)),$P(RXINFO,U,2)=$P($G(^("RXN",0)),U)
 S $P(RXINFO,U,9)=$TR($G(^TMP("PS",$J,"P",0)),U,"~")
 S $P(RXINFO,U,10)=PSIFN_"R;O",$P(RXINFO,U,13)=$$LOC^APSPFNC2(+ORIFN)
 S $P(RXINFO,U,14)=$$NDCVAL^APSPFUNC(PSIFN)
 S $P(RXINFO,U,15)=$$GETRXNRM(+ORIFN,PSIFN)
 S $P(RXINFO,U,16)=$$PSTATE(PSIFN)
 S $P(RXINFO,U,17)=$$EPHARM(PSIFN)
 D ADDOUT(RXINFO)
 S INST(1)=" "_$P(RXINFO,U),Y=1
 S:$L($P(RXINFO,U,8)) INST(1)=INST(1)_"  Qty: "_$P(RXINFO,U,8)
 S:$L($P(RXINFO,U,7)) INST(1)=INST(1)_" for "_$P(RXINFO,U,7)_" days"
 S I=0
 F  S I=$O(^TMP("PS",$J,"SIG",I)) Q:'I  D
 .S Y=Y+1,INST(Y)=^TMP("PS",$J,"SIG",I,0)
 S INST(2)="\ Sig: "_$G(INST(2))
 F I=3:1:Y S INST(I)=" "_INST(I)
 S I=0
 F  S I=+$O(INST(I)) Q:'I  D ADDOUT(INST(I))
 K ^TMP("PS",$J)
 Q
 ; RPC: BEHORXFN PRINTLOG
 ; Log print activity
PRINTLOG(DATA,ORIFN,PRINTER,ACTION,COM) ;
 N ARY,PSIFN
 S:$L(PRINTER)>40 $E(PRINTER,1,$L(PRINTER)-37)="..."
 S PRINTER=$TR(PRINTER,U)
 I ACTION=2 D
 .S ARY("COM")=$G(COM,"Comment not provided.")
 .S ARY("TYPE")="R"
 E  D
 .S ARY("COM")=$S(ACTION:"Sample label",1:"Prescription")_" printed on "_PRINTER_"."
 .S ARY("TYPE")="P"
 S ARY("REASON")="B"
 S ARY("RX REF")=0
 S ARY("DEV")=PRINTER
 S:$L($G(COM)) ARY("COM")=COM
 S PSIFN=+$$GETPSIFN(ORIFN)
 I $$ORDFSIG(ORIFN) D
 .D UPTLOG^BEHORXF1(.DATA,ORIFN,ACTION,.ARY)
 E  D:PSIFN UPTLOG^APSPFNC2(.DATA,PSIFN,ACTION,.ARY)
 Q
 ; RPC: BEHORXFN GETRXS
 ; Fetch list of current prescriptions
 ;  DFN = Patient IEN
 ;  DAYS= # days to include in search (default = 365)
 ;  DATA returned as a list in the format for each script:
 ;
 ;   ~Type[1] ^ PharmID[2] ^ Drug[3] ^ InfRate[4] ^ StopDt[5] ^ RefRem[6] ^
 ;    TotDose[7] ^ UnitDose[8] ^ OrderID[9] ^ Status[10] ^ LastFill[11] ^
 ;    Days Supply[12] ^ Quantity[13] ^ Chronic[14] ^ Issued[15] ^
 ;    Rx #[16] ^ Provider IEN~Name[17] ^ Status Reason[18] ^ DEA Handling[19] ^
 ;    Pharmacy Site[20] ^ Indication ICD~Text[21] ^ DAW[22] ^ NVOA[23] ^ NDC[24] ^ RXNORM[25] ^
 ;    Process State[26] ^ External Pharmacy[27]
 ;
 ;   <"\" or " "><Instruction Text>  where "\" indicates a new line
GETRXS(DATA,DFN,DAYS) ;
 D CLNNVA
 N INDEX,ILST,DAT
 K ^TMP("PS",$J)
 S:$G(DAYS)<1 DAYS=365
 D OCL^PSOORRL(DFN,$$FMADD^XLFDT(DT,-DAYS),"")
 S ILST=0,INDEX=""
 F  S INDEX=$O(^TMP("PS",$J,INDEX),-1) Q:'INDEX  D
 .N INSTRUCT,COMMENTS,FIELDS,NVSDT,TYPE,IND,CMF,RXN,PRV,REASON,DEA,IFN,DAW,J,K,X,NDC,RXNORM,ATF,EPHARM
 .S (INSTRUCT,COMMENTS,IND,CMF,RXN,REASON,DEA,DAW,NDC,RXNORM,ATF,EPHARM)=""
 .S FIELDS=^TMP("PS",$J,INDEX,0),PRV=$TR($G(^("P",0)),U,"~")
 .S IFN=+$P(FIELDS,U,8),X=$O(^OR(100,IFN,4.5,"ID","DRUG",0))
 .S:X X=+$G(^OR(100,IFN,4.5,X,1))
 .S:X DEA=$P($G(^PSDRUG(X,0)),U,3)
 .;S:$D(^OR(100,IFN,8,"C","XX")) $P(^(0),U,2)="*"_$P(^TMP("PS",$J,INDEX,0),U,2)
 .S TYPE=$S($P($P(FIELDS,U),";",2)="O":"OP",1:"UD")
 .I TYPE="OP",$P(FIELDS,";")["N" S TYPE="NV"
 .S:$O(^TMP("PS",$J,INDEX,"A",0))>0 TYPE="IV"
 .S:$O(^TMP("PS",$J,INDEX,"B",0))>0 TYPE="IV"
 .Q:$G(IFN)&$D(^TMP("PS",$J,"X",TYPE,IFN))  S ^(IFN)=""  ; OCL^PSOORRL can return dups
 .I TYPE="UD" D
 ..D UDINST(.INSTRUCT)
 ..D SETMULT(.COMMENTS,"SIO")
 .E  I TYPE="OP" D
 ..D OPINST(.INSTRUCT)
 ..S CMF=$$GETCMF1(IFN)
 ..S IND=$$GETIND(IFN)
 ..S DAW=$$GETDAW(IFN)
 ..S NDC=$$GETNDC(IFN)
 ..S RXNORM=$$GETRXNRM(IFN)
 ..S ATF=$$PSTATE(+$$GETPSIFN(IFN))
 ..S EPHARM=$$EPHARM(+$$GETPSIFN(IFN))
 ..S J=$P($P(FIELDS,U),";")
 ..I J["R" D
 ...S RXN=$P($G(^PSRX(+J,0)),U),J=$G(^(2)),K=+$G(^("STA"))
 ...I K<12,'$P(J,U,13),$P(J,U,15) S $P(FIELDS,U,9,10)="Not Picked Up^",REASON="Returned to stock on "_$$FMTE^XLFDT($P(J,U,15))
 .E  I TYPE="IV" D
 ..D IVINST(.INSTRUCT)
 ..D SETMULT(.COMMENTS,"SIO")
 .E  I TYPE="NV" D
 ..D NVINST(.INSTRUCT)
 ..D NVSTATE(.REASON,.NVSDT)
 ..D SETMULT(.COMMENTS,"SIO")
 ..S $P(FIELDS,U,9)=$$NVSTS(IFN,$P(FIELDS,U,9))
 ..S $P(FIELDS,U,15)=$G(NVSDT)
 .S:$D(COMMENTS(1)) COMMENTS(1)="\"_COMMENTS(1)
 .S:$P(FIELDS,U,9)="HOLD" REASON=$$HLDRSN(IFN)
 .D ADDOUT("~"_TYPE_U_$P(FIELDS,U,1,12)_U_CMF_U_$P(FIELDS,U,15)_U_RXN_U_PRV_U_REASON_U_DEA_U_$S(IFN:$$LOC^APSPFNC2(IFN),1:"")_U_IND_U_DAW_U_$$NVOA()_U_NDC_U_RXNORM_U_ATF_U_EPHARM)
 .S J=0
 .F  S J=+$O(INSTRUCT(J)) Q:'J  D ADDOUT(INSTRUCT(J))
 .F  S J=+$O(COMMENTS(J)) Q:'J  D ADDOUT("t"_COMMENTS(J))
 .F  S J=+$O(REASON(J)) Q:'J  D ADDOUT("t"_REASON(J))
 K ^TMP("PS",$J)
 Q
 ; Add to output
ADDOUT(X) ;
 S ILST=ILST+1,@DATA@(ILST)=X
 Q
 ; Assembles instructions for a unit dose order
UDINST(Y) ;
 N I,X
 S X=FIELDS
 S Y(1)=" "_$P(X,U,2),Y=1
 S X=$S($L($P(X,U,6)):$P(X,U,6),1:$P(X,U,7))
 I $L(X) S Y=2,Y(2)=X
 E  S Y=1 D SETMULT(.Y,"SIG")
 S Y(2)="\Give: "_$G(Y(2)),Y=$G(Y,2)
 D SETMULT(.Y,"MDR"),SETMULT(.Y,"SCH")
 F I=3:1:Y S Y(I)=" "_Y(I)
 Q
 ; Assembles instructions for an outpatient prescription
OPINST(Y) ;
 N I,X
 S X=FIELDS
 S Y(1)=" "_$P(X,U,2),Y=1
 S:$L($P(X,U,12)) Y(1)=Y(1)_"  Qty: "_$P(X,U,12)
 S:$L($P(X,U,11)) Y(1)=Y(1)_" for "_$P(X,U,11)_" days"
 D SETMULT(.Y,"SIG")
 I Y=1 D
 .D SETMULT(.Y,"SIO")
 .D SETMULT(.Y,"MDR")
 .D SETMULT(.Y,"SCH")
 S Y(2)="\ Sig: "_$G(Y(2))
 F I=3:1:Y S Y(I)=" "_Y(I)
 Q
 ; Assembles instructions for an IV order
IVINST(Y) ;
 N SOLN1,I
 S Y=0
 D SETMULT(.Y,"A")
 S SOLN1=Y+1
 D SETMULT(.Y,"B")
 I $D(Y(SOLN1)),$L($P(FIELDS,U,2)) S Y(SOLN1)="in "_Y(SOLN1)
 S SOLN1=Y+1
 D SETMULT(.Y,"SCH")
 S:$D(Y(SOLN1)) Y(SOLN1)=" "_Y(SOLN1)
 F I=1:1:Y S Y(I)="\"_$TR(Y(I),U," ")
 S:$D(Y(1)) Y(1)=" "_$E(Y(1),2,999)
 S Y(Y)=Y(Y)_" "_$P(FIELDS,U,3)
 Q
 ; Assembles instructions for a home med
NVINST(Y) ;
 N I
 S Y(1)=" "_$P(FIELDS,U,2),Y=1
 D SETMULT(.Y,"SIG")
 I Y=1 D
 .D SETMULT(.Y,"SIO")
 .D SETMULT(.Y,"MDR")
 .D SETMULT(.Y,"SCH")
 S Y(2)="\ "_$G(Y(2))
 F I=3:1:Y S Y(I)=" "_Y(I)
 Q
 ; Assembles start date and reasons for a home med
NVSTATE(Y,NVSDT) ;
 N ORN
 S ORN=+$P(FIELDS,U,8)
 I $D(^OR(100,ORN,0)) D
 .S NVSDT=$P(^OR(100,ORN,0),U,8)
 .D WPVAL(.Y,ORN,"STATEMENTS")
 Q
 ; Return Non-VA med validate order action
NVOA() ;EP -
 N ORN,OA
 S ORN=+$P(FIELDS,U,8)
 S OA=$P($G(^OR(100,ORN,8,1,0)),U,2)
 Q $S(OA="VA":OA,1:"")
 ; Return status for home med
NVSTS(IFN,STS) ;EP -
 N OSTS
 S OSTS=$$GET1^DIQ(100,IFN,5,"I")
 Q $S((OSTS>21399)!(OSTS=3):$$GET1^DIQ(100.01,OSTS,.01),1:STS)
 ;  Return word processing value
WPVAL(Y,ORN,ID) ;
 N DA,I,J
 S DA=+$O(^OR(100,ORN,4.5,"ID",ID,0)),(I,J)=0
 F  S I=$O(^OR(100,ORN,4.5,DA,2,I)) Q:'I  S J=J+1,Y(J)=^(I,0)
 Q
 ; Appends the multiple at the subscript to Y
SETMULT(Y,SUB) ;
 N I
 S I=0
 F  S I=$O(^TMP("PS",$J,INDEX,SUB,I)) Q:'I  D
 .S Y=Y+1,Y(Y)=^TMP("PS",$J,INDEX,SUB,I,0)
 Q
 ; Return hold reason
HLDRSN(ORIFN) ;
 N RSN,PSIFN,X
 S X=$O(^OR(100,+ORIFN,8,"C","HD",""),-1)
 S:$O(^OR(100,+ORIFN,8,"C","RL",X)) X=""
 S RSN=$S('X:"",1:$G(^OR(100,+ORIFN,8,X,1)))
 S PSIFN=$$GETPSIFN(ORIFN)
 I PSIFN=+PSIFN D
 .S X=$$GET1^DIQ(52,PSIFN,99.1)
 .S:'$L(X) X=$$GET1^DIQ(52,PSIFN,99),X=$S($E(X,1,5)="OTHER":"",1:X)
 .S:$L(X) RSN=X
 Q "Hold Reason:  "_$S($L(RSN):RSN,1:"Not specified")
 ; Return chronic med flag from order IFN
GETCMF1(ORIFN) ;EP
 N PSIFN
 S PSIFN=$$GETPSIFN(ORIFN)
 Q:PSIFN=+PSIFN $$GET1^DIQ(52,PSIFN,9999999.02)["Y"
 Q $$VALUE^ORCSAVE2(+ORIFN,"CMF")["Y"
 ; Return clinical indication from order IFN
GETIND(ORIFN) ;EP
 N PSIFN,ICD,TXT
 S PSIFN=$$GETPSIFN(ORIFN)
 I PSIFN=+PSIFN D
 .S TXT=$$GET1^DIQ(52,PSIFN,9999999.21)
 .S ICD=$$GET1^DIQ(52,PSIFN,9999999.22)
 E  D
 .S TXT=$$VALUE^ORCSAVE2(+ORIFN,"CLININD")
 .S ICD=$$VALUE^ORCSAVE2(+ORIFN,"CLININD2")
 Q $S($L(TXT)!$L(ICD):ICD_"~"_TXT,1:"")
 ; Return dispense as written (DAW) flag from order IFN
GETDAW(ORIFN) ;EP
 N PSIFN,DAW
 S PSIFN=$$GETPSIFN(ORIFN)
 I PSIFN=+PSIFN S DAW=$$GET1^DIQ(52,PSIFN,9999999.25,"I")
 E  S DAW=$$VALUE^ORCSAVE2(+ORIFN,"DAW")
 Q $S(DAW=7:1,DAW>1:0,1:+DAW)
 ; Return NDC value associated with Prescription
GETNDC(ORIFN) ;EP
 N PSIFN,NDC
 S NDC=""
 S PSIFN=$$GETPSIFN(ORIFN)
 S:PSIFN=+PSIFN NDC=$$NDCVAL^APSPFUNC(PSIFN)
 Q NDC
 ; Return RXNORM value associated with NDC
GETRXNRM(ORIFN,PSIFN) ;EP
 N RXNORM,NDC
 S RXNORM=""
 S PSIFN=$G(PSIFN,$$GETPSIFN(ORIFN))
 I PSIFN=+PSIFN D
 .S NDC=$TR($$NDCVAL^APSPFUNC(PSIFN),"-","")
 .Q:'$L(NDC)
 .S RXNORM=+$O(^C0CRXN(176.002,"NDC",NDC,0))
 .S RXNORM=$$GET1^DIQ(176.002,RXNORM,.01)
 Q RXNORM
 ; Return process state of E, Q, P, or I
PSTATE(PSIFN) ;EP-
 N RES,ATF,PMY,PRT
 S RES=""
 S ATF=$$GET1^DIQ(52,PSIFN,9999999.23,"I")  ;autofinish
 S PMY=$$GET1^DIQ(52,PSIFN,9999999.24,"I")  ;pharmacy
 I 'ATF S RES="I"
 E  D
 .S PRT=$$CKRXACT^APSPFNC6(PSIFN,"B","PR")
 .I PMY D
 ..; if pharmacy and either transmitted or failed to transmit and no print then return E
 ..; else
 ..I $$CKRXACT^APSPFNC6(PSIFN,"X","T")!($$CKRXACT^APSPFNC6(PSIFN,"X","F"))&('PRT) S RES="E"
 ..E  S RES=$S(PRT:"P",1:"Q")
 .E  D
 ..S RES=$S(PRT:"P",1:"Q")
 Q RES
 ; Return external pharmacy information
EPHARM(PSIFN) ;EP-
 Q $$GET1^DIQ(52,PSIFN,9999999.24,"I")_";"_$$GET1^DIQ(52,PSIFN,9999999.24)
 ; Get pharmacy IFN from order IFN
GETPSIFN(ORIFN) ;
 N PKG,PSIFN
 S PKG=+$P($G(^OR(100,+ORIFN,0)),U,14),PSIFN=$P($G(^(4)),U)
 Q $S('PSIFN!(PKG'=$O(^DIC(9.4,"C","PSO",0))):"",1:PSIFN)
 ; RPC: BEHORXFN SETCMF
 ; Set chronic med flag for one or more prescriptions
 ; DFN = Patient IEN
 ; RXS = Order ID or list of order IDs
 ; CMF = New value for chronic med flag (0 or 1)
 ; DATA returned as list in format:
 ;   OrderID^Error Text (null if no error)
SETCMF(DATA,DFN,RXS,CMF) ;EP
 N LP,FDA,FDX,ERR,PLC,ORIFN,IDS,X
 S:$L($G(RXS)) RXS(-1)=RXS
 S LP="",PLC=0
 F  S LP=$O(RXS(LP)) Q:'$L(LP)  D SETCMF1(RXS(LP))
 D:$D(FDA) UPDATE^DIE("E","FDA",,"ERR")
 F  S LP=$O(ERR("DIERR",LP)) Q:'LP  D
 .S ORIFN=FDX($G(ERR("DIERR",LP,"PARAM","FILE"),100.045),ERR("DIERR",LP,"PARAM","IENS"))
 .D ADDERR(ERR("DIERR",LP,"TEXT",1))
 Q
 ; Set CMF flag in FDA array for specified order and associated script
SETCMF1(ORIFN) ;
 N PSIFN,OK
 S IDS(ORIFN)=LP,DATA(LP)=ORIFN
 I $P($G(^OR(100,+ORIFN,0)),U,2)'=(DFN_";DPT(") D  Q
 .D ADDERR("Prescription does not belong to current patient.")
 S PSIFN=$$GETPSIFN(ORIFN)
 D:PSIFN=+PSIFN ADDFDA(52,PSIFN_",",9999999.02)                        ; Set CMF on script
 S OK=+$O(^OR(100,+ORIFN,4.5,"ID","CMF",0))                            ; Find CMF prompt on order
 I OK D                                                                ; If prompt found, change response
 .D ADDFDA(100.045,OK_","_+ORIFN_",",1)
 E  D                                                                  ; Else add prompt and set response
 .N X,DLG,PMT,CMI,CMN,IENS
 .S DLG=$P($G(^OR(100,+ORIFN,0)),U,5)
 .Q:DLG'[";ORD(101.41,"
 .S DLG=+DLG,CMI=+$O(^ORD(101.41,"B","OR GTX CMF",0))
 .S CMN=$O(^ORD(101.41,DLG,10,"D",CMI,0))
 .Q:'CMN
 .S PLC=PLC+1,IENS="+"_PLC_","_+ORIFN_",",OK=1
 .S FDA(100.045,IENS,.01)=CMN
 .S FDA(100.045,IENS,.02)="`"_CMI
 .S FDA(100.045,IENS,.03)=1
 .S FDA(100.045,IENS,.04)="CMF"
 .D ADDFDA(100.045,IENS,1)
 D:'OK ADDERR("Cannot set chronic med status on this order.")
 Q
 ; Add to FDA array
ADDFDA(FN,IENS,FLD) ;
 S FDA(FN,IENS,FLD)=$S(CMF:"Y",1:"N"),FDX(FN,IENS)=ORIFN
 Q
 ; Add error text
ADDERR(TXT) ;
 S DATA(IDS(ORIFN))=ORIFN_U_TXT
 Q
 ; Get list of active/pending med orders for order checking
OCALL(DATA,DFN) ;EP
 N CNT,OBJ,ORIEN,ORLOG,X
 S OBJ=DFN_";DPT(",(CNT,ORLOG)=0,DATA=$$TMPGBL^CIAVMRPC
 F  S ORLOG=$O(^OR(100,"AC",OBJ,ORLOG)) Q:'ORLOG  D
 .S ORIEN=0
 .F  S ORIEN=$O(^OR(100,"AC",OBJ,ORLOG,ORIEN)) Q:'ORIEN  D
 ..Q:$D(@DATA@(0,ORIEN))
 ..S @DATA@(0,ORIEN)=""
 ..S X=$G(^OR(100,ORIEN,0)),ST=$P($G(^(3)),U,3)
 ..I ST'=5,ST'=6,ST'=11 Q
 ..Q:$P(X,U,2)'=OBJ
 ..S PKG=$$GET1^DIQ(9.4,$P(X,U,14),1)
 ..Q:$E(PKG,1,2)'="PS"
 ..S CNT=CNT+1,@DATA@(CNT)=ORIEN
 K @DATA@(0)
 Q
 ; Cleanup PCC Link in NVA node
CLNNVA ;EP -
 Q:$$PATCH^XPDUTL("APSP*7.0*1009")
 N DFN,IEN,FDA,NVAERR
 S DFN=0 F  S DFN=$O(^PS(55,"APCC","+1",DFN)) Q:'DFN  D
 .S IEN=0 F  S IEN=$O(^PS(55,"APCC","+1",DFN,IEN)) Q:'IEN  D
 ..S FDA(55.05,IEN_","_DFN_",",9999999.11)="@"
 D:$D(FDA) UPDATE^DIE("","FDA",,"NVAERR")
 Q
 ; Returns boolean flag indicating if order is Order For Signature
ORDFSIG(ORIFN) ;EP-
 N ORD
 S ORD=$G(^OR(100,ORIFN,4))
 Q (ORD?.N1"S")&($P($G(^OR(100,ORIFN,3)),U,3)=5)
