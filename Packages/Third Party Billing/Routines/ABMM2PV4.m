ABMM2PV4 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12**;NOV 12, 2009;Build 187
 ;IHS/SD/SDR - 2.6*12 - Made changes for uncomp care; uncomp should be a separate detail line
 ;  and should be included in pt vol total, not as separate line
 ;IHS/SD/SDR - 2.6*12 - Included numerator and msgs about numerator, denominator
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
 .S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)
 .;end new abm*2.6*12
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"UNCOMP")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"UNCOMP"))+$G(ABMUNCOM)  ;abm*2.6*12 uncomp care
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"UNCOMP")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"UNCOMP"))+$G(ABMUNCOM)  ;abm*2.6*12 uncomp care
 .W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT,ABMVLOC)),U)_"%"
 .W !!,"Total Patient Encounters (Denominator) "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMVLOC)),8)
 .W !,"Total Numerator Encounters "_ABMLOC_": ",?70,$J((ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)),8)
 .W !,"Total Medicaid Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Medicaid Zero Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Medicaid Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Kidscare/Chip Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Kidscare/Chip Zero Paid Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Paid Other Encounters "_ABMLOC_" (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"OTHR")),8)
 .W:($G(ABMFQHC)=1) !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)  ;abm*2.6*12 uncomp care
 ;
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U)_"%"
 W !!,"Total Patient Encounters (Denominator) All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT)),8)
 W !,"Total Numerator Encounters All Facilities Total: ",?70,$J(ABMNUMT,8)
 W !,"Total Medicaid Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"MCD")),8)
 W !,"Total Medicaid Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"MCD")),8)
 W !,"Total Medicaid Enrolled (Not Billed) Encounters All Facs Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"MCD")),8)  ;abm*2.6*12
 W !,"Total Kidcare/Chip Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"CHIP")),8)
 W !,"Total Kidcare/Chip Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"CHIP")),8)
 ;W !,"Total Kidscare/Chip Enrolled Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP")),8)  ;abm*2.6*12
 W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters All Facs: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP")),8)  ;abm*2.6*12
 W !,"Total Paid Other Encounters All Fac. (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"OTHR")),8)  ;abm*2.6*12
 W:($G(ABMFQHC)=1) !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),8)  ;abm*2.6*12 uncomp care
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
 .S ABMUNCOM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,"UNCOMP")),6)  ;abm*2.6*12
 .;W !,ABMPD,?15,ABMRT,?20,ABMDEN,?28,ABMNUM,?35,ABMMCDPD,?41,ABMMCDZP,?50,ABMMCDEN,?57,ABMSCHPD,?63,ABMSCHZP,?73,ABMSCHEN  ;abm*2.6*12
 .W !,ABMPD,?13,ABMRT,?20,ABMDEN,?27,ABMNUM,?34,ABMMCDPD,?41,ABMMCDZP,?48,ABMMCDEN,?55,ABMSCHPD,?62,ABMSCHZP,?67,ABMSCHEN  ;abm*2.6*12
 .I ABMFQHC=1 W ?74,ABMUNCOM  ;abm*2.6*12
 I ABMDTCNT=0 D
 .W !!, "<< NO DATA FOUND FOR SELECTION >>"
 Q
PATIENT ;EP
 I ABMY("RFMT")="P",$G(ABMFN)'="" D PTHSTFL Q
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U,2)
 D HDR^ABMM2PV3
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC)) Q:'ABMVLOC  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .D PTHDR^ABMM2PV3
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ......S ABMVDFN=0
 ......F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .......S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .......S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .......S IENS=ABMVLOC_","_ABMPT_","
 .......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .......W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 .......W ?18,ABMHRN  ;HRN
 .......W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Cat
 .......W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clin
 .......W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;itype
 .......W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;ins
 .......W ?53,$$CDT^ABMDUTL(ABMVDT)  ;vst dt
 .......W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt pd
 .......I $P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 .......I $Y+5>IOSL D HD^ABMM2PV3,PTHDR^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 Q
PTHSTFL ;EP
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP")),U,2)
 K ABMDCNT
 D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 Q:POP
 U IO
 S ABM("PG")=1
 D HDR^ABMM2PV3
 W !,"Visit Location"_U_"Patient"_U_"Chart#"_U_"Policy Holder ID"_U_"Serv Cat"_U_"Clinic"_U_"InsType"_U_"BilledTo"
 W U_"DateOfService"_U_"DatePaid"_U_"Medicaid/SchipPaid"_U_"Bill#"_U_"Payment"_U_"Primary POV"_U_"PRVT"_U_"MCR"_U_"MCD"_U_"CHIP"_U_"NEEDY INDIV"
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC)) Q:'ABMVLOC  D
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D
 ......S ABMP("VDT")=ABMVDT
 ......S ABMVDFN=0
 ......F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D
 .......I +$G(^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN))=1 S ABMDCNT=+$G(ABMDCNT)+1
 .......S ^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN)=1
 .......S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .......S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .......S IENS=ABMVLOC_","_ABMPT_","
 .......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .......W !,$$GET1^DIQ(9999999.06,ABMVLOC,".02","E")
 .......W U_ABMPTL_", "_ABMPTF  ;pt name
 .......W U_ABMHRN  ;HRN
 .......K ABML
 .......D ELGCHK^ABMM2PV3
 .......S ABMMIEN=0
 .......K ABMMCDN
 .......I ($G(ABML("MCD"))!($G(ABML("CHIP")))) D
 ........S ABMMIEN=+$G(ABMP("SAVE"))
 ........I ABMMIEN D
 .........S ABMMCDN=$P($G(^AUPNMCD(ABMMIEN,0)),U,3)
 ........I 'ABMMIEN D PRVTCHIP^ABMM2PV3
 .......I $G(ABMMCDN)'="" W U_ABMMCDN  ;Medicaid # - policy holder ID
 .......I 'ABMMIEN W U
 .......W U_$$GET1^DIQ(9000010,ABMVDFN,.07,"E")  ;Cat
 .......W U_$$GET1^DIQ(9000010,ABMVDFN,.08,"E")  ;clin
 .......W U_$S(ABMITYP="X":"",1:ABMITYP)  ;itype
 .......W U_$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 .......W U_$$CDT^ABMDUTL(ABMVDT)  ;vst dt
 .......W U_$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt pd
 .......S ABMREC=$G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN))
 .......D ELGCHK^ABMM2PV3
 .......W U_$P($G(ABMREC),U,4)
 .......W U_$P($G(ABMREC),U,5)
 .......W U_$P($G(ABMREC),U,6)
 .......W U_$P($G(ABMREC),U,7)
 .......W U_ABMPI_U_ABMMCR_U_ABMMCD_U_ABMCHIP_U_ABMNI
 I +$G(ABMDCNT)>0 W !!,"Duplicate visits for this period: "_ABMDCNT
 D CLOSE^%ZISH("ABM")
 Q
