ABMDF11X ; IHS/ASDST/DMJ - PRINT UB92 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ; IHS/SD/SDR - v2.5 p8 - IM14893/IM15353
 ;    Removal of "0" from FL19 and FL20
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15034
 ;    Modified to print 2-page claims correctly
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM12048
 ;    Correction to FL4
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM18032
 ;    Put Medicaid Resubmission Number in FL37
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16991
 ;    Added code for San Felipe VT 998
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM17778
 ;   Added code for AZ Medicaid to not print source of admission if VT 998
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20182/IM20211
 ;   Fixed FL4 to keep it from wrapping
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20000
 ;   Added code to use CARD NAME for Policy Holder
 ;**********************************************************************
 ;
 K ABM
 S ABMP("LM")=$P(^ABMDEXP(11,0),"^",2)  ; Left margin of form
 ;
 ; FOLLOWING LINE TAGS CORRESPOND TO LINE NUMBERS
 ;
1 ; EP
 ; Provider name -- form locator #1
 W !
 S ABMP("NOFMT")=1  ; format flag (1 = no special formatting)
 D 120^ABMER10      ; Provider name
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,120)="SAN FELIPE HS"
 S ABMDE=ABMR(10,120)_"^^25"  ; data ^ tab ^ format
 D WRT^ABMDF11W     ; write data in specified format
 ;
2 ;
 ; Provider address, Patient control number, Bill type
 W !
 D 130^ABMER10      ; Provider address -- form locator #1
 D 30^ABMER20       ; Patient control number -- form locator #3
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,130)="PO BOX 4339"
 S ABMDE=ABMR(10,130)_"^^25"
 D WRT^ABMDF11W
 S ABMDE=ABMR(20,30)_"^57^20"
 D WRT^ABMDF11W
 S ABMDE=ABMP("BTYP")_"^77^3"  ; Bill type -- form locator #4
 D WRT^ABMDF11W
 ;
3 ;
 ; Provider city, state, zip  -- form locator #1
 W !
 D 140^ABMER10      ; Provider city
 D 150^ABMER10      ; Provider state
 D 160^ABMER10      ; Provider zip
 I $L(ABMR(10,160))=9 D
 . S ABMR(10,160)=$E(ABMR(10,160),1,5)_"-"_$E(ABMR(10,160),6,9)
 . Q
 S ABMDE=ABMR(10,140)_", "_ABMR(10,150)_" "_ABMR(10,160)_"^^25"
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMDE="SAN FELIPE, NM 87001^^25"
 D WRT^ABMDF11W
 ;
4 ;
 W !
 D 110^ABMER10      ; Provider phone          -- form locator #1
 D 40^ABMER10       ; Fed. tax number         -- form locator #5
 D 190^ABMER20      ; Stmt covers period from -- form locator #6
 D 200^ABMER20      ; Stmt covers period to   -- form locator #6
 D 200^ABMER30      ; Covered days            -- form locator #7
 D 210^ABMER30      ; Non-covered days        -- form locator #8
 D 220^ABMER30      ; Co-insured days         -- form locator #9
 D 230^ABMER30      ; Lifetime reserve days   -- form locator #10
 S ABMDE=ABMR(10,110)_"^^25"
 D WRT^ABMDF11W
 I DUZ(2)=1581,(ABMP("VTYP")=998) S ABMR(10,40)=850210848
 S ABMDE=ABMR(10,40)_"^26^10"
 D WRT^ABMDF11W
 S ABMDE=ABMR(20,190)_"^37^6"
 D WRT^ABMDF11W
 S ABMDE=ABMR(20,200)_"^44^6"
 D WRT^ABMDF11W
 S ABMDE=ABMR(30,200)_"^51^3R"
 S ABMP("CDAYS")=$G(ABMR(30,200))
 D:ABMR(30,200) WRT^ABMDF11W
 S ABMDE=ABMR(30,210)_"^55^4R"
 D:ABMR(30,210) WRT^ABMDF11W
 S ABMDE=ABMR(30,220)_"^60^3R"
 D WRT^ABMDF11W
 S ABMDE=ABMR(30,230)_"^64^3R"
 D WRT^ABMDF11W
 ;
