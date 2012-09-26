APSPES3 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;12-Dec-2011 16:08;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1011,1013**;Sep 23, 2004;Build 33
 ; Send denial message
 ; Input:  ORID - ^OR(100 IEN
 ;        RXIEN - Prescription IEN
 ;          OCC - Order Control Code  (default to DF)
 ;       MSGTXT - optional
 ;          STA - Status (default to 3)
DENY(ORID,RXIEN,OCC,MSGTXT,STA) ;
 N RR
 S RR=$$VALUE^ORCSAVE2(+ORID,"SSRREQIEN")
 Q:'RR
DENY1 N DATA,HLMSGIEN,HLMSTATE,ARY,SEG
 N PARMS,ACK,ERR,I,FLG,LP,LOG,DNYC,DNYR
 S ORID=+$G(ORID)
 S RXIEN=+$G(RXIEN)
 S OCC=$G(OCC,"DF")
 S HLMSGIEN=$$GET1^DIQ(9009033.91,RR,.05)  ; Message ID
 ; TODO- Add logic to use the HL7 message text in the RR entry if HL7 message has been purged.
 Q:'HLMSGIEN
 S PARMS("ACK CODE")="AA"
 S PARMS("MESSAGE TYPE")="RRE"
 S PARMS("EVENT")="O26"
 S PARMS("ACCEPT ACK TYPE")="AL"
 I $L($G(MSGTXT)) D
 .S DNYC="AF"
 E  D
 .S DNYR=$$VALUE^ORCSAVE2(+ORID,"SSDENYRSN")
 .I $L(DNYR) D
 ..S DNYC=$P(DNYR,"-")
 ..S MSGTXT=$P(DNYR,"-",2)
 .E  S DNYC="AF"
 S MSGTXT=$G(MSGTXT,"Have patient return to clinic.")
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) W !,ERR Q
 ;TODO - SEND NOTIFICATION ON ERROR
 D PREPARY^APSPES1(.DATA,"PID",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"ORC",.ARY)
 D SET(.ARY,OCC,1)  ; Order Control Code
 D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT()),9)  ; Written Date/Time
 D SET(.ARY,DNYC,16,1)  ; Order Control Code Reason Identifier
 D SET(.ARY,$E(MSGTXT,1,70),16,2)  ; Order Control Code Reason Text
 D SET(.ARY,"NCPDP1131",16,3)  ; Order Control Code Reason System
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXO",.ARY)
 D SET(.ARY,0,13,1)  ; Refill count to zero
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXR",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXE",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 S LP=0
 S FLG=0 F I=1:1 D  Q:FLG
 .S LP=$$FSEGIEN^APSPES1(.DATA,"DG1",LP)
 .I LP=0 S FLG=1 Q
 .D PREPARY^APSPES1(.DATA,"DG1",.ARY,LP-1)
 .S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 ;
 I '$$SENDACK^HLOAPI2(.ACK,.ERR) W !,ERR
 K FDA
 S FDA(9009033.91,RR_",",.02)="@"  ; Remove order ien
 S FDA(9009033.91,RR_",",.03)=$S($G(STA):STA,1:3)  ; Set status to processed-denied
 S FDA(9009033.91,RR_",",.07)=$$NOW^XLFDT()
 D FILE^DIE("K","FDA","ERR")
 ; Update activity log
 I RXIEN D
 .N LOG,RET
 .S LOG("REASON")="X"
 .S LOG("RX REF")=0
 .S ARY("TYPE")="U"
 .S LOG("COM")="E-Prescribe denial response sent to "_$$PHMINFO^APSPES2(RXIEN)
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.LOG)
 Q
 ; Send accept message
 ; Input:  ORID - ^OR(100 IEN
ACCEPT(RX,ORID,MSGTXT) ;
 N RR,DATA,HLMSGIEN,HLMSTATE,ARY,SEG,SEGIEN,SEGRXO
 N PARMS,ACK,ERR,PRN,REF,REFILLS,I,FLG,LP,DISP
 S REFILLS=$$GET1^DIQ(52,RX,9,"I")
 S DISP=REFILLS+1  ; Number of dispenses
 S RR=$$VALUE^ORCSAVE2(+ORID,"SSRREQIEN")
 Q:'RR
 S HLMSGIEN=$$GET1^DIQ(9009033.91,RR,.05)  ; Message ID
 ; TODO- Add logic to use the HL7 message text in the RR entry if HL7 message has been purged.
 Q:'HLMSGIEN
 S PARMS("ACK CODE")="AA"
 S PARMS("MESSAGE TYPE")="RRE"
 S PARMS("EVENT")="O26"
 S PARMS("ACCEPT ACK TYPE")="AL"
 S MSGTXT=$G(MSGTXT,"")
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) W !,ERR Q
 ;TODO - SEND NOTIFICATION ON ERROR
 S PRN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",7,7)="PRN"  ; Check for PRN value
 S REF=+$$GETVAL^APSPES2(HLMSGIEN,"RXO",13,1)  ; incoming Refill count
 D PREPARY^APSPES1(.DATA,"PID",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"ORC",.ARY)
 ;TODO - ADJUST RX NUMBER, CHECK REFILL PRN $S(ORC 7.7="PRN" OR RXO13.1=REFILL SET APPROVED (AF), RXO 13.1<>REFILLS SET TO APPROVED WITH CHANGES (CF)
 D SET(.ARY,$S(PRN:"AF",'REF:"AF",DISP'=REF:"CF",1:"AF"),1)  ; Order Control Code - Accept
 D SET(.ARY,RX,2)  ; Prescription number
 D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT()),9)  ; Written Date/Time
 ;D SET(.ARY,"AM",16,1)  ; Order Control Code Reason Identifier
 ;D SET(.ARY,$E(MSGTXT,1,70),16,2)  ; Order Control Code Reason Text
 ;D SET(.ARY,"NCPDP1131",16,3)  ; Order Control Code Reason System
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXO",.ARY)
 ;S REF=$$GETVAL^APSPES2(HLMSGIEN,"RXO",13,1)  ; incoming Refill count
 D SET(.ARY,DISP,13,1)  ; Set refill count to # of dispenses
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXR",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXE",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 S LP=0
 S FLG=0 F I=1:1 D  Q:FLG
 .S LP=$$FSEGIEN^APSPES1(.DATA,"DG1",LP)
 .I LP=0 S FLG=1 Q
 .D PREPARY^APSPES1(.DATA,"DG1",.ARY,LP-1)
 .S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 I '$$SENDACK^HLOAPI2(.ACK,.ERR) W !,ERR
 K FDA
 S FDA(9009033.91,RR_",",.03)=2  ; Set status to processed-accepted
 S FDA(9009033.91,RR_",",.07)=$$NOW^XLFDT()
 D FILE^DIE("K","FDA","ERR")
 ; Update activity log
 I RX D
 .N LOG,RET
 .S LOG("REASON")="X"
 .S LOG("RX REF")=0
 .S LOG("TYPE")="U"
 .S LOG("COM")="E-Prescribe accept response sent to "_$$PHMINFO^APSPES2(RX)
 .D UPTLOG^APSPFNC2(.RET,RX,0,.LOG)
 Q
 ;
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
