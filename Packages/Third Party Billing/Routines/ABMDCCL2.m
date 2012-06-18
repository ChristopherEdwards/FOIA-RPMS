ABMDCCL2 ; IHS/ASDST/DMJ - Cancelled claims-132 Width ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;IHS/SD/SDR - v2.5 p10 - IM20215
 ;  HRN not printing on report
 ;
PRINT ;EP for printing data
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0,(ABM("CANC"),ABM("LOC"),ABM("VT"))=""
 S ABM("Z")="TMP(""ABM-CC"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-CC",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2),ABM("TXT")=+$P(ABM("T"),",",3)_U_ABM("TXT")
 .S ABM("PDFN")=$G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0)) Q:ABM("PDFN")=""  S ABM("CDT")=$P($G(^(1)),U,5)
 .I ABM("CANC")'=$P(ABM("TXT"),U) S ABM("CANC")="" D SUB,SUBHD S ABM("LOC")=""
 .I ABM("LOC")'=$P(ABM("TXT"),U,2) D SUB:ABM("LOC")]"" W:ABM("LOC")'="" ! W !?3,"Visit Location: ",$P(^DIC(4,$P(ABM("PDFN"),U,3),0),U) S ABM("VT")=""
 .S ABM("CANC")=$P(ABM("TXT"),U)
 .S ABM("LOC")=$P(ABM("TXT"),U,2)
 .I ABM("VT")'=$P(ABM("TXT"),U,3) D SUB2:ABM("VT")]"" W:ABM("VT")]"" ! W !?7,$S(ABMY("SORT")="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,3),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,3),0),U))
 .S ABM("VT")=$P(ABM("TXT"),U,3)
 .W !
 .W $E($P(^DPT($P(ABM("PDFN"),U),0),U),1,35)  ;pat name
 .W ?37,$P($G(^AUPNPAT($P(ABM("PDFN"),U),41,$P(ABM("PDFN"),U,3),0)),U,2)  ;HRN
 .W ?47,$E($P(^AUTNINS($P(ABM("PDFN"),U,8),0),U),1,24)  ;ins
 .W ?73,$P(ABM("TXT"),U,5)  ;claim number
 .W ?81,$$SDT^ABMDUTL($P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0)),U,2))  ;visit date
 .I ABMY("SORT")="VT" W:+$P(ABM("PDFN"),U,10) ?92,$E($P(^DIC(40.7,$P(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0),U,6),0),U),1,18)  ;clinic
 .E  W ?92,$P(^ABMDVTYP($P(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0),U,7),0),U)  ;visit
 .W ?102,$E($P($G(^ABMCCLMR($P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),1)),U,8),0)),U),1,30)  ;reason
 .S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 .S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 D SUB
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !,?47,"Active",?73,"Claim",?81,"Visit"
 W !?5,"Patient",?37,"HRN",?47,"Insurer",?73,"Number",?81,"Date",?94,$S(ABMY("SORT")="VT":"Clinic",1:"Visit Type"),?110,"Reason"
 S $P(ABM("LINE"),"-",132)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
SUBHD W !!,"Cancelling Official: ",$P(^VA(200,$P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),1)),U,4),0),U)
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?32,"------",?121,"----------"
 W !?5,"Sub-total:",?32,ABM("CNT2"),?121,$J($FN(ABM("TOT2"),",",2),10)
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?32,"------"
 W !?9,"Total:",?32,ABM("CNT1")
 S ABM("CNT1")=0,ABM("TOT1")=0,ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
XIT ;EXIT POINT
 Q
