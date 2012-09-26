APSPCDI1 ; IHS/MSC/PLS - CRITICAL DRUG INTERACTION REPORT ;28-Nov-2011 14:53;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 33
 ;
 Q
PRINT ;EP
 N APSPPG,DFLG,NEWPG
 S (APSPPG,DFLG,NEWPG)=0
 D HDR
 D PRINT1
 W:'DFLG !,"No data found..."
 Q
 ;
PRINT1 ;EP
 N DIV,SUB1,SUB2,SUB3,SUB4,SUB5,VAL,LP,LSTFDT
 S LSTFDT=0
 S DIV=0 F  S DIV=$O(^TMP($J,"XREF",DIV)) Q:'DIV  D
 .I APSPDIV="*" W !!!,"Pharmacy Division: "_$$GET1^DIQ(59,DIV,.01),!  ;W !,"|"_$$GET1^DIQ(59,DIV,.01)_"|" D PRINT3()
 .I APSPSORT=1 D  ; Drug Name
 ..S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1)) Q:SUB1=""  D  ; Drug Name
 ...S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2)) Q:'SUB2  D  ; Fill Date
 ....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 .....D PRINT2(^TMP($J,"DATA",SUB3))
 .....S DFLG=1
 .I APSPSORT=2 D  ; Fill Date
 ..S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"FDT",SUB1)) Q:'SUB1  D  ; Fill Date
 ...S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"FDT",SUB1,SUB2)) Q:SUB2=""  D  ; Drug Name
 ....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"FDT",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 .....D PRINT2(^TMP($J,"DATA",SUB3))
 .....S DFLG=1
 .I APSPSORT=3 D  ; Patient Name
 ..S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PAT",SUB1)) Q:'$L(SUB1)  D  ; Patient Name
 ...S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2)) Q:'SUB2  D  ; Fill Date
 ....S SUB3="" F  S SUB3=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3)) Q:'$L(SUB3)  D  ; Drug Name
 .....S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB4))
 ......S DFLG=1
 .I APSPSORT=4 D  ; Provider
 ..S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PRV",SUB1)) Q:'$L(SUB1)  D  ; Provider
 ...S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2)) Q:'$L(SUB2)  D  ; Drug Name
 ....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Fill Date
 .....S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB4))
 ......S DFLG=1
 Q
 ; Print the line
PRINT2(DATA) ; EP -
 N RX,DFN,HRN
 I $P(DATA,U,3)="APSP" D
 .D APSPINV(+DATA)
 E  D
 .S RX=+DATA
 .S DFN=$$GET1^DIQ(52,RX,2,"I")
 .S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 .D PRINT3($P(DATA,U,16)+1)
 .W !,$P($TR($$FMTE^XLFDT($P(DATA,U,2),"5Z"),"@"," "),":",1,2),?14,$P(DATA,U,9),?20,$E($$GET1^DIQ(2,DFN,.01),1,16),?38,HRN,?48,$$GET1^DIQ(52,RX,.01),?60,$P(DATA,U,8)
 .D INTOUT(RX)
 D PRINT3() ;check page length
 Q
 ; Check page length and optionally print blank line
 ;
PRINT3(ADD) ;EP
 S ADD=$G(ADD,0)
 D:($Y+9+ADD)>IOSL HDR
 Q
 ;
HDR ;EP
 W:APSPPG @IOF
 S APSPPG=APSPPG+1,NEWPG=1
 W !,"Critical Drug Interaction Report",?(IOM-28),$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2),?(IOM-10),"Page: "_APSPPG
 W !,"Report Criteria:"
 W !,?5,"Inclusive Dates: "_APSPBDF_" to "_APSPEDF
 W !,?5,"Pharmacy Division: "_$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All")
 W !,?5,"Sorted by: "_$S(APSPSORT=1:"Drug Name, Fill Date",APSPSORT=2:"Fill Date then Drug Name",APSPSORT=3:"Patient then Fill Date",4:"Prescriber then Drug Name, Fill Date",1:"Unknown")
 I APSPSORT=3,APSPPAT W !,?7,"Patient sort restricted to ",$$GET1^DIQ(2,APSPPAT,.01)
 I APSPSORT=4,APSPPRV W !,?7,"Prescriber sort restricted to ",$$GET1^DIQ(200,APSPPRV,.01)
 D HDR1
 Q
 ;
HDR1 ;EP
 D DASH
 W "Date Disp.",?14,"Type",?20,"Patient",?40,"HRN",?48,"Rx Number",?60,"Drug Name"
 W !,?37,"Overriding Provider"
 W !,?7,"Overriding Reason"
 W !,"Cause"
 D DASH
 Q
 ;
DASH ;EP
 N DASH
 W ! F DASH=1:1:IOM W "-"
 W !
 Q
 ; Output order check information
INTOUT(RX) ;EP-
 N IEN,CNT,ORDID,IENS,CAUSE
 S (IEN,CNT)=0
 S ORDID=$P(^PSRX(RX,"OR1"),U,2)
 F  S IEN=$O(^OR(100,ORDID,9,IEN)) Q:'IEN  D
 .Q:$$GET1^DIQ(100.8,$P($G(^OR(100,+ORDID,9,IEN,0)),U),.01)'="CRITICAL DRUG INTERACTION"
 .S IENS=IEN_","_ORDID_","
 .W !,?5,$$GET1^DIQ(100.09,IENS,.01),?37,$$GET1^DIQ(100.09,IENS,.05)
 .W !,?7,$$GET1^DIQ(100.09,IENS,.04)
 .S CAUSE=$P($G(^OR(100,+ORDID,9,IEN,1)),":",2)
 .I $L(CAUSE) D
 ..W !,$S($L(CAUSE)>IOM:$E(CAUSE,1,IOM-3)_"...",1:CAUSE)
 Q
 ; Output APSP Intervention
APSPINV(IEN) ;EP-
 N FN,DFN,NODE0
 S FN=9009032.4
 S NODE0=^APSPQA(32.4,IEN,0)
 S DFN=$P(NODE0,U,2)
 W !,?5,$P($TR($$FMTE^XLFDT($P(NODE0,U),"5Z"),"@"," "),":",1,2),?21,$$GET1^DIQ(2,DFN,.01),?51,$$HRN^AUPNPAT(DFN,$$GET1^DIQ(59,$P(NODE0,U,16),100,"I")),?58,$$GET1^DIQ(FN,IEN,.05)
 W !,?7,$$GET1^DIQ(200,$P(NODE0,U,4),.01),?49,$$GET1^DIQ(FN,IEN,.08)
 W !,"Critical Drug Interaction over-ridden in RPMS Pharmacy Package"
 Q
