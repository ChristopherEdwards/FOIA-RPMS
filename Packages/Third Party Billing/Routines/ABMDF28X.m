ABMDF28X ; IHS/ASDST/DMJ - PRINT UB-04 ;  
 ;;2.6;IHS Third Party Billing;**1,3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25033 - Made changes for NM Medicaid
 ; IHS/SD/SDR - v2.5 p12 - IM25136 - Made change for alignment of FL4
 ; IHS/SD/SDR - v2.5 p12 - IM24881 - Form alignment changes
 ; IHS/SD/SDR - v2.5 p13 - IM25889 - Fix for blank page between forms
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4566 - Override address for San Felipe Pueblo
 ; IHS/SD/SDR - abm*2.6*1 - HEAT5837 - Print delayed reason code
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7998 - print patient when ITYP="N"
 ; IHS/SD/SDR - abm*2.6*1 - FIXPMS10028 - check FL38 and what address to print
 ; IHS/SD/SDR - abm*2.6*3 - HEAT13774 - fix <UNDEF>12+28^ABMDF28X
 ;
 ;**********************************************************************
 ;
 K ABM
 S ABMP("LM")=$P(^ABMDEXP(28,0),"^",2)  ; Left margin of form
 ;
 ; FOLLOWING LINE TAGS CORRESPOND TO LINE NUMBERS
 ;
1 ; EP
 ; Provider name -- form locator #1-line 1
 W !
 S ABMP("NOFMT")=1  ;format flag (1 = no special formatting)
 D 120^ABMER10      ;Provider name
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,120)="SAN FELIPE HS"
 S ABMDE=$P(^DIC(4,ABMP("LDFN"),0),U)_"^^25"  ; data ^ tab ^ format
 D WRT^ABMDF28W     ;write data in specified format
 S ABMDE=ABMR(10,120)_"^25^25"  ;Pay-To Name -- form locator #2-line 1
 I $$RCID^ABMERUTL(ABMP("INS"))=61044 S ABMDE=""
 D WRT^ABMDF28W     ;write data in specified format
 D 30^ABMER20       ;Patient control number -- form locator #3a
 S ABMDE=ABMR(20,30)_"^53^24"
 D WRT^ABMDF28W
 ;
2 ;
 ; Provider address, Patient control number, Bill type
 W !
 D 130^ABMER10  ;Provider address -- form locator #1-line 2
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,130)="PO BOX 4339"
 I $D(^DIC(4,ABMP("LDFN"),1)) D
 .S ABMVLOC=^DIC(4,ABMP("LDFN"),1)
 S ABMDE=$P($G(ABMVLOC),U)_"^^25"
 D WRT^ABMDF28W
 D 130^ABMER10  ; Pay-To Address -- form locator #2-line 2
 S ABMDE=ABMR(10,130)_"^25^25"
 I $$RCID^ABMERUTL(ABMP("INS"))=61044 S ABMDE=""
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMDE="PO BOX 4342^25^25"  ;abm*2.6*1 HEAT4566
 D WRT^ABMDF28W
 S ABMP("HRN")=$P($G(^AUPNPAT(+ABMP("PDFN"),41,+ABMP("LDFN"),0)),U,2)
 S:ABMP("HRN")="" ABMP("HRN")=$P($G(^AUPNPAT(+ABMP("PDFN"),41,DUZ(2),0)),U,2)
 S ABMDE=$G(ABMP("HRN"))_"^53^24"  ;Patient HRN - form locator #3b
 D WRT^ABMDF28W
 S ABMDE=ABMP("BTYP")_"^77^4"  ;Bill type -- form locator #4
 D WRT^ABMDF28W
 ;
