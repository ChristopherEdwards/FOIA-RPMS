BEHOARCV ;MSC/IND/DKM - Cover Sheet: Adverse Reactions ;31-Mar-2011 09:07;DU
 ;;1.1;BEH COMPONENTS;**027002**;Mar 20, 2007;Build 1
 ;=================================================================
 ; Return adverse reaction info for a patient
LIST(DATA,DFN,UNRL,NOIN) ;
 N CNT,REASON,LP,LP2,RESTA,IN,INACTIVE,REC,ER,RXN,STA,SEV,SGN,X,Y,Z,X1,RTYP,INACT,ALCNT,REACT
 N NIEN,INZ,INSTA,INIEN,REA2,REACTBY
 S CNT=0
 S UNRL=$G(UNRL),IN=$G(IN),NOIN=$G(NOIN),(LP,CNT,ALCNT)=0,DATA=$$TMPGBL^CIAVMRPC
 S Y=$O(^GMR(120.86,DFN,9999999.11,$C(0)),-1) I +Y D
 .I $P($G(^GMR(120.86,DFN,9999999.11,Y,0)),U,4)="" D
 ..S X1="Unassessable"
 ..S INIEN=Y_","_DFN
 ..S REASON=$$GET1^DIQ(120.869999911,INIEN,1)
 ..I REASON'="" D
 ...I REASON="OTHER" S REA2=$$GET1^DIQ(120.869999911,INIEN,5) S REASON=REASON_" "_REA2
 ...D ADD("-1^Unassessable: "_REASON)
 F  S LP=$O(^GMR(120.8,"B",DFN,LP)) Q:'LP  D
 .S INZ=0,REACTBY=""
 .S REC=$G(^GMR(120.8,LP,0)),ER=+$G(^("ER"))
 .Q:(+REC'=DFN)!(ER=1)
 .S Z=$O(^GMR(120.8,LP,9999999.12,$C(0)),-1) I +Z D
 ..S INACT=$P($G(^GMR(120.8,LP,9999999.12,Z,0)),U,1)
 ..S REACT=$P($G(^GMR(120.8,LP,9999999.12,Z,0)),U,4)
 ..I +INACT&(REACT="") S INZ=1
 ..I REACT'="" S REACTBY=$P($G(^GMR(120.8,LP,9999999.12,Z,0)),U,5)
 .S SGN=($P(REC,U,5)=DUZ!(REACTBY=DUZ))&'$P(REC,U,12)
 .I ER=2,'UNRL!'SGN Q
 .S LP2=0,RXN=""
 .F  S LP2=$O(^GMR(120.8,LP,10,LP2)) Q:'LP2  S X=$G(^(LP2,0)) D
 ..S X=$$GET1^DIQ(120.83,+X,.01)
 ..S:$L(X) RXN=RXN_$S($L(RXN):";",1:"")_X
 .S LP2=0,SEV=""
 .F  S LP2=$O(^GMR(120.85,"C",LP,LP2)) Q:'LP2  D
 ..S X=$P($G(^GMR(120.85,LP2,0)),U,14)
 ..S SEV=$S(X>SEV:X,1:SEV)
 .S:SEV SEV=$$EXTERNAL^DILFD(120.85,14.5,,SEV)
 .S STA=$S($P(REC,U,16):"V",$P(REC,U,12):"S",1:"U")
 .S RTYP=$P(REC,U,20)
 .S (INSTA,RESTA)=""
 .Q:(INZ=1)&(+NOIN)
 .I INZ=1 S INSTA=INACT
 .S ALCNT=ALCNT+1
 .D ADD(LP_U_$P(REC,U,2)_U_SEV_U_RXN_U_SGN_U_STA_U_INSTA_U_RTYP)
 I 'ALCNT D
 .S CNT=0
 .S X=$P($G(^GMR(120.86,DFN,0)),U,2)
 .S Y=$O(^GMR(120.86,DFN,9999999.11,$C(0)),-1)
 .I +Y  D
 ..I $P($G(^GMR(120.86,DFN,9999999.11,Y,0)),U,4)="" D
 ...D ADD("^Unassessable "_REASON_" and no "_$S('$L(X):"Allergy Assessment",'X:"Known Allergies",1:"Allergies Found"))
 ..E  D ADD("^No "_$S('$L(X):"Allergy Assessment",'X:"Known Allergies",1:"Allergies Found"))
 .E  D ADD("^No "_$S('$L(X):"Allergy Assessment",'X:"Known Allergies",1:"Allergies Found"))
 Q
 ; Detail view for adverse reaction
DETAIL(DATA,DFN,ADR) ;
 N RXN,LP,LP2,LBL,CNT,Y,INIEN,REASON,X1
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 I ADR=-1 D  Q
 .S Y=$O(^GMR(120.86,DFN,9999999.11,$C(0)),-1) I +Y D
 ..I $P($G(^GMR(120.86,DFN,9999999.11,Y,0)),U,4)="" D
 ...S INIEN=Y_","_DFN
 ...S REASON=$$GET1^DIQ(120.869999911,INIEN,1)
 ...I REASON'="" D
 ....I REASON="OTHER" S REA2=$$GET1^DIQ(120.869999911,INIEN,5) S REASON=REASON_" "_REA2
 ...D ADD("Unassessable: "_REASON)
 ...D ADD("Date: "_$$GET1^DIQ(120.869999911,INIEN,.01))
 ...D ADD("User: "_$$GET1^DIQ(120.869999911,INIEN,2))
 D EN1^GMRAOR2(ADR,"RXN")
 D ADD($P(RXN,U),"Causative agent:")
 I DUZ("AG")'="I" D
 .S RXNORM=$$RXNORM(ADR)  ;Get the RXNorm code for this agent
 .I +RXNORM D ADD(RXNORM,"RxNorm:")
 I $P(RXN,U,12)'="" D ADD($P(RXN,U,12),"Event:"),ADD()
 D:$D(RXN("S",1)) SYM,ADD()
 D:$D(RXN("V",1)) CLS,ADD()
 D:$D(RXN("I",1)) ING,ADD()
 D ADD($P(RXN,U,2)_"  "_$P(RXN,U,3),"Originated:")
 S X=$$FMTE^XLFDT($P(RXN,U,10)) D ADD(X,"Origination Date:")
 D ADD()
 D:$D(RXN("O",1)) OBS,ADD()
 S X1="" S X1=$P(RXN,U,9)
 I +X1 S X1=" Date: "_$$FMTE^XLFDT(X1)
 D ADD($S($P(RXN,U,4)="VERIFIED":"Yes",1:"No")_" "_X1,"Verified:")
 I $P(RXN,U,4)="VERIFIED" D ADD($P(RXN,U,8),"Verified by:")
 D ADD()
 D ADD($S($P(RXN,U,5)="OBSERVED":"Observed",$P(RXN,U,5)="HISTORICAL":"Historical",1:""),"Observed/Historical:")
 I $P(RXN,U,11)'="" D ADD($P(RXN,U,11),"Source:"),ADD()
 ;IHS/MSC/MGH Add inactive data
 D:$D(RXN("N",1)) INAC,ADD()
 D:$D(RXN("C",1)) COM,ADD()
 ;IHS/MSC/MGH Add last modified
 D LAST
 Q
SYM S LP=0,LBL="Signs/symptoms:"
 F  S LP=$O(RXN("S",LP)) Q:'LP  D ADD(RXN("S",LP),.LBL)
 Q
CLS S LP=0,LBL="Drug Classes:"
 F  S LP=$O(RXN("V",LP)) Q:'LP  D ADD($P(RXN("V",LP),U,2),.LBL)
 Q
ING S LP=0,LBL="Ingredients:"
 F  S LP=$O(RXN("I",LP)) Q:'LP  D ADD($P(RXN("I",LP),U,1),.LBL)
 Q
OBS S LP=0,LBL="Obs dates/severity:"
 F  S LP=$O(RXN("O",LP)) Q:'LP  D ADD($$DT(+RXN("O",LP))_" "_$P(RXN("O",LP),U,2),.LBL)
 Q
INAC ;add inactivity time
 S LP=0
 F  S LP=$O(RXN("N",LP)) Q:'LP  D
 .D ADD($P(RXN("N",LP),U,1),"Inactivation Date:")
 .D ADD($P(RXN("N",LP),U,2),"Inactivation Reason:")
 .D ADD($P(RXN("N",LP),U,3),"Inactivated By:")
 .I $P(RXN("N",LP),U,6)'="" D ADD($P(RXN("N",LP),U,6),"Comment:")
 .I $P(RXN("N",LP),U,4)'="" D
 ..D ADD($P(RXN("N",LP),U,4),"Reactivation Date:")
 ..D ADD($P(RXN("N",LP),U,5),"Reactivated By:")
 Q
LAST ;Get last modified
 N LP,MOD,IIEN,X,Y
 S LP=9999999 S LP=$O(^GMR(120.8,ADR,9999999.14,LP),-1) Q:'+LP  D
 .S MOD=$G(^GMR(120.8,ADR,9999999.14,LP,0))
 .S IIEN=LP_","_ADR_","
 .S X=$$GET1^DIQ(120.899999914,IIEN,.01),Y=$$GET1^DIQ(120.899999914,IIEN,.02)
 .S X=X_" by "_Y
 .D ADD(X,"Last Modified:")
 Q
COM S LP=0,LBL="Comments:"
 D ADD()
 F  S LP=$O(RXN("C",LP)),LP2=0 Q:'LP  D
 .N X
 .D:$L(LBL) ADD(,.LBL)
 .S X=$P(RXN("C",LP),U,2)
 .S:$L(X) X=" by "_X
 .D ADD("   "_$$DT(+RXN("C",LP))_X)
 .F  S LP2=$O(RXN("C",LP,LP2)) Q:'LP2  D ADD("    "_RXN("C",LP,LP2,0))
 Q
RXNORM(ADR) ;Find and add the RxNorm code
 N NDC,RXNORM,TYPE,GEN,DRUG
 S RXNORM=0
 S TYPE=$P($G(^GMR(120.8,ADR,0)),U,3)
 I $P(TYPE,";",2)="PSNDF(50.6," D
 .;Its a VA generic drug, now find all the drugs attached and look for
 .;RXNorm
 .S GEN=$P(TYPE,";",1)
 .S DRUG="" F  S DRUG=$O(^PSDRUG("AND",GEN,DRUG)) Q:'+DRUG!(+RXNORM)  D
 ..S IENS=DRUG_","
 ..S NDC=$$GET1^DIQ(50,IENS,31)
 ..Q:'$L(NDC)
 ..S NDC=$TR(NDC,"-","")
 ..S:$L(NDC)=12 NDC=$E(NDC,2,12)
 ..S RXNORM=+$O(^C0CRXN(176.002,"NDC",NDC,0))
 ..S RXNORM=$$GET1^DIQ(176.002,RXNORM,.01)
 Q RXNORM
 ; Format date/time
DT(Y) D DD^%DT
 Q Y
 ; Add to output array
ADD(TXT,LBL) ;
 S CNT=CNT+1 S @DATA@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_$G(TXT),LBL=""
 Q
 ; Ingredients and VA drug classes
 ;
