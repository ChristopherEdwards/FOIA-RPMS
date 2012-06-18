APSPCSM1 ; IHS/MSC/PLS - CONTROLLED SUBSTANCE MANAGEMENT REPORT ;22-Jul-2011 09:30;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007,1011**;Sep 23, 2004;Build 17
 ;
 Q
PRINT ;EP
 N APSPPG,DFLG,NEWPG
 S (APSPPG,DFLG,NEWPG)=0
 I APSPXML D
 .D HDRXML
 .D PRINT1
 .W !,$$TAG("Dispenses",1)
 .W !,$$TAG("Report",1)
 E  D
 .D HDR
 .D PRINT1
 .W:'DFLG !,"No data found..."
 Q
 ;
PRINT1 ;EP
 N DIV,SUB1,SUB2,SUB3,SUB4,SUB5,VAL,LP,LSTFDT
 S LSTFDT=0
 I APSPXML W !,$$TAG("PharmacyDivisions",0)
 S DIV=0 F  S DIV=$O(^TMP($J,"XREF",DIV)) Q:'DIV  D
 .I APSPDIV="*",'APSPXML W !!!,"Pharmacy Division: "_$$GET1^DIQ(59,DIV,.01),!  ;W !,"|"_$$GET1^DIQ(59,DIV,.01)_"|" D PRINT3
 .I APSPRTYP=1 D  ; Summary report
 ..W:APSPXML !,$$TAG("PharmacyDivision",0)
 ..W:APSPXML !,$$TAG("DivisionName",2,$$GET1^DIQ(59,DIV,.01))
 ..I APSPSORT=2 D  ; Fill Date/Drug Name
 ...S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"S-FDT",SUB1)) Q:'SUB1  D
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"S-FDT",SUB1,SUB2)) Q:'$L(SUB2)  D
 .....S SUB3="" F  S SUB3=$O(^TMP($J,"XREF",DIV,"S-FDT",SUB1,SUB2,SUB3)) Q:'SUB3  D
 ......D STATS^APSPCSM(^TMP($J,"DATA",SUB3))
 .....D PRINTSUM(APSPSORT,SUB2,.STATS,SUB1)
 .....K STATS
 .....S DFLG=1
 ....W !
 ..E  D  ; Drug Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"S-DRUG",SUB1)) Q:'$L(SUB1)  D
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"S-DRUG",SUB1,SUB2)) Q:'SUB2  D
 .....D STATS^APSPCSM(^TMP($J,"DATA",SUB2))
 ....D PRINTSUM(APSPSORT,SUB1,.STATS)
 ....K STATS
 ....S DFLG=1
 ..W:APSPXML !,$$TAG("PharmacyDivision",1)
 .E  D  ; Detailed report
 ..I APSPXML D
 ...W !,$$TAG("PharmacyDivision",0)
 ...W !,$$TAG("DivisionName",2,$$GET1^DIQ(59,DIV,.01))
 ..I APSPSORT=1 D  ; Drug Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1)) Q:SUB1=""  D  ; Drug Name
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2)) Q:'SUB2  D  ; Fill Date
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB3))
 ......S DFLG=1
 ..I APSPSORT=2 D  ; Fill Date
 ...S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"FDT",SUB1)) Q:'SUB1  D  ; Fill Date
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"FDT",SUB1,SUB2)) Q:SUB2=""  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"FDT",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB3))
 ......S DFLG=1
 ..I APSPSORT=3 D  ; Drug Class
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1)) Q:'$L(SUB1)  D  ; Drug Class
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2)) Q:'$L(SUB2)  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Fill Date
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ..I APSPSORT=4 D  ; Patient Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PAT",SUB1)) Q:'$L(SUB1)  D  ; Patient Name
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2)) Q:'SUB2  D  ; Fill Date
 .....S SUB3="" F  S SUB3=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3)) Q:'$L(SUB3)  D  ; Drug Name
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ..I APSPSORT=5 D  ; Provider
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PRV",SUB1)) Q:'$L(SUB1)  D  ; Provider
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2)) Q:'$L(SUB2)  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Fill Date
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ...I APSPDET,APSPPRV'="*" D PRTDSUM
 ..W:APSPXML !,$$TAG("PharmacyDivision",1)
 .D:APSPDET PRTDSUM
 .K STATS
 D:APSPDET PRTRTOT
 I APSPXML W !,$$TAG("PharmacyDivisions",1)
 Q
 ; Print Summary report line
