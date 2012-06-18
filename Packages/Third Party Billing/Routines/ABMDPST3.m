ABMDPST3 ; IHS/SD/SDR - Pending Claims Status Report ; JUN 29, 2005
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
PRINT ;EP for printing data
 K ABM("LOC TEMP"),ABM("PSU TEMP"),ABM("VT TEMP")
 K ABM("CLIN TEMP"),ABM("ACTIVE INS TEMP")
 S ABM("PG")=0
 D HDB
 S ABM("SUBCNT")=0
 S ABM("TOTALCNT")=0
 S (ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"),ABM("REASON"))=""
 F  S ABM("LOC NAME")=$O(ABM("ST",ABM("LOC NAME"))) Q:$G(ABM("LOC NAME"))=""  D
 .S ABM("PSUIEN")=""
 .F  S ABM("PSUIEN")=$O(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"))) Q:$G(ABM("PSUIEN"))=""  D
 ..S ABM("SORT")=""
 ..F  S ABM("SORT")=$O(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"))) Q:$G(ABM("SORT"))=""  D
 ...S ABM("I")=""
 ...F  S ABM("I")=$O(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"))) Q:$G(ABM("I"))=""  D
 ....S ABM("REASON")=""
 ....F  S ABM("REASON")=$O(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"),ABM("REASON"))) Q:$G(ABM("REASON"))=""  D
 .....S ABM("PSU")=$P($G(^VA(200,ABM("PSUIEN"),0)),U)
 .....;DO SUB HEADERS
 .....I $G(ABM("LOC TEMP"))'=ABM("LOC NAME") D:$G(ABM("LOC TEMP"))'="" SUBHDR,TOTHDR W !?3,"Visit Location: ",$G(ABM("LOC NAME")) S ABM("LOC TEMP")=ABM("LOC NAME")
 .....I $G(ABM("PSU TEMP"))'=ABM("PSU") W !?6,"Status Updater: ",$G(ABM("PSU")) S ABM("PSU TEMP")=ABM("PSU")
 .....I ABMY("SORT")="V" I $G(ABM("SORT TEMP"))'=ABM("SORT") D:$G(ABM("SORT TEMP"))'="" SUBHDR W !?5,"Visit Type: "_$P(^ABMDVTYP(ABM("SORT"),0),U) S ABM("SORT TEMP")=ABM("SORT")
 .....I ABMY("SORT")="C" I $G(ABM("SORT TEMP"))'=ABM("SORT") D:$G(ABM("SORT TEMP"))'="" SUBHDR W !?5,"    Clinic: "_$G(ABM("SORT")) S ABM("SORT TEMP")=ABM("SORT")
 .....I $G(ABM("ACTIVE INS TEMP"))'=$G(ABM("I")) W !?11,"Active Insurer: ",$P($G(^AUTNINS(ABM("I"),0)),U) S ABM("ACTIVE INS TEMP")=ABM("I")
 .....W !!,?2,$G(ABM("REASON"))
 .....W ?60,ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"),ABM("REASON")),!
 .....S ABM("SUBCNT")=$G(ABM("SUBCNT"))+$G(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"),ABM("REASON")))
 .....S ABM("TOTALCNT")=$G(ABM("TOTALCNT"))+$G(ABM("ST",ABM("LOC NAME"),ABM("PSUIEN"),ABM("SORT"),ABM("I"),ABM("REASON")))
 D SUBHDR
 D TOTHDR
 D PAZ^ABMDRUTL
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !,?60,"Number of"
 W !?2,"Reason",?60,"Claims"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
SUBHDR Q:'ABM("SUBCNT")
 W !?27,"------"
 W !?16,"Subtotal:",?60,ABM("SUBCNT"),!
 S ABM("SUBCNT")=0
 Q
 ;
TOTHDR Q:'ABM("TOTALCNT")
 W !?27,"------"
 W !?19,"Total:",?60,ABM("TOTALCNT")
 S ABM("TOTALCNT")=0
 Q
XIT ;EXIT POINT
 K ^TMP("ABM-ICS",$J)
 Q
