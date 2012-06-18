APSPES9 ;IHS/MSC/PLS - Master File SPI Request;24-Mar-2011 05:02;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1009,1010**;Sep 23, 2004
 ; Modified - IHS/MSC/PLS - 03/24/2011 - EN+20 (removed checks for DEA)
 Q
ADDPRV(PVD,MFNTYP) ;
 Q:'$G(PVD)
 N HLPM,HLST,ERR,ARY,AP,WHO,ERR
 S HLPM("MESSAGE TYPE")="MFN"
 S HLPM("EVENT")="M02"
 S HLPM("VERSION")=2.5
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) W !,EHR,0
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 S MFNTYP=$$FNDTYP(PVD)
 D MFI
 D MFE
 ;D STF
 ;D ORG
 ;D PRA
 S AP("SENDING APPLICATION")="APSP RPMS"
 S AP("ACCEPT ACK TYPE")="AL"  ; Commit ACK
 S AP("APP ACK TYPE")="AL"
 S AP("QUEUE")="RPMS SPI"
 S AP("FAILURE RESPONSE")="FAILURE^APSPES9"
 S WHO("RECEIVING APPLICATION")="SURESCRIPTS"
 S WHO("FACILITY LINK NAME")="APSP EPRES"
 I '$$SENDONE^HLOAPI1(.HLST,.AP,.WHO,.ERR) W !,ERR
 Q
 ;
MFI ;EP
 N MFI
 D SET(.ARY,"MFI",0)
 D SET(.ARY,"STF",1)  ; Master File Identifier
 D SET(.ARY,"UPD",3)  ; Update record
 D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT()),4)  ; Entered Date/Time
 D SET(.ARY,"MF",6)   ; Response level code
 S MFI=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
MFE ;EP
 N MFE,PKV
 S PKV=PVD_":"_DUZ(2)_":1"
 D SET(.ARY,"MFE",0)
 D SET(.ARY,MFNTYP,1)  ; Record-level event code
 D SET(.ARY,PKV,2)    ; MFN Control ID - DUZ.DUZ(2).1
 D SET(.ARY,PKV,4)    ; Primary Key Value
 S MFE=$$ADDSEG^HLOAPI(.HLST,.ARY)
 I MFE D
 .D STF(PKV)
 .D PRA(PKV)
 .D ORG
 Q
STF(PKV) ;EP
 N STF,NM,LP,VAL,PHONE,FAX
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,+PKV,.01))
 D SET(.ARY,"STF",0)
 D SET(.ARY,PKV,1)  ; Primary Key value
 D SET(.ARY,"NEW PERSON",1,3)  ; Coding System - File Name
 D SET(.ARY,+PKV,2) ; Staff ID (DUZ)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,3,LP)
 D SET(.ARY,"A",7)  ; Active/Inactive Flag
 S PHONE=$$GET1^DIQ(200,+PKV,.132)
 S:'$L(PHONE) PHONE=$$GET1^DIQ(9999999.06,DUZ(2),.13)  ; Default to Location phone
 D SET(.ARY,$$HLPHONE^HLFNC(PHONE),10,1)  ; Work Phone
 D SET(.ARY,"WPH",10,2)
 D SET(.ARY,"PH",10,3)
 S FAX=$$GET1^DIQ(200,+PKV,.136)
 D SET(.ARY,$$HLPHONE^HLFNC(FAX),10,1,,2)  ; Fax
 D SET(.ARY,"WPN",10,2,,2)
 D SET(.ARY,"FX",10,3,,2)
 D SET(.ARY,$$GET1^DIQ(200,+PKV,.151),10,4)  ; email address
 D SET(.ARY,$$GET1^DIQ(4,DUZ(2),1.01),11,1)  ; Institution Address 1
 D SET(.ARY,$$GET1^DIQ(4,DUZ(2),1.03),11,3)  ; Institution City
 D SET(.ARY,$$GET1^DIQ(5,$$GET1^DIQ(4,DUZ(2),.02,"I"),1),11,4)  ; Institution State Abbreviation
 D SET(.ARY,$E($$GET1^DIQ(4,DUZ(2),1.04,"I"),1,5),11,5)  ; Institution 5 digit Zip Code
 D SET(.ARY,"O",11,7)  ; Address Type
 D SET(.ARY,"O",16)  ; Preferred method of contact
 D SET(.ARY,$$GET1^DIQ(200,+PKV,8),18)  ; Job Title
 D SET(.ARY,$$GET1^DIQ(200,+PKV,53.5,"I"),19,1)  ; Job Code/Class
 D SET(.ARY,$$GET1^DIQ(200,+PKV,53.5),19,2)
 S STF=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
ORG ;EP
 Q
PRA(PKV) ;EP
 N PRA,NM,LP,VAL,DEA,NPI
 S DEA=$$GET1^DIQ(200,+PKV,53.2)  ; New Person DEA#
 S NPI=$$GET1^DIQ(200,+PKV,41.99) ; New Person NPI
 I '$L(DEA) D
 .S DEA=$$GET1^DIQ(4,DUZ(2),52)  ; Institution DEA
 .S DEA=DEA_"-"_NPI   ;$$GET1^DIQ(9999999.06,DUZ(2),.12)  ;CHANGED TO USE NPI INSTEAD OF ASUFAC CODE
 D SET(.ARY,"PRA",0)
 D SET(.ARY,PKV,1)  ; Primary Key value
 D SET(.ARY,DEA,6,1,1,1)
 D SET(.ARY,"DEA",6,2,,1)
 D SET(.ARY,NPI,6,1,,2)
 D SET(.ARY,"NPI",6,2,,2)
 S PRA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Failed Transmission Callback
