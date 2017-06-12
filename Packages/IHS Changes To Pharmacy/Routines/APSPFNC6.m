APSPFNC6 ;IHS/MSC/PLS - Prescription Creation Support ;29-Oct-2014 14:27;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1011,1012,1016,1017,1018**;Sep 23, 2004;Build 21
 ;=================================================================
 ;Returns string containing the possible pickup locations
GPKUP(DATA,USR,OI,ORDER) ; EP -
 N AUTORX,RET,C,CRX,RSCH,OKERX,AUTOOR
 S ORDER=$G(ORDER),AUTOOR=-1
 ;IHS/MSC/MGH 1016 If the order number is sent in and the order is e-prescribed, then renewals must be electronic.
 S:ORDER'="" AUTOOR=$$CHKERX(ORDER)
 S C=$$GET^XPAR("ALL","APSP AUTO RX CII PRESCRIBING")
 S CRX=$$GET^XPAR("ALL","APSP AUTO RX ERX OF CS II")
 S AUTORX=+$$GET^XPAR("ALL","APSP AUTO RX")
 S RSCH=$$GET^XPAR("ALL","APSP AUTO RX SCHEDULE RESTRICT")
 I AUTORX=0 D  ;Internal Pharmacy
 .S RET="CMW"
 E  I AUTORX=1 D  ;Internal and External Pharmacy
 .I '$$ERXUSER(USR) D  ;User not able to select E
 ..S RET=$S(AUTOOR>0:"CP",1:"CMWP")
 .E  D
 ..;IHS/MSC/MGH Patch 1016 Changes to incorporate ERX field
 ..S OKERX=$$OKTOUSE(OI,RSCH)
 ..I '+OKERX D
 ...S RET=$S(AUTOOR>0:"CP",'AUTOOR:"CMW",1:"CMWP")
 ..E  D
 ...S RET=$S(AUTOOR>0:"CP",'AUTOOR:"CMW",1:"CMWP")
 ...I AUTOOR'=0 S RET=RET_$S(OKERX=1:"E",$L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
 E  I AUTORX=2 D  ;External Pharmacy
 .I '$$ERXUSER(USR) D  ;User not able to select E
 ..S RET="CP"
 .E  D
 ..;IHS/MSC/MGH Patch 1016 Changes to incorporate ERX field
 ..S OKERX=$$OKTOUSE(OI,RSCH)
 ..I '+OKERX S RET="CP"
 ..E  S RET="CP"_$S(OKERX=1:"E",$L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
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
 ;Returns if this drug is OK to send as a eRX
OKTOUSE(OI,RSCH) ;function call
 N RES,IEN,STOP,POI,NODE
 S RES=1
 I $L(RSCH)&($$ERXOI(OI,RSCH)) Q 0
 S POI=$P($P($G(^ORD(101.43,OI,0)),U,2),";",1)
 I POI="" Q RES
 S IEN="" F  S IEN=$O(^PSDRUG("ASP",POI,IEN)) Q:IEN=""!(RES=0)  D
 .S NODE=$G(^PSDRUG(IEN,0))
 .Q:NODE=""
 .I $P($G(^PSDRUG(IEN,999999935)),U,3)=1 S RES=0
 Q RES
CHKERX(ORDER) ;Find out if ORDER was an eRX one
 N VALUE,RX
 S VALUE=0,ORDER=$P(ORDER,";")
 S RX="" S RX=$O(^PSRX("APL",ORDER,RX))
 Q:RX="" VALUE
 S VALUE=+$$GET1^DIQ(52,RX,9999999.23,"I")
 Q VALUE
 ; Return long name of drug
 ; Input: Order File IEN
GETLONG(RET,ORDER) ;EP-
 N DRUG
 S RET=""
 S DRUG=$$VALUE^ORCSAVE2(ORDER,"DRUG")
 Q:'+DRUG
 S RET=$$GET1^DIQ(50,DRUG,9999999.352)
 Q
 ; Return long name of drug
 ; Input: Drug File IEN
GETLNGDG(DRUG) ;EP-
 Q $$GET1^DIQ(50,DRUG,9999999.352)
 ;
 ; Find a site
LOC(ORIEN) ;
 N PSOLOC,PSOINS,PSOSITE
 S PSOLOC=$P($G(^OR(100,ORIEN,0)),U,10)
 S PSOSITE=$$GET^XPAR("LOC.`"_PSOLOC_U_"DIV.`"_DUZ(2)_"^SYS","APSP AUTO RX DIV")
 I 'PSOSITE D
 .S PSOSITE=0
 .I PSOLOC["SC" D
 ..S PSOLOC=+PSOLOC
 ..S PSOINS=$P($G(^SC(PSOLOC,0)),U,4)
 ..Q:'PSOINS
 ..S PSOSITE=$$DIV(PSOINS)
 .S:'PSOSITE PSOSITE=$$DIV(DUZ(2))
 .S:'PSOSITE PSOSITE=$$DIV(+$$SITE^VASITE)
 Q $S($G(PSOSITE):PSOSITE,1:0)
 ; This screen is used by the APSP AUTO RX DIV parameter.
 ; Input: DIV - Pointer to Institution (4) file
DIVSCN(ENT) ;
 I $G(ENT)["DIC(4," Q ''$$DIV(+ENT)
 I $G(ENT)["DIC(4.2," Q 1
 I $G(ENT)["SC(" Q 1
 Q 0
 ; Return Pharmacy Division
DIV(INS) Q $O(^PS(59,"D",+INS,0))
 ;
 ; Returns the last activity type for requested reason
LASTACT(RX,REASON) ;EP-
 N RES,LP,PR,PT,FLG
 S FLG=0,RES=""
 S LP=$C(1)
 Q:'$G(RX) RES
 Q:'$L($G(REASON)) RES
 F  S LP=$O(^PSRX(RX,"A",LP),-1) Q:'LP  D  Q:FLG
 .S PR=$P(^PSRX(RX,"A",LP,0),U,2)
 .Q:PR'=REASON
 .S FLG=1
 .S RES=$P($G(^PSRX(RX,"A",LP,9999999)),U,2)
 Q RES
