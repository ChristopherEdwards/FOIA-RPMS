ABMDRTX1 ; IHS/ASDST/DMJ - Print Transmittal Report ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/25/96 11:29 AM
 ;
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ;
 Q:$D(DUOUT)!$D(DTOUT)
 G:$D(IO("Q")) QUE
 I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
 ;
PRQUE ;EP - Entry Point for Taskman
 K ^TMP("ABM-TX",$J)
 S ABM("HD",0)="TRANSMITTAL LIST "
 S ABM("HD")="(Export No: "
 S ABM("PG")=0
 S ABM=0
 F ABM("I")=1:1 S ABM=$O(ABM("DFN",ABM)) Q:'ABM  D
 .I ABM("I")=1 S ABM("HD")=ABM("HD")_ABM Q
 .S ABM("HD")=ABM("HD")_","_ABM
 S ABM("HD")=ABM("HD")_")"
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
 S ABM("V")=$P(ABMBILL0,U,7)
 S ABM("P")=$P(ABMBILL0,U,5)
 Q:ABM("L")=""!(ABM("V")="")!(ABM("P")="")
 S ^TMP("ABM-TX",$J,$P(^DIC(4,ABM("L"),0),U)_U_ABM("V")_U_$P(^DPT(ABM("P"),0),U)_U_ABM)=""
 Q
 ;
WRT ;
 S IOP=ABM("IOP")
 D ^%ZIS
 Q:$G(POP)
 U IO
 D HD
 S (ABM("TOT"),ABM("CNT"),ABM("SUBTOT"),ABM("SUBCNT"))=0
 S (ABM("L"),ABM("V"))=""
 S ABM("A")="^TMP(""ABM-TX"","_$J
 S ABM=ABM("A")_")"
 I '$D(@ABM) G XIT
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")_","  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-7),$E(IOST)="C",'$D(IO("S")) K DIR S DIR(0)="E" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D HD,LOC W " (cont)"
 .I $Y>(IOSL-6) D HD,LOC W " (cont)"
 .S ABM("T")=$P($P(ABM,",",3,99),"""",2)
 .I ABM("L")'=$P(ABM("T"),U) D SUB,LOC
 .S ABM("L")=$P(ABM("T"),U)
 .I ABM("V")'=$P(ABM("T"),U,2) D SUB W !,$P(^ABMDVTYP($P(ABM("T"),U,2),0),U)
 .S ABM("V")=$P(ABM("T"),U,2)
 .Q:'$D(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0))
 .W !?5,$E($P(ABM("T"),U,3),1,27),?34,$P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U)_$S($P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),0),U,4)="X":"*",1:""),?43,$E($P(^AUTNINS($P(^(0),U,8),0),U),1,26)
 .W ?70,$J($FN($P(^ABMDBILL(DUZ(2),$P(ABM("T"),U,4),2),U),",",2),10) S ABM("TOT")=ABM("TOT")+$P(^(2),U),ABM("SUBTOT")=ABM("SUBTOT")+$P(^(2),U)
 .S ABM("CNT")=ABM("CNT")+1
 .S ABM("SUBCNT")=ABM("SUBCNT")+1
 D SUB
 W !?34,"======",?70,"=========="
 W !?10,"Total:",?34,$J($FN(ABM("CNT"),",",0),5),?68,$J($FN(ABM("TOT"),",",2),12)
 W $$EN^ABMVDF("IOF")
 G XIT
 ;
HD ;
 I 'ABM("PG") D
 .I $L(ABM("HD"))<35 S ABM("HD",0)=ABM("HD",0)_ABM("HD") Q
 .S ABM("HD",1)=ABM("HD")
 S ABM("PG")=ABM("PG")+1
 D WHD^ABMDRHD
 W !?5,"""*"" following the bill number denotes a bill that has been cancelled"
 W !?35,"BILL",?75,"BILL"
 W !?11,"PATIENT",?34,"NUMBER",?46,"ACTIVE INSURER",?73,"AMOUNT"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
LOC ;
 W !!?15,"Visit Location: ",$P(ABM("T"),U)
 Q
 ;
SUB ;
 Q:'ABM("SUBTOT")
 W !?34,"------",?70,"----------"
 W !?17,"Subtotal:",?34,$J($FN(ABM("SUBCNT"),",",0),5),?68,$J($FN(ABM("SUBTOT"),",",2),12),!
 S ABM("SUBCNT")=0
 S ABM("SUBTOT")=0
 Q
 ;
XIT ;
 D POUT^ABMDRUTL,^%ZISC
 K ^TMP("ABM-TX",$J)
 Q
 ;
QUE ;
 S ZTRTN="PRQUE^ABMDRTX1"
 S ZTDESC="3P TRANSMITTAL REPORT"
 D QUE^ABMDRUTL
 G XIT
