ABMDRBR1 ; IHS/ASDST/DMJ - Brief Claim List - 80 width ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4482 - Added claim status to report
 ;
PRINT ;EP for printing data
 S ABM("TXT")=""
 D HDB
 S (ABM("CNT"),ABM("SUBCNT"))=0,(ABM("L"),ABM("V"))=""
 S ABM("A")="TMP(""ABM-BR"","_$J,ABM="^"_ABM("A")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D LOC W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-B",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2)
 .S ABM("C")=$G(^ABMDCLM(DUZ(2),+$P(ABM("TXT"),U,4),0)) Q:ABM("C")=""
 .Q:'ABM("C")!'$P(ABM("C"),U,7)!'$P(ABM("C"),U,8)
 .I ABM("L")'=$P(ABM("TXT"),U) S ABM("V")="" D SUB,LOC
 .S ABM("L")=$P(ABM("TXT"),U)
 .I ABM("V")'=$P(ABM("TXT"),U,2) D SUB:ABM("V")]"" W:ABM("V")'="" ! W !?7,$S(ABMY("SORT")="C":"Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,2),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,2),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,2)
 .;W !,$E($P(ABM("TXT"),U,3),1,20)  ;abm*2.6*1 HEAT4482
 .;start new code abm*2.6*1 HEAT4482
 .S ABMSTA=$P($G(^ABMDCLM(DUZ(2),$P(ABM("TXT"),U,4),0)),U,4)
 .S ABMSTA=$S(ABMSTA="E":"EDT",ABMSTA="R":"RJT",ABMSTA="U":"B/U",ABMSTA="C":"CMP",ABMSTA="F":"FAB",ABMSTA="O":"ROL",1:"")
 .W !,ABMSTA
 .W ?5,$E($P(ABM("TXT"),U,3),1,15)
 .;end new code HEAT4482
 .W ?21,$S($D(^AUPNPAT($P(ABM("C"),U),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 .W ?28,$E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,22)
 .W ?52,$P(ABM("TXT"),U,4)
 .W ?60,$$SDT^ABMDUTL($P(ABM("C"),U,2))
 .I ABMY("SORT")="V" W ?71,$E($P(^DIC(40.7,$P(ABM("C"),U,6),0),U),1,9)
 .E  W ?71,$E($P(^ABMDVTYP($P(ABM("C"),U,7),0),U),1,9)
 .S ABM("CNT")=ABM("CNT")+1,ABM("SUBCNT")=ABM("SUBCNT")+1
 Q:$D(DIROUT)!($D(DUOUT))!($D(DTOUT))
 D SUB
 W !?52,"======"
 W !?46,"Total:",?52,$FN(ABM("CNT"),",",0)
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,?52,"Claim",?62,"Visit" W:ABMY("SORT")="C" ?71,"Visit"
 ;W !,"Patient",?22,"HRN",?28,"Active Insurer",?52,"Number",?62,"Date",?71,$S(ABMY("SORT")="V":"Clinic",1:" Type")  ;abm*2.6*1 HEAT4482
 W !,"ST",?3,"Patient",?22,"HRN",?28,"Active Insurer",?52,"Number",?62,"Date",?71,$S(ABMY("SORT")="V":"Clinic",1:" Type")  ;abm*2.6*1 HEAT4482
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
LOC W !!?3,"Visit Location: ",$P(ABM("TXT"),U)
 Q
 ;
SUB Q:'ABM("SUBCNT")
 W !?52,"------"
 W !?43,"Subtotal:",?52,$FN(ABM("SUBCNT"),",",0)
 S ABM("SUBCNT")=0
 Q
