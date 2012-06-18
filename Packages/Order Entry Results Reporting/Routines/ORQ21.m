ORQ21 ; SLC/MKB/GSS - Detailed Order Report cont ;15-Mar-2011 22:15;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**141,190,1005,1007**;Dec 17, 1997
 ;
 ; Modified - IHS/MSC/PLS - 03/15/2011 - Line M2+10
RAD(TCOM) ; -- add RA data for 2.5 orders
 N RAIFN,CASE,PROC,ORD,ORI,X,ORTTL,ORB
 S RAIFN=$G(^OR(100,ORIFN,4)) Q:RAIFN'>0
 D EN30^RAO7PC1(RAIFN) Q:'$D(^TMP($J,"RAE2",+ORVP))
 S ORD=$G(^TMP($J,"RAE2",+ORVP,"ORD")),CASE=$O(^(0)) Q:'CASE  S PROC=$O(^(CASE,""))
 I '$G(TCOM) D  ;else add only Tech Comments
 . S CNT=CNT+1,@ORY@(CNT)=$$LJ^XLFSTR("Procedure:",30)_$S($L(ORD):ORD,1:PROC)
 . S ORI=0,ORTTL="Procedure Modifiers:          ",ORB=1
 . F  S ORI=$O(^TMP($J,"RAE2",+ORVP,CASE,PROC,"M",ORI)) Q:ORI'>0  S CNT=CNT+1,@ORY@(CNT)=ORTTL_^(ORI),ORTTL=$$REPEAT^XLFSTR(" ",30)
 . S CNT=CNT+1,@ORY@(CNT)="History and Reason for Exam:"
 . F  S ORI=$O(^TMP($J,"RAE2",+ORVP,CASE,PROC,"H",ORI)) Q:ORI'>0  S CNT=CNT+1,@ORY@(CNT)="  "_^(ORI)
RAD1 I $L($G(^TMP($J,"RAE2",+ORVP,CASE,PROC,"TCOM",1))) S X=^(1) D
 . N DIWL,DIWR,DIWF,I K ^UTILITY($J,"W")
 . S DIWL=1,DIWR=72,DIWF="C72" D ^DIWP
 . S CNT=CNT+1,@ORY@(CNT)="Technologist's Comment:",ORB=1
 . S I=0 F  S I=$O(^UTILITY($J,"W",DIWL,I)) Q:I'>0  S CNT=CNT+1,@ORY@(CNT)="  "_^(I,0)
 K ^TMP($J,"RAE2",+ORVP),^UTILITY($J,"W")
 S:$G(ORB) CNT=CNT+1,@ORY@(CNT)="   " ;blank
 Q
 ;
