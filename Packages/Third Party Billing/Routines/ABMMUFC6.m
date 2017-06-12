ABMMUFC6 ;IHS/SD/SDR - EHR Incentive Report (MU) ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,7,12,15,20**;NOV 12, 2009;Build 317
 ;IHS/SD/SDR - 2.6*20 - HEAT256154 - Split routine from ABMMUFC1 due to size.
 ;   Made changes for Newborn stays for 3+ days to count as Adult&Ped charges and bed days.
 ;   Also added 2 new categories, Visits w/no Eligibility and Medicare/Medicaid dual eligibles.  Corrected PI/Mcd entries so
 ;   they weren't duplicates any more.  Correction to lookup of visit data where parent visit link isn't the same as the visit
 ;   we are using.  For option 'H' only look at bills with bill type 121 or visit type 111 or 3P Visit Type UB-92 BILL TYPE 111.
 ;   Added bill type, visit type to detail output to assist with validation.  Smartened up check for eligibility when in the
 ;   visit section.  It was counting using the first insurer found.  If the reason is one of the ones with (NE) it shouldn't use
 ;   that eligibility to count.
 ;
VISITS ;EP
 S ABMNDAYS=0,ABMBILLD=0,ABMPBDFN=0
 S ABMDDT=ABMP("SDT")-.0001
 F  S ABMDDT=$O(^AUPNVINP("B",ABMDDT)) Q:ABMDDT=""!($P(ABMDDT,".")>ABMP("EDT"))  D
 .S ABMDOSE=ABMDDT
 .S ABMHDFN=0
 .F  S ABMHDFN=$O(^AUPNVINP("B",ABMDDT,ABMHDFN)) Q:ABMHDFN'=+ABMHDFN  D
 ..Q:'$D(^AUPNVINP(ABMHDFN,0))
 ..S ABMVDFN=$P(^AUPNVINP(ABMHDFN,0),U,3)
 ..Q:'ABMVDFN
 ..I $D(^TMP($J,"ABM-MUVLST",ABMVDFN)) Q  ;visit already counted ;abm*2.6*15
 ..Q:'$D(^AUPNVSIT(ABMVDFN,0))
 ..Q:$P(^AUPNVSIT(ABMVDFN,0),U,11)  ;deleted visit
 ..Q:$P(^AUPNVSIT(ABMVDFN,0),U,7)'="H"  ;hospitalizations only
 ..Q:$P(^AUPNVSIT(ABMVDFN,0),U,3)="C"  ;CHS visit
 ..I '$D(ABMLOC($P(^AUPNVSIT(ABMVDFN,0),U,6))) Q  ;not location of interest
 ..S ABMVLOC=$$GET1^DIQ(9000010,ABMVDFN,".06","E")
 ..S (DFN,ABMP("PDFN"))=$P(^AUPNVSIT(ABMVDFN,0),U,5)
 ..Q:$$GET1^DIQ(2,ABMP("PDFN"),".01","E")["DEMO,PATIENT"  ;exclude any DEMO,PATIENT
 ..;exclude DEMO patients
 ..S ABMNAME=$P(^DPT(DFN,0),U)
 ..;S (ABMDOSB,ABMP("VDT"))=$P($P($G(^AUPNVSIT(ABMVDFN,0)),U),".")  ;visit date  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S (ABMDOSB,ABMVDT,ABMP("VDT"))=$P($P($G(^AUPNVSIT(ABMVDFN,0)),U),".")  ;visit date  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S ABMSC=$P($G(^AUPNVSIT(ABMVDFN,0)),U,7)  ;serv cat
 ..S ABMCLN=$P($G(^AUPNVSIT(ABMVDFN,0)),U,8)  ;clinic
 ..S ABMCDAYS=$$LOS^APCLV(ABMVDFN)  ;Length of Stay
 ..S ABMP("NEWBORN")=0  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;commented out below line in abm*2.6*20 IHS/SD/SDR; Harrell Little said it didn't apply, that newborn is always newborn
 ..;I $P($G(^AUPNVINP(ABMHDFN,0)),U,4)]"",$P($G(^DIC(45.7,$P($G(^AUPNVINP(ABMHDFN,0)),U,4),9999999)),U)="07",(ABMCDAYS<3) S ABMP("NEWBORN")=1  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S:$P($G(^AUPNVINP(ABMHDFN,0)),U,4)]"" ABMATYP=$P($G(^DIC(45.7,$P($G(^AUPNVINP(ABMHDFN,0)),U,4),0)),U)  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;Next section will guess what insurer should be.  Going to use first insurer found, billable or not.
 ..;It gets too complicated to figure out when it will or won't count for each insurer type.
 ..S ABMLSV=$G(ABML)
 ..N ABML  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S ABML=""
 ..K ABMDISDT  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..D ELG^ABMDLCK(ABMVDFN,.ABML,DFN,ABMP("VDT"))
 ..;I '$D(ABML) Q  ;patient doesn't have eligibility, don't count.  ;abm*2.6*15 HEAT208561  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;start new abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S ABMPRI=0,ABMITYPA=""
 ..F  S ABMPRI=$O(ABML(ABMPRI)) Q:'ABMPRI  D
 ...S ABMP("INS")=0
 ...F  S ABMP("INS")=$O(ABML(ABMPRI,ABMP("INS"))) Q:'ABMP("INS")  D
 ....I ABMPRI<97,(ABMITYPA'="") S ABMITYPA=ABMITYPA_"~"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMP("INS"),".211","I"),1,"I")
 ....I ABMPRI<97,(ABMITYPA="") S ABMITYPA=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMP("INS"),".211","I"),1,"I")
 ..;
 ..S ABMPRI=0,ABMEFLG=0
 ..S ABMRT="NOTBLD"
 ..F  S ABMPRI=$O(ABML(ABMPRI)) Q:'ABMPRI  D  Q:ABMEFLG
 ...S ABMP("INS")=0
 ...F  S ABMP("INS")=$O(ABML(ABMPRI,ABMP("INS"))) Q:'ABMP("INS")  D  Q:ABMEFLG
 ....I ABMPRI<97 S ABMEFLG=1 Q
 ....I (ABMPRI=99)&(+$P(ABML(ABMPRI,ABMP("INS")),U,6)=0) Q
 ....I $P($G(^ABMDCS(+$P(ABML(ABMPRI,ABMP("INS")),U,6),0)),U)'["(NE)" S ABMEFLG=1 Q
 ..;
 ..I '$D(ABML)!('ABMEFLG) D  Q  ;patient doesn't have eligibility, count as VISIT WITH NO ELIG and quit
 ...S ABMP("PVDFN")=ABMVDFN
 ...S (ABMP("VTYP"),ABMP("BTYP"))=0
 ...I ABMSC="H" S (ABMP("VTYP"),ABMP("BTYP"))=111  ;if no elig and service cat 'H', make it inpatient
 ...D SETCAT^ABMMUFAC
 ...S ABMP("INS")=0
 ...S ABMP("INSN")="NO ELIG"
 ...S ABMITYP="VISIT W/NO ELIG"
 ...I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ...I ABMSUMDT="D" D DETREC
 ..;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;
 ..;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;S ABMPRI=$O(ABML(0))
 ..;S ABMP("INS")=$O(ABML(ABMPRI,0))
 ..;end old abm*2.6*20 IHS/SD/SDR HEAT256154
 ..S ABMIT=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")
 ..S:(ABMIT="K") ABMIT2=$P(ABML(ABMPRI,ABMP("INS")),U,3)  ;this will show if it is title XIX or XXI
 ..D INSTYP^ABMMUFC1
 ..S ABMP("VTYP")=$$VTYP^ABMDVCK1(ABMVDFN,ABMSC,ABMP("INS"),ABMCLN)
 ..D BTYP^ABMMUFC1
 ..D SETCAT^ABMMUFAC
 ..S ABML=ABMLSV
 ..;
 ..S ABMP("PVDFN")=ABMVDFN
 ..S ABMRT="NOTBLD"
 ..;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ..;;I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC  ;abm*2.6*15
 ..;I ABMSUMDT="D" D DETREC  ;abm*2.6*15
 ..;;below code will check if patient has PI and MCD for this visit abm*2.6*15 HEAT183309 Req#E
 ..;S ABMPF=0,ABMDF=0
 ..;S ABMPRI=0
 ..;F  S ABMPRI=$O(ABML(ABMPRI)) Q:'ABMPRI  D
 ..;.S ABMI=0
 ..;.F  S ABMI=$O(ABML(ABMPRI,ABMI)) Q:'ABMI  D
 ..;..I $P(ABML(ABMPRI,ABMI),U,3)="P" S ABMPF=1
 ..;..I $P(ABML(ABMPRI,ABMI),U,3)="D" S ABMDF=1
 ..;I ABMPF=1,ABMDF=1 D
 ..;.S ABMITYP="PRI/MCD"
 ..;.I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC Q
 ..;.;I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC  ;abm*2.6*15
 ..;.I ABMSUMDT="D" D DETREC  ;abm*2.6*15
 ..;end old start new abm*2.6*20 IHS/SD/SDR HEAT256154
 ..;below code will check if patient has PI and MCD for this visit abm*2.6*15 HEAT183309 Req#E
 ..S ABMPF=0,ABMDF=0,ABMMF=0
 ..S ABMPRI=0
 ..F  S ABMPRI=$O(ABML(ABMPRI)) Q:'ABMPRI  D
 ...Q:ABMPRI>97
 ...S ABMI=0
 ...F  S ABMI=$O(ABML(ABMPRI,ABMI)) Q:'ABMI  D
 ....I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMI,".211","I"),1,"I")="P" S ABMPF=1
 ....I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMI,".211","I"),1,"I")="D" S ABMDF=1
 ....I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMI,".211","I"),1,"I")="M" S ABMMF=1
 ..I ABMPF=1,ABMDF=1 S ABMITYP="PRI/MCD"
 ..I ABMMF=1,ABMDF=1 S ABMITYP="MCR/MCD"
 ..I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC Q
 ..I ABMSUMDT="D" D DETREC
 ..;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 Q
 ;end new HEAT183309 Req#B
