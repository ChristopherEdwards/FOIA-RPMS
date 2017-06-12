ABMMUFC1 ;IHS/SD/SDR - EHR Incentive Report (MU) ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,7,12,15,20**;NOV 12, 2009;Build 317
 ;IHS/SD/SDR - 2.6*12 - VMBP RQMT_104 - Added VA data to report
 ;IHS/SD/SDR - 2.6*12 - Added swingbed
 ;IHS/SD/SDR - 2.6*15 - HEAT183309 - Req#B - Added Billed and Total columns
 ;   Req#E - Added new section Private primary/mcd secondary
 ;   Req#G - Split Kidscare into Kidscare Title XIX and XXI
 ;IHS/SD/SDR - 2.6.15 - HEAT208561 - Made change to fix error <SUBSCR>VISITS+30^ABMMUFC1.
 ;   Occurs when patient has a visit but no eligibility at all on Reg.
 ;IHS/SD/SDR - 2.6*20 - HEAT256154 - Made changes for Newborn stays for 3+ days to count as Adult&Ped charges and bed days.
 ;   Also added 2 new categories, Visits w/no Eligibility and Medicare/Medicaid dual eligibles.  Corrected PI/Mcd entries so
 ;   they weren't duplicates any more.  Correction to lookup of visit data where parent visit link isn't the same as the visit
 ;   we are using.  For option 'H' only look at bills with bill type 121 or visit type 111 or 3P Visit Type UB-92 BILL TYPE 111.
 ;   Added bill type, visit type to detail output to assist with validation.
 ;
LBK ;
 D ^XBFMK
 S DIR("A")="Enter ENDING Date"
 S DIR(0)="DO^:"_(DT-1)_":EPX"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMY("DT",2)=Y
 S X1=ABMY("DT",2)
 S X2=-365
 D C^%DTC
 S ABMY("DT",1)=X
 Q
FACHOS ;EP
 D ^XBFMK
 S DIR("A")="Select the type of report to run"
 S DIR(0)="S^F:FACILITY EHR INCENTIVE REPORT (COST REPORT);H:HOSPITAL CALCULATION MU INCENTIVE REPORT"
 D ^DIR
 K DIR
 S ABMY("FACHOS")=Y
 Q
 ;start new abm*2.6*15 HEAT183309 Req#B
VISITS ;EP
 D VISITS^ABMMUFC6  ;abm*2.6*20 IHS/SD/SDR HEAT256154 - split routine due to size.
 Q
 ;end new HEAT183309 Req#B
