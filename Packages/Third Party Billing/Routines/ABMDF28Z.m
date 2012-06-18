ABMDF28Z ; IHS/ASDST/DMJ - PRINT UB-04 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**3,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM24881 - Form alignment changes
 ; IHS/SD/SDR - v2.5 p12 - IM25363 - Removed line 45 (not needed on this form)
 ; IHS/SD/SDR - v2.5 p12 - IM25551 - Made change for Medicare and visit type not 111
 ;   to not print FL74.  Also some old code due to routine size.
 ; IHS/SD/SDR - v2.5 p13 - POA changes - POA changes aren't documented due to routine size
 ; IHS/SD/SDR - abm*2.6*3 - POA changes - removed insurer type "R" check
 ;
45 ; ABMPAID = Primary + Secondary + Tertiary + Prepaid
 ; ABMPBAL = Gross amount - ABM("PAID")
 ; FL #57
 ;
47 ;
 W !
 N I
 F I=1:1:3 D
 .W !
 .Q:'$D(ABMREC(30,I))
 .S ABMDE=$E(ABMREC(30,I),111,130)  ; Insured's last name
 .S ABMDE=$TR(ABMDE," ")
 .I $E(ABMREC(30,I),131,139)]"" S ABMDE=ABMDE_","_$TR($E(ABMREC(30,I),131,139)," ")   ; Add First Name
 .I $E(ABMREC(30,I),140)]"" S ABMDE=ABMDE_" "_$E(ABMREC(30,I),140)   ; Add Middle Init
 .S ABMDE=ABMDE_"^^25"                  ; Insured's Name
 .D WRT^ABMDF28W                                ; FL #58
 .S ABMDE=$E(ABMREC(30,I),144,145)_"^26^2"  ; Pat relation to Ins
 .D WRT^ABMDF28W                                ; FL #59
 .S ABMDE=$E(ABMREC(30,I),35,53)_"^29^20"   ; Claim Certificate ID
 .D WRT^ABMDF28W                                ; FL #60
 .S ABMDE=$E(ABMREC(30,I),97,110)_"^49^14"  ; Insured Group Name
 .D WRT^ABMDF28W                                ; FL #61
 .S ABMDE=$E(ABMREC(30,I),80,96)_"^64^16"   ; Insurance Group Num
 .D WRT^ABMDF28W                                ; FL #62
51 ;
 W !
 N I
 F I=50:10:70 D
 .D @(I_"^ABMER40A")
 N I
 F I=1:1:3 D
 .W !
 .Q:'$D(ABMREC(30,I))
 .S ABMDE=ABMR(40,(10*I)+40)_"^^30"         ; Pro Auth #
 .D WRT^ABMDF28W                                ; FL #63
 .;Document Control Number for active ins
 .I $E(ABMREC(30,I),54,78)=$$FMT^ABMERUTL($P($G(^AUTNINS(ABMP("INS"),0)),U),25) D
 ..S ABMDE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)_"^30^26"
 ..D WRT^ABMDF28W                                ; FL #64
 .S ABMDE=$E(ABMREC(31,I),87,110)_"^57^20"  ; Employer name
 .D WRT^ABMDF28W                                ; FL #65
 .S ABMTMPDE=$E(ABMREC(31,I),129,143)       ; Employer city/state
 .S ABMDE=$P(ABMTMPDE," ",1)
 .N J
