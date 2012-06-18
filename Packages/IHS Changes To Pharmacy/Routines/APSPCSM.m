APSPCSM ; IHS/MSC/PLS - CONTROLLED SUBSTANCE MANAGEMENT REPORT ;03-Aug-2011 16:21;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007,1008,1011**;Sep 23, 2004;Build 17
 ;
 ; IHS/MSC/PLS - 12/29/2008 - Line OUT+4 - Fixed variable name
 ;               04/21/2009 - Line FIND+10 - Fixed issue with external vs internal value
 ;               08/31/2009 - Added DSPRDT API for check of release date
 ;               05/16/2011 - Added Remaining Refills to data store
EN ;EP
 N APSPBD,APSPED,APSPBDF,APSPEDF,APSPDIV,APSPRTYP,APSPQ,APSPDSUB,APSPDCLS
 N APSPDCT,APSPDCTN,APSPDRG,APSPDET,APSPSORT,STATS,APSPDOSE,APSPXML,APSPPRV
 N APSPETOT,APSPPAT,APSPRTOT
 S APSPDIV="",APSPDRG="",APSPQ=0,APSPDSUB=0,APSPDOSE=0,APSPXML=0,APSPPRV=""
 S APSPETOT=1,APSPPAT=""
 W @IOF
 W !!,"Controlled Substance Management Report"
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,DT,DT)
 Q:APSPQ
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 S APSPDIV=$$DIR^APSPUTIL("Y","Would you like all pharmacy divisions","Yes",,.APSPQ)
 Q:APSPQ
 I APSPDIV D
 .S APSPDIV="*"
 E  D  Q:APSPQ
 .S APSPDIV=$$GETIEN^APSPUTIL(59,"Select Pharmacy Division: ",.APSPQ)
 Q:APSPQ
 D  Q:APSPQ
 .S APSPDCLS=$$DIR^APSPUTIL("S^1:C-II;2:C-II through C-V;3:C-III through C-V","Drug Class Types","",,.APSPQ)
 .Q:APSPQ
 .S APSPDSUB=1  ;$$DIR^APSPUTIL("Y","Secondary sort by drug name",,,.APSPQ)
 .S APSPDCT(1)="2",APSPDCT(2)="2345",APSPDCT(3)="345"
 .S APSPDCTN(1)="C-II",APSPDCTN(2)="C-II through C-V",APSPDCTN(3)="C-III through C-V"
 S APSPRTYP=+$$DIR^APSPUTIL("S^1:Summary;2:Detail","Report Type",,,.APSPQ)
 Q:APSPQ
 S APSPDET=APSPRTYP>1
 S APSPSORT=+$$DIR^APSPUTIL("S^1:Drug Name;2:Fill Date;"_$S(APSPDET:"3:Drug Schedule/Drug Name;4:Patient;5:Prescriber",1:""),"Sort report by",,,.APSPQ)
 Q:APSPQ
 S APSPPAT="*"
 I APSPSORT=4 D
 .S APSPPAT=$$DIR^APSPUTIL("Y","Would you like all patients","Yes",,.APSPQ)
 .Q:APSPQ
 .I APSPPAT D
 ..S APSPPAT="*"
 .E  D  Q:APSPQ
 ..S APSPPAT=+$$DIR^APSPUTIL("9000001,.01","Select Patient: ",,,.APSPQ)
 Q:APSPQ
 S APSPPRV="*"
 I APSPSORT=5 D
 .S APSPPRV=$$DIR^APSPUTIL("Y","Would you like all prescribers","Yes",,.APSPQ)
 .Q:APSPQ
 .I APSPPRV D
 ..S APSPPRV="*"
 .E  D  Q:APSPQ
 ..S APSPPRV=+$$DIR^APSPUTIL("52,4","Select Prescriber: ",,,.APSPQ)
 Q:APSPQ
 S APSPXML=+$$DIR^APSPUTIL("S^1:Standard Report;2:Data Export","Output Mode",1,,.APSPQ)
 Q:APSPQ
 S APSPXML=APSPXML=2
 S:APSPXML&APSPDET APSPETOT=+$$DIR^APSPUTIL("Y","Export report totals","No",,.APSPQ)
 Q:APSPQ
 S:APSPDET&'APSPXML APSPDOSE=+$$DIR^APSPUTIL("Y","Would you like dosing information included","No",,.APSPQ)
 Q:APSPQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPCSM"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 K ^TMP($J)
 D FIND(APSPBD,APSPED,"AD",$G(APSPDCLS))  ; Regular and Refill
 D FIND(APSPBD,APSPED,"ADP",$G(APSPDCLS))  ; Partial
 ;D:APSPRTYP=1 STATS
 D SORT
 D PRINT^APSPCSM1
 K ^TMP($J)
 Q
 ;