GETBILLS ;EP
 S ABMPSDT=ABMP("SDT")-10000
 F  S ABMPSDT=$O(^ABMDBILL(DUZ(2),"AD",ABMPSDT)) Q:'ABMPSDT  D  ;loop thru service date from x-ref
 .S ABMPFLG=0  ;abm*2.6*15 HEAT183309 Req#B
 .S ABMP("BDFN")=0
 .F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AD",ABMPSDT,ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),11,ABMVDFN)) Q:'ABMVDFN  D  Q:ABMPFLG=1
 ...I $D(^TMP($J,"ABM-MUVLST",ABMVDFN)) Q  ;visit has already been counted on a different bill  abm*2.6*15
 ...I $P($G(^AUPNVSIT(ABMVDFN,0)),U,11)=1 Q  ;deleted visit
 ...S ABMP("PVDFN")=$S($P($G(^AUPNVSIT(ABMVDFN,0)),U,12):$P(^AUPNVSIT(ABMVDFN,0),U,12),1:ABMVDFN)  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ...;S ABMSC=$P($G(^AUPNVSIT(ABMVDFN,0)),U,7)  ;service category  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ...S ABMSC=$P($G(^AUPNVSIT(ABMP("PVDFN"),0)),U,7)  ;service category  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ...I "HIASRO"'[ABMSC Q  ;ignore all other service categories
 ...;H=Hosp
 ...;I=In Hosp
 ...;A=Amb
 ...;S=Day Surg
 ...;R=Nurs Home
 ...;O=Observ
 ...;parent visit link; default to visit if there isn't one
 ...;S ABMP("PVDFN")=$S($P($G(^AUPNVSIT(ABMVDFN,0)),U,12):$P(^AUPNVSIT(ABMVDFN,0),U,12),1:ABMVDFN)  ;abm*2.6*20 IHS/SD/SDR HEAT256154
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
 ....I ABMY("FACHOS")="H"&'((ABMP("BTYP")=121)!(ABMP("VTYP")=111)!(+$P($G(^ABMDVTYP(ABMP("VTYP"),0)),U,2)=111)) Q  ;only inpt or ancillary visit types  ;abm*2.6*20 IHS/SD/SDR HEAT256154
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
 ......Q:$$GET1^DIQ(2,ABMP("PDFN"),".01","E")["DEMO,PATIENT"  ;exclude any DEMO,PATIENT
 ......S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,8)
 ......I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="K" D GETBINS^ABMMUFC3  ;abm*2.6*15 HEAT183309 Req#G
 ......S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,3)
 ......S ABMP("VDT")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U)
 ......S ABMP("NEWBORN")=0  ;abm*2.6*7
 ......I $$GET1^DIQ(9002274.03,$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,5)),U),.03,"E")="NEWBORN" S ABMP("NEWBORN")=1  ;abm*2.6*7
 ......S ABMATYP=$$GET1^DIQ(9002274.03,$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,5)),U),.03,"E")  ;abm*2.6*20 IHS/SD/SDR HEAT256154
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
 ...;at this point it will be either 1)the first bill with payment; or 2)the first bill sorted so inpatient is on top
 ...S ABMIT=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,2)),U,2)
 ...D INSTYP
 ...S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U,8)
 ...S ABMP("FSDT")=0,ABMFFLG=0
 ...F  S ABMP("FSDT")=$O(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"))) Q:'ABMP("FSDT")  D  Q:ABMFFLG=1
 ....I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U)>ABMP("EDT") Q
 ....I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U,2)>ABMP("SDT") Q
 ....S ABMFFLG=1
 ...;start new abm*2.6*20 IHS/SD/SDR HEAT256154
 ...S ABMCDAYS=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U,3)
 ...S:'ABMCDAYS ABMCDAYS=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,6)),U,9)
 ...S:'ABMCDAYS ABMCDAYS=1
 ...;commented out below line in abm*2.6*20 IHS/SD/SDR; Harrell Little said it didn't apply, that newborn is always newborn
 ...;I ABMCDAYS>2 S ABMP("NEWBORN")=0  ;if stay is more than 2 days it isn't counted as newborn; it should be counted as adult&ped
 ...;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 ...D SETCAT^ABMMUFAC
 ...;Q:$D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN")))  ;quit if this visit has already counted
 ...;S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 ...;start new abm*2.6*15 HEAT183309 Req#B
 ...S ABMDOSB=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U)
 ...S ABMDOSE=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U,2)
 ...S ABMBILLD=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,2)),U)
 ...S ABMVLOC=$$GET1^DIQ(9002274.4,ABMPBDFN,".03","E")
 ...S ABMNDAYS=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,6)),U,6)
 ...;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 ...;S ABMCDAYS=+$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,7)),U,3)
 ...;S:'ABMCDAYS ABMCDAYS=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,6)),U,9)
 ...;S:'ABMCDAYS ABMCDAYS=1
 ...;end old abm*2.6*20 IHS/SD/SDR HEAT256154
 ...S ABMRT=$S(+$G(ABMP("PD"))'=0&(ABMPYD):"PD",1:"BLD")
 ...;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 ...;I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ...;I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC
 ...;I ABMIT="P" D  ;if Private look for a Medicaid on the same bill abm*2.6*15 HEAT183309 Req#E
 ...;.S ABMI=0,ABMDF=0
 ...;.F  S ABMI=$O(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI)) Q:'ABMI  D
 ...;..I $P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U,6)'="" S ABMDF=1
 ...;.I ABMDF=1 S ABMITYP="PRI/MCD" D
 ...;..I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ...;..I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC
 ...;end old start new abm*2.6*20 IHS/SD/SDR HEAT256154
 ...;this looks at other insurers on the bill and tries to determine if they are a PI/MCD or MCR/MCD bill;
 ...;puts these into separate categories.
 ...S ABMI=0,ABMDF=0,ABMITYPA=""
 ...F  S ABMI=$O(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI)) Q:'ABMI  D
 ....S ABMJ=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U)
 ....I ABMITYPA'="" S ABMITYPA=ABMITYPA_"~"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMJ,".211","I"),1,"I")
 ....I ABMITYPA="" S ABMITYPA=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMJ,".211","I"),1,"I")
 ....I $P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U,6)'="",ABMIT="P" S ABMDF=1
 ....I $P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U,6)'="",ABMIT="R" S ABMDF=2
 ...I ABMDF=1 S ABMITYP="PRI/MCD"
 ...I ABMDF=2 S ABMITYP="MCR/MCD"
 ...;
 ...I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC
 ...I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC
 ...;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 Q
 ;start new abm*2.6*15 HEAT183309 Req#B
