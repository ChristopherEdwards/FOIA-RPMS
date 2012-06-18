APSPFNC1 ;IHS/CIA/DKM - Supporting calls for EHR ;12-Feb-2008 16:00;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1004,1006**;Sep 23, 2004
 ;=================================================================
 ; RPC: APSPFNC GETRXS
 ; Fetch list of current prescriptions
 ; DFN = Patient IEN
 ; DAYS= # days to include in search (default = 365)
 ; DATA returned as a list in the format for each script:
 ;   ~Type^PharmID^Drug^InfRate^StopDt^RefRem^TotDose^UnitDose^OrderID^Status^LastFill^Chronic^Issued^Rx #^Provider^Status Reason
 ;   <"\" or " "><Instruction Text>  where "\" indicates a new line
 ; Retrieve active inpatient & outpatient meds
GETRXS(DATA,DFN,DAYS) ;
 N ITMP,ILST,DAT
 K ^TMP("PS",$J)
 S:$G(DAYS)<1 DAYS=365
 D OCL^PSOORRL(DFN,$$FMADD^XLFDT(DT,-DAYS),"")
 S ILST=0,ITMP=""
 F  S ITMP=$O(^TMP("PS",$J,ITMP),-1) Q:'ITMP  D
 .N INSTRUCT,COMMENTS,FIELDS,TYPE,CMF,RXN,PRV,RSN,J
 .S (INSTRUCT,COMMENTS,CMF,RXN,RSN)="",FIELDS=^TMP("PS",$J,ITMP,0),PRV=$P($G(^("P",0)),U,2)
 .                                                                     ;S:$D(^OR(100,+$P(FIELDS,U,8),8,"C","XX")) $P(^(0),U,2)="*"_$P(^TMP("PS",$J,ITMP,0),U,2)
 .S TYPE=$S($P($P(FIELDS,U),";",2)="O":"OP",1:"UD")
 .S:$O(^TMP("PS",$J,ITMP,"A",0))>0 TYPE="IV"
 .S:$O(^TMP("PS",$J,ITMP,"B",0))>0 TYPE="IV"
 .I TYPE="UD" D
 ..D UDINST(.INSTRUCT,ITMP)
 ..D SETMULT(.COMMENTS,ITMP,"SIO")
 .E  I TYPE="OP" D
 ..D OPINST(.INSTRUCT,ITMP)
 ..S CMF=$$GETCMF1($P(FIELDS,U,8))
 ..S J=$P($P(FIELDS,U),";")
 ..I J["R" D
 ...S RXN=$P($G(^PSRX(+J,0)),U),J=$G(^(2))
 ...I '$P(J,U,13),$P(J,U,15) S $P(FIELDS,U,9,10)="Not Picked Up^",RSN="Returned to stock on "_$$FMTE^XLFDT($P(J,U,15))
 .E  I TYPE="IV" D
 ..D IVINST(.INSTRUCT,ITMP)
 ..D SETMULT(.COMMENTS,ITMP,"SIO")
 .S:$D(COMMENTS(1)) COMMENTS(1)="\"_COMMENTS(1)
 .S:$P(FIELDS,U,9)="HOLD" RSN=$$HLDRSN($P(FIELDS,U,8))
 .S @DATA@($$NXT)="~"_TYPE_U_$P(FIELDS,U,1,10)_U_CMF_U_$P(FIELDS,U,15)_U_RXN_U_PRV_U_RSN
 .S J=0
 .F  S J=+$O(INSTRUCT(J)) Q:'J  S @DATA@($$NXT)=INSTRUCT(J)
 .F  S J=+$O(COMMENTS(J)) Q:'J  S @DATA@($$NXT)="t"_COMMENTS(J)
 K ^TMP("PS",$J)
 Q
 ; Increment ILST
NXT() S ILST=ILST+1
 Q ILST
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
GETCMF1(ORIFN) ;
 N PSIFN
 S PSIFN=$$GETPSIFN(ORIFN)
 Q:PSIFN=+PSIFN $$GET1^DIQ(52,PSIFN,9999999.02)["Y"
 Q $$VALUE^ORCSAVE2(+ORIFN,"CMF")["Y"
 ; Get pharmacy IFN from order IFN
GETPSIFN(ORIFN) ;
 N PKG,PSIFN
 S PKG=+$P($G(^OR(100,+ORIFN,0)),U,14),PSIFN=$P($G(^(4)),U)
 Q $S('PSIFN!(PKG'=$O(^DIC(9.4,"C","PSO",0))):"",1:PSIFN)
 ; RPC: APSPFNC SETCMF
 ; Set chronic med flag for one or more prescriptions
 ; DFN = Patient IEN
 ; RXS = Order ID or list of order IDs
 ; CMF = New value for chronic med flag (0 or 1)
 ; DATA returned as list of errors in format:
 ;   OrderID^Error Text
SETCMF(DATA,DFN,RXS,CMF) ;EP
 N LP,FDA,FDX,ERR,PLC,ORIFN,X
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
 I $P($G(^OR(100,+ORIFN,0)),U,2)'=(DFN_";DPT(") D  Q
 .D ADDERR("Prescription does not belong to current patient.")
 S PSIFN=$$GETPSIFN(ORIFN)
 I 'PSIFN D ADDERR("Not a pharmacy order.") Q
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
 S DATA(1+$O(DATA(""),-1))=ORIFN_U_TXT
 Q
 ; Assembles instructions for a unit dose order
UDINST(Y,INDEX) ;
 N I,X
 S X=^TMP("PS",$J,INDEX,0)
 S Y(1)=" "_$P(X,U,2),Y=1
 S X=$S($L($P(X,U,6)):$P(X,U,6),1:$P(X,U,7))
 I $L(X) S Y=2,Y(2)=X
 E  S Y=1 D SETMULT(.Y,INDEX,"SIG")
 S Y(2)="\Give: "_$G(Y(2)),Y=$G(Y,2)
 D SETMULT(.Y,INDEX,"MDR"),SETMULT(.Y,INDEX,"SCH")
 F I=3:1:Y S Y(I)=" "_Y(I)
 Q
 ; Assembles instructions for an outpatient prescription
OPINST(Y,INDEX) ;
 N I,X
 S X=^TMP("PS",$J,INDEX,0)
 S Y(1)=" "_$P(X,U,2),Y=1
 S:$L($P(X,U,12)) Y(1)=Y(1)_"  Qty: "_$P(X,U,12)
 S:$L($P(X,U,11)) Y(1)=Y(1)_" for "_$P(X,U,11)_" days"
 D SETMULT(.Y,INDEX,"SIG")
 I Y=1 D
 .D SETMULT(.Y,INDEX,"SIO")
 .D SETMULT(.Y,INDEX,"MDR")
 .D SETMULT(.Y,INDEX,"SCH")
 S Y(2)="\ Sig: "_$G(Y(2))
 F I=3:1:Y S Y(I)=" "_Y(I)
 Q
 ; Assembles instructions for an IV order
IVINST(Y,INDEX) ;
 N SOLN1,I
 S Y=0
 D SETMULT(.Y,INDEX,"A")
 S SOLN1=Y+1
 D SETMULT(.Y,INDEX,"B")
 I $D(Y(SOLN1)),$L($P(FIELDS,U,2)) S Y(SOLN1)="in "_Y(SOLN1)
 S SOLN1=Y+1
 D SETMULT(.Y,INDEX,"SCH")
 S:$D(Y(SOLN1)) Y(SOLN1)=" "_Y(SOLN1)
 F I=1:1:Y S Y(I)="\"_$TR(Y(I),U," ")
 S:$D(Y(1)) Y(1)=" "_$E(Y(1),2,999)
 S Y(Y)=Y(Y)_" "_$P(^TMP("PS",$J,INDEX,0),U,3)
 Q
 ; Appends the multiple at the subscript to Y
SETMULT(Y,INDEX,SUB) ;
 N I
 S I=0
 F  S I=$O(^TMP("PS",$J,INDEX,SUB,I)) Q:'I  D
 .S Y=Y+1,Y(Y)=^TMP("PS",$J,INDEX,SUB,I,0)
 Q
 ; Return Activity Log items for given prescription
ACTLOG(DATA,RX) ;EP
 N AIEN,A0,CNT
 S CNT=0
 S AIEN=0 F  S AIEN=$O(^PSRX(RX,"A",AIEN)) Q:'AIEN  D
 .S A0=^PSRX(RX,"A",AIEN,0)
 .S CNT=CNT+1
 .S DATA(CNT)=AIEN_U_A0
 Q
