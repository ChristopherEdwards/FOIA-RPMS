ABMDF28U ; IHS/SD/SDR - PRINT UB-04 ;    
 ;;2.6;IHS Third Party Billing;**,20**;NOV 12, 2009;Build 317
 ;IHS/SD/SDR - 2.6*20 - HEAT262141 - Split routine from ABMDF28Y.  Added code for AHCCCS RX billing.  Will print detail lines for all meds,
 ;  but won't print the price, only the NDC, desc., date, and units.
 ;
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
 Q
PGTOT ;EP
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
 I DUZ(2)=4610,($$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")="EDS/CDP") S ABMDE=1124150891  ;abm*2.6*19 IHS/SD/SDR HEAT116949
 S ABMDE=ABMDE_"^68^15"
 D WRT^ABMDF28W
 Q
