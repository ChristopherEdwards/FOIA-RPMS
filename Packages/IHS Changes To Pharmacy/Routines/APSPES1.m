APSPES1 ;IHS/MSC/PLS - SureScripts HL7 interface  ;31-Oct-2013 12:09;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1009,1011,1013,1014,1016**;Sep 23, 2004;Build 74
 ;====================================================================
 ;Patch 1016 added AL1 segment and RXC segment
 Q
 ; Build NewRx HL7 segments
NEWRX(RXIEN) ;EP
 N HLPM,HLST,ERR,ARY,HLECH,HLFS,APPARMS
 N RX0,RX2,DFN,LN,HL1
 S LN=0
 S HLPM("MESSAGE TYPE")="OMP"
 S HLPM("EVENT")="O09"
 S HLPM("VERSION")=2.5
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) D  Q
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to create HL7 message")
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("COM")="eRx request failed"
 .S ARY("TYPE")="F"
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 S RX0=^PSRX(RXIEN,0)
 S RX2=^PSRX(RXIEN,2)
 S DFN=$P(RX0,U,2)
 ;Create segments
 D PID(DFN),ORCNW("NW",1),RXO(1),RXR,RXC,DG1,AL1
 ; Define sending and receiving parameters
 S APPARMS("SENDING APPLICATION")="APSP RPMS"
 S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 ;S APPARMS("APP ACK RESPONSE")="AACK^APSPES1"  ;Callback when 'application ACK' is received
 S APPARMS("ACCEPT ACK RESPONSE")="CACK^APSPES1"  ;Callback when 'commit ACK' is received
 S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 S APPARMS("QUEUE")="APSP ERX"   ;Incoming QUEUE
 S APPARMS("FAILURE RESPONSE")="FAILURE^APSPES4"  ;Callback for transmission failures (i.e. - No 'commit ACK' received or message not sendable.
 S WHO("RECEIVING APPLICATION")="SURESCRIPTS"
 S WHO("FACILITY LINK NAME")="APSP EPRES"
 I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to send request")
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("COM")="eRx request failed"
 .S ARY("TYPE")="F"
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 E  D  ; Update activity log
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("TYPE")="T"
 .S ARY("COM")="eRx request sent to "_$$PHMINFO^APSPES2(RXIEN)
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 Q
 ;
 ; Build ACK response
ACKRES ;
 N X S X="" Q
 ; MSH, MSA segments
 ;
 Q
 ;
AACK ; EP - Application ACK call back - called when AA, AE or AR is received.
 N DATA,RXIEN,AACK,ARY,RET
 Q:'$G(HLMSGIEN)
 S RXIEN=$$RXIEN^APSPES2(HLMSGIEN)
 S AACK=$G(^HLB(HLSMGIEN,4))
 I $P(AACK,U,3)'["|AA|" D
 .S MSG(1)="HL7 Message "_^HLB(HLMSGIEN,1)_^HLB(HLMSGIEN,2)
 .S MSG(2)=" "
 .S MSG(3)="did not receive a valid NEWRX acknowledgement."
 .S MSG(4)=AACK
 .S WHO("G.APSP EPRESCRIBING")=""
 .D BULL^APSPES2("HL7 ERROR","APSP eRx Interface",.WHO,.MSG)
 E  D
 .Q:'RXIEN
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("TYPE")="U"
 .S ARY("COM")="eRx update: Received acknowledgement from SureScripts"
 .D UPTLOG^APSPFNC2(.RET,+RXIEN,0,.ARY)
 Q
 ;
CACK ; EP - Commit ACK callback - called when CA, CE or CR is received.
 N CACK
 S CACK=$G(^HLB(HLMSGIEN,4))
 I $P(CACK,"^",3)'["|CA|" D
 .S MSG(1)="HL7 Message "_^HLB(HLMSGIEN,1)_^HLB(HLMSGIEN,2)
 .S MSG(2)=" "
 .S MSG(3)="did not receive a valid NEWRX acknowledgement."
 .S MSG(4)=CACK
 .S WHO("G.APSP EPRESCRIBING")=""
 .D BULL^APSPES2("HL7 ERROR","APSP eRx Interface",.WHO,.MSG)
 Q
 ;
ARSP ; EP - callback for ORP/O10 event
 N AACK,MSG,WHO,OPRV,ARY,RET,RXIEN,DATA,HLMSTATE,MSA
 N SEGIEN,SEGMSA,MSGIEN,SEGERR,ERRTXT,TXT
 S MSGIEN=0,TXT=0
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN(.DATA,"MSA")
 I 'SEGIEN D  Q
 .D BADORP^APSPES4
 M SEGMSA=DATA(SEGIEN)
 S MSGIEN=+$P($$GET^HLOPRS(.SEGMSA,2)," ",2)
 S AACK=$$GET^HLOPRS(.SEGMSA,1)
 S TXT=$$GET^HLOPRS(.SEGMSA,3)
 I AACK'="AA" D
 .S SEGIEN=$$FSEGIEN(.DATA,"ERR")
 .M SEGERR=DATA(SEGIEN)
 .S ERRTXT=$$GET^HLOPRS(.SEGERR,8)
 S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 S OPRV=$$OPRV^APSPES2(MSGIEN)
 S ARY("REASON")="X"
 S ARY("RX REF")=0
 S ARY("USER")=OPRV
 I AACK'="AA" D  Q
 .D BADORP^APSPES4
 .I RXIEN D
 ..S ARY("TYPE")="F"
 ..S ARY("COM")=$S($L($G(ERRTXT)):ERRTXT,1:"ERROR: eRx did not transmit.")
 ..D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 ..D NOTIF^APSPES4(RXIEN,"ERROR: eRx did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Transmission was not accepted"))
 Q:'RXIEN
 S ARY("TYPE")="U"
 S ARY("COM")=$S(TXT'="":TXT,1:"eRx update: Prescription delivered to pharmacy.")
 D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 Q
ARSPRE ;Refill request call back for ERROR
 D ARSP
 Q
 ;
ERR ;
 Q
 ; Create MSH segment
MSH(ARY) ;EP
 Q
 ; Create PID segment
PID(DFN) ;EP
 Q:'$G(DFN)
 N PID,SGM,X,LP,VAL,FLD,HLQ,SSN
 S HLQ=""
 S PID=$$EN^VAFHLPID(DFN,"3,5,7,8,11P,13,19,",1)
 D SET(.ARY,"PID",0)
 D SET(.ARY,$$HRCNF^BDGF2(DFN,DUZ(2)),3,1)  ; Patient HRN
 D SET(.ARY,"MR",3,5)  ; Medical Record
 S FLD=$P(PID,HLFS,6)  ; Patient Name
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,5,LP)
 D SET(.ARY,$P(PID,HLFS,8),7)  ; Date of Birth
 D SET(.ARY,$P(PID,HLFS,9),8)  ; Gender
 S FLD=$P(PID,HLFS,12)  ; Patient Address
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,11,LP)
 ;IHS/MSC/PLS - 10/25/2013
 S SSN=$P(PID,HLFS,20)
 I SSN="" D
 .N NOSSNR
 .S NOSSNR=$$GET1^DIQ(9000001,DFN,.24,"I")
 .I NOSSNR S SSN=NOSSNR_"0000000"
 D SET(.ARY,SSN,19)  ; Patient SSN
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create ORC segment
ORCNW(OCC,ADD) ;EP
 N ORC,INST,NM,LP,VAL,IMMSUP,IMMNPI,ORDER,RRIEN,SSNUM,HLO,HLOIEN,HLB7
 S ADD=$G(ADD,1)
 D SET(.ARY,"ORC",0)
 D SET(.ARY,OCC,1)
 D SET(.ARY,RXIEN,2,1)
 D SET(.ARY,"OP7.0",2,2)
 D SET(.ARY,"D"_$P(RX0,U,8),7,3)   ;Days Supply
 D ORC7
 D SET(.ARY,$$HLDATE^HLFNC($P(RX0,U,13),"DT"),9)   ;Issue Date
 D SET(.ARY,+$P(RX0,U,16),10,1)  ;Entered By IEN
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(RX0,U,16),.01),HLECH)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,10,LP+1)
 ;_$E(HLECH)_$$HLNAME^HLFNC($P(RX0,U,16),HLECH),10)  ;Entered By
 S IMMSUP=$$GET1^DIQ(49,$$GET1^DIQ(200,+$P(RX0,U,4),29,"I"),2,"I")
 S IMMNPI=$$GET1^DIQ(200,+IMMSUP,41.99) ; Immediate Supervisor NPI
 D SET(.ARY,IMMNPI,11)
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,IMMSUP,.01),HLECH)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,11,LP+1)  ;Immediate Supervisor (Chief of service)
 D SET(.ARY,$$SPI(+$P(RX0,U,4)),12)
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(RX0,U,4),.01),HLECH)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,12,LP+1)  ;Provider
 D SET(.ARY,$$PRVDEA^APSPES9(+$P(RX0,U,4)),12,10)  ; DEA
 D SET(.ARY,+$P(RX0,U,5),13,1)
 D SET(.ARY,$$GET1^DIQ(44,+$P(RX0,U,5),.01),13,2)  ;Clinic
 D SET(.ARY,$$HLPHONE^HLFNC($$GET1^DIQ(44,+$P(RX0,U,5),99)),14)  ;Clinic Phone
 D SET(.ARY,$$HLDATE^HLFNC($P(RX2,U,13),"DT"),15)  ;Fill Date
 D:ADD SET(.ARY,"NW",16)
 S INST=+$$GETRINST($P(RX2,U,9))
 S:'INST INST=+$G(DUZ(2))
 D SET(.ARY,$$GET1^DIQ(4,INST,.01),21)  ; Institution Name
 D SET(.ARY,$$HLPHONE^HLFNC($$GET1^DIQ(9999999.06,INST,.13)),23,1)
 D SET(.ARY,"WPN",23,2)
 D SET(.ARY,"PH",23,3)
 D SET(.ARY,$$GET1^DIQ(4,INST,1.01),24,1)  ; Institution Address 1
 D SET(.ARY,$$GET1^DIQ(4,INST,1.02),24,2)  ; Institution Address 2
 D SET(.ARY,$$GET1^DIQ(4,INST,1.03),24,3)  ; Institution City
 D SET(.ARY,$$GET1^DIQ(5,$$GET1^DIQ(4,INST,.02,"I"),1),24,4)  ; Institution State Abbreviation
 D SET(.ARY,$E($$GET1^DIQ(4,INST,1.04,"I"),1,5),24,5)  ; Institution 5 digit Zip Code
 ;Code added to return Surescripts number if a new order following a deny
 S ORDER=$$GET1^DIQ(52,RXIEN,39.3)
 S RRIEN=$$VALUE^ORCSAVE2(ORDER,"SSRREQIEN")
 I +RRIEN D
 .S HLB7=""
 .S SSNUM=$$GET1^DIQ(9009033.91,RRIEN,.1)
 .S HLO=$$GET1^DIQ(9009033.91,RRIEN,.01)         ;Message ID
 .S HLOIEN=$O(^HLB("B",HLO,""))
 .I +HLOIEN S HLB7=$P($G(^HLB(HLOIEN,0)),U,7)
 .D SET(.ARY,SSNUM,3,1)
 .D SET(.ARY,HLB7,3,2)
 S:ADD ORC=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; ORC-7 Dosing Support
