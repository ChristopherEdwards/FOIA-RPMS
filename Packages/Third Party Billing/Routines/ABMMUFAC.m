ABMMUFAC ;IHS/SD/SDR - EHR Incentive Report (MU) ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,7,11,12,15,20**;NOV 12, 2009;Build 317
 ;2.6*12-VMBP RQMT_104 - Added VAMB to report.
 ;2.6*12-Relabeled hdrs to include 'Adult&Ped'; added swingbed
 ;IHS/SD/SDR - 2.6*15 - HEAT183309 
 ;    split routine due to size
 ;    Req#B - added code so paid will still print for 'F' report so changes made for paid will work for both reports
 ;IHS/SD/SDR - 2.6*20 - HEAT256154 - Added IP Ancillary Discharges category.  Added bill type and visit type to detail report.
 ;
 W !!,"This report will calculate the number of Covered Inpatient days for Medicare,"
 W !,"Medicaid, and Private Insurance.  Outpatient All-Inclusive Rate (AIR) bills are"
 W !,"counted.  A report can be selected to view the bills used in the calculations."
 W !!!
 K ABMY,ABMP
 K ^TMP($J,"ABM-MUFAC")
 K ^TMP($J,"ABM-MUVLST")
DTTYP ;
 D ^XBFMK
 ;start new MU2 #8
 S DIR("A")="Run report by FISCAL YEAR, DATE RANGE, or LOOKBACK DATE"
 S DIR(0)="SO^F:FISCAL YEAR;D:DATE RANGE;L:LOOKBACK DATE"
 ;end new MU2 #8
 S DIR("B")="FISCAL YEAR"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMDTYP=Y
 S ABMY("FACHOS")="F"  ;default to F  ;abm*2.6*11 MU2 #8
 W !
 I ABMDTYP="F" D FDT
 I ABMDTYP="D" D DTR
 ;start new abm*2.6*11 MU2 #8
 I ABMDTYP="L" D
 .D LBK
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;start new abm*2.6*20 IHS/SD/SDR HEAT256154
 D GETLOCS
 I +ABMPAR=0 D  H 1  G DTTYP
 .W !!?8,"** There are no active facilities for the date range selected. **"
 .W !?24,"** Please re-select date span. **"
 ;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 D FACHOS
 ;end new MU2 #8
 D RTYPE
 Q
FDT ;
 D ^XBFMK
 S DIR("A")="Select REPORT DATE Fiscal year"
 S DIR(0)="LO^1960:2100:0"
 S DIR("B")=$E($$Y2KD2^ABMDUTL(DT),1,4)
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMY("DT",1)=Y
 W !
 Q
DTR ;
 D ^XBFMK
 S DIR("A")="Enter STARTING Date"
 S DIR(0)="DO^::EP"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING Date"
 D ^DIR
 K DIR
 G DTR:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DTR
 Q
 ;start new abm*2.6*11 MU2 #8
LBK ;
 D LBK^ABMMUFC1
 Q
FACHOS ;EP
 D FACHOS^ABMMUFC1
 Q
 ;end new MU2 #8
RTYPE ;sum or dtl?
 W !
 K DIC,DIE,DIR,X,Y,DA
 S DIR(0)="S^S:SUMMARY;D:DETAIL;B:BOTH"
 S DIR("A")="SUMMARY, DETAIL, or BOTH"
 S DIR("B")="SUMMARY"
 D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMSUMDT=Y