FAILURE ; EP
 N ARY,SEGIEN
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFN")
 Q:'SEGIEN
 D NOTIF($$GET1^DIQ(200,+PKV,.01)_": Unable to transmit SPI request.")
 Q
 ; Process MFK acknowledgement
MFK ; EP -
 N ARY,SEGIEN,SEGDAT,PVD,PKV,SPI
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFA")
 Q:'SEGIEN
 M SEGDAT=DATA(SEGIEN)
 S PKV=$$GET^HLOPRS(.SEGDAT,2)
 I $$GET^HLOPRS(.SEGDAT,4)'="S" D
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ERR")
 .I SEGIEN D
 ..M SEGDAT=DATA(SEGIEN)
 ..S ERR=$$GET^HLOPRS(.SEGDAT,8)
 ..D:$L(ERR) NOTIF($$GET1^DIQ(200,+PKV,.01)_": "_$P(ERR,":"))
 E  D
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFI")
 .Q:'SEGIEN
 .M SEGDAT=DATA(SEGIEN)
 .S SPI=$$GET^HLOPRS(.SEGDAT,1)
 .D NOTIF($$GET1^DIQ(200,+PKV,.01)_": Please assign SPI "_SPI_" to user.")
 Q
 ; Notify SPI mail group
NOTIF(MSG) ; EP -
 N RET
 S XQAMSG=MSG
 S XQA("G.SPI NOTIFICATION")=""
 D SETUP^XQALERT
 Q
 ; Main entry point for selection of user
EN ; EP -
 N USR,APSPPOP
 W @IOF
 W !,"SureScripts Provider ID Request Utility",!
 S USR=$$GETIEN1^APSPUTIL(200,"Select Provider: ",-1,,"I $S('$D(^VA(200,Y,0)):0,Y<1:1,$L($P(^(0),U,3)):1,1:0),$P($G(^VA(200,Y,""PS"")),U)")
 Q:USR<1
 W !!,"Processing request for: "_$$GET1^DIQ(200,+USR,.01)
 ; Check for active user
 I '$$ACTIVE^XUSER(+USR) D  Q
 .W !,"User is not an active RPMS user.",!
 .D DIRZ
 ; Check for existing SPI
 I $$SPI^APSPES1(+USR) D  Q
 .W !,"User has already been assigned an SPI number.",!
 .D DIRZ
 ; Ensure that selected user has an NPI
 I '$$GET1^DIQ(200,+USR,41.99) D  Q
 .W !,"The selected user must have an NPI assigned.",!
 .D DIRZ
 ; If needed, indicate that Institutional DEA will be used.
 ;I '$L($$GET1^DIQ(200,+USR,53.2)) D
 ;.W !,"This provider lacks an individual DEA number."
 ;.W !,"The facility DEA number will be used to request the SPI number."
 ;.D DIRZ
 ;I '$L($$GET1^DIQ(4,DUZ(2),52)) D  Q
 ;.W !,"The selected facility, "_$$GET1^DIQ(4,DUZ(2),.01)_" lacks a Facility DEA number."
 ;.W !,"This will need to be corrected before you can continue with the request."
 ;.D DIRZ
 I '$L($$GET1^DIQ(200,+USR,.136)) D  Q
 .W !,"The user lacks a fax number. This will need to be corrected before you can"
 .W !,"continue with the request."
 .D DIRZ
 I '$L($$GET1^DIQ(200,+USR,.151)) D  Q
 .W !,"The user lacks an email address. This will need to be corrected before you can"
 .W !,"continue with the request."
 .D DIRZ
 I '$L($$GET1^DIQ(9999999.06,DUZ(2),.13)) D  Q
 .W !,"The selected facility, "_$$GET1^DIQ(4,DUZ(2),.01)_" lacks a phone number."
 .W !,"This will need to be corrected before you can continue with the request."
 .D DIRZ
 I $$DIRYN^APSPUTIL("Request SPI","YES",,.APSPPOP) D
 .D ADDPRV(USR,"MAD")
 .W !!,"An SPI number has been requested. A Kernel Alert will be sent to"
 .W !,"the SPI NOTIFICATION group when the SPI number is received."
 Q
 ;
DIRZ ;EP - Prompt to continue
 D DIRZ^APSPUTIL("Press ENTER to continue")
 Q
 ;
FNDTYP(IEN) ;EP - Determine if a new or update message should be sent
 ;If MFNTYP exists, no need to do the lookup
 Q:$D(MFNTYP) MFNTYP
 N TD,ENTER,ACTIVE,RES
 S TD=$$DT^XLFDT()
 S ENTER=$P($G(^VA(200,IEN,1)),U,7)  ; Date Entered
 I TD>ENTER S RES="MUP1"
 I ENTER=TD D
 .I $P($G(^VA(200,IEN,1.1)),U,1)'="" S RES="MUP1"
 .I $P($G(^VA(200,IEN,1.1)),U,1)="" S RES="MAD"
 I $P($G(^VA(200,IEN,0)),U,11)!($P($G(^VA(200,IEN,"PS")),U,4)) S RES="MDC"
 Q RES
 ;
ADDPTL(PVD) ;EP - Entry point for APSP ERX MFN UPDATE protocol
 ;Additional business rules to be added here
 D ADDPRV(PVD)
 Q
