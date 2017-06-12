ABMMUFC3 ;IHS/SD/SDR - EHR Incentive Report (MU) ;
 ;;2.6;IHS 3P BILLING SYSTEM;**15,20**;NOV 12, 2009;Build 317
 ;IHS/SD/SDR - 2.6*15 - HEAT183309 - split routine due to size
 ;IHS/SD/SDR - 2.6*15 - HEAT207910 - made change to fix <SUBSCR>CLAIMS+64^ABMMUFC3; occurs when there isn't an active
 ;  insurer on the claim.
 ;IHS/SD/SDR - 2.6*20 - HEAT256154 - Fixed paid bug.  Paid amount from previous bill was being used because variable wasn't being set to 0.
 ;  Also fixed where service category from visit but other info from Parent visit were being used together, causing wrong visit to show up
 ;  on report.  Added check for newborn with bed days >2 to report in adult and ped bed days.  Added code to get Kidscare info so it can
 ;  determine if Kidscare is Medicaid or PI to determine title XIX or XXI.
 ;
PREV ;
 S ABMP("PD")=0,ABMPYD=0
 D SETVAR^ABMPPAD1
 S ABMPHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2)
 S ABMBSUF=$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,4)
 ;loop thru active bills
 S ABMBNUM=$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,0)),U)
 ;get trans for bills
 S ABMHOLD=DUZ(2)
 S ABMSAT=ABMP("LDFN")  ;Satellite = 3P Visit loc
 S DUZ(2)=ABMPAR
 S ABMBNUM=$O(^BARBL(DUZ(2),"B",ABMBNUM))
 S ABMAIEN=$O(^BARBL(DUZ(2),"B",ABMBNUM,0))
 I +$G(ABMAIEN)=0 S:+$G(ABMHOLD)'=0 DUZ(2)=ABMHOLD K ABMHOLD Q  ;there isn't an A/R bill w/this number
 S ABMTRIEN=0,ABMLN=1
 F  S ABMTRIEN=$O(^BARTR(DUZ(2),"AC",ABMAIEN,ABMTRIEN)) Q:ABMTRIEN=""  D
 .S ABMREC=$G(^BARTR(DUZ(2),ABMTRIEN,0))
 .I $G(ABMOPDT)="" S ABMOPDT=$P($P(ABMREC,U),".")
 .Q:+$P(ABMREC,U,2)=0&(+$P(ABMREC,U,3)=0)
 .S ABMBINS=$P(ABMREC,U,6)
 .I +$G(ABMBINS)=0 S ABMBINS=$P($G(^BARBL(DUZ(2),ABMAIEN,0)),U,3)  ;abm*2.6*7
 .S ABMBINS=+$P($G(^BARAC(DUZ(2),ABMBINS,0)),U)
 .S ABMTTYP=$P($G(^BARTR(DUZ(2),ABMTRIEN,1)),U,1)
 .S ABMADJC=$P($G(^BARTR(DUZ(2),ABMTRIEN,1)),U,2)
 .S ABMCAT=""
 .I ABMTTYP=40 S ABMCAT="P"
 .;treat a pymt credit w/credit amt like a pymt
 .I (ABMTTYP=43),(ABMADJC=20),(+$P($G(^BARTR(DUZ(2),ABMTRIEN,0)),U,2)'=0) S ABMCAT="P"
 .Q:ABMCAT=""
 .S ABMP("PD")=+$G(ABMP("PD"))+$$GET1^DIQ(90050.03,ABMTRIEN,3.5,"E"),ABMPYD=+$G(ABMPYD)+1
 I +$G(ABMHOLD)'=0 S DUZ(2)=ABMHOLD K ABMHOLD
 Q
CLAIMS ;EP
 S ABMPBDFN=0  ;abm2.6*15 to stop bill number from carrying over to other visits
 S ABMP("PD")=0  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 S ABMPSDT=ABMP("SDT")-10000
 F  S ABMPSDT=$O(^ABMDCLM(DUZ(2),"AD",ABMPSDT)) Q:'ABMPSDT  D  ;loop thru service date from x-ref
 .S ABMPFLG=0  ;abm*2.6*15 HEAT183309 Req#B
 .S ABMP("CDFN")=0
 .F  S ABMP("CDFN")=$O(^ABMDCLM(DUZ(2),"AD",ABMPSDT,ABMP("CDFN"))) Q:'ABMP("CDFN")  D  Q:ABMPFLG=1
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVDFN)) Q:'ABMVDFN  D  Q:ABMPFLG=1
 ...I $D(^TMP($J,"ABM-MUVLST",ABMVDFN)) Q  ;visit already counted ;abm*2.6*15
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
 ....S ABMP("VHIEN")=+$O(^AUPNVINP("AD",ABMP("PVDFN"),0))
 ....I ABMP("VHIEN")=0 S ABMQFLG=0 Q
 ....S ABMP("DISCHDT")=$P($G(^AUPNVINP(ABMP("VHIEN"),0)),U)
 ....I ABMP("DISCHDT")<ABMP("SDT") S ABMQFLG=0 Q  ;seen before start date
 ....I ABMP("DISCHDT")>ABMP("EDT") S ABMQFLG=0 Q  ;seen after end date
 ....;start new abm*2.6*12 swingbed
 ....S ABMP("SWINGBED")=0
 ....I $$GET1^DIQ(45.7,$$GET1^DIQ(9000010.02,ABMP("VHIEN"),".04","I"),"9999999.01","E")=21 S ABMP("SWINGBED")=1
 ....I $$GET1^DIQ(45.7,$$GET1^DIQ(9000010.02,ABMP("VHIEN"),".05","I"),"9999999.01","E")=21 S ABMP("SWINGBED")=1
 ....;end new swingbed
 ...S ABMPCDFN=0
 ...S ABMPFLG=0  ;pymt flg
 ...K ABMB
 ...F ABMC=1:1  S ABMPCDFN=$O(^ABMDCLM(DUZ(2),"AV",ABMP("PVDFN"),ABMPCDFN)) Q:'ABMPCDFN  D  Q:ABMPFLG=1
 ....;S ABMP("BTYP")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,2)  ;bill type  ;abm*2.6*20  IHS/SD/SDR HEAT256154
 ....S ABMP("BTYP")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,12)  ;bill type  ;abm*2.6*20  IHS/SD/SDR HEAT256154
 ....S ABMP("VTYP")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,7)  ;visit type
 ....I +$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,8)=0 Q  ;no active insurer on claim - skip  abm*2.6*15 HEAT207910
 ....I $P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,4)="X" Q  ;skip cancelled claims
 ....S ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC)=ABMPCDFN
 ...S ABMP("VTYP")=0
 ...F  S ABMP("VTYP")=$O(ABMB(ABMP("VTYP"))) Q:'ABMP("VTYP")  D  Q:ABMPFLG=1
 ....S ABMP("BTYP")=0
 ....F  S ABMP("BTYP")=$O(ABMB(ABMP("VTYP"),ABMP("BTYP"))) Q:'ABMP("BTYP")  D  Q:ABMPFLG=1
 .....S ABMC=0
 .....F  S ABMC=$O(ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC)) Q:'ABMC  D  Q:ABMPFLG=1
 ......S ABMPCDFN=$G(ABMB(ABMP("VTYP"),ABMP("BTYP"),ABMC))
 ......S ABM=ABMPCDFN
 ......S ABMP("PDFN")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U)
 ......Q:$$GET1^DIQ(2,ABMP("PDFN"),".01","E")["DEMO,PATIENT"  ;exclude any DEMO,PATIENT
 ......S ABMP("INS")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,8)
 ......I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="K" D GETCINS^ABMMUFC3  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 ......S ABMP("LDFN")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,3)
 ......S ABMP("VDT")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,7)),U)
 ......S ABMP("NEWBORN")=0  ;abm*2.6*7
 ......I $$GET1^DIQ(9002274.03,$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,5)),U),.03,"E")="NEWBORN" S ABMP("NEWBORN")=1
 ......S ABMATYP=$$GET1^DIQ(9002274.03,$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,5)),U),.03,"E")  ;abm*2.6*20 IHS/SD/SDR HEAT256154
 .....S ABMIT=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")
 .....D INSTYP^ABMMUFC1
 .....S ABMP("INS")=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,0)),U,8)
 .....S ABMP("FSDT")=0,ABMFFLG=0
 .....F  S ABMP("FSDT")=$O(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"))) Q:'ABMP("FSDT")  D  Q:ABMFFLG=1
 ......I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U)>ABMP("EDT") Q
 ......I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,ABMP("FSDT"),0)),U,2)>ABMP("SDT") Q
 ......S ABMFFLG=1
 .....;start new abm*2.6*20 IHS/SD/SDR HEAT256154
 .....S ABMCDAYS=+$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,7)),U,3)
 .....S:'ABMCDAYS ABMCDAYS=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,6)),U,9)
 .....S:'ABMCDAYS ABMCDAYS=1
 .....;commented out below line in abm*2.6*20 IHS/SD/SDR; Harrell Little said it didn't apply, that newborn is always newborn
 .....;I ABMCDAYS>2 S ABMP("NEWBORN")=0  ;if stay is more than 2 days it isn't counted as newborn; it should be counted as adult&ped
 .....;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 .....D SETCAT^ABMMUFAC
 .....;Q:$D(^TMP($J,"ABM-MUVLST",ABMP("PVDFN")))  ;quit if this visit has already counted
 .....;S ^TMP($J,"ABM-MUVLST",ABMP("PVDFN"))=""  ;add visit to list
 .....S ABMDOSB=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,7)),U)
 .....S ABMDOSE=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,7)),U,2)
 .....S ABMBILLD=+$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,2)),U)
 .....S ABMVLOC=$$GET1^DIQ(9002274.3,ABMPCDFN,".03","E")
 .....S ABMNDAYS=+$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,6)),U,6)
 .....;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 .....;S ABMCDAYS=+$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,7)),U,3)
 .....;S:'ABMCDAYS ABMCDAYS=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,6)),U,9)
 .....;S:'ABMCDAYS ABMCDAYS=1
 .....;end old abm*2.6*20 IHS/SD/SDR HEAT256154
 .....S ABMRT="NOTBLD"
 .....;start old abm*2.6*20 IHS/SD/SDR HEAT256154
 .....;I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC^ABMMUFC1
 .....;I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC^ABMMUFC1
 .....;end old start new abm*2.6*20 IHS/SD/SDR HEAT256154
 .....;this looks at other insurers on the bill and tries to determine if they are a PI/MCD or MCR/MCD bill;
 .....;puts these into separate categories.
 .....S ABMI=0,ABMDF=0,ABMITYPA=""
 .....F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI)) Q:'ABMI  D
 ......S ABMJ=$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U)
 ......I ABMITYPA'="" S ABMITYPA=ABMITYPA_"~"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMJ,".211","I"),1,"I")
 ......I ABMITYPA="" S ABMITYPA=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMJ,".211","I"),1,"I")
 ......I $P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U,6)'="",ABMIT="P" S ABMDF=1
 ......I $P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U,6)'="",ABMIT="R" S ABMDF=2
 .....I ABMDF=1 S ABMITYP="PRI/MCD"
 .....I ABMDF=2 S ABMITYP="MCR/MCD"
 .....;
 .....I "^S^B^"[("^"_ABMSUMDT_"^") D SUMMREC^ABMMUFC1
 .....I "^D^B^"[("^"_ABMSUMDT_"^") D DETREC^ABMMUFC1
 .....;end new abm*2.6*20 IHS/SD/SDR HEAT256154
 Q
GETBINS ;EP
 S ABMI=0
 F  S ABMI=$O(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI)) Q:'ABMI  D
 .I $P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U)'=ABMP("INS") Q  ;not the active insurer
 .I +$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U,7)'=0 S ABMIT2="D"
 .I +$P($G(^ABMDBILL(DUZ(2),ABMPBDFN,13,ABMI,0)),U,8)'=0 S ABMIT2="P"
 Q
 ;start new abm*2.6*20 IHS/SD/SDR HEAT256154
GETCINS ;EP
 S ABMI=0
 F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI)) Q:'ABMI  D
 .I $P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U)'=ABMP("INS") Q  ;not the active insurer
 .I +$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U,7)'=0 S ABMIT2="D"
 .I +$P($G(^ABMDCLM(DUZ(2),ABMPCDFN,13,ABMI,0)),U,8)'=0 S ABMIT2="P"
 Q
 ;end new abm*2.6*20 IHS/SD/SDR HEAT256154
