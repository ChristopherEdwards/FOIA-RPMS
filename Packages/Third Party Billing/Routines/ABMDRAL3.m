ABMDRAL3 ; IHS/ASDST/DMJ - Bills Stats Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**4**;NOV 12, 2009
 ;Original;TMD;
 ; IHS/SD/SDR - abm*2.6*4 - HEAT12210 - put subscripts in correct order
 ;
PRINT ;EP for printing data
 S ABM("PG")=0
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) D HDB
 S ABM("L")="",ABM("OL")=""
 F ABM="N","B","PD","DD","WO","OB" S ABM("T"_ABM)=0
 ;F  S ABM("L")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"))) Q:ABM("L")=""  D  ;abm*2.6*4 HEAT12210
 F  S ABM("L")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"))) Q:ABM("L")=""  D  ;abm*2.6*4 HEAT12210
 .S ABM("V")=0 F ABM="N","B","PD","DD","WO","OB" S ABM("S"_ABM)=0
 .;F  S ABM("V")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"))) Q:'ABM("V")  D  ;abm*2.6*4 HEAT12210
 .F  S ABM("V")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"))) Q:'ABM("V")  D  ;abm*2.6*4 HEAT12210
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  S ABM("OL")=""
 ..I ABM("L")'=ABM("OL") W !!,$E(ABM("L"),1,30) S ABM("OL")=ABM("L")
 ..W !
 ..I ABMY("SORT")="V" W ?17,$E($P(^ABMDVTYP(ABM("V"),0),U),1,25)
 ..I ABMY("SORT")="C" W ?17,$E($P(^DIC(40.7,ABM("V"),0),U),1,25)
 ..S ABM("I")=0
 ..F ABM="44^N","51^B","65^PD","79^DD","93^WO","107^OB" D
 ...S ABM("I")=ABM("I")+1
 ...;S ABM("P")=$P(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),0,0),U,ABM("I"))  ;abm*2.6*4 HEAT12210
 ...S ABM("P")=$P(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"),0,0),U,ABM("I"))  ;abm*2.6*4 HEAT12210
 ...S ABM($P(ABM,U,2))=ABM("P")
 ...S ABM("T"_$P(ABM,U,2))=ABM("P")+ABM("T"_$P(ABM,U,2))
 ...S ABM("S"_$P(ABM,U,2))=ABM("P")+ABM("S"_$P(ABM,U,2))
 ...I +ABM=44 W ?44,$J($FN(ABM("P"),",",0),5)
 ...E  W ?+ABM,$J($FN(ABM("P"),",",2),12)
 ..W ?124,$J($J($S(ABM("B"):(ABM("PD")/ABM("B")*100),1:0),".",1),5)
 .W !?44,"-----" F ABM=51,65,79,93,107 W ?ABM,"  ----------"
 .W ?123,"------",!?36,"Total:",?44,$J($FN(ABM("SN"),",",0),5)
 .F ABM="51^B","65^PD","79^DD","93^WO","107^OB" W ?+ABM,$J($FN(ABM("S"_$P(ABM,U,2)),",",2),12)
 .W ?124,$J($J($S(ABM("SB"):(ABM("SPD")/ABM("SB")*100),1:0),".",1),5)
 I ABM("TN")'=+$G(ABM("SN")) D
 .W !?43,"======" F ABM=51,65,79,93,107 W ?ABM," ==========="
 .W ?123,"======",!?30,"Grand Total:",?44,$J($FN(ABM("TN"),",",0),5)
 .F ABM="51^B","65^PD","79^DD","93^WO","107^OB" W ?+ABM,$J($FN(ABM("T"_$P(ABM,U,2)),",",2),12)
 .W ?124,$J($J($S(ABM("TB"):(ABM("TPD")/ABM("TB")*100),1:0),".",1),5)
 G XIT
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,"Location",?42,"Number of",?55,"Amount",?69,"Amount",?81,"Deductible",?95,"Write Off",?108,"Outstanding",?121,"Collection"
 W !?17,$S(ABMY("SORT")="C":"Clinic",1:"Visit Type"),?44,"Bills",?55,"Billed",?70,"Paid",?81,"and Co-Ins",?96,"Amount",?110,"Balance",?121,"Percentage"
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
XIT ;K ^TMP(ABM("SUBR"),"ST",$J)  ;abm*2.6*4 HEAT12210
 K ^TMP(ABM("SUBR"),$J,"ST")  ;abm*2.6*4 HEAT12210
 Q
