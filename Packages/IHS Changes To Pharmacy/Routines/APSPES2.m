APSPES2 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;05-Aug-2013 10:36;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1011,1016**;Sep 23, 2004;Build 74
 ; Return array of message data
 ; Input: MIEN - IEN to HLO MESSAGES and HLO MESSAGE BODY files
 ; Output: DATA
 ;         HLMSTATE
PARSE(DATA,MIEN,HLMSTATE) ;EP
 N SEG,CNT
 Q:'$$STARTMSG^HLOPRS(.HLMSTATE,MIEN)
 M DATA("HDR")=HLMSTATE("HDR")
 S CNT=0
 F  Q:'$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG)  D
 .S CNT=CNT+1
 .M DATA(CNT)=SEG
 Q
 ; Process incoming RDS message
DISP ;EP
 ;todo- check APP ACK TYPE
 N DATA,ARY,SEGORC,SEGIEN,SEGRXD,ERR,RET
 N DRG,DCODE,DCODEQ,PVDIEN,DSPNUM,RXIEN
 Q:'$G(HLMSGIEN)
 D PARSE(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ORC")
 Q:'SEGIEN 0
 M SEGORC=DATA(SEGIEN)
 Q:$$GET^HLOPRS(.SEGORC,1,1)'="OK"
 S PVDIEN=$$GET^HLOPRS(.SEGORC,10,1)
 S RXIEN=$$GET^HLOPRS(.SEGORC,2,1)
 Q:'RXIEN
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"RXD")
 Q:'SEGIEN
 M SEGRXD=DATA(SEGIEN)
 S DSPNUM=$$GET^HLOPRS(.SEGRXD,1)
 Q:'DSPNUM
 S DSPNUM=DSPNUM-1  ;Adjust fill offset - original = 0
 S DCODE=$$GET^HLOPRS(.SEGRXD,2,1)
 S DRG=$$GET^HLOPRS(.SEGRXD,2,2)
 S DCODEQ=$$GET^HLOPRS(.SEGRXD,2,3)
 S ARY("REASON")="X"
 S ARY("TYPE")="U"
 S ARY("RX REF")=$S(DSPNUM>5:DSPNUM+1,1:DSPNUM) ; adjust for 6=partial
 S ARY("COM")="DDrg:"_DRG_$S($L(DCODE):" ("_DCODEQ_":"_DCODE_")",1:"")
 S ARY("USER")=PVDIEN
 D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 I DATA("HDR","APP ACK TYPE")="AL" D
 .; Generate APP Ack
 .N PARMS,ACK,ERR
 .S PARMS("ACK CODE")="AA"
 .I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) W !,ERR Q
 .I '$$SENDACK^HLOAPI2(.ACK,.ERR) W !,ERR Q
 Q
DSP ;
 N HLMSGIEN,HLMSTATE,PARMS
 S HLMSGIEN=200000000001
 D PARSE(.DATA,HLMSGIEN,.HLMSTATE)
 S PARMS("ACK CODE")="AA"
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) W !,ERR Q
 I '$$SENDACK^HLOAPI2(.ACK,.ERR) W !,ERR Q
 Q
 ; Send bulletin
BULL(XMSUB,XMDUZ,WHO,MSG) ;EP
 N XMY,XMTEXT
 M XMY=WHO
 S XMTEXT="MSG("
 D ^XMD
 Q
 ; Return Ordering Provider for HL7 Message
OPRV(MSGIEN) ; EP
 N RXIEN,VAL
 S VAL=0
 S RXIEN=+$$RXIEN(MSGIEN)
 Q:'RXIEN ""
 Q +$P($G(^PSRX(RXIEN,0)),U,16)
 ; Return RX IEN
 ; Input: MSGIEN - HLO Message IEN
 ;           TGL - default to 0, 1=return numeric value in HL7 message