55 ;
 W !
 N I
 F I=40:10:120 D
 .D @(I_"^ABMER70A")
 N I
 F I=250,260,290,300 D
 .D @(I_"^ABMER70")
 S ABMDE=ABMR(70,40)_"^1^7"       ; Principle DX
 D WRT^ABMDF28W                      ; FL #67
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,40,"POA")'=1:$G(ABMR(70,40,"POA")),1:"")_"^8^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,50)_"^9^7"      ; Other DX 1
 D WRT^ABMDF28W                      ; FL #67a
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,50,"POA")'=1:$G(ABMR(70,50,"POA")),1:"")_"^16^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,60)_"^17^7"     ; Other DX 2
 D WRT^ABMDF28W                      ; FL #67b
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,60,"POA")'=1:$G(ABMR(70,60,"POA")),1:"")_"^24^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,70)_"^25^7"     ; Other DX 3
 D WRT^ABMDF28W                      ; FL #67c
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,70,"POA")'=1:$G(ABMR(70,70,"POA")),1:"")_"^32^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,80)_"^33^7"     ; Other DX 4
 D WRT^ABMDF28W                      ; FL #67d
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,80,"POA")'=1:$G(ABMR(70,80,"POA")),1:"")_"^40^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,90)_"^41^7"     ; Other DX 5
 D WRT^ABMDF28W                      ; FL #67e
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,90,"POA")'=1:$G(ABMR(70,90,"POA")),1:"")_"^48^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,100)_"^49^7"    ; Other DX 6
 D WRT^ABMDF28W                      ; FL #67f
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,100,"POA")'=1:$G(ABMR(70,100,"POA")),1:"")_"^56^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,110)_"^57^7"    ; Other DX 7
 D WRT^ABMDF28W                      ; FL #67g
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,110,"POA")'=1:$G(ABMR(70,110,"POA")),1:"")_"^64^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,120)_"^65^7"    ; Other DX 8
 D WRT^ABMDF28W                      ; FL #67h
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,120,"POA")'=1:$G(ABMR(70,120,"POA")),1:"")_"^72^1"
 D WRT^ABMDF28W  ; FL #67 POA
 F I=130:10:200 D
 .D @(I_"^ABMER70A")
 W !
 S ABMDE="9^^1"                ;DX Version Qualifier - always 9
 D WRT^ABMDF28W                                ; FL #66
 S ABMDE=ABMR(70,130)_"^1^7"      ; Other DX 9
 D WRT^ABMDF28W                      ; FL #67i
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,130,"POA")'=1:$G(ABMR(70,130,"POA")),1:"")_"^8^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,140)_"^9^7"     ; Other DX 10
 D WRT^ABMDF28W                      ; FL #67j
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,140,"POA")'=1:$G(ABMR(70,140,"POA")),1:"")_"^16^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,150)_"^17^7"     ; Other DX 11
 D WRT^ABMDF28W                      ; FL #67k
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,150,"POA")'=1:$G(ABMR(70,150,"POA")),1:"")_"^24^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,160)_"^25^7"     ; Other DX 12
 D WRT^ABMDF28W                      ; FL #67l
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,160,"POA")'=1:$G(ABMR(70,160,"POA")),1:"")_"^32^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,170)_"^33^7"     ; Other DX 13
 D WRT^ABMDF28W                      ; FL #67m
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,170,"POA")'=1:$G(ABMR(70,170,"POA")),1:"")_"^40^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,180)_"^41^7"    ; Other DX 14
 D WRT^ABMDF28W                      ; FL #67n
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,180,"POA")'=1:$G(ABMR(70,180,"POA")),1:"")_"^48^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,190)_"^49^7"    ; Other DX 15
 D WRT^ABMDF28W                      ; FL #67o
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,190,"POA")'=1:$G(ABMR(70,190,"POA")),1:"")_"^56^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,200)_"^57^7"    ; Other DX 16
 D WRT^ABMDF28W                      ; FL #67p
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,200,"POA")'=1:$G(ABMR(70,200,"POA")),1:"")_"^64^1"
 D WRT^ABMDF28W  ; FL #67 POA
 W !
 ;
 S ABMDE=ABMR(70,250)_"^4^7"    ; Admitting DX
 D WRT^ABMDF28W                      ; FL #69
 S ABMDE=ABMR(70,250)_"^17^7"    ; Pt Reason Dx
 D WRT^ABMDF28W                      ; FL #70
 ;
 S ABMDE=ABMR(70,260)_"^48^7"    ; Ext. cause of injury (1)
 D WRT^ABMDF28W                      ; FL #72
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,260,"POA")'=1:$G(ABMR(70,260,"POA")),1:"")_"^55^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,290)_"^56^7"    ; Ext. cause of injury (2)
 D WRT^ABMDF28W                      ; FL #72
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,290,"POA")'=1:$G(ABMR(70,290,"POA")),1:"")_"^63^1"
 D WRT^ABMDF28W  ; FL #67 POA
 S ABMDE=ABMR(70,300)_"^64^7"    ; Ext. cause of injury (3)
 D WRT^ABMDF28W                      ; FL #72
 ;I ABMP("ITYPE")="R" D
 S ABMDE=$S(ABMR(70,300,"POA")'=1:$G(ABMR(70,300,"POA")),1:"")_"^71^1"
 D WRT^ABMDF28W  ; FL #67 POA
 ;
56 ;
 W !
 D PROV^ABMDF28W
 ;Attending Provider
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .I $P(ABM("PRV",1),U,4)'="" D
 ..S ABMDE=$P($P(ABM("PRV",1),U,4),"#",2)_"^59^10"  ;NPI
 ..D WRT^ABMDF28W  ; FL #76
 .S ABMDE=$P($P(ABM("PRV",1),U,3),"#")_"^71^2"  ;ID qualifier
 .D WRT^ABMDF28W  ; FL #76
 .S ABMDE=$P($P(ABM("PRV",1),U,3),"#",2)_"^73^9"  ;ID
 .D WRT^ABMDF28W  ; FL #76
57 ;
 W !
 N I
 F I=130:10:240,270 D
 .D @(I_"^ABMER70")
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,9)'="N" D
 .S ABMDE=$TR(ABMR(70,130),".")_"^1^7"     ; Principle Procedure code
 .D WRT^ABMDF28W                      ; FL #74
 .S ABMDE=ABMR(70,140)_"^8^6"    ; Principle Procedure date
 .D WRT^ABMDF28W                      ; FL #74a
 .S ABMDE=$TR(ABMR(70,150),".")_"^15^7"    ; Other Procedure code - 1
 .D WRT^ABMDF28W                      ; FL #74b
 .S ABMDE=ABMR(70,160)_"^23^6"    ; Other Procedure date - 1
 .D WRT^ABMDF28W                      ; FL #74c
 .S ABMDE=$TR(ABMR(70,170),".")_"^30^7"    ; Other Procedure code - 2
 .D WRT^ABMDF28W                      ; FL #74d
 .S ABMDE=ABMR(70,180)_"^38^6"    ; Other Procedure date - 2
 .D WRT^ABMDF28W                      ; FL #74e
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .S ABMDE=$P($P(ABM("PRV",1),U),",")_"^53^15"  ;Attending provider name
 .D WRT^ABMDF28W  ; FL #76
 .S ABMDE=$P($P(ABM("PRV",1),U),",",2)_"^70^11"  ;Attending provider name
 .D WRT^ABMDF28W  ; FL #76