ORC7 ;
 N LP,D,DU,CMP,CONJ
 S LP=0,CMP=1 F  S LP=$O(^PSRX(RXIEN,6,LP)) Q:'LP  D
 .S D=^PSRX(RXIEN,6,LP,0)
 .S CMP=CMP+1
 .S DU=$$DRGUNITS($P(RX0,U,6))
 .D SET(.ARY,DU,7,1,1,CMP)  ; Drug Units
 .;D SET(.ARY,$P(D,U),7,1,2,CMP)  ;
 .D SET(.ARY,$P(D,U,8),7,2,,CMP)  ; Interval
 .D SET(.ARY,$$ADJDUR($P(D,U,5)),7,3,,CMP) ; Duration
 .D SET(.ARY,"R",7,6,,CMP)  ; Priority
 .D SET(.ARY,$P(D,U),7,8,1,CMP)  ; Text
 .S CONJ=$P(D,U,6)
 .S CONJ=$S(CONJ="T":"S",1:"A")
 .D SET(.ARY,CONJ,7,9,1,CMP)
 .;D SET(.ARY,"S",7,9,1,CMP)  ; Conjunction
 Q
 ; Create ORC Refill Request segment
 ; Input: IORC = Incoming ORC segment
ORCRF(IORC) ;EP
 N ORC
 D SET(.ARY,"ORC",0)
 D SET(.ARY,"DF",1)
 D SET(.ARY,"AF",16,1)
 D SET(.ARY,"Patient should contact provider first",16,2)
 D SET(.ARY,"NCPDP1131",16,3)
 S ORC=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create RXO segment
