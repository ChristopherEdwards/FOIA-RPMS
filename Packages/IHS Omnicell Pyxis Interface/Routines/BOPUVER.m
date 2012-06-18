BOPUVER ;IHS/ILC/DUG/CIA/PLS - Create Unverified Prescription;24-Jul-2006 22:41;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;
 ;Process entries in File 90355.44 into unverified prescriptions.
 ;get record number from RUN+2^BOPROC to get data from file 90355.44
 ;then create a record in prescription file 52 so that the pharmacist
 ;can verify later.
 ;
ENTRY(BOPDAS) ;EP
 ;Assume variables:
 ;  BOPSITE - IEN to File 59
 N NODE0,NODE2,NODE3,DIC,DFN,PROV,CLINIC,DIV,DRUG
 N QTY,USER,SIG,HRN,VER,X,DD,DO,SIGOK,PSONEW,PSODRUG
 Q:'$G(BOPDAS)
 S NODE0=$G(^BOP(90355.44,BOPDAS,0)) Q:NODE0=""    ;PID info
 S NODE2=$G(^BOP(90355.44,BOPDAS,2)) ;Q:NODE2=""
 S NODE3=$G(^BOP(90355.44,BOPDAS,3)) Q:NODE3=""
 ;Q:$P(NODE0,U,2)'="D"   ;is not a drug
 S DFN=$P(NODE0,U,4)  ;Patient
 S HRN=$P(NODE0,U,5)  ;HRN
 S PROV=+$P($P(NODE3,"|",22),U)   ;provider IEN  =>200
 S:'$D(^VA(200,PROV,0)) PROV=""  ;must be a valid user
 ;S:'PROV PROV=$P($G(^BOP(90355,1,"SITE")),U,7)  ; Use default provider
 S USER=$P($P(NODE3,"|",21),U)   ;user IEN entering order
 S:'USER USER=$P($G(^BOP(90355,1,"SITE")),U,8)  ; Use default user
 S DRUG=+$$DRGIEN^BOPROC(NODE3)
 I '$D(^PSDRUG(DRUG,0)) D MAIL Q  ; Drug not found
 S QTY=$P(NODE3,"|",11)  ;Quantity
 S CLINIC=$$FIND1^DIC(44,,"O",$P($P(NODE2,"|",4),U))  ; Clinic Name
 S:'CLINIC CLINIC=+$P($G(^BOP(90355,1,"SITE")),U,6)
 S:'CLINIC CLINIC=""
 D
 .S SIG(1)=$$GET1^DIQ(90355,1,402) Q:$L(SIG(1))
 .S SIG(1)=$P(^PSDRUG(DRUG,0),U,4)_"  MAXIMUM DOSES PER DAY" Q:SIG(1)
 .S SIG(1)="ASK PHYSICIAN FOR DOSE INSTRUCTIONS"
 S SIGOK=1
 S NDC=$$NDCLKP(+DRUG)  ;
 ;
CREATE ;creating a prescription record
 S PSONEW("DFLG")=0
 S PSOSITE=BOPSITE
 I $D(^APSPCTRL(PSOSITE,0)) S %APSITE=^(0)
 D AUTO^PSONRXN
 S PSOX=PSONEW("RX #")
 S PSONEW("ISSUE DATE")=$P(DT,".",1)
 S PSONEW("DAYS SUPPLY")=7
 S PSONEW("# OF REFILLS")=0
 S BOPSTPDT=""
 S BOPSTPDT=$$FMADD^XLFDT(DT,7)
 S PSONEW("STOP DATE")=BOPSTPDT
 S PSONEW("FILL DATE")=$P(DT,".",1)
 S PSONEW("CM")="N"
 S PSONEW("PHARM")=PROV
 S PSONEW("PROVIDER")=PROV
 S PSONEW("CLINIC")=CLINIC
 S PSODRUG("IEN")=DRUG
 S PSONEW("QTY")=QTY
 S PSODRUG("NDC")=NDC
 S PSONEW("COST")=$$COST^APSQDAWP(NDC,DRUG)
 S PSONEW("LAST DISPENSED DATE")=PSONEW("FILL DATE")
 S PSODRUG("DEA")=$P(^PSDRUG(DRUG,0),U,3)
 S PSODRUG("OI")=+^PSDRUG(DRUG,2)
 S PSONEW("ENT")=0
 S PSOCOU="",PSOCOUU=0,PSONOOR=""
 S PSONEW("NDC")=NDC
 I DFN="" S DFN=$P(NODE0,"^",5)
 S (PSODFN,BOPDFN)=DFN
 S PSONEW("PATIENT STATUS")=1
 S PSONEW("STATUS")=1 ; field 100
 S PSONEW("MAIL/WINDOW")="W"
 S PSONEW("CLERK CODE")=USER
 S PSONEW("DISPENSED DATE")=$P(DT,".",1)
 S PSONEW("RX #")=PSONEW("RX #") ; for nfile^pson52
 ;S PSONEW("STOP DATE")=PSOX("STOP DATE") ; for ps55
 S PSORX("VERIFY")=1 ; for anq^pson52 to create verify 52.4 entry
 S PSONEW("POE")=1
 D EN^PSON52(.PSONEW) ; file entry in file 52
 ; Returns RX IEN in PSONEW("IRXN")
 S %APSITE=$G(%APSITE)
 S BOPPSRX="" S BOPPSRX=$O(^PSRX("B",PSOX,BOPPSRX))
 S $P(^BOP(90355.44,BOPDAS,0),U,8)=BOPPSRX
 S ^BOP(90355.44,"DRUG",DFN,DRUG,BOPPSRX)=DT
 ; Update the CLERK field of the RX VERIFY file (52.4) to reflect
 ; the dispensing person and not the user associated with the interface process.
 D VERIFY(+$G(PSONEW("IRXN")),USER)
 K PSOX,APSPDOC1,APSRX,PSODRUG
 Q
 ;
VERIFY(IEN,VAL) ;setting record for Rx Verify File
 N FDA,MSG,TIME
 Q:'$D(^PS(52.4,IEN,0))
 S FDA(52.4,IEN_",",2)=VAL
 D FILE^DIE(,"FDA","MSG")
 Q
 ;
MAIL ;mail alert for bad drug entry
 N XMDUZ,XMTEXT,XMY,XMSUB,XMZ,TEXT,BOPMGRP
 S BOPMGRP=$$GET1^DIQ(90355,1,.06)
 I BOPMGRP="" D
 .S XMY(DUZ)=""
 E  D
 .S XMY("G."_BOPMGRP)=""
 S XMDUZ=USER
 S TEXT(1)="An error has occurred in the Automated Dispensing Interface."
 S TEXT(2)="The drug that was selected is not in the Drug file (50)"
 S TEXT(3)="for patient: "_$P(^DPT(DFN,0),U)_"(Health Record #:"_HRN_")."
 S TEXT(4)="Drug IEN is "_DRUG
 S XMTEXT="TEXT(",XMSUB="BOP DRUG NOT ON FILE ERROR"
 D ^XMD
 Q
 ; Return NDC value from the HL7 (Omnicell) or from Drug File (Pyxis)
NDCLKP(DRUG) ;EP
 ;N VEND
 ;S VEND=$$VENDTYP^BOPROC()
 ;I VEND="O" Q $P(NODE3,"|",8)
 ;I VEND="P"
 Q $P($G(^PSDRUG(+DRUG,2)),"^",4)
 ;Q ""
