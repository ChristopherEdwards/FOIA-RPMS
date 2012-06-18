ABMDRAG1 ; IHS/ASDST/DMJ - Aged A/R Reports ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;01/19/96 1:02 PM
 ;
PRINT ;EP for printing data
 U IO W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S ABM="" F  S ABM=$O(^TMP("ABM-AG",$J,ABM)) Q:ABM=""  S ABM("T")=^(ABM) D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .Q:ABM("T")=""
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .D WRT
 S ABM("T")=$G(^TMP("ABM-AG",$J))
 W !,"                             +------+----------+-----------+-----------+-----------+-----------+-----------+-----------+==========="
 W !,"Total Accounts Receivable:",?30,$J($FN($P(ABM("T"),U),",",0),5),$J($FN($P(ABM("T"),U,2),",",2),11) F ABM("I")=3:1:9 W " |",$J($FN($P(ABM("T"),U,ABM("I")),",",2),10)
 W !?47,"+-----------+-----------+-----------+-----------+-----------+-----------+===========",!
 F ABM("I")=3:1:8 W ?((12*ABM("I"))+16),$J($S($P(ABM("T"),U,9)>0:(100*$P(ABM("T"),U,ABM("I")))\$P(ABM("T"),U,9),1:0),2),"%"
 Q
 ;
WRT W !,$E(ABM,1,28)
 W ?30,$J($FN($P(ABM("T"),U),",",0),5),$J($FN($P(ABM("T"),U,2),",",2),11) F ABM("I")=3:1:9 W " |",$J($FN($P(ABM("T"),U,ABM("I")),",",2),10)
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !!,?70,"AGING WITHOUT DISTRIBUTION OF CREDITS"
 W !?10,"Insurer",?31,"Bills",?39,"Credits |   0-30    |   31-60   |   61-90   |  91-120   |  Over 120 | Total Aged|   Total"
 W !,"-----------------------------+------+----------+-----------+-----------+-----------+-----------+-----------+-----------+==========="
 Q