RXO(ADD) ;EP
 N DSF,PHM,DNAME,X,FRM,DRG,NDC,RXNORM,DIEN,TYP,NIEN,TTY,APP,FOUND
 S TYP=""
 D SET(.ARY,"RXO",0)
 S NDC=$$NDC^APSPES4($P(RX0,U,6))
 S DIEN=$P(RX0,U,6)
 D SET(.ARY,NDC,1,1)  ; NDC Value
 ;IHS/MSC/MGH Patch 1016 change to use long name if available
 S DNAME=$P($G(^PSDRUG($P(RX0,U,6),999999935)),U,2)
 I DNAME="" S DNAME=$$GET1^DIQ(50,$P(RX0,U,6),.01)
 D SET(.ARY,DNAME,1,2)  ; Drug Name
 I +NDC D SET(.ARY,"NDC",1,3)  ; Coding System
 S DSF=$$GET1^DIQ(50.7,$$GET1^DIQ(52,RXIEN,39.2,"I"),.02,"I")  ; Dosage Form IEN
 S FRM=""
 S X=$$GDFORM(DSF,1)
 I +X S FRM=$$GET1^DIQ(9009033.7,X,3)
 D SET(.ARY,FRM,5,1)  ; Dosage Form Code
 D SET(.ARY,$$GDFMTXT(DSF),5,2)  ; Dosage Form Code Text
 D SET(.ARY,"X12DE1330",5,3)  ; Dosage Form Coding System
 D SET(.ARY,$$GETPRC(),6,2)  ; Provider Comments
 D SET(.ARY,$$GETSIG(),7,2)  ; SIG
 D SET(.ARY,$$SUBST(RXIEN),9)  ; Substitution (Default to allow)  N=Not authorized, G=Allowed Generic, T=Allow therapeutic
 D SET(.ARY,$P(RX0,U,7),11)  ; Quantity
 S DRG=$P(RX0,U,6)
 D SET(.ARY,$$QTYQUAL(DRG),12,1)  ; Quantity Qualifier
 D SET(.ARY,$$QTYTXT(DRG),12,2)  ; Quantity  Qualifier Code Text
 D SET(.ARY,"X12DE0335",12,3)  ; Quantity Qualifier Code List
 D SET(.ARY,+$P(RX0,U,9),13)  ; Number of refills
 D SET(.ARY,"",18)  ; Strength ;
 D SET(.ARY,$$SUNITS(),19)  ; Strength Units
 ;IHS/MGH/MGH added supplies and compounds patch 1016
 I $P($G(^PSDRUG(DIEN,999999935)),U,1)=1 S TYP="C"
 I $E($P($G(^PSDRUG(DIEN,0)),U,2),1,2)="XA"!($P($G(^PSDRUG(DIEN,0)),U,3)["S") S TYP="P"
 D SET(.ARY,TYP,27,1)        ;Supply or compound code
 I NDC'="" D
 .S RXNORM=$$RXNORM^APSPFNC1(NDC)
 .Q:RXNORM=""
 .D SET(.ARY,RXNORM,24,1)     ;RxNorm as alt id
 .S FOUND=0
 .S NIEN="" F  S NIEN=$O(^C0CRXN(176.001,"B",RXNORM,NIEN)) Q:NIEN=""!(FOUND=1)  D
 ..S TTY=""
 ..S APP=$$GET1^DIQ(176.001,NIEN,2)
 ..I APP="RXNORM" D
 ...S TTY=$$GET1^DIQ(176.001,NIEN,3)
 ...I TTY="SCD"!(TTY="SBD")!(TTY="GPCK")!(TTY="BPCK") D
 ....S FOUND=1
 ....S TTY=$S(TTY="GPCK":"GPK",TTY="BPCK":"BPK",1:TTY)
 ....D SET(.ARY,TTY,24,2)     ;TTY code
 .D SET(.ARY,"RXNORM",24,3)   ;Code List
 S PHM=$$GPHM(RXIEN)
 I PHM D
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,.02),32,1)  ; Pharmacy NCPDP Provider ID
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,.01),32,2)  ; Pharmacy Name
 .D SET(.ARY,"D3",32,3)  ; Pharmacy NCPDP Provider ID
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,.04),32,4)  ; Pharmacy NPI
 .D SET(.ARY,"HPI",32,6)
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,1.1),33,1)  ; Pharmacy Address
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,1.2),33,2) ; Address second line
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,1.3),33,3)  ; Pharmacy City
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,1.4),33,4)  ; State
 .D SET(.ARY,$$GET1^DIQ(9009033.9,PHM,1.5),33,5)  ; Zip
 .D SET(.ARY,$$HLPHONE^HLFNC($$GET1^DIQ(9009033.9,PHM,2.1)),36,1)  ; Telephone
 .D SET(.ARY,"WPN",36,2)  ; Work Phone
 .D SET(.ARY,"PH",36,3)   ; Phone
 .S:ADD PHM=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create RXR segment