6 ;
 ; Patient's name and mailing address
 W !!
 K ABMP("PNAME")
 N I
 F I=40:10:60 D     ; Patient name            -- form locator #12
 . D @(I_"^ABMER20A")
 N I
 F I=120:10:160 D   ; Patient mailing address -- form locator #13
 . D @(I_"^ABMER20")
 I $L(ABMR(20,160))=9 D
 . S ABMR(20,160)=$E(ABMR(20,160),1,5)_"-"_$E(ABMR(20,160),6,9)
 . Q
 S ABMP("PNAME")=ABMR(20,40)_", "_ABMR(20,50)_" "_ABMR(20,60)
 S ABMDE=ABMP("PNAME")_"^^30"
 D WRT^ABMDF11W
 S ABMDE=ABMR(20,120)_$S(ABMR(20,130)]"":" "_ABMR(20,130),1:"")_", "_ABMR(20,140)_", "_ABMR(20,150)_" "_ABMR(20,160)_"^31^50"
 D WRT^ABMDF11W
 S ABMP("NOFMT")=0
 ; Quit if printing additional pages to ONE itemized UB-92 claim
 ;
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
 F I=40:10:100 D
 .D @(I_"^ABMER41A")
 S ABMDE=ABMR(20,80)_"^^8"                   ; Patient Birthdate
 D WRT^ABMDF11W                                  ; form locator #14
 S ABMDE=ABMR(20,70)_"^9^1"                  ; Patient sex code
 D WRT^ABMDF11W                                  ; form locator #15
 S ABMDE=ABMR(20,90)_"^12^1"                 ; Marital Status code
 D WRT^ABMDF11W                                  ; form locator #16
 S:ABMR(20,170) ABMDE=ABMR(20,170)_"^14^6"   ; Admission date
 D WRT^ABMDF11W                                  ; form locator #17
 S:ABMR(20,180) ABMDE=ABMR(20,180)_"^21^2"   ; Admission hour
 D WRT^ABMDF11W                                  ; form locator #18
 I +$G(ABMR(20,100))'=0 S ABMR(20,100)="0"_ABMR(20,100)
 S ABMDE=(ABMR(20,100))_"^24^2"            ; Type of admission
 D WRT^ABMDF11W                                  ; form locator #19
 I +$G(ABMR(20,110))'=0 S ABMR(20,110)="0"_ABMR(20,110)
 S ABMDE=(ABMR(20,110))_"^27^2"            ; Source of admission
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)="ARIZONA MEDICAID",(ABMP("VTYP")=998) S ABMDE="^^28^2"
 D WRT^ABMDF11W                                  ; form locator #20
 S:ABMR(20,220) ABMDE=ABMR(20,220)_"^30^2"   ; Discharge hour
 D WRT^ABMDF11W                                  ; form locator #21
 S:ABMR(20,210) ABMDE=ABMR(20,210)_"^33^2"   ; Pat discharge status
 D WRT^ABMDF11W                                  ; form locator #22
 S ABMDE=ABMR(20,250)_"^36^17"               ; Medical record num.
 D WRT^ABMDF11W                                  ; form locator #23
 S ABMDE=ABMR(41,40)_"^54^2"                 ; Condition code - 1
 D WRT^ABMDF11W                                  ; form locator #24
 S ABMDE=ABMR(41,50)_"^57^2"                 ; Condition code - 2
 D WRT^ABMDF11W                                  ; form locator #25
 S ABMDE=ABMR(41,60)_"^60^2"                 ; Condition code - 3
 D WRT^ABMDF11W                                  ; form locator #26
 S ABMDE=ABMR(41,70)_"^63^2"                 ; Condition code - 4
 D WRT^ABMDF11W                                  ; form locator #27 
 S ABMDE=ABMR(41,80)_"^66^2"                 ; Condition code - 5
 D WRT^ABMDF11W                                  ; form locator #28
 S ABMDE=ABMR(41,90)_"^69^2"                 ; Condition code - 6
 D WRT^ABMDF11W                                  ; form locator #29
 S ABMDE=ABMR(41,100)_"^72^2"                ; Condition code - 7
 D WRT^ABMDF11W                                  ; form locator #30
 ;
10 ;
 W !!
 K ABMR
 N I
 F I=80:10:150 D
 .D @(I_"^ABMER40A")
 N I
 F I=280:10:300 D
 .D @(I_"^ABMER40")
 S ABMDE=ABMR(40,80)_"^^2"              ; Occurrence code - 1
 D WRT^ABMDF11W                             ; form locator #32a
 S ABMDE=ABMR(40,90)_"^3^6"             ; Occurrence date - 1
 D WRT^ABMDF11W                             ; form locator #32a
 S ABMDE=ABMR(40,100)_"^10^2"           ; Occurrence code - 2
 D WRT^ABMDF11W                             ; form locator #33a
 S ABMDE=ABMR(40,110)_"^13^6"           ; Occurrence date - 2
 D WRT^ABMDF11W                             ; form locator #33a
 S ABMDE=ABMR(40,120)_"^20^2"           ; Occurrence code - 3
 D WRT^ABMDF11W                             ; form locator #34a
 S ABMDE=ABMR(40,130)_"^23^6"           ; Occurrence date - 3
 D WRT^ABMDF11W                             ; form locator #34a
 S ABMDE=ABMR(40,140)_"^30^2"           ; Occurrence code - 4
 D WRT^ABMDF11W                             ; form locator #35a
 S ABMDE=ABMR(40,150)_"^33^6"           ; Occurrence date - 4
 D WRT^ABMDF11W                             ; form locator #35a
 S ABMDE=ABMR(40,280)_"^40^2"           ; Occur. Span code - 1
 D WRT^ABMDF11W                             ; form locator #36a
 S ABMDE=ABMR(40,290)_"^43^6"           ; Occur. Span from date - 1
 D WRT^ABMDF11W                             ; form locator #36a
 S ABMDE=ABMR(40,300)_"^50^6"           ; Occur. Span thru date - 1
 D WRT^ABMDF11W                             ; form locator #36a
 ;
