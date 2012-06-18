ABMRVTPB ; IHS/SD/SDR - VISIT W/THIRD PARTY BILLED REPORT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 K ABM,ABMY
 ;
SEL S ABM("STA","NM")="PCC Status Report"
 S ABM("TXT")=""
 S ABM("NODX")=""
 S ABMY("DT")="V"
START W !!," ============ Entry of VISIT Range =============",!
 S DIR("A")="Enter STARTING Visit for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 ;G START:$D(DIRUT)  ;abm*2.6*6 NOHEAT
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*6 NOHEAT
 S ABMY("DT",1)=Y
 W !
END S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G START:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G START
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)=ABM("STA","NM")
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMRVTPB"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMRVTPB"
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-VTPB" K ^TMP("ABM-VTPB",$J) Q:'$D(ABM("STA"))  S ABM("PG")=0
ALL ;ALL STATUS
SLOOP S ABMV=ABMY("DT",1)-.5
 F  S ABMV=$O(^AUPNVSIT("B",ABMV)) Q:'ABMV!(ABMV>ABMY("DT",2))  D
 .S ABMVIEN=0
 .F  S ABMVIEN=$O(^AUPNVSIT("B",ABMV,ABMVIEN)) Q:'ABMVIEN  D DATA
 Q
 ;
DATA ;
 S ABMP("TPB")=$$GET1^DIQ(9000010,ABMVIEN_",",.04,"E")
 S ABMP("VLOC")=$$GET1^DIQ(9000010,ABMVIEN_",",.06,"E")
 S ABMP("SCAT")=$$GET1^DIQ(9000010,ABMVIEN_",",.07,"E")
 S ABMP("CLIN")=$$GET1^DIQ(9000010,ABMVIEN_",",.08,"E")
 S ABMP("PDFN")=$$GET1^DIQ(9000010,ABMVIEN_",",.05,"I")
 S ^TMP("ABM-VTPB",$J,ABMP("VLOC")_U_ABMP("TPB")_U_ABMP("SCAT")_U_ABMVIEN_U_ABMP("PDFN")_U_ABMP("CLIN"))=""
 Q
PRINT ;EP for printing data
 S ABM("PG")=0 D HDB
 S (ABM("CNT1"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0
 S ABM("VLOC")=""
 S ABM("Z")="TMP(""ABM-VTPB"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-VTPB",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2),ABM("TXT")=+$P(ABM("T"),",",3)_U_ABM("TXT")
 .I ABM("VLOC")'=$P(ABM("TXT"),U,2) D SUB:ABM("VLOC")]"" W:(ABM("VLOC")'="") ! W !?3,"Visit Location: ",$P(ABM("TXT"),U,2)
 .S ABM("VLOC")=$P(ABM("TXT"),U,2)
 .S ABM("TPB")=$P(ABM("TXT"),U,3)
 .S ABM("SCAT")=$P(ABM("TXT"),U,4)
 .S ABM("VDFN")=$P(ABM("TXT"),U,5)
 .S ABM("PDFN")=$P(ABM("TXT"),U,6)
 .S ABM("CLIN")=$P(ABM("TXT"),U,7)
 .W !
 .W $E($P(^DPT($P(ABM("PDFN"),U),0),U),1,16)  ;pat name
 .S ABM("HRN")=$P($G(^AUPNPAT($P(ABM("PDFN"),U),41,ABM("VLOC"),0)),U,2)  ;HRN
 .S:ABM("HRN")="" ABM("HRN")=$P($G(^AUPNPAT($P(ABM("PDFN"),U),41,DUZ(2),0)),U,2)  ;HRN
 .W ?18,ABM("HRN")
 .W ?25,$E(ABM("CLIN"),1,10)  ;clinic
 .W ?37,$$GET1^DIQ(9000010,ABM("VDFN")_",",.01,"E")  ;visit date/time
 .W ?57,$E(ABM("TPB"),1,22)  ;third party billed
 .S ABM("CNT1")=ABM("CNT1")+1,ABM("CNT2")=ABM("CNT2")+1,ABM("CNT")=ABM("CNT")+1,ABM("TOT")=ABM("TOT")+ABM("T")
 .S ABM("TOT1")=ABM("TOT1")+ABM("T"),ABM("TOT2")=ABM("TOT2")+ABM("T")
 D SUB
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?2,"Patient",?18,"HRN",?25,"Clinic",?37,"Visit Date/Time",?57,"Third Party Billed"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
SUB Q:'ABM("CNT1")
 W !?27,"------"
 W !?19,"Count:",?27,ABM("CNT1")
 S ABM("CNT1")=0,ABM("TOT1")=0,ABM("CNT2")=0,ABM("TOT2")=0,ABM("I")=""
 Q
XIT ;EXIT POINT
 Q
