ABMM2PV3 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12**;NOV 12, 2009;Build 187
 ;IHS/SD/SDR - 2.6*12 - Made changes for uncompensated care; uncompensated should be a separate detail line
 ;  and should be included in the patient volume total, not as a separate line.
 ;IHS/SD/SDR - 2.6*12 - Included numerator and msgs about numerator and denominator.
 ;
PRINT ;EP
 I ABMY("RTYP")="GRP" D GRPPRT^ABMM2PV4 Q
 S ABMPRV=0
 F  S ABMPRV=$O(ABMP(ABMPRV)) Q:'ABMPRV  D  D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMPMET=0
 .I ABMY("RFMT")="P" D PATIENT Q
 .I +$G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV))>29.5 S ABMPMET=1 D MET Q
 .I +$G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV))>19.5&($$DOCLASS^ABMDVST2(ABMPRV)["PEDIAT") S ABMPMET=1 D MET Q
 .D NOTMET
 K ^XTMP("ABM-PVP2",$J)
 Q
MET ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR
 I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMP("PRV")=0
 S ABMNUMT=0  ;abm*2.6*12
 F  S ABMP("PRV")=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"))) Q:'ABMP("PRV")  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I ABMP("PRV")'=ABMPRV Q
 .S ABMVLOC=0
 .F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"),ABMVLOC)) Q:'ABMVLOC  D
 ..I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
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
 ...;S ABMUNCOM=ABMTENC-ABMMPD-ABMMZPD-ABMMENR-ABMCPD-ABMCZPD-ABMCENR-ABMOTHPD ;abm*2.6*12 uncomp care
 ...;S ABMNUMER=ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+ABMUNCOM ;abm*2.6*12 uncomp care
 ...;S ABMUNCR=$S(+$G(ABMDENOM)>0:(ABMNUMER/ABMDENOM),1:0) ;abm*2.6*12 uncomp care
 ...;S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"UNCOMP")=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"UNCOMP"))+ABMUNCOM  ;abm*2.6*12 uncomp care
 ...S ABMUNCR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,ABMVLOC,"UNCOMP")) ;abm*2.6*12 uncomp care
 ..S ABMNUMT=+$G(ABMNUMT)+ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)  ;abm*2.6*12
 ..;
 ..W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT,ABMPRV,ABMVLOC)),U)_"%"
 ..;W:($G(ABMFQHC)=1) !,"Uncompensated Care "_ABMLOC_": ",$J(ABMUNCR*100,0,1)_"%"  ;abm*2.6*12 uncomp care
 ..;W !!,"Total Patient Encounters "_ABMLOC_": ",?70,$J(ABMTENC,8)  ;abm*2.6*12
 ..W !!,"Total Patient Encounters (Denominator) "_ABMLOC_": ",?70,$J(ABMTENC,8)  ;abm*2.6*12
 ..W !,"Total Numerator Encounters "_ABMLOC_": ",?70,$J((ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+$G(ABMUNCR)),8)  ;abm*2.6*12
 ..W !,"Total Medicaid Paid Encounters "_ABMLOC_": ",?70,$J(ABMMPD,8)
 ..W !,"Total Medicaid Zero Paid Encounters "_ABMLOC_": ",?70,$J(ABMMZPD,8)
 ..;W !,"Total Medicaid Enrolled Encounters "_ABMLOC_": ",?70,$J(ABMMENR,8)  ;abm*2.6*12
 ..W !,"Total Medicaid Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(ABMMENR,8)  ;abm*2.6*12
 ..W !,"Total Kidscare/Chip Paid Encounters "_ABMLOC_": ",?70,$J(ABMCPD,8)
 ..W !,"Total Kidscare/Chip Zero Paid Encounters "_ABMLOC_": ",?70,$J(ABMCZPD,8)
 ..;W !,"Total Kidscare/Chip Enrolled Encounters "_ABMLOC_": ",?70,$J(ABMCENR,8)  ;abm*2.6*12
 ..W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters "_ABMLOC_": ",?70,$J(ABMCENR,8)  ;abm*2.6*12
 ..;W !,"Total Paid Other Encounters "_ABMLOC_": ",?70,$J(ABMOTHPD,8)  ;abm*2.6*12
 ..W !,"Total Paid Other Encounters "_ABMLOC_" (*not included in numerator): ",?70,$J(ABMOTHPD,8)  ;abm*2.6*12
 ..W:($G(ABMFQHC)=1) !,"Total Uncompensated Care "_ABMLOC_": ",?70,$J(ABMUNCR,8)  ;abm*2.6*12 uncomp care
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U)_"%"
 ;W:($G(ABMFQHC)=1) !,"Uncompensated Care: ",$J(ABMTUNCR*100,0,1)_"%"  ;abm*2.6*12 uncomp care
 ;W !!,"Total Patient Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV)),8)  ;abm*2.6*12
 W !!,"Total Patient Encounters (Denominator) All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV)),8)  ;abm*2.6*12
 W !,"Total Numerator Encounters All Facilities Total: ",?70,$J(ABMNUMT,8)  ;abm*2.6*12
 W !,"Total Medicaid Paid Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"MCD")),8)
 W !,"Total Medicaid Zero Paid Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"MCD")),8)
 ;W !,"Total Medicaid Enrolled Medicaid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD")),8)  ;abm*2.6*12
 W !,"Total Medicaid Enrolled (Not Billed) Medicaid Encounters All Facs: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD")),8)  ;abm*2.6*12
 W !,"Total Kidcare/Chip Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"CHIP")),8)
 W !,"Total Kidcare/Chip Zero Paid Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"CHIP")),8)
 ;W !,"Total Kidscare/Chip Enrolled Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"CHIP")),8)  ;abm*2.6*12
 W !,"Total Kidscare/Chip Enrolled (Not Billed) Encounters All Facs Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"CHIP")),8)  ;abm*2.6*12
 ;W !,"Total Paid Other Encounters All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"OTHR")),8)  ;abm*2.6*12
 W !,"Total Paid Other Encounters All Facs (*not included in numerator): ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"OTHR")),8)  ;abm*2.6*12
 W:($G(ABMFQHC)=1) !,"Total Uncompensated Care All Facilities Total: ",?70,$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,"UNCOMP")),8)  ;abm*2.6*12 uncomp care
 W !
 Q
