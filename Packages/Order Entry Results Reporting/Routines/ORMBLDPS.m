ORMBLDPS ;SLC/MKB-Build outgoing Pharmacy ORM msgs ;06-Aug-2010 06:42;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**7,38,54,86,97,94,116,129,141,190,1006**;Dec 17, 1997
 ;Modified - IHS/MSC/PLS - 08/06/2010 - Line ZRN+10
PTR(NAME) ; -- Returns ptr value of prompt in Dialog file
 Q +$O(^ORD(101.41,"AB",$E("OR GTX "_NAME,1,63),0))
 ;
NVA ; -- new Non-VA Meds order
 N NVA S NVA=1
OUT ; -- new Outpt Meds order
 ;    fall through to UD: same msg, +3 fields
UD ; -- new Inpt (Unit Dose) Meds order
 N OI,DRUG,INSTR,DOSE,ROUTE,SCHED,DUR,URG,PROVCOMM,PI,DISPENSE,X,Y,I,J,K,L,QT1,QT2,QT3,QT4,QT6,QT9,CONJ,ORC,SC,OUTPT
 S OUTPT=$S($P(OR0,U,12)="O":1,1:0) ;outpt flag
 S X=$G(^OR(100,IFN,8,1,0)) I $P(X,U,5),$P(X,U,5)'=$P(X,U,3) S $P(ORMSG(4),"|",13)=$P(X,U,5) ; Send signer instead of orderer if different
 S OI=$$PTR("ORDERABLE ITEM"),DRUG=$$PTR("DISPENSE DRUG")
 S INSTR=$$PTR("INSTRUCTIONS"),SCHED=$$PTR("SCHEDULE")
 S DUR=$$PTR("DURATION"),URG=$$PTR("URGENCY"),DOSE=$$PTR("DOSE")
 S ROUTE=$$PTR("ROUTE"),PROVCOMM=$$PTR("WORD PROCESSING 1")
 S PI=$$PTR("PATIENT INSTRUCTIONS"),CONJ=$$PTR("AND/THEN")
 S J=1,ORC(J)=$P(ORMSG(4),"|",1,7)_"|"
 I +$G(NVA)=1 G NVA1
UD1 S I=0 F  S I=$O(ORDIALOG(INSTR,I)) Q:I'>0  D
 . S QT2=$G(ORDIALOG(SCHED,I)),QT3=$$HL7DUR,X=$G(ORDIALOG(DOSE,I))
 . ;S QT1=$S($L(X):$P(X,"&",1,4)_"&"_$P(X,"&",6),1:"")
 . S QT1=$S($L(X):$P(X,"&",1,6),1:"")
 . S QT6=$P($G(^ORD(101.42,+$G(ORDIALOG(URG,I)),0)),U,2)
 . S QT9=$G(ORDIALOG(CONJ,I))_"~" S:$E(QT9)="T" QT9="S~"
 . S J=J+1,ORC(J)=QT1_U_QT2_U_QT3_"^^^"_QT6_"^^"_$$INSTR_U_QT9
 ;
NVA1 I +$G(NVA)=1 D
 . S I=1 ;only one dosage possible for non-va meds
 . S QT2=$G(ORDIALOG(SCHED,I)),QT3=$$HL7DUR,X=$G(ORDIALOG(DOSE,I))
 . S QT1=$S($L(X):$P(X,"&",1,6),1:"")
 . S QT6=$P($G(^ORD(101.42,+$G(ORDIALOG(URG,I)),0)),U,2)
 . S QT9=$G(ORDIALOG(CONJ,I))_"~" S:$E(QT9)="T" QT9="S~"
 . S J=J+1,ORC(J)=QT1_U_QT2_U_QT3_"^^^"_QT6_"^^"_$$INSTR_U_QT9
 ;
 I $L($P(OR0,U,8)) S $P(ORC(2),U,4)=$$FMTHL7^XLFDT($P(OR0,U,8)) S:J<2 J=2
 S J=J+1,ORC(J)="|"_$P(ORMSG(4),"|",9,999),ORC=J,X="ORMSG(4)",ORMSG(4)="",I=0
 F J=1:1:ORC S Y=ORC(J) D  ;add to ORMSG(4)
 . I $L(@X)+$L(Y)'>245 S @X=@X_Y
 . E  S L=245-$L(@X),@X=@X_$E(Y,1,L),I=I+1,X="ORMSG(4,"_I_")",@X=$E(Y,L+1,$L(Y))
 I $G(ORDIALOG(DRUG,1)) S X=$$ENDCM^PSJORUTL(ORDIALOG(DRUG,1)),DISPENSE=$P(X,U,3)_"^^99NDF^"_ORDIALOG(DRUG,1)_"^^99PSD"
 S ORMSG(5)="RXO|"_$$USID^ORMBLD($G(ORDIALOG(OI,1)))_"|||||||||"_$G(DISPENSE)
