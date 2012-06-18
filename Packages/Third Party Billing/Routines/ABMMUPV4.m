ABMMUPV4 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;
GRPPRT ;EP
 I ABMY("RFMT")="P" D PATIENT Q
 I +$G(^XTMP("ABM-PVP",$J,"PRV TOP"))>29.99 S ABMPMET=1 D MET Q
 D NOTMET
 K ^XTMP("ABM-PVP",$J)
 Q
MET ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U,2)
 D HDR^ABMMUPV3
 D MHDR^ABMMUPV3
 I $Y+5>IOSL D HD^ABMMUPV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMVLOC)) Q:'ABMVLOC  D
 .I $Y+5>IOSL D HD^ABMMUPV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .F ABM=1:1:80 W "-"
 .S ABMLOC=$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E")
 .W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMSDT,ABMVLOC)),U)_"%"
 .W !!,"Total Patient Encounters "_ABMLOC_": ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMVLOC)),8)
 .W !,"Total Paid Medicaid Encounters "_ABMLOC_": ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"MCD")),8)
 .W !,"Total Paid Kidscare/Chip Encounters "_ABMLOC_": ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"CHIP")),8)
 .W !,"Total Paid Other Encounters "_ABMLOC_": ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMVLOC,"OTHR")),8),!
 ;
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U)_"%"
 W !!,"Total Patient Encounters All Facilities Total: ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT)),8)
 W !,"Total Paid Medicaid Encounters All Facilities Total: ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,"MCD")),8)
 W !,"Total Paid Kidscare/Chip Encounters All Facilities Total: ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,"CHIP")),8)
 W !,"Total Paid Other Encounters All Facilities Total: ",?60,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,"OTHR")),8)
 W !
 Q
NOTMET ;EP
 S ABMCNT=0
 K ABMLN
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U,2)
 ;
 I +$G(ABMY("TVDTS"))'=0 D
 .S ABMCNT=0
 .S ABMDT=0
 .F  S ABMDT=$O(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMDT)) Q:'ABMDT  D
 ..S ABMPRC($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMDT)),ABMCNT)=ABMDT
 .S ABMP=""
 .S ABMSAV=ABMCNT-ABMY("TVDTS")
 .F  S ABMP=$O(ABMPRC(ABMP)) Q:ABMP=""  D
 ..S ABMCNT=0,ABMC=0
 ..F  S ABMCNT=$O(ABMPRC(ABMP,ABMCNT)) Q:'ABMCNT  D  Q:(ABMC=ABMSAV)
 ...K ^XTMP("ABM-PVP",$J,"PRV PERCENT",$G(ABMPRC(ABMP,ABMCNT))),ABMP("PRV")
 ...S ABMC=ABMC+1
 ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U,2)
 I +ABMSDT=0 S ABMSDT=ABMY("SDT")
 D HDR^ABMMUPV3
 W !,"The Patient Volume Threshold (30% for EPs, or 20% for Pediatricians) was not"
 W !,"met for the MU Qualification year."
 W !,"Details for the volumes that were achieved are provided for your information.",!
 W !,"Highest Patient Volume Met: ",+$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U)_"%"
 W !,"First Day Highest Patient Volume Achieved: ",$$SDT^ABMDUTL(ABMSDT)
 W !!,"Patient Volume for the Qualification Year was calculated using the Medicaid"
 W !,$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")_" calculation method."
 ;
 S ABMTHPV=0
 S:ABMSDT ABMTHPV=+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT))
 S ABMMHPV=0
 S:ABMSDT ABMMHPV=+$G(^XTMP("ABM-PVP",$J,"PRV-NUM",ABMSDT))
 W !!,"Total Patient Encounters of First Highest Patient Volume Period: ",ABMTHPV,!
 S ABMU("TXT")="Total Medicaid"_$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")
 S ABMU("TXT")=ABMU("TXT")_" Encounters of First Highest Patient Volume Period: "_ABMMHPV
 S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 D ^ABMDWRAP
 D NMHDR^ABMMUPV3
 ;
 S ABMSDT=0,ABMCNT=0
 F  S ABMSDT=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT)) Q:'ABMSDT  D
 .;
 .;start old code abm*2.6*8 NOHEAT
 .;S X1=ABMSDT
 .;S X2=89
 .;D C^%DTC
 .;S ABMEDT=X
 .;end old code start new code
 .I +$G(ABMY("EDT"))=0 D
 ..S X1=ABMSDT
 ..S X2=89
 ..D C^%DTC
 ..S ABMEDT=X
 .I +$G(ABMY("EDT"))'=0 S ABMEDT=ABMY("EDT")
 .;end new code
 .S ABMCNT=ABMCNT+1
 .S ABMLN(ABMCNT)=$TR($P($$MDT^ABMDUTL(ABMSDT),"-",1,2),"-"," ")_" - "_$TR($P($$MDT^ABMDUTL(ABMEDT),"-",1,2),"-"," ")  ;report period
 .S $P(ABMLN(ABMCNT),U,2)=$J($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMSDT)),3)_"%"  ;rate
 .S $P(ABMLN(ABMCNT),U,3)=$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT)),6)  ;denominator
 .S $P(ABMLN(ABMCNT),U,4)=$J(+$G(^XTMP("ABM-PVP",$J,"PRV-NUM",ABMSDT)),6)  ;numerator
 S ABMCUTOF=$S(ABMCNT#2=1:(ABMCNT+1)\2,1:ABMCNT\2)
 S ABMMCNT=1
 F ABMCUTOF=(ABMCUTOF+1):1:ABMCNT D
 .S ABMLN(ABMMCNT)=ABMLN(ABMMCNT)_U_ABMLN(ABMCUTOF)
 .K ABMLN(ABMCUTOF)
 .S ABMMCNT=+$G(ABMMCNT)+1
 S ABMCNT=0
 F  S ABMCNT=$O(ABMLN(ABMCNT)) Q:'ABMCNT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD^ABMMUPV3,NMHDR^ABMMUPV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMPD=$P(ABMLN(ABMCNT),U)
 .S ABMRT=$P(ABMLN(ABMCNT),U,2)
 .S ABMDEN=$P(ABMLN(ABMCNT),U,3)
 .S ABMNUM=$P(ABMLN(ABMCNT),U,4)
 .S ABMPD2=$P(ABMLN(ABMCNT),U,5)
 .S ABMRT2=$P(ABMLN(ABMCNT),U,6)
 .S ABMDEN2=$P(ABMLN(ABMCNT),U,7)
 .S ABMNUM2=$P(ABMLN(ABMCNT),U,8)
 .W !,ABMPD,?16,ABMRT,?21,ABMDEN,?29,ABMNUM,?40,ABMPD2,?56,ABMRT2,?63,ABMDEN2,?71,ABMNUM2
 Q
PATIENT ;EP
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP")),U,2)
 D HDR^ABMMUPV3
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC)) Q:'ABMVLOC  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .D PTHDR^ABMMUPV3
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ......S ABMVDFN=0
 ......F  S ABMVDFN=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .......S ABMPT=$P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .......S ABMTRIEN=$P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .......S IENS=ABMVLOC_","_ABMPT_","
 .......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .......W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 .......W ?18,ABMHRN  ;HRN
 .......W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Category
 .......W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clinic
 .......W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 .......W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 .......W ?53,$$CDT^ABMDUTL(ABMVDT)  ;visit date
 .......W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 .......I $P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 .......I $Y+5>IOSL D HD^ABMMUPV3,PTHDR^ABMMUPV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 Q
