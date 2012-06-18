ABMDRUN2 ; IHS/ASDST/DMJ - Unpaid Bills Listing-132 width ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/ASDS/SDH - 09/26/01 - V2.4 Patch 9 - NOIS NCA-0901-180041
 ;     Modified to correct <UNDEF>WRT+1^ABMDRUN2
 ;
 ; IHS/SD/SDR - 10/10/02 - V2.5 P2 - UXX-0801-170114
 ;      Modified to correct <SBSCR>SUBHD^ABMDRUN2
 ;
 ; *********************************************************************
 ;
PRINT ;EP for printing data
 S ABM("PRIVACY")=1
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0,(ABM("A"),ABM("L"),ABM("V"))=""
 S ABM("Z")="TMP(""ABM-AL"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-A",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2,99)
 .S ABM("C")=$G(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),0)) Q:ABM("C")=""  S ABM("T")=+^(2),ABM("D")=$P($G(^(1)),U,7) S:ABM("D")]"" ABM("D")=+$G(^ABMDTXST(DUZ(2),ABM("D"),0))
 .I ABM("L")'=$P(ABM("TXT"),U) D SUB:ABM("L")]"",SUBHD S ABM("V")=""
 .S ABM("L")=$P(ABM("TXT"),U)
 .I ABM("V")'=$P(ABM("TXT"),U,2) D SUB2:ABM("V")]"" W:ABM("V")]"" ! W:$P(ABM("TXT"),U,2) !?7,$S(ABMY("SORT")="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,2),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,2),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,2)
 .D WRT
 D SUB,TOT
 Q
 ;
WRT W ! W:ABM("I")'=$P(ABM("C"),U,8) $E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,30) S ABM("I")=$P(ABM("C"),U,8)
 W ?32,$P(ABM("C"),U),?40,$E($P(^DPT(+$P(ABM("C"),U,5),0),U),1,30),?72,$S($D(^AUPNPAT($P(ABM("C"),U,5),41,$P(ABM("C"),U,3),0)):$P(^(0),U,2),$D(^AUPNPAT($P(ABM("C"),U,5),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 W:+$G(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),7)) ?80,$$SDT^ABMDUTL(+^(7))
 I ABMY("SORT")="V" W:+$P(ABM("C"),U,10) ?92,$E($P(^DIC(40.7,$P(ABM("C"),U,10),0),U),1,16)
 E  W ?92,$E($P(^ABMDVTYP($P(ABM("C"),U,7),0),U),1,16)
 W:ABM("D")]"" ?110,$$SDT^ABMDUTL(ABM("D"))
 W ?121,$J($FN(ABM("T"),",",2),10)
 S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 Q
 ;
TOT Q:ABM("CNT")=0
 W !?32,"======",?121,"==========",!?3,"GRAND TOTAL:",?32,ABM("CNT"),?121,$J($FN(ABM("TOT"),",",2),10)
 S ABM("TOT")=0
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !,?32,"Claim",?81,"Visit",?113,"Export",?123,"Billed"
 W !?10,"Insurer",?32,"Number",?47,"Patient",?73,"HRN",?81,"Date",?94,$S(ABMY("SORT")="V":"Clinic",1:"Visit Type"),?114,"Date",?123,"Amount"
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
SUBHD ;
 I $G(ABM("L"))'="" W !!?3,"Visit Location: ",$P(^DIC(4,$P(ABM("C"),U,3),0),U)
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?32,"------",?121,"----------"
 W !?5,"Sub-total:",?32,ABM("CNT2"),?121,$J($FN(ABM("TOT2"),",",2),10)
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?32,"------",?121,"----------"
 W !?9,"Total:",?32,ABM("CNT1"),?121,$J($FN(ABM("TOT1"),",",2),10)
 S (ABM("CNT1"),ABM("TOT1"),ABM("CNT2"),ABM("TOT2"))=0,ABM("I")=""
 Q