SUMMREC ;EP
 ;cnt # IP/OP discharges
 Q:$$GET1^DIQ(2,ABMP("PDFN"),".01","E")["DEMO,PATIENT"  ;exclude any DEMO,PATIENT
 I $D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN")))&(ABMITYP'="PRI/MCD") Q  ;quit if this visit has already counted
 I ABMSUMDT="B" D DETREC
 S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ;
 S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,ABMP("RPT-CAT"))=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,ABMP("RPT-CAT")))+1
 ;S ^TMP($J,"ABM-MUFAC","GTOT",ABMRT,ABMP("RPT-CAT"))=+$G(^TMP($J,"ABM-MUFAC","GTOT",ABMRT,ABMP("RPT-CAT")))+1
 ;tot cov'd days
 ;start old abm*2.6*15 HEAT183309 Req#B
 ;S:(ABMP("RPT-CAT")="IP SB DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP SB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP SB DAYS"))+ABMCDAYS  ;abm*2.6*12 swingbed
 ;S:(ABMP("RPT-CAT")="IP DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP DAYS"))+ABMCDAYS
 ;S:(ABMP("RPT-CAT")="IP NB DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DAYS"))+ABMCDAYS  ;abm*2.6*7
 ;;S:(ABMP("RPT-CAT")="IP CHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHG DAYS"))+ABMCDAYS  ;abm*2.6*7
 ;S:(ABMP("RPT-CAT")="IP CHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS"))+ABMCDAYS  ;abm*2.6*7
 ;end old start new HEAT183309 Req#B
 I (ABMP("RPT-CAT")="IP SB DISCHGS") S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP SB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP SB DAYS"))+ABMCDAYS
 I (ABMP("RPT-CAT")="IP DISCHGS") D
 .S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP DAYS"))+ABMCDAYS
 .;S ^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP DAYS")=+$G(^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP DAYS"))+ABMCDAYS
 ;start new abm*2.6*20 IHS/SD/SDR HEAT256154
 I (ABMP("RPT-CAT")="IP ANC DISCHGS") D
 .S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP ANC DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP ANC DAYS"))+ABMCDAYS
 ;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 I (ABMP("RPT-CAT")="IP NB DISCHGS") D
 .S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP NB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP NB DAYS"))+ABMCDAYS
 .;S ^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP NB DAYS")=+$G(^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP NB DAYS"))+ABMCDAYS
 I (ABMP("RPT-CAT")="IP CHGS") D
 .S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP CHGS DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMRT,"IP CHGS DAYS"))+ABMCDAYS
 .;S ^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP CHGS DAYS")=+$G(^TMP($J,"ABM-MUFAC","GTOT",ABMRT,"IP CHGS DAYS"))+ABMCDAYS
 Q
