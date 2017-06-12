ABMM2PV9 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**15**;NOV 12, 2009;Build 251
 ;IHS/SD/SDR - 2.6*15 - HEAT161159 - Changed PT LST to sort differently so there won't be duplicate vsts on pt lst.  Also made
 ;   change so it will correctly report the category for the patient on the pt lst, and added record indicator.
 ;IHS/SD/SDR - 2.6*15 - HEAT171490 - Added facility NPI and TIN to pt list host file
 ;IHS/SD/SDR - 2.6*15 - HEAT183289 - Made changes to print tribal self-insured summary line
 ;
MET ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR^ABMM2PV3
 I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMP("PRV")=0
 S ABMNUMT=0  ;abm*2.6*12
 F  S ABMP("PRV")=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"))) Q:'ABMP("PRV")  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I ABMP("PRV")'=ABMPRV Q
 .S ABMVLOC=0
 .F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"),ABMVLOC)) Q:'ABMVLOC  D
 ..I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..F ABM=1:1:80 W "-"
 ..S ABMLOC=$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E")
 ..S (ABMTENC,ABMDENOM)=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV,ABMVLOC))
 ..S ABMMPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,ABMVLOC,"MCD"))
 ..S ABMMZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,ABMVLOC,"MCD"))
 ..S ABMMENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,ABMVLOC,"MCD"))
 ..S ABMCPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,ABMVLOC,"CHIP"))
 ..S ABMCZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,ABMVLOC,"CHIP"))
 ..S ABMCENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,ABMVLOC,"CHIP"))
 ..S ABMOTHPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,ABMVLOC,"OTHR"))
 ..I $G(ABMFQHC)=1 D
 ...S ABMUNCR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,ABMVLOC,"UNCOMP")) ;abm*2.6*12 uncomp care
 ...S ABMTSI=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,ABMPRV,ABMVLOC,"TRIBSI")) ;abm*2.6*15 HEAT183289 tribal self-insured
 ..S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)  ;abm*2.6*15 HEAT183289
 ..;S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)+$G(ABMTSI)  ;abm*2.6*15 HEAT183289
 ..;
 ..W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT,ABMPRV,ABMVLOC)),U)_"%"
 ..W !!,"Total Patient Encounters (Denominator) "_ABMLOC_": ",?70,$J(ABMTENC,8)  ;abm*2.6*12
 ..W !,"Total Numerator Encounters "_ABMLOC_": ",?70,$J((ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)),8)  ;abm*2.6*12
 ..W !,"Total Medicaid Paid Encounters "_ABMLOC_": ",?70,$J(ABMMPD,8)
 ..W !,"Total Medicaid Zero Paid Encounters "_ABMLOC_": ",?70,$J(ABMMZPD,8)
 ..W !,"Total Medicaid Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(ABMMENR,8)  ;abm*2.6*12
 ..W !,"Total Kidscare/Chip Paid Encounters "_ABMLOC_": ",?70,$J(ABMCPD,8)
 ..W !,"Total Kidscare/Chip Zero Paid Encounters "_ABMLOC_": ",?70,$J(ABMCZPD,8)
 ..W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(ABMCENR,8)  ;abm*2.6*12
 ..;W !,"Total Paid Other Encounters "_ABMLOC_" (*not included in numerator): ",?70,$J(ABMOTHPD,8)  ;abm*2.6*12  ;abm*2.6*15 HEAT183289
 ..W !,"Total Paid Other Encounters "_ABMLOC_" (*not incl. in numerator): ",?70,$J(ABMOTHPD,8)  ;abm*2.6*12  ;abm*2.6*15 HEAT183289
 ..;W:($G(ABMFQHC)=1) !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)  ;abm*2.6*12 uncomp care  ;abm*2.6*15 HEAT183289
 ..;start new abm*2.6*15 HEAT183289
 ..I ($G(ABMFQHC)=1) D
 ...W !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)
 ...W !,"Total Tribal Self-Insured "_ABMLOC_" (*not incl. in numerator): ",?70,$J(ABMTSI,8)
 ;end new HEAT183289
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U)_"%"
 W !!,"Total Patient Encounters (Denominator) All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV)),8)  ;abm*2.6*12
 W !,"Total Numerator Encounters All Facilities Total: ",?70,$J(ABMNUMT,8)  ;abm*2.6*12
 W !,"Total Medicaid Paid Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"MCD")),8)
 W !,"Total Medicaid Zero Paid Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"MCD")),8)
 ;W !,"Total Medicaid Enrolled Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD")),8)  ;abm*2.6*12
 W !,"Total Medicaid Enrolled (Not Billed) Medicaid Encounters All Facs: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD")),8)  ;abm*2.6*12
 W !,"Total Kidscare/Chip Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"CHIP")),8)
 W !,"Total Kidscare/Chip Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"CHIP")),8)
 W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters All Facs Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"CHIP")),8)  ;abm*2.6*12
 W !,"Total Paid Other Encounters All Facs (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"OTHR")),8)  ;abm*2.6*12
 ;W:($G(ABMFQHC)=1) !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,"UNCOMP")),8)  ;abm*2.6*12 uncomp care  ;abm*2.6*15 HEAT183289
 ;start new abm*2.6*15 HEAT183289
 I ($G(ABMFQHC)=1) D
 .W !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,"UNCOMP")),8)
 .W !,"Total Tribal Self-Insured All Facilities Total (*not incl. in numer.): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,ABMPRV,"TRIBSI")),7)
 ;end new HEAT183289
 W !
 Q