NOTMET ;EP
 D NOTMET^ABMM2PV5
 Q
PATIENT  ;EP
 I ABMY("RFMT")="P",$G(ABMFN)'="" D PTHSTFL Q
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC)) Q:'ABMVLOC  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .D PTHDR
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ......S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,0))
 ......S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 ......S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 ......S IENS=ABMVLOC_","_ABMPT_","
 ......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 ......W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 ......W ?18,ABMHRN  ;HRN
 ......W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Category
 ......W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clinic
 ......W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 ......W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 ......W ?53,$$CDT^ABMDUTL(ABMVDT)  ;visit date
 ......W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 ......I $P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 ......I $Y+5>IOSL D HD,PTHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 Q
PTHSTFL ;EP
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 K ABMDCNT
 D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 Q:POP
 U IO
 S ABM("PG")=1
 D HDR
 W !,"Visit Location"_U_"Patient"_U_"Chart#"_U_"Policy Holder ID"_U_"Serv Cat"_U_"Clinic"_U_"Provider"_U_"InsType"_U_"BilledTo"
 W U_"DateOfService"_U_"DatePaid"_U_"Medicaid/SchipPaid"_U_"Bill#"_U_"Payment"_U_"Primary POV"_U_"PRVT"_U_"MCR"_U_"MCD"_U_"CHIP"_U_"Needy Indiv."
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC)) Q:'ABMVLOC  D
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D
 ......S ABMP("VDT")=ABMVDT
 ......S ABMVDFN=0
 ......F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D
 .......I +$G(^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN))=1 S ABMDCNT=+$G(ABMDCNT)+1
 .......S ^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN)=1
 .......S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .......S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .......S IENS=ABMVLOC_","_ABMPT_","
 .......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .......W !,$$GET1^DIQ(9999999.06,ABMVLOC,".02","E")
 .......W U_ABMPTL_", "_ABMPTF  ;pt name
 .......W U_ABMHRN  ;HRN
 .......K ABML
 .......D ELGCHK
 .......S ABMMIEN=0
 .......K ABMMCDN
 .......I ($G(ABML("MCD"))!($G(ABML("CHIP")))) D
 ........S ABMMIEN=+$G(ABMP("SAVE"))
 ........I ABMMIEN D
 .........S ABMMCDN=$P($G(^AUPNMCD(ABMMIEN,0)),U,3)
 ........I 'ABMMIEN D PRVTCHIP
 .......I $G(ABMMCDN)'="" W U_ABMMCDN  ;Medicaid # - policy holder ID
 .......I 'ABMMIEN W U
 .......W U_$$GET1^DIQ(9000010,ABMVDFN,.07,"E")  ;Category
 .......W U_$$GET1^DIQ(9000010,ABMVDFN,.08,"E")  ;clinic
 .......W U_$S($P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U),1:"")   ;provider NPI
 .......W U_$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 .......W U_$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 .......W U_$$CDT^ABMDUTL(ABMVDT)  ;visit date
 .......W U_$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 .......S ABMREC=$G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN))
 .......D ELGCHK
 .......W U_$P($G(ABMREC),U,4)
 .......W U_$P($G(ABMREC),U,5)
 .......W U_$P($G(ABMREC),U,6)
 .......W U_$P($G(ABMREC),U,7)
 .......W U_ABMPI_U_ABMMCR_U_ABMMCD_U_ABMCHIP_U_ABMNI
 I +$G(ABMDCNT)>0 W !!,"Duplicate visits for this period: "_ABMDCNT
 D CLOSE^%ZISH("ABM")
 Q