SEL ;Select device
 I ABMSUMDT="B" D
 .W !!,"There will be two outputs, one for SUMMARY and one for DETAIL."
 .W !,"The first one should be a terminal or a printer."
 .W !,"The second forces an HFS file because it could be a large file",!
 I ABMSUMDT'="D" D
 .S ABMQ("RX")=$S(ABMSUMDT="S":"XIT^ABMMUFAC",1:"XIT2^ABMMUFAC")
 .S ABMQ("NS")="ABM"
 .S ABMQ("RC")="GETTOTS^ABMMUFAC"
 .S ABMQ("RP")="WRTSUM^ABMMUFAC"
 .D ^ABMDRDBQ
 I ABMSUMDT'="S" D
 .W !!,"Will now write detail to file",!!
 .D ^XBFMK
 .;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 .;S DIR(0)="F"
 .;S DIR("A")="Enter Path"
 .;S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .;D ^DIR K DIR
 .;Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .;S ABMPATH=Y
 .;S DIR(0)="F",DIR("A")="Enter File Name"
 .;D ^DIR K DIR
 .;Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .;S ABMFN=Y
 .;W !!,"Creating file..."
 .;D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .;Q:POP
 .;U IO
 .;D GETTOTS  ;abm*2.6*7
 .;D WRTDTL^ABMMUFC2
 .;D CLOSE^%ZISH("ABM")
 .;W "DONE" H 1
 .;end old start new abm*2.6*20 IHS/SD/SDR HEAT256154
 .S ABMQ("RX")=$S(ABMSUMDT="S":"XIT^ABMMUFAC",1:"XIT2^ABMMUFAC")
 .S ABMQ("NS")="ABM"
 .S ABMQ("RC")="GETTOTS^ABMMUFAC"
 .S ABMQ("RP")="WRTDTL^ABMMUFC2"
 .D ^ABMDRDBQ
 .;end new abm*2.6*20 IHS/SD/SDR HEAT256154
XIT ;
 K ^TMP($J,"ABM-MUFAC")
 K ^TMP($J,"ABM-MUVLST")
 K ABMP,ABMY,ABMPTINA,ABMPT,ABMMFLG,ABMC,ABMB
XIT2 ;
 Q
QUE ;TASKMAN
 S ZTRTN="WRTDTL^ABMMUFAC"
 S ZTDESC="FACILITY EHR INCENTIVE REPORT"
 S ZTSAVE("ABM*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
GETTOTS ;
 D GETLOCS
 ;start new abm*2.6*15 HEAT183309 keep 'F' option same as before
 I ABMY("FACHOS")="F" D  Q
 .S ABML=0
 .S ABMDUZ2=DUZ(2)
 .F  S ABML=$O(ABMLOC(ABML)) Q:'ABML  D
 ..S DUZ(2)=ABML
 ..D GETBILLS^ABMMUFC5
 ;
 ;only gets here if 'H' option
 S ABML=0
 S ABMDUZ2=DUZ(2)
 F  S ABML=$O(ABMLOC(ABML)) Q:'ABML  D
 .S DUZ(2)=ABML
 .D GETBILLS^ABMMUFC1
 .D CLAIMS^ABMMUFC3  ;abm*2.6*15 HEAT183309 Req#B
 S DUZ(2)=ABMDUZ2
 D VISITS^ABMMUFC1  ;abm*2.6*15 HEAT183309 Req#B
 Q
GETLOCS ;
 I ABMDTYP="F" D
 .S ABMP("SDT")=((+ABMY("DT",1)-1)_"1001")-17000000
 .S ABMP("EDT")=((+ABMY("DT",1))_"0930")-16999999
 I ABMDTYP="D"!(ABMDTYP="L") D  ;abm*2.6*11 MU2 #8
 .S ABMP("SDT")=ABMY("DT",1)-.5
 .S ABMP("EDT")=ABMY("DT",2)+.999999
 K ABMPSFLG
 S ABMPAR=0
 F  S ABMPAR=$O(^BAR(90052.05,ABMPAR)) Q:+ABMPAR=0  D  Q:($G(ABMPSFLG)=1)
 .I $D(^BAR(90052.05,ABMPAR,DUZ(2))) D
 ..; Use A/R parent/sat is yes, but DUZ(2) is not parent for this 
 ..; visit loc
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,3)'=ABMPAR
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,6)>ABMP("EDT")
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,7)&($P(^(0),U,7)<ABMP("SDT"))
 ..S ABMPSFLG=1
 I +ABMPAR=0 Q  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 S ABMLOC(ABMPAR)=""
 S ABML=0
 F  S ABML=$O(^BAR(90052.05,ABMPAR,ABML)) Q:'ABML  D
 .Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,6)>ABMP("EDT")
 .Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,7)&($P(^(0),U,7)<ABMP("SDT"))
 .S ABMLOC(ABML)=""
 Q