DETREC ;EP
 Q:$$GET1^DIQ(2,ABMP("PDFN"),".01","E")["DEMO,PATIENT"  ;exclude any DEMO,PATIENT
 I ABMITYP="PRI/MCD" K ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))
 I $D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))) Q  ;quit if this visit has already counted
 S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ;
 I ABMY("FACHOS")="H"&(ABMP("RPT-CAT")'["IP") Q  ;only include IP lines if option H was selected for rpt
 I ABMY("FACHOS")="H"&(ABMP("RPT-CAT")["SB") Q  ;skip include Swingbed lines if option H was selected for rpt
 ;S ABMP("INSN")=$P($G(^AUTNINS(ABMP("INS"),0)),U)  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 I +ABMP("INS")'=0 S ABMP("INSN")=$P($G(^AUTNINS(ABMP("INS"),0)),U)  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 S ABMREC=ABMDOSB_U_ABMDOSE_U_ABMBILLD_U_+$G(ABMP("PD"))_U_ABMCDAYS_U_ABMNDAYS_U_ABMVLOC_U_DUZ(2)_U_ABMPBDFN
 ;I ABMY("FACHOS")="H" S ABMREC=ABMREC_U_ABMRT  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 I ABMY("FACHOS")="H" S ABMREC=ABMREC_U_ABMRT_U_$G(ABMP("BTYP"))_U_$G(ABMP("VTYP"))_U_$G(ABMITYPA)_U_ABMATYP  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 S ^TMP($J,"ABM-MUFAC","DETAIL",ABMITYP,ABMRT,ABMP("RPT-CAT"),ABMP("INSN")_"|"_ABMP("INS"),$S(+$G(ABMP("PVDFN")):ABMP("PVDFN"),1:ABMVDFN))=ABMREC
 Q