PRINTSUM(RPTTYP,DRGNM,STATS,FDT) ;EP -
 N DAT
 S DAT=$G(STATS("DRUGN",DRGNM))
 I APSPXML D
 .W !,$$TAG("DispenseSummary")
 .W:$G(FDT) !,$$TAG("FillDate",2,$P($TR($$FMTE^XLFDT(FDT,"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("DrugName",2,DRGNM)
 .;W !,$$TAG("RXCnt",2,$J(STATS("RXCNT"),6))
 .W !,$$TAG("FillCnt",2,$J(STATS("FILLS"),6))
 .W !,$$TAG("UnitType",2,$P(DAT,U,2))
 .W !,$$TAG("TotalUnits",2,$J(+$G(STATS("DRUG",+DAT)),8))
 .;W !,$$TAG("AvgUnitsDispPerRX",2,$J(+$G(STATS("DRUG",+DAT))\STATS("RXCNT"),6,1))
 .W !,$$TAG("AvgUnitsDispPerFill",2,$J(+$G(STATS("DRUG",+DAT))\STATS("FILLS"),6,1))
 .W !,$$TAG("DispenseSummary",1)
 E  D
 .I $G(FDT),((FDT'=LSTFDT)!NEWPG) D
 ..W "Fill Date ",$$FMTE^XLFDT(FDT,"5Z"),!
 ..S LSTFDT=FDT
 .;W DRGNM,?44,$J(STATS("RXCNT"),6),?51,$P(DAT,U,2),?63,$J(+$G(STATS("DRUG",+DAT)),8),?73,$J(+$G(STATS("DRUG",+DAT))\STATS("RXCNT"),6,1),!
 .;W DRGNM,?44,$J(STATS("FILLS"),6),?51,$P(DAT,U,2),?63,$J(+$G(STATS("DRUG",+DAT)),8),?73,$J(+$G(STATS("DRUG",+DAT))\STATS("FILLS"),6,1),!
 .W DRGNM,?44,$E($P(DAT,U,2),1,10),?55,$J(STATS("FILLS"),6),?62,$J(+$G(STATS("DRUG",+DAT)),8),?74,$J(+$G(STATS("DRUG",+DAT))\STATS("FILLS"),6,1),!
 .S NEWPG=0
 .D PRINT3  ; check page length
 Q
 ; Output summary for detail report
PRTDSUM ; EP -
 N DRUGN,RX,RXCNT
 Q:'APSPETOT  ; User didn't ask for totals
 I APSPXML D
 .W !,$$TAG("ReportSubTotals")
 .S DRUGN="" F  S DRUGN=$O(STATS("RXDRUG",DRUGN)) Q:DRUGN=""  D
 ..W !,$$TAG("DrugName",2,DRUGN)
 ..W !,$$TAG("RXCount",2,$J(STATS("RXDRUG",DRUGN),6,0))
 ..S RX=0 F  S RX=$O(STATS("RXS",RX)) Q:'RX  D
 ...S RXCNT=$G(RXCNT)+1
 ..W:$G(RXCNT) !,$$TAG("TotalPrescriptionCount",2,RXCNT)
 ..W !,$$TAG("TotalFills",2,STATS("FILLS"))
 .W !,$$TAG("ReportTotals",1)
 E  D
 .D PRINT3
 .W !,"Report sub-totals",!
 .W !,?5,"Drug Name",?47,"# of fills",!
 .S DRUGN="" F  S DRUGN=$O(STATS("RXDRUG",DRUGN))  Q:DRUGN=""  D
 ..W ?5,DRUGN,?47,$J(STATS("RXDRUG",DRUGN),6,0),!
 ..D PRINT3
 .S RX=0 F  S RX=$O(STATS("RXS",RX)) Q:'RX  D
 ..S RXCNT=$G(RXCNT)+1
 .;W !!,"Total prescription count: ",+$G(RXCNT)
 .W !,"Total fills (new, refill, and partial): ",+$G(STATS("FILLS"))
 Q
 ; Output totals for report
PRTRTOT ; EP -
 N DRUGN,RX,RXCNT
 Q:'APSPETOT  ; User didn't ask for totals
 I APSPXML D
 .W !,$$TAG("ReportTotals")
 .S DRUGN="" F  S DRUGN=$O(APSPRTOT("RXDRUG",DRUGN)) Q:DRUGN=""  D
 ..W !,$$TAG("DrugName",2,DRUGN)
 ..W !,$$TAG("RXCount",2,$J(APSPRTOT("RXDRUG",DRUGN),6,0))
 ..S RX=0 F  S RX=$O(APSPRTOT("RXS",RX)) Q:'RX  D
 ...S RXCNT=$G(RXCNT)+1
 ..W:$G(RXCNT) !,$$TAG("TotalPrescriptionCount",2,RXCNT)
 .W !,$$TAG("TotalFills",2,$G(APSPRTOT("FILLS")))
 .W !,$$TAG("ReportTotals",1)
 E  D
 .D PRINT3
 .W !!,"Report Totals",!
 .W !,?5,"Drug Name",?47,"# of fills",!
 .S DRUGN="" F  S DRUGN=$O(APSPRTOT("RXDRUG",DRUGN))  Q:DRUGN=""  D
 ..W ?5,DRUGN,?47,$J(APSPRTOT("RXDRUG",DRUGN),6,0),!
 ..D PRINT3
 .S RX=0 F  S RX=$O(APSPRTOT("RXS",RX)) Q:'RX  D
 ..S RXCNT=$G(RXCNT)+1
 .;W !!,"Total prescription count: ",+$G(RXCNT)
 .W !,"Total fills (new, refill, and partial): ",+$G(APSPRTOT("FILLS"))
 Q
 ; Print the line
PRINT2(DATA) ; EP -
 N RX,DFN,HRN
 S RX=+DATA
 S DFN=$$GET1^DIQ(52,RX,2,"I")
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 D STATS^APSPCSM(DATA)
 I APSPXML D
 .W !,$$TAG("Dispense")
 .W !,$$TAG("FillDate",2,$P($TR($$FMTE^XLFDT($P(DATA,U,2),"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("Type",2,$P(DATA,U,9))
 .W !,$$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01))
 .W !,$$TAG("PatientHRN",2,HRN)
 .W !,$$TAG("PrescriptionNumber",2,$$GET1^DIQ(52,RX,.01))
 .W !,$$TAG("DrugName",2,$P(DATA,U,8))
 .W !,$$TAG("QTY",2,$P(DATA,U,6))
 .W !,$$TAG("DaysSupply",2,$P(DATA,U,13))
 .W !,$$TAG("DrugSchedule",2,$P(DATA,U,7))
 .W !,$$TAG("Provider",2,$$GET1^DIQ(200,$P(DATA,U,14),.01))
 .W !,$$TAG("ProviderDEA",2,$$GET1^DIQ(200,$P(DATA,U,14),53.2))
 .W !,$$TAG("Pharmacist",2,$$GET1^DIQ(200,$P(DATA,U,15),.01))
 .W !,$$TAG("RefillsRemaining",2,$P(DATA,U,16))
 .W !,$$TAG("Dosing",2,$$GETSIG(RX))
 .W !,$$TAG("Dispense",1)
 E  D
 .W !,$P($TR($$FMTE^XLFDT($P(DATA,U,2),"5Z"),"@"," "),":",1,2),?14,$P(DATA,U,9),?20,$E($$GET1^DIQ(2,DFN,.01),1,16),?38,HRN,?48,$$GET1^DIQ(52,RX,.01),?60,$P(DATA,U,8),?107,$P(DATA,U,6),?117,$P(DATA,U,13),?127,$P(DATA,U,7)
 .W !,?5,$$GET1^DIQ(200,$P(DATA,U,14),.01),?35,$$GET1^DIQ(200,$P(DATA,U,14),53.2),?50,$E($$GET1^DIQ(200,$P(DATA,U,15),.01),1,22),?74,$P(DATA,U,16)
 .I APSPDOSE D
 ..W !,?5,"Dosing:" D OUTSIG($$GETSIG(RX),IOM,12)
 .D PRINT3 ;check page length
 Q
 ; Check page length and optionally print blank line
 ;
PRINT3 ;EP
 D:$Y+8>IOSL HDR
 Q
 ;
HDR ;EP
 W:APSPPG @IOF
 S APSPPG=APSPPG+1,NEWPG=1
 W !,"Controlled Substance Management Report ("_$S(APSPRTYP=1:"Summary",1:"Detail")_")",?(IOM-28),$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2),?(IOM-10),"Page: "_APSPPG
 W !,"Report Criteria:"
 W !,?5,"Inclusive Dates: "_APSPBDF_" to "_APSPEDF
 W !,?5,"Pharmacy Division: "_$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All")
 W !,?5,"Drug Class: "_APSPDCTN(APSPDCLS)
 I APSPRTYP=2 D
 .W !,?5,"Sorted by: "_$S(APSPSORT=1:"Drug Name, Fill Date",APSPSORT=3:"Drug Schedule, Drug Name then Fill Date",APSPSORT=2:"Fill Date then Drug Name",APSPSORT=4:"Patient then Fill Date",5:"Prescriber then Drug Name, Fill Date",1:"Unknown")
 E  D
 .W !,?5,"Sorted by: "_$S(APSPSORT=1:"Drug Name",1:"Fill Date then Drug Name")
 I APSPDET,APSPSORT=4,APSPPAT W !,?7,"Patient sort restricted to ",$$GET1^DIQ(2,APSPPAT,.01)
 I APSPDET,APSPSORT=5,APSPPRV W !,?7,"Prescriber sort restricted to ",$$GET1^DIQ(200,APSPPRV,.01)
 D HDR1:APSPRTYP=2,HDR2:APSPRTYP=1
 Q
 ;
HDR1 ;EP
 D DASH
 W "Date Disp.",?14,"Type",?20,"Patient",?40,"HRN",?48,"Rx Number",?60,"Drug Name",?107,"Qty",?113,"Days Supply",?127,"Drug Schedule"
 W !,?5,"Prescriber",?35,"DEA Number",?50,"Pharmacist",?74,"Refills left"
 W !,?5,"Dosage Ordered"
 D DASH
 Q
HDR2 ;EP - Summary Report Header
 ; Note: Header states RX but the value printed is fills
 D DASH
 D PRINT3
 ;W ?45,"# of",?75,"Units",!
 ;W "Drug Name",?45,"Fills",?51,"Unit Type",?66,"Total",?72,"/Fill"
 W ?44,"Unit",?56,"# RXs",?64,"#Units",?74,"Avg",!
 W "Drug Name",?44,"Type",?56,"Filled",?64,"Filled",?73,"Unit/RX"
 D DASH
 Q
 ;
HDRXML ;EP - XML Header
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"Controlled Substance Management Report ("_$S(APSPRTYP=1:"Summary",1:"Detail")_")")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,APSPBDF_" to "_APSPEDF)
 W !,$$TAG("PharmacyDivision",2,$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All"))
 W !,$$TAG("DrugClass",2,APSPDCTN(APSPDCLS))
 W:APSPDET !,$$TAG("SortBy",2,$S(APSPSORT=1:"Drug Name, Fill Date",APSPSORT=3:"Drug Schedule, Drug Name then Fill Date",APSPSORT=2:"Fill Date, Drug Name",APSPSORT=4:"Patient, Fill Date",5:"Prescriber, Drug Name then Fill Date",1:"Unknown"))
 I APSPDET,APSPSORT=4,APSPPAT W !,$$TAG("Patient sort restricted to "_$$GET1^DIQ(2,APSPPAT,.01),2)
 I APSPDET,APSPSORT=5,APSPPRV W !,$$TAG("Prescriber sort restricted to "_$$GET1^DIQ(200,APSPPRV,.01),2)
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Dispenses")
 Q
 ;
DASH ;EP
 N DASH
 W ! F DASH=1:1:IOM W "-"
 W !
 Q
 ;
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
 ; Return SIG as a single string
GETSIG(RX) ;EP
 N LP,RET,SG
 S RET=""
 S SG=$G(^PSRX(RX,"SIG"))
 I $P(SG,U,2) D
 .S LP=0 F  S LP=$O(^PSRX(RX,"SIG1",LP)) Q:'LP  D
 ..S RET=RET_^PSRX(RX,"SIG1",LP,0)
 E  S RET=$P(SG,U)
 Q RET
 ; Output SIG
 ; Input:  X - Data to output
 ;          RM - Right Margin
 ;          LI - Left Indent
OUTSIG(X,RM,LI) ;EP - Output SIG
 Q:'$L(X)
 K ^UTILITY($J,"W")
 N DIWL,DIWR,DIWF,LP
 S DIWL=0,DIWR=RM-LI,DIWF=""
 D ^DIWP
 ;S LP=0 F  S LP=$O(^PSRX(RX,"PRC",LP)) Q:'LP  D
 ;.I $D(^(LP,0)) S X=^(0) D ^DIWP
 I $D(^UTILITY($J,"W")) D
 .S LP=0 F  S LP=$O(^UTILITY($J,"W",DIWL,LP)) Q:'LP  W ?LI,^(LP,0),!
 K ^UTILITY($J,"W")
 Q
