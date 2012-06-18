APSPTDD ;IHS/DSD/ENM/CIA/PLS - OUTPATIENT PHAR TOTAL DRUGS DISPENSED ;07-Jul-2010 15:55;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1009**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 02/16/04
 ;            IHS/MSC/PLS - 01/02/08 - Routine updated
 ;                          12/16/09 - Modified GETIEN1 to GETIEN for File 50
 ;                          07/07/10 - Added S APSPDALL=0 when sorted by Drug Class
EN ;EP
 N APSPBD,APSPED,APSPBDF,APSPEDF,APSPDIV,APSPDRG,APSPQ
 N APSPCLS,APSPDARY,APSPNOD,TCNT,APSPDALL,QFLG,TOTAL
 N APSPSORT,DCNT
 S (DCNT,APSPCLS)=0
 W @IOF
 W "Pharmacy Total Drugs Dispensed List ",!!
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,DT,DT)
 Q:APSPQ
 I APSPED<APSPBD S X=APSPED,APSPED=APSPBD,APSPBD=X
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 S APSPDIV=$$DIR^APSPUTIL("Y","Would you like all pharmacy divisions","Yes",,.APSPQ)
 Q:APSPQ
 I APSPDIV D
 .S APSPDIV="*"
 E  D  Q:APSPQ
 .S APSPDIV=$$GETIEN^APSPUTIL(59,"Select Pharmacy Division: ",.APSPQ)
 ; Sort by
 S APSPSORT=$$DIR^APSPUTIL("S^1:VA Drug Class;2:Drug","Sort By",,.APSPQ)
 I APSPSORT=1 D  Q:APSPCLS<0
 .S APSPCLS=$$GETIEN1^APSPUTIL(50.605,"Select VA Drug Class: ",-1)
 .S APSPDALL=0
 E  D  Q:'APSPDALL&'DCNT
 .S APSPDALL=$$DIRYN^APSPUTIL("Would you like all drugs","Yes","Enter 'Yes' or 'No'",.APSPQ)
 .Q:APSPQ!APSPDALL
 .F  D  Q:QFLG
 ..S APSPDRG=$$GETIEN^APSPUTIL(50,"Select Drug Name: ",,"QM")
 ..I APSPDRG<1 S QFLG=1 Q
 ..S APSPDARY(APSPDRG)=""
 ..S DCNT=DCNT+1
 ..S QFLG='$$DIRYN^APSPUTIL("Want to Select Another Drug","No","Enter a 'Y' or 'YES' to include more drugs in your search",.APSPQ)
 ..S:'QFLG QFLG=APSPQ
 Q:APSPQ
 S APSPNOD=$$DIRYN^APSPUTIL("Suppress printing drug names in header","Yes","Answer 'Yes' if you do not want the drug names to appear on each page",.APSPQ)
 D DEV
 Q
DEV ;EP
 N XBRP,XBNS
 S XBRP="OUT^APSPTDD"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 K ^TMP($J)
 D:APSPCLS VAC  ; Build drug list
 D FIND(APSPBD,APSPED,"AD",.APSPDARY)
 D FIND(APSPBD,APSPED,"ADP",.APSPDARY)
 D EN^APSPTDD1
 K ^TMP($J)
 Q
 ;
VAC ; Build drug list for selected VA Drug Class
 N APSPDS
 S APSPDS=0
 F  S APSPDS=$O(^PSDRUG("VAC",APSPCLS,APSPDS)) Q:'APSPDS  D
 .Q:'$D(^PS(50.605,APSPCLS))
 .S APSPDARY(APSPDS)=""
 Q
FIND(SDT,EDT,XREF,DARY) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN,DRG
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^PSRX(XREF,FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RXIEN=0
 .F  S RXIEN=$O(^PSRX(XREF,FDTLP,RXIEN)) Q:'RXIEN  D
 ..Q:$$CHKSTAT(RXIEN)          ; check prescription status
 ..;Q:'$$DIVVRY(RXIEN,APSPDIV)  ;check division
 ..S DRG=$P(^PSRX(RXIEN,0),U,6)
 ..Q:'DRG   ; Prescription must have a drug
 ..Q:'$D(^PSDRUG(DRG,0))
 ..Q:'$$CHKDRG(DRG)
 ..S IEN="" F  S IEN=$O(^PSRX(XREF,FDTLP,RXIEN,IEN)) Q:IEN=""  D
 ...Q:'IEN&($$GET1^DIQ(52,RXIEN,32.1,"I"))  ; Quit if original fill anda return to stock date exists
 ...Q:'$$DIVVRY(RXIEN,APSPDIV,XREF,IEN)  ;check division
 ...D SET(FDTLP,RXIEN,XREF,IEN)
 Q
 ; Check status business rules
 ; Input: RX - Prescription IEN
 ; Output: 0 - Prescription status OK, 1- Failed check
CHKSTAT(RX) ; EP
 N STA
 S STA=$P($G(^PSRX(RX,"STA")),U)
 Q:STA=13 1  ; Deleted
 Q:STA=5 1   ; Suspended
 Q 0
 ; Check prescription drug for report inclusion
 ; Input: DRG - Prescription Drug
 ; Output: 0 - Drug not included; 1 - Drug included
CHKDRG(DRG) ;EP
 Q:APSPDALL 1
 Q ''$D(DARY(DRG))
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV,TYP,SIEN) ;EP
 Q:DIV="*" 1
 Q $S($G(SIEN):DIV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,9),1:DIV=+$P(^PSRX(RX,2),U,9))
SET(FDT,RX,XREF,SIEN) ;EP
 N RXN,DFN,QTY,DRGNM,REMARK,OPRV,FTYPE,DIV,UNIT
 S FTYPE=$S(XREF="ADP":"P",SIEN:"R",1:"F")
 S RXN=$P(^PSRX(RX,0),U)  ; Prescription number
 S DFN=$P(^PSRX(RX,0),U,2)  ; Patient IFN
 S DIV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RXIEN_",",1:RXIEN),$S(FTYPE="P":.09,FTYPE="R":8,1:20),"I")  ; Pharmacy Division IEN
 S QTY=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":.04,FTYPE="R":1,1:7))
 S DRGNM=$P(^PSDRUG(DRG,0),U) ;Drug Name
 S OPRV=$$GET1^DIQ($S(FTYPE="P":52.2,FTYPE="R":52.1,1:52),$S("PR"[FTYPE:SIEN_","_RX_",",1:RX),$S(FTYPE="P":6,FTYPE="R":15,1:4),"I")
 S UNIT=$$GET1^DIQ(50,DRG,14.5)
 S:'$L(UNIT) UNIT="***"
 I $D(^TMP($J,"PSODUR",DIV,DRGNM,UNIT)) D
 .S ^TMP($J,"PSODUR",DIV,DRGNM,UNIT)=$P(^(UNIT),U)+QTY_U_($P(^(UNIT),U,2)+1)
 E  S ^TMP($J,"PSODUR",DIV,DRGNM,UNIT)=QTY_U_1
 Q