UD2 I $G(OUTPT) D
 . N QTY,REFS,DSPY
 . S QTY=$$PTR("QUANTITY"),REFS=$$PTR("REFILLS"),DSPY=$$PTR("DAYS SUPPLY")
 . S ORMSG(5)=ORMSG(5)_"|"_$G(ORDIALOG(QTY,1))_"||"_$G(ORDIALOG(REFS,1))_"||||D"_$G(ORDIALOG(DSPY,1))
 S I=5 I $L($G(ORDIALOG(PROVCOMM,1))) D
 . S J=$O(^TMP("ORWORD",$J,PROVCOMM,1,0)) Q:'J
 . S I=6,ORMSG(6)="NTE|6|P|"_$G(^TMP("ORWORD",$J,PROVCOMM,1,J,0))
 . S K=0 F  S J=$O(^TMP("ORWORD",$J,PROVCOMM,1,J)) Q:J'>0  S K=K+1,ORMSG(6,K)=$G(^(J,0))
 I $G(OUTPT),$L($G(ORDIALOG(PI,1))) D
 . S J=$O(^TMP("ORWORD",$J,PI,1,0)) Q:'J
 . S I=I+1,ORMSG(I)="NTE|7|P|"_$G(^TMP("ORWORD",$J,PI,1,J,0))
 . S K=0 F  S J=$O(^TMP("ORWORD",$J,PI,1,J)) Q:J'>0  S K=K+1,ORMSG(I,K)=$G(^(J,0))
UD3 S J=0 F  S J=$O(ORDIALOG(ROUTE,J)) Q:J'>0  S I=I+1,ORMSG(I)=$$RXR($G(ORDIALOG(ROUTE,J)))
 I $D(^OR(100,IFN,9)) D ORDCHKS
 S I=I+1,ORMSG(I)=$$ZRX(IFN)
 I $G(OUTPT) D  ;add SC data
 . N OR5 S OR5=$G(^OR(100,IFN,5))
 . I $L(OR5),OR5'?5"^" S I=I+1,ORMSG(I)="ZSC|"_$TR(OR5,"^","|") Q
 . S SC=$$PTR("SERVICE CONNECTED") S:$D(ORDIALOG(SC,1)) I=I+1,ORMSG(I)="ZSC|"_$S(ORDIALOG(SC,1):"SC",1:"NSC")
 ; Create DG1 & ZCL segment(s) for Billing Awareness (BA) Project
 D DG1^ORWDBA1($G(IFN),"I",I)
 I $P(^ORD(100.98,$P(OR0,U,11),0),U)="NON-VA MEDICATIONS" D
 . S I=I+1 D ZRN(IFN,.ORMSG,I)
 Q
 ;
INSTR() ; -- Return text instructions for QT-8, instance I
 N Y S Y=$P($G(ORDIALOG(DOSE,I)),"&",5)
 I $G(ORDIALOG(DRUG,1)),$L(Y) Q Y
 S Y=$G(ORDIALOG(INSTR,I)) I $G(OUTPT) D
 . N UNITS,UNT S UNITS=$$PTR("FREE TEXT"),UNT=$G(ORDIALOG(UNITS,I))
 . S:$L(UNT) Y=Y_" "_UNT ;old format
 Q Y
 ;