58 ;
 ; Secondary Provider License #
 W !
 ;Operating provider
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .I $D(ABM("PRV",2)) D
 ..I $P(ABM("PRV",2),U,4)'="" D
 ...S ABMDE=$P($P($G(ABM("PRV",2)),U,4),"#",2)_"^59^10"  ;NPI
 ...D WRT^ABMDF28W                      ; FL #77
 ..S ABMDE=$P($P(ABM("PRV",2),U,3),"#")_"^71^2"  ;ID qualifier
 ..D WRT^ABMDF28W  ; FL #77
 ..S ABMDE=$P($P(ABM("PRV",2),U,3),"#",2)_"^73^9"  ;ID
 ..D WRT^ABMDF28W  ; FL #77
 ;Operating provider-attending if Medical
 I $$RCID^ABMERUTL(ABMP("INS"))=61044 D
 .I $D(ABM("PRV",1)) D
 ..I $P(ABM("PRV",1),U,4)'="" D
 ...S ABMDE=$P($P($G(ABM("PRV",1)),U,4),"#",2)_"^59^10"  ;NPI
 ...D WRT^ABMDF28W                      ; FL #77
 ..S ABMDE=$P($P(ABM("PRV",1),U,3),"#")_"^71^2"  ;ID qualifier
 ..D WRT^ABMDF28W  ; FL #77
 ..S ABMDE=$P($P(ABM("PRV",1),U,3),"#",2)_"^73^9"  ;ID
 ..D WRT^ABMDF28W  ; FL #77
59 ;
 W !
 S ABMDE=ABMR(70,190)_"^2^7"     ; Other Procedure code - 3
 D WRT^ABMDF28W                      ; FL #81e
 S ABMDE=ABMR(70,200)_"^9^6"    ; Other Procedure date - 3
 D WRT^ABMDF28W                      ; FL #81f
 S ABMDE=ABMR(70,210)_"^16^7"    ; Other Procedure code - 4
 D WRT^ABMDF28W                      ; FL #81g
 S ABMDE=ABMR(70,220)_"^24^6"    ; Other Procedure date - 4
 D WRT^ABMDF28W                      ; FL #81h
 S ABMDE=ABMR(70,230)_"^31^7"    ; Other Procedure code - 5
 D WRT^ABMDF28W                      ; FL #81i
 S ABMDE=ABMR(70,240)_"^39^6"    ; Other Procedure date - 5
 D WRT^ABMDF28W                      ; FL #81j
 ;Operating Provider name
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .S ABMDE=$P($P($G(ABM("PRV",2)),U),",")_"^53^15"
 .D WRT^ABMDF28W                      ; FL #77
 .S ABMDE=$P($P($G(ABM("PRV",2)),U),",",2)_"^70^11"
 .D WRT^ABMDF28W                      ; FL #77