PRVTCHIP ;
 S ABMMIEN=0
 S ABMFINS=0
 F  S ABMMIEN=$O(^AUPNPRVT(ABMPT,11,ABMMIEN)) Q:'ABMMIEN  D  Q:ABMFINS
 .Q:'$D(ABMI("INS",$P($G(^AUPNPRVT(ABMPT,11,ABMMIEN,0)),U)))
 .S ABMFINS=1
 .S IENS=ABMMIEN_","_ABMPT_","
 .S ABMMCDN=$$GET1^DIQ(9000006.11,IENS,21)
 .S:ABMMCDN="" ABMMCDN=$$GET1^DIQ(9000003.1,$P($G(^AUPNPRVT(ABMPT,11,ABMMIEN,0)),U,8),".04")
 Q
PTHDR    ;
 I IOST["C",(ABM("PG")=1) D HD  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;start data on 2nd page of report
 W !,"VISIT LOCATION: ",$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E"),!
 F ABM=1:1:80 W "="
 W !,?25,"Ser",?39,"I.",?42,"Billed",?53,"Date of",?70,"Date"
 W !,"PATIENT NAME",?18,"CHART#",?25,"Cat",?29,"Clinic",?39,"T.",?42,"To",?53,"Service",?70,"Paid",!
 F ABM=1:1:80 W "="
 Q
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("PG")=+$G(ABM("PG"))+1
HDR      ;EP
 D HDR^ABMM2PV5
 Q
ELGCHK ;EP
 S ABML=""
 D ELIG^ABMM2PV8
 S (ABMMCR,ABMMCD,ABMPI,ABMCHIP,ABMNI)="N"
 S ABMIT=""
 F  S ABMIT=$O(ABMK(ABMIT)) Q:ABMIT=""  D
 .I ABMIT="I"!(ABMIT="N") Q  ;don't count ben and non-ben
 .I "^R^MH^MD^MC^MMC^"[("^"_ABMIT_"^") S ABMMCR="Y"
 .I ABMIT="D"!(ABMIT="FPL") S ABMMCD="Y"
 .I (ABMIT="K")!($D(ABMI("INS",ABMINS))) S ABMCHIP="Y"
 .;I (("^D^FPL^K^R^MH^MD^MC^MMC^"'[("^"_ABMIT_"^"))&('(ABMIT="P"&($D(ABMI("INS",ABMINS)))))) S ABMPI="Y"
 .I (("^D^FPL^K^R^MH^MD^MC^MMC^"'[("^"_ABMIT_"^"))&('($D(ABMI("INS",ABMINS))))) S ABMPI="Y"
 I ABMMCD="Y"&(ABMCHIP="Y") S ABMMCD="N"  ;can't cnt in both
 I ABMMCR="N",ABMMCD="N",ABMPI="N",ABMCHIP="N" S ABMNI="Y"
 Q
