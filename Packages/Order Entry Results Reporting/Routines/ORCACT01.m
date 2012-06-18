ORCACT01 ;SLC/MKB-Validate order actions cont ;14-Mar-2011 19:37;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**94,116,134,141,163,187,190,1002,1004,1006,1007**;Dec 17, 1997
 ;Modified - IHS/MSC/PLS - 08/09/10 - Line ES+5,ES+7,RW+2
 ;                         03/02/11 - Line XFT+5 - added check for NV RX
ES ; -- sign [on chart]
 I ORDSTS=11,VER<3,PKG'="OR" S ERROR="This order cannot be released and must be discontinued!" Q
 N X I ACTSTS=11!(ACTSTS=10) D  Q:$L($G(ERROR))
 . I $P(ORA0,U,2)="DC",$$DONE^ORCACT0 D CANCEL^ORCSEND(+IFN),UNOTIF^ORCSIGN S OREBUILD=1 Q
 . S X=$$DISABLED^ORCACT0 I X S ERROR=$P(X,U,2) Q
 ;I ACTION="OC",$G(DG)="NV RX" S:MEDPARM<2 ERROR="You are not authorized to release outside med orders!" Q
 I ACTION="OC",$L($G(NV)) S:MEDPARM<2 ERROR="You are not authorized to release "_NV_" orders!" Q
 ;S X=$P(ORA0,U,4) I X=3 S:ACTSTS'=11&(ACTSTS'=10) ERROR="This order does not require a signature!" Q
 S X=$P(ORA0,U,4) I X=3 Q:$L($G(NV))  S:ACTSTS'=11&(ACTSTS'=10) ERROR="This order does not require a signature!" Q
 I X'=2 S ERROR="This order has been signed!" Q
 I DG="O RX",ACTION'="ES",ACTION'="DS",$G(NATR)'="I" S ERROR="Outpatient meds may not be released without a clinician's signature!" Q
 I (ACTION="ES"!(ACTION="DS")),$D(^XUSEC("ORELSE",DUZ)),$P(OR0,U,16)'<2 S ERROR="You are not privileged to sign this order!" Q
 I ACTION="OC" S:MEDPARM<2 ERROR="You are not authorized to release med orders!" Q
 I ACTION="RS" D  Q:$D(ERROR)  Q:$G(NATR)'="I"
 . Q:ACTSTS=11  Q:ACTSTS=10  ;unreleased - ok
 . S ERROR="This order has already been released!"
ES1 I PKG="PS" D  ;authorized to write meds?
 . N TYPE,OI,PSOI,DEAFLG,PKI
 . S X=$G(^VA(200,DUZ,"PS"))
 . I '$P(X,U) S ERROR="You are not authorized to sign med orders!" Q
 . I $P(X,U,4),$$NOW^XLFDT>$P(X,U,4) S ERROR="You are no longer authorized to sign med orders!" Q
 . Q:DG="IV RX"  Q:$P(ORA0,U,2)="DC"  ;don't need to ck DEA#
 . S OI=+$$VALUE^ORX8(+IFN,"ORDERABLE")
 . S PSOI=+$P($G(^ORD(101.43,OI,0)),U,2) Q:PSOI'>0
 . S TYPE=$S($P(DG," ")="O":"O",1:"I"),DEAFLG=$$OIDEA^PSSUTLA1(PSOI,TYPE)
 . I DEAFLG>0,'$L($$DEA^XUSER()) S ERROR="You must have a valid DEA# or VA# to sign this order!" Q
 . D PKISITE^ORWOR(.PKI)
 . I $G(PKI),ACTION="RS",DEAFLG=1 S ERROR="This order cannot be released without a Digital Signature" Q
 Q
 ;
XFR ; -- transfer to inpt/outpt [IFN=order to be transferred]
 N OI,PS I DG="TPN" S ERROR="TPN orders may not be copied!" Q
 I $$INACTIVE S ERROR="Orders for inactive orderables may not be transferred; please enter a new order!" Q
 S OI=+$O(^OR(100,+IFN,.1,"B",0)),ORPS=$G(^ORD(101.43,OI,"PS"))
 I DG="UD RX",'$P(ORPS,U,2) S ERROR="This drug may not be ordered for an outpatient!" Q
 I DG="O RX" D  Q:$L($G(ERROR))
 . I '$P(ORPS,U) S ERROR="This drug may not be ordered for an inpatient!" Q
 . D:$O(^OR(100,+IFN,4.5,"ID","MISC",0)) DOSES^ORCACT02(+IFN)
 I DG="NV RX" D  Q:$L($G(ERROR))
 .N XFRIO
 .S XFRIO=$P($G(^TMP("BEHPSHMX",$J)),U,2)
 .I XFRIO="I",'$P(ORPS,U) S ERROR="This drug may not be ordered as an inpatient medication!" Q
 .I XFRIO="O",'$P(ORPS,U,2) S ERROR="This drug may not be ordered as outpatient medication!" Q
 .D:$O(^OR(100,+IFN,4.5,"ID","MISC",0)) DOSES^ORCACT02(+IFN)
 Q
 ;