60 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,1,0))_"^^19"  ; remarks line 1
 D WRT^ABMDF28W                      ; FL #80
 ;
 ;If NM Medicaid add Taxonomy and qualifier
 ;I ($P($G(^AUTNINS(ABMP("INS"),0)),U)="NEW MEXICO MEDICAID")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="MEDICAID EXEMPT") D  ;abm*2.6*8 NOHEAT - ADD TAX FOR IA MCD ONLY
 I ($P($G(^AUTNINS(ABMP("INS"),0)),U)="NEW MEXICO MEDICAID")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="MEDICAID EXEMPT")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="IOWA MEDICAID") D  ;abm*2.6*8 NOHEAT - ADD TAX FOR IA MCD ONLY
 .S ABMDE="B3"_$$PTAX^ABMUTLF(ABMP("LDFN"))  ;taxonomy - form locator #81D
 .S ABMDE=ABMDE_"^26^15"
 .D WRT^ABMDF28W
 ;
 ;Other provider (1)
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .I $D(ABM("PRV",3)) D
 ..I $P(ABM("PRV",3),U,4)'="" D
 ...S ABMDE=$P($P($G(ABM("PRV",3)),U,4),"#")_"^55^2"  ;NPI qualifier
 ...D WRT^ABMDF28W                      ; FL #78
 ...S ABMDE=$P($P($G(ABM("PRV",3)),U,4),"#",2)_"^59^10"  ;NPI
 ...D WRT^ABMDF28W                      ; FL #78
 ..S ABMDE=$P($P(ABM("PRV",3),U,3),"#")_"^71^2"  ;ID qualifier
 ..D WRT^ABMDF28W  ; FL #78
 ..S ABMDE=$P($P(ABM("PRV",3),U,3),"#",2)_"^73^9"  ;ID
 ..D WRT^ABMDF28W  ; FL #78
61 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,2,0))_"^^24"  ; remarks line 2
 D WRT^ABMDF28W                      ; FL #80
 ;
 ;Other Provider name (1)
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .S ABMDE=$P($P($G(ABM("PRV",3)),U),",")_"^53^15"
 .D WRT^ABMDF28W                      ; FL #78
 .S ABMDE=$P($P($G(ABM("PRV",3)),U),",",2)_"^70^11"
 .D WRT^ABMDF28W                      ; FL #78
62 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,3,0))_"^^24"  ; remarks line 3
 D WRT^ABMDF28W                      ; FL #80
 ;
 ;Other provider (2)
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .I $D(ABM("PRV",4)) D
 ..I $P(ABM("PRV",4),U,4)'="" D
 ...S ABMDE=$P($P($G(ABM("PRV",4)),U,4),"#")_"^54^2"  ;NPI qualifier
 ...D WRT^ABMDF28W                      ; FL #79
 ...S ABMDE=$P($P($G(ABM("PRV",4)),U,4),"#",2)_"^57^10"  ;NPI
 ...D WRT^ABMDF28W                      ; FL #79
 ..S ABMDE=$P($P(ABM("PRV",4),U,3),"#")_"^70^2"  ;ID qualifier
 ..D WRT^ABMDF28W  ; FL #79
 ..S ABMDE=$P($P(ABM("PRV",4),U,3),"#",2)_"^72^9"  ;ID
 ..D WRT^ABMDF28W  ; FL #79
63 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,4,0))_"^^24"  ; remarks line 4
 D WRT^ABMDF28W                      ; FL #80
 ;
 ;Other Provider name (2)
 I $$RCID^ABMERUTL(ABMP("INS"))'=61044 D
 .S ABMDE=$P($P($G(ABM("PRV",4)),U),",")_"^53^15"
 .D WRT^ABMDF28W                      ; FL #79
 .S ABMDE=$P($P($G(ABM("PRV",4)),U),",",2)_"^69^11"
 .D WRT^ABMDF28W                      ; FL #79
 Q
