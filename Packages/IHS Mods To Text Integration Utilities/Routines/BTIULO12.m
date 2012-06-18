BTIULO12 ;IHS/CIA/MGH - IHS OBJECTS ADDED IN PATCHES ;03-Aug-2009 16:10;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006**;NOV 04, 2004
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
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C
 S C=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",,1,1,VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S C=C+1
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. ;I $E(ORD("TX",Y),1,3)="to " Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;I
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