MED ; -- Add Pharmacy order data
 Q:$G(^OR(100,ORIFN,4))["N"  ;non-VA med -- no refill history
 N TYPE,NODE,RXN,OR5 S TYPE=$P(OR0,U,12)
 I '$D(^TMP("PS",$J,0)) D  ;get PS data
 . N PSIFN S PSIFN=$G(^OR(100,ORIFN,4))
 . S:TYPE="O" PSIFN=$TR(PSIFN,"S","P")_$S(PSIFN?1.N:"R",1:"")
 . D OEL^PSOORRL(+ORVP,PSIFN_";"_TYPE)
 S NODE=$G(^TMP("PS",$J,0)),RXN=$G(^("RXN",0))
 I '$L(NODE) K ^TMP("PS",$J) Q  ;error
 I $O(^TMP("PS",$J,"DD",0)) D  ;Disp Drugs
 . N I,X,Y S X="Dispense Drugs (units/dose):  ",I=0
 . F  S I=$O(^TMP("PS",$J,"DD",I)) Q:I'>0  S Y=$G(^(I,0)) S:Y CNT=CNT+1,@ORY@(CNT)=X_$$GET1^DIQ(50,+Y_",",.01)_" ("_$P(Y,U,2)_")"
 S:$P(NODE,U,9) CNT=CNT+1,@ORY@(CNT)="Total Dose:                   "_$P(NODE,U,9)
M1 I TYPE="I" D  ;admin data
 . N I,X,Y I $O(^TMP("PS",$J,"B",0)) D
 .. S X="IV Print Name:                ",I=0
 .. F  S I=$O(^TMP("PS",$J,"B",I)) Q:I<1  S Y=$G(^(I,0)) S:$L(Y) CNT=CNT+1,@ORY@(CNT)=X_$P(Y,U),X=$$REPEAT^XLFSTR(" ",30) I $L($P(Y,U,3)) S CNT=CNT+1,@ORY@(CNT)=X_" "_$P(Y,U,3)
 . S I=+$O(^TMP("PS",$J,"SCH",0)),X=$P($G(^(I,0)),U,2)
 . S:$L(X) CNT=CNT+1,@ORY@(CNT)="Schedule Type:                "_X
 . S X="Administration Times:         ",I=0
 . F  S I=$O(^TMP("PS",$J,"ADM",I)) Q:I'>0  S Y=$G(^(I,0)) S:$L(Y) CNT=CNT+1,@ORY@(CNT)=X_Y,X=$$REPEAT^XLFSTR(" ",30)
M2 I TYPE="O" D  ;fill history
 . N FILLD,X,Y,I
 . S:$P(NODE,U,12) CNT=CNT+1,@ORY@(CNT)="Last Filled:                  "_$$FMTE^XLFDT($P(NODE,U,12),2)
 . S CNT=CNT+1,@ORY@(CNT)="Refills Remaining:            "_$P(NODE,U,4)
 . I $P(RXN,U,6)!$G(^TMP("PS",$J,"REF",0)) S X="Filled:                       " D
 .. I $P(RXN,U,6) S FILLD=$P(RXN,U,6)_"^^^"_$P(RXN,U,7)_U_$P(RXN,U,3,4) D FILLED("R")
 .. S I=0 F  S I=$O(^TMP("PS",$J,"REF",I)) Q:I'>0  S FILLD=$G(^(I,0)) D FILLED("R")
 . I $G(^TMP("PS",$J,"PAR",0)) S I=0,X="Partial Fills:      " F  S I=$O(^TMP("PS",$J,"PAR",I)) Q:I'>0  S FILLD=$G(^(I,0)) D FILLED("P")
 . S:RXN CNT=CNT+1,@ORY@(CNT)="Prescription#:                "_$P(RXN,U)
 .S:$L($$GETRXNRM^BEHORXFN(+ORIFN)) CNT=CNT+1,@ORY@(CNT)="RXNorm Code:                  "_$$GETRXNRM^BEHORXFN(+ORIFN)
M3 S:$P(RXN,U,5) CNT=CNT+1,@ORY@(CNT)="Pharmacist:                   "_$P($G(^VA(200,+$P(RXN,U,5),0)),U)
 D ACTLOG($G(^OR(100,ORIFN,4))) ;IHS/MSC/PLS - Display activity log
 S:$P(NODE,U,13) CNT=CNT+1,@ORY@(CNT)="NOT TO BE GIVEN" K ^TMP("PS",$J)
 S CNT=CNT+1,@ORY@(CNT)="   " ;blank
 S OR5=$G(^OR(100,ORIFN,5)) I $L(OR5) D  ;SC data
 . N X,Y,I S X="For conditions related to:    "
 . F I=1:1:7 S Y=$P(OR5,U,I) I Y S CNT=CNT+1,@ORY@(CNT)=X_$$SC(I),X=$$REPEAT^XLFSTR(" ",30)
 Q
 ;
BA ;Billing Aware data display
 N DXIEN,DXV,ICD9,OCT
 S OCT=0 F  S OCT=$O(^OR(100,ORIFN,5.1,OCT)) Q:OCT=""  D
 . S OREC=^OR(100,ORIFN,5.1,OCT,0)
 . S DXIEN=$P(OREC,U) S:DXIEN'="" ICD9=$P($G(^ICD9(DXIEN,0)),U)
 . S DXV=$P($G(^ICD9(DXIEN,0)),U,3)
 . S X="Diagnosis of:  "_ICD9_" - "_DXV,CNT=CNT+1,@ORY@(CNT)=X
 . S X="For conditions related to:    "
 . F I=1:1:6 S Y=$P(OREC,U,I+3) I Y S CNT=CNT+1,@ORY@(CNT)=X_$$SC(I),X=$$REPEAT^XLFSTR(" ",30)
 Q
 ;
FILLED(TYPE) ; -- add FILLD data
 N Y S Y=$$FMTE^XLFDT($P(FILLD,U),2)_" ("_$$ROUTING($P(FILLD,U,5))_")"
 S:TYPE="R"&$P(FILLD,U,4) Y=Y_" released "_$$FMTE^XLFDT($P(FILLD,U,4),2)
 S:TYPE="P"&$P(FILLD,U,3) Y=Y_" Qty: "_$P(FILLD,U,3)
 S CNT=CNT+1,@ORY@(CNT)=X_Y,X=$$REPEAT^XLFSTR(" ",30)
 S:$L($P(FILLD,U,6)) CNT=CNT+1,@ORY@(CNT)=X_$P(FILLD,U,6)
 Q
 ;
ROUTING(X) ; -- Returns external form
 N Y S Y=$S($G(X)="M":"Mail",$G(X)="W":"Window",1:$G(X))
 Q Y
 ;
SC(J) ; -- Returns name of SC field by piece number
 I '$G(J) Q ""
 I J=1 Q "SERVICE CONNECTED CONDITION"
 I J=2 Q "MILITARY SEXUAL TRAUMA"
 I J=3 Q "AGENT ORANGE EXPOSURE"
 I J=4 Q "IONIZING RADIATION EXPOSURE"
 I J=5 Q "ENVIRONMENTAL CONTAMINANTS"
 I J=6 Q "HEAD OR NECK CANCER"
 I J=7 Q "COMBAT VETERAN"
 Q ""
 ; IHS/MSC/PLS - Display activity log in order detail
ACTLOG(RX) ;EP
 Q:'$G(RX)
 ;Q:'$$GET1^DIQ(52,RX,9999999.23,"I")  ; Only display activity log for autofinished prescriptions
 N ACTD,ALP,AD,COM,BRK
 D ACTLOG^APSPFNC1(.ACTD,RX)
 I $D(ACTD) D
 .S CNT=CNT+1
 .S @ORY@(CNT)=" "
 .S CNT=CNT+1
 .S @ORY@(CNT)="Activity Log"
 .S CNT=CNT+1
 .S @ORY@(CNT)="#   Date        Reason         Rx Ref         Initiator Of Activity"
 .S CNT=CNT+1
 .S $P(@ORY@(CNT),"=",79)="="
 .S ALP=0 F  S ALP=$O(ACTD(ALP)) Q:'ALP  D
 ..S AD=ACTD(ALP),IENS=$P(AD,U)_","_RX_","
 ..S COM=$P(AD,U,6)
 ..S CNT=CNT+1
 ..S @ORY@(CNT)=$P(AD,U)_"   "_$P($$FMTE^XLFDT($P(AD,U,2),"2Z"),"@")_"    "_$$LJ^XLFSTR($$GET1^DIQ(52.3,IENS,.02),15)_$$LJ^XLFSTR($$GET1^DIQ(52.3,IENS,.03),15)_$$GET1^DIQ(52.3,IENS,.03)
 ..I $L(COM) D
 ...I $L(COM)<71 D
 ....S CNT=CNT+1
 ....S @ORY@(CNT)="Comments: "_COM
 ...E  D
 ....I $E(COM,1,70)'[" " D
 .....S CNT=CNT+1
 .....S @ORY@(CNT)="Comments: "_$E(COM,1,70)
 .....S CNT=CNT+1
 .....S @ORY@(CNT)=$E(COM,71,245)
 ....E  D
 .....F BRK=245:-1 Q:BRK=0  I $E(COM,BRK)=" ",BRK<71 D  Q
 ......S CNT=CNT+1
 ......S @ORY@(CNT)="Comments: "_$E(COM,1,BRK)
 ......S CNT=CNT+1
 ......S @ORY@(CNT)=$E(COM,BRK,245)
 Q