SETCAT ;
 ;swingbed
 I (ABMSC="H"!(ABMSC="I")),(+$G(ABMP("SWINGBED"))=1)!(($E(ABMP("BTYP"),1,2)=18)&(ABMP("VTYP")'=999)) S ABMP("RPT-CAT")="IP SB DISCHGS" Q  ;abm*2.6*12
 I (ABMSC="H"!(ABMSC="I")),+$G(ABMP("NEWBORN"))=0,($E(ABMP("BTYP"),1,2)=11),(ABMP("VTYP")=111) S ABMP("RPT-CAT")="IP DISCHGS" Q  ;abm*2.6*7
 I (ABMSC="H"!(ABMSC="I")),+$G(ABMP("NEWBORN"))=1,($E(ABMP("BTYP"),1,2)=11),(ABMP("VTYP")=111) S ABMP("RPT-CAT")="IP NB DISCHGS" Q  ;abm*2.6*7
 I (ABMSC="H"!(ABMSC="I")),($E(ABMP("BTYP"),1,2)=11),(ABMP("VTYP")=999) S ABMP("RPT-CAT")="IP CHGS" Q
 I (ABMSC'="H"&(ABMSC'="I")),(($E(ABMP("BTYP"),1,2)=13)!($E(ABMP("BTYP"),1,2)=85)!($E(ABMP("BTYP"),1,2)=73)),(ABMP("VTYP")=131),(ABMFFLG=1) S ABMP("RPT-CAT")="OP AIR" Q
 I (ABMSC'="H"&(ABMSC'="I")),(($E(ABMP("BTYP"),1,2)=13)!($E(ABMP("BTYP"),1,2)=85)!($E(ABMP("BTYP"),1,2)=73)),(ABMP("VTYP")=131),(ABMFFLG=0) S ABMP("RPT-CAT")="OP ITEM" Q
 I (ABMSC'="H"&(ABMSC'="I")),(($E(ABMP("BTYP"),1,2)=13)!($E(ABMP("BTYP"),1,2)=85)!($E(ABMP("BTYP"),1,2)=73)),(ABMP("VTYP")=999) S ABMP("RPT-CAT")="OP CHGS" Q
 I ABMSC="H"!(ABMSC="I"),($E(ABMP("BTYP"),1,2)=12) S ABMP("RPT-CAT")="IP ANC DISCHGS" Q   ;abm*2.6*20 IHS/SD/SDR HEAT256154
 I ABMSC="H"!(ABMSC="I"),($E(ABMP("BTYP"),1,2)'=11) S ABMP("RPT-CAT")="IP CHGS" Q
 I +$G(ABMFFLG)=1 S ABMP("RPT-CAT")="OP AIR" Q
 S ABMP("RPT-CAT")="OP ITEM"
 Q
WRTSUM ;
 I ABMY("FACHOS")="H" D WRTSUMHO^ABMMUFC2 Q  ;abm*2.6*12
 S ABM("HD",0)="FACILITY EHR INCENTIVE REPORT"  ;abm*2.6*7
 S ABM("PG")=1  ;abm*2.6*7
 S ABMTYP="SUM" D WHD
 S CENTER=IOM/2
 S ABMITYP=""
 F ABMITYP="MEDICARE","MEDICAID","PRIVATE","KIDSCARE/CHIP","VMBP","OTHER" D  ;abm*2.6*12 VMBP RQMT_104
 .W !
 .I ABMITYP="PRIVATE" W ?CENTER-($L("-- P R I V A T E  I N S U R A N C E --")/2),"-- P R I V A T E  I N S U R A N C E --"
 .I ABMITYP="MEDICARE" W ?CENTER-($L("-- M E D I C A R E --")/2),"-- M E D I C A R E --"
 .I ABMITYP="MEDICAID" W ?CENTER-($L("-- M E D I C A I D --")/2),"-- M E D I C A I D --"
 .I ABMITYP="KIDSCARE/CHIP" W ?CENTER-($L("-- K I D S C A R E / C H I P --")/2),"-- K I D S C A R E / C H I P --"
 .I ABMITYP="VMBP" W ?CENTER-($L("-- V E T E R A N S  M E D I C A L  B E N  P R O G --")/2),"-- V E T E R A N S  M E D I C A L  B E N  P R O G --"  ;abm*2.6*12 VMBP RQMT_104
 .I ABMITYP="OTHER" W ?CENTER-($L("-- O T H E R --")/2),"-- O T H E R --"
 .W !?4,"# Paid "_ABMITYP_" IP Discharges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP DISCHGS")),20)
 .W !?4,"# Paid "_ABMITYP_" IP Newborn Discharges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DISCHGS")),20)  ;abm*2.6*7
 .;W !?4,"# Paid "_ABMITYP_" IP Charges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS")),20)  ;abm*2.6*11 MU2 #8
 .W:$G(ABMY("FACHOS"))="F" !?4,"# Paid "_ABMITYP_" IP Charges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS")),20)  ;abm*2.6*11 MU2 #8
 .W !?4,"# Paid "_ABMITYP_" IP Bed Days",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP DAYS")),20)
 .W !?4,"# Paid "_ABMITYP_" IP Newborn Bed Days",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DAYS")),20)  ;abm*2.6*7
 .W !?4,"# Paid "_ABMITYP_" IP Bed Days Charges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS")),20)
 .W !?4,"# Paid "_ABMITYP_" OP All-Inclusive",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"OP AIR")),20)
 .W !?4,"# Paid "_ABMITYP_" OP Charges",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"OP CHGS")),20)
 .W !?4,"# Paid "_ABMITYP_" OP Itemized",?59,$J(+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"OP ITEM")),20)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .W !
 W !!,"(SUMMARY REPORT COMPLETE):"
 D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DUZ(2)=ABMDUZ2
 Q
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
WHD ;EP
 W $$EN^ABMVDF("IOF"),!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 D NOW^%DTC
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,$S(ABMTYP="SUM":"   Page "_ABM("PG"),1:"")
 S:ABMDTYP="F" ABM("HD",1)="For FISCAL YEAR: "_+(ABMY("DT",1))
 S:ABMDTYP="D" ABM("HD",1)="For Date Range: "_$$SDT^ABMDUTL(ABMY("DT",1))_" to "_$$SDT^ABMDUTL(ABMY("DT",2))
 S:ABMDTYP="L" ABM("HD",1)="Lookback Date Range: "_$$SDT^ABMDUTL(ABMY("DT",1))_" to "_$$SDT^ABMDUTL(ABMY("DT",2))  ;abm*2.6*11 MU2 #8
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 W !,"Billing Location: ",$P($G(^AUTTLOC(ABMPAR,0)),U,2)
 W !,ABM("LINE") K ABM("LINE")
 S ABM("PG")=+$G(ABM("PG"))+1
 I ABMTYP="DET" D
 .;W !,"INSURER CATEGORY"_U_"IP/OP CATEGORY"_U_"INSURER"_U_"INSURER TYPE"  ;abm*2.6*15 HEAT183309 Req#B
 .W !,"INSURER CATEGORY"_U_"RECORD TYPE"_U_"IP/OP CATEGORY"_U_"INSURER"_U_"INSURER TYPE"  ;abm*2.6*15 HEAT183309 Req#B
 .W U_"BILL NUMBER"_U_"ADMIT DT"_U_"DISCHG DT"_U_"AMOUNT BILLED"_U_"PAYMENT"_U_"COVD DAYS"_U_"N-COVD DAYS"
 .;I ABMY("FACHOS")="H" W U_"HRN"_U_"VISIT"_U_"VISIT LOCATION"  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 .I ABMY("FACHOS")="H" W U_"HRN"_U_"VISIT"_U_"VISIT LOCATION"_U_"BILL TYPE"_U_"VISIT TYPE"_U_"ALL INSURER TYPES"_U_"ADMISSION TYPE"  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 .I ABMY("FACHOS")="F" W U_"VISIT"_U_"VISIT LOCATION"
 I ABMTYP="SUM" D
 .;W !?67,"# Discharges",!  ;abm*2.6*15 HEAT183309 Req#A
 .;start new abm*2.6*15 HEAT183309 Req#A
 .I ABMY("FACHOS")="F" D
 ..W !?67,"# Discharges",!
 .;end new HEAT183309 Req#A
 .I ABMY("FACHOS")="H" D
 ..W !?52,"Billed",?63,"Paid",?73,"Total",!  ;abm*2.6*15 HEAT183309 Req#B
 .F ABMI=1:1:80 W "-"
 Q
