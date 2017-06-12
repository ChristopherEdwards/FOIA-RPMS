ABMM2PV4 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,15**;NOV 12, 2009;Build 251
 ;IHS/SD/SDR - 2.6*12 - Made changes for uncomp care; uncomp should be a separate detail line
 ;  and should be included in pt vol total, not as separate line
 ;IHS/SD/SDR - 2.6*12 - Included numerator and msgs about numerator, denominator
 ;IHS/SD/SDR - 2.6*15 - HEAT161159 - Changed PT LST to sort differently so there won't be duplicate vsts on pt lst.
 ;IHS/SD/SDR - 2.6*15 - HEAT174501 - Added Provider NPI to host file
 ;IHS/SD/SDR - 2.6*15 - HEAT171490 - Added facility NPI and TIN to pt list host file
 ;IHS/SD/SDR - 2.6*15 - HEAT183289 - Added Tribal self-insured flag to output and summary total lines
 ;
GRPPRT ;EP
 I ABMY("RFMT")="P" D PATIENT Q
 I +$G(^XTMP("ABM-PVP2",$J,"PRV TOP"))>29.5 S ABMPMET=1 D MET Q
 D NOTMET
 K ^XTMP("ABM-PVP2",$J)
 Q
MET ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U,2)
 D HDR^ABMM2PV3
 I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMNUMT=0  ;abm*2.6*12
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMVLOC)) Q:'ABMVLOC  D
 .I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .F ABM=1:1:80 W "-"
 .S ABMLOC=$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E")
 .S (ABMTENC,ABMDENOM)=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMVLOC))
 .S ABMMPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"MCD"))
 .S ABMMZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"MCD"))
 .S ABMMENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"MCD"))
 .S ABMCPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"CHIP"))
 .S ABMCZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"CHIP"))
 .S ABMCENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"CHIP"))
 .S ABMOTHPD=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"OTHR"))
 .;start new abm*2.6*12
 .I $G(ABMFQHC)=1 D
 ..S ABMUNCR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMVLOC,"UNCOMP")) ;abm*2.6*12 uncomp care
 ..S ABMTSI=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,ABMVLOC,"TRIBSI")) ;abm*2.6*15 HEAT183289 tribal self-insured
 .S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)  ;abm*2.6*15 HEAT183289
 .;S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)+$G(ABMTSI)  ;abm*2.6*15 HEAT183289
 .;end new abm*2.6*12
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"UNCOMP")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"UNCOMP"))+$G(ABMUNCOM)  ;abm*2.6*12 uncomp care
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"UNCOMP")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"UNCOMP"))+$G(ABMUNCOM)  ;abm*2.6*12 uncomp care
 .;start new abm*2.6*15 HEAT183289 tribal self-insured
 .;S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"TRIBSI")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"TRIBSI"))+$G(ABMTSI)
 .;S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"TRIBSI")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"TRIBSI"))+$G(ABMTSI)
 .;end new HEAT183289
 .W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT,ABMVLOC)),U)_"%"
 .W !!,"Total Patient Encounters (Denominator) "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMVLOC)),8)
 .W !,"Total Numerator Encounters "_ABMLOC_": ",?70,$J((ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)),8)
 .W !,"Total Medicaid Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Medicaid Zero Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Medicaid Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Kidscare/Chip Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Kidscare/Chip Zero Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"CHIP")),8)
 .;W !,"Total Paid Other Encounters "_ABMLOC_" (*not included in numer.): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"OTHR")),8)  ;abm*2.6*15
 .W !,"Total Paid Other Encounters "_ABMLOC_" (*not included in numer.): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"OTHR")),8)  ;abm*2.6*15
 .;W:($G(ABMFQHC)=1) !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)  ;abm*2.6*12 uncomp care  ;abm*2.6*15 HEAT183289
 .;start new abm*2.6*15 HEAT183289
 .I ($G(ABMFQHC)=1) D
 ..;W !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)  ;abm*2.6*15
 ..W !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMVLOC,"UNCOMP")),8)  ;abm*2.6*15
 ..;W !,"Total Tribal Self-Insured "_ABMLOC_" (*not incl. in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,"TRIBSI")),8)  ;abm*2.6*15
 ..W !,"Total Tribal Self-Insured "_ABMLOC_" (*not incl. in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,ABMVLOC,"TRIBSI")),8)  ;abm*2.6*15 ;end new HEAT183289
 ;
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U)_"%"
 W !!,"Total Patient Encounters (Denominator) All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT)),8)
 W !,"Total Numerator Encounters All Facilities Total: ",?70,$J(ABMNUMT,8)
 W !,"Total Medicaid Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"MCD")),8)
 W !,"Total Medicaid Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"MCD")),8)
 W !,"Total Medicaid Enrolled (Not Billed) Encounters All Facs Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"MCD")),8)  ;abm*2.6*12
 W !,"Total Kidscare/Chip Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"CHIP")),8)
 W !,"Total Kidscare/Chip Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"CHIP")),8)
 ;W !,"Total Kidscare/Chip Enrolled Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP")),8)  ;abm*2.6*12
 W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters All Facs: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP")),8)  ;abm*2.6*12
 ;W !,"Total Paid Other Encounters All Fac. (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"OTHR")),8)  ;abm*2.6*12  ;abm*2.6*15
 W !,"Total Paid Other Encounters All Fac. (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"OTHR")),8)  ;abm*2.6*12  ;abm*2.6*15
 ;W:($G(ABMFQHC)=1) !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),8)  ;abm*2.6*12 uncomp care  ;abm*2.6*15 HEAT183289
 ;start new abm*2.6*15 HEAT183289
 I ($G(ABMFQHC)=1) D
 .W !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),8)
 .W !,"Total Tribal Self-Insured All Facilities Total (*not incl. in numer.): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,"TRIBSI")),7)
 ;end new HEAT183289
 W !
 Q
