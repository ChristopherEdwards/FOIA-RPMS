ABMDRUN3 ; IHS/ASDST/DMJ - Unpaid Bills Stats ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
PRINT ;EP for printing data
 S ABM("PG")=0
 D HDB
 S (ABM("SUBCNT"),ABM("SUBAMT"))=0
 S ABM("CNT")=0,ABM("AMT")=0,ABM("L")="",ABM("OL")=""
 F  S ABM("L")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"))) Q:ABM("L")=""  D  Q:$D(DUOUT)!$D(DTOUT)
 .S (ABM("SUBCNT"),ABM("V"),ABM("SUBAMT"))=0
 .F  S ABM("V")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"))) Q:'ABM("V")  D  Q:$D(DUOUT)!$D(DTOUT)
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  S ABM("OL")=""
 ..I ABM("L")'=ABM("OL") W !!,$E(ABM("L"),1,30) S ABM("OL")=ABM("L")
 ..E  W !
 ..I ABMY("SORT")="V" W ?32,$E($P(^ABMDVTYP(ABM("V"),0),U),1,26)
 ..I ABMY("SORT")="C" W ?32,$E($P(^DIC(40.7,ABM("V"),0),U),1,26)
 ..S ABM("T")=$P(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),0,0),U,1)
 ..S ABM("A")=$P(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),0,0),U,2)
 ..W ?60,$J($FN(ABM("T"),",",0),5)
 ..W ?67,$J($FN(ABM("A"),",",2),12)
 ..S ABM("CNT")=ABM("CNT")+ABM("T"),ABM("SUBCNT")=ABM("SUBCNT")+ABM("T")
 ..S ABM("AMT")=ABM("AMT")+ABM("A"),ABM("SUBAMT")=ABM("SUBAMT")+ABM("A")
 .W !?60,"-----",?69,"----------",!?52,"Total:",?60,$J($FN(ABM("SUBCNT"),",",0),5)
 .W ?67,$J($FN(ABM("SUBAMT"),",",2),12)
 I ABM("CNT")'=ABM("SUBCNT") W !?59,"======",?68,"===========",!?46,"Grand Total:",?59,$J($FN(ABM("CNT"),",",0),6),?67,$J($FN(ABM("AMT"),",",2),12)
 K ^TMP(ABM("SUBR"),"ST",$J) Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,?58,"Number of",?72,"Amount"
 W !,"Location",?32,$S(ABMY("SORT")="C":"Clinic",1:"Visit Type"),?60,"Claims",?72,"Billed"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
