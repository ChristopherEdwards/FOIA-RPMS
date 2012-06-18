ACRFEVX1 ;IHS/OIRM/DSD/THL,AEF - EVALUATE QUOTES; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;EVALUATE QUOTES
VHEAD ;EP;TO DISPLAY HEADER FOR COMPARISON OF QUOTES BY VENDOR
 W @IOF
 W !?10,"Comparison of Quotes by VENDOR for RFQ: ",ACRDOC
 I $P(^ACRDOC(ACRDOCDA,"PO"),U,5) D
 .S ACRVDA=$P(^ACRDOC(ACRDOCDA,"PO"),U,5)
 .I ACRVDA,$D(^AUTTVNDR(ACRVDA,0)) D
 ..W !!,$P(^AUTTVNDR(ACRVDA,0),U)," is currently VENDOR for this PO."
 W !!?10,"No."
 W ?15,"Vendor"
 W ?50,"Total Quote"
 W !?10,"------------------------------"
 W ?50,"---------------"
 Q
IHEAD ;EP;TO DISPLAY HEADER FOR COMPARISON OF QUOTES BY ITEM
 W @IOF
 W !?10,"Comparison of Quotes by ITEM for RFQ: ",ACRDOC
 W !!,"No."
 W ?4,"Description/Vendor"
 W ?46,"Quantity"
 W ?56,"Unit"
 W ?68,"Item Cost"
 W !,"---"
 W ?4,"------------------------------"
 W ?46,"--------"
 W ?56,"-------"
 W ?68,"------------"
 Q
TOP ;EP;SELECT NUMBER TO DISPLAY
 S DIR(0)="NOA^1:"_ACRJ
 S DIR("A")="Display the Top HOW MANY "_$S($D(ACRVND):"VENDORS",1:"ITEMS")_": "
 S DIR("B")=ACRJ
 W !
 D DIR^ACRFDIC
 I $G(Y)<1!$D(ACRQUIT)!$D(ACROUT) S ACRQUIT="" Q
 S ACRTOP=Y
 Q
MODE ;EP;SELECT DISPLAY MODE
 S DIR(0)="SO^1:Display Summary VENDOR Quotes;2:Display Detailed VENDOR Quotes;3:Display Quotes by ITEM"
 S DIR("A")="Which display"
 W !
 D DIR^ACRFDIC
 I $G(Y)<1!$D(ACRQUIT)!$D(ACROUT) S ACRQUIT="" Q
 S ACRMODE=$S(Y'=3:"VENDOR",1:"ITEM")
 S:Y=2 ACRDETL=""
 Q
COUNT ;EP;COUNT NUMBER OF ITEMS IN ORIGINAL RFQ
 S (ACRSSDA,ACRI)=0
 F  S ACRSSDA=$O(^ACRSS("J",ACRDOCDA,ACRSSDA)) Q:'ACRSSDA  S ACRI=ACRI+1
 S ACRCOUNT=ACRI
 Q
