ABMDRPX1 ; IHS/ASDST/DMJ - Billed CPT List ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Original;TMD;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4716 - Allowed room for NDC
 ;
PRINT ;EP for printing data
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S ABM="" F  S ABM=$O(^TMP("ABM-PX",$J,ABM)) Q:ABM=""  S ABM("T")=^(ABM) D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .D WRT
 I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) K ^TMP("ABM-PX",$J,"CL") Q
 S ABM("T")=$G(^TMP("ABM-PX",$J))
 W !?50,"+=======+=============+"
 W !?43,"Total:",?52,$J($FN($P(ABM("T"),U),",",0),5),?60,$J($FN($P(ABM("T"),U,2),",",2),11)
 W !?50,"+=======+=============+"
 K ^TMP("ABM-PX",$J,"CL") Q
 ;
WRT ;W !?1,$S(ABM="ZZZZZ":"",1:ABM),?9,$P(ABM("T"),U,3)  ;abm*2.6*1 HEAT4716
 I ABM["-" W !?1,ABM,?20,$P(ABM("T"),U,3)  ;abm*2.6*1 HEAT4716
 I ABM'["-" W !?1,$S(ABM="ZZZZZ":"",1:ABM),?9,$P(ABM("T"),U,3)  ;abm*2.6*1 HEAT4716
 W ?52,$J($FN($P(ABM("T"),U),",",0),5),?60,$J($FN($P(ABM("T"),U,2),",",2),11)
 W ?74,$J($J(100*$P(ABM("T"),U,2)\$P(^TMP("ABM-PX",$J),U,2),".",1),4),"%"
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?63,"Amount"
 ;start old code abm*2.6*1 HEAT4716
 ;W !?1,"Code",?17,"Procedure Description",?52,"Count",?63,"Billed",?73,"Percent"
 ;W !,"-------+------------------------------------------+-------+-------------+-------"
 ;end old code start new code HEAT4716
 I $G(ABM("SUB"))=23 D
 .W !?1,"Code",?20,"Procedure Description",?52,"Count",?63,"Billed",?73,"Percent"
 .W !,"-----------------+--------------------------------+-------+-------------+-------"
 I $G(ABM("SUB"))'=23 D
 .W !?1,"Code",?17,"Procedure Description",?52,"Count",?63,"Billed",?73,"Percent"
 .W !,"-------+------------------------------------------+-------+-------------+-------"
 ;end new code HEAT4716
 Q
