ABMDCCL1 ; IHS/ASDST/DMJ - Cancelled claims listing-80 Width ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;IHS/SD/SDR - v2.5 p10 - IM20215
 ;  HRN not printing on report
 ;
PRINT ;EP for printing data
 S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0,(ABM("CANC"),ABM("LOC"),ABM("VT"))=""
 S ABM("Z")="TMP(""ABM-CC"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-CC",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2),ABM("TXT")=+$P(ABM("T"),",",3)_U_ABM("TXT")
 .S ABM("PDFN")=$G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0)) Q:ABM("PDFN")=""
 .I ABM("CANC")'=$P(ABM("TXT"),U) S ABM("CANC")="" D SUB,SUBHD S ABM("LOC")=""
 .I ABM("LOC")'=$P(ABM("TXT"),U,2) D SUB:ABM("LOC")]"" W:(ABM("LOC")'="") ! W !?3,"Visit Location: ",$P(^DIC(4,$P(ABM("PDFN"),U,3),0),U) S ABM("VT")=""
 .S ABM("CANC")=$P(ABM("TXT"),U)
 .S ABM("LOC")=$P(ABM("TXT"),U,2)
 .I ABM("VT")'=$P(ABM("TXT"),U,3) D SUB2:ABM("VT")]"" W:ABM("VT")]"" ! W !?7,$S(ABMY("SORT")="C":"    Clinic: "_$P(^DIC(40.7,$P(ABM("TXT"),U,3),0),U),1:"Visit Type: "_$P(^ABMDVTYP($P(ABM("TXT"),U,3),0),U))
 .S ABM("VT")=$P(ABM("TXT"),U,3)
 .W !
 .W $E($P(^DPT($P(ABM("PDFN"),U),0),U),1,16)  ;pat name
 .W ?18,$P($G(^AUPNPAT($P(ABM("PDFN"),U),41,$P(ABM("PDFN"),U,3),0)),U,2)  ;HRN
 .W ?25,$E($P(^AUTNINS($P(ABM("PDFN"),U,8),0),U),1,12)  ;ins
 .W ?39,$P(ABM("TXT"),U,5)  ;claim number
 .W ?47,$$SDT^ABMDUTL($P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),0)),U,2))  ;visit date
 .W ?59,$E($P($G(^ABMCCLMR($P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),1)),U,8),0)),U),1,18)  ;reason
 .S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 .S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 D SUB
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?25,"Active",?39,"Claim",?50,"Visit"
 W !?2,"Patient",?18,"HRN",?25,"Insurer",?39,"Number",?50,"Date",?63,"Reason"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
SUBHD ;
 W !!,"Cancelling Official: ",$P(^VA(200,$P($G(^ABMCCLMS(DUZ(2),$P(ABM("TXT"),U,5),1)),U,4),0),U)
 Q
 ;
SUB2 Q:'ABM("CNT2")
 W !?27,"------"
 W !?16,"Subcount:",?27,ABM("CNT2")
 S ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
 ;
SUB Q:'ABM("CNT1")  D SUB2:ABM("CNT1")'=ABM("CNT2")
 W !?27,"------"
 W !?19,"Count:",?27,ABM("CNT1")
 S ABM("CNT1")=0,ABM("TOT1")=0,ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
XIT ;EXIT POINT
 Q