RXIEN(MSGIEN,TGL) ; EP
 N RET,RXN
 S TGL=$G(TGL,0)
 D PARSE(.DATA,MSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ORC")
 Q:'SEGIEN ""
 M SEGORC=DATA(SEGIEN)
 ;Q:$$GET^HLOPRS(.SEGORC,1,1)'="OK"
 S RXN=$$GET^HLOPRS(.SEGORC,2,1)
 S RET=$S(TGL:RXN,$D(^PSRX(+RXN,0)):+RXN,1:0)
 Q RET
 ; Return Pharmacy Info for Activity Log
 ; Input - RXIEN - Prescription IEN
PHMINFO(RXIEN) ; EP -
 N PHM
 S PHM=$$GPHM^APSPES1(RXIEN)
 Q:'PHM "UNKNOWN"
 Q $$GET1^DIQ(9009033.9,PHM,.01)_"  "_$$HLPHONE^HLFNC($$GET1^DIQ(9009033.9,PHM,2.1))
 ;
REFRES ; EP - Refill request callback
 ;Build response to Refill Request
 N DATA,PARMS,SEG,ACK,ARY,ERR,ORID,SEGRX0,REFILL,RR,ORITM,PRV,DFN
 N RXIEN,FN,DEA,MATCHK
 S MATCHK=""
 D PARSE^APSPES2(.DATA,$G(HLMSGIEN),.HLMSTATE)
 ; Create entry in APSP REFILL REQUEST file
 ; If possible, generate order
 S FN=9009033.91
 S RR=$$ADDRR(+$G(HLMSGIEN))
 Q:$$GET1^DIQ(9009033.91,RR,.03,"I")=8  ;Do not process duplicate record
 S RXIEN=+$$GET1^DIQ(9009033.91,RR,.06,"I")
 S DEA=$$DEA($P($G(^PSRX(RXIEN,0)),U,6))
 I RR,RXIEN D   ;,'$$DEACLS(DEA,2) D
 .I '$D(^PSRX(RXIEN,0)) D  Q
 ..S MATCHK=MATCHK_"Z"
 ..;S FDA(FN,RR_",",.03)=9
 ..;D FILE^DIE("K","FDA")
 ..;S MSGTXT="AG-RX to refill not in system"
 ..;D UPTRRACT^APSPES3(RR,MSGTXT)
 ..;D DENYRPC^APSPES3(.DATA,RR,MSGTXT)
 ..;D ERR900^APSPES4(RR,"PON does not match our records"
 .;Only allow automap if patient and provider match and there is an order
 .I MATCHK["P"&(MATCHK["D") D
 ..S ORID=$$GENRENEW^APSPES4(HLMSGIEN,RXIEN,$$GET1^DIQ(52,RXIEN,16,"I"),$$GETVAL(HLMSGIEN,"RXO",13,1),RR)
 ..I ORID D
 ...S FDA(FN,RR_",",.02)=+ORID
 ...S ORITM=$$VALUE^ORCSAVE2(+ORID,"ORDERABLE")
 ...S:ORITM FDA(FN,RR_",",1.1)=ORITM
 ...S FDA(FN,RR_",",.03)=1
 ...S FDA(FN,RR_",",1.3)=PRV
 ...S FDA(FN,RR_",",1.2)=DFN  ; Patient IEN
 ...S FDA(FN,RR_",",.11)=MATCHK
 ...D FILE^DIE("K","FDA")
 ...;MERGE DATA FROM ORDER RESPONSE LIST TO REFILL REQUEST RESPONSE LIST
 ...K ^APSPRREQ(RR,4.5)
 ...M ^APSPRREQ(RR,4.5)=^OR(100,ORID,4.5)
 ...S $P(^APSPRREQ(RR,4.5,0),U,2)="9009033.913A"
 ..E  D
 ...N DATA
 ...S MATCHK=MATCHK_"Z"
 ...S FDA(FN,RR_",",.03)=0  ;9   ;PLS
 ...S FDA(FN,RR_",",.11)=MATCHK  ;PLS
 ...D FILE^DIE("K","FDA")
 ...D UPTRRACT^APSPES3(RR,$P(ORID,U,2))
 ...;S MSGTXT="AG-Refill not appropriate"
 ...;D DENYRPC^APSPES3(.DATA,RR,MSGTXT)
 ...;D ERR900^APSPES4(RR,"Refill not appropriate")
 .E  D
 ..;Store the data but send it to the queue
 ..S:ORITM FDA(FN,RR_",",1.1)=ORITM
 ..I +PRV S FDA(FN,RR_",",1.3)=PRV
 ..I +DFN S FDA(FN,RR_",",1.2)=DFN  ; Patient IEN
 ..S FDA(FN,RR_",",.11)=MATCHK
 ..S FDA(FN,RR_",",.03)=0
 ..D FILE^DIE("K","FDA")
 E  D
 .;No order found store data and send to queue
 .;S ORITM=$$FNDORD^APSPES4(RR,HLMSGIEN)     ;Try and find the pharmacy orderable item for mapping in the queue
 .;I +ORITM D
 .N HL7PON,ERRFLG
 .S HL7PON=$$RXIEN(HLMSGIEN,1)  ;Get PON sent in HL7 request
 .I HL7PON?1.N,'(MATCHK["O") S ERRFLG=1
 .S:$G(ORITM) FDA(FN,RR_",",1.1)=ORITM
 .I +$G(DFN) S FDA(FN,RR_",",1.2)=DFN   ; Patient IEN
 .I +$G(PRV) S FDA(FN,RR_",",1.3)=PRV   ; Provider IEN
 .S FDA(FN,RR_",",.03)=$S($G(ERRFLG):9,1:0)
 .S FDA(FN,RR_",",.11)=MATCHK
 .D FILE^DIE("K","FDA")
 .I $G(ERRFLG) D
 ..D UPTRRACT^APSPES3(RR,"PON does not match our records")
 ..D ERR900^APSPES4(RR,"PON does not match our records")
 .;S MSGTXT=$P(ORID,U,2)
 .;D DENY1^APSPES3
 ;E  D
 ;.S MSGTXT="Schedule II not allowed."
 ;.D DENY1^APSPES3
 ; todo - Set Scheduled purge dt field (.09) in 778 to 30 days until processed.
 ;
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Add entry to REFILL REQUEST file
ADDRR(MSGIEN) ; EP -
 N FDA,FN,I,MSGID,ERR,IENS,SPI,RXIEN,DAYS,ACTSPI,NOTES
 N FILLS,HMSG,PHARM,SSNUM,DXCODE,DX,FIEN,DAW
 S FN=9009033.91,I="+1,",DFN=0,FIEN=0
 S FDA(FN,I,.01)=$$GET1^DIQ(778,MSGIEN,.01)  ; Message ID
 S FDA(FN,I,.04)=$$GET1^DIQ(778,MSGIEN,.16,"I")  ; Message D/T
 S FDA(FN,I,.05)=MSGIEN  ; HLO Message IEN
 S FDA(FN,I,.07)=$$NOW^XLFDT()  ; Last Update D/T
 ;Check for PON
 S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 S:RXIEN MATCHK=MATCHK_"O"
 ;Patient check for matching pts
 S:'DFN DFN=$$HRCNF^APSPFUNC($$GETVAL(MSGIEN,"PID",3,1))
 I DFN=-1 D
 .I 'RXIEN S DFN=$$CHKNME^APSPES4(MSGIEN)   ;See if pt in PID segment is in file 2
 .E  D
 ..;check the pt in the order against the pt in the PID segment
 ..S DFN=$$GET1^DIQ(52,RXIEN,2,"I")
 ..S DFN=$$CHKOPT^APSPES4(DFN)
 I +DFN S MATCHK=MATCHK_"P"        ;Patients match
 ;Medication check
 I RXIEN D
 .S ORITM=$$CHKDRG^APSPES4(MSGIEN,RXIEN)   ;Check the drug in the message
 E  D
 .S ORITM=$$FNDORD^APSPES4(MSGIEN)     ;Try and find the pharmacy orderable item for mapping in the queue
 I +ORITM S MATCHK=MATCHK_"M"          ;Drugs match
 ;Provider check
 S SPI=$$GETVAL(MSGIEN,"ORC",12,1)
 S PRV=$$FIND1^DIC(200,,"O",SPI,"ASPI")
 S ACTSPI=1
 I +PRV S ACTSPI=$$EFF(PRV)
 I 'RXIEN&(+PRV)&(+ACTSPI) S MATCHK=MATCHK_"D"
 I +RXIEN&(+PRV)&(+ACTSPI)&(PRV=$$GET1^DIQ(52,RXIEN,4,"I")) S MATCHK=MATCHK_"D"
 ;S:PRV FDA(FN,I,1.3)=PRV  ; Provider IEN
 S SSNUM=$$GETVAL(MSGIEN,"ORC",3,1)
 S FILLS=$$GETVAL(MSGIEN,"RXO",13,1)  ;Number of fills requested
 I FILLS=""!(FILLS=0) S FILLS=1
 ;S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 S:RXIEN FDA(FN,I,.06)=RXIEN  ; Original Prescription
 ;S PHARM=$$GET1^DIQ(52,RXIEN,9999999.24,"I")
 ;.S:PHARM FDA(FN,I,1.7)=PHARM  ; Requesting Pharmacy
 ;E  D
 S PHARM=$$GETVAL(MSGIEN,"RXE",40,1)
 S:PHARM PHARM=$$FIND1^DIC(9009033.9,,"O",PHARM,"C")
 S:PHARM FDA(FN,I,1.7)=PHARM
 S DAYS=$$GETVAL(MSGIEN,"ORC",7,3)   ; Days Supply
 I +DAYS=0 S DAYS=$E(DAYS,2,$L(DAYS))
 S DAW=$$GETVAL(MSGIEN,"RXO",9,1)    ; DAW
 S DAW=$S(DAW="G":0,DAW="T":0,1:1)
 S FDA(FN,I,1.5)=+DAYS
 S FDA(FN,I,1.4)=$$GETVAL(MSGIEN,"RXO",11,1)  ; Quantity
 S FDA(FN,I,1.9)=FILLS                        ; Number of fills
 S FDA(FN,I,.1)=SSNUM                         ; Surescripts number
 S FDA(FN,I,1.12)=DAW
 ;Add Diagnosis
 S DXCODE=$$GETVAL(MSGIEN,"DG1",3,1)
 S DX=$$GETVAL(MSGIEN,"DG1",3,2)
 I DX=""&(DXCODE'="") D
 .I $$AICD^BGOUTL2 S DX=$P($$ICDDX^ICDEX(DXCODE,DT),U,4)
 .E  S DX=$P($$ICDDX^ICDCODE(DXCODE,DT),U,4)
 S FDA(FN,I,7.1)=DX
 S FDA(FN,I,7.2)=DXCODE
 ;Add Notes to Pharmacist
 S NOTES=$$GETVAL(MSGIEN,"RXO",6,2)
 S FDA(FN,I,4.1)=NOTES
 S FIEN=$$CHKSSNUM^APSPES4(SSNUM)
 S FDA(FN,I,.03)=$S(FIEN:8,1:0)  ; Status
 ;S FDA(FN,I,.03)=0  ; Status
 D UPDATE^DIE(,"FDA","IENS","ERR")
 ;TODO - PROCESS ERR
 ;TODO - POPULATE OTHER FIELDS
 K ERR
 S I=+IENS(1)_","
 D GETHMSG(MSGIEN,.HMSG)
 S FDA(FN,I,5)=HMSG  ; HL7 Message
 D FILE^DIE("K","FDA","ERR")
 D SIG(+IENS(1))
 D DOSES(+IENS(1))  ;Add medication instructions multiple
 I FIEN D
 .D SETDUP^APSPES4(FIEN,+IENS(1))
 .N S
 .S S=$$GET1^DIQ(9009033.91,FIEN,.03,"I")  ;Status
 .I S=2!(S=3)!(S=5) D
 ..D ERR900^APSPES4(+IENS(1),"Request has already been viewed.")
 Q +$G(IENS(1))
 ; Extract data from segment
 ; Input: MSG - Message ien
 ;        SEG - Segment name
 ;        FLD - Field #
 ;        OFF - Offset in field (default to 1)
GETVAL(MSG,SEG,FLD,OFF) ;EP -
 N DATA,HLMSTATE,ARY,SEGIEN,SEGARY
 S OFF=$G(OFF,1)
 D PARSE(.DATA,MSG,.HLMSTATE)
 Q:'$D(DATA) ""
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,SEG)
 Q:'SEGIEN ""
 M SEGARY=DATA(SEGIEN)
 Q $$GET^HLOPRS(.SEGARY,FLD,OFF)
DOSES(IEN) ;Get dosage fields
 N HLMSG,HLDATA,APSPORC,SEG,CNT,I,FDA,AIEN,ERR,FN,MUL,N,D,RTE,ROUTE,TYPE,FORM,FORMT,CONJ,DUR
 S HLMSG=$$GHLDAT^APSPESG(IEN)
 S APSPORC=$$GETSEG^APSPESG(.HLDATA,"ORC")
 S SEG=$P(APSPORC,"|",8)
 S CNT=$L(SEG,"~")
 S FN=9009033.912
 F I=2:1:CNT D
 .S MUL=$P(SEG,"~",I)
 .S AIEN="+"_I_","_IEN_","
 .S FDA(FN,AIEN,1.3)=$P(MUL,"^",1)
 .S DUR=$P(MUL,"^",3)
 .I DUR="INDEF" S DUR=""
 .S N=$E(DUR,1,1)
 .S D=$E(DUR,2,$L(DUR))
 .S DUR=D_N
 .S FDA(FN,AIEN,1.5)=DUR
 .S FDA(FN,AIEN,1.1)=$P(MUL,"^",8)
 .S FDA(FN,AIEN,1.8)=$P(MUL,"^",2)
 .I CNT>2 D
 ..S CONJ=$P(MUL,"^",9)
 ..S FDA(FN,AIEN,1.6)=$S(CONJ="S":"T",1:"A")
 .;Get the dose type
 .S TYPE=$$GETVAL(MSGIEN,"RXO",12,1)
 .S FORMT=""
 .I TYPE'="" D
 ..S FORM=$O(^APSPNCP(9009033.7,"D",TYPE,""))
 ..I FORM'="" S FORMT=$P($G(^APSPNCP(9009033.7,FORM,0)),U,2)
 .S FDA(FN,AIEN,.01)=$P(MUL,"^",8)_"&"_$P(MUL,"^",1)_"&&"_FORMT_"&"_$P(MUL,"^",8)_$P(MUL,"^",1)
 .;Lookup the route
 .S RTE=""
 .S ROUTE=$$GETVAL(MSGIEN,"RXR",1,1)
 .I ROUTE'="" S RTE=$O(^PS(51.2,"B",ROUTE,""))
 .S FDA(FN,AIEN,1.7)=RTE
 .D UPDATE^DIE(,"FDA","AIEN","ERR")
 .K FDA,ERR
 Q
SIG(IEN) ;Store sig
 N FN,FDA,AIEN,ERR,X,X1,X2
 S X2=""
 S FN=9009033.913
 S AIEN="+1,"_IEN_","
 ;S FDA(FN,AIEN,.01)=$$GETVAL(MSGIEN,"RXO",7,2)  ; SIG
 S X=$$GETVAL(MSGIEN,"RXO",7,2)  ; SIG
 I $L(X)>200 S X1=$E(X,1,200),X2=$E(X,201,$L(X))
 E  S X1=X
 S FDA(FN,AIEN,.01)=X1
 D UPDATE^DIE(,"FDA","AIEN","ERR")
 I X2'="" D
 .S FDA(FN,AIEN,.01)=X2
 .D UPDATE^DIE(,"FDA","AIEN","ERR")
 K ERR
 Q
DEA(DRUG) ; Return DEA value
 N DEA
 S DEA=+$$GET1^DIQ(50,DRUG,3)
 Q DEA
DEACLS(DEA,CLS) ; Return boolean value for comparison
 Q CLS[DEA
 ;
PREPPTXT(RET,RRIEN) ; Return prepared text from Pharmacy
 N M,C
 S RRIEN=$G(RRIEN,0)
 S M=$P(^APSPRREQ(RRIEN,0),U,5)
 S @RET@(1)="Pharmacy: "_$$GETVAL(M,"RXE",40,2)_" ("_$$FMTPHN($$GETVAL(M,"RXE",45))_")"
 S @RET@(2)="Drug description: "_$$GETVAL(M,"RXO",1,2)
 S @RET@(3)="Quantity: "_$$GETVAL(M,"RXO",11)_" "_$$GET1^DIQ(9009033.7,$$FIND1^DIC(9009033.7,,,$$GETVAL(M,"RXO",12)),1)
 S @RET@(4)="Days Supply: "_$$GETVAL(M,"ORC",7,3)
 S @RET@(5)="Sig-Directions: "_$$GETVAL(M,"RXO",7,2)
 S @RET@(6)="Note: "_$$GETVAL(M,"RXO",6,2)
 S @RET@(7)="Refills: "_+$$GETVAL(M,"RXO",13,1)
 S @RET@(8)="Substitution allowed: "_$$ESUBST($$GETVAL(M,"RXO",9))
 S @RET@(9)="Last fill date: "_$$FMTE^XLFDT($$FMDATE^HLFNC($$GETVAL(M,"ORC",27,1)),"5DZ0")
 S @RET@(10)=" "
 ;S @RET@(11)="Diagnosis: "
 ;S C=12
 ;D GETDIAG(M,RET,.C)
 S @RET@(11)="Diagnosis: "_$$GETVAL(M,"DG1",3,2)
 Q
 ; Return full HL7 message
GETHMSG(MSGIEN,DATA) ;EP
 N MSG,SEG,CNT
 S DATA=$NA(^TMP("REFREQ",$J))
 K @DATA
 Q:'$$GETMSG^HLOMSG(MSGIEN,.MSG)
 S CNT=1
 S SEG(1)=MSG("HDR",1)_MSG("HDR",2)
 D ADD(.SEG)
 F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  D
 .D ADD(.SEG)
 Q
 ; Return external text for Substitution
ESUBST(VAL) ;
 Q $S(VAL="N":"Not Authorized",VAL="T":"Allow therapeutic",1:"Allowed Generic")
I() ;EP -
 S CNT=CNT+1
 Q CNT
 ; Return external text for diagnosis
GETDIAG(MSG) ; EP -
 N TXT,DATA,ARY,SEG,HLMSTATE,HDR,SEGIEN,SEGDG1
 S TXT=""
 I '$$STARTMSG^HLOPRS(.HLMSTATE,MSG,.HDR) Q
 F  Q:'$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG)  D
 .I $$GET^HLOPRS(.SEG,0)="DG1" D
 ..S TXT=$$GET^HLOPRS(.SEG,3,1)_" ("_$$GET^HLOPRS(.SEG,3,3)_")"
 ..I $L(TXT) S C=C+1,@RET@(C)=TXT
 Q DX
 ; Add data to array
ADD(SEG) ; EP -
 N I
 S I=0 F  S I=$O(SEG(I)) Q:'I  S @DATA@($$I())=SEG(I)
 S @DATA@($$I())=""
 Q
ADD1(SEG) ;
 N QUIT,I,J,LINE
 S QUIT=0
 S (I,J)=1
 S LINE(1)=$E(SEG(1),1,255),SEG(1)=$E(SEG(1),81,9999)
 I SEG(1)="" K SEG(1)
 D SHIFT(.I,.J)
 S @VALMAR@($$I,0)=LINE(1)
 S I=1
 F  S I=$O(LINE(I)) Q:'I  D
 .S @VALMAR@($$I,0)=LINE(I)
 Q
 ;
SHIFT(I,J) ;
 I '$D(SEG(I)) S I=$O(SEG(0)) Q:'I
 I $L(LINE(J))<255 D
 .N LEN
 .S LEN=$L(LINE(J))
 .S LINE(J)=LINE(J)_$E(SEG(I),1,255-LEN)
 .S SEG(I)=$E(SEG(I),256-LEN,9999)
 .I SEG(I)="" K SEG(I)
 E  D
 .S J=J+1
 .S LINE(J)="-"
 D SHIFT(.I,.J)
 Q
 ; Return formatted phone number
FMTPHN(X) ;EP
 N RES
 I $E(X,1,10)?10N Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I $E(X,1,7)?7N Q $E(X,1,3)_"-"_$E(X,4,7)_"  "_$E(8,20)
 I X?10N1" ".6UN Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I X?3N1"-"3N1"-"4N.1" ".A Q "("_$E(X,1,3)_")"_$E(X,5,12)_"  "_$E(X,13,20)
 I X?3N1"-"4N Q X
 I X?3N1"-"4N.1" ".6UN Q X
 Q X
 ; Check status of APSP REFIIL REQUEST entry
 ; Input: IEN - IEN
 ;        STA - Status to check (if not passed, set to -1 and return status value)
RREQSTAT(DATA,IEN,STA) ; EP -
 S RES=$P($G(^APSPRREQ(IEN,0)),U,3)
 S:'$L($G(STA)) STA=-1
 S DATA=$S(STA=-1:RES,1:RES=STA)
 Q
EFF(PRV) ;See if SPI is ACTIVE
 N EFF,IN
 S IN=1
 S EFF=9999999 F  S EFF=$O(^VA(200,PRV,"SPISTATUS",EFF),-1) Q:'+EFF  D
 .S IN=$P($G(^VA(200,PRV,"SPISTATUS",EFF,0)),U,2)
 Q IN
ACK(HLMSGIEN,MSGTXT) ; Generate APP Ack
 N PARMS,ACK,ERR,OCC,DNYC
 S PARMS("ACK CODE")="AE"
 S PARMS("ERROR MESSAGE")=MSGTXT
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 I $$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D
 .S OCC="UF",DNYC="AF"
 .D SETACK^APSPES3
 .I '$$SENDACK^HLOAPI2(.ACK,.ERR)&(+RR) D UPTRRACT^APSPES3(RR,$G(ERR,"There was a problem generating the HL7 message"))
 Q
