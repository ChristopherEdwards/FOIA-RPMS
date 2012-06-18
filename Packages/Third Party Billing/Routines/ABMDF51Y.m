ABMDF51Y ;IHS/DSD/DMJ/LSL - PRINT UB92      ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ; IHS/CAO/JLB 2/6/2000  added to CAO changes 
 ;
 ;IHS/DSD/LSL -3/23/98 - Add to line tag  18 to quit print if
 ;itemized for flat rate billing on a UB-92.
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM15936
 ;    Correct print format issues
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines being bundled by rev code
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM24315
 ;   Line items weren't printing
 ;   box 50 s/b O/P MEDI-CAL if AO CONTROL NUMBER is 61044
 ;
13 ;
 W !
 K ABMR
 S ABM("9SP")="         "
 N I
 F I=160:10:200 D
 .D @(I_"^ABMER41A")
 N I
 F I=210:10:390 D
 .D @(I_"^ABMER41")
 ; Policy holder street address
 S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),.09,"E"))_"^^40"
 D WRT^ABMDF11W                     ; form locator #38
 I ABMR(41,160) D
 .S ABMDE=ABMR(41,160)_"^43^2"     ; Value code 1
 .D WRT^ABMDF11W                   ; form locator #39a
 I ABMR(41,170) D
 .S ABMDE=+ABMR(41,170)_"^46^9R"   ; Value Amount 1
 .D WRT^ABMDF11W                   ; form locator #39a
 I ABMR(41,180)  D
 .S ABMDE=ABMR(41,180)_"^56^2"     ; Value code 2
 .D WRT^ABMDF11W                   ; form locator #40a
 I ABMR(41,190) D
 .S ABMDE=+ABMR(41,190)_"^59^9R"   ; Value amount 2
 .D WRT^ABMDF11W                   ; form locator #40a
 I ABMR(41,200) D
 .S ABMDE=ABMR(41,200)_"^69^2"     ; Value code 3
 .D WRT^ABMDF11W                   ; form locator #41a
 I ABMR(41,210) D
 .S ABMDE=+ABMR(41,210)_"^72^9R"   ; Value amount 3
 .D WRT^ABMDF11W                   ; form locator #41a
 ;
14 ;
 W !
 S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),.11,"E"))  ; Policy holders Address - City
 I $G(ABM(9000003.1,+$G(ABME("PH")),.12,"I")) D
 .S ABMPHST=$P(^DIC(5,ABM(9000003.1,ABME("PH"),.12,"I"),0),"^",2)  ; Policy holders Address - State
 .S ABMDE=ABMDE_", "_ABMPHST
 .Q
 S ABMDE=ABMDE_"  "_$G(ABM(9000003.1,+$G(ABME("PH")),.13,"E"))  ; add Policy holders zip
 I ABMDE'="" D
 .S ABMDE=ABMDE_"^^40"             ; Policy holders address
 .D WRT^ABMDF11W                   ; form locator #38
 I ABMR(41,220) D
 .S ABMDE=ABMR(41,220)_"^43^2"     ; Value code 4
 .D WRT^ABMDF11W                   ; form locator #39b
 I ABMR(41,230) D
 .S ABMDE=+ABMR(41,230)_"^46^9R"   ; Value amount 4
 .D WRT^ABMDF11W                   ; form locator #39b
 I ABMR(41,240) D
 .S ABMDE=ABMR(41,240)_"^56^2"     ; Value code 5
 .D WRT^ABMDF11W                   ; form locator #40b
 I ABMR(41,250) D
 .S ABMDE=+ABMR(41,250)_"^59^9R"   ; Value amount 5
 .D WRT^ABMDF11W                   ; form locator #40b
 I ABMR(41,260) D
 .S ABMDE=ABMR(41,260)_"^69^2"     ; Value code 6
 .D WRT^ABMDF11W                   ; form locator #41b
 I ABMR(41,270) D
 .S ABMDE=+ABMR(41,270)_"^72^9R"   ; Value amount 6
 .D WRT^ABMDF11W                   ; form locator #41b
 ;