FIND(SDT,EDT,XREF,DCLS) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^PSRX(XREF,FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RXIEN=0
 .F  S RXIEN=$O(^PSRX(XREF,FDTLP,RXIEN)) Q:'RXIEN  D
 ..Q:'$$PATVRY(RXIEN,APSPPAT)  ;check patient
 ..;Q:'$$DIVVRY(RXIEN,APSPDIV)  ;check division  ;patch 1008
 ..Q:'$P(^PSRX(RXIEN,0),U,6)   ; Prescription must have a drug
 ..Q:'$$DCVRY(APSPDCLS,RXIEN)  ;Quit if Drug Class search and drug doesn't match class
 ..Q:$$GET1^DIQ(52,RXIEN,100,"I")=13  ; Quit if Deleted status
 ..;Q:$$GET1^DIQ(52,RXIEN,100,"I")=5   ; Quit if Suspended status
 ..S IEN="" F  S IEN=$O(^PSRX(XREF,FDTLP,RXIEN,IEN)) Q:IEN=""  D
 ...Q:'IEN&($$GET1^DIQ(52,RXIEN,32.1,"I"))  ; Quit if original fill and a return to stock date exists
 ...Q:'$$DIVVRY(RXIEN,APSPDIV,XREF,IEN)  ;check division
 ...Q:'$$DSPRDT(RXIEN,XREF,IEN)  ;check for release date
 ...Q:'$$PRVVRY(RXIEN,APSPPRV,XREF,IEN)  ;check provider
 ...D SET(FDTLP,RXIEN,XREF,IEN)
 Q
 ;
 ; Calculate statistics
STATS(DAT) ;EP -
 N LP,RX,DRUG,DRUGN,QTY,FDT,RXCNT
 S RX=$P(DAT,U)
 S DRUG=$P(DAT,U,11)
 S DRUGN=$P(DAT,U,8)
 S QTY=+$P(DAT,U,6)
 S FDT=$P(DAT,U,2)
 S DIV=+$P(DAT,U,12)
 S STATS("FILLS")=+$G(STATS("FILLS"))+1
 S APSPRTOT("FILLS")=$G(APSPRTOT("FILLS"))+1
 S STATS("DRUG",DRUG)=+$G(STATS("DRUG",DRUG))+QTY
 S APSPRTOT("DRUG",DRUG)=+$G(APSPRTOT("DRUG",DRUG))+QTY
 S STATS("DRUGN",DRUGN)=DRUG_U_$$GET1^DIQ(50,DRUG,14.5)
 S APSPRTOT("DRUGN",DRUGN)=DRUG_U_$$GET1^DIQ(50,DRUG,14.5)
 I '$G(STATS("RXS",RX)) D
 .S APSPRTOT("RXCNT")=+$G(APSPRTOT("RXCNT"))+1
 .S STATS("RXCNT")=+$G(STATS("RXCNT"))+1
 I '$G(STATS("RXS",RX)) D
 .S APSPRTOT("RXDRUG",DRUGN)=+$G(APSPRTOT("RXDRUG",DRUGN))+1
 .S STATS("RXDRUG",DRUGN)=+$G(STATS("RXDRUG",DRUGN))+1  ; Holds number for prescriptions for a given drug
 S APSPRTOT("RXS",RX)=+$G(STATS("RXS",RX))+1
 S STATS("RXS",RX)=+$G(STATS("RXS",RX))+1  ; Holds number of fills per RX
 Q
SORT ;EP -
 Q
 ; Set data into ^TMP global for output
SET(FDT,RX,XREF,SIEN) ;EP
 N LSTDSPDT,NODE0,NODE2,NODE3,DIV,DCLS,RTSDATE,DRUG,RDT,RIFLG,FTYPE
 N PNM,DFN,DAYS,OPRV,PHRM,QTY,OPRVNM,NXT
 S FTYPE=$S(XREF="ADP":"P",SIEN:"R",1:"F")
 S NXT=$O(^TMP($J,"DATA",$C(1)),-1)
 S NXT=NXT+1
 S NODE0=^PSRX(RX,0)
 S NODE2=^PSRX(RX,2)
 S NODE3=^PSRX(RX,3)
 S DRUG=$P(NODE0,U,6)
 S DFN=$P(NODE0,U,2)
 S PNM=$$GET1^DIQ(2,DFN,.01)
 S DRGNM=$P(^PSDRUG(DRUG,0),U)
 S DCLS=+$P(^PSDRUG(DRUG,0),U,3)
 S DCLS=$$CVTDCLS(DCLS)
 S LSTDSPDT=+NODE3
 S RIFLG=""
 S DIV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.09,FTYPE="R":8,1:20),"I")  ; Pharmacy Division IEN
 S RDT=$$GET1^DIQ(52,RX,31,"I")  ;Release Date
 S QTY=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.04,FTYPE="R":1,1:7))
 S DAYS=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.041,FTYPE="R":1.1,1:8))
 S OPRV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":6,FTYPE="R":15,1:4),"I")
 S OPRVNM=$$GET1^DIQ(200,OPRV,.01)
 S:'$L(OPRVNM) OPRVNM="NONAME"
 S PHRM=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.05,FTYPE="R":4,1:23),"I")
 ;                1            2             3                  4             5            6       7         8         9       10      11         12          13          14        15          16
 ;Format: Prescription IEN^Fill Date^Xref ("AD" or "ADP")^Fill SubIEN^Prescription Number^QTY^Drug Class^Drug Name^Fill Type^RI Flg^Drug IEN^RX Division^Days Supply^Prescriber^Pharmacist^RemainingRefills
 S ^TMP($J,"DATA",NXT)=RXIEN_U_FDT_U_XREF_U_SIEN_U_$P(NODE0,U)_U_QTY_U_DCLS_U_DRGNM_U_FTYPE_U_RIFLG_U_DRUG_U_DIV_U_DAYS_U_OPRV_U_PHRM_U_+$$RMNRFL^APSPFUNC(RXIEN,FDT)
 S ^TMP($J,"XREF",DIV,"FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"DRUG",DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-DRUG",DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"DCLS",DCLS,DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF",DIV,"PAT",PNM,FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"PRV",OPRVNM,DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF","RX",RX,FTYPE,SIEN)=NXT
 Q
 ; Return boolean flag indicating prescription drug matches selected report drug class
 ; Input:  DCLS - Drug Class based on input selected by user
 ;         RX - Prescription IEN