HL7DUR() ; -- Returns HL7 form of duration X
 N X,X1,X2,Y S X=$G(ORDIALOG(DUR,I))
 S X1=+$G(X),Y="" G:X1'>0 HDQ
 S X2=$$UP^XLFSTR($P(X,X1,2)) S:$E(X2)=" " X2=$E(X2,2,99)
 S Y=$S($E(X2,1,2)="MO":"L",'$L(X2):"D",1:$E(X2))_X1
HDQ Q Y
 ;
IV ; -- new IV Meds order
 N SOLN,VOL,ADDS,STR,UNITS,RATE,URG,WP,QT,I,X1,X2,INST
 S RATE=$$PTR("INFUSION RATE"),ADDS=$$PTR("ADDITIVE")
 S STR=$$PTR("STRENGTH PSIV"),UNITS=$$PTR("UNITS")
 S WP=$$PTR("WORD PROCESSING 1"),VOL=$$PTR("VOLUME")
 S SOLN=$$PTR("ORDERABLE ITEM"),URG=+$G(ORDIALOG($$PTR("URGENCY"),1))
 S QT=U_$G(ORDIALOG(+$$PTR("SCHEDULE"),1))_"^^^^"
 S:URG QT=QT_$P($G(^ORD(101.42,URG,0)),U,2) S $P(ORMSG(4),"|",8)=QT
 S X=$G(^OR(100,IFN,8,1,0)) I $P(X,U,5),$P(X,U,5)'=$P(X,U,3) S $P(ORMSG(4),"|",13)=$P(X,U,5) ; Send signer instead of orderer if different
 S RATE=$G(ORDIALOG(RATE,1)) S:$E(RATE,$L(RATE))=" " RATE=$E(RATE,1,($L(RATE)-1)) S ORMSG(5)="RXO|^^^PS-1^IV^99OTH|"_RATE ;strip any trailing spaces
 S I=5 I $L($G(ORDIALOG(WP,1))) D
 . N J,K S J=$O(^TMP("ORWORD",$J,WP,1,0)) Q:'J
 . S I=6,ORMSG(6)="NTE|6|P|"_$G(^TMP("ORWORD",$J,WP,1,J,0))
 . S K=0 F  S J=$O(^TMP("ORWORD",$J,WP,1,J)) Q:J'>0  S K=K+1,ORMSG(6,K)=^(J,0)
IV1 S INST=0 F  S INST=$O(ORDIALOG(SOLN,INST)) Q:INST'>0  D
 . S X1="B",X2=+$G(ORDIALOG(SOLN,INST))
 . I $P($G(^ORD(101.43,X2,"PS")),U,4) S X1=X1_"A" ;pre-mix
 . S I=I+1,ORMSG(I)="RXC|"_X1_"|"_$$USID^ORMBLD(X2)_"|"_$G(ORDIALOG(VOL,INST))_"|"_$$HL7UNIT("ML")
 I $O(ORDIALOG(ADDS,0)) D
 . S INST=0 F  S INST=$O(ORDIALOG(ADDS,INST)) Q:INST'>0  D
 . . S X1=$G(ORDIALOG(ADDS,INST)),X2=$G(ORDIALOG(UNITS,INST))
 . . S I=I+1,ORMSG(I)="RXC|A|"_$$USID^ORMBLD(X1)_"|"_$G(ORDIALOG(STR,INST))_"|"_$$HL7UNIT(X2)
 I $D(^OR(100,IFN,9)) D ORDCHKS
 S I=I+1,ORMSG(I)=$$ZRX(IFN)
 ; Create DG1 & ZCL segment(s) for Billing Awareness (BA) Project
 D DG1^ORWDBA1($G(IFN),"I",I)
 Q
 ;
RXR(ROUTE) ; -- Returns RXR segment
 N NAME S NAME=$$GET1^DIQ(51.2,+ROUTE_",",.01)
 Q "RXR|^^^"_+ROUTE_U_NAME_"^99PSR"
 ;
ZRX(IFN) ; -- Returns ZRX segment
 N NATURE,TYPE,ORIG,PSORIG,ZRX
 S TYPE=$P($G(^OR(100,IFN,3)),U,11),NATURE=$P($G(^(8,1,0)),U,12)
 S:NATURE NATURE=$P($G(^ORD(100.02,+NATURE,0)),U,2) ;code
 S PSORIG="" I (TYPE=1)!(TYPE=2) D
 . S ORIG=$P($G(^OR(100,IFN,3)),U,5),PSORIG=$G(^OR(100,+ORIG,4))
 . I PSORIG'>0 S PSORIG="",TYPE=0 ;edit of unreleased order
 S ZRX="ZRX|"_PSORIG_"|"_NATURE_"|"_$S(TYPE=1:"E",TYPE=2:"R",1:"N")
 I $G(OUTPT) S ZRX=ZRX_"|"_$G(ORDIALOG($$PTR("ROUTING"),1))_$S($L($P($G(^OR(100,ORIFN,8,1,2)),"^",3)):"|||1",1:"")
 Q ZRX
 ;
ZRN(IFN,ORMSG,I) ; -- Set ZRN segment
 N ST,ZRN,J,K,TXT,LSTDOSE,HMMEDLST,RESN,LOCALE
 S ORMSG(I)="ZRN|N|"
 S ST=$$PTR("STATEMENTS")
 I $L($G(ORDIALOG(ST,1))) D
 . S J=$O(^TMP("ORWORD",$J,ST,1,0)) Q:'J
 . S K=0,TXT=$G(^TMP("ORWORD",$J,ST,1,J,0))
 . I $L(TXT) S K=K+1,ORMSG(I,K)=TXT
 . F  S J=$O(^TMP("ORWORD",$J,ST,1,J)) Q:J'>0  S TXT=$G(^(J,0)) D
 . . I $L(TXT) S K=K+1,ORMSG(I,K)=TXT
 ;IHS/MSC/REC/PLS - 08/06/2010 - Support for Med Rec
 S LSTDOSE=$$PTR^ORCD("OR GTX HM LAST DOSE TAKEN")
 S HMMEDLST=$$PTR^ORCD("OR GTX HM LIST SOURCE")
 S RESN=$$PTR^ORCD("OR GTX HM REASON")
 S LOCALE=$$PTR^ORCD("OR GTX HM LOCATION OF MEDICATION")
 I $L($G(ORDIALOG(LSTDOSE,1))) D
 .N %DT,Y,X
 .S %DT="X",X=ORDIALOG(LSTDOSE,1) I X]"" D ^%DT
 .S:Y $P(ORMSG(I),"|",4)=$$FMTHL7^XLFDT(Y)
 I $L($G(ORDIALOG(HMMEDLST,1))) D
 .N LIST,X,OK
 .S LIST=$P(ORDIALOG(HMMEDLST,0),U,2)
 .S X=ORDIALOG(HMMEDLST,1)
 .F J=1:1 Q:$P(LIST,";",J)=""  Q:$G(OK)  I X=$P($P(LIST,";",J),":") S $P(ORMSG(I),"|",5)=$P($P(LIST,";",J),":",2),OK=1
 I $L($G(ORDIALOG(LOCALE,1))) D
 .N LIST,X,OK
 .S LIST=$P(ORDIALOG(LOCALE,0),U,2)
 .S X=ORDIALOG(LOCALE,1)
 .F J=1:1 Q:$P(LIST,";",J)=""  Q:$G(OK)  I X=$P($P(LIST,";",J),":") S $P(ORMSG(I),"|",6)=$P($P(LIST,";",J),":",2),OK=1
 I $L($G(ORDIALOG(RESN,1))) D
 .S I=I+1,ORMSG(I)="ZHM||"
 .S J=$O(^TMP("ORWORD",$J,RESN,1,0)) Q:'J
 .S TXT=$G(^TMP("ORWORD",$J,RESN,1,J,0))
 .I $L(TXT) S $P(ORMSG(I),"|",2)=J,$P(ORMSG(I),"|",3)=TXT
 .F  S J=$O(^TMP("ORWORD",$J,RESN,1,J)) Q:J'>0  S TXT=$G(^(J,0)) D
 ..I $L(TXT) S I=I+1,ORMSG(I)="ZHM|"_J_"|"_TXT
 Q
 ;