RXR ;EP
 D RXR^APSPES4
 Q
RXC ; Create RXC segment
 D RXC^APSPES4
 Q
 ; Create DG1 segment
DG1 ;EP -
 D DG1^APSPES4
 Q
 ; Create AL1 segment
AL1 ;EP -
 D AL1^APSPES4
 Q
 ; Create MSA segment
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
 ; Return Related Institution for prescription
 ; Input: Pharmacy Division IEN
 ; Output: Institution Pointer (File 4)
GETRINST(PDIV) ;EP
 Q $$GET1^DIQ(59,PDIV,100,"I")
 ; Return NCPDP Route
GROUTE(RIEN) ;EP
 N RXROUTE
 S RXROUTE=$$GET1^DIQ(51.2,RIEN,.01)
 Q RXROUTE
 ; Return NCPDP Dosage Form Code
 ; Input: FORM = IEN to Dosage Form File
 ;        TYPE = 0(default) returns code; 1 returns IEN
GDFORM(FORM,TYPE) ;EP
 Q $$GET1^DIQ(50.606,FORM,9999999.01,$S($G(TYPE):"I",1:"E"))
 ; Return NCPDP Dosage Form Code Text
GDFMTXT(FORM) ;EP
 Q $$GET1^DIQ(9009033.7,$$GDFORM(FORM,1),1)
 ; Return NCPDP Quantity Qualifier mapped to Dispense Unit NCPDP Code field in File 50
 ; Input: DIEN- IEN to Drug File (50)
 ; Output: Returns .01 field value from APSP NCPDP Control Codes file
