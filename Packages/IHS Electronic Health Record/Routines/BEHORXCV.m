BEHORXCV ;MSC/IND/PLS/DKM - Cover Sheet: Medications ;09-Feb-2011 08:56;PLS
 ;;1.1;BEH COMPONENTS;**033002,033003,033004**;Mar 20, 2007
 ;=================================================================
 ; List medications
LIST(DATA,DFN) ;EP
 N RXN,CNT,X,Y,Z
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 K ^TMP("PS",$J)
 D OCL^PSOORRL(DFN,"","")
 F RXN=0:0 S RXN=$O(^TMP("PS",$J,RXN)) Q:'RXN  S X=^(RXN,0) D
 .S:$P($P(X,U),";",2)="I" $P(X,U,15)=$P($G(^OR(100,+$P(X,U,8),0)),U,7)
 .D ADD(X)
 K ^TMP("PS",$J)
 F RXN=0:0 S RXN=$O(^AUPNVMED("AC",DFN,RXN)) Q:'RXN  D
 .S X=$G(^AUPNVMED(RXN,0)),Z=$G(^(11)),Y=$G(^AUPNVSIT(+$P(X,U,3),0))
 .Q:$P(Y,U,7)'="E"   ; Historical visits only
 .Q:$L($P(Z,U,2))    ; No associated rx
 .Q:$L($P(Z,U,8))        ; Outside meds already in meds list - P7
 .D ADD(RXN_";E^"_$$GET1^DIQ(50,+X,.01)_"^^^^^^^"_$S($P(X,U,8):"DISCONTINUED",1:"ACTIVE")_"*^^^^^^"_(Y\1))
 Q
 ; List medication detail
DETAIL(DATA,DFN,ID) ;EP
 N I,X,Y,NODE,RXN,PROV,DRUG,INPT,CNT
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 I $P(ID,";",2)="E" D VMED Q
 D OEL^PSOORRL(DFN,ID)
 S NODE=$G(^TMP("PS",$J,0)),RXN=$G(^("RXN",0)),PROV=$G(^TMP("PS",$J,"P",0)),DRUG=$P(NODE,U),INPT=$P(ID,";",2)="I"
 I $P($G(^OR(100,+$P(NODE,U,11),0)),U,11)=$O(^ORD(100.98,"B","IV RX",0)) D
 .D IV
 E  D DRUG
 ; Add start & stop dates, status
 D ADD()
 D:$P(RXN,U,5) ADD($P($G(^VA(200,+$P(RXN,U,5),0)),U),"Pharmacist:")
 D ADD($$FMTE^XLFDT($P(NODE,U,5),"2P"),"Start Date:")
 D ADD($$FMTE^XLFDT($P(NODE,U,3),"2P"),"Stop Date:")
 D ADD($P(NODE,U,6),"Status:")
 D:$P(NODE,U,11) ADD("Order #"_+$P(NODE,U,11))
 D ADD($$GETRXNRM^BEHORXFN(+$P(NODE,U,11)),"RXNorm Code:")
 K ^TMP("PS",$J)
 Q
 ; VMED Detail
VMED S NODE=$G(^AUPNVMED(+ID,0)),X=+$P(NODE,U,3)
 D ADD($$GET1^DIQ(50,+NODE,.01)),ADD()
 D ADD("Outside","Prescription #:")
 D ADD($P(NODE,U,7),"Days Supply:")
 D ADD($P(NODE,U,6),"Quantity:")
 D ADD($P(NODE,U,5),"Sig:")
 D ADD($$FMTE^XLFDT($G(^AUPNVSIT(X,0))\1,2),"Prescribed:")
 D:$P(NODE,U,8) ADD($$FMTE^XLFDT($P(NODE,U,8),2),"Discontinued:")
 D ADD($P($G(^AUPNVSIT(X,21)),U),"Where Dispensed:")
 Q
 ; Drug Detail