SUMMREC ;EP
 D SUMMREC^ABMMUFC6  ;abm*2.6*20 IHS/SD/SDR HEAT256154 - split routine due to size
 Q
DETREC ;EP
 D DETREC^ABMMUFC6  ;abm*2.6*20 IHS/SD/SDR HEAT256154 - split routine due to size
 Q
 ;end new HEAT183309 Req#B
INSTYP ;EP
 I "^R^MH^MD^"[("^"_ABMIT_"^") S ABMITYP="MEDICARE"
 I "^P^H^D^F^"[("^"_ABMIT_"^") S ABMITYP="PRIVATE"
 I ABMIT="D" S ABMITYP="MEDICAID"
 ;I ABMIT="K" S ABMITYP="KIDSCARE/CHIP"  ;abm*2.6*15 HEAT183309 Req#G
 I ABMIT="K"&($G(ABMIT2)="D") S ABMITYP="KIDSCARE XIX"  ;abm*2.6*15 HEAT183309 Req#G
 I ABMIT="K"&($G(ABMIT2)="P") S ABMITYP="KIDSCARE XXI"  ;abm*2.6*15 HEAT183309 Req#G
 I ABMIT="V" S ABMITYP="VMBP"  ;abm*2.6*12 VMBP RQMT_104
 ;I "^W^C^N^I^T^G^"[("^"_ABMIT_"^") S ABMITYP="OTHER"  ;abm*2.6*15 HEAT183309
 I "^W^C^N^I^T^G^FPL^MMC^MC^SEP^TSI^"[("^"_ABMIT_"^") S ABMITYP="OTHER"  ;abm*2.6*15 HEAT183309
 Q
BTYP ;EP - partial copy of code from BTYP^ABMDEVAR
 S ABMP("BTYP")=""
 I $P($G(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0)),U,11) D
 .S ABMP("BTYP")=$P(^ABMNINS(DUZ(2),+ABMP("INS"),1,ABMP("VTYP"),0),U,11)
 .S ABMP("BTYP")=$P($G(^ABMDCODE(ABMP("BTYP"),0)),U)
 S:ABMP("BTYP")<110!(ABMP("BTYP")>999) ABMP("BTYP")=""
 S:ABMP("BTYP")="" ABMP("BTYP")=$S(ABMP("VTYP")=111:111,ABMP("VTYP")=121:121,ABMP("VTYP")=831:831,1:131)
 I ABMP("VTYP")=111,$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="R" S ABMP("BTYP")=121 D
 .N I
 .S I=0
 .F  S I=$O(^AUPNMCR(ABMP("PDFN"),11,I)) Q:'I  D
 ..Q:$P(^AUPNMCR(ABMP("PDFN"),11,I,0),U)>ABMP("VDT")
 ..I $P(^AUPNMCR(ABMP("PDFN"),11,I,0),U,2)<ABMP("VDT"),$P(^(0),U,2)'="" Q
 ..Q:$P(^AUPNMCR(ABMP("PDFN"),11,I,0),U,3)'="A"
 ..S ABMP("BTYP")=111
 .I ABMP("BTYP")=121 D
 ..N I
 ..S I=0
 ..F  S I=$O(^AUPNRRE(ABMP("PDFN"),11,I)) Q:'I  D
 ...Q:$P(^AUPNRRE(ABMP("PDFN"),11,I,0),U)>ABMP("VDT")
 ...I $P(^AUPNRRE(ABMP("PDFN"),11,I,0),U,2)<ABMP("VDT"),$P(^(0),U,2)'="" Q
 ...Q:$P(^AUPNRRE(ABMP("PDFN"),11,I,0),U,3)'="A"
 ...S ABMP("BTYP")=111
 Q