QTYQUAL(DIEN) ;EP
 N X,RET
 S RET=""
 S X=$$GET1^DIQ(50,DIEN,9999999.145,"I")
 I +X S RET=$$GET1^DIQ(9009033.7,X,3)
 Q RET
QTYTXT(DIEN) ;EP
 N X,RET
 S RET=""
 S X=$$GET1^DIQ(50,DIEN,9999999.145,"I")
 I +X S RET=$$GET1^DIQ(9009033.7,X,1)
 Q RET
 ; Return Pharmacy IEN
GPHM(RXIEN) ;EP
 Q $P($G(^PSRX(RXIEN,999999921)),U,4)
 ; Return Unit from Drug File
DRGUNITS(DIEN) ;EP
 Q $$GET1^DIQ(50,DIEN,902)
 ; Return NCPDP Units
SUNITS() ;EP
 Q ""
 ; Return adjusted Duration Value
ADJDUR(VAL) ;
 N N,D
 Q:'VAL "INDEF"
 S N=$E(VAL,1,$L(VAL)-1)
 S D=$E(VAL,$L(VAL))
 Q D_N
 ; Find and return prepared segment array
PREPARY(SRC,SEG,RET,START) ;
 N IEN,LP
 S IEN=$$FSEGIEN(.SRC,SEG,.START)
 Q:'IEN
 S LP=0 F  S LP=$O(SRC(IEN,LP)) Q:'LP  D
 .M RET(LP-1)=SRC(IEN,LP)
 Q
 ; Return IEN to particular segment in source array
 ; Optional START value can specify where in source to start search
FSEGIEN(SRC,SEG,START) ;
 N LP,RES
 S (LP,RES)=0
 S:$G(START) LP=START
 F  S LP=$O(SRC(LP)) Q:'LP  D  Q:RES
 .I $G(SRC(LP,"SEGMENT TYPE"))=SEG S RES=LP
 Q RES
 ; Return SIG as a single string
GETSIG() ;EP
 N LP,RET
 S RET=""
 S LP=0 F  S LP=$O(^PSRX(RXIEN,"SIG1",LP)) Q:'LP  D
 .S RET=RET_^PSRX(RXIEN,"SIG1",LP,0)
 Q RET
 ; Return Provider Comments as a single string
GETPRC() ;EP -
 N LP,RET
 S RET=""
 S LP=0 F  S LP=$O(^PSRX(RXIEN,"PRC",LP)) Q:'LP  D
 .S RET=RET_^PSRX(RXIEN,"PRC",LP,0)
 Q RET
 ; Return SPI number for user
SPI(USR) ; EP -
 Q $$GET1^DIQ(200,USR,43.99)
 ; Return HL7 substitution value
SUBST(RXIEN) ; EP -
 N VAL
 S VAL=$$GET1^DIQ(52,RXIEN,9999999.25,"I")
 Q $S(VAL=1!(VAL=7):"N",1:"G")
