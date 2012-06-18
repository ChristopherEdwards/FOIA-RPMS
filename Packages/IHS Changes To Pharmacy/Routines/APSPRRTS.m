APSPRRTS ; IHS/MSC/PLS - RETURN TO STOCK REPORT ;23-Sep-2010 18:27;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1006,1007,1008,1009**;Sep 23, 2004
 ;
EN ;EP
 N APSPBD,APSPED,APSPDIV,APSPRTYP,APSPQ,APSPDSUB,APSPDCLS
 N APSPDCT,APSPDCTN,APSPDRG,APSPBDF,APSPEDF
 S APSPDIV="",APSPDRG="",APSPQ=0,APSPDSUB=0
 W @IOF
 W !!,"Pharmacy Return to Stock report by Division"
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
 S APSPRTYP=+$$DIR^APSPUTIL("S^1:Specific Drug Name;2:Drug Class;3:All Drugs","Sort report by",,,.APSPQ)
 Q:APSPQ
 I APSPRTYP=1 D  Q:APSPQ
 .S APSPDRG=$$GETIEN^APSPUTIL(50,"Select Drug Name: ",.APSPQ)
 E  I APSPRTYP=2 D  Q:APSPQ
 .S APSPDCLS=$$DIR^APSPUTIL("S^1:C-II;2:C-II through C-V;3:C-III through C-V","Drug Class Types","",,.APSPQ)
 .Q:APSPQ
 .S APSPDSUB=1  ;$$DIR^APSPUTIL("Y","Secondary sort by drug name",,,.APSPQ)
 .S APSPDCT(1)="2",APSPDCT(2)="2345",APSPDCT(3)="345"
 .S APSPDCTN(1)="C-II",APSPDCTN(2)="C-II through C-V",APSPDCTN(3)="C-III through C-V"
 E  D
 .S APSPDRG="*"
 .S APSPDSUB=$$DIR^APSPUTIL("Y","Sort by generic drug name","No",,.APSPQ)
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPRRTS"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 K ^TMP($J)
 D FIND($G(APSPDCLS))
 D PRINT
 Q
 ;
FIND(DCLS) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0
 S RXIEN=0
 F  S RXIEN=$O(^PSRX(RXIEN)) Q:'RXIEN  D
 .Q:'$D(^PSRX(RXIEN,0))       ; Prescription must have a zero node
 .Q:'$$DIVVRY(RXIEN,APSPDIV)  ;check division
 .Q:'$P(^PSRX(RXIEN,0),U,6)   ; Prescription must have a drug
 .I APSPRTYP=1 Q:'$$DRGVRY(APSPDRG,RXIEN)  ; Check for matching drug
 .I APSPRTYP=2 Q:'$$DCVRY(DCLS,RXIEN)  ;Quit if Drug Class search and drug doesn't match class
 .S ACTIEN=0
 .F  S ACTIEN=$O(^PSRX(RXIEN,"A",ACTIEN)) Q:'ACTIEN  D
 ..S A0=$G(^PSRX(RXIEN,"A",ACTIEN,0))
 ..Q:$P(A0,U,2)'="I"  ; Check for RETURN reason
 ..Q:+A0<APSPBD!(+A0>APSPED)  ;Check activity date against report date parameters
 ..D SET(RXIEN,ACTIEN)
 Q
 ;
PRINT ;EP
 N APSPPG,DFLG
 S (APSPPG,DFLG)=0
 D HDR
 D PRINT1
 W:'DFLG !,"No data found..."
 Q
 ;
PRINT1 ;EP
 ;This EP makes use of the MUMPS naked reference syntax.
 N DIV,SUB1,SUB2,SUB3,SUB4,VAL
 S DIV=0 F  S DIV=$O(^TMP($J,"XREF",DIV)) Q:'DIV  D
 .I APSPDIV="*" W !,"|"_$$GET1^DIQ(59,DIV,.01)_"|" D PRINT3
 .I APSPRTYP=1!(APSPRTYP=3&APSPDSUB) D
 ..S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1)) Q:'$L(SUB1)  D
 ...S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2)) Q:'SUB2  D
 ....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2,SUB3)) Q:'SUB3  D
 .....S VAL=^(SUB3)
 .....D PRINT2(^TMP($J,"DATA",VAL))
 .....S DFLG=1
 .E  I 'APSPDSUB D
 ..S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"RTS",SUB1)) Q:'SUB1  D
 ...S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"RTS",SUB1,SUB2)) Q:'SUB2  D
 ....S VAL=^(SUB2)
 ....D PRINT2(^TMP($J,"DATA",VAL))
 ....S DFLG=1
 .E  I APSPRTYP=2 D
 ..S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1)) Q:'$L(SUB1)  D
 ...S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2)) Q:'$L(SUB2)  D
 ....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3)) Q:'SUB3  D
 .....S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D
 ......S VAL=^(SUB4)
 ......D PRINT2(^TMP($J,"DATA",VAL))
 ......S DFLG=1
 Q
 ; Print the line
PRINT2(DATA) ;EP
 W !,$P($TR($$FMTE^XLFDT($P(DATA,U),"5Z"),"@"," "),":",1,2)_$P(DATA,U,8),?20,$P(DATA,U,9)_$P(DATA,U,3),?38,$P(DATA,U,7),?53,$E($P(DATA,U,6),1,34),?95,$P(DATA,U,4),?101,$$FMTE^XLFDT($P(DATA,U,2),"5Z"),?116,$P(DATA,U,10)
 D PRINT3 ;check page length
 Q
 ; Check page length
PRINT3 ;EP
 D:$Y+8>IOSL HDR
 Q
 ; Set data into ^TMP global for output
