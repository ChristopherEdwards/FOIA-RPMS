BADEHLZ ;IHS/MSC/MGH/PLS/VAC - Dentrix HL7 interface  ;16-Jul-2009 10:35;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified IHS/MSC/AMF 11/23/10 More descriptive alerts
 Q
ZP2 ;Create the ZP2 segment
 N AFFIL,TRIBE,ZP2,NODE,NODE11,NODE26,SSN,FLD,K,X,CNT,TEXT,CODE
 N LP,VAL,BENE,ERR,SSNSTAT
 N BCITY,BSTATE,TMV,TMVE,EMC,EMCE,FCITY,FNAME,FSTATE,MCITY,MSTATE,HLOC
 N HREG,LOC,REG,REM,REM1
 S CNT=0
 S NODE=$G(^AUPNPAT(DFN,0))
 S NODE11=$G(^AUPNPAT(DFN,11))
 S NODE26=$G(^AUPNPAT(DFN,26))
 Q:NODE=""
 S CNT=CNT+1
 D SET^BADEHL1(.ARY,"ZP2",0)
 D SET^BADEHL1(.ARY,CNT,1)
 ;Date of last reg
 S X=$$HLDATE^HLFNC($P(NODE,U,3))
 D SET^BADEHL1(.ARY,X,2)
 ;outpt release date
 S X=$$HLDATE^HLFNC($P(NODE,U,4))
 D SET^BADEHL1(.ARY,X,3)
 ;revoked date
 S X=$$HLDATE^HLFNC($P(NODE,U,5))
 D SET^BADEHL1(.ARY,X,4)
 ;Enrollment Number
 D SET^BADEHL1(.ARY,$P(NODE,U,7),5)
 ;Tribal affiliation
 S AFFIL=$P(NODE,U,9)
 I AFFIL'="" D
 .S TRIBE=$P($G(^AUTTTRI(AFFIL,0)),U,1)
 .S CODE=$P($G(^AUTTTRI(AFFIL,0)),U,2)
 .S X=CODE_"^"_TRIBE
 .F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ..D SET^BADEHL1(.ARY,VAL,6,LP)
 ;Blood type code
 D SET^BADEHL1(.ARY,$P(NODE,U,13),7)
 ;Assigned benefits obtained date
 S X=$$HLDATE^HLFNC($P(NODE,U,17))
 D SET^BADEHL1(.ARY,X,9)
 ;Assigned benefits expired date
 S X=$$HLDATE^HLFNC($P(NODE,U,18))
 D SET^BADEHL1(.ARY,X,10)
 ;SSN verification status
 S SSN=$P(NODE,U,23)
 I SSN'="" D
 .S SSNSTAT=$P($G(^AUTTSSN(SSN,0)),U,1),TEXT=$P($G(^AUTTSSN(SSN,0)),U,2)
 .D SET^BADEHL1(.ARY,SSNSTAT,11,1)  ;SSN Verification Status Code
 .D SET^BADEHL1(.ARY,TEXT,11,2)  ;SSN Verification Status Text
 .D SET^BADEHL1(.ARY,"99IHS",11,3)
 ;Reason for no SSN
 S SSN=$P(NODE,U,24)
 I SSN'="" D
 .S TEXT=$S(SSN=1:"Not Available",SSN=2:"Patient Refused",SSN=3:"Patient will submit",1:"")
 .S X=SSN_"^"_TEXT_"^99IHS"
 .F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ..D SET^BADEHL1(.ARY,VAL,12,LP)
 ;Birth place city/state
 S BCITY=$P($G(^DPT(DFN,0)),U,11)
 S BSTATE=$P($G(^DPT(DFN,0)),U,12)
 S BSTATE=$$GET1^DIQ(5,BSTATE,1)
 D SET^BADEHL1(.ARY,BCITY,13,3)  ; Birth City
 D SET^BADEHL1(.ARY,BSTATE,13,4) ; Birth State Abbrev
 ;S X="^^"_BCITY_"^"_BSTATE
 ;F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ;.D SET^BADEHL1(.ARY,VAL,13,LP)
 ;Birth certificate number
 D SET^BADEHL1(.ARY,$P(NODE11,U,5),14)
 ;Tribe of membership
 S TRIBE=$P(NODE11,U,8)
 I TRIBE'="" D
 .S TEXT=$P($G(^AUTTTRI(TRIBE,0)),U,1)
 .S CODE=$P($G(^AUTTTRI(TRIBE,0)),U,2)
 .S X=CODE_"^"_TEXT_"^99IHS"
 .F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ..D SET^BADEHL1(.ARY,VAL,15,LP)
 ;Tribe quantum
 D SET^BADEHL1(.ARY,$P(NODE11,U,9),16)
 ;Indian quantum
 D SET^BADEHL1(.ARY,$P(NODE11,U,10),17)
 ;classification beneficiary
 S BENE=$P(NODE11,U,11)
 I BENE D
 .D SET^BADEHL1(.ARY,$$GET1^DIQ(9999999.25,BENE,.02),18,1)
 .D SET^BADEHL1(.ARY,$$GET1^DIQ(9999999.25,BENE,.01),18,2)
 .D SET^BADEHL1(.ARY,"99IHS",18,3)
 ;Current residence date
 S X=$$HLDATE^HLFNC($P(NODE11,U,13))
 D SET^BADEHL1(.ARY,X,19)
 D SET^BADEHL1(.ARY,$$GET1^DIQ(5,$P(NODE11,U,15),1),20)  ;State of Death
 D SET^BADEHL1(.ARY,$P(NODE11,U,16),21)  ;Death Certificate Number
 ;current community
 D SET^BADEHL1(.ARY,$P(NODE11,U,18),22)
 ;tribe membership verified
 S TMV=$P(NODE11,U,19)
 I TMV'="" D
 .S TMVE=$$EXTERNAL^DILFD(9000001,1119,"",TMV)
 .S X=TMV_"^"_TMVE_"^99IHS"
 .F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ..D SET^BADEHL1(.ARY,VAL,23,LP)
 ;residence verified
 D SET^BADEHL1(.ARY,$P(NODE11,U,21),24)
 ;date eligibility determined
 D SET^BADEHL1(.ARY,$$HLDATE^HLFNC($P(NODE11,U,23)),25)
 ;eligible minor child code
 S EMC=$P(NODE11,U,25)
 I EMC'="" D
 .S EMCE=$$EXTERNAL^DILFD(9000001,1125,"",EMC)
 .S X=EMC_"^"_EMCE_"^99IHS"
 .F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ..D SET^BADEHL1(.ARY,VAL,26,LP)
 D SET^BADEHL1(.ARY,$$GETWP(DFN,12,100,HLECH),27)  ; Location of Home
 D SET^BADEHL1(.ARY,$$GETWP(DFN,13,100,HLECH),28)  ; Additional reg information
 D SET^BADEHL1(.ARY,$$GETWP(DFN,14,100,HLECH),29)  ; Remarks
 ;father's name
 S FNAME=$$GET1^DIQ(2,DFN_",",.2401)
 D SET^BADEHL1(.ARY,FNAME,31)
 ;father's city/state
 S FCITY=$P(NODE26,U,2),FSTATE=+$P(NODE26,U,3)
 ;I FSTATE'="" S FSTATE=$P($G(^DIC(5,FSTATE,0)),U,1)
 S FSTATE=$$GET1^DIQ(5,FSTATE,1)  ; State Abbrev
 S X="^^"_FCITY_"^"_FSTATE
 F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 .D SET^BADEHL1(.ARY,VAL,32,LP)
 ;mother's city/state
 S MCITY=$P(NODE26,U,5),MSTATE=+$P(NODE26,U,6)
 ;I MSTATE'="" S MSTATE=$P($G(^DIC(5,MSTATE,0)),U,1)
 S MSTATE=$$GET1^DIQ(5,MSTATE,1)  ; State Abbrev
 S X="^^"_MCITY_"^"_MSTATE
 F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 .D SET^BADEHL1(.ARY,VAL,33,LP)
 S ZP2=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF^BADEHL1(DFN,"Can't create ZP2. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ;Return text in WP array
 ;Input:
 ; DFN: Patient pointer
 ; NODE: File 9000001
 ; LIMIT: Max characters (defaults to 500)
GETWP(DFN,NODE,LIMIT,HLECH) ;
 N RET,LP,VAL
 S LIMIT=$G(LIMIT,500)
 S RET="",LP=0
 Q:'$D(^AUPNPAT(DFN,NODE)) RET
 F  S LP=$O(^AUPNPAT(DFN,NODE,LP)) Q:'LP  D  Q:$L(RET)>(LIMIT-1)
 .S VAL=$G(^AUPNPAT(DFN,NODE,LP,0))
 .I ($L(RET)+($L(VAL)-1))>LIMIT D
 ..S RET=RET_" "_$E(VAL,1,(LIMIT-($L(RET)+1)))
 .E  D
 ..S RET=RET_" "_VAL
 Q $TR(RET,"|","_")  ; translate field separator to underscore
