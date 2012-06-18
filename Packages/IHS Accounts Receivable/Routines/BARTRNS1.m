BARTRNS1 ; IHS/SD/SDR - Transaction Summary/Detail Report ; 03/10/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,19,20**;OCT 26, 2005
 ;New routine H2470
 Q
COMPUTE ; EP
 S BAR("SUBR")="BAR-TRANS"
 K ^TMP($J,"BAR-TRANS")
 K ^TMP($J,"BAR-TRANST")
 I BAR("LOC")="BILLING" D LOOP Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 S BARY("DT",3)=BARY("DT",2)+.99
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP
 S DUZ(2)=BARDUZ2
 Q
LOOP ;EP for Looping thru Bill File
 S BARP("DT")=BARY("DT",1)-1+.9  ;PKD 9/24/10 1.8*19 don't go back extra day
 ;PKD 1.8*19 BARY("DT",3) - corrected end date
 ;F  S BARP("DT")=$O(^BARBL(DUZ(2),"AG",BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>BARY("DT",2))  D
 F  S BARP("DT")=$O(^BARBL(DUZ(2),"AG",BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>BARY("DT",3))  D
 .S BARIEN=0
 .F  S BARIEN=$O(^BARBL(DUZ(2),"AG",BARP("DT"),BARIEN)) Q:'BARIEN  D
 ..;get bill info
 ..S BAR(0)=$G(^BARBL(DUZ(2),BARIEN,0))  ;A/R Bill 0 node
 ..S BAR(1)=$G(^BARBL(DUZ(2),BARIEN,1))  ;A/R Bill 1 node
 ..S BAR("LOC")=$P(BAR(1),U,8)  ;Visit loc (A/R Parent/Sat)
 ..S BAR("INS")=$P(BAR(0),U,3)  ;A/R Acct
 ..S BAR("DOS")=$P(BAR(1),U,2)  ;DOS Begin
 ..S BAR("APPDT")=$P(BAR(0),U,18)  ;3P Appr. date
 ..S BAR("BAMT")=$P(BAR(0),U,13)  ;total bill amt
 ..I BAR("INS")]"" D
 ...S D0=BAR("INS")
 ...S BAR("ITYP")=$$VALI^BARVPM(8)  ;Ins Type
 ..;PKD 1.8*19 12/29/10 - shouldn't happen that there's no A/R acct for bill
 ..I BAR("INS")="" S BAR("INS")=0
 ..I $D(BARY("ITYP")),$G(BARY("ITYP"))'=BAR("ITYP") Q  ;looking for specific ins type
 ..I $D(BARY("LOC")),$G(BARY("LOC"))'=BAR("LOC") Q  ;looking for specific loc and this isn't it
 ..I $D(BARY("ARACCT")),'$D(BARY("ARACCT",BAR("INS"))) Q  ;not the a/r acct we want
 ..;I $G(BAR("ITYP"))="" S BAR("BI")="No Billing Entity"  ;bar*1.8*20 pkd <undef> correction
 ..I $G(BAR("ITYP"))="" S BAR("ITYP")="No Billing Entity"  ;bar*1.8*20 pkd <undef> correction
 ..I BAR("ITYP")'="No Billing Entity" D
 ...S BAR("ALL")="O"  ;Other Allow Cat
 ...I BAR("ITYP")="G" S BAR("ALL")="O" Q
 ...I BAR("ITYP")="R"!(BAR("ITYP")="MD")!(BAR("ITYP")="MH") S BAR("ALL")="R" Q  ;Medicare Allow Cat
 ...I BAR("ITYP")="D" S BAR("ALL")="D" Q  ;Medicaid Allow Cat
 ...I BAR("ITYP")="K" S BAR("ALL")="D" Q  ;CHIPS is lumped with Medicaid
 ...;PKD 1.8*19 "T" = 3RD PARTY BILL - NO LONGER 'Private' per Adrian 12/29/10
 ...;I ",F,M,H,P,T,"[(","_BAR("ITYP")_",") S BAR("ALL")="P" Q  ;Private
 ...I ",F,M,H,P,"[(","_BAR("ITYP")_",") S BAR("ALL")="P" Q  ;Private
 ..I $G(BAR("ALL"))=""  S BAR("ALL")="No Allowance Category"
 ..I $D(BARY("ALL")),(+BARY("ALL")=BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))
 ..I $D(BARY("ALL")),BARY("ALL")'=BAR("ALL") Q  ;Not chosen Allow Cat
 ..;
 ..S BARBILL=$P($G(^BARBL(DUZ(2),BARIEN,0)),U)
 ..I BARY("RTYP")=1 D
 ...S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U)=+$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U)+1
 ...S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U,2)=+$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U,2)+$G(BAR("BAMT"))
 ..;NEED TO ADD CHECK FOR INS TYPE
 ..D TRANS  ;trans info for bill
 Q
