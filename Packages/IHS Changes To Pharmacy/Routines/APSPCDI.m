APSPCDI ; IHS/MSC/PLS - CRITICAL DRUG INTERACTION REPORT ;12-Jan-2012 12:00;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 33
 ;
EN ;EP
 N APSPBD,APSPED,APSPBDF,APSPEDF,APSPDIV,APSPQ,APSPDSUB
 N APSPDCT,APSPDCTN,APSPDRG,APSPSORT,STATS,APSPDOSE,APSPPRV
 N APSPPAT,APSPIVN
 S APSPDIV="",APSPDRG="",APSPQ=0,APSPDSUB=0,APSPDOSE=0,APSPPRV=""
 S APSPPAT=""
 W @IOF
 W !!,"Critical Drug Interaction Report"
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
 S APSPIVN=$$DIR^APSPUTIL("Y","Would you like to include Critical Drug Interactions from Pharmacy Intervention entries","Yes",,.APSPQ)
 Q:APSPQ
 S APSPSORT=+$$DIR^APSPUTIL("S^1:Drug Name;2:Fill Date;3:Patient;4:Prescriber","Sort report by","",,.APSPQ)
 Q:APSPQ
 S APSPPAT="*"
 I APSPSORT=3 D
 .S APSPPAT=$$DIR^APSPUTIL("Y","Would you like all patients","Yes",,.APSPQ)
 .Q:APSPQ
 .I APSPPAT D
 ..S APSPPAT="*"
 .E  D  Q:APSPQ
 ..S APSPPAT=+$$DIR^APSPUTIL("9000001,.01","Select Patient: ",,,.APSPQ)
 Q:APSPQ
 S APSPPRV="*"
 I APSPSORT=4 D
 .S APSPPRV=$$DIR^APSPUTIL("Y","Would you like all prescribers","Yes",,.APSPQ)
 .Q:APSPQ
 .I APSPPRV D
 ..S APSPPRV="*"
 .E  D  Q:APSPQ
 ..S APSPPRV=+$$DIR^APSPUTIL("52,4","Select Prescriber: ",,,.APSPQ)
 Q:APSPQ
 D DEV
 Q
DEV ;
 D OUT^APSPCDI
 Q
 N XBRP,XBNS
 S XBRP="OUT^APSPCDI"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 K ^TMP($J)
 D FIND(APSPBD,APSPED,"AD")  ; Regular and Refill
 D FIND(APSPBD,APSPED,"ADP")  ; Partial
 D:APSPIVN FINDINTV(APSPBD,APSPED)  ; APSP Interventions
 D SORT
 D PRINT^APSPCDI1
 ;K ^TMP($J)
 Q
 ;
