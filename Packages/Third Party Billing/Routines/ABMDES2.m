ABMDES2 ; IHS/ASDST/DMJ - Display Summarized HCFA-1500 charges ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
HCFA ;EP for displaying charge summary for HCFA-1500
 ;
 I $Y+5>IOSL S DIR(0)="E" D ^DIR W $$EN^ABMVDF("IOF") Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 D HD
 S ABMS="" F  S ABMS=$O(ABMS(ABMS)) Q:'ABMS  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) S DIR(0)="EO" D ^DIR W $$EN^ABMVDF("IOF") Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 .W !,$P(ABMS(ABMS),U,2),?15,$S(ABMP("BTYP")=111:1,1:3),?20,$P(ABMS(ABMS),U,4)
 .K ABMU
 .I $L($P(ABMS(ABMS),U,8))>19 S ABMU("LNG")=19,ABMU("TXT")=$P(ABMS(ABMS),U,8),ABMU=2 D LNG^ABMDWRAP W ?29,ABMU(1) I 1
 .E  W ?29,$P(ABMS(ABMS),U,8)
 .W ?52,$P(ABMS(ABMS),U,5),?60,$J($FN($P(ABMS(ABMS),U),",",2),8),?72,$P(ABMS(ABMS),U,6),?77,$P(ABMS(ABMS),U,7),!
 .W:$P(ABMS(ABMS),U,3)'=$P(ABMS(ABMS),U,2) ?4,$P(ABMS(ABMS),U,3) I $D(ABMU(2)) W ?29,ABMU(2)
 .K ABMS(ABMS)
 W !?59,"---------",!?59,$J($FN(ABMS("TOT"),",",2),9)
 S ABMP("TOT")=ABMP("TOT")+ABMS("TOT")
 Q
 ;
 I $D(ABMP("VTYP",999)) D
 .S ABMP("RATIO")=1/(ABMP("HCFA")+ABMP("UB82"))
 .I $D(ABM("DD-FRT")) S ABMP("UB82")=ABMP("RESP"),ABMP("HCFA")=0 Q
 .S ABMP("UB82")=+$FN(ABMP("RESP")*ABMP("UB82")*ABMP("RATIO"),"T",2),ABMP("HCFA")=+$FN(ABMP("RESP")*ABMP("HCFA")*ABMP("RATIO"),"T",2)
 I '$D(ABMP("VTYP",999)) S ABMP("HCFA")=ABMP("RESP")
 Q
 ;
HD W ?20,"***** HCFA-1500A CHARGE SUMMARY *****"
 W !,"   Dates of    Vst",?21,$S(ABMP("VTYP")=998:"ADA",$G(ABMP("PX"))="I":"ICD",1:"CPT"),?32,"Description        Corr"
 W !,"   Service     Typ   Code       of Service           ICD      Charge   Qty  Cat"
 S ABMS("I")="",$P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