TRANS ;EP for Looping thru Trans File
 S BARTR=0
 F  S BARTR=$O(^BARTR(DUZ(2),"AC",BARIEN,BARTR)) Q:'BARTR  D
 .; for checking Trans File data parameters
 .S BARTR(0)=$G(^BARTR(DUZ(2),BARTR,0))  ;A/R Trans 0 node
 .S BARTR(1)=$G(^BARTR(DUZ(2),BARTR,1))  ;A/R Trans 1 node
 .S BARTR("TTYP")=$P(BARTR(1),U)  ;Trans type
 .S BARTR("ADJ CAT")=$P(BARTR(1),U,2)  ;Adj Cat
 .S BARTR("ADJ TYPE")=$$GET1^DIQ(90052.02,$P(BARTR(1),U,3),.01)  ;Adj Type
 .;PKD 1.8*19 will include ADJ TYPE IEN on rpt -> BARTR("ADJ TYPIEN")
 .S BARTR("ADJ TYPIEN")=$P(BARTR(1),U,3)
 .S:BARTR("ADJ CAT")="" BARTR("ADJ CAT")="NULL"
 .;1.8*19 Use space if ADJ TYP IEN is null to prevent subscript error
 .;S:(BARTR("ADJ TYPE")="") BARTR("ADJ TYPE")="NULL"
 .I BARTR("ADJ TYPE")="" S BARTR("ADJ TYPE")="NULL",BARTR("ADJ TYPIEN")=" "
ADJTY .I $D(BARY("ADJ TYP")) Q:'$D(BARY("ADJ TYP",BARTR("ADJ TYPIEN")))  ;PKD 1.8*20 Check for Inclusion ADJ TYPE
 .S BARTR("DT")=$P(BARTR(0),U)  ;Trans date/time
 .S BARTR("TAMT")=$$GET1^DIQ(90050.03,BARTR,3.5)
 .S BARTR("INS")=$P(BAR(0),U,3)  ;A/R Acct
 .I BARTR("INS")]"" D
 ..S D0=BARTR("INS")
 ..S BARTR("ITYP")=$$VALI^BARVPM(8)  ;Ins Type
 .;I $G(BARTR("ITYP"))=""  S BARTR("BI")="No Billing Entity"
 .;I BARTR("ITYP")'="No Billing Entity" D
 .;.S BARTR("ALL")="O"  ;Other Allow Cat
 .;.I BARTR("ITYP")="G" S BARTR("ALL")="O" Q
 .;.I BARTR("ITYP")="R"!(BARTR("ITYP")="MD")!(BARTR("ITYP")="MH") S BARTR("ALL")="R" Q  ;Medicare Allow Cat
 .;.I BARTR("ITYP")="D" S BARTR("ALL")="D" Q  ;Medicaid Allow Cat
 .;.I BARTR("ITYP")="K" S BARTR("ALL")="D" Q  ;CHIPS is lumped with Medicaid
 .;.I ",F,M,H,P,T,"[(","_BARTR("ITYP")_",") S BARTR("ALL")="P" Q  ; Private
 .;I $G(BARTR("ALL"))=""  S BARTR("ALL")="No Allowance Category"
 .;I $D(BARY("ALL")),(+BARY("ALL")=BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))
 .;I $D(BARY("ALL")),BARY("ALL")'=BARTR("ALL") Q  ;Not chosen Allow Cat
 .I BARY("RTYP")=1 D SUMMARY
 .I BARY("RTYP")=2 D DETAIL
 Q
