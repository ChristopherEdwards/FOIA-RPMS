ABMDRST1 ; IHS/ASDST/DMJ - Statistical Report - Part 3 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/ASDS/LSL - 03/19/2001 - V2.4 Patch 9 - NOIS XXX-0301-200059
 ;     Modified code to accomodate deleted visit type 141.
 ;     "DELETED 141" will appear in this instance.
 ;
 ; *********************************************************************
 ;
PRINT ;EP for writing data
 S ABM("PG")=0
 D HDB S ABM("L")="" F ABM("NL")=1:1 S ABM("L")=$O(ABM(ABM("L"))) Q:'ABM("L")  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-7) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .W !!,$P(^DIC(4,ABM("L"),0),U)
 .S (ABM("N"),ABM("B"),ABM("P"))=0
 .S ABM("V")="" F  S ABM("V")=$O(ABM(ABM("L"),ABM("V"))) Q:'ABM("V")  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..I $Y>(IOSL-6) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !,$P(^DIC(4,ABM("L"),0),U)," (cont)"
 ..;Nest line prints visit type
 ..W !?3
 ..I ABMY("SORT")="V" D
 ...I $P($G(^ABMDVTYP(ABM("V"),0)),U)]"" W $E($P(^ABMDVTYP(ABM("V"),0),U),1,15) Q
 ...W "DELETED ",ABM("V")
 ..E  W $E($P(^DIC(40.7,ABM("V"),0),U),1,15)
 ..W ?22,$J($FN($P(ABM(ABM("L"),ABM("V")),U),",",0),5),?30,$J($FN($P(ABM(ABM("L"),ABM("V")),U,2),",",0),5)
 ..;Next line writes $ with comma and cents
 ..W ?37,$J($FN($P(ABM(ABM("L"),ABM("V")),U,3),",",2),13)
 ..W ?50,$J($FN($P(ABM(ABM("L"),ABM("V")),U,4),",",2),13)
 ..W ?66,$J($FN(($P(ABM(ABM("L"),ABM("V")),U,3)-$P(ABM(ABM("L"),ABM("V")),U,4)),",",2),13)
 ..S ABM("N")=$P(ABM(ABM("L"),ABM("V")),U,1)+ABM("N"),ABM("NLN")=ABM("NLN")+$P(ABM(ABM("L"),ABM("V")),U,1)
 ..S ABM("B")=$P(ABM(ABM("L"),ABM("V")),U,3)+ABM("B"),ABM("NLB")=ABM("NLB")+$P(ABM(ABM("L"),ABM("V")),U,3)
 ..S ABM("P")=$P(ABM(ABM("L"),ABM("V")),U,4)+ABM("P"),ABM("NLP")=ABM("NLP")+$P(ABM(ABM("L"),ABM("V")),U,4)
 .W !,?22,"------",?30,"------",?40,"----------",?53,"----------",?69,"----------"
 .W !?22,$J($FN(ABM("N"),",",0),5)
 .W ?30,$J($FN(ABM("LC",ABM("L")),",",0),5)
 .W ?37,$J($FN(ABM("B"),",",2),13)
 .W ?50,$J($FN(ABM("P"),",",2),13)
 .W ?66,$J($FN(ABM("B")-ABM("P"),",",2),13)
 .;PRINT INPATIENT DAYS - WILL PRINT 0 DAYS ALSO         
 .W !!
 .W "TOTAL COVERED INPATIENT DAYS  ",+$GET(ABM(ABM("L"),"COVD"))
 .W !
 I ABM("NL")<3 G XIT
 W !,?22,"======",?30,"======",?40,"==========",?53,"==========",?69,"=========="
 ;TOOK OUT TOTAL UNDUP CNT 2/98 SL
 W !?10,"Total:",?22,$J($FN(ABM("NLN"),",",0),5)
 W ?37,$J($FN(ABM("NLB"),",",2),13)
 W ?50,$J($FN(ABM("NLP"),",",2),13)
 W ?66,$J($FN(ABM("NLB")-ABM("NLP"),",",2),13)
 G XIT
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !!?3,$S(ABMY("SORT")="V":"VISIT",1:""),?22,"NUMBER",?32,"UNDUP",?44,"BILLED",?58,"PAID",?72,"UNPAID"
 W !?3,$S(ABMY("SORT")="V":"TYPE",1:"CLINIC"),?22,"VISITS",?32,"PATIENTS",?44,"AMOUNT",?57,"AMOUNT",?72,"AMOUNT"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
XIT K ^TMP($J,"ABM-ST")
 Q
