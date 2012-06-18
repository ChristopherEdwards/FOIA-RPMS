APSSSPRO ;IHS/CIA/PLS - ScriptPro Interface;06-Dec-2007 15:06;SM
 ;;1.0;IHS SCRIPTPRO INTERFACE;**1**;January 11, 2006
 ;Call via entry point placed in Field 900 of File 9009033
 ;Direct entry not supported
 ; Modified - IHS/MSC/PLS - 02/08/07 - Line ASK+2 - Added check for ZTSK
 ;                          12/06/07 - Line ASK+7 - Changed duplicate check for DTOUT to check for DUOUT
 Q
EP1(RXIEN,REPRINT,SGY,RXF,RXPI) ;PEP	- Main entry point
 N APSS,RX0,RX2,RX3,REFIEN,RXSTAT,QTY
 N ZTRTN,ZTIO,ZTDESC,ZTREQ,ZTSAVE,VAR,ZTSK
 Q:'$G(RXIEN)  ; Prescription IEN required
 Q:'$D(^APSSPARM($G(DUZ(2))))
 Q:'$$SETUP(DUZ(2),.APSS)
TASK ;
 I $G(APSS("ASK")),'$$ASK("Send to SCRIPT-PRO") U IO Q
 Q:'$G(APSS("DEV"))  ; No device
 S ZTRTN="EPTASK^APSSSPRO"
 S ZTDESC="ScriptPro Interface for RXIEN: "_RXIEN
 S ZTDTH=$H
 S ZTIO="`"_APSS("DEV")
 F VAR="RXIEN","REPRINT","SGY(","RXF","RXPI" S:$D(VAR) ZTSAVE(VAR)=""
 D ^%ZTLOAD
 Q
 ;
EPTASK ;EP - Tasked entry point
 Q:'$$SETUP(DUZ(2),.APSS)
 D INIT
 ;
 Q:'$$DRUGOK($$GETP(RX0,6))
 ;
 ; Build output from Table
 S APSSREC=""
 S APSSCMD=$$FIND1^DIC(9009033.3,,,"FILL")
 Q:'APSSCMD
 D BLDFARY(.APSSFARY,APSSCMD)
 ;
 D SETRM(0)
 U IO W $$PROCARY(APSSCMD,.APSSFARY,.APSSREC)
 D:APSS("LOG") LOG(APSSREC,.SGY)
 Q
 ; Build field array
BLDFARY(ARY,CIEN) ;
 N IEN,SEQ
 S IEN=0
 F  S IEN=$O(^APSSCOMD(CIEN,1,IEN)) Q:'IEN  D
 .S SEQ=+$P($G(^APSSCOMD(CIEN,1,IEN,0)),U,2)
 .S:SEQ>0 ARY(SEQ)=IEN
 Q
 ; Initialize output array
PROCARY(CIEN,FLDS,RET) ;
 N LP,VNM
 D ADD("|**|<COMMAND>FILL")
 S LP=0 F  S LP=$O(FLDS(LP)) Q:'LP  D
 .S VNM=$P(^APSSCOMD(CIEN,1,FLDS(LP),0),U)
 .D ADD("<"_VNM_">"_$$DATA(CIEN,FLDS(LP),RXIENS))
 D ADD("|##|"_$C(13,10))
 Q RET
 ; Return data for given tag