11 ;
 W !
 K ABMR
 N I
 F I=160,170 D
 .D @(I_"^ABMER40A")
 N I
 F I=180:10:230,310:10:330 D
 .D @(I_"^ABMER40")
 S ABMDE=ABMR(40,160)_"^^2"             ; Occurrence code - 5
 D WRT^ABMDF11W                             ; form locator #32b
 S ABMDE=ABMR(40,170)_"^3^6"            ; Occurrence date - 5
 D WRT^ABMDF11W                             ; form locator #32b
 S ABMDE=ABMR(40,180)_"^10^2"           ; Occurrence code - 6
 D WRT^ABMDF11W                             ; form locator #33b
 S ABMDE=ABMR(40,190)_"^13^6"           ; Occurrence date - 6
 D WRT^ABMDF11W                             ; form locator #33b
 S ABMDE=ABMR(40,200)_"^20^2"           ; Occurrence code - 7
 D WRT^ABMDF11W                             ; form locator #34b
 S ABMDE=ABMR(40,210)_"^23^6"           ; Occurrence date - 7
 D WRT^ABMDF11W                             ; form locator #34b
 S ABMDE=ABMR(40,220)_"^30^2"           ; Occurrence code - 8
 D WRT^ABMDF11W                             ; form locator #35b
 S ABMDE=ABMR(40,230)_"^33^6"           ; Occurrence date - 8
 D WRT^ABMDF11W                             ; form locator #35b
 S ABMDE=ABMR(40,310)_"^40^2"           ; Occur. Span code - 2
 D WRT^ABMDF11W                             ; form locator #36b
 S ABMDE=ABMR(40,320)_"^43^6"           ; Occur. Span from date - 2
 D WRT^ABMDF11W                             ; form locator #36b
 S ABMDE=ABMR(40,330)_"^50^6"           ; Occur. Span thru date - 2
 D WRT^ABMDF11W                             ; form locator #36b
 S ABMDE=$E($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9),1,22)
 S:ABMDE'="" ABMDE=ABMDE_"^58^22"
 D WRT^ABMDF11W
 ;
12 ;
 ; If private insurance and relationship of policy holder to patient
 ; is not self, write name of policy holder
 W !
 S ABM38FLG=$P($G(^ABMDPARM(DUZ(2),1,2)),U,10)
 I ABM38FLG["P" D
 .I ABMP("ITYPE")="P" D
 ..N I
 ..S I=0
 ..F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D  ;insurer
 ...; insurer status = initiated
 ...I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I" D
 ....S ABME("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",1)
 ....S ABME("INSIEN")=I
 ..Q:'$G(ABME("INSIEN"))
 ..D PRVT^ABMERINS
 ..S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),2,"E"))_"^^40"  ;card name-policy holder
 ..S:($P(ABMDE,U)="") $P(ABMDE,U)=$G(ABM(9000003.1,+$G(ABME("PH")),.01,"E"))_"^^40"  ;name-policy holder
 ..D WRT^ABMDF11W   ;form locator 38
 ..Q
 ;
 I ABM38FLG["I" D
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
 .D WRT^ABMDF11W    ;form locator 38 line1
 ;
 I ABM38FLG["B"     ;if B it shouldn't do anything
 I $G(ABMORE)'="" D
 .D 13^ABMDF11Y
 Q:$G(ABMORE)
 ;
OTHER ;DO OTHER ROUTINES & QUIT
 D ^ABMDF11Y,^ABMDF11Z
 W $$EN^ABMVDF("IOF")
 K ABMR,ABMREC,ABM,ABME
 K ABMINM,ABMISTR,ABMICTY,ABMIST,ABMIZIP
 Q
 ;
TEST ;
 ; EP;Test forms allignment
 D TEST^ABMDF11W
 Q
