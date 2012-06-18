ABME630 ; IHS/ASDST/DMJ - UB92 EMC RECORD 30 (Third Party Payor) ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;01/22/96 10:43 AM
 ;
 ; IHS/ASDS/DMJ - 01/23/01 - V2.4 Patch 3 - NOIS HQW-0101-100032
 ; Created routine to correct rejections for Medicare
 ;
START ;START HERE
 K ABMREC(30),ABMREC(31),ABME,ABM,ABMP("PAYED")
 K ABMP("SET")
 D SET^ABMERUTL,LOOP  ; get insurer data
 K ABME,ABM
 Q
 ;
LOOP ;FIRST LOOP
 ; Loop thru INS priorities
 S ABME("S#")=0
 F  S ABME("S#")=$O(ABMP("INS",ABME("S#"))) Q:'ABME("S#")  D
 .S ABME("INS")=+ABMP("INS",ABME("S#"))  ; Insurer IEN
 .S ABME("INSIEN")=$P(ABMP("INS",ABME("S#")),"^",3)  ; IEN to insurer multiple
 .S ABME("RTYPE")=30    ; record type
 .K ABMR(30),ABMR(31)
 .D ISET^ABMERINS       ; set INS priority
 .D LOOP2               ; Get data
 .D S90^ABMERUTL        ; Add 1 to record type counts (electronic)
 .D ^ABMER31            ; Get insured's data
 Q
 ;
LOOP2 ;LOOP HERE
 D ^ABME630A             ; Get insurance data
 F I=160:10:260 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),30,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(30,ABME("S#"))=$G(ABMREC(30,ABME("S#")))_ABMR(30,I)
 Q
 ;
160 ;EP - Release Code (SOURCE: FILE=9002274.4 FIELD=.74)
 ; form locator #52
 S ABME("FLD")=.74
 D DIQ1
 S ABMR(30,160)=ABM(9002274.4,ABMP("BDFN"),.74,"I")
 S ABMR(30,160)=$$FMT^ABMERUTL(ABMR(30,160),1)
 Q
 ;
170 ;EP - Benefits Assigned Indicator (SOURCE: FILE=9002274.4, FIELD=.75)
 ; form locator #53
 S ABME("FLD")=.75
 D DIQ1
 S ABMR(30,170)=ABM(9002274.4,ABMP("BDFN"),.75,"I")
 S ABMR(30,170)=$$FMT^ABMERUTL(ABMR(30,170),1)
 Q
 ;
180 ;EP - Patient's Relationship to Insured (SOURCE: FILE=, FIELD=)
 ; form locator #59
 I '$G(ABME("PH")) S ABMR(30,180)="01"
 I $G(ABME("PH")) S ABMR(30,180)=ABME("REL")
 S ABMR(30,180)=$$FMT^ABMERUTL(ABMR(30,180),"2NR")
 Q
 ;
190 ;EP - Employment Status Code (SOURCE: FILE=9000003.1, FIELD=.15)
 S ABMR(30,190)=""
 I $G(ABME("PPP")) D                   ; of patient
 .S ABME("FLD")=.21
 .D DIQ3
 .S ABMR(30,190)=$G(ABM(9000001,ABME("PPP"),.21,"I"))
 .Q
 I ABMR(30,190)="",$G(ABME("PH")) D    ; of policy holder
 .S ABME("FLD")=.15
 .D DIQ2
 .S ABMR(30,190)=$G(ABM(9000003.1,+ABME("PH"),.15,"I"))
 .Q
 S ABMR(30,190)=$$FMT^ABMERUTL(ABMR(30,190),1)
 Q
 ;
200 ;EP - Covered Days (SOURCE: FILE=9002274.4, FIELD=.73)
 ; form locator #7
 S ABME("FLD")=.73
 D DIQ1
 S ABMR(30,200)=ABM(9002274.4,ABMP("BDFN"),.73,"I")
 S ABMR(30,200)=$$FMT^ABMERUTL(ABMR(30,200),"3NR")
 Q
 ;
210 ;EP - Non-Covered Days (SOURCE: FILE=9002274.4 FIELD=.66)
 ; form locator #8
 S ABME("FLD")=.66
 D DIQ1
 S ABMR(30,210)=ABM(9002274.4,ABMP("BDFN"),.66,"I")
 S ABMR(30,210)=$$FMT^ABMERUTL(ABMR(30,210),"4NR")
 Q
 ;