3 ;
 ; Provider city, state, zip  -- form locator #1-line 3
 W !
 D 140^ABMER10  ;Provider city
 D 150^ABMER10  ;Provider state
 D 160^ABMER10  ;Provider zip
 I $L(ABMR(10,160))=9 D
 .S ABMR(10,160)=$E(ABMR(10,160),1,5)_"-"_$E(ABMR(10,160),6,9)
 .Q
 I $D(^DIC(4,ABMP("LDFN"),1)) D
 .S ABMVLOC=$G(^DIC(4,ABMP("LDFN"),1))
 .S ABMLCTY=$P(ABMVLOC,U,3)
 .S ABMLST=$P(^DIC(5,$P(^DIC(4,ABMP("LDFN"),0),U,2),0),U,2)
 .S ABMLZIP=$P(ABMVLOC,U,4)
 .S ABMDE=ABMLCTY_", "_ABMLST_" "_ABMLZIP_"^^25"
 I $$RCID^ABMERUTL(ABMP("INS"))=61044 S ABMDE=$TR(ABMDE,",-")
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMDE="SAN FELIPE, NM 87001^^25"
 D WRT^ABMDF28W
 ; Pay-To city, state, zip  -- form locator #2-line 3
 I $L(ABMR(10,160))=9 D
 .S ABMR(10,160)=$E(ABMR(10,160),1,5)_"-"_$E(ABMR(10,160),6,9)
 .Q
 S ABMDE=$E(ABMR(10,140),1,12)_", "_ABMR(10,150)_" "_ABMR(10,160)_"^25^25"
 I $$RCID^ABMERUTL(ABMP("INS"))=61044 S ABMDE=""
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMDE="SAN FELIPE PUEBLO, NM 87001^25^27"  ;abm*2.6*1 HEAT4566
 D WRT^ABMDF28W
 ;
4 ;
 W !
 D 110^ABMER10  ;Provider phone          -- form locator #1-line 4
 D 40^ABMER10   ;Fed. tax number         -- form locator #5
 D 190^ABMER20  ;Stmt covers period from -- form locator #6
 D 200^ABMER20  ;Stmt covers period to   -- form locator #6
 D 200^ABMER30  ;Covered days            -- form locator #7-old
 D 210^ABMER30  ;Non-covered days        -- form locator #8-old
 D 220^ABMER30  ;Co-insured days         -- form locator #9-old
 D 230^ABMER30  ;Lifetime reserve days   -- form locator #10-old
 S ABMDE=ABMR(10,110)_"^^25"
 D WRT^ABMDF28W
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,40)=850210848
 S ABMDE=$TR(ABMR(10,40),"-")_"^50^10"  ;#5
 D WRT^ABMDF28W
 S ABMDE=ABMR(20,190)_"^60^6"  ;#6
 D WRT^ABMDF28W
 S ABMDE=ABMR(20,200)_"^67^6"  ;#6
 D WRT^ABMDF28W
 S ABMP("CDAYS")=$G(ABMR(30,200))
 ;
6 ;
 ; Patient's name and mailing address
 W !
 K ABMP("PNAME")
 N I
 F I=40:10:60 D  ;Patient name -- form locator #9
 .D @(I_"^ABMER20A")
 N I
 F I=120:10:160 D  ;Patient mailing address -- form locator #9
 .D @(I_"^ABMER20")
 S ABMDE=ABMR(20,120)_$S(ABMR(20,130)]"":" "_ABMR(20,130),1:"")_"^41^40"  ;patient str address #9a
 D WRT^ABMDF28W
 W !
 S ABMP("PNAME")=ABMR(20,40)_", "_ABMR(20,50)_" "_ABMR(20,60)
 S ABMDE=ABMP("PNAME")_"^2^29"  ;#8b
 D WRT^ABMDF28W
 S ABMDE=ABMR(20,140)_"^31^30"  ;patient city #9b
 D WRT^ABMDF28W
 S ABMDE=ABMR(20,150)_"^64^2"  ;patient state #9c
 D WRT^ABMDF28W
 S ABMDE=ABMR(20,160)_"^68^9"  ;patient zip  #9d
 D WRT^ABMDF28W
 S ABMP("NOFMT")=0
