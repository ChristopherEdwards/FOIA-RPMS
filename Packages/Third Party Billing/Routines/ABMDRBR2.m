ABMDRBR2 ; IHS/ASDST/DMJ - Brief Claim List - 132 width ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4482 - Added claim status to report
 ;
PRINT ;EP for printing data
 S ABM("PRIVACY")=1
 U IO W:$D(ABM("PRINT",16)) @ABM("PRINT",16) D HDB
 S (ABM("TXT"),ABM("CNT"),ABM("SUBCNT"))=0,(ABM("L"),ABM("V"))=""
 S ABM("A")="TMP(""ABM-BR"","_$J,ABM="^"_ABM("A")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D LOC W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-B",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2)
 .S ABM("C")=$G(^ABMDCLM(DUZ(2),$P(ABM("TXT"),U,4),0)) Q:ABM("C")=""
 .Q:'ABM("C")!'$P(ABM("C"),U,7)!'$P(ABM("C"),U,8)
 .I ABM("L")'=$P(ABM("TXT"),U) S ABM("V")="" D SUB,LOC
 .S ABM("L")=$P(ABM("TXT"),U)
 .I ABM("V")'=$P(ABM("TXT"),U,2) D SUB:ABM("V")]"" W:ABM("V")'="" ! W !?7,$S(ABMY("SORT")="C":"Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,2),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,2),0),U))
 .S ABM("V")=$P(ABM("TXT"),U,2)
 .;W !,$E($P(ABM("TXT"),U,3),1,30)  ;abm*2.6*1 HEAT4482
 .;start new code abm*2.6*1 HEAT4482
 .S ABMSTA=$P($G(^ABMDCLM(DUZ(2),$P(ABM("TXT"),U,4),0)),U,4)
 .S ABMSTA=$S(ABMSTA="E":"EDIT",ABMSTA="R":"RJECT",ABMSTA="U":"BILLD",ABMSTA="C":"CCOMP",ABMSTA="F":"FAB",ABMSTA="O":"ROL-EDT",1:"")
 .W !?2,ABMSTA
 .W ?11,$E($P(ABM("TXT"),U,3),1,23)
 .;end new code HEAT4482
 .W ?32,$S($D(^AUPNPAT($P(ABM("C"),U),41,DUZ(2),0)):$P(^(0),U,2),1:"")
 .W ?40,$E($P(^AUTNINS($P(ABM("C"),U,8),0),U),1,30)
 .W ?72,$P(ABM("TXT"),U,4)
 .W ?80,$$SDT^ABMDUTL($P(ABM("C"),"^",2))
 .I $P($G(^ABMDCLM(DUZ(2),$P(ABM("TXT"),U,4),6)),U,3)]"" W ?92,$$SDT^ABMDUTL($P(^(6),U,3))
 .I ABMY("SORT")="V" W ?104,$E($P(^DIC(40.7,$P(ABM("C"),U,6),0),U),1,28)
 .E  W ?100,$E($P(^ABMDVTYP($P(ABM("C"),U,7),0),U),1,30)
 .S ABM("CNT")=ABM("CNT")+1,ABM("SUBCNT")=ABM("SUBCNT")+1
 Q:$D(DIROUT)!($D(DTOUT))!($D(DUOUT))
 D SUB
 W !?72,"======"
 W !?64,"Total:",?72,$FN(ABM("CNT"),",",0)
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,?72,"Claim",?81,"Visit",?90,"Discharge"
 ;W !?5,"Patient",?33,"HRN",?45,"Active Insurer",?72,"Number",?82,"Date",?92,"Date",?104,$S(ABMY("SORT")="V":"Clinic",1:"Visit Type")  ;abm*2.6*1 HEAT4482
 W !?3,"STA",?11,"Patient",?33,"HRN",?45,"Active Insurer",?72,"Number",?82,"Date",?92,"Date",?104,$S(ABMY("SORT")="V":"Clinic",1:"Visit Type")  ;abm*2.6*1 HEAT4482
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
LOC W !!?3,"Visit Location: ",$P(ABM("TXT"),U)
 Q
 ;
SUB Q:'ABM("SUBCNT")
 W !?72,"------"
 W !?61,"Subtotal:",?72,$FN(ABM("SUBCNT"),",",0)
 S ABM("SUBCNT")=0
 Q