NOTMET ;EP
 S ABMCNT=0
 K ABMLN
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U,2)
 ;
 I +$G(ABMY("TVDTS"))'=0 D
 .S ABMCNT=0
 .S ABMDT=0
 .F  S ABMDT=$O(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT)) Q:'ABMDT  D
 ..;I ABMY("90")'="A"&(ABMY("SDT")'=ABMSDT) Q  ;abm*2.6*12 HEAT134048
 .I "^A^D^"'[("^"_ABMY("90")_"^")&(ABMY("SDT")'=ABMSDT) Q  ;only whole yr for auto ;abm*2.6*12 uncomp care
 .;start new abm*2.6*12 HEAT134048
 .S X1=ABMY("SDT")
 .S X2=275
 .D C^%DTC
 .I "^A^D^"[("^"_ABMY("90")_"^")&(ABMSDT>X) Q  ;275 days after start won't be 90 days anymore
 .;end new HEAT134048
 ..S ABMPRC($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT)),ABMCNT)=ABMDT
 .S ABMP=""
 .S ABMSAV=ABMCNT-ABMY("TVDTS")
 .F  S ABMP=$O(ABMPRC(ABMP)) Q:ABMP=""  D
 ..S ABMCNT=0,ABMC=0
 ..F  S ABMCNT=$O(ABMPRC(ABMP,ABMCNT)) Q:'ABMCNT  D  Q:(ABMC=ABMSAV)
 ...K ^XTMP("ABM-PVP2",$J,"PRV PERCENT",$G(ABMPRC(ABMP,ABMCNT))),ABMP("PRV")
 ...S ABMC=ABMC+1
 ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U,2)
 I +ABMSDT=0 S ABMSDT=ABMY("SDT")
 D HDR^ABMM2PV3
 W !,"The Patient Volume Threshold (30% for EPs, or 20% for Pediatricians) was not"
 W !,"met for the "_$S(("^A^B^C^"[("^"_ABMY("90")_"^")):"timeframe entered",1:"MU Qualification year")_"."
 W !,"Details for the volumes that were achieved are provided for your information.",!
 W !,"Highest Patient Volume Met: ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U)_"%"
 W !,"First Day Highest Patient Volume Achieved: ",$$SDT^ABMDUTL(ABMSDT)
 ;
 I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMTHPV=0
 S:ABMSDT ABMTHPV=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT))
 S ABMMHPV=0
 S:ABMSDT ABMMHPV=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM",ABMSDT))
 W !!,"Total Patient Encounters of First Highest Patient Volume Period: ",ABMTHPV,!
 S ABMU("TXT")="Total Medicaid"_$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")
 S ABMU("TXT")=ABMU("TXT")_" Encounters of First Highest Patient Volume Period: "_ABMMHPV
 S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 D ^ABMDWRAP
 D NMHDR^ABMM2PV5
 ;
 S ABMSDT=0,ABMCNT=0
 S ABMDTCNT=0
 F  S ABMSDT=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT)) Q:'ABMSDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I "^A^D^"'[("^"_ABMY("90")_"^")&(ABMY("SDT")'=ABMSDT) Q  ;only whole year for automated ;abm*2.6*12 uncomp care
 .;start new abm*2.6*12 HEAT134048
 .S X1=ABMY("SDT")
 .S X2=275
 .D C^%DTC
 .I "^A^D^"[("^"_ABMY("90")_"^")&(ABMSDT>X) Q  ;275 days after start won't be 90 days anymore
 .;end new HEAT134048
 .S ABMDTCNT=+$G(ABMDTCNT)+1
 .;
 .I $Y+5>IOSL D HD^ABMM2PV3,NMHDR^ABMM2PV5 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I +$G(ABMY("EDT"))=0 D
 ..S X1=ABMSDT
 ..S X2=89
 ..D C^%DTC
 ..S ABMEDT=X
 .I +$G(ABMY("EDT"))'=0 S ABMEDT=ABMY("EDT")
 .S ABMPD=$TR($P($$MDT^ABMDUTL(ABMSDT),"-",1,2),"-"," ")_"-"_$TR($P($$MDT^ABMDUTL(ABMEDT),"-",1,2),"-"," ")  ;rpt prd
 .S ABMRT=$J($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT)),5)_"%"  ;rate
 .S ABMDEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT)),6)  ;denom.
 .S ABMNUM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM",ABMSDT)),6)  ;num.
 .S ABMMCDPD=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"MCD")),6)
 .S ABMSCHPD=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"CHIP")),5)
 .S ABMMCDZP=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"MCD")),6)
 .S ABMMCDEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"MCD")),6)
 .S ABMSCHZP=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"CHIP")),5)
 .S ABMSCHEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP")),5)
 .;S ABMUNCOM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),6)  ;abm*2.6*12  ;abm*2.6*15
 .S ABMUNCOM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),4)  ;abm*2.6*12  ;abm*2.6*15
 .S ABMTSI=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,"TRIBSI")),2)  ;abm*2.6*15 HEAT183289
 .;W !,ABMPD,?15,ABMRT,?20,ABMDEN,?28,ABMNUM,?35,ABMMCDPD,?41,ABMMCDZP,?50,ABMMCDEN,?57,ABMSCHPD,?63,ABMSCHZP,?73,ABMSCHEN  ;abm*2.6*12
 .W !,ABMPD,?13,ABMRT,?20,ABMDEN,?27,ABMNUM,?34,ABMMCDPD,?41,ABMMCDZP,?48,ABMMCDEN,?55,ABMSCHPD,?62,ABMSCHZP,?67,ABMSCHEN  ;abm*2.6*12
 .;I ABMFQHC=1 W ?74,ABMUNCOM  ;abm*2.6*12  ;abm*2.6*15
 .I ABMFQHC=1 W ?74,ABMUNCOM,?78,ABMTSI  ;abm*2.6*15
  I ABMDTCNT=0 D
 .W !!, "<< NO DATA FOUND FOR SELECTION >>"
 Q
PATIENT ;EP
 D PATIENT^ABMM2P10  ;abm*2.6*15 split routine due to size
 Q
