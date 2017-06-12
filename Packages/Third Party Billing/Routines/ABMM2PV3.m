ABMM2PV3 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,15**;NOV 12, 2009;Build 251
 ;IHS/SD/SDR 2.6*12 - Uncomp'd should be a separate detail line and s/be incl. in pt vol total, not as separate line.
 ;IHS/SD/SDR 2.6*12 - Incl. numer and msgs about numer. and denom.
 ;IHS/SD/SDR 2.6*15 - HEAT161159 - Changed PT LST to sort differently so there won't be duplicate vsts on pt lst.  Also made
 ;   change so it will correctly rpt category for pt on pt lst, and added record indicator.
 ;IHS/SD/SDR 2.6*15 - HEAT171490 - Added fac NPI and TIN to pt list host file
 ;IHS/SD/SDR 2.6*15 - HEAT183289 - Made changes to print tribal self-insured summary line
 ;IHS/SD/SDR 2.6*15 - Rearranged code so all prvs would print in HFS file instead of just first one
 ;IHS/SD/SDR 2.6*15 - HEAT188548 - Format vst dt to 4 digits
 ;IHS/SD/SDR 2.6*15 - If pt has MCD and CHIP and user runs report excluding CHIP, it will flag both so it can be counted in
 ;   MCD enrolled; if they include CHIP it flags CHIP only so it doesn't get confusing.
 ;
PRINT ;EP
 I ABMY("RTYP")="GRP" D GRPPRT^ABMM2PV4 Q
 ;start new abm*2.6*15
 ;Write all providers, not just first, to HFS file
 I ABMY("RFMT")="P",$G(ABMFN)'="" D  Q
 .D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .Q:POP
 .U IO
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMP(ABMPRV)) Q:'ABMPRV  D  D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..S ABMPMET=0
 ..D PTHSTFL
 .;
 .D CLOSE^%ZISH("ABM")
 ;end new abm*2.6*15
 ;
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
 D MET^ABMM2PV9  ;split routine due to size
 Q
NOTMET ;EP
 D NOTMET^ABMM2PV5
 Q
PATIENT  ;EP
 ;I ABMY("RFMT")="P",$G(ABMFN)'="" D PTHSTFL Q  ;abm*2.6*15 - was only printing first provider selected this way
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC)) Q:'ABMVLOC  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .D PTHDR
 .;start old abm*2.6*15 HEAT161159
 .;S ABMITYP=""
 .;F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;.S ABMINS=""
 .;.F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;..S ABMPTL=""
 .;..F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;...S ABMPTF=""
 .;...F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;....S ABMVDT=0
 .;....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;.....S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,0))
 .;.....S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .;.....S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .;.....S IENS=ABMVLOC_","_ABMPT_","
 .;.....S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .;.....W !,$E(ABMPTL_", "_ABMPTF,1,16)
 .;.....W ?18,ABMHRN
 .;.....W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)
 .;.....W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)
 .;.....W ?39,$S(ABMITYP="X":"",1:ABMITYP)
 .;.....W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))
 .;.....W ?53,$$CDT^ABMDUTL(ABMVDT)
 .;.....W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"")
 .;.....I $P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 .;.....I $Y+5>IOSL D HD,PTHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .;end old start new HEAT161159
 .S ABMVDT=0
 .F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,2)
 ...S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,3)
 ...S ABMINS=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,5)
 ...S IENS=ABMVLOC_","_ABMPT_","
 ...S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 ...S ABMPTL=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,10)
 ...S ABMPTF=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,11)
 ...W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 ...W ?18,ABMHRN  ;HRN
 ...W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Category
 ...W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clinic
 ...W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 ...W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 ...W ?53,$$CDT^ABMDUTL(ABMVDT)  ;visit date
 ...W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 ...I $P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 ...I $Y+5>IOSL D HD,PTHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ;end new HEAT161159
 Q
