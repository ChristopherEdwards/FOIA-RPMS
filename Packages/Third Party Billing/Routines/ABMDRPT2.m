ABMDRPT2 ; IHS/ASDST/DMJ - Bills Listing-part 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
PRINT ;EP for printing data
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"),ABM("PD"),ABM("PDT1"),ABM("PDT2"),ABM("PDT"))=0,(ABM("A"),ABM("L"),ABM("V"))=""
 S ABM("Z")="TMP(""ABM-PT"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-P",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2)
 .S ABM("C")=$G(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),0)) Q:ABM("C")=""  S ABM("T")=+^(2),ABM("D")=$P($G(^(1)),U,7) S:ABM("D")]"" ABM("D")=+$G(^ABMDTXST(DUZ(2),ABM("D"),0))
 .I ABM("L")'=$P(ABM("TXT"),U) D SUB:ABM("L")]"",SUBHD S ABM("V")=""
 .S ABM("L")=$P(ABM("TXT"),U)
 .I ABM("V")'=$P(ABM("TXT"),U,2) D SUB2:ABM("V")]"" W:ABM("V")]"" ! W:$P(ABM("TXT"),U,2) !?7,$S(ABMY("SORT")="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,2),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,2),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,2)
 .D WRT
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))
 D SUB,TOT
 Q
 ;
WRT W ! W:ABM("I")'=$P(ABM("C"),U,8) $E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,28) S ABM("I")=$P(ABM("C"),U,8)
 W ?30,$P(ABM("C"),U)
 W ?38,$E($P(^DPT($P(ABM("C"),U,5),0),U),1,18)
 W ?58,$S($D(^AUPNPAT($P(ABM("C"),U,5),41,$P(ABM("C"),U,3),0)):$P(^(0),U,2),$D(^AUPNPAT($P(ABM("C"),U,5),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 W:+$G(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),7)) ?65,$$SDT^ABMDUTL(+^(7))
 I ABMY("SORT")="V" W:+$P(ABM("C"),U,10) ?76,$E($P(^DIC(40.7,$P(ABM("C"),U,10),0),U),1,10)
 E  W ?76,$E($P(^ABMDVTYP($P(ABM("C"),U,7),0),U),1,10)
 W ?87,$$SDT^ABMDUTL(ABM("D"))
 W ?98,$J($FN(ABM("T"),",",2),10)
 S ABM("PD")=0 F ABM(0)=1:1 S ABM("PD")=$O(^ABMDBILL(DUZ(2),+$P(ABM("TXT"),U,5),3,ABM("PD"))) Q:'ABM("PD")  S ABM("PDD")=$P(^(ABM("PD"),0),U),ABM("PD0")=$P(^(0),U,2) D
 .I $G(ABMY("DT"))="P",ABM("PDD")<ABMY("DT",1)!(ABM("PDD")>ABMY("DT",2)) S ABM(0)=ABM(0)-1 Q
 .W:ABM(0)>1 !
 .W ?110,$$SDT^ABMDUTL(ABM("PDD"))
 .W ?121,$J($FN(ABM("PD0"),",",2),10)
 .S ABM("PDT1")=ABM("PDT1")+ABM("PD0"),ABM("PDT2")=ABM("PDT2")+ABM("PD0"),ABM("PDT")=ABM("PDT")+ABM("PD0")
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)",!
 S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 Q
 ;
TOT Q:ABM("CNT")=0
 W !?30,"======",?98,"==========",?121,"==========",!?3,"GRAND TOTAL:",?30,ABM("CNT"),?98,$J($FN(ABM("TOT"),",",2),10),?121,$J($FN(ABM("PDT"),",",2),10)
 S ABM("TOT")=0,ABM("PDT")=0
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !,?30,"Claim",?67,"Visit",?89,"Export",?101,"Billed",?112,"Date",?125,"Paid"
 W !?10,"Insurer",?30,"Number",?43,"Patient",?59,"HRN",?67,"Date",?77,$S(ABMY("SORT")="V":"Clinic",1:"Visit Type"),?90,"Date",?101,"Amount",?112,"Paid",?124,"Amount"
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
SUBHD W:ABM("L")'="" ! W !?3,"Visit Location: ",$P(^DIC(4,$P(ABM("C"),U,3),0),U)
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?30,"------",?98,"----------",?121,"----------"
 W !?5,"Sub-total:",?30,ABM("CNT2"),?98,$J($FN(ABM("TOT2"),",",2),10),?121,$J($FN(ABM("PDT2"),",",2),10)
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")="",ABM("PDT2")=0
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?30,"------",?98,"----------",?121,"----------"
 W !?9,"Total:",?30,ABM("CNT1"),?98,$J($FN(ABM("TOT1"),",",2),10),?121,$J($FN(ABM("PDT1"),",",2),10)
 S (ABM("CNT1"),ABM("TOT1"),ABM("CNT2"),ABM("TOT2"),ABM("PDT1"),ABM("PDT2"))=0,ABM("I")=""
 Q