RW ; -- rewrite/copy
 I ACTSTS=12 S ERROR="Orders that have been dc'd due to editing may not be copied!" Q
 ;IHS/MSC/REC/PLS - 08/09/10
 ;I DG="NV RX" S ERROR="Outside med orders cannot be copied!" Q
 I $L($G(NV)) S ERROR=NV_" orders cannot be copied!" Q
 I DG="TPN" S ERROR="TPN orders may not be rewritten!" Q
 I DG="UD RX",$$NTBG(+IFN) S ERROR="This order has been marked 'Not to be Given' and may not be rewritten!" Q
 I $$INACTIVE S ERROR="Orders for inactive orderables may not be copied; please enter a new order!" Q
 I PKG="PS",'$$MEDOK S ERROR="This drug may not be ordered!" Q
 I DG="O RX",$O(^OR(100,+IFN,4.5,"ID","MISC",0)) D DOSES^ORCACT02(+IFN) ;old form
 Q
 ;
RN ; -- renew
 I PKG'="PS",PKG'="OR" S ERROR="This order may not be renewed!" Q
 I (ORDSTS=11)!(ORDSTS=10) S ERROR="This order has not been released to the service." Q
 I ACTSTS=12 S ERROR="Orders that have been dc'd due to editing may not be renewed!" Q
 I $P(OR3,U,6) S ERROR="This order has already been "_$S($P($G(^OR(100,+$P(OR3,U,6),3)),U,11)=1:"changed!",1:"renewed!") Q
 I PKG="OR" D  Q  ;Generic orders
 . I $$INACTIVE S ERROR="Orders for inactive orderables may not be renewed!" Q
 . I DG="ADT" S ERROR="M.A.S. orders may not be renewed!" Q
 . I "^1^2^6^7^"[(U_ORDSTS_U) Q  ;ok
 . S ERROR="This order may not be renewed!"
 I (PKG="PS"),$$INACTIVE S ERROR="Orders for inactive orderables may not be renewed!" Q
 I '$$MEDOK S ERROR="This drug may not be ordered!" Q
RN1 N PSIFN S PSIFN=$G(^OR(100,+IFN,4))
 I PSIFN<1,'$O(^OR(100,+IFN,2,0)) S ERROR="Missing or invalid order number!" Q
 I DG="O RX" D  Q  ;Outpt Meds
 . ; IHS/CIA/DKM - 10/11/2005 - Modified next 3 lines to support ORWOR RX EXPIRED MAX parameter
 . ;N ORZ,ORD S ORZ=$L($T(RENEW^PSORENW),",")
 . ;I ORZ>1 S ORD=+$$VALUE^ORX8(+IFN,"DRUG"),X=$$RENEW^PSORENW(PSIFN,ORD)
 . ;S:ORZ'>1 X=$$RENEW^PSORENW(PSIFN) I X<1 S ERROR=$P(X,U,2) Q
 . N ORZ,ORD,DAYS S ORZ=$L($T(RENEW^PSORENW),","),DAYS=$$GET^XPAR("ALL","ORWOR RX EXPIRED MAX")
 . I ORZ>1 S ORD=+$$VALUE^ORX8(+IFN,"DRUG"),X=$$RENEW^PSORENW(PSIFN,ORD,DAYS)
 . S:ORZ'>1 X=$$RENEW^PSORENW(PSIFN,,DAYS) I X<1 S ERROR=$P(X,U,2) Q
 . S X=+$P(X,U,2) D:X RESET(+IFN,X)
 . I $O(^OR(100,+IFN,4.5,"ID","MISC",0)) D DOSES^ORCACT02(+IFN) ;old format
 I DG="UD RX",$$NTBG(+IFN) S ERROR="This order has been marked 'Not to be Given' and may not be renewed!" Q
 I ORDSTS=7,'$$IV,$P(OR0,U,9)<$$FMADD^XLFDT(DT,-4)  S ERROR="Inpatient med orders may not be renewed more than 4 days after expiration!" Q
 I ORDSTS'=6,ORDSTS'=7 S ERROR="This order may not be renewed!" Q
RN2 I $O(^OR(100,+IFN,2,0))!$P(OR3,U,9) D  Q:$D(ERROR)!'PSIFN
 . I $P(OR3,U,9),$$VALUE^ORX8(+IFN,"SCHEDULE",1,"E")="NOW" S ERROR="One-time NOW orders may not be renewed!" Q
 . N DAD,ORD3,I,Y S DAD=$S($P(OR3,U,9):+$P(OR3,U,9),1:+IFN),Y=0
 . S ORD3=$G(^OR(100,DAD,3)) I $P(ORD3,U,6) S ERROR="This complex order has already been renewed!" Q
 . I $P(ORD3,U,3)'=6 S ERROR="This complex order is not active and may not be renewed!" Q
 . I '$$AND^ORX8(DAD) S ERROR="Complex orders with sequential doses may not be renewed!" Q
 . S I=0 F  S I=+$O(^OR(100,DAD,2,I)) Q:I<1  D  Q:Y
 .. I $P($G(^OR(100,I,3)),U,3)'=6 S Y=1,ERROR="Complex orders with terminated doses may not be renewed!" Q
 .. I PSIFN<1 S X=$$ACTIVE^PSJORREN(+ORVP,$G(^OR(100,I,4))) I +X'=1 S ERROR="This order may not be renewed: "_$S(+X>1:"Inactive orderable item",1:$P(X,U,2)) Q
 ;I DG="TPN" S ERROR="TPN orders may not be renewed!" Q
 S X=$$ACTIVE^PSJORREN(+ORVP,PSIFN) Q:+X=1  ;Ok
 I +X>1,$P(X,U,2) D RESET(+IFN,+$P(X,U,2)) Q  ;replace OI
 S ERROR="This order may not be renewed: "_$P(X,U,2)
 Q
 ;
XX ; -- edit/change--
 I PKG="RA",ORDSTS'=11,ORDSTS'=10 S ERROR="Orders released to Radiology cannot be changed!" Q
 I PKG="LR",ORDSTS'=11,ORDSTS'=10 S ERROR="Orders released to Lab cannot be changed!" Q
 I PKG="FH",ORDSTS'=11,ORDSTS'=10 S ERROR="Orders released to Dietetics cannot be changed!" Q
 I PKG="GMRC",ORDSTS'=11,ORDSTS'=10 S ERROR="Orders released to Consults cannot be changed!" Q
 I DG="TPN" S ERROR="TPN orders may not be changed!" Q
 I ORDSTS=3 S ERROR="Orders on hold may not be changed!" Q
 I DG="UD RX",$$NTBG(+IFN) S ERROR="This order has been marked 'Not to be Given' and may not be changed!" Q
 I $O(^OR(100,+IFN,2,0)) S ERROR="Complex orders may not be changed!" Q
 I $P(OR3,U,9) D  Q:$D(ERROR)
 . Q:$$VALUE^ORX8(+IFN,"SCHEDULE",1,"E")="NOW"  ;NOW ok
 . Q:'$O(^OR(100,+$P(OR3,U,9),4.5,"ID","CONJ",0))  ;no conj=1dose/ok
 . S ERROR="Complex orders may not be changed!" Q
 I $P(OR3,U,6) S ERROR="This order may not be changed - a "_$S($P($G(^OR(100,+$P(OR3,U,6),3)),U,11)=1:"change",1:"renewal")_" order already exists!" Q
 I $P(OR3,U,11)=2 D  Q:$D(ERROR)
 . ;IHS/MSC/PLS - 11/04/2010 - Restore behavior
 . ;I (ORDSTS=10!(ORDSTS=11)),DG'="O RX" S ERROR="Unreleased renewals may not be changed!" Q
 . I (ORDSTS=10!(ORDSTS=11)) S ERROR="Unreleased renewals may not be changed!" Q
 . I PKG="PS",ORDSTS=5 S ERROR="Pending renewals may not be changed!" Q
 I $$INACTIVE S ERROR="Orders for inactive orderables may not be changed; please enter a new order!" Q
 I PKG="PS",'$$MEDOK S ERROR="This drug may not be ordered!" Q
 I DG="O RX",$O(^OR(100,+IFN,4.5,"ID","MISC",0)) D DOSES^ORCACT02(+IFN) ;old form
 Q
 ;
INACTIVE() ; -- Returns 1 or 0, if OI is now inactive
 N I,OI,PREOI,PREOIX,X,Y,ORNOW,DD,PSOI S Y=0,ORNOW=$$NOW^XLFDT
 S I=0 F  S I=+$O(^OR(100,+IFN,4.5,"ID","ORDERABLE",I)) Q:I'>0  D  Q:Y
 . S OI=+$G(^OR(100,+IFN,4.5,I,1))
 . I OI S X=$G(^ORD(101.43,OI,.1)) I X,X<ORNOW S Y=1
 I Y,PKG="PS",DG'="IV RX" D  ;replacement OI?
 . S I=+$O(^OR(100,+IFN,4.5,"ID","DRUG",0)) Q:I'>0  ;first
 . S DD=+$G(^OR(100,+IFN,4.5,I,1)) Q:DD'>0  Q:$G(OI)'>0
 . S PSOI=+$P($G(^ORD(101.43,OI,0)),U,2),X=$$ITEM^PSSUTIL1(PSOI,DD)
 . Q:X'>0  S X=+$O(^ORD(101.43,"ID",+$P(X,U,2)_";99PSP",0)) Q:X'>0
 . I $G(^ORD(101.43,X,.1)),$G(^(.1))<ORNOW Q  ;make sure new OI is active
 . S I=+$O(^OR(100,+IFN,4.5,"ID","ORDERABLE",0))
 . IF I D
 . . S PREOI=$G(^OR(100,+IFN,4.5,I,1))
 . . S PREOIX=$O(^OR(100,+IFN,.1,"B",PREOI,0))
 . . K ^OR(100,+IFN,.1,"B",PREOI,PREOIX)
 . . S ^OR(100,+IFN,.1,"B",X,PREOIX)=""
 . . S ^OR(100,+IFN,.1,PREOIX,0)=X
 . . S ^OR(100,+IFN,4.5,I,1)=X
 . . S Y=0 ;reset
 Q Y
 ;
MEDOK() ; -- Returns 1 or 0, if med OI usage=Y
 N Y,OI,ORPS,X S Y=1,X=$P(OR0,U,12)
 I (DG="SPLY")!(DG="O RX")!(DG="I RX")!(DG="UD RX") D
 . S OI=+$O(^OR(100,+IFN,4.5,"ID","ORDERABLE",0))
 . S OI=+$G(^OR(100,+IFN,4.5,OI,1))
 . S ORPS=$G(^ORD(101.43,OI,"PS"))
 I DG="SPLY",'$P(ORPS,U,5) S Y=0
 I DG="O RX",'(X="O"&$P(ORPS,U,2)),'(X="I"&($P(ORPS,U)=2)) S Y=0
 I DG="I RX"!(DG="UD RX"),'$P(ORPS,U) S Y=0
 I DG="IV RX" D
 . N I,X0,X1 S I=0
 . F  S I=+$O(^OR(100,+IFN,4.5,"ID","ORDERABLE",I)) Q:I<1  D  Q:Y<1
 .. S X0=$G(^OR(100,+IFN,4.5,I,0)),X1=+$G(^(1))
 .. I $P($G(^ORD(101.41,+$P(X0,U,2),0)),U)["ADDITIVE" S:'$P($G(^ORD(101.43,X1,"PS")),U,4) Y=0 Q
 .. S:'$P($G(^ORD(101.43,X1,"PS")),U,3) Y=0
 I Y,$G(OI) S Y=$$OI^APSPMULT(OI,+$G(DFN))
 Q Y
 ;
IV() ; -- IV order, either Inpt or Fluid?
 I DG="IV RX" Q 1
 N I,OI,X S I=+$O(^OR(100,IFN,4.5,"ID","ORDERABLE",0))
 S OI=+$G(^OR(100,IFN,4.5,+I,1)),X=$P($G(^ORD(101.43,+OI,"PS")),U)
 Q (X>1)
 ;
NTBG(ORIFN) ; -- Inpt order marked as 'Not to be Given'?
 N PSIFN,Y,ORI,ORCH S Y=""
 S PSIFN=$G(^OR(100,+ORIFN,4)) I PSIFN>0 Q $$ENNG^PSJORUT2(+ORVP,PSIFN)
 S ORI=0 F  S ORI=$O(^OR(100,+ORIFN,2,ORI)) Q:ORI'>0  S ORCH=+$G(^(ORI,0)),PSIFN=$G(^OR(100,ORCH,4)) I PSIFN>0 S Y=$$ENNG^PSJORUT2(+ORVP,PSIFN) Q:Y
 Q Y
 ;
RESET(IFN,NEWOI) ; -- Update OI if changed before renewing
 Q:'$G(IFN)  Q:'$D(^OR(100,+IFN,0))  Q:'$G(NEWOI)
 N I,ORIT S ORIT=+$O(^ORD(101.43,"ID",NEWOI_";99PSP",0)) Q:ORIT'>0
 S I=$O(^OR(100,+IFN,4.5,"ID","ORDERABLE",0))
 S:I ^OR(100,+IFN,4.5,I,1)=ORIT
 Q