8 ;
 W !!
 K ABMR
 N I
 F I=70:10:110 D
 .D @(I_"^ABMER20A")
 N I
 F I=170,180,210,220,250 D
 .D @(I_"^ABMER20")
 N I
 F I=40:10:130,210 D
 .D @(I_"^ABMER41A")
 S ABMDE=ABMR(20,80)_"^^8"  ;Patient Birthdate
 D WRT^ABMDF28W  ; form locator #10
 S ABMDE=ABMR(20,70)_"^10^1"  ;Patient sex code
 D WRT^ABMDF28W  ; form locator #11
 S:ABMR(20,170) ABMDE=ABMR(20,170)_"^12^6"  ;Admission date
 D WRT^ABMDF28W  ; form locator #12
 S:ABMR(20,180) ABMDE=ABMR(20,180)_"^18^3"  ;Admission hour
 D WRT^ABMDF28W  ; form locator #13
 I +$G(ABMR(20,100))'=0 S ABMR(20,100)="0"_ABMR(20,100)
 S ABMDE=(ABMR(20,100))_"^21^3"  ;Type of admission
 I ($P($G(^AUTNINS(ABMP("INS"),0)),U)="NEW MEXICO MEDICAID")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="MEDICAID EXEMPT") S ABMDE=+(ABMR(20,100))_"^21^3"
 D WRT^ABMDF28W  ; form locator #14
 I +$G(ABMR(20,110))'=0 S ABMR(20,110)="0"_ABMR(20,110)
 S ABMDE=(ABMR(20,110))_"^24^3"  ;Source of admission
 I ($P($G(^AUTNINS(ABMP("INS"),0)),U)="NEW MEXICO MEDICAID")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="MEDICAID EXEMPT") S ABMDE=+(ABMR(20,110))_"24^3"
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)="ARIZONA MEDICAID",(ABMP("VTYP")=998) S ABMDE="^^24^3"
 D WRT^ABMDF28W  ; form locator #15
 S:ABMR(20,220) ABMDE=ABMR(20,220)_"^27^3"  ;Discharge hour
 D WRT^ABMDF28W  ; form locator #16
 S:ABMR(20,210) ABMDE=ABMR(20,210)_"^30^3"  ;Pat discharge status
 D WRT^ABMDF28W  ; form locator #17
 ;
 S ABMDE=ABMR(41,40)_"^33^3"  ; Condition code - 1
 D WRT^ABMDF28W  ; form locator #18
 S ABMDE=ABMR(41,50)_"^37^3"  ; Condition code - 2
 D WRT^ABMDF28W  ; form locator #19
 S ABMDE=ABMR(41,60)_"^40^3"  ; Condition code - 3
 D WRT^ABMDF28W  ; form locator #20
 S ABMDE=ABMR(41,70)_"^43^3"  ; Condition code - 4
 D WRT^ABMDF28W  ; form locator #21 
 S ABMDE=ABMR(41,80)_"^46^3"  ; Condition code - 5
 D WRT^ABMDF28W  ; form locator #22
 S ABMDE=ABMR(41,90)_"^49^3"  ; Condition code - 6
 D WRT^ABMDF28W  ; form locator #23
 S ABMDE=ABMR(41,100)_"^52^3"  ; Condition code - 7
 D WRT^ABMDF28W  ; form locator #24
 S ABMDE=$G(ABMR(41,110))_"^55^3"  ; Condition code - 8
 D WRT^ABMDF28W  ; form locator #25
 S ABMDE=$G(ABMR(41,120))_"^58^3"  ; Condition code - 9
 D WRT^ABMDF28W  ; form locator #26
 S ABMDE=$G(ABMR(41,130))_"^61^3"  ; Condition code - 10
 D WRT^ABMDF28W  ; form locator #27
 S ABMDE=$G(ABMR(41,210))_"^64^3"  ; Condition code - 11
 D WRT^ABMDF28W  ; form locator #28
 ;
 S ABMDE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,16)  ;accident state
 I ABMDE S ABMDE=$P($G(^DIC(5,ABMDE,0)),U,2)_"^69^2" D WRT^ABMDF28W  ;form locator #29
 ;
