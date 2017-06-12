ABMMUFC5 ;IHS/SD/SDR - EHR Incentive Report (MU) ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,7,12,15**;NOV 12, 2009;Build 251
 ;IHS/SDR/SDR - 2.6*12 - VMBP RQMT_104 - Added VA data to report
 ;IHS/SD/SDR - 2.6*12 - Added swingbed
 ;IHS/SD/SDR - 2.6*15 - HEAT183309 - Created separate GETBILLS for 'F' option since they are so different now
GETBILLS ;EP
 S ABMPSDT=ABMP("SDT")-10000
 F  S ABMPSDT=$O(^ABMDBILL(DUZ(2),"AD",ABMPSDT)) Q:'ABMPSDT  D  ;loop thru service date from x-ref
 .S ABMPFLG=0  ;abm*2.6*15 HEAT183309 Req#B
 .S ABMP("BDFN")=0
 .F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AD",ABMPSDT,ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),11,ABMVDFN)) Q:'ABMVDFN  D  Q:ABMPFLG=1
 ...I $P($G(^AUPNVSIT(ABMVDFN,0)),U,11)=1 Q  ;deleted visit
 ...S ABMSC=$P($G(^AUPNVSIT(ABMVDFN,0)),U,7)  ;service category
 ...I "HIASRO"'[ABMSC Q  ;ignore all other service categories
 ...;H=Hosp
 ...;I=In Hosp
 ...;A=Amb
 ...;S=Day Surg
 ...;R=Nurs Home
 ...;O=Observ
 ...;parent visit link; default to visit if there isn't one
 ...S ABMP("PVDFN")=$S($P($G(^AUPNVSIT(ABMVDFN,0)),U,12):$P(^AUPNVSIT(ABMVDFN,0),U,12),1:ABMVDFN)
 ...;if not Hospitalization, use Visit/Admit Date&Time
 ...I ABMSC'="H",($P($G(^AUPNVSIT(ABMP("PVDFN"),0)),U)<ABMP("SDT")) Q  ;seen before start date
 ...I ABMSC'="H",($P($G(^AUPNVSIT(ABMP("PVDFN"),0)),U)>ABMP("EDT")) Q  ;seen after end date
 ...;if Hospitalization, get Date of Discharge from V Hospitalization file
 ...S ABMQFLG=1
 ...I ABMSC="H" D  Q:ABMQFLG=0
 ....;S ABMP("VHIEN")=$O(^AUPNVINP("AD",ABMP("PVDFN"),0))  ;abm*2.6*7
 ....S ABMP("VHIEN")=+$O(^AUPNVINP("AD",ABMP("PVDFN"),0))  ;abm*2.6*7
 ....I ABMP("VHIEN")=0 S ABMQFLG=0 Q
 ....S ABMP("DISCHDT")=$P($G(^AUPNVINP(ABMP("VHIEN"),0)),U)
 ....I ABMP("DISCHDT")<ABMP("SDT") S ABMQFLG=0 Q  ;seen before start date
 ....I ABMP("DISCHDT")>ABMP("EDT") S ABMQFLG=0 Q  ;seen after end date
 ....;start new abm*2.6*12 swingbed
 ....S ABMP("SWINGBED")=0
 ....I $$GET1^DIQ(45.7,$$GET1^DIQ(9000010.02,ABMP("VHIEN"),".04","I"),"9999999.01","E")=21 S ABMP("SWINGBED")=1
 ....I $$GET1^DIQ(45.7,$$GET1^DIQ(9000010.02,ABMP("VHIEN"),".05","I"),"9999999.01","E")=21 S ABMP("SWINGBED")=1
 ....;end new swingbed
 ...S ABMPBDFN=0
 ...S ABMPFLG=0  ;pymt flg
 ...K ABMB
 ...F ABMC=1:1  S ABMPBDFN=$O(^ABMDBILL(DUZ(2),"AV",ABMP("PVDFN"),ABMPBDFN)) Q:'ABMPBDFN  D  Q:ABMPFLG=1
 ....S ABMP("BTYP")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,2)  ;bill type
 ....S ABMP("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,7)  ;visit type
 ....I $P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,4)="X" Q  ;skip cancelled bills
 ....S ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC)=ABMPBDFN
 ...I '$D(ABMB) Q    ;no active bills found  ;abm*2.6*15 HEAT183309
 ...S ABMP("VTYP")=0
 ...F  S ABMP("VTYP")=$O(ABMB(ABMP("VTYP"))) Q:'ABMP("VTYP")  D  Q:ABMPFLG=1
 ....S ABMP("BTYP")=0
 ....F  S ABMP("BTYP")=$O(ABMB(ABMP("VTYP"),ABMP("BTYP"))) Q:'ABMP("BTYP")  D  Q:ABMPFLG=1
 .....S ABMC=0
 .....F  S ABMC=$O(ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC)) Q:'ABMC  D  Q:ABMPFLG=1
 ......S ABMPBDFN=$G(ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC))
 ......S ABM=ABMPBDFN
 ......S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,5)
 ......S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,8)
 ......S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,3)
 ......S ABMP("VDT")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U)
 ......S ABMP("NEWBORN")=0  ;abm*2.6*7
 ......I $$GET1^DIQ(9002274.03,$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,5)),U),.03,"E")="NEWBORN" S ABMP("NEWBORN")=1  ;abm*2.6*7
 ......S ABMP("PD")=0  ;abm*2.6*15 HEAT183309 Req#B
 ......D PREV^ABMMUFC3
 ......I +$G(ABMP("PD"))=0&('ABMPYD) Q  ;skip if no payment made on bill
 ......S ABMPFLG=1
 ...I ABMPFLG=0 D  ;if ABMPFLG=0 there wasn't a pymt on any bill; use the first one billed
 ....S ABMP("VTYP")=$O(ABMB(0))
 ....S ABMP("BTYP")=$O(ABMB(ABMP("VTYP"),0))
 ....S ABMC=$O(ABMB(ABMP("VTYP"),ABMP("BTYP"),0))
 ....S ABMPBDFN=$G(ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC))
 ...;start old abm*2.6*15 HEAT183309 Req#B
 ...;;if it gets here and ABMPFLG is 0, no pymt was found for any bill for this visit
 ...;Q:+$G(ABMPFLG)=0
 ...;end old HEAT183309 Req#B
 ...;if it gets here, ABMP("BDFN") is the first bill with a payment
 ...S ABMIT=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,2)),U,2)
 ...D INSTYP
 ...S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,8)
 ...S ABMP("FSDT")=0,ABMFFLG=0
 ...F  S ABMP("FSDT")=$O(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"))) Q:'ABMP("FSDT")  D  Q:ABMFFLG=1
 ....I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U)>ABMP("EDT") Q
 ....I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U,2)>ABMP("SDT") Q
 ....S ABMFFLG=1
 ...D SETCAT^ABMMUFAC
 ...;Q:$D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN")))  ;quit if this visit has already counted
 ...;S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ...;start new abm*2.6*15 HEAT183309 Req#B
 ...S ABMDOSB=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U)
 ...S ABMDOSE=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U,2)
 ...S ABMBILLD=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,2)),U)
 ...S ABMVLOC=$$GET1^DIQ(9002274.4,ABMPBDFN,".03","E")
 ...S ABMNDAYS=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,6)),U,6)
 ...S ABMCDAYS=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U,3)
 ...S:'ABMCDAYS ABMCDAYS=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,6)),U,9)
 ...S:'ABMCDAYS ABMCDAYS=1
 ...S ABMRT=$S(+$G(ABMP("PD"))'=0&(ABMPYD):"PD",1:"BLD")
 ...I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ...I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC
 Q
SUMMREC ;EP
 ;cnt # IP/OP discharges
 I $D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN")))&(ABMITYP'="PRI/MCD") Q  ;quit if this visit has already counted
 S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ;
 S ^TMP($J,"ABM-MUFAC",ABMITYP,ABMP("RPT-CAT"))=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,ABMP("RPT-CAT")))+1
 ;tot cov'd days
 S:(ABMP("RPT-CAT")="IP SB DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP SB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP SB DAYS"))+ABMCDAYS
 S:(ABMP("RPT-CAT")="IP DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP DAYS"))+ABMCDAYS
 S:(ABMP("RPT-CAT")="IP NB DISCHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP NB DAYS"))+ABMCDAYS
 S:(ABMP("RPT-CAT")="IP CHGS") ^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS")=+$G(^TMP($J,"ABM-MUFAC",ABMITYP,"IP CHGS DAYS"))+ABMCDAYS
 Q
