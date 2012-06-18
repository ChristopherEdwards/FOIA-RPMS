ABMDRPR1 ; IHS/ASDST/DMJ - Productivity Report-80 Width ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
PRINT ;EP for printing data
 S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0,(ABM("A"),ABM("L"),ABM("V"))=""
 S ABM("Z")="TMP(""ABM-PR"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-P",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2),ABM("TXT")=+$P(ABM("T"),",",3)_U_ABM("TXT")
 .S ABM("C")=$G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,6),0)) Q:ABM("C")=""  S ABM("D")=+^(7),ABM("T")=+^(2)
 .I ABM("A")'=$P(ABM("TXT"),U) S ABM("L")="" D SUB,TOT,SUBHD
 .S ABM("A")=$P(ABM("TXT"),U)
 .I ABM("L")'=$P(ABM("TXT"),U,2) D SUB:ABM("L")]"" W:ABM("L")'="" ! W !?3,"Visit Location: ",$P(^DIC(4,$P(ABM("C"),U,3),0),U) S ABM("V")=""
 .S ABM("L")=$P(ABM("TXT"),U,2)
 .I ABM("V")'=$P(ABM("TXT"),U,3) D SUB2:ABM("V")]"" W:ABM("V")]"" ! W !?7,$S(ABMY("SORT")="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,3),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,3),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,3)
 .W ! W:ABM("I")'=$P(ABM("C"),U,8) $E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,25) S ABM("I")=$P(ABM("C"),U,8)
 .W ?27,$P(ABM("C"),U),?35,$E($P(^DPT($P(ABM("C"),U,5),0),U),1,16)
 .W ?52,$S($D(^AUPNPAT($P(ABM("C"),U,5),41,$P(ABM("C"),U,3),0)):$P(^(0),U,2),$D(^AUPNPAT($P(ABM("C"),U,5),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 .W ?59,$$SDT^ABMDUTL(ABM("D"))
 .W ?70,$J($FN(ABM("T"),",",2),9)
 .S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 .S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 D SUB,TOT
 Q
TOT Q:ABM("CNT")=0  W !?27,"======",?69,"=========="
 W !?13,"GRAND COUNT:",?27,ABM("CNT"),?56,"GRAND TOTAL:",?69,$J($FN(ABM("TOT"),",",2),10)
 S ABM("TOT")=0,ABM("CNT")=0
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?27,"Claim",?61,"Visit",?71,"Billed"
 W !?5,"Insurer",?27,"Number",?38,"Patient",?53,"HRN",?61,"Date",?71,"Amount"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
SUBHD Q:$D(ABMY("APPR"))  W !!,"Approving Official: ",$P(^VA(200,$P(ABM("TXT"),U),0),U)
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?27,"------",?69,"----------"
 W !?16,"Subcount:",?27,ABM("CNT2"),?59,"Subtotal:",?69,$J($FN(ABM("TOT2"),",",2),10)
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?27,"------",?69,"----------"
 W !?19,"Count:",?27,ABM("CNT1"),?62,"Total:",?69,$J($FN(ABM("TOT1"),",",2),10)
 S ABM("CNT1")=0,ABM("TOT1")=0,ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
XIT ;EXIT POINT
 Q