PTHSTFL ;EP
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 K ABMDCNT
 ;start old abm*2.6*15 moved up so all providers will print in one HFS file
 ;D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 ;Q:POP
 ;U IO
 ;end old abm*2.6*15
 S ABM("PG")=1
 D HDR
 W !,"Visit Location"_U_"Patient"_U_"Chart#"_U_"Policy Holder ID"_U_"Serv Cat"_U_"Clinic"_U_"Provider NPI"_U_"InsType"_U_"BilledTo"
 W U_"DateOfService"_U_"DatePaid"_U_"Medicaid/SchipPaid"_U_"Bill#"_U_"Payment"_U_"Primary POV"_U_"PRVT"_U_"MCR"_U_"MCD"_U_"CHIP"_U_"Needy Indiv."
 W U_"Tribal self-insured"  ;abm*2.6*15 HEAT183289
 W U_"MCD ST"  ;abm*2.6*15 HEAT164125
 W U_"Facility NPI"_U_"Facility TIN"_U_"Record Indicator"  ;abm*2.6*15 HEAT171490 and HEAT161159
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC)) Q:'ABMVLOC  D
 .;start old abm*2.6*15 HEAT161159
 .;S ABMITYP=""
 .;F  S ABMITYP=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D
 .;.S ABMINS=""
 .;.F  S ABMINS=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D
 .;..S ABMPTL=""
 .;..F  S ABMPTL=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D
 .;...S ABMPTF=""
 .;...F  S ABMPTF=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D
 .;....S ABMVDT=0
 .;....F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D
 .;.....S ABMP("VDT")=ABMVDT
 .;.....S ABMVDFN=0
 .;.....F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D
 .;......I +$G(^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN))=1 S ABMDCNT=+$G(ABMDCNT)+1
 .;......S ^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN)=1
 .;......S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 .;......S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 .;......S IENS=ABMVLOC_","_ABMPT_","
 .;......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 .;......W !,$$GET1^DIQ(9999999.06,ABMVLOC,".02","E")
 .;......W U_ABMPTL_", "_ABMPTF
 .;......W U_ABMHRN
 .;......K ABML
 .;......D ELGCHK
 .;......S ABMMIEN=0
 .;......K ABMMCDN
 .;......I ($G(ABML("MCD"))!($G(ABML("CHIP")))) D
 .;.......S ABMMIEN=+$G(ABMP("SAVE"))
 .;.......I ABMMIEN D
 .;........S ABMMCDN=$P($G(^AUPNMCD(ABMMIEN,0)),U,3)
 .;.......I 'ABMMIEN D PRVTCHIP
 .;......I $G(ABMMCDN)'="" W U_ABMMCDN  ;Medicaid # - policy holder ID
 .;......I 'ABMMIEN W U
 .;......W U_$$GET1^DIQ(9000010,ABMVDFN,.07,"E")  ;Category
 .;......W U_$$GET1^DIQ(9000010,ABMVDFN,.08,"E")  ;clinic
 .;......W U_$S($P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U),1:"")   ;provider NPI
 .;......W U_$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 .;......W U_$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 .;......W U_$$CDT^ABMDUTL(ABMVDT)  ;visit date
 .;......W U_$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 .;......S ABMREC=$G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN))
 .;......D ELGCHK
 .;......W U_$P($G(ABMREC),U,4)
 .;......W U_$P($G(ABMREC),U,5)
 .;......W U_$P($G(ABMREC),U,6)
 .;......W U_$P($G(ABMREC),U,7)
 .;......W U_ABMPI_U_ABMMCR_U_ABMMCD_U_ABMCHIP_U_ABMNI
 .;end old start new HEAT161159
 .S ABMVDT=0
 .F  S ABMVDT=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT)) Q:'ABMVDT  D
 ..S ABMP("VDT")=ABMVDT
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D
 ...I +$G(^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN))=1 S ABMDCNT=+$G(ABMDCNT)+1
 ...S ^XTMP("ABM-PVP2",$J,"DUPS",ABMVDFN)=1
 ...S ABMPT=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,2)
 ...S ABMTRIEN=$P($G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN)),U,3)
 ...S ABMREC=$G(^XTMP("ABM-PVP2",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMVDT,ABMVDFN))
 ...S ABMITYP=$P(ABMREC,U,8)
 ...S ABMINS=$P(ABMREC,U,9)
 ...S ABMPTL=$P(ABMREC,U,10)
 ...S ABMPTF=$P(ABMREC,U,11)
 ...S IENS=ABMVLOC_","_ABMPT_","
 ...S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 ...W !,$$GET1^DIQ(9999999.06,ABMVLOC,".02","E")
 ...W U_ABMPTL_", "_ABMPTF  ;pt name
 ...W U_ABMHRN  ;HRN
 ...K ABML
 ...D ELGCHK
 ...S ABMMIEN=0
 ...K ABMMCDN
 ...I ($G(ABML("MCD"))!($G(ABML("CHIP")))) D
 ....S ABMMIEN=+$G(ABMP("SAVE"))
 ....I ABMMIEN D
 .....S ABMMCDN=$P($G(^AUPNMCD(ABMMIEN,0)),U,3)
 ....I 'ABMMIEN D PRVTCHIP
 ...I $G(ABMMCDN)'="" W U_ABMMCDN  ;Medicaid # - policy holder ID
 ...I 'ABMMIEN W U
 ...W U_$$GET1^DIQ(9000010,ABMVDFN,.07,"E")  ;Category
 ...W U_$$GET1^DIQ(9000010,ABMVDFN,.08,"E")  ;clinic
 ...W U_$S($P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABMPRV),U),1:"")   ;provider NPI
 ...W U_$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 ...W U_$S(ABMINS="NO BILL":"NOT BILLED",1:ABMINS)  ;insurer
 ...;W U_$$CDT^ABMDUTL(ABMVDT)  ;visit date  ;abm*2.6*15 HEAT188548
 ...W U_$$BDT^ABMDUTL(ABMVDT)  ;visit date  ;abm*2.6*15 HEAT188548
 ...W U_$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 ...K ABMPI,ABMMCR,ABMMCD,ABMCHIP,ABMNI  ;abm*2.6*15 HEAT161159
 ...D ELGCHK
 ...W U_$P($G(ABMREC),U,4)
 ...W U_$P($G(ABMREC),U,5)
 ...W U_$P($G(ABMREC),U,6)
 ...W U_$P($G(ABMREC),U,7)
 ...;W U_ABMPI_U_ABMMCR_U_ABMMCD_U_ABMCHIP_U_ABMNI  ;abm*2.6*15 HEAT183289
 ...W U_ABMPI_U_ABMMCR_U_ABMMCD_U_ABMCHIP_U_ABMNI_U_$G(ABMTSI)  ;abm*2.6*15 HEAT183289
 ...W U_$G(ABMP("STATE"))  ;abm*2.6*15 HEAT164125
 ...W U_$P(ABMREC,U,13)  ;visit location NPI abm*2.6*15 HEAT171490
 ...W U_$P(ABMREC,U,14)  ;visit location TIN abm*2.6*15 HEAT171490
 ...W U_$P(ABMREC,U,15)  ;record indicator  abm*2.6*15 HEAT161159
 ...;start new abm*2.6*15 HEAT183289
 ...I +$G(ABMFQHC)=1 D
 ....I +$G(ABMICNT)=1&($G(ABMTSI)="Y") D
 .....W "TSI"  ;write TSI if pt has TSI insurer only
 .....I +$P($G(ABMREC),U,6)'=0 W "-PD"  ;if TSI insurer paid
 ....I $G(ABMNI)="Y" W "UNC"  ;write UNC if pt is needy individual
 ...;end new HEAT183289
 ;end new HEAT161159
 I +$G(ABMDCNT)>0 W !!,"Duplicate visits for this period: "_ABMDCNT
 ;D CLOSE^%ZISH("ABM")  ;abm*2.6*15 moved up so all providers will print in one file
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
 S (ABMMCR,ABMMCD,ABMPI,ABMCHIP,ABMNI)="N"  ;abm*2.6*15
 ;start old abm*2.6*15 HEAT161159
 ;S ABMIT=""
 ;F  S ABMIT=$O(ABMK(ABMIT)) Q:ABMIT=""  D
 ;.I ABMIT="I"!(ABMIT="N") Q  ;don't count ben and non-ben
 ;.I "^R^MH^MD^MC^MMC^"[("^"_ABMIT_"^") S ABMMCR="Y"
 ;.I ABMIT="D"!(ABMIT="FPL") S ABMMCD="Y"
 ;.I (ABMIT="K")!($D(ABMI("INS",ABMINS))) S ABMCHIP="Y"
 ;.;I (("^D^FPL^K^R^MH^MD^MC^MMC^"'[("^"_ABMIT_"^"))&('(ABMIT="P"&($D(ABMI("INS",ABMINS)))))) S ABMPI="Y"
 ;.I (("^D^FPL^K^R^MH^MD^MC^MMC^"'[("^"_ABMIT_"^"))&('($D(ABMI("INS",ABMINS))))) S ABMPI="Y"
 ;I ABMMCD="Y"&(ABMCHIP="Y") S ABMMCD="N"  ;can't cnt in both
 ;I ABMMCR="N",ABMMCD="N",ABMPI="N",ABMCHIP="N" S ABMNI="Y"
 ;end old start new HEAT161159
 S ABMJ("INS")=0
 F  S ABMJ("INS")=$O(ABMILST(ABMJ("INS"))) Q:'ABMJ("INS")  D
 .S ABMIT=$G(ABMILST(ABMJ("INS")))
 .I ABMIT="I"!(ABMIT="N") Q  ;don't count ben and non-ben
 .I "^R^MH^MD^MC^MMC^"[("^"_ABMIT_"^") S ABMMCR="Y"
 .;I ABMIT="D"!(ABMIT="FPL") S ABMMCD="Y"
 .I ABMIT="D" S ABMMCD="Y",ABMP("STATE")=$G(ABMILST("STATE",ABMJ("INS")))
 .I (ABMIT="K")!($D(ABMI("INS",ABMJ("INS")))) S ABMCHIP="Y"
 .I (("^D^K^R^MH^MD^MC^MMC^"'[("^"_ABMIT_"^"))&('($D(ABMI("INS",ABMJ("INS")))))) S ABMPI="Y"
 ;I ABMMCD="Y"&(ABMCHIP="Y") S ABMMCD="N"  ;can't cnt in both  ;abm*2.6*15
 I ABMMCD="Y"&(ABMCHIP="Y")&($D(ABMI("INS"))) S ABMMCD="N"  ;can't cnt in both if counting CHIP  ;abm*2.6*15
 I ABMMCR="N",ABMMCD="N",ABMPI="N",ABMCHIP="N" S ABMNI="Y"
 ;end new HEAT161159
 Q