DETREC ;EP
 I ABMITYP="PRI/MCD" K ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))
 I $D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))) Q  ;quit if this visit has already counted
 S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ;
 S ABMP("INSN")=$P($G(^AUTNINS(ABMP("INS"),0)),U)
 S ABMREC=ABMDOSB_U_ABMDOSE_U_ABMBILLD_U_+$G(ABMP("PD"))_U_ABMCDAYS_U_ABMNDAYS_U_ABMVLOC_U_DUZ(2)_U_ABMPBDFN
 S ^TMP($J,"ABM-MUFAC","DETAIL",ABMITYP,ABMP("RPT-CAT"),ABMP("INSN")_"|"_ABMP("INS"),$S(+$G(ABMP("PVDFN")):ABMP("PVDFN"),1:ABMVDFN))=ABMREC
 Q
INSTYP ;EP
 I "^R^MH^MD^"[("^"_ABMIT_"^") S ABMITYP="MEDICARE"
 I "^P^H^D^F^"[("^"_ABMIT_"^") S ABMITYP="PRIVATE"
 I ABMIT="D" S ABMITYP="MEDICAID"
 I ABMIT="K" S ABMITYP="KIDSCARE/CHIP"
 I ABMIT="V" S ABMITYP="VMBP"
 I "^W^C^N^I^T^G^FPL^MMC^MC^SEP^TSI^"[("^"_ABMIT_"^") S ABMITYP="OTHER"
 Q