ORDCHKS ; -- Include order checks in OBX segments
 N OC,X,X1 S OC=0
 F  S OC=$O(^OR(100,IFN,9,OC)) Q:OC'>0  S X=$G(^(OC,0)),X1=$G(^(1)) D
 . S I=I+1,ORMSG(I)="OBX|"_OC_"|TX|^^^"_+X_"^^99OCX||"_$S($L(X1):X1,1:$P(X,U,3))_"|||||||||"_$$FMTHL7^XLFDT($P(X,U,6))_"||"_$P(X,U,5)
 . I $L($P(X,U,4)) S I=I+1,ORMSG(I)="NTE|"_OC_"|P|"_$P(X,U,4)
 Q
 ;
HL7UNIT(X) ; -- Return coded element for volume/strength units
 N I,UNIT,Y
 F I=1:1:$L(X) I $E(X,I)?1A Q  ; first letter
 S UNIT=$$UP^XLFSTR($E(X,I,$L(X))),Y=""
 F I=1:1:11 S X=$T(UNITS+I) I UNIT=$P(X,";",3) S Y="^^^PSIV-"_I_U_UNIT_"^99OTH" Q
 Q Y
 ;
UNITS ; -- allowable PS units
 ;;ML
 ;;LITER
 ;;MCG
 ;;MG
 ;;GM
 ;;UNITS
 ;;IU
 ;;MEQ
 ;;MM
 ;;MU
 ;;THOUU
