ABMDF28V ; IHS/SD/SDR - PRINT UB-04 ;    
 ;;2.6;IHS Third Party Billing;**11,14,19**;NOV 12, 2009;Build 300
 ;IHS/SD/SDR - 2.6*19 - HEAT116949 - updated check for Medi-Cal to contain (not equal) 61044
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
 ; Policy holder street addr
 ;start new abm*2.6*2 FIXPMS10028
 I ABM38FLG="P" D
 .I "^P^H^F^M^"[("^"_ABMP("ITYPE")_"^") D
 ..S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),.09,"E"))_"^^40"
 ..D WRT^ABMDF28W  ;FL #38
 .;MCR or MCD - pt addr
 .I "^R^MD^MH^D^K^"[("^"_ABMP("ITYPE")_"^") D
 ..S ABMISTR=$G(ABME("AD1"))
 ..S ABMDE=ABMISTR_"^^40"
 ..D WRT^ABMDF28W   ;FL #38
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMISTR=$G(ABME("AD1"))
 ..S ABMDE=ABMISTR_"^^40"
 ..D WRT^ABMDF28W
 .;end new FIXPMS10028
 I ABM38FLG["I" D
 .;start new abm*2.6*1 HEAT7998
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMISTR=$G(ABME("AD1"))
 ..S ABMDE=ABMISTR_"^^40"
 ..D WRT^ABMDF28W
 .;end new HEAT7998
 .S ABMDE=ABMISTR_"^^40"
 .D WRT^ABMDF28W
 ;
 I ABMR(41,160)'="" D
 .S ABMDE=ABMR(41,160)_"^43^2"  ;Value code 1
 .D WRT^ABMDF28W  ;FL #39a
 I ($TR(ABMR(41,170)," ",""))'="" D
 .I ABMR(41,160)="A0"!(ABMR(41,160)=80) S ABMDE=+ABMR(41,170)_"^46^7R"
 .E  S ABMDE=$FN(+ABMR(41,170),"",2)_"^46^9R"  ;Value Amt 1
 .D WRT^ABMDF28W  ;FL #39a
 ;
 I ABMR(41,180)'="" D
 .S ABMDE=ABMR(41,180)_"^56^2"  ;Value code 2
 .D WRT^ABMDF28W  ;FL #40a
 I ($TR(ABMR(41,190)," ",""))'="" D
 .I ABMR(41,180)="A0"!(ABMR(41,180)=80) S ABMDE=+ABMR(41,190)_"^59^7R"
 .E  S ABMDE=$FN(+ABMR(41,190),"",2)_"^59^9R"
 .D WRT^ABMDF28W  ;FL #40a
 ;
 I ABMR(41,200)'="" D
 .S ABMDE=ABMR(41,200)_"^69^2"  ;Value code 3
 .D WRT^ABMDF28W  ;FL #41a
 I ($TR(ABMR(41,210)," ",""))'="" D
 .I ABMR(41,200)="A0"!(ABMR(41,200)=80) S ABMDE=+ABMR(41,210)_"^72^7R"
 .E  S ABMDE=+ABMR(41,210)_"^72^9R"
 .D WRT^ABMDF28W  ;FL #41a
 Q
42 ;
 ;Lines 42 - 44
 K ABMP("SET")
 D ^ABMER30  ;get ins and pymt data
 N I
 F I=1:1:3 D  ;check for blank entries; if any, move others up
 .I '$D(ABMREC(30,I)) D
 ..S ABMREC(30,I)=$G(ABMREC(30,(I+1)))
 ..S ABMREC(31,I)=$G(ABMREC(31,(I+1)))
 F I=1:1:3 D
 .W !
 .;Q:'$D(ABMREC(30,I))  ;HEAT144755
 .Q:$TR(ABMREC(30,I),"")=""  ;HEAT144755
 .;Ins name_" "_Payor Sub ID
 .S ABMDE=$S($E(ABMREC(30,I),54,78)["RAILROAD":"RAILROAD MEDICARE",1:$E(ABMREC(30,I),54,78))_" "_$E(ABMREC(30,I),31,34)_"^^22"
 .;I $$RCID^ABMERUTL(+$G(ABMP("INS",I)))=61044 S ABMDE="O/P MEDI-CAL^^22"  ;abm*2.6*19 IHS/SD/SDR HEAT116949
 .I $$RCID^ABMERUTL(+$G(ABMP("INS",I)))["61044" S ABMDE="O/P MEDI-CAL^^22"  ;abm*2.6*19 IHS/SD/SDR HEAT116949
 .D WRT^ABMDF28W  ;FL #50
 .S ABMDE=$E(ABMREC(30,I),160,172)_"^23^15"  ; Provider ID (blank)
 .I $P($G(^AUTNINS(ABMP("INS"),0)),U)="IOWA MEDICAID" S ABMDE="^23^15"
 .D WRT^ABMDF28W   ;FL #51
 .S ABMDE=$E(ABMREC(30,I),142)_"^38^1"  ;Release code
 .D WRT^ABMDF28W   ;FL #52
 .S ABMDE=$E(ABMREC(30,I),143)_"^41^1"  ;Ben Assgn Indicator
 .D WRT^ABMDF28W   ;FL #53
 .S ABMDE=+$E(ABMREC(30,I),173,182)_" ^43^10R"  ;3PB pymt receive
 .I +ABMDE D WRT^ABMDF28W  ;FL #54
 .S ABMDE=+$E(ABMREC(30,I),183,192)_" ^55^10R"  ;Est 3PB amt due
 .I +ABMDE D WRT^ABMDF28W  ;FL #55
 .I I=1 D  ;other provider ID - FL #57
 ..S Y=$P($G(^ABMNINS(ABMP("LDFN"),+ABMP("INS",I),1,ABMP("VTYP"),0)),U,8)
 ..S:Y="" Y=$P($G(^AUTNINS(+ABMP("INS",I),15,ABMP("LDFN"),0)),U,2)
 ..S:Y="" Y=$TR($P($G(^AUTTLOC(DUZ(2),0)),U,18),"-")
 ..Q:$P($G(^AUTNINS(ABMP("INS"),0)),U)["VMBP"  ;abm*2.6*11 IHS/SD/AML 7/30/2013
 ..S ABMDE=Y_"^67^15"
 ..I $P($G(^AUTNINS(ABMP("INS"),0)),U)="IOWA MEDICAID" S ABMDE="^67^15"
 ..D WRT^ABMDF28W
 K ABMR
 Q
