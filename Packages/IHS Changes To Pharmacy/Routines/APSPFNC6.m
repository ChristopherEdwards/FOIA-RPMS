APSPFNC6 ;IHS/MSC/PLS - Prescription Creation Support ;22-Sep-2011 14:35;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1011,1012**;Sep 23, 2004;Build 5
 ;=================================================================
 ;Returns string containing the possible pickup locations
GPKUP(DATA,USR,OI) ; EP -
 N AUTORX,RET,C,CRX,RSCH
 S C=$$GET^XPAR("ALL","APSP AUTO RX CII PRESCRIBING")
 S CRX=$$GET^XPAR("ALL","APSP AUTO RX ERX OF CS II")
 S AUTORX=+$$GET^XPAR("ALL","APSP AUTO RX")
 S RSCH=$$GET^XPAR("ALL","APSP AUTO RX SCHEDULE RESTRICT")
 I AUTORX=0 D  ;Internal Pharmacy
 .S RET="CMW"
 E  I AUTORX=1 D  ;Internal and External Pharmacy
 .I '$$ERXUSER(USR) D  ;User not able to select E
 ..S RET="CMWP"
 .E  D
 ..S RET="CMWP"_$S($L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
 E  I AUTORX=2 D  ;External Pharmacy
 .I '$$ERXUSER(USR) D  ;User not able to select E
 ..S RET="CP"
 .E  D
 ..S RET="CP"_$S($L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
 S DATA=RET
 Q
 ; Returns ability of user to e-prescribe
 ; Input: USR - IEN to New Person File
 ; Output:   0 = e-Prescribing is not available to user
 ;           1 = e-Prescribing is available to user
ERXUSER(USR) ; EP
 N RET
 D ERXUSER^APSPFNC2(.RET,USR)
 Q RET
 ; Returns match of orderable item to drug schedule
 ; Input: OIIEN - Orderable Item IEN
 ;          SCH - SCHEDULE
 ;          TPL - Invert return value
ERXOI(OIIEN,SCH,TPL) ; EP
 N RET
 S TPL=+$G(TPL,0)
 D ERXOI^APSPFNC2(.RET,OIIEN,SCH)
 Q $S(TPL:RET,1:'RET)
 ; Retransmit eRX order
 ; Input: ORD - IEN to Order File (100)
 ; Output: 1 = resent
RESEND(DATA,ORD,RXNUM) ;EP -
 N PHARM,RX
 S PHARM=+$$VALUE^ORCSAVE2(+ORD,"PHARMACY")
 S RX=+$G(^OR(100,ORD,4))
 I $P($G(^PSRX(RX,0)),U)=RXNUM D
 .D EN^APSPELRX(RX,PHARM)
 S DATA=1
 Q
 ; Returns boolean value representing presence of reason and type in activity log.
CKRXACT(RX,REASON,TYPE) ;EP-
 N RES,LP,PR,PT
 S (LP,RES)=0
 Q:'$G(RX) RES
 Q:'$L($G(REASON)) RES
 S TYPE=$G(TYPE)
 F  S LP=$O(^PSRX(RX,"A",LP)) Q:'LP  D  Q:RES
 .S PR=$P(^PSRX(RX,"A",LP,0),U,2)
 .Q:PR'=REASON
 .S PT=$P($G(^PSRX(RX,"A",LP,9999999)),U,2)
 .Q:PT=""
 .S:TYPE[PT RES=1
 Q RES