SET(RX,ACT) ;EP
 N LSTDSPDT,NODE0,NODE2,NODE3,DIV,DCLS,RTSDATE,DRUG,RDT,RIFLG
 N ACT0,ACTREF,HRN
 S NXT=$O(^TMP($J,"DATA",$C(1)),-1)
 S NXT=NXT+1
 S NODE0=^PSRX(RX,0)
 S NODE2=$G(^PSRX(RX,2))  ; IHS/MSC/PLS - 06/20/08 - Added $G
 S NODE3=$G(^PSRX(RX,3))  ; IHS/MSC/PLS - 06/20/08 - Added $G
 S DIV=$P(NODE2,U,9)
 S DRUG=$P(NODE0,U,6)
 S DRGNM=$P(^PSDRUG(DRUG,0),U)
 S DCLS=+$P(^PSDRUG(DRUG,0),U,3)
 S DCLS=$$CVTDCLS(DCLS)
 S LSTDSPDT=+NODE3
 S RIFLG=""
 S ACT0=$G(^PSRX(RX,"A",ACT,0))
 S RTSDATE=$P(+ACT0,".")  ; IHS/MSC/PLS - 06/20/08 - Added $G
 S HRN=$$HRN^AUPNPAT($P(NODE0,U,2),$$GET1^DIQ(59,DIV,100,"I"))  ;IHS/MSC/PLS - 06/29/10 - Added line
 S ACTREF=$P(ACT0,U,4)  ;RX Reference - 6=partial
 S RDT=$$GET1^DIQ(52,RX,31,"I")  ;Release Date
 I RDT>APSPBD,RDT<APSPED D
 .S:'$$GET1^DIQ(52.3,ACT_","_RX_",",.04,"I") RIFLG="*"
 S ^TMP($J,"DATA",NXT)=RTSDATE_U_LSTDSPDT_U_$P(NODE0,U)_U_$S(ACTREF=6:"#",1:$P(NODE0,U,7))_U_DCLS_U_DRGNM_U_$$GET1^DIQ(52.3,ACT_","_RX_",",.04)_U_RIFLG_U_$$DELFLG(RX)_U_HRN
 S ^TMP($J,"XREF",DIV,"RTS",RTSDATE,RX)=NXT
 S ^TMP($J,"XREF",DIV,"DCLS",DCLS,DRGNM,RTSDATE,RX)=NXT
 S ^TMP($J,"XREF",DIV,"DRUG",DRGNM,RTSDATE,RX)=NXT
 Q
 ; Return boolean flag indicating prescription drug matches selected drug
DRGVRY(DRUG,RX) ;EP
 Q $P($G(^PSRX(RX,0)),U,6)=DRUG
 ; Return boolean flag indicating prescription drug matches selected report drug class
 ; Input:  DCLS - Drug Class based on input selected by user
 ;         RX - Prescription IEN
DCVRY(DCLS,RX) ;EP
 N RXRTSDT,DRGIEN,DCLSVAL
 S RXRTSDT=$P($G(^PSRX(RXIEN,2)),U,15)
 S DRGIEN=$P(^PSRX(RX,0),U,6)
 Q:'$D(^PSDRUG(DRGIEN,0)) 0  ; Check for missing drug entry
 S DCLSVAL=$P(^PSDRUG(DRGIEN,0),U,3)
 Q APSPDCT(DCLS)[+DCLSVAL
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV) ;EP
 Q:DIV="*" 1
 Q DIV=+$P($G(^PSRX(RX,2)),U,9)  ; IHS/MSC/PLS -06/20/08 - Added $G
 ;
CVTDCLS(DCLS) ; EP
 Q:DCLS=2 "C-II"
 Q:DCLS=3 "C-III"
 Q:DCLS=4 "C-IV"
 Q:DCLS=5 "C-V"
 Q "C-UNKNOWN"
 ;
 ; Return '*' flag indicated prescription has been deleted
DELFLG(RX) ;EP
 Q $S($G(^PSRX(RX,"STA"))=13:"*",1:" ")
HDR ;EP
 W @IOF
 S APSPPG=APSPPG+1
 W !,"Returned to Stock Report",?35,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2),?(IOM-10),"Page: "_APSPPG
 W !,"Report Criteria:                  (An '*' after RTS Date indicates a reissued original Rx.)"
 W !,"                                  (An '*' prior to the Rx Number indicates a deleted prescription.)"
 W !,"                                  (A '#' indicates that quantity is unknown for returned partial fill.)"
 W !,?5,"Inclusive Dates: "_APSPBDF_" to "_APSPEDF
 W !,?5,"Pharmacy Division: "_$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All")
 W !,?5,"Type of Search: "_$S(APSPRTYP=3:"All Drugs",APSPRTYP=2:"Drug Class ("_APSPDCTN(APSPDCLS)_")",APSPRTYP=1:"Specific Drug ("_$$GET1^DIQ(50,APSPDRG,.01)_")",1:"")
 W !,?5,"Sorted by: "_$S($G(APSPDCLS):"Drug Class then Drug Name then RTS Date/Time",$G(APSPDSUB):"Drug Name then RTS Date/Time",1:"RTS Date/Time")
 D HDR1
 Q
 ;
HDR1 ;EP
 D DASH
 W "RTS Date/Time",?20,"Rx Number",?38,"Act Reference",?53,"Drug Name",?95,"Qty",?101,"Last Disp Date",?116,"Pt ID"
 D DASH
 Q
 ;
DASH ;EP
 N DASH
 W ! F DASH=1:1:IOM W "-"
 W !
 Q