15 ;
 W !
 K ABM
 I ABMR(41,280) D
 .S ABMDE=ABMR(41,280)_"^43^2"     ; Value code 7
 .D WRT^ABMDF11W                   ; form locator #39c
 I ABMR(41,290) D
 .S ABMDE=+ABMR(41,290)_"^46^9R"   ; Value amount 7
 .D WRT^ABMDF11W                   ; form locator #39c
 I ABMR(41,300) D
 .S ABMDE=ABMR(41,300)_"^56^2"     ; Value code 8
 .D WRT^ABMDF11W                   ; form locator #40c
 I ABMR(41,310) D
 .S ABMDE=+ABMR(41,310)_"^59^9R"   ; Value amount 8
 .D WRT^ABMDF11W                   ; form locator #40c
 I ABMR(41,320) D
 .S ABMDE=ABMR(41,320)_"^69^2"     ; Value code 9
 .D WRT^ABMDF11W                   ; form locator #41c
 I ABMR(41,330) D
 .S ABMDE=+ABMR(41,330)_"^72^9R"   ; Value amount 9
 .D WRT^ABMDF11W                   ; form locator #41c
 ;
16 ;
 W !
 I ABMR(41,340) D
 .S ABMDE=ABMR(41,340)_"^43^2"     ; Value code 10
 .D WRT^ABMDF11W                   ; form locator #39d
 I ABMR(41,350) D
 .S ABMDE=+ABMR(41,350)_"^46^9R"   ; Value amount 10
 .D WRT^ABMDF11W                   ; form locator #39d
 I ABMR(41,360) D
 .S ABMDE=ABMR(41,360)_"^56^2"     ; Value code 11
 .D WRT^ABMDF11W                   ; form locator #40d
 I ABMR(41,370) D
 .S ABMDE=+ABMR(41,370)_"^59^9R"   ; Value amount 11
 .D WRT^ABMDF11W                   ; form locator #40d
 I ABMR(41,380) D
 .S ABMDE=ABMR(41,380)_"^69^2"     ; Value code 12
 .D WRT^ABMDF11W                   ; form locator #41d
 I ABMR(41,390) D
 .S ABMDE=+ABMR(41,390)_"^72^9R"   ; Value amount 12
 .D WRT^ABMDF11W                   ; form locator #41d
 ;
