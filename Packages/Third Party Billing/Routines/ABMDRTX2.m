ABMDRTX2 ; IHS/ASDST/DMJ - Transmittal Report by Insurer ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/25/96 11:32 AM
 ;
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ;
 G:$D(IO("Q")) QUE
 I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
PRQUE ;EP - Entry Point for Taskman
 K ^TMP("ABM-TX2",$J)
 S ABM("DFN")=0
 F  S ABM("DFN")=$O(ABM("DFN",ABM("DFN"))) Q:'ABM("DFN")  D
 .S ABM=""
 .F  S ABM=$O(^ABMDBILL(DUZ(2),"AX",ABM("DFN"),ABM)) Q:'ABM  D DATA
 G WRT
 ;
DATA ;
 Q:'$D(^ABMDBILL(DUZ(2),ABM,0))
 S ABMBILL0=$G(^ABMDBILL(DUZ(2),ABM,0))
 S ABM("L")=$P(ABMBILL0,U,3)
 S ABM("I")=$P(ABMBILL0,U,8)
 S ABM("P")=$P(ABMBILL0,U,5)
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")
 S ^TMP("ABM-TX2",$J,$P(^AUTNINS(ABM("I"),0),U)_U_$P(^DPT(ABM("P"),0),U)_U_$P(^DIC(4,ABM("L"),0),U)_U_ABM)=""
 Q
 ;
WRT ;
 S IOP=ABM("IOP")
 D ^%ZIS
 Q:$G(POP)
 U IO
 W $$EN^ABMVDF("IOF")
 S ABM("PG")=0
 S (ABM("TOT"),ABM("CNT"),ABM("SUBTOT"),ABM("SUBCNT"))=0
 S (ABM("L"),ABM("I"))=""
 S ABM("A")="TMP(""ABM-TX2"","_$J
 S ABM="^"_ABM("A")_")"
 I '$D(@ABM) G XIT
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")_","  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-7),$E(IOST)="C",'$D(IO("S")) K DIR S DIR(0)="E" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D HD W " (cont)"
 .I $Y>(IOSL-6) D HD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-T",2),ABM("T")=$P($P(ABM("T"),",",3,99),"""",2)
 .I ABM("I")'=$P(ABM("T"),U) D SUB,PAZ:ABM("I")]"" Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D INS,HD
 .S ABM("I")=$P(ABM("T"),U) W !
 .I ABM("P")'=$P(ABM("T"),U,2) W $E($P(ABM("T"),U,2),1,27)
 .S ABM("P")=$P(ABM("T"),U,2)
 .W ?29,$P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U)_$S($P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U,4)="X":"*",1:"") W:+$G(^(7)) ?37,$$SDT^ABMDUTL(+^(7))
 .W ?48,$E($P(^DIC(4,$P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U,3),0),U),1,20)
 .W ?69,$J($FN($P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),2),U),",",2),10) S ABM("TOT")=ABM("TOT")+$P(^(2),U),ABM("SUBTOT")=ABM("SUBTOT")+$P(^(2),U)
 .S ABM("CNT")=ABM("CNT")+1
 .S ABM("SUBCNT")=ABM("SUBCNT")+1
 D SUB,PAZ,HD
 W !?29,"------",?69,"----------"
 W !?10,"Total:",?29,$FN(ABM("CNT"),",",0),?68,$J($FN(ABM("TOT"),",",2),11)
 W $$EN^ABMVDF("IOF")
 G XIT
 ;
HD ;
 S ABM("PG")=ABM("PG")+1
 S ABM("RTYP")=1
 S ABM("HD",0)="TRANSMITTAL LIST for "_$P(^AUTNINS($P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U,8),0),U)
 D WHD^ABMDRHD
 W !?5,"""*"" following the bill number denotes a bill that has been cancelled"
 W !?30,"Bill",?38,"Visit",?50,"Visit",?72,"Bill"
 W !?5,"Patient",?29,"Number",?38,"Date",?49,"Location",?71,"Amount"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
PAZ ;
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) K DIR S DIR(0)="E" D ^DIR K DIR
 Q
 ;
INS ;
 S ABM("PG")=0
 Q
 ;
SUB ;
 Q:'ABM("SUBTOT")
 W !?29,"------",?69,"----------"
 W !?7,"Subtotal:",?29,$FN(ABM("SUBCNT"),",",0),?68,$J($FN(ABM("SUBTOT"),",",2),11),!
 S ABM("SUBCNT")=0,ABM("SUBTOT")=0
 Q
 ;
XIT ;
 D POUT^ABMDRUTL,^%ZISC
 K ^TMP("ABM-TX2",$J)
 Q
 ;
QUE ;
 S ZTRTN="PRQUE^ABMDRTX2"
 S ZTDESC="3P TRANSMITTAL REPORT"
 D QUE^ABMDRUTL
 G XIT