DATA(CMDIEN,TAGIEN,RXIENS) ;
 N TAG0,FILE,FLD
 S TAG0=$G(^APSSCOMD(CMDIEN,1,TAGIEN,0))
 S FILE=$P($P(TAG0,U,3),",")
 S FLD=$P($P(TAG0,U,3),",",2)
 S FMT=$P(TAG0,U,4)
 I $L(RXIENS,",")>2 D
 .S RXIENS=$S($F(FMT,"R"):RXIENS,1:$P(RXIENS,",",2)_",")
 S VAL=""
 I FILE,FLD D
 .S VAL=$$GET1^DIQ(FILE,RXIENS,FLD,$S(FMT["I":"I",1:"E"))
 ; Check for Transform code
 I $F(FMT,"Z")>0 D
 .X:$L($G(^APSSCOMD(CMDIEN,1,TAGIEN,1))) ^APSSCOMD(CMDIEN,1,TAGIEN,1)
 ; Check for Date Format
 I $F(FMT,"D")>0 D
 .S FMTD=$E(FMT,$F(FMT,"D"))
 .S VAL=$TR($$FMTE^XLFDT(VAL,$S(FMTD=2:"7",1:"5")_"Z"),"/","")
 .S:FMTD=3 VAL=$E(VAL,1,2)_$E(VAL,5,8)
 Q VAL
 ; Add a node to the output array
ADD(VAL) ;
 S RET=$G(RET,"")_VAL
 Q
SETUP(FAC,APSS) ;EP - Build configuration array
 N PARAM
 S APSS("PFL")="N"
 S (PARAM,APSS("PARM"))=$G(^APSSPARM(FAC,0))
 Q:'PARAM 0
 Q:'$$GETP(PARAM,2) 0   ; Interface is turned off
 S APSS("DEV")=+$$GETP(PARAM,3)
 S APSS("SIGLINE")=$S($$GETP(PARAM,4):$$GETP(PARAM,4),1:30)
 S APSS("CHKDRG")=''$$GETP(PARAM,5)
 S APSS("ASK")=''$$GETP(PARAM,6)
 S APSS("LOG")=''$$GETP(PARAM,7)
 Q 1
 ;
INIT ;EP - Build data for prescription
 S RX0=$G(^PSRX(RXIEN,0))
 S RX2=$G(^PSRX(RXIEN,2))
 S RX3=$G(^PSRX(RXIEN,3))
 S RXSTAT=$G(^PSRX(RXIEN,"STA"))
 S PARIEN=+$G(RXPI)
 ;S REFIEN=+$O(^PSRX(RXIEN,1,$C(1)),-1)
 S REFIEN=+$G(RXF)
 S QTY=+$S(PARIEN:$P($G(^PSRX(RXIEN,"P",PARIEN,0)),U,4),REFIEN:$P($G(^PSRX(RXIEN,1,REFIEN,0)),U,4),1:$P(RX0,U,7))
 S RXIENS=$S(PARIEN:PARIEN_",",REFIEN:REFIEN_",",1:"")_RXIEN_","
 Q
 ; Log transmission
LOG(REC,SGY) ;
 N APSSNOW,LP
 S APSSNOW=$$NOW^XLFDT
 L +^XTMP("APSSSPRO"):2
 S ^XTMP("APSSSPRO",0)=$$FMADD^XLFDT(DT,7)_U_$$DT^XLFDT
 S ^XTMP("APSSSPRO",RXIEN,APSSNOW)=REC
 S LP=0 F  S LP=$O(SGY(LP)) Q:'LP  S ^XTMP("APSSSPRO",RXIEN,APSSNOW,LP)=SGY(LP)
 L -^XTMP("APSSSPRO")
 Q
 ; Check drug availability in ScriptPro
DRUGOK(DRUGIEN) ;EP
 I 'APSS("CHKDRG") Q 1    ; Drug checking is disabled
 N PARAM
 S PARAM=$G(^APSSDRUG(DRUGIEN,0))
 Q:'$$GETP(PARAM,1) 0     ; Drug not present
 Q:'$$GETP(PARAM,3) 1     ; Inactive date not present
 I $$GETP(PARAM,3)<$$FMADD^XLFDT(DT,1) Q 0    ; Drug has been deactivated
 Q '(QTY>$$GETP(PARAM,2))    ; Quantity
 ;
CHKDRUG(RXIEN) ; PEP - Logic called from field 800 in APSP Control file
 N APSS,RX0,RX2,RX3,REFIEN,RXSTAT,QTY
 Q:'$$SETUP($G(DUZ(2)),.APSS) 0
 D INIT
 Q $$DRUGOK($$GETP(RX0,6))
 ; Returns given piece of supplied string
GETP(VAL,P) ;EP
 Q $P(VAL,U,P)
SIG() ;
 S APSS("SIG")=""
 S N=0
 F  S N=$O(SGY(N)) Q:'N  D
 .I APSS("SIG")="" S APSS("SIG")=SGY(N) Q
 .S APSS("SIG")=APSS("SIG")_SGY(N)
 Q:$Q APSS("SIG")
 Q
 ; Return priority
GETPRI(LOCIEN) ;EP
 Q:'$G(LOCIEN) 0
 Q $S($D(^APSSPARM(DUZ(2),1,LOCIEN,0)):+$$GETP(^APSSPARM(DUZ(2),1,LOCIEN,0),2),1:1)
 ;
ASK(PRMPT) ;EP - Prompt user for transmission to ScriptPro
 N DIR,DTOUT,DUOUT
 I $E(IOST,1)="P"!$G(ZTSK) Q 1  ; User input not available for queued tasks or print devices
 S DIR("A")=PRMPT  ;"Send to SCRIPT-PRO"
 S DIR("B")="N"
 S DIR(0)="Y"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT)) 0
 Q Y>0
 ; Query for drug
HASDRUG(DRUG) ; EP
 Q:'$G(DRUG) 0
 Q ''$D(^APSSDRUG(DRUG))
 ; Set Right Margin of output device
SETRM(X) ;
 X ^%ZOSF("RM")
 Q
