ABMDRBR3 ; IHS/ASDST/DMJ - Brief Claim List - stats ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;10/13/95 12:26 PM
 ;
PRINT ;EP for printing data
 D HDB
 S ABM("CNT")=0,ABM("L")="",ABM("OL")=""
 F  S ABM("L")=$O(ABM("ST",ABM("L"))) Q:ABM("L")=""!($G(ABM("F1")))  D
 .S (ABM("SUBCNT"),ABM("V"))=0
 .F  S ABM("V")=$O(ABM("ST",ABM("L"),ABM("V"))) Q:'ABM("V")!($G(ABM("F1")))  D
 ..I $Y>(IOSL-5) D HD Q:$G(ABM("F1"))  S ABM("OL")=""
 ..I ABM("L")'=ABM("OL") W !!,$E(ABM("L"),1,30) S ABM("OL")=ABM("L")
 ..E  W !
 ..I ABMY("SORT")="V" W ?32,$E($P(^ABMDVTYP(ABM("V"),0),U),1,30)
 ..I ABMY("SORT")="C" W ?32,$E($P(^DIC(40.7,ABM("V"),0),U),1,30)
 ..S ABM("T")=ABM("ST",ABM("L"),ABM("V"))
 ..W ?64,$J($FN(ABM("T"),",",0),5)
 ..S ABM("CNT")=ABM("CNT")+ABM("T"),ABM("SUBCNT")=ABM("SUBCNT")+ABM("T")
 .Q:$G(ABM("F1"))
 .W !?64,"-----",!?56,"Total:",?64,$J($FN(ABM("SUBCNT"),",",0),5)
 I ABM("CNT")'=$G(ABM("SUBCNT")),'$G(ABM("F1")) W !?63,"======",!?50,"Grand Total:",?63,$J($FN(ABM("CNT"),",",0),6)
 Q
 ;
HD D PAZ^ABMDRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("F1")=1 Q
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,?32,$S(ABMY("SORT")="V":"Visit",1:""),?62,"Number of"
 W !,"Location",?32,$S(ABMY("SORT")="C":"Clinic",1:"Type"),?64,"Claims"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