FIND(SDT,EDT,XREF) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^PSRX(XREF,FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RXIEN=0
 .F  S RXIEN=$O(^PSRX(XREF,FDTLP,RXIEN)) Q:'RXIEN  D
 ..Q:'$$PATVRY(RXIEN,APSPPAT)  ;check patient
 ..Q:'$P(^PSRX(RXIEN,0),U,6)   ; Prescription must have a drug
 ..Q:$$GET1^DIQ(52,RXIEN,100,"I")=13  ; Quit if Deleted status
 ..S IEN="" F  S IEN=$O(^PSRX(XREF,FDTLP,RXIEN,IEN)) Q:IEN=""  D
 ...Q:'IEN&($$GET1^DIQ(52,RXIEN,32.1,"I"))  ; Quit if original fill and a return to stock date exists
 ...Q:'$$DIVVRY(RXIEN,APSPDIV,XREF,IEN)  ;check division
 ...Q:'$$DSPRDT(RXIEN,XREF,IEN)  ;check for release date
 ...Q:'$$PRVVRY(RXIEN,APSPPRV,XREF,IEN)  ;check provider
 ...Q:'$$CDIVRY(RXIEN)  ;check for Critical Drug Interaction on order
 ...D SET(FDTLP,RXIEN,XREF,IEN)
 Q
 ;
FINDINTV(SDT,EDT) ;EP
 N FDTLP,IEN
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^APSPQA(32.4,"B",FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S IEN=0
 .F  S IEN=$O(^APSPQA(32.4,"B",FDTLP,IEN)) Q:'IEN  D
 ..Q:'$$PATVRY(IEN,APSPPAT,1)
 ..Q:'$P(^APSPQA(32.4,IEN,0),U,5)  ;Intervention must have a drug
 ..Q:'$$PRVVRY(IEN,APSPPRV,,,1)  ;check provider
 ..Q:'$$CDIVRYA(IEN)  ;check for Critical Drug Interaction on intervention
 ..D SETA(FDTLP,IEN)  ;set intervention data
 Q
 ;
SORT ;EP -
 Q
 ; Set data into ^TMP global for output
SET(FDT,RX,XREF,SIEN) ;EP
 ;DATE FILLED
 ;CHART NUMBER;
 ;PATIENT NAME
 ;RX NUMBER
 ;MEDICATION FILLED
 ;INTERACTION
 ;OVER-RIDING PROVIDER OR PHARMACIST
 ;OVER-RIDING REASON
 N LSTDSPDT,NODE0,NODE2,NODE3,DIV,RTSDATE,DRUG,RDT,RIFLG,FTYPE
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
 ;                1            2             3                  4             5            6       7         8         9       10      11         12          13          14        15            16
 ;Format: Prescription IEN^Fill Date^Xref ("AD" or "ADP")^Fill SubIEN^Prescription Number^QTY^Drug Class^Drug Name^Fill Type^RI Flg^Drug IEN^RX Division^Days Supply^Prescriber^Pharmacist^Number of Order Checks
 S ^TMP($J,"DATA",NXT)=RXIEN_U_FDT_U_XREF_U_SIEN_U_$P(NODE0,U)_U_QTY_U_""_U_DRGNM_U_FTYPE_U_RIFLG_U_DRUG_U_DIV_U_DAYS_U_OPRV_U_PHRM_U_$$OCKCNT(RXIEN)
 S ^TMP($J,"XREF",DIV,"FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"DRUG",DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-DRUG",DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"PAT",PNM,FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"PRV",OPRVNM,DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF","RX",RX,FTYPE,SIEN)=NXT
 Q
 ;
SETA(FDT,IEN) ;EP-
 N NXT,NODE0,DRUG,DFN,PNM,DRGNM,PHRMC,PRV,PRVNM,DIV
 S NODE0=$G(^APSPQA(32.4,IEN,0))
 S DRUG=$P(NODE0,U,5)
 Q:DRUG=""
 S DFN=$P(NODE0,U,2)
 S PNM=$$GET1^DIQ(2,DFN,.01)
 Q:PNM=""
 S DRGNM=$P(^PSDRUG(DRUG,0),U)
 Q:DRGNM=""
 S PHRMC=$P(NODE0,U,4)
 S PRV=+$P(NODE0,U,3)
 S PRVNM=$$GET1^DIQ(200,PRV,.01)
 S:'$L(PRVNM) PRVNM="UNKNOWN"
 S DIV=$P(NODE0,U,16)
 Q:DIV=""
 S NXT=$O(^TMP($J,"DATA",$C(1)),-1)
 S NXT=NXT+1
 ;
 ;Format: Prescription IEN^Fill Date^Xref ("AD" or "ADP")^Fill SubIEN^Pr
 S ^TMP($J,"DATA",NXT)=IEN_U_FDT_U_"APSP"
 S ^TMP($J,"XREF",DIV,"FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"DRUG",DRGNM,FDT,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-DRUG",DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"S-FDT",FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"PAT",PNM,FDT,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"PRV",PRVNM,DRGNM,FDT,NXT)=""
 Q
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV,TYP,SIEN) ;EP
 Q:DIV="*" 1
 Q $S($G(SIEN):DIV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,9),1:DIV=+$P(^PSRX(RX,2),U,9))
 ; Return release date for dispense
DSPRDT(RX,TYP,SIEN) ;EP
 Q $S($G(SIEN):+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,$S(TYP="ADP":19,1:18)),1:+$P(^PSRX(RX,2),U,13))
 ; Return boolean flag indicating valid provider
PRVVRY(RX,PRV,TYP,SIEN,APSP) ;EP
 Q:PRV="*" 1
 Q:$G(APSP) +$P($G(^APSPQA(32.4,IEN,0)),U,3)=PRV
 Q $S($G(SIEN):PRV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,17),1:PRV=$P(^PSRX(RX,0),U,4))
 ; Return boolean flag indicating valid patient
PATVRY(IEN,PAT,APSP) ;EP
 Q:PAT="*" 1
 Q:$G(APSP) +$P($G(^APSPQA(32.4,IEN,0)),U,2)=PAT
 Q +$P($G(^PSRX(IEN,0)),U,2)=PAT
 ; Return boolean flag indicating valid order with order check of Critical Drug Indication
CDIVRY(RX) ;EP-
 N IEN,RES,ORDID
 S RES=0
 S ORDID=$P(^PSRX(RX,"OR1"),U,2)
 S IEN=0 F  S IEN=$O(^OR(100,ORDID,9,IEN)) Q:'IEN  D  Q:RES
 .S RES=$$GET1^DIQ(100.8,$P($G(^OR(100,+ORDID,9,IEN,0)),U),.01)="CRITICAL DRUG INTERACTION"
 Q RES
 ; Return boolean flag indicating intervention with Critical Drug Interaction
CDIVRYA(IEN) ;EP-
 Q $P($G(^APSPQA(32.4,IEN,0)),U,7)=18
 ; Return number of order checks on order
OCKCNT(RX) ;EP-
 N IEN,CNT,ORDID
 S (IEN,CNT)=0
 S ORDID=$P(^PSRX(RX,"OR1"),U,2)
 F  S IEN=$O(^OR(100,ORDID,9,IEN)) Q:'IEN  S CNT=CNT+1
 Q CNT
