ABMDRAP1 ; IHS/ASDST/DMJ - Approved Bills Summary Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
COMPUTE ;EP - Entry Point for setting up data
 K ABMP("APP")
 S ABM=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),"AC","A",ABM)) Q:'ABM  D DATA
 Q
 ;
DATA S ABMP("HIT")=0 D ^ABMDRCHK Q:'ABMP("HIT")
 Q:"RA"'[$P(^ABMDBILL(DUZ(2),ABM,0),U,4)  S ABM("VAR")=$S(ABMP("VAR")=2:$P(^(0),U,8),1:$P(^(0),U,6)),ABM("DT")=$P($G(^(1)),U,5) Q:'ABM("VAR")!'ABM("DT")
 S:'$D(ABMP("APP",ABM("VAR"))) ABMP("APP",ABM("VAR"))=""
 S $P(ABMP("APP",ABM("VAR")),U)=$P(ABMP("APP",ABM("VAR")),U)+1
 S X2=ABM("DT"),X1=DT D ^%DTC
 S $P(ABMP("APP",ABM("VAR")),U,2)=$P(ABMP("APP",ABM("VAR")),U,2)+X
 S $P(ABMP("APP",ABM("VAR")),U,3)=$P(ABMP("APP",ABM("VAR")),U,3)+$G(^ABMDBILL(DUZ(2),ABM,2))
 Q
 ;
PRINT ;EP for printing data
 U IO S ABM("PG")=0
 S ABM("TOT")=0
 D HDB S ABM("F")="" F  S ABM("F")=$O(ABMP("APP",ABM("F"))) Q:'ABM("F")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-7) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S $P(ABM("TOT"),U)=$P(ABM("TOT"),U)+ABMP("APP",ABM("F"))
 .S $P(ABM("TOT"),U,2)=$P(ABM("TOT"),U,2)+$P(ABMP("APP",ABM("F")),U,3)
 .W !?3,$S(ABMP("VAR")=2:$P(^AUTNINS(ABM("F"),0),U),1:$P(^ABMDEXP(ABM("F"),0),U))
 .W ?35,$J($FN($P(ABMP("APP",ABM("F")),U),",",0),4)
 .W ?45,$J($FN($P(ABMP("APP",ABM("F")),U,2)\+ABMP("APP",ABM("F")),",",0),5)
 .W ?56,$J($FN($P(ABMP("APP",ABM("F")),U,3),",",2),10)
 W !?35,"=====",?56,"==========="
 W !,?35,$J($FN($P(ABM("TOT"),U),",",0),4)
 W ?56,$J($FN($P(ABM("TOT"),U,2),",",2),10)
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?45,"Avg Days"
 W !?35,"Number",?45,"Awaiting",?60,"Total"
 W !?3,$S(ABMP("VAR")=2:"Insurer",1:"Export Mode"),?35,"Bills",?45," Export",?59,"Charges"
 W !,"-------------------------------------------------------------------------------"
 Q
