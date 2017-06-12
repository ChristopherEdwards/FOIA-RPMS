BTIULO19 ; IHS/MSC/MGH - Return to Stock Meds ;23-May-2016 15:35;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1017**;NOV 04, 2004;Build 7
RTS(DFN,TARGET,DAYS) ;Object to return RTS medications
 K @TARGET
 N CNT,X,X1,X2,STRT,RXIEN,PT,DATA,POI,QTY,FILL,PRV,RTS,AIEN,DOS,UNIT,FORM,SCH,DCNT,DIEN,SIG
 S CNT=0,DCNT=0,DAYS=$G(DAYS)
 I +DAYS=0 S DAYS=30
 S X1=$$NOW^XLFDT,X2=-30
 D C^%DTC
 S STRT=X
 F  S STRT=$O(^PSRX("AJ",STRT)) Q:'+STRT  D
 .S RXIEN="" F  S RXIEN=$O(^PSRX("AJ",STRT,RXIEN)) Q:'+RXIEN  D
 ..S PT=$$GET1^DIQ(52,RXIEN,2,"I")
 ..;Its for the correct patient
 ..I PT=DFN D
 ...S DCNT=DCNT+1
 ...D GETS^DIQ(52,RXIEN_",","4;7;22;32.1;39.2","IE","DATA")
 ...S POI=$G(DATA(52,RXIEN_",",39.2,"E"))
 ...S QTY=$G(DATA(52,RXIEN_",",7,"E"))
 ...S FILL=$G(DATA(52,RXIEN_",",22,"E"))
 ...S PRV=$G(DATA(52,RXIEN_",",4,"E"))
 ...S RTS=$G(DATA(52,RXIEN_",",32.1,"E"))
 ...S CNT=CNT+1
 ...S @TARGET@(CNT,0)=DCNT_". Drug: "_POI
 ...S CNT=CNT+1
 ...S @TARGET@(CNT,0)="   Fill: "_FILL_" RTS: "_RTS
 ...S CNT=CNT+1
 ...S @TARGET@(CNT,0)="   Provider: "_PRV
 ...S DIEN=0 F  S DIEN=$O(^PSRX(RXIEN,6,DIEN)) Q:'+DIEN  D
 ....S AIEN=DIEN_","_RXIEN_","
 ....K DOSE
 ....D GETS^DIQ(52.0113,AIEN,"**","IE","DOSE")
 ....S DOS=$G(DOSE(52.0113,AIEN,.01,"E"))
 ....S UNIT=$G(DOSE(52.0113,AIEN,2,"E"))
 ....S FORM=$G(DOSE(52.0113,AIEN,3,"E"))
 ....S SCH=$G(DOSE(52.0113,AIEN,7,"E"))
 ....S CNT=CNT+1
 ....S @TARGET@(CNT,0)="   Instr: "_DOS_UNIT_" "_FORM_" "_SCH
 ...S CNT=CNT+1
 ...S @TARGET@(CNT,0)="   Qty: "_QTY
 ...S SIG=0 F  S SIG=$O(^PSRX(RXIEN,"SIG1",SIG)) Q:SIG=""  D
 ....S CNT=CNT+1
 ....S @TARGET@(CNT,0)=$G(^PSRX(RXIEN,"SIG1",SIG,0))
 I 'DCNT S @TARGET@(1,0)="No Meds were returned to stock."
 Q "~@"_$NA(@TARGET)