18 ;
 ; Lines 18 - 40 on form (description area)
 ; ABMVR(IEN,code,counter) = IEN ^ Code ^ Modifier ^ 2nd Modifier ^ 
 ;                   Total units ^ Total charges ^ ^ Unit charge ^
 ;                   NDC name or description ^ date/time
 W !
 K ABMRV
 D ORV^ABMERGRV                     ; get other revenue codes
 D P1^ABMERGRV                      ; Build ABMVR of revenue codes
 ; Itemized UB-92 flag (1=yes, 0=no)
 S ABMITMZ=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,12)
 N I,J,L
 S I=0
 S (ABMCTR,ABMRV("ZZTOT"),ABMRV("NCTOT"))=0
 F  S I=$O(ABMRV(I)) Q:'I  D
 .S J=-1
 .F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ..S L=0
 ..F  S L=$O(ABMRV(I,J,L)) Q:+L=0  D
 ...; Grand total charges
 ...S:J'="ZZTOT" ABMRV("ZZTOT")=ABMRV("ZZTOT")+$P(ABMRV(I,J,L),U,6)
 ...; Grand total noncovered charges
 ...S:J'="ZZTOT" ABMRV("NCTOT")=ABMRV("NCTOT")+$P(ABMRV(I,J,L),U,7)
 ...; if not itemized bill and not done, accumulate totals
 ...I 'ABMITMZ,J'="ZZTOT" D
 ....S $P(ABMRV(I,"ZZTOT",1),U)=I   ; IEN to REVENUE CODE
 ....S:$D(ABMP("CPT")) $P(ABMRV(I,"ZZTOT",1),U,2)=ABMP("CPT")
 ....N K
 ....; Accumulate totals per revenue code
 ....F K=5:1:7 S $P(ABMRV(I,"ZZTOT",1),U,K)=$P(ABMRV(I,"ZZTOT",1),U,K)+$P(ABMRV(I,J,L),U,K)
 ....S $P(ABMRV(I,"ZZTOT",1),U,8)=$P(ABMRV(I,J,L),U,8)  ; unit charge
 ....Q
 ...I 'ABMITMZ,J'="ZZTOT" Q
 ...I ABMITMZ,J="ZZTOT" Q    ; If itemized and done, Q
 ...W !
 ...S ABMCTR=ABMCTR+1              ; Count items
 ...; If more than 22 items, complete bottom of form,
 ...; then start a new page
 ...I ABMCTR>22 D
 ....S ABMORE=1
 ....N I,J
 ....D 42
 ....D ^ABMDF51Z
 ....W $$EN^ABMVDF("IOF")
 ....N I,J
 ....D 1^ABMDF51X
 ....K ABMORE
 ....N I
 ....F I=1:1:12 W !
 ....S ABMCTR=1
 ....Q
 ...; If description is blank, get it from visit type in INSURER file
 ...I $P(ABMRV(I,J,L),U,9)="" D
 ....S ABMDE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,9)
 ....S:ABMDE="" ABMDE=$P($G(^AUTTREVN(I,0)),U,2)  ; standard abbreviation
 ....S ABMDE=ABMDE_"^5^24"        ; Description
 ....D WRT^ABMDF11W               ; form locator #43
 ....Q
 ...; If description, use it
 ...I $P(ABMRV(I,J,L),U,9)'="" D
 ....S ABMDE=$P(ABMRV(I,J,L),U,9)_"^5^24"  ; Description
 ....D WRT^ABMDF11W               ; form locator #43
 ....Q
 ...; HCPCS/rates -- form locator #44
 ...S ABMDE=$S($L($P(ABMRV(I,J,L),U,2))>3:$P(ABMRV(I,J,L),U,2)_$S($P(ABMRV(I,J,L),U,3)]"":"-"_$P(ABMRV(I,J,L),U,3),1:"")_"^30^9",$P(ABMRV(I,J,L),U,8):$J($P(ABMRV(I,J,L),U,8),1,2)_"^30^9R",1:"")
 ...D WRT^ABMDF11W
 ...S ABMDE=$$MDY^ABMDUTL(ABMP("VDT"))_"^40^6"
 ...D WRT^ABMDF11W                 ;form locator #45
 ...S ABMDE=$P(ABMRV(I,J,L),U,5)_"^47^7R"  ; Total units per item
 ...D WRT^ABMDF11W                 ; form locator #46
 ...S ABMDE=$FN($P(ABMRV(I,J,L),U,6),"T",2)
 ...S ABMDE=$TR(ABMDE,".")_"^55^10R"   ; Total charges per item
 ...D WRT^ABMDF11W                 ; form locator #47
 ...S ABMDE=$FN($P(ABMRV(I,J,L),U,7),"T",2)
 ...I +ABMDE D
 ....S ABMDE=$TR(ABMDE,".")_"^66^10R"  ; Total noncover charges per item
 ....D WRT^ABMDF11W               ; form locator #48
 ....Q
 F  W ! Q:$Y>39
 S ABMDE="0001 TOTAL^^10"
 D WRT^ABMDF11W
 S ABMDE=$TR($FN(ABMRV("ZZTOT"),"T",2),".")_"^55^10R"  ; Grand total
 D WRT^ABMDF11W                     ; last item in description section
 I +ABMRV("NCTOT") D
 .S ABMDE=$TR($FN(ABMRV("NCTOT"),"T",2),".")_"^66^10R"
 .D WRT^ABMDF11W                   ; Grand total - noncovered items
 .Q
 N I
 K ABMRV
 ;
42 ;
 ; Lines 42 - 44
 W !
 K ABMP("SET")
 D ^ABMER30                         ; get insurer and payment data
 N I
 F I=1:1:3 D
 .Q:'$D(ABMREC(30,I))
 .W ! S ABMFLAG=I
 .; Insurer name_" "_Payor Sub Identification
 .I $E(ABMREC(30,I),26,30)=61044 S ABMDE="O/P MEDI-CAL^^25"
 .E  S ABMDE=$E(ABMREC(30,I),54,78)_" "_$E(ABMREC(30,I),31,34)_"^^25"
 .D WRT^ABMDF11W                                 ; form locator #50
 .S ABMDE=$E(ABMREC(30,I),160,172)_"^26^13"  ; Provider ID (blank)
 .D WRT^ABMDF11W                             ; form locator #51
 .S ABMDE=$E(ABMREC(30,I),142)_"^40^1"       ; Release code
 .D WRT^ABMDF11W                             ; form locator #52
 .S ABMDE=$E(ABMREC(30,I),143)_"^43^1"       ; Ben Assgn Indicator
 .D WRT^ABMDF11W                             ; form locator #53
 .S ABMDE=+$E(ABMREC(30,I),173,182)_" ^45^10R"  ; 3PB pymnt recieve
 .I +ABMDE D WRT^ABMDF11W                    ; form locator #54
 .S ABMDE=+$E(ABMREC(30,I),183,192)_" ^56^10R"  ; Est 3PB amt due
 .I +ABMDE D WRT^ABMDF11W                    ; form locator #55
 W:'$G(ABMFLAG) !
 W !!
 K ABMR,ABMQUIT
 Q
