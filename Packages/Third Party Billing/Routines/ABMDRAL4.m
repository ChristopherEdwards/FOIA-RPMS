ABMDRAL4 ; IHS/ASDST/DMJ - Bills Cost Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**3,8**;NOV 12, 2009
 ;Original;TMD;
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12210 - fix output so $amounts display
 ;
PRINT ;EP for printing data
 S ABM("PG")=0
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) D HDB
 F ABM="N","B","PD","DD","WO","OB" S ABM("T"_ABM)=0
 S ABM("L")="",ABM("V")=0,ABM("TN")=0
 ;F  S ABM("L")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"))) Q:ABM("L")=""  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 F  S ABM("L")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"))) Q:ABM("L")=""  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 .S (ABM("SN"),ABM("V"))=0 F ABM="DD","B","PD","WO","OB" S ABM("S"_ABM)=0
 .D WLOC:$Y<(IOSL-7)
 .;F ABM("VI")=1:1 S ABM("V")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"))) Q:'ABM("V")  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 .F ABM("VI")=1:1 S ABM("V")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"))) Q:'ABM("V")  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 ..I $Y>(IOSL-6) D HD Q:$D(DUOUT)  D WLOC I 1
 ..E  I ABM("VI")>1 W !
 ..D WSRT
 ..F ABM="DD","B","PD","WO","OB" S ABM("M"_ABM)=0
 ..S ABM("E")="",ABM("OE")="",ABM("CN")=0
 ..;F  S ABM("E")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),ABM("E"))) Q:ABM("E")=""  D  G XIT:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 ..F  S ABM("E")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"),ABM("E"))) Q:ABM("E")=""  D  G XIT:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 ...I $Y>(IOSL-4) D HD Q:$D(DUOUT)  D WLOC,WSRT
 ...W ! I ABM("E")'=ABM("OE") W $E(ABM("E"),1,30)
 ...S ABM("C")=0,ABM("AI")=0
 ...;F  S ABM("C")=$O(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),ABM("E"),ABM("C"))) Q:'ABM("C")  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 ...F  S ABM("C")=$O(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"),ABM("E"),ABM("C"))) Q:'ABM("C")  D  Q:$D(DUOUT)  ;abm*2.6*8 HEAT49932
 ....I $Y>(IOSL-4) D HD Q:$D(DUOUT)  D WLOC,WSRT
 ....I ABM("AI") W !
 ....S ABM("AI")=ABM("AI")+1
 ....S ABM("CN")=ABM("CN")+1
 ....S ABM("SN")=ABM("SN")+1
 ....S ABM("TN")=ABM("TN")+1
 ....S ABM=$P(^ABMDBILL(DUZ(2),ABM("C"),0),U,5)
 ....W ?32,$S($D(^AUPNPAT(ABM,41,ABM("L"),0)):$P(^(0),U,2),$D(^AUPNPAT(ABM,41,DUZ(2),0)):$P(^(0),U,2),1:"")
 ....;W:$G(^ABMDBILL(DUZ(2),ABM("C"),7)) ?40,$E(+^(7),4,5),"/",$E(+^(7),6,7)
 ....W ?40,$J($P(^ABMDBILL(DUZ(2),ABM("C"),0),U),7)
 ....S ABM("I")=0
 ....F ABM="48^N","51^B","65^PD","79^DD","93^WO","107^OB" D  Q:$D(DUOUT)
 .....S ABM("I")=ABM("I")+1 Q:+ABM=48
 .....;S ABM("P")=$P(^TMP(ABM("SUBR"),"ST",$J,ABM("L"),ABM("V"),ABM("E"),ABM("C")),U,ABM("I"))  ;abm*2.6*3 HEAT12210
 .....S ABM("P")=$P(^TMP(ABM("SUBR"),$J,"ST",ABM("L"),ABM("V"),ABM("E"),ABM("C")),U,ABM("I"))  ;abm*2.6*3 HEAT12210
 .....S ABM($P(ABM,U,2))=ABM("P")
 .....S ABM("T"_$P(ABM,U,2))=ABM("P")+ABM("T"_$P(ABM,U,2))
 .....S ABM("S"_$P(ABM,U,2))=ABM("P")+ABM("S"_$P(ABM,U,2))
 .....S ABM("M"_$P(ABM,U,2))=ABM("P")+ABM("M"_$P(ABM,U,2))
 .....I +ABM=58 W ?58,$J($FN(ABM("P"),",",0),5)
 .....E  W ?+ABM,$J($FN(ABM("P"),",",2),12)
 ....W ?124,$J($J($S(ABM("B"):(ABM("PD")/ABM("B")*100),1:0),".",1),5)
 ..Q:ABM("CN")=1
 ..W !?40,"-------" F ABM=51,65,79,93,107 W ?ABM,"  ----------"
 ..W ?123,"------",!?27,"Subtotal:",?40,$J($FN(ABM("CN"),",",0),7)
 ..F ABM="51^B","65^PD","79^DD","93^WO","107^OB" W ?+ABM,$J($FN(ABM("M"_$P(ABM,U,2)),",",2),12)
 ..W ?124,$J($J($S(ABM("MB"):(ABM("MPD")/ABM("MB")*100),1:0),".",1),5)
 .W !?40,"-------" F ABM=51,65,79,93,107 W ?ABM,"  ----------"
 .W ?123,"------",!?30,"Total:",?40,$J($FN(ABM("SN"),",",0),7)
 .F ABM="51^B","65^PD","79^DD","93^WO","107^OB" W ?+ABM,$J($FN(ABM("S"_$P(ABM,U,2)),",",2),12)
 .W ?124,$J($J($S(ABM("SB"):(ABM("SPD")/ABM("SB")*100),1:0),".",1),5)
 I ABM("TN")'=+$G(ABM("SN")) D
 .W !?40,"=======" F ABM=51,65,79,93,107 W ?ABM," ==========="
 .W ?123,"======",!?24,"Grand Total:",?40,$J($FN(ABM("TN"),",",0),7)
 .F ABM="51^B","65^PD","79^DD","93^WO","107^OB" W ?+ABM,$J($FN(ABM("T"_$P(ABM,U,2)),",",2),12)
 .W ?124,$J($J($S(ABM("TB"):(ABM("TPD")/ABM("TB")*100),1:0),".",1),5)
 G XIT
 ;
HD D PAZ^ABMDRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S DUOUT="" Q
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !?41,"Bill",?55,"Amount",?69,"Amount",?81,"Deductible",?95,"Write Off-",?110,"Residual",?121,"Collection"
 W !?10,"Insurer",?33,"HRN",?40,"Number",?55,"Billed",?70,"Paid",?81,"and Co-Ins",?95,"Adjustment",?110,"Balance",?121,"Percentage"
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
WLOC W !!?3,"Visit Location: ",ABM("L")
 Q
 ;
WSRT I ABMY("SORT")="V" W !?7,"Visit Type: ",$E($P(^ABMDVTYP(ABM("V"),0),U),1,18)
 I ABMY("SORT")="C" W !?11,"Clinic: ",$E($P(^DIC(40.7,ABM("V"),0),U),1,18)
 Q
 ;
XIT K ^TMP(ABM("SUBR"),"ST",$J)
 Q