220 ;EP - Coinsurance Days (SOURCE: FILE=9002274.4, FIELD=.67)
 ; form locator #9
 S ABME("FLD")=.67
 D DIQ1
 S ABMR(30,220)=ABM(9002274.4,ABMP("BDFN"),.67,"I")
 S ABMR(30,220)=$$FMT^ABMERUTL(ABMR(30,220),"3NR")
 Q
 ;
230 ;EP - Lifetime Reserve Days (SOURCE: FILE=9002274.4, FIELD=.68)
 ; form locator #10
 S ABME("FLD")=.68
 D DIQ1
 S ABMR(30,230)=ABM(9002274.4,ABMP("BDFN"),.68,"I")
 S ABMR(30,230)=$$FMT^ABMERUTL(ABMR(30,230),"3NR")
 Q
 ;
240 ;EP - Provider I.D. Number
 ; form locator #51
 S ABMR(30,240)=$P($G(^ABMNINS(ABMP("LDFN"),ABME("INS"),1,ABMP("VTYP"),0)),"^",8)
 S:ABMR(30,240)="" ABMR(30,240)=$P($G(^ABMNINS(DUZ(2),ABME("INS"),1,ABMP("VTYP"),0)),"^",8)
 S:ABMR(30,240)="" ABMR(30,240)=$P($G(^AUTNINS(ABME("INS"),39,ABMP("VTYP"),0)),"^",8)
 S:ABMR(30,240)="" ABMR(30,240)=$P($G(^AUTNINS(ABME("INS"),15,ABMP("LDFN"),0)),"^",2)
 I ABME("ITYPE")="R" D
 .S:ABMR(30,240)="" ABMR(30,240)=$P($G(^AUTTLOC(+ABMP("LDFN"),0)),"^",19)
 .S ABMR(30,240)=$TR(ABMR(30,240),"-")
 S ABMR(30,240)=$$FMT^ABMERUTL(ABMR(30,240),13)
 Q
 ;
250 ;EP - Third Party Payments Received (SOURCE: FILE= FIELD=)
 ; form locator #54
 I '$D(ABMP("PAYED")) D PAYED^ABMERUTL
 S ABMR(30,250)=+$G(ABMP("PAYED",ABME("INS")))
 ; If non-ben patient and Prepay amt
 I ABME("ITYPE")="N" S ABMR(30,250)=ABMR(30,250)+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",9)
 S ABMR(30,250)=$$FMT^ABMERUTL(ABMR(30,250),"10NRJ2")
 Q
 ;
260 ;EP - Estimated Third Party Amount Due (SOURCE: FILE= FIELD=)
 ; form locator #55
 I '$D(ABMP("PAYED")) D PAYED^ABMERUTL
 S ABMR(30,260)=""
 ; If INS and initiated status
 I ABME("INS")=ABMP("INS"),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABME("INSIEN"),0),"^",3)="I" D
 .S ABMR(30,260)=(+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U))
 S ABMR(30,260)=$$FMT^ABMERUTL(ABMR(30,260),"10NRJ2")
 Q
 ;
DIQ1 ;PULL BILL DATA VIA DIQ1
 Q:$D(ABM(9002274.4,ABMP("BDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".66;.67;.68;.73;.74;.75;.99"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ2 ;POLICY HOLDER INFORMATION
 Q:'$G(ABME("PH"))
 Q:$D(ABM(9000003.1,ABME("PH"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPN3PPH("
 S DA=ABME("PH")
 S DR=".02;.15"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ3 ;PATIENT IS INSURED    
 Q:$D(ABM(9000001,ABMP("PDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPNPAT("
 S DA=ABMP("PDFN")
 S DR=".21"
 D EN^DIQ1
 K DIQ
 Q
 ;
EX(ABMX,ABMY,ABMZ) ;EXTRINSIC FUNCTION HERE
 ;
 ;  INPUT:  ABMX = data element
 ;             Y = bill internal entry number
 ;          ABMZ = insurer
 ;
 ; OUTPUT:     Y = bill internal entry number
 ;
 S ABMP("BDFN")=ABMY
 D SET^ABMERUTL
 S ABME("INS")=ABMZ
 I '$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABME("INS"))) S Y="" Q Y
 S ABME("S#")=0
 D ISET^ABMERINS
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(30,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(30,ABMX),ABMX,ABMY,ABMZ,ABME,ABM
 Q Y
