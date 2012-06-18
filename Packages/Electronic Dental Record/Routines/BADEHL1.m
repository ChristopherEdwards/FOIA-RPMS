BADEHL1 ;IHS/MSC/MGH/PLS/VAC/AMF - Dentrix HL7 interface  ;17-Nov-2010;AMF
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/AMF - 11/23/10 - More descriptive alert messages
 ;; Modified - IHS/MSC/VAC, IHS/SAIC/FJE, IHS/MSC/PLS,AMF - 9/10/10,1/3/11 - Fix for DUZ(2) problem
 Q
 ; Build Outbound A28 or A31 HL7 segments
NEWMSG(DFN,EVNTTYPE) ;EP
 N HLPM,HLST,ARY,HLQ,APPARMS,HLPM,HLMSGIEN,HLECH,HLFS,ERR,WHO
 N LN,HL1,HRCN,FLD,LP,X,LN
 S LN=0
 S HLPM("MESSAGE TYPE")="ADT"
 S HLPM("EVENT")=EVNTTYPE
 S HLPM("VERSION")=2.4
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) D  Q
 .D NOTIF(DFN,"Unable to build HL7 message. "_$G(ERR)) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 ;Create segments
 ;
 D EVN(EVNTTYPE)
 I '$D(ERR) D PID(DFN)
 I '$D(ERR) D PD1(DFN)
 I '$D(ERR) D NK1
 I '$D(ERR) D INS^BADEHLI
 I '$D(ERR) D ZP2^BADEHLZ
 I '$D(ERR) D
 .; Define sending and receiving parameters
 .S APPARMS("SENDING APPLICATION")="RPMS-DEN"
 .S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 .S APPARMS("APP ACK RESPONSE")="AACK^BADEHL1"  ;Callback when 'application ACK' is received
 .S APPARMS("ACCEPT ACK RESPONSE")="CACK^BADEHL1"  ;Callback when 'commit ACK' is received
 .S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 .S APPARMS("QUEUE")="DENT ADT"   ;Incoming QUEUE
 .;S APPARMS("RECEIVING APPLICATION")="DENTRIX"
 .;S APPARMS("FACILITY LINK NAME")="DENTRIX"
 .;S APPARMS("FAILURE RESPONSE")="FAILURE^DENTHL1"  ;Callback for transmission failures (i.e. - No 'commit ACK' received or message not sendable.
 .S WHO("RECEIVING APPLICATION")="DENTRIX"
 .S WHO("FACILITY LINK NAME")="DENTRIX"
 .;S WHO("STATION NUMBER")=11555  ;Used for testing on external RPMS system
 .I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D
 ..D NOTIF(DFN,"Unable to send HL7 message. "_$G(ERR)) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ;
AACK ; EP - Application ACK callback - called when AA, AE or AR is received.
 N DATA,AACK,XQAID,XQDATA,XQA,XQAMSG,MSGID
 Q:'$G(HLMSGIEN)
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S AACK=$G(^HLB(HLMSGIEN,4))
 I $P(AACK,U,3)'["|AA|" D
 .S XQAMSG="EDR message "_MSGID_" did not receive a correct application ack."
 .S XQAID="ADEN,"_MSGID_","_50
 .S XQDATA=$P(AACK,U,3)
 .S XQA("G.RPMS DENTAL")=""
 .D SETUP^XQALERT
 Q
 ;
CACK ; EP - Commit ACK callback - called when CA, CE or CR is received.
 N CACK,XQAID,XQAMSG,XQA,XQDATA,MSGID
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S CACK=$G(^HLB(HLMSGIEN,4))
 I $P(CACK,U,3)'["|CA|" D
 .S XQAMSG="EDR message "_MSGID_" did not receive a correct commit acknowledgement."
 .S XQAID="ADEN,"_MSGID_","_50
 .S XQDATA=$P(CACK,U,3)
 .S XQA("G.RPMS DENTAL")=""
 .D SETUP^XQALERT
 Q
 ;
 ; Send Notification to group
 ; Input: DFN = Patient
 ;        MSG = Main message
NOTIF(DFN,MSG) ;EP ----- IHS/MSC/AMF 11/23/10 More descriptive alert
 N PVDIEN,RET,X,SAVE,STR,LEN
 N XQA,XQAID,XQADATA,XQAMSG
 S LEN=$L("Patient:  ["_DFN_"]. "_$G(MSG))
 S STR=$P($G(^DPT(DFN,0)),U,1) I ($L(STR)+LEN)>70 S STR=$E(STR,1,(67-LEN))_"..."
 S XQAMSG="Patient: "_STR_" ["_DFN_"]. "_$G(MSG)
 ; ----- end IHS/MSC/AMF 11/23/10 
 S XQAID="ADEN,"_DFN_","_50
 S XQDATA="DFN="_DFN
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 ;Save the DFN in a parameter for correction
 S X=$$GET^XPAR("ALL","BADE EDR TOTAL ERRORS",1,"E")
 S X=X+1
 S SAVE=DFN_" "_MSG
 D EN^XPAR("SYS","BADE EDR ERROR PTS",X,SAVE)
 D EN^XPAR("SYS","BADE EDR TOTAL ERRORS",1,X)
 Q
 ;
ERR ;
 Q
 ;
EVN(EVNTTYPE) ;Create the EVN segment
 N %,X,FLD,VAL
 D NOW^%DTC
 S X=$$HLDATE^HLFNC(%,"TS")
 D SET(.ARY,"EVN",0)
 D SET(.ARY,EVNTTYPE,1)
 S FLD="ADT^"_EVNTTYPE
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,5,LP)
 D SET(.ARY,X,2)
 D SET(.ARY,"01",4)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF($G(DFN),"Can't create EVN. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ; Create PID segment
PID(DFN) ;EP
 N PID,HRCN,FLD,LP,VAL,ASU
 ;Q:'$G(DFN)
 I '$G(DFN) S ERR="PID ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 ;Q:$G(^DPT(DFN,0))=""
 I $G(^DPT(DFN,0))="" S ERR="PID ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 ;Q:$P($G(^DPT(DFN,0)),U,1)=""
 I $P($G(^DPT(DFN,0)),U,1)="" S ERR="PID ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 N ASU,PID,SGM,X,LP,VAL,HLQ,MSTS
 S HLQ=HL1("Q")
 S PID=$$EN^VAFHLPID(DFN,"2,3,5,6,7,8,11,13,14,16,17,19,",1)
 ;Q:PID=""
 I PID="" S ERR="PID ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 D SET(.ARY,"PID",0)
 D SET(.ARY,1,1)
 D SET(.ARY,DFN,2)
 ;IHS/MSC/PLS,AMF 1/3/11 Fix for DUZ problem
 ;S HRCN=$$HRCNF^BDGF2(DFN,DUZ(2))
 ;S HRCN=$$GETCHART(DFN,DUZ(2))
 S HRCN=$$FINDHRN(DFN,$S($G(AGDUZ2):AGDUZ2,1:DUZ(2)))
 ;end fix for DUZ problem
 S ASU=0
 S ASU=$$ASUFAC^BADEHL1(DFN)
 I ASU=0 I '$G(BADELOAD) S ERR="PID ERROR" D NOTIF(DFN,"No ASUFAC.  Can't create PID.") Q  ;SAIC/FJE 08/04/2011;IHS/MSC/AMF 11/23/10 More descriptive alert
 I '$G(BADELOAD) I '+HRCN S ERR="PID ERROR" D NOTIF(DFN,"No HRN.  Can't create PID.") Q  ;SAIC/FJE 08/04/2011;IHS/MSC/AMF 11/23/10 More descriptive alert
 D SET(.ARY,$P(HRCN,U),3,1) ; Patient HRN IHS/MSC/AMF 1/3/11 DUZ problem
 ;D SET(.ARY,"MR",3,5)  ; Medical Record
 ;S ASU=$$ASUFAC^BADEHL1(DFN)  ;Get all HRCNs for this patient
 S FLD=$P(PID,HLFS,6)  ; Patient Name
 I FLD="" S ERR="PID ERROR" D NOTIF(DFN,"No name.  Can't create PID.") Q  ;SAIC/FJE 08/04/2011;IHS/MSC/AMF 11/23/10 More descriptive alert
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,5,LP)
 D SET(.ARY,"L",5,7)
 D ALIAS(DFN)
 I $P(PID,HLFS,8)="" S ERR="PID ERROR" D NOTIF(DFN,"No Date of Birth.  Can't create PID.") Q  ;SAIC/FJE 08/04/2011;IHS/MSC/AMF 11/23/10 More descriptive alert
 S FLD=$$HLNAME^XLFNAME($$GET1^DIQ(2,DFN,.2403))  ; Mother's Maiden Name
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,6,LP)
 D SET(.ARY,"M",6,7)
 D SET(.ARY,$P(PID,HLFS,8),7)  ; Date of Birth
 D SET(.ARY,$P(PID,HLFS,9),8)  ; Gender
 S FLD=$P(PID,HLFS,12)  ; Patient Address
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .;Fix for zipcode
 .S:LP=5 VAL=$$FIXZIP(DFN,VAL)
 .D SET(.ARY,VAL,11,LP)
 I $L($P(PID,HLFS,14)) D
 .D SET(.ARY,$P(PID,HLFS,14),13)  ; Patient Home Phone
 .D SET(.ARY,"PRN",13,2)
 .D SET(.ARY,"PH",13,3)
 I $L($P(PID,HLFS,15)) D
 .D SET(.ARY,$P(PID,HLFS,15),14)  ; Patient Work Phone
 .D SET(.ARY,"WPH",14,2)
 .D SET(.ARY,"PH",14,3)
 ; PID-15 (Language) not captured in RPMS
 S MSTS=$$GET1^DIQ(2,DFN,.05,"I")
 D SET(.ARY,$$GET1^DIQ(11,MSTS,90001),16,1)  ; Marital Status HL7 Code
 D SET(.ARY,$$GET1^DIQ(2,DFN,.05),16,2)  ; Marital Status Text
 D SET(.ARY,$$GET1^DIQ(2,DFN,.08),17,2)  ; Religion
 ; PID-18 (Patient Account #) not captured in RPMS
 D SET(.ARY,$P(PID,HLFS,20),19)  ; Patient SSN
 D SET(.ARY,$$HLDATE^HLFNC($$GET1^DIQ(2,DFN,.351,"I"),"TS"),29)  ; Patient Date of Death
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(DFN,"Can't create PID. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ;Add Aliases to segment
ALIAS(DFN) ;EP
 N AL,FLD,LP,ALN,CNT
 ;Q:'$G(DFN)
 I '$G(DFN) S ERR="ALAIS ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 S CNT=2
 S AL=0 F  S AL=$O(^DPT(DFN,.01,AL)) Q:'AL  D
 .S ALN=$P(^DPT(DFN,.01,AL,0),U)
 .S FLD=$$HLNAME^HLFNC(ALN)
 .F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,5,LP,1,CNT)
 .D SET(.ARY,"A",5,7,1,CNT)
 .S CNT=CNT+1
 Q
 ; Create Primary Provider segment
PD1(DFN) ;EP
 ;Q:'$G(DFN)
 I '$G(DFN) S ERR="PID ERROR" D NOTIF(DFN,"Can't create PID for:  "_DFN) Q  ;SAIC/FJE 08/04/2011
 N PPRV,FLD,LP,PD1
 D SET(.ARY,"PD1",0)
 S PPRV=$$GET1^DIQ(9000001,DFN,.14,"I")
 S FLD=PPRV_$E(HLECH)_$$HLNAME^HLFNC($$GET1^DIQ(9000001,DFN,.14))
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,4,LP)
 S PD1=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(DFN,"Can't create PD1. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ; Create next of kin and emergency contact segment
NK1 ;EP
 N ADDR,NK1,NODE,PHONE,DGNAME,FLD,K,CNT,SHIP,REL,HLQ
 S CNT=0
 S HLQ=HL1("Q")
 F K="EC","NOK" D
 .I K="EC" S NODE=$G(^DPT(DFN,.33))
 .I K="NOK" S NODE=$G(^DPT(DFN,.21))
 .Q:NODE=""
 .S CNT=CNT+1
 .D SET(.ARY,"NK1",0)
 .D SET(.ARY,CNT,1)
 .S DGNAME("FILE")=2,DGNAME("IENS")=DFN
 .S DGNAME("FIELD")=$S(K="NOK":.211,K="EC":.331)
 .;Name of next of kin
 .S FLD=$$HLNAME^XLFNAME(.DGNAME,"","^")
 .F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,2,LP)
 .;Relationship
 .S SHIP=$S(K="EC":$P($G(^AUPNPAT(DFN,31)),U,2),K="NOK":$P($G(^AUPNPAT(DFN,28)),U,2))
 .I SHIP'="" D
 ..S X=$P($G(^AUTTRLSH(SHIP,0)),U,2)_"^"_$P($G(^AUTTRLSH(SHIP,0)),U,1)_"^UB-92"
 ..F LP=1:1:$L(X,$E(HLECH)) S VAL=$P(X,$E(HLECH),LP) D
 ...D SET(.ARY,VAL,3,LP)
 .S ADDR=$$ADDR^VAFHLFNC($P(NODE,U,3,8))
 .F LP=1:1:$L(ADDR,$E(HLECH)) S VAL=$P(ADDR,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,4,LP)   ;Address
 .S PHONE=$$HLPHONE^HLFNC($P(NODE,U,9))
 .I $L(PHONE) D
 ..D SET(.ARY,PHONE,5)    ;Home phone
 ..D SET(.ARY,"PRN",5,2)
 ..D SET(.ARY,"PH",5,3)
 .S PHONE=$$HLPHONE^HLFNC($P(NODE,U,11))
 .I $L(PHONE) D
 ..D SET(.ARY,PHONE,6)  ;Work phone
 ..D SET(.ARY,"WPH",6,2)
 ..D SET(.ARY,"PH",6,3)
 .D SET(.ARY,K,7)
 .D SET(.ARY,$S(K="EC":"Emergency Contact",K="NOK":"Next of Kin",1:""),7,2)
 .S NK1=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 .I $D(ERR) D NOTIF(DFN,"Can't create NK1. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
ASUFAC(DFN) ;Set up all the ASUFAC numbers for this patient
 N IEN,DATA,LOC,HRN,DATE,ASUFAC,FAC,LP,VAL,REP,PART
 S IEN=0,FAC=""
 F  S IEN=$O(^AUPNPAT(DFN,41,IEN)) Q:'IEN  D
 .S DATA=$G(^AUPNPAT(DFN,41,IEN,0))
 .S LOC=$P(DATA,U,1),DATE=$$HLDATE^HLFNC($P(DATA,U,3))
 .S ASUFAC=$$GETCHART(DFN,LOC)
 .I FAC="" S FAC=ASUFAC_"^"_DATE
 .E  S FAC=FAC_"~"_ASUFAC_"^"_DATE
 I FAC="" Q 0
 F REP=1:1:$L(FAC,$E(HLECH,2,2)) S PART=$P(FAC,$E(HLECH,2,2),REP) D
 .F LP=1:1:$L(PART,$E(HLECH)) S VAL=$P(PART,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,4,LP,,REP)
 ..D SET(.ARY,"ASUFAC",4,LP+1,,REP)
 Q 1
GETCHART(P,L) ;
 N S,C,%
 ; ----- IHS/SAIC/FJE 11/5/2010 
 S (X,LL)=0 F  S X=$O(^AUPNPAT(P,41,X)) Q:+X=0!(LL=L)  D
 .S Y=$G(^AUPNPAT(P,41,X,0))
 .Q:$L($P(Y,"^",3))
 .Q:'$L($P(Y,"^",2))
 .S LL=$P(Y,"^",1)
 I +LL I LL'=L S L=LL
 K LL,X,Y
 ; ----- end IHS/SAIC/FJE 11/5/2010
 S S=$P(^AUTTLOC(L,0),U,10)
 I S="" Q S
 S S=$E("000000",1,6-$L(S))_S
 S C=$P($G(^AUPNPAT(P,41,L,0)),U,2)
 I C="" Q C
 S C=$E("000000",1,6-$L(C))_C
 S %=S_C
 Q %
 ; Create MSA segment
 ; ----- IHS/MSC/PLS,AMF 1/3/2011 
FINDHRN(PAT,LOC) ;DD
 N L,RET,X
 S RET=""
 S X=$G(^AUPNPAT(PAT,41,LOC,0))
 I $L($P(X,U,2)),'$P(X,U,3) S RET=$$FMTHRN(LOC,$P(X,U,2))
 I RET="" D
 .S L=0 F  S L=$O(^AUPNPAT(PAT,41,L)) Q:'L  D  Q:$L(RET)
 ..S X=$G(^AUPNPAT(PAT,41,L,0))
 ..Q:$P(X,U,3)  ;Inactivated entry
 ..Q:'$L($P(X,U,2))  ;No HRN
 ..S RET=$$FMTHRN(L,$P(X,U,2))_U_-1_U_LOC
 Q RET
FMTHRN(L,HRN) ;
 N S
 S S=$P(^AUTTLOC(L,0),U,10)
 I S="" Q S
 S S=$E("000000",1,6-$L(S))_S
 Q:'$L(HRN) HRN
 S HRN=$E("000000",1,6-$L(HRN))_HRN
 Q S_HRN
MSA ;EP
 N MSA
 D SET(.ARY,"MSA",0)
 D SET(.ARY,"AA",1)
 D SET(.ARY,"TODO-MSGID",2)
 D SET(.ARY,"Transaction Successful",3)
 D SET(.ARY,"todo-010",4)
 S MSA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create MSH segment
 ;EP
 N MSH
 D SET(.ARY,"MSH",0)
 S MSH=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Fix for non-working ZIPCODE Field trigger in File 2
FIXZIP(DFN,ZIP) ;EP
 Q:$G(ZIP) ZIP
 Q $$GET1^DIQ(2,DFN,.116)