DCVRY(DCLS,RX) ;EP
 N RXRTSDT,DRGIEN,DCLSVAL
 S RXRTSDT=$P($G(^PSRX(RXIEN,2)),U,15)
 S DRGIEN=$P(^PSRX(RX,0),U,6)
 Q:'$D(^PSDRUG(DRGIEN,0))  ; Check for missing drug entry
 S DCLSVAL=$P(^PSDRUG(DRGIEN,0),U,3)
 Q APSPDCT(DCLS)[+DCLSVAL
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV,TYP,SIEN) ;EP
 Q:DIV="*" 1
 Q $S($G(SIEN):DIV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,9),1:DIV=+$P(^PSRX(RX,2),U,9))
 ; Return release date for dispense
DSPRDT(RX,TYP,SIEN) ;EP
 Q $S($G(SIEN):+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,$S(TYP="ADP":19,1:18)),1:+$P(^PSRX(RX,2),U,13))
 ; Return boolean flag indicating valide provider
PRVVRY(RX,PRV,TYP,SIEN) ;EP
 Q:PRV="*" 1
 Q $S($G(SIEN):PRV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,17),1:PRV=$P(^PSRX(RX,0),U,4))
 ; Return boolean flag indicating valid patient
PATVRY(RX,PAT) ;EP
 Q:PAT="*" 1
 Q +$P($G(^PSRX(RX,0)),U,2)=PAT
 ;
CVTDCLS(DCLS) ; EP
 Q:DCLS=2 "C-II"
 Q:DCLS=3 "C-III"
 Q:DCLS=4 "C-IV"
 Q:DCLS=5 "C-V"
 Q "C-UNKNOWN"
 ;
