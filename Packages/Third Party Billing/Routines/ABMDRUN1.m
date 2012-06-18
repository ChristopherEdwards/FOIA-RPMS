ABMDRUN1 ; IHS/ASDST/DMJ - Unpaid Bills Listing-80 width ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
PRINT ;EP for printing data
 S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"),ABM("PD"),ABM("PDT1"),ABM("PDT2"),ABM("PDT"))=0,(ABM("A"),ABM("L"),ABM("V"))=""
 S ABM("Z")="TMP(""ABM-AL"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-A",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2,99)
 .S ABM("C")=$G(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),0)) Q:ABM("C")=""  S ABM("T")=+^(2),ABM("D")=$P($G(^(1)),U,7) S:ABM("D")]"" ABM("D")=+$G(^ABMDTXST(DUZ(2),ABM("D"),0))
 .I ABM("L")'=$P(ABM("TXT"),U) D SUB:ABM("L")]"" W:ABM("L")'="" ! W !?3,"Visit Location: ",$P(^DIC(4,$P(ABM("C"),U,3),0),U) S ABM("V")=""
 .S ABM("L")=$P(ABM("TXT"),U)
 .I ABM("V")'=$P(ABM("TXT"),U,2) D SUB2:ABM("V")]"" W:ABM("V")]"" ! W !?7,$S($G(ABMY("SORT"))="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,2),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,2),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,2)
 .W ! W:ABM("I")'=$P(ABM("C"),U,8) $E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,23) S ABM("I")=$P(ABM("C"),U,8)
 .W ?25,$P(ABM("C"),U)
 .W ?33,$E($P(^DPT($P(ABM("C"),U,5),0),U),1,18)
 .W ?52,$S($D(^AUPNPAT($P(ABM("C"),U,5),41,$P(ABM("C"),U,3),0)):$P(^(0),U,2),$D(^AUPNPAT($P(ABM("C"),U,5),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 .W:ABM("D")]"" ?59,$$SDT^ABMDUTL(ABM("D"))
 .W ?69,$J($FN(ABM("T"),",",2),10)
 .S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 .S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 D SUB,TOT
 Q
 ;
TOT Q:ABM("CNT")=0  W !?25,"======",?69,"=========="
 W !?3,"GRAND TOTAL:",?27,ABM("CNT"),?69,$J($FN(ABM("TOT"),",",2),10)
 S ABM("TOT")=0,ABM("PDT")=0
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !,?25,"Claim",?60,"Export",?71,"Billed"
 W !?5,"Insurer",?25,"Number",?38,"Patient",?53,"HRN",?61,"Date",?71,"Amount"
 W !,"==============================================================================="
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?25,"------",?69,"----------"
 W !?5,"Sub-total:",?27,ABM("CNT2"),?69,$J($FN(ABM("TOT2"),",",2),10)
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?25,"------",?69,"----------"
 W !?9,"Total:",?25,ABM("CNT1"),?69,$J($FN(ABM("TOT1"),",",2),10)
 S (ABM("CNT1"),ABM("TOT1"),ABM("CNT2"),ABM("TOT2"))=0,ABM("I")=""
 Q