HL7TIME(X) ; -- Return HL7 formatted duration
 N I,Y S Y=""
 F I=1:1:$L(X) I $E(X,I)?1A S Y=$$UP^XLFSTR($E(X,I)) Q  ; first letter
 S Y=Y_+X
 Q Y
 ;
VER(IFN) ; -- Send msg for nurse-verified orders
 N OR0,ORMSG S OR0=$G(^OR(100,+IFN,0)) Q:$P(OR0,U,12)'="I"  ;Inpt only
 S ORMSG(1)=$$MSH^ORMBLD("ORM","PS"),ORMSG(2)=$$PID^ORMBLD($P(OR0,U,2))
 S ORMSG(3)=$$PV1^ORMBLD($P(OR0,U,2),$P(OR0,U,12),+$P(OR0,U,10))
 S ORMSG(4)="ORC|ZV|"_IFN_"^OR|"_$G(^OR(100,+IFN,4))_"^PS||||||||"_DUZ_"||||"_$$FMTHL7^XLFDT($$NOW^XLFDT)
 D MSG^XQOR("OR EVSEND PS",.ORMSG)
 Q
 ;
REF(IFN,ROUTING,CLINIC) ; -- Send msg for refill request
 N OR0,ORMSG S OR0=$G(^OR(100,+IFN,0)) Q:$P(OR0,U,12)'="O"
 S:'$G(CLINIC) CLINIC=$S($G(ORL):+ORL,1:+$P(OR0,U,10))
 S ORMSG(1)=$$MSH^ORMBLD("ORM","PS"),ORMSG(2)=$$PID^ORMBLD($P(OR0,U,2))
 S ORMSG(3)=$$PV1^ORMBLD($P(OR0,U,2),"O",CLINIC)
 S ORMSG(4)="ORC|ZF|"_IFN_"^OR|"_$G(^OR(100,+IFN,4))_"^PS|||||||"_DUZ_"||"_$G(ORNP)_"|||"_$$FMTHL7^XLFDT($$NOW^XLFDT)
 S ORMSG(5)="ZRX||||"_ROUTING
 D MSG^XQOR("OR EVSEND PS",.ORMSG)
 Q
