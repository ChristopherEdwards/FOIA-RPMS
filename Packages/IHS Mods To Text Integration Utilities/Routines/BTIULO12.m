BTIULO12 ;IHS/MSC/MGH - IHS OBJECTS ADDED IN PATCHES ;31-Jan-2012 11:58;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006,1009**;NOV 04, 2004;Build 22
TORDER(DFN,TARGET) ;EP Orders for today
 NEW X,I,CNT,RESULT
 S CNT=0
 D GETORD(.RESULT,DFN)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .I $G(RESULT(I))'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 Q "~@"_$NA(@TARGET)
GETORD(RETURN,DFN) ;Get list of orders
 K RETURN
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C,ORDER,OLDOR
 S C=0,OLDOR=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",1,2,"",VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . S ORDER=+ORD
 . Q:ORDER=OLDOR
 . S OLDOR=ORDER
 . S C=C+1
 . F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. ;I $E(ORD("TX",Y),1,3)="to " Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;I
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
ORDTYPE(DFN,TARGET,TYPE) ;EP Orders for today depending on the type
 NEW X,I,CNT,RESULT
 S CNT=0
 D GETORD2(.RESULT,DFN,TYPE)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .I $G(RESULT(I))'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 Q "~@"_$NA(@TARGET)
GETORD2(RETURN,DFN,TYPE) ;Get list of orders
 K RETURN
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C,ORACT,ACT,NATURE,CODE
 S C=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",1,2,"",VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S CODE=""
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . S ORACT=$P($P(ORD,U,1),";",2)
 . S ACT=$G(^OR(100,+ORD,8,ORACT,0))
 . S NATURE=$P(ACT,U,12)
 . I NATURE'="" S CODE=$P($G(^ORD(100.02,NATURE,0)),U,2)
 . Q:CODE'=TYPE
 .F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;I
 .. S C=C+1
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
PRELAN(DFN) ;Preferred language
 N PRILAN,PRETER,PREFLAN,PROF,LANDT,IEN
 S PREFLAN="Not recorded"
 S LANDT=9999999 S LANDT=$O(^AUPNPAT(DFN,86,LANDT),-1)
 Q:LANDT="" PREFLAN
 S IEN=LANDT_","_DFN
 S PREFLAN=$$GET1^DIQ(9000001.86,IEN,.04)
 Q PREFLAN
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