SUMMARY ;left of the "=" - LOC^INS TYPE^INSURER
 ;right of the "=" - BILL COUNT^TOTAL BILL AMT^TOTAL PYMTS^ADJ TYPE^TOTAL ADJS
 ;     ***PKD 1.8*19 adding "ADJ TYPIEN" before ADJ TYPE for sort 
 ;     ***& splitting long lines for SAC and clarity in reading
 ; update: bill count; total bill amount ;total pymts
 ; 1.8*19 Lines too long w/out change - Line body must not exceed 245 characters
 I BARTR("TTYP")=40 D
 .S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U,3)=+$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U,3)+$G(BARTR("TAMT"))
 ;I BARTR("TTYP")=43 D  ;bar*1.8*20
 I BARTR("TTYP")=43!(BARTR("TTYP")=993) D  ;bar*1.8*20
 .I +$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U,3)=0 S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U,3)=0
 .N NODE
 .;S NODE=$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPIEN"),BARTR("ADJ TYPE")))  ;total adjs  bar*1.8*20
 .S NODE=$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPIEN")_" "_BARTR("ADJ TYPE")))  ;total adjs  bar*1.8*20
 .S $P(NODE,U)=$P(NODE,U)+$G(BARTR("TAMT"))
 .;S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPIEN"),BARTR("ADJ TYPE")),U)=NODE  ;bar*1.8*20
 .S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPIEN")_" "_BARTR("ADJ TYPE")),U)=NODE  ;bar*1.8*20
 Q
 ;oldTag***  SUMMARY ;left of the "=" - LOC^INS TYPE^INSURER
 Q
 I BARTR("TTYP")=40 D
 .S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U,3)=+$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U,3)+$G(BARTR("TAMT"))
 ;total adjs
 I BARTR("TTYP")=43 D
 .I +$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))),U,3)=0 S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")),U,3)=0
 .S $P(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPE")),U)=+$P($G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BARTR("ADJ TYPE"))),U)+$G(BARTR("TAMT"))  ;total adjs
 Q
 ;
DETAIL ;left of the "=" - LOC^ALLOW CAT^INS TYPE^INSURER^BILL
 ;right of the "=" - DOS^APPROVAL DT^TOTAL BILL AMT^TOTAL PYMTS^# DAYS (DOS-APPR.DT)
 ; if adj
 ;right of the "=" - ADJ DT^ADJ TYPE^ADJ AMT^#DAYS (APPR.DT-ADJ.DT)
 S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U)=$$SDT^BARDUTL(BAR("DOS"))
 S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U,2)=$$CDT^BARDUTL(BAR("APPDT"))
 S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U,3)=BAR("BAMT")
 ;# of days between appr. date & DOS
 S X1=BAR("APPDT")
 S X2=BAR("DOS")
 D ^%DTC
 S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U,5)=X
 ;
 I BARTR("TTYP")=40 D
 .S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U,4)=$P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL),U,4)+BARTR("TAMT")
 ;I BARTR("TTYP")=43 D  ;bar*1.8*20
 I BARTR("TTYP")=43!(BARTR("TTYP")=993) D  ;bar*1.8*20
 .S BAR(BARBILL)=+$G(BAR(BARBILL))+1
 .;# of days between appr. date & adj date
 .S X1=+BARTR("DT")
 .S X2=BAR("APPDT")
 .D ^%DTC
 .;S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",+$G(BAR(BARBILL))),U,4)=X  ;bar*1.8*20
 .;PKD 1.8*19 Add  "ADJ TYPIEN" to sort
 .N NODE
 .S $P(NODE,U)=$$CDT^BARDUTL(BARTR("DT"))
 .;S $P(NODE,U,2)=BARTR("ADJ TYPE")_" "_$J(BARTR("ADJ TYPIEN"),4) move to right side
 .S $P(NODE,U,2)=$J(BARTR("ADJ TYPIEN"),4)_" "_BARTR("ADJ TYPE")
 .S $P(NODE,U,3)=BARTR("TAMT")
 .S ^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",+$G(BAR(BARBILL)))=NODE
 .;S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",+$G(BAR(BARBILL))),U)=$$CDT^BARDUTL(BARTR("DT"))
 .;S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",+$G(BAR(BARBILL))),U,2)=BARTR("ADJ TYPE")
 .;S $P(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",+$G(BAR(BARBILL))),U,3)=BARTR("TAMT")
 .; END 1.8*19
 Q
PRINT ;
 D HDB
 I '$D(^TMP($J,"BAR-TRANST"))&(BARY("RTYP")=1) D  Q
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .D EOP^BARUTL(0)
 ;summary lines
 I $D(^TMP($J,"BAR-TRANST")) W !,"LOCATION^ALLOWANCE CAT^INSURER TYPE^INSURER^BILL COUNT^TOTAL BILL AMOUNT^TOTAL PAYMENTS^ADJ TYPE IEN^ADJUSTMENT TYPE^TOTAL ADJUSTMENTS"
 S BAR("LOC")=0
 F  S BAR("LOC")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"))) Q:'BAR("LOC")  D
 .S BAR("ITYP")=""
 .F  S BAR("ITYP")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"))) Q:BAR("ITYP")=""  D
 .. ;PKD 1.8*19 12/29/10 -A/R ACCT- Zero if missing
 ..;S BAR("INS")=0
 ..;F  S BAR("INS")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))) Q:'BAR("INS")  D
 ..S BAR("INS")=""
 ..F  S BAR("INS")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"))) Q:BAR("INS")'?1N.N  D
 ...S BARO("LOC")=$P($G(^AUTTLOC(BAR("LOC"),0)),U,2)
 ...S BARO("ALLC")=$P($T(@BAR("ITYP")),";;",2)
 ...S BARO("ITYP")=$P($T(@BAR("ITYP")),";;",3)
 ...;PKD 1.8*19 fix undef if no A/R acct
 ...;S BARO("INS")=$$GET1^DIQ(90050.02,BAR("INS")_",",.01) 
 ...I BAR("INS")'=0 S BARO("INS")=$$GET1^DIQ(90050.02,BAR("INS")_",",.01) I 1
 ...E  S BARO("INS")="No A/R Account"
 ...S BARREC=BARO("LOC")_U_BARO("ALLC")_U_BARO("ITYP")_U_BARO("INS")_U
 ...W !,BARREC_$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS")))
 ...I $D(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS")) D
 ....;PKD 1.8*19 - including AdjTypeIEN
 ....;S BAR("ADJ")=""
 ....;F  S BAR("ADJ")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJ"))) Q:BAR("ADJ")=""  D
 ....S (BAR("ADJ"),BAR("ADJIEN"))=""  ;only one AdjType per AdjTypeIEN
 ....S BARACNT=0
 ....F  S BAR("ADJIEN")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJIEN"))) Q:BAR("ADJIEN")=""  D
 .....;S BAR("ADJ")=$O(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJIEN"),""))  ;bar*1.8*20
 .....I BARACNT'=0 W !,BARREC_U_U
 .....;W U_BAR("ADJ")_U_$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJ"))) 1.8.19
 .....;W U_BAR("ADJIEN")_U_BAR("ADJ")_U_$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJIEN"),BAR("ADJ")))  ;bar*1.8*20
 .....W U_BAR("ADJIEN")_U_BAR("ADJ")_U_$G(^TMP($J,"BAR-TRANST",BAR("LOC"),BAR("ITYP"),BAR("INS"),"ADJS",BAR("ADJIEN")))  ;bar*1.8*20
 .....S BARACNT=1
 ;detail lines
 I '$D(^TMP($J,"BAR-TRANS"))&(BARY("RTYP")=2) D  Q
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .D EOP^BARUTL(0)
 I $D(^TMP($J,"BAR-TRANS")) W !,"LOCATION^ALLOWANCE CAT^INSURER TYPE^INSURER^BILL^DOS^APPROVAL DT^TOTAL BILL AMT^TOTAL PAYMENTS^#DAYS (DOS-APPR.DT)^ADJUSTMENT DT^ADJUSTMENT TYPE^ADJUSTMENT AMT^#DAYS (APPR.DT-ADJ.DT)"
 S BAR("LOC")=0
 F  S BAR("LOC")=$O(^TMP($J,"BAR-TRANS",BAR("LOC"))) Q:'BAR("LOC")  D
 .S BAR("ITYP")=""
 .F  S BAR("ITYP")=$O(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"))) Q:BAR("ITYP")=""  D
 ..;PKD 1.8*19 If A/R acct is missing
 ..;S BAR("INS")=0
 ..;F  S BAR("INS")=$O(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"))) Q:'BAR("INS")  D
 ..S BAR("INS")=""
 ..F  S BAR("INS")=$O(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"))) Q:BAR("INS")'?1N.N  D
 ...S BARBILL=""
 ...F  S BARBILL=$O(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL)) Q:BARBILL=""  D
 ....S BARO("LOC")=$P($G(^AUTTLOC(BAR("LOC"),0)),U,2)
 ....S BARO("ALLC")=$P($T(@BAR("ITYP")),";;",2)
 ....S BARO("ITYP")=$P($T(@BAR("ITYP")),";;",3)
 ....;PKD 1.8*19 fix undef if no A/R acct
 ....;S BARO("INS")=$$GET1^DIQ(90050.02,BAR("INS")_",",.01)
 ....I BAR("INS")'=0 S BARO("INS")=$$GET1^DIQ(90050.02,BAR("INS")_",",.01) I 1
 ....E  S BARO("INS")="No A/R Account"
 ....S BARREC=BARO("LOC")_U_BARO("ALLC")_U_BARO("ITYP")_U_BARO("INS")_U_BARBILL_U
 ....;PKD 1.8.20 1/25/11 BARDET - print detail all adj lines
 ....;W !,BARREC_$G(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL))
 ....S BARDTAIL=$G(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL))
 ....W !,BARREC_BARDTAIL
 ....;end 1.8.20
 ....I $D(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS")) D
 .....S BARACNT=0
 .....F  S BARACNT=$O(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",BARACNT)) Q:'BARACNT  D
 ......;PKD 1.8*20 1/25/11 BARDET - Print bill amt even if >1 adj / bill
 ......;I BARACNT>1 W !,BARREC_U_U_U_U
 ......I BARACNT>1 D
 .......I BARDET W !,BARREC_BARDTAIL
 .......E  W !,BARREC_U_U_U_U
 ......;END 1.8*20
 ......W U_$G(^TMP($J,"BAR-TRANS",BAR("LOC"),BAR("ITYP"),BAR("INS"),BARBILL,"ADJS",BARACNT))
 Q
HDB ; EP
 ; Page & column hdr
 ;EP for writing Rpt Hdr
 W $$EN^BARVDF("IOF"),!
 I $D(BAR("PRIVACY")) W ?($S($D(BAR(132)):34,$D(BAR(180)):68,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!
 K BAR("LINE")
 S $P(BAR("LINE"),"=",$S($D(BAR(133)):132,$D(BAR(180)):181,1:81))=""
 W BAR("LINE"),!
 W BAR("HD",0),?$S($D(BAR(132)):102,$D(BAR(180)):150,1:51)
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 W $P(Y,":",1,2)
 S BAR("TMPLVL")=0
 F  S BAR("TMPLVL")=$O(BAR("HD",BAR("TMPLVL"))) Q:'BAR("TMPLVL")&(BAR("TMPLVL")'=0)  W:$G(BAR("HD",BAR("TMPLVL")))]"" !,BAR("HD",BAR("TMPLVL"))
 W !,BAR("LINE")
 K BAR("LINE")
 Q
 ;
R ;;MEDICARE;;MEDICARE FI
D ;;MEDICAID;;MEDICAID FI
F ;;PRIVATE INSURANCE;;FRATERNAL ORGANIZATION
P ;;PRIVATE INSURANCE;;PRIVATE INSURANCE
H ;;PRIVATE INSURANCE;;HMO
M ;;PRIVATE INSURANCE;;MEDICARE SUPPL.
N ;;OTHER;;NON-BENEFICIARY (NON-INDIAN)
I ;;OTHER;;INDIAN PATIENT
W ;;OTHER;;WORKMEN'S COMP
C ;;OTHER;;CHAMPUS
K ;;MEDICAID;;CHIP (KIDSCARE)
T ;;PRIVATE INSURANCE;;THIRD PARTY LIABILITY
G ;;OTHER;;GUARANTOR
MD ;;MEDICARE;;MCR PART D
MH ;;MEDICARE;;MEDICARE HMO
 ;
