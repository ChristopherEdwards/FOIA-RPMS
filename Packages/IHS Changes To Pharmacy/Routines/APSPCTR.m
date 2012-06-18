APSPCTR ; IHS/DSD/ENM/BAO/DMH/CIA/PLS - CONTROLLED DRUG LIST BY DIV;15-Dec-2009 11:03;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1004,1006,1008,1009**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 01/13/04 - Updated version
 ; Modified - IHS/CIA/PLS - 02/24/06 - Patch 1004
 ; Modified - IHS/MSC/PLS - 09/26/07 - Patch 1006 - Added CHKSTAT check and business rule for DE date=Fill date for exclusion
 ;            IHS/MSC/PLS - 12/30/08 - Patch 1008 - Routine updated
 ;                        - 08/31/09 - Patch 1008 - Added DSPRDT for release date check
 ;                        - 12/14/09 - Patch 1009 - removed check for $$DIVVRY in the inital loop of Find.
EN ;EP
 N APSP,APSPAT,APSPATN,APSPBD,APSPCHN,APSPD,APSPDES,APSPDR,APSPBD,APSPED,APSPX,APSPN,APSPRX,APSPSH,DIC,APSPANS,APSPDTDR
 N APSPDRUG,APSPED,APSPGO,APSPITM,APSPMD,APSPMSG,APSPOP,APSPQTY,APSPRN,APSPRXN,APSPZZ,APSPBD,APSPCLER,APSPDIV,APSPDV
 N APSPGT,APSPT,APSPC9,%ZIS,%DT,POP,APSPQ,APSPBDF,APSPEDF
 W @IOF,!!,"Pharmacy Controlled Drug List by Division"
 W !,*7,?10,"132 Character Format!",!
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,DT,DT)
 Q:APSPQ
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 ;SELECT DIVISION
 S APSPDIV=$$DIR^APSPUTIL("Y","Would you like all pharmacy divisions","Yes",,.APSPQ)
 Q:APSPQ
 I APSPDIV D
 .S APSPDIV="*"
 E  D  Q:APSPQ
 .S APSPDIV=$$GETIEN^APSPUTIL(59,"Select Pharmacy Division: ",.APSPQ)
 Q:APSPQ
 S APSPDTDR=$$DIR^APSPUTIL("S^1:Date;2:Drug","Sort Report by",,,.APSPQ)
 Q:APSPQ
 D  Q:APSPQ
 .S APSPDCLS=$$DIR^APSPUTIL("S^1:C-2'S;2:C-3'S to C5'S;3:All","Drug Class Types","",,.APSPQ)
 .S APSPDCT(1)="2",APSPDCT(3)="2345",APSPDCT(2)="345"
 .S APSPDCTN(1)="C-II",APSPDCTN(2)="C-III through C-V",APSPDCTN(3)="C-II through C-V"
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPCTR"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 K ^TMP($J)
 D FIND(APSPBD,APSPED,"AD",$G(APSPDCLS))  ; Regular and Refill
 D FIND(APSPBD,APSPED,"ADP",$G(APSPDCLS))  ; Partial
 D PRINT^APSPCTR1
 K ^TMP($J)
 Q
 ;
FIND(SDT,EDT,XREF,DCLS) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^PSRX(XREF,FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RXIEN=0
 .F  S RXIEN=$O(^PSRX(XREF,FDTLP,RXIEN)) Q:'RXIEN  D
 ..Q:$$CHKSTAT(RXIEN)          ; check prescription status
 ..;Q:'$$DIVVRY(RXIEN,APSPDIV)  ;check division  ;Patch 1009 commented out
 ..Q:'$P(^PSRX(RXIEN,0),U,6)   ; Prescription must have a drug
 ..Q:'$$DCVRY(APSPDCLS,RXIEN)  ;Quit if Drug Class search and drug doesn't match class
 ..S IEN="" F  S IEN=$O(^PSRX(XREF,FDTLP,RXIEN,IEN)) Q:IEN=""  D
 ...Q:'IEN&($$GET1^DIQ(52,RXIEN,32.1,"I"))  ; Quit if original fill and a return to stock date exists
 ...Q:'$$DIVVRY(RXIEN,APSPDIV,XREF,IEN)  ;check division
 ...Q:'$$DSPRDT(RXIEN,XREF,IEN)  ;check for release date
 ...D SET(FDTLP,RXIEN,XREF,IEN)
 Q
 ; Check status business rules
 ; Input: RX - Prescription IEN
 ; Output: 0 - Prescription status OK, 1- Failed check
CHKSTAT(RX) ; EP
 N STA
 S STA=$P($G(^PSRX(RX,"STA")),U)
 Q:STA=13 1  ;Deleted
 ;Q:STA=5 1   ;Suspended
 ; Discontinue/Edit Status and (Fill Date = Order D/C Date) per PSG
 I STA=15,$$GET1^DIQ(52,RX,22,"I")=$P($$GET1^DIQ(100,$$GET1^DIQ(52,RX,39.3,"I"),63,"I"),".") Q 1
 Q 0
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
 ; Set data into ^TMP global for output
SET(FDT,RX,XREF,SIEN) ;EP
 N LSTDSPDT,NODE0,NODE2,NODE3,DIV,DCLS,RTSDATE,DRUG,RDT,RIFLG,FTYPE
 N PNM,DFN,DAYS,OPRV,PHRM,QTY,OPRVNM,CLERK,EDCLS,NXT
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
 S EDCLS=$$CVTDCLS(DCLS)
 S LSTDSPDT=+NODE3
 S RIFLG=""
 S DIV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.09,FTYPE="R":8,1:20),"I")  ; Pharmacy Division IEN
 S RDT=$$GET1^DIQ(52,RX,31,"I")  ;Release Date
 S QTY=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.04,FTYPE="R":1,1:7))
 S DAYS=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.041,FTYPE="R":1.1,1:8))
 S OPRV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":6,FTYPE="R":15,1:4),"I")
 S OPRVNM=$$GET1^DIQ(200,OPRV,.01)
 S CLERK=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.07,FTYPE="R":6,1:16),"I")
 S:'$L(OPRVNM) OPRVNM="NONAME"
 S PHRM=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.05,FTYPE="R":4,1:23),"I")
 ;                1            2             3                  4             5            6       7         8         9       10      11         12          13          14        15       16
 ;Format: Prescription IEN^Fill Date^Xref ("AD" or "ADP")^Fill SubIEN^Prescription Number^QTY^Drug Class^Drug Name^Fill Type^RI Flg^Drug IEN^RX Division^Days Supply^Prescriber^Pharmacist^Clerk
 S ^TMP($J,"DATA",NXT)=RXIEN_U_FDT_U_XREF_U_SIEN_U_$P(NODE0,U)_U_QTY_U_EDCLS_U_DRGNM_U_FTYPE_U_RIFLG_U_DRUG_U_DIV_U_DAYS_U_OPRV_U_PHRM_U_CLERK
 S ^TMP($J,"XREF",DIV,"FDT",FDT,DCLS,DRGNM,NXT)=""
 S ^TMP($J,"XREF",DIV,"DRUG",DRGNM,DCLS,FDT,NXT)=""
 S ^TMP($J,"XREF","RX",RX,FTYPE,SIEN)=NXT
 Q
 ;
CVTDCLS(DCLS) ; EP
 Q:DCLS=2 "C-II"
 Q:DCLS=3 "C-III"
 Q:DCLS=4 "C-IV"
 Q:DCLS=5 "C-V"
 Q "C-UNKNOWN"
