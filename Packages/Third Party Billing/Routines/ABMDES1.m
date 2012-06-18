ABMDES1 ; IHS/ASDST/DMJ - Display Summarized UB-82/92 Info ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16660
 ;    4-digit revenue codes
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20227
 ;   Changed hardset of 001 rev code to 0001
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21581
 ;   Added line to print active insurer in summary
 ;
UB82 ;EP for printing UB-82/92 charge summary
 ;
 D HD
 S ABMS="" F ABMS("I")=0:1 S ABMS=$O(ABMS(ABMS)) Q:'ABMS  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-7) S DIR(0)="EO" D ^DIR Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 .W !,$S($P($G(ABMP("FLAT")),U,6)]"":$P(ABMP("FLAT"),U,6),1:$P($G(^AUTTREVN(ABMS,0)),U,2)),?29,"|"
 .W $S($D(ABMS("CPT")):$P(ABMS("CPT",1),U,2),$P($G(ABMP("FLAT")),U,7)]"":$P(ABMP("FLAT"),U,7),$P(ABMS(ABMS),U,3)]"":$J($P(ABMS(ABMS),U,3),7,2),1:"")
 .W ?43,$$GETREV^ABMDUTL(ABMS),?51,$J($P(ABMS(ABMS),U,2),3),?58,$J($FN($P(ABMS(ABMS),U),",",2),9)
 .I $D(ABMP("FLAT")),'ABMS("I") W ?70,$J($FN($P(ABMS(ABMS),U,5),",",2),9)
 I $D(ABMS("CPT")) S ABMS=1 F  S ABMS=$O(ABMS("CPT",ABMS)) Q:ABMS=""  W !,$P(ABMS("CPT",ABMS),U),?29,"|",$P(ABMS("CPT",ABMS),U,2),?43,$P(ABMS("CPT",ABMS),U,3),?51,$J($P(ABMS("CPT",ABMS),U,4),3),?58,$J($FN($P(ABMS("CPT",ABMS),U,5),",",2),9)
 W !?58,"---------"
TOT ;
 W !?10,"TOTAL CHARGE",?43,"0001",?58,$J($FN(ABMS("TOT"),",",2),9)
 S ABMP("TOT")=ABMP("TOT")+ABMS("TOT")
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
 D PREV^ABMDFUTL
 I $D(ABMP("FLAT")) S ABMP("RESP")=ABMP("RESP")-$P(ABMS($P(ABMP("FLAT"),U,2)),U,5) W !?39,"Non-Covd Charges:",?57,$J("("_$FN($P(ABMS($P(ABMP("FLAT"),U,2)),U,5),",",2),10),")"
 S:ABMP("RESP")<1 ABMP("RESP")=0
 I ABMP("PD")!ABMP("WO") D
 .W !?38,"Previous Payments:",?57,$J("("_$FN(ABMP("PD"),",",2),10),")"
 .W:ABMP("WO") !?39,"Write-off Amount:",?57,$J("("_$FN(ABMP("WO"),",",2),10),")"
 .W !?58,"---------",!,?37,"Est. Responsibility:",?58,$J(($FN(ABMP("RESP"),",",2)),9)
 Q
 ;
HD ;HEADER
 W $$EN^ABMVDF("IOF")
 S ABMP("FORM")=$P(^ABMDEXP(ABMP("EXP"),0),U)
 S ABMP("HEADER")="***** "_ABMP("FORM")_" CHARGE SUMMARY *****"
 W !?22,ABMP("HEADER")
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 W !?42,"Revn",?60,"Total" I $D(ABMP("FLAT")) W ?71,"Non-cvd"
 W !?10,"  Description",?42,"Code",?50,"Units",?59,"Charges" I $D(ABMP("FLAT")) W ?71,"Charges"
 S ABMS("I")="",$P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
