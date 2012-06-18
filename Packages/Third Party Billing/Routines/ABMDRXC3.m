ABMDRXC3 ; IHS/SD/SDR - Closed claim stats ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
PRINT ;EP for writing data
 S ABM("PG")=0
 D HDB
 S ABM("CNT")=0,ABM("AMT")=0,ABM("CLOSER")=0,ABM("OL")=""
 S ABM("TOTCNT")=0
 F  S ABM("CLOSER")=$O(ABM("ST",ABM("CLOSER"))) Q:'ABM("CLOSER")!($G(ABM("F1")))  D
 .W !!?5,"Closing Official: ",$P(^VA(200,ABM("CLOSER"),0),U)
 .S ABM("L")="",ABM("OL")="",(ABM("SUBCNT"),ABM("V"),ABM("SUBAMT"))=0
 .F  S ABM("L")=$O(ABM("ST",ABM("CLOSER"),ABM("L"))) Q:ABM("L")=""!($G(ABM("F1")))  D
 ..S (ABM("SSCNT"),ABM("V"),ABM("SSAMT"))=0
 ..F  S ABM("V")=$O(ABM("ST",ABM("CLOSER"),ABM("L"),ABM("V"))) Q:'ABM("V")!($G(ABM("F1")))  D
 ...I $Y>(IOSL-5) D HD Q:$G(ABM("F1"))  S ABM("OL")=""
 ...I ABM("L")'=ABM("OL") W !!,$E(ABM("L"),1,30) S ABM("OL")=ABM("L")
 ...E  W !
 ...I ABMY("SORT")="V" W ?32,$E($P(^ABMDVTYP(ABM("V"),0),U),1,26)
 ...I ABMY("SORT")="C" W ?32,$E($P(^DIC(40.7,ABM("V"),0),U),1,26)
 ...S ABM("T")=$P(ABM("ST",ABM("CLOSER"),ABM("L"),ABM("V")),U,1)
 ...S ABM("A")=$P(ABM("ST",ABM("CLOSER"),ABM("L"),ABM("V")),U,2)
 ...W ?60,$J($FN(ABM("T"),",",0),5)
 ...S ABM("CNT")=ABM("CNT")+ABM("T"),ABM("SUBCNT")=ABM("SUBCNT")+ABM("T")
 ...S ABM("TOTCNT")=ABM("TOTCNT")+ABM("T")
 ...S ABM("AMT")=ABM("AMT")+ABM("A"),ABM("SUBAMT")=ABM("SUBAMT")+ABM("A")
 ...S ABM("SSAMT")=ABM("SSAMT")+ABM("A"),ABM("SSCNT")=ABM("SSCNT")+ABM("T")
 .D SUBHDR
 D TOTHDR
 W !!,"E N D  O F  R E P O R T"
 D PAZ^ABMDRUTL
 Q
 ;
HD D PAZ^ABMDRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("F1")=1 Q
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,?58,"Number of"
 W !,"Location",?32,$S(ABMY("SORT")="C":"Clinic",1:"Visit Type"),?60,"Claims"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
SUBHDR ;
 Q:+$G(ABM("SUBCNT"))=0
 W !?60,"------"
 W !?16,"Subtotal:",?60,$J($FN(ABM("SUBCNT"),",",0),5)
 S ABM("SUBCNT")=0
 Q
 ;
TOTHDR ;
 Q:+$G(ABM("TOTCNT"))=0
 W !?60,"------"
 W !?19,"Total:",?60,$J($FN(ABM("TOTCNT"),",",0),5)
 S ABM("T")=0
 Q
XIT ;EXIT POINT
 Q
