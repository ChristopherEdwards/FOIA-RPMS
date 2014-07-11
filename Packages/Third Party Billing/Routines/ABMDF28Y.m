ABMDF28Y ; IHS/ASDST/DMJ - PRINT UB-04 ;    
 ;;2.6;IHS Third Party Billing;**1,2,4,6,9,10,11**;NOV 12, 2009;Build 133
 ;
13 ; EP
 D 13^ABMDF28V
14 ;
 W !
 I ABM38FLG="P" D
 .I "^P^H^F^M^"[("^"_ABMP("ITYPE")_"^") D
 ..S ABMDE=$G(ABM(9000003.1,+$G(ABME("PH")),.11,"E"))_", "_$G(ABM(9000003.1,+$G(ABME("PH")),.12,"E"))_" "_$G(ABM(9000003.1,+$G(ABME("PH")),.13,"E"))_"^^40"
 ..D WRT^ABMDF28W   ;FL 38
 .;MCR or MCD - patient addr
 .I "^R^MD^MH^D^K^"[("^"_ABMP("ITYPE")_"^") D
 ..S ABMDE=$G(ABME("AD4"))_", "_$G(ABME("AD5"))_"  "_$G(ABME("AD6"))_"^^40"
 ..D WRT^ABMDF28W   ;FL 38
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMDE=$G(ABME("AD4"))_", "_$G(ABME("AD5"))_"  "_$G(ABME("AD6"))_"^^40"
 ..D WRT^ABMDF28W
 I ABM38FLG["I" D
 .I ABMP("ITYPE")="N" D  Q
 ..S ABMDE=$G(ABME("AD4"))_", "_$G(ABME("AD5"))_"  "_$G(ABME("AD6"))_"^^40"
 ..D WRT^ABMDF28W
 .S ABMDE=ABMICTY_", "_$P($G(^DIC(5,ABMIST,0)),U,2)_"  "_ABMIZIP_"^^40"
 D WRT^ABMDF28W  ;FL #38
 ;
 I ABMR(41,220)'="" D
 .S ABMDE=ABMR(41,220)_"^43^2"  ;Value code 4
 .D WRT^ABMDF28W  ;FL #39b
 I ABMR(41,230) D
 .I ABMR(41,220)="A0" S ABMDE=+ABMR(41,230)_"^46^9"
 .E  S ABMDE=+ABMR(41,230)_"^46^9R"  ;Value amt 4
 .D WRT^ABMDF28W  ;FL #39b
 I ABMR(41,240)'="" D
 .S ABMDE=ABMR(41,240)_"^56^2"  ;Value code 5
 .D WRT^ABMDF28W  ;FL #40b
 I ABMR(41,250) D
 .I ABMR(41,240)="A0" S ABMDE=+ABMR(41,250)_"^59^9"
 .E  S ABMDE=+ABMR(41,250)_"^59^9R"  ;Value amt 5
 .D WRT^ABMDF28W  ;FL #40b
 I ABMR(41,260)'="" D
 .S ABMDE=ABMR(41,260)_"^69^2"  ;Value code 6
 .D WRT^ABMDF28W  ;FL #41b
 I ABMR(41,270) D
 .I ABMR(41,260)="A0" S ABMDE=+ABMR(41,270)_"^72^9"
 .E  S ABMDE=+ABMR(41,270)_"^72^9R"  ;Value amt 6
 .D WRT^ABMDF28W  ;FL #41b
 Q:$G(ABMORE)
15 ;
 W !
 K ABM
 I ABMR(41,280)'="" D
 .S ABMDE=ABMR(41,280)_"^43^2"  ;Value code 7
 .D WRT^ABMDF28W  ;FL #39c
 I ABMR(41,290) D
 .I ABMR(41,280)="A0" S ABMDE=+ABMR(41,290)_"^46^9"
 .E  S ABMDE=+ABMR(41,290)_"^46^9R"  ;Value amt 7
 .D WRT^ABMDF28W  ;FL #39c
 I ABMR(41,300)'="" D
 .S ABMDE=ABMR(41,300)_"^56^2"  ;Value code 8
 .D WRT^ABMDF28W  ;FL #40c
 I ABMR(41,310) D
 .I ABMR(41,300)="A0" S ABMDE=+ABMR(41,310)_"^59^9"
 .E  S ABMDE=+ABMR(41,310)_"^59^9R"  ;Value amt 8
 .D WRT^ABMDF28W   ;FL #40c
 I ABMR(41,320)'="" D
 .S ABMDE=ABMR(41,320)_"^69^2"  ;Value code 9
 .D WRT^ABMDF28W  ;FL #41c
 I ABMR(41,330) D
 .I ABMR(41,320)="A0" S ABMDE=+ABMR(41,330)_"^72^9"
 .E  S ABMDE=+ABMR(41,330)_"^72^9R"  ;Value amt 9
 .D WRT^ABMDF28W  ;FL #41c
16 ;
 W !
 I ABMR(41,340)'="" D
 .S ABMDE=ABMR(41,340)_"^43^2"  ;Value code 10
 .D WRT^ABMDF28W  ;FL #39d
 I ABMR(41,350) D
 .I ABMR(41,340)="A0" S ABMDE=+ABMR(41,350)_"^46^9"
 .E  S ABMDE=+ABMR(41,350)_"^46^9R"  ;Value amt 10
 .D WRT^ABMDF28W  ;FL #39d
 ;
 I ABMR(41,360)'="" D
 .S ABMDE=ABMR(41,360)_"^56^2"  ;Value code 11
 .D WRT^ABMDF28W  ;FL #40d
 I ABMR(41,370) D
 .I ABMR(41,360)="A0" S ABMDE=+ABMR(41,370)_"^59^9"
 .E  S ABMDE=+ABMR(41,370)_"^59^9R"  ;Value amt 11
 .D WRT^ABMDF28W  ;FL #40d
 ;
 I ABMR(41,380)'="" D
 .S ABMDE=ABMR(41,380)_"^69^2"  ;Value code 12
 .D WRT^ABMDF28W  ;FL #41d
 I ABMR(41,390) D
 .I ABMR(41,380)="A0" S ABMDE=+ABMR(41,390)_"^72^9"
 .E  S ABMDE=+ABMR(41,390)_"^72^9R"  ;Value amt 12
 .D WRT^ABMDF28W  ;FL #41d
18 ;
 ; Lines 18 - 40 on form (desc area)
 ; ABMVR(IEN,code,counter) = IEN ^ Code ^ Modifier ^ 2nd Modifier ^ 
 ;     Total units ^ Total charges ^ ^ Unit charge ^ NDC name or desc ^ date/time
 W !
 K ABMRV
 D ORV^ABMERGRV  ;get other rev codes
 D P1^ABMERGRV   ;Build ABMVR of rev codes
 ;Itemized UB-92 flag (1=yes, 0=no)
 S ABMITMZ=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",12)
 K I,J,L
 ;start new abm*2.6*9 HEAT18507
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,26)="Y" D
 .S I=0
 .F  S I=$O(ABMRV(I)) Q:'I  D
 ..S J=-1
 ..F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ...S K=0
 ...F  S K=$O(ABMRV(I,J,K)) Q:'K  D
 ....Q:$P(ABMRV(I,J,K),U,9)=""
 ....S L=K+.5
 ....S $P(ABMRV(I,J,L),U,9)=$P($P(ABMRV(I,J,K),U,9)," ",2,$L(ABMRV(I,J,K)," "))
 ....S $P(ABMRV(I,J,K),U,9)=$P($P(ABMRV(I,J,K),U,9)," ")
 ....S K=L
 ;end new HEAT18507
 S I=0
 ;cnt all lines for page numbering
 S ABMLCNT=0
 F  S I=$O(ABMRV(I)) Q:'I  D
 .I 'ABMITMZ S ABMLCNT=ABMLCNT+1 Q
 .S J=-1
 .F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ..S L=0
 ..F  S L=$O(ABMRV(I,J,L)) Q:+L=0  D
 ...S ABMLCNT=ABMLCNT+1
 S ABMPGTOT=ABMLCNT/22  ;# of pages
 I $P(ABMPGTOT,".",2)>0 S ABMPGTOT=(ABMPGTOT\1)+1
 K ABMLCNT
 ;start new code abm*2.6*11 HEAT91321
 ;I +$G(ABMCDNUM)'=0,($$GET1^DIQ(9000004,ABMCDNUM,".11","E")["IOWA MEDICAID") D
 .K I,J,L
 .S I=0
 .S ABMFND=0
 .F  S I=$O(ABMRV(I)) Q:'I  D  Q:ABMFND=1
 ..S J=" "
 ..F  S J=$O(ABMRV(I,J)) Q:($G(J)="")  D  Q:ABMFND=1
 ...I J="T1015" D  K ABMRV(I,J)
 ....S L=0
 ....F  S L=$O(ABMRV(I,J,L)) Q:'L  D
 .....I $P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)["EPSDT",(+$P($G(ABMRV(I,J,L)),U,2)=0) D
 .....S $P(ABMRV(I,J,L),U,9)="OUTPATIENT CLINIC"
 .....S:J'="ZZTOT" ABMRV("ZZTOT")=ABMRV("ZZTOT")+$P(ABMRV(I,J,L),U,6)
 .....; Grand tot noncovered chgs
 .....S:J'="ZZTOT" ABMRV("NCTOT")=ABMRV("NCTOT")+$P(ABMRV(I,J,L),U,7)
 .....;if not itemized bill & not done, accumulate tots
 .....I 'ABMITMZ,J'="ZZTOT" D
 ......S $P(ABMRV(I,"ZZTOT",1),U)=I   ;IEN to REVENUE CODE
 ......S:$D(ABMP("CPT")) $P(ABMRV(I,"ZZTOT",1),"^",2)=ABMP("CPT")  ;CPT code
 ......N K
 ......;Accumulate tots per rev code
 ......F K=5:1:7 S $P(ABMRV(I,"ZZTOT",1),U,K)=$P(ABMRV(I,"ZZTOT",1),U,K)+$P(ABMRV(I,J,L),U,K)
 ......S $P(ABMRV(I,"ZZTOT",1),U,8)=$P(ABMRV(I,J,L),U,8)  ;unit chg
 ......S $P(ABMRV(I,"ZZTOT",1),U,3)=$P(ABMRV(I,J,L),U,3)
 .....I 'ABMITMZ,J'="ZZTOT" Q
 .....I ABMITMZ,J="ZZTOT" Q    ;If itemized & done, Q
 .....W !
 .....S ABMCTR=ABMCTR+1  ;Cnt items
 .....S ABMDE=$$GETREV^ABMDUTL(I)_"^^4R"  ;Rev code
 .....I L["." S ABMDE=""  ;abm*2.6*9 HEAT18507
 .....I $$RCID^ABMERUTL(ABMP("INS"))'=61004!((ABMP("VDT")>3100630)&($P($G(^AUTNINS(ABMP("INS"),0)),U)="EAPC")) D WRT^ABMDF28W  ;FL #42  ;abm*2.6*4 HEAT12271
 .....; If desc is blank, get it from vtyp in INS file
 .....I $P(ABMRV(I,J,L),U,9)="" D
 ......S ABMDE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,9)
 ......S:ABMDE="" ABMDE=$P($G(^AUTTREVN(I,0)),U,2)  ;std abbrev
 ......S ABMDE=ABMDE_"^5^24"  ;Desc
 ......D WRT^ABMDF28W   ;FL #43
 .....; If desc, use it
 .....I $P(ABMRV(I,J,L),U,9)'="" D
 ......S ABMDE=$P(ABMRV(I,J,L),U,9)_"^5^24"  ;Desc
 ......D WRT^ABMDF28W  ;FL #43
 .....; HCPCS/rates--FL #44
 .....S ABMMODL=$S($P(ABMRV(I,J,L),U,3)]"":$P(ABMRV(I,J,L),U,3),1:"")
 .....S ABMMODL=ABMMODL_$S($P(ABMRV(I,J,L),U,4)]"":$P(ABMRV(I,J,L),U,4),1:"")
 .....S ABMMODL=ABMMODL_$S($P(ABMRV(I,J,L),U,12)]"":$P(ABMRV(I,J,L),U,12),1:"")
 .....S ABMDE=$S($L($P(ABMRV(I,J,L),U,2))>3:$P(ABMRV(I,J,L),U,2)_ABMMODL_"^30^14",$P(ABMRV(I,J,L),U,8)&(+$P(ABMRV(I,J,L),U,2)'=0):$J($P(ABMRV(I,J,L),U,8),1,2)_"^30^14R",+ABMMODL:$J(ABMMODL,1,2)_"^30^14",1:"")
 .....I $P($G(ABMRV(I,J,L)),U,14)'="",($P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,24)="Y") S ABMDE="RX"_$P(ABMRV(I,J,L),U,14)_"^30^9"
 .....I ABMDE=""&($D(ABMP("FLAT"))!((I>99)&(I<250))) S ABMDE=$J($S($D(ABMP("FLAT")):$P(ABMP("FLAT"),U),1:$P(ABMRV(I,J,L),U,8)),1,2)_"^30^14"  ;default flat rate  ;new
 .....;start new abm*2.6*10 HEAT68319
 .....;I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,9)="A" D  ;abm*2.6*11 HEAT102837
 .....;.S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)  ;Dent remap
 .....;.S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .....;.S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .....;.I +$O(^AUTTADA("B",+$P(ABMDE,U),0))=0 Q  ;abm*2.6*11 HEAT102837
 .....;.S:ABMDENP]"" $P(ABMDE,U)=ABMDENP_$P(ABMDE,U)
 .....;end new HEAT68319
 .....D WRT^ABMDF28W
 .....S ABMDE=$$MDY^ABMDUTL($P(ABMRV(I,J,L),U,10))_"^45^6" ;DOS
 .....D WRT^ABMDF28W  ;FL #45
 .....S ABMDE=$P(ABMRV(I,J,L),U,5)_"^52^7R"  ; Tot units/item
 .....D WRT^ABMDF28W  ;FL #46
 .....S ABMDE=$FN($P(ABMRV(I,J,L),U,6),"T",2)
 .....S ABMDE=$TR(ABMDE,".")_"^61^9R"  ;Tot chg per item
 .....I L["." S ABMDE=""  ;abm*2.6*9 HEAT18507
 .....D WRT^ABMDF28W  ;FL #47
 .....S ABMDE=$FN($P(ABMRV(I,J,L),U,7),"T",2)
 .....I +ABMDE D
 ......S ABMDE=$TR(ABMDE,".")_"^71^9R"  ;Tot noncover chgs/item
 ......D WRT^ABMDF28W  ;FL #48
 ....S ABMFND=1
 ;end new code HEAT91321
 K I,J,L
 S I=0
 ;
 S (ABMCTR,ABMRV("ZZTOT"),ABMRV("NCTOT"))=0
 S ABMPGCNT=1
 F  S I=$O(ABMRV(I)) Q:'I  D
 .S J=-1
 .F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ..S L=0
 ..F  S L=$O(ABMRV(I,J,L)) Q:+L=0  D
 ...; Grand tot chgs
 ...I $P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)["EPSDT",(+$P($G(ABMRV(I,J,L)),U,2)=0) D
 ....S $P(ABMRV(I,J,L),U,9)="OUTPATIENT CLINIC"
 ...S:J'="ZZTOT" ABMRV("ZZTOT")=ABMRV("ZZTOT")+$P(ABMRV(I,J,L),U,6)
 ...; Grand tot noncovered chgs
 ...S:J'="ZZTOT" ABMRV("NCTOT")=ABMRV("NCTOT")+$P(ABMRV(I,J,L),U,7)
 ...;if not itemized bill & not done, accumulate tots
 ...I 'ABMITMZ,J'="ZZTOT" D
 ....S $P(ABMRV(I,"ZZTOT",1),U)=I   ;IEN to REVENUE CODE
 ....S:$D(ABMP("CPT")) $P(ABMRV(I,"ZZTOT",1),"^",2)=ABMP("CPT")  ;CPT code
 ....N K
 ....;Accumulate tots per rev code
 ....F K=5:1:7 S $P(ABMRV(I,"ZZTOT",1),U,K)=$P(ABMRV(I,"ZZTOT",1),U,K)+$P(ABMRV(I,J,L),U,K)
 ....S $P(ABMRV(I,"ZZTOT",1),U,8)=$P(ABMRV(I,J,L),U,8)  ;unit chg
 ....S $P(ABMRV(I,"ZZTOT",1),U,3)=$P(ABMRV(I,J,L),U,3)
 ....Q
 ...I 'ABMITMZ,J'="ZZTOT" Q
 ...I ABMITMZ,J="ZZTOT" Q    ;If itemized & done, Q
 ...W !
 ...S ABMCTR=ABMCTR+1  ;Cnt items
 ...;If more than 22 items, complete bottom of form, start new page
 ...I ABMCTR>22 D
 ....S ABMORE=1
 ....S ABMDE=ABMPGCNT_"    "_ABMPGTOT_"^11^15"  ;page#
 ....D WRT^ABMDF28W  ;form locator #43
 ....;S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),1:DT))_"^45^20"  ;creation date  ;abm*2.6*4 HEAT17615  ;abm*2.6*11 HEAT81561
 ....S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),$G(ABMP("PRINTDT"))="A":$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,5),1:DT))_"^45^20"  ;create dt ;abm*2.6*11 HEAT81561
 ....D WRT^ABMDF28W
 ....W !
 ....S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ....S ABMDE=$S($P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U),1:"")  ;NPI - form locator #56
 ....S ABMDE=ABMDE_"^68^15"
 ....D WRT^ABMDF28W
 ....S ABMPGCNT=ABMPGCNT+1
 ....N I,J
 ....D 42
 ....D ^ABMDF28Z
 ....W $$EN^ABMVDF("IOF")
 ....N I,J
 ....D 1^ABMDF28X
 ....K ABMORE
 ....N I
 ....F I=1:1:4 W !
 ....S ABMCTR=1
 ....Q
 ...S ABMDE=$$GETREV^ABMDUTL(I)_"^^4R"  ;Rev code
 ...I L["." S ABMDE=""  ;abm*2.6*9 HEAT18507
 ...I $$RCID^ABMERUTL(ABMP("INS"))'=61004!((ABMP("VDT")>3100630)&($P($G(^AUTNINS(ABMP("INS"),0)),U)="EAPC")) D WRT^ABMDF28W  ;FL #42  ;abm*2.6*4 HEAT12271
 ...; If desc is blank, get it from vtyp in INS file
 ...I $P(ABMRV(I,J,L),U,9)="" D
 ....S ABMDE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,9)
 ....S:ABMDE="" ABMDE=$P($G(^AUTTREVN(I,0)),U,2)  ;std abbrev
 ....S ABMDE=ABMDE_"^5^24"  ;Desc
 ....D WRT^ABMDF28W   ;FL #43
 ....Q
 ...; If desc, use it
 ...I $P(ABMRV(I,J,L),U,9)'="" D
 ....S ABMDE=$P(ABMRV(I,J,L),U,9)_"^5^24"  ;Desc
 ....D WRT^ABMDF28W  ;FL #43
 ....Q
 ...; HCPCS/rates--FL #44
 ...S ABMMODL=$S($P(ABMRV(I,J,L),U,3)]"":$P(ABMRV(I,J,L),U,3),1:"")
 ...S ABMMODL=ABMMODL_$S($P(ABMRV(I,J,L),U,4)]"":$P(ABMRV(I,J,L),U,4),1:"")
 ...S ABMMODL=ABMMODL_$S($P(ABMRV(I,J,L),U,12)]"":$P(ABMRV(I,J,L),U,12),1:"")
 ...S ABMDE=$S($L($P(ABMRV(I,J,L),U,2))>3:$P(ABMRV(I,J,L),U,2)_ABMMODL_"^30^14",$P(ABMRV(I,J,L),U,8)&(+$P(ABMRV(I,J,L),U,2)'=0):$J($P(ABMRV(I,J,L),U,8),1,2)_"^30^14R",+ABMMODL:$J(ABMMODL,1,2)_"^30^14",1:"")
 ...I $P($G(ABMRV(I,J,L)),U,14)'="",($P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,24)="Y") S ABMDE="RX"_$P(ABMRV(I,J,L),U,14)_"^30^9"
 ...I ABMDE=""&($D(ABMP("FLAT"))!((I>99)&(I<250))) S ABMDE=$J($S($D(ABMP("FLAT")):$P(ABMP("FLAT"),U),1:$P(ABMRV(I,J,L),U,8)),1,2)_"^30^14"  ;default flat rate  ;new
 ...I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,20)="Y" S ABMDE="^^30^14"  ;abm*2.6*11 IHS/SD/AML HEAT92962
 ...;start new abm*2.6*10 HEAT68319
 ...;I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,9)="A" D
 ...;.S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)  ;Dent remap
 ...;.S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 ...;.S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 ...;.Q:+$G(ABMP("FLAT"))  ;abm*2.6*11 IHS/SD/AML HEAT92962
 ...;.S:ABMDENP]"" $P(ABMDE,U)=ABMDENP_$P(ABMDE,U)
 ...;end new HEAT68319
 ...D WRT^ABMDF28W
 ...S ABMDE=$$MDY^ABMDUTL($P(ABMRV(I,J,L),U,10))_"^45^6" ;DOS
 ...D WRT^ABMDF28W  ;FL #45
 ...S ABMDE=$P(ABMRV(I,J,L),U,5)_"^52^7R"  ; Tot units/item
 ...D WRT^ABMDF28W  ;FL #46
 ...S ABMDE=$FN($P(ABMRV(I,J,L),U,6),"T",2)
 ...S ABMDE=$TR(ABMDE,".")_"^61^9R"  ;Tot chg per item
 ...I L["." S ABMDE=""  ;abm*2.6*9 HEAT18507
 ...D WRT^ABMDF28W  ;FL #47
 ...S ABMDE=$FN($P(ABMRV(I,J,L),U,7),"T",2)
 ...I +ABMDE D
 ....S ABMDE=$TR(ABMDE,".")_"^71^9R"  ;Tot noncover chgs/item
 ....D WRT^ABMDF28W  ;FL #48
 ....Q
 ;
 F ABMCTR=ABMCTR:1:22 W !  ;get to line 23
 S ABMDE="0001 TOTAL^^4"
 D WRT^ABMDF28W
 ;page number
 S ABMDE=ABMPGCNT_"    "_ABMPGTOT_"^10^15"  ;page #
 D WRT^ABMDF28W  ;FL #43
 ;creation date
 ;S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),1:DT))_"^45^20"  ;abm*2.6*2 FIXPMS10006  ;abm*2.6*4 HEAT17615  ;abm*2.6*10 HEAT67219
 ;S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O"&(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7)'=0):$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),1:DT))_"^45^20"  ;abm*2.6*10 HEAT67219  ;abm*2.6*11 HEAT81561
 S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),$G(ABMP("PRINTDT"))="A":$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,5),1:DT))_"^45^20"  ;create dt ;abm*2.6*11 HEAT81561
 D WRT^ABMDF28W
 ;
 S ABMDE=$TR($FN(ABMRV("ZZTOT"),"T",2),".")_"^60^10R"  ;Grand tot
 D WRT^ABMDF28W  ;last item in desc section
 I +ABMRV("NCTOT") D
 .S ABMDE=$TR($FN(ABMRV("NCTOT"),"T",2),".")_"^69^10R"
 .D WRT^ABMDF28W  ;Grand tot-noncovered items
 .Q
 K ABMRV
 W !
 S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 S ABMDE=$S($P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U),1:"")  ;NPI-FL #56
 S ABMDE=ABMDE_"^68^15"
 D WRT^ABMDF28W
42 ;
 ;Lines 42 - 44
 D 42^ABMDF28V
 Q