10 ;
 W !!
 K ABMR
 N I
 F I=80:10:150 D
 .D @(I_"^ABMER40A")
 N I
 F I=280:10:300,350:10:400 D
 .D @(I_"^ABMER40")
 ;
 F I=160,170 D
 .D @(I_"^ABMER40A")
 N I
 F I=180:10:230,310:10:330 D
 .D @(I_"^ABMER40")
 S ABMDE=ABMR(40,80)_"^^2"  ; Occurrence code - 1
 D WRT^ABMDF28W  ;form locator #31a
 S ABMDE=ABMR(40,90)_"^3^6"  ; Occurrence date - 1
 D WRT^ABMDF28W  ;form locator #31a
 ;
 S ABMDE=ABMR(40,100)_"^10^2"  ; Occurrence code - 2
 D WRT^ABMDF28W  ; form locator #32a
 S ABMDE=ABMR(40,110)_"^13^6"  ; Occurrence date - 2
 D WRT^ABMDF28W  ; form locator #32a
 ;
 S ABMDE=ABMR(40,120)_"^20^2"  ; Occurrence code - 3
 D WRT^ABMDF28W  ; form locator #33a
 S ABMDE=ABMR(40,130)_"^23^6"  ;Occurrence date - 3
 D WRT^ABMDF28W  ; form locator #33a
 ;
 S ABMDE=ABMR(40,140)_"^30^2"  ; Occurrence code - 4
 D WRT^ABMDF28W  ; form locator #34a
 S ABMDE=ABMR(40,150)_"^33^6"  ; Occurrence date - 4
 D WRT^ABMDF28W  ; form locator #34a
 ;
 S ABMDE=ABMR(40,280)_"^40^2"  ; Occur. Span code - 1
 D WRT^ABMDF28W  ; form locator #35a
 S ABMDE=ABMR(40,290)_"^43^6"  ; Occur. Span from date - 1
 D WRT^ABMDF28W  ; form locator #35a
 S ABMDE=ABMR(40,300)_"^50^6"  ; Occur. Span thru date - 1
 D WRT^ABMDF28W  ; form locator #35a
 ;
 S ABMDE=ABMR(40,310)_"^57^2"  ; Occur. Span code - 1
 D WRT^ABMDF28W  ; form locator #36a
 S ABMDE=ABMR(40,320)_"^60^6"  ; Occur. Span from date - 1
 D WRT^ABMDF28W  ; form locator #36a
 S ABMDE=ABMR(40,330)_"^67^6"  ; Occur. Span thru date - 1
 D WRT^ABMDF28W  ; form locator #36a
 ;start new code abm*2.6*1 HEAT5837
 S ABMDE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,16)  ;delayed reason code
 I ABMDE S ABMDE=$P($G(^ABMDCODE(ABMDE,0)),U)_"^74^7" D WRT^ABMDF28W  ;form locator #37a
 ;end new code HEAT5837
11 ;
 W !
 N I
 S ABMDE=ABMR(40,160)_"^^2"  ; Occurrence code - 5
 D WRT^ABMDF28W  ; form locator #31b
 S ABMDE=ABMR(40,170)_"^3^6"  ; Occurrence date - 5
 D WRT^ABMDF28W  ; form locator #31b
 ;
 S ABMDE=ABMR(40,180)_"^10^2"  ; Occurrence code - 6
 D WRT^ABMDF28W  ; form locator #32b
 S ABMDE=ABMR(40,190)_"^13^6"  ; Occurrence date - 6
 D WRT^ABMDF28W  ; form locator #32b
 ;
 S ABMDE=ABMR(40,200)_"^20^2"  ; Occurrence code - 7
 D WRT^ABMDF28W  ; form locator #33b
 S ABMDE=ABMR(40,210)_"^23^6"  ; Occurrence date - 7
 D WRT^ABMDF28W  ; form locator #33b
 ;
 S ABMDE=ABMR(40,220)_"^30^2"  ; Occurrence code - 8
 D WRT^ABMDF28W  ; form locator #34b
 S ABMDE=ABMR(40,230)_"^33^6"  ; Occurrence date - 8
 D WRT^ABMDF28W  ; form locator #34b
 ;
 S ABMDE=ABMR(40,350)_"^40^2"  ; Occur. Span code - 3
 D WRT^ABMDF28W  ; form locator #35b
 S ABMDE=ABMR(40,360)_"^43^6"  ; Occur. Span from date - 3
 D WRT^ABMDF28W  ; form locator #35b
 S ABMDE=ABMR(40,370)_"^50^6"  ; Occur. Span thru date - 3
 D WRT^ABMDF28W  ; form locator #35b
 ;
 S ABMDE=ABMR(40,380)_"^57^2"  ; Occur. Span code - 4
 D WRT^ABMDF28W  ; form locator #36b
 S ABMDE=ABMR(40,390)_"^60^6"  ; Occur. Span from date - 4
 D WRT^ABMDF28W  ; form locator #36b
 S ABMDE=ABMR(40,400)_"^67^6"  ; Occur. Span thru date - 4
 D WRT^ABMDF28W  ; form locator #36b
 ;
 S ABMDE=$E($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9),1,22)
 S:ABMDE'="" ABMDE=ABMDE_"^58^22"
 D WRT^ABMDF28W
 ;