DRUG D ADD(DRUG),ADD()
 D:RXN ADD($P(RXN,U),"Prescription #:")
 D:PROV ADD($P(PROV,U,2),"Prescriber:")
 D ADD($P(NODE,U,9),"Total Dose:")
 D ADD($P(NODE,U,10),"Units/Dose:")
 D MULT("MDR","Route:")
 D MULT("SCH","Schedule:")
 D WP("SIG",$S(INPT:"Instructions:",1:"Sig:"))
 D WP("PC","Provider Comments:")
 D WP("SIO","Other Instructions:")
 D ADD()
 I 'INPT D
 .D ADD($P(NODE,U,7),"Days Supply:")
 .D ADD($P(NODE,U,8),"Quantity:")
 .D:$P(NODE,U,12) ADD($$FMTE^XLFDT($P(NODE,U,12),2),"Last Filled:")
 .D ADD($P(NODE,U,4),"Refills Remaining:")
 .I $P(RXN,U,6)!$G(^TMP("PS",$J,"REF",0)) D
 ..S I=0,X="Filled:"
 ..D:$P(RXN,U,6) FILLED("R",$P(RXN,U,6)_"^^^"_$P(RXN,U,7)_U_$P(RXN,U,3,4),.X)
 ..F  S I=$O(^TMP("PS",$J,"REF",I)) Q:'I  D FILLED("R",$G(^(I,0)),.X)
 .I $G(^TMP("PS",$J,"PAR",0)) D
 ..S I=0,X="Partial Fills:"
 ..F  S I=$O(^TMP("PS",$J,"PAR",I)) Q:'I  D FILLED("P",$G(^(I,0)),.X)
 I INPT,$D(^TMP("PS",$J,"ADM")) D
 .S X="Admin Times:",I=0
 .F  S I=$O(^TMP("PS",$J,"ADM",I)) Q:I'>0  S Y=$G(^(I,0)) D:$L(Y) ADD(Y,.X)
 Q
 ; IV Fluid Detail
IV D ADD("IV Fluid"),ADD()
 D:PROV ADD($P(PROV,U,2),"Prescriber:")
 D MULT("B","Solution:")
 D MULT("A","Additive:")
 D ADD($P(NODE,U,2),"Infusion Rate:")
 D WP("PC","Provider Comments:")
 Q
 ; Add WP item
WP(SUB,CAPTION) ;
 N LP,DIWL,DIWR,DIWF,X
 S DIWL=1,DIWR=60,DIWF="C60",LP=0
 K ^UTILITY($J,"W")
 F  S LP=+$O(^TMP("PS",$J,SUB,LP)) Q:'LP  S X=^(LP,0) D ^DIWP
 F  S LP=+$O(^UTILITY($J,"W",DIWL,LP)) Q:'LP  D ADD(^(LP,0),.CAPTION)
 K ^UTILITY($J,"W")
 Q
 ; Add multi-valued item
MULT(SUB,CAPTION) ;
 N I
 S I=0
 F  S I=$O(^TMP("PS",$J,SUB,I)) Q:'I  D ADD($TR(^(I,0),U," "),.CAPTION)
 Q
 ; Add FILLD data
FILLED(TYPE,FILLD,CAPTION) ;
 N Y
 S Y=$$FMTE^XLFDT($P(FILLD,U),2)_" ("_$$ROUTING($P(FILLD,U,5))_")"
 S:TYPE="R"&$P(FILLD,U,4) Y=Y_" released "_$$FMTE^XLFDT($P(FILLD,U,4),2)
 S:TYPE="P"&$P(FILLD,U,3) Y=Y_" Qty: "_$P(FILLD,U,3)
 D ADD(Y,.CAPTION)
 D:$L($P(FILLD,U,6)) ADD($P(FILLD,U,6),"")
 Q
 ; Return routing info
ROUTING(X) ;
 Q $S($G(X)="":"",X="M":"Mail",X="W":"Window",1:X)
 ; Add to output array
ADD(TXT,LBL) ;
 S TXT=$G(TXT," ")
 S:$L(TXT) CNT=CNT+1,@DATA@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_TXT,LBL=""
 Q