12 ;
 ; If private insurance and relationship of policy holder to patient
 ; is not self, write name of policy holder
 W !
 ;S ABM38FLG=$P($G(^ABMDPARM(DUZ(2),1,2)),U,10)  ;abm*2.6*1 FIXPMS10028
 S ABM38FLG=""  ;abm*2.6*1 FIXPMS10028
 S ABM38FLG=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,15)  ;abm*2.6*1 FIXPMS10028
 S:ABM38FLG="" ABM38FLG=$P($G(^ABMDPARM(DUZ(2),1,2)),U,10)  ;abm*2.6*1 FIXPMS10028
 I ABM38FLG["P" D
 .;I ABMP("ITYPE")="P" D  ;abm*2.6*1 FIXPMS10028
 .I "^P^H^F^M^"[("^"_ABMP("ITYPE")_"^") D  ;abm*2.6*1 FIXPMS10028
 ..;
 ..N I
 ..S I=0
 ..F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D  ;insurer
 ...; insurer status = initiated
 ...I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I" D
 ....S ABME("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U)
 ....S ABME("INSIEN")=I
 ..Q:'$G(ABME("INSIEN"))
 ..D PRVT^ABMERINS
 ..S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),2,"E"))_"^^40"  ;card name-policy holder
 ..S:($P(ABMDE,U)="") $P(ABMDE,U)=$G(ABM(9000003.1,+$G(ABME("PH")),.01,"E"))_"^^40"  ;name-policy holder
 ..D WRT^ABMDF28W   ;form locator 38
 ..Q
 .;start new code abm*2.6*1 FIXPMS10028
 .;MCR
 .I "^R^MD^MH^"[("^"_ABMP("ITYPE")_"^") D
 ..D ISET^ABMERUTL  ;abm*2.6*3 HEAT13774
 ..S IENS=$P($G(ABMP(("INS"),ABME("INS#"))),U,3)_","_ABMP("PDFN")_","
 ..S ABMDE=$$GET1^DIQ(9000003.11,IENS,".05","E")_"^^40"  ;MCR name
 ..D WRT^ABMDF28W   ;form locator 38
 .;MCD
 .I "^D^K^"[("^"_ABMP("ITYPE")_"^") D
 ..S ABMDE=$$GET1^DIQ(9000004,+$G(ABMCDNUM),2101,"E")_"^^40"  ;MCD name
 ..D WRT^ABMDF28W   ;form locator 38
 .;
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMDE=$G(ABMP("PNAME"))_"^^40"  ;patient name
 ..D WRT^ABMDF28W  ;form locator 38
 .;end new code FIXPMS10028
 ;
 I ABM38FLG["I" D
 .;start new code abm*2.6*1 HEAT7998
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMDE=$G(ABMP("PNAME"))_"^^40"  ;patient name
 ..D WRT^ABMDF28W  ;form locator 38
 .;end new code HEAT7998
 .S (ABMINMF,ABMISTRF)=""
 .; billing office
 .I $P($G(^AUTNINS(ABMP("INS"),1)),U)'="" D
 ..S ABMINM=$P(^AUTNINS(ABMP("INS"),1),U)
 ..S ABMINMF=1
 .E  S ABMINM=$P($G(^AUTNINS(ABMP("INS"),0)),U)
 .; street address
 .I $G(ABMINMF)=1,$P($G(^AUTNINS(ABMP("INS"),1)),U,2)'="" D
 ..S ABMISTR=$P(^AUTNINS(ABMP("INS"),1),U,2)
 ..S ABMISTRF=1
 .E  S ABMISTR=$P($G(^AUTNINS(ABMP("INS"),0)),U,2)
 .;
 .I ABMINMF=1,ABMISTRF=1 S ABMI=1
 .E  S ABMI=0
 .S ABMICTY=$P($G(^AUTNINS(ABMP("INS"),ABMI)),U,3)
 .S ABMIST=$P($G(^AUTNINS(ABMP("INS"),ABMI)),U,4)
 .S ABMIZIP=$P($G(^AUTNINS(ABMP("INS"),ABMI)),U,5)
 .S ABMDE=ABMINM_"^^40"
 .D WRT^ABMDF28W    ;form locator #38 line1
 ;
 I ABM38FLG["B"     ;if B it shouldn't do anything
 I $G(ABMORE)'="" D
 .D 13^ABMDF28Y
 Q:$G(ABMORE)
 ;
OTHER ;DO OTHER ROUTINES & QUIT
 D ^ABMDF28Y,^ABMDF28Z
 W $$EN^ABMVDF("IOF")
 K ABMR,ABMREC,ABM,ABME
 K ABMINM,ABMISTR,ABMICTY,ABMIST,ABMIZIP
 Q
 ;
TEST ;
 ; EP;Test forms allignment
 D TEST^ABMDF28W
 Q
